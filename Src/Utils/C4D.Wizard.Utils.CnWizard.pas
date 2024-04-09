{******************************************************************************}
{ Unit Note:                                                                   }
{    This file is partly derived from CnPack For Delphi/C++Builder             }
{                                                                              }
{ Original author:                                                             }
{                       CnPack For Delphi/C++Builder                           }
{                     中国人自己的开放源码第三方开发包                         }
{                   (C)Copyright 2001-2023 CnPack 开发组                       }
{                      网站地址：http://www.cnpack.org                          }
{                       电子邮件：master@cnpack.org                             }
{******************************************************************************}

unit C4D.Wizard.Utils.CnWizard;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  Winapi.Windows,
  ToolsAPI,
  Vcl.Forms;

function CnOtaGetCurrentProject: IOTAProject;
function CnOtaGetProjectGroup: IOTAProjectGroup;
function QuerySvcs(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean;
function CnOtaGetProjectOutputDirectory(Project: IOTAProject): string;
function _CnExtractFileDir(const FileName: string): string;
function LinkPath(const Head, Tail: string): string;
function MakeDir(const Path: string): string;
function AddDirSuffix(const Dir: string): string;
function MakePath(const Dir: string): string;
function ReplaceToActualPath(const Path: string; Project: IOTAProject = nil): string;
function CnOtaGetActiveProjectOption(const Option: string; var Value: Variant): Boolean;
function CnOtaGetActiveProjectOptions(Project: IOTAProject = nil): IOTAProjectOptions;
function GetIdeRootDirectory: string;
function _CnExtractFilePath(const FileName: string): string;
function _CnChangeFileExt(const FileName, Extension: string): string;
function _CnExtractFileName(const FileName: string): string;
procedure ExploreFile(const AFile: string; ShowDir: Boolean = True);
procedure ExploreDir(const APath: string; ShowDir: Boolean = True);

implementation

const
  SCnIDEPathMacro = '$(DELPHI)';

function CnOtaGetCurrentProject: IOTAProject;
var
  IProjectGroup: IOTAProjectGroup;
begin
  IProjectGroup := CnOtaGetProjectGroup;
  if Assigned(IProjectGroup) then
  begin
    try
      // This raises exceptions in D5 with .bat projects active
      Result := IProjectGroup.ActiveProject;
      Exit;
    except
      ;
    end;
  end;
  Result := nil;
end;

function CnOtaGetProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  {$IFNDEF BDS}
  IModule: IOTAModule;
  I: Integer;
  {$ENDIF}
begin
  QuerySvcs(BorlandIDEServices, IOTAModuleServices, IModuleServices);
  {$IFDEF BDS}
  Result := IModuleServices.MainProjectGroup;
  {$ELSE}
  if IModuleServices <> nil then
    for I := 0 to IModuleServices.ModuleCount - 1 do
    begin
      IModule := IModuleServices.Modules[I];
      if Supports(IModule, IOTAProjectGroup, Result) then
        Exit;
    end;
  Result := nil;
  {$ENDIF}
end;

function QuerySvcs(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean;
begin
  Result := (Instance <> nil) and Supports(Instance, Intf, Inst);
end;

function _CnExtractFileDir(const FileName: string): string;
{$IFDEF DELPHIXE3_UP}
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  if (I > 1) and (FileName[I] = PathDelim) and
    (not IsDelimiter(PathDelim + DriveDelim, FileName, I-1)) then
    Dec(I);
  Result := Copy(FileName, 1, I);
end;
{$ELSE}

begin
  Result := ExtractFileDir(FileName);
end;
{$ENDIF}


function MakeDir(const Path: string): string;
begin
  Result := Trim(Path);
  if Result = '' then
    Exit;
  if CharInSet(Result[Length(Result)], ['/', '\']) then
    Delete(Result, Length(Result), 1);
end;

function AddDirSuffix(const Dir: string): string;
begin
  Result := Trim(Dir);
  if Result = '' then
    Exit;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF};
end;

// Ä¿Â¼Î²¼Ó'\'ÐÞÕý
function MakePath(const Dir: string): string;
begin
  Result := AddDirSuffix(Dir);
end;

function LinkPath(const Head, Tail: string): string;
var
  HeadIsUrl: Boolean;
  TailHasRoot: Boolean;
  TailIsRel: Boolean;
  AHead, ATail, S: string;
  UrlPos, I: Integer;
begin
  if Head = '' then
  begin
    Result := Tail;
    Exit;
  end;

  if Tail = '' then
  begin
    Result := Head;
    Exit;
  end;

  TailHasRoot := (AnsiPos(':\', Tail) = 2) or // C:\Test
    (AnsiPos('\\', Tail) = 1) or // \\Name\C\Test
    (AnsiPos('://', Tail) > 0); // ftp://ftp.abc.com
  if TailHasRoot then
  begin
    Result := Tail;
    Exit;
  end;

  UrlPos := AnsiPos('://', Head);
  HeadIsUrl := UrlPos > 0;
  AHead := StringReplace(Head, '/', '\', [rfReplaceAll]);
  ATail := StringReplace(Tail, '/', '\', [rfReplaceAll]);

  TailIsRel := ATail[1] = '\'; // Î²Â·¾¶ÊÇÏà¶ÔÂ·¾¶
  if TailIsRel then
  begin
    if AnsiPos(':\', AHead) = 2 then
      Result := AHead[1] + ':' + ATail
    else if AnsiPos('\\', AHead) = 1 then
    begin
      S := Copy(AHead, 3, MaxInt);
      I := AnsiPos('\', S);
      if I > 0 then
        Result := Copy(AHead, 1, I + 1) + ATail
      else
        Result := AHead + ATail;
    end
    else if HeadIsUrl then
    begin
      S := Copy(AHead, UrlPos + 3, MaxInt);
      I := AnsiPos('\', S);
      if I > 0 then
        Result := Copy(AHead, 1, I + UrlPos + 1) + ATail
      else
        Result := AHead + ATail;
    end
    else
    begin
      Result := Tail;
      Exit;
    end;
  end
  else
  begin
    if Copy(ATail, 1, 2) = '.\' then
      Delete(ATail, 1, 2);
    AHead := MakeDir(AHead);
    I := Pos('..\', ATail);
    while I > 0 do
    begin
      AHead := _CnExtractFileDir(AHead);
      Delete(ATail, 1, 3);
      I := Pos('..\', ATail);
    end;
    Result := MakePath(AHead) + ATail;
  end;

  if HeadIsUrl then
    Result := StringReplace(Result, '\', '/', [rfReplaceAll]);
end;

function ReplaceToActualPath(const Path: string; Project: IOTAProject = nil): string;
{$IFDEF COMPILER6_UP}
var
  Vars: TStringList;
  I: Integer;
  {$IFDEF DELPHI2011_UP}
  BC: IOTAProjectOptionsConfigurations;
  {$ENDIF}
begin
  Result := Path;
  Vars := TStringList.Create;
  try
    GetEnvironmentVars(Vars, True);
    for I := 0 to Vars.Count - 1 do
    begin
      {$IFDEF DELPHIXE6_UP}
      // There's a $(Platform) values '' in XE6, will make Platform Empty.
      if Trim(Vars.Values[Vars.Names[I]]) = '' then
        Continue;
      {$ENDIF}
      Result := StringReplace(Result, '$(' + Vars.Names[I] + ')',
        Vars.Values[Vars.Names[I]], [rfReplaceAll, rfIgnoreCase]);
    end;

    {$IFDEF DELPHI2011_UP}
    BC := CnOtaGetActiveProjectOptionsConfigurations(Project);
    if BC <> nil then
    begin
      if BC.GetActiveConfiguration <> nil then
      begin
        Result := StringReplace(Result, '$(Config)',
          BC.GetActiveConfiguration.GetName, [rfReplaceAll, rfIgnoreCase]);
        {$IFDEF DELPHI2012_UP}
        if BC.GetActiveConfiguration.GetPlatform <> '' then
        begin
          Result := StringReplace(Result, '$(Platform)',
            BC.GetActiveConfiguration.GetPlatform, [rfReplaceAll, rfIgnoreCase]);
        end
        else if Project <> nil then
        begin
          Result := StringReplace(Result, '$(Platform)',
            Project.CurrentPlatform, [rfReplaceAll, rfIgnoreCase]);
        end;
        {$ENDIF}
      end;
    end;
    {$ENDIF}
    if Project <> nil then
    begin
      Result := StringReplace(Result, '$(MSBuildProjectName)',
        _CnChangeFileExt(_CnExtractFileName(Project.FileName), ''),
        [rfReplaceAll, rfIgnoreCase]);
    end;
  finally
    Vars.Free;
  end;
end;
{$ELSE}

begin
  // Delphi5 ÏÂ²»Ö§³Ö»·¾³±äÁ¿
  Result := StringReplace(Path, SCnIDEPathMacro, MakeDir(GetIdeRootDirectory),
    [rfReplaceAll, rfIgnoreCase]);
end;
{$ENDIF}


function GetIdeRootDirectory: string;
begin
  Result := _CnExtractFilePath(_CnExtractFileDir(Application.ExeName));
end;

function _CnExtractFilePath(const FileName: string): string;
{$IFDEF DELPHIXE3_UP}
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, 1, I);
end;
{$ELSE}

begin
  Result := ExtractFilePath(FileName);
end;
{$ENDIF}


function CnOtaGetProjectOutputDirectory(Project: IOTAProject): string;
var
  Options: IOTAProjectOptions;
  ProjectDir: string;
  {$IFNDEF DELPHIXE_UP}
  Dir: Variant;
  OutputDir: string;
  {$ENDIF}
begin
  Result := '';
  if Project = nil then
    Project := CnOtaGetCurrentProject;
  if Project = nil then
    Exit;

  ProjectDir := _CnExtractFileDir(Project.FileName);
  Options := Project.ProjectOptions;

  {$IFDEF DELPHIXE_UP}  // XE ÒÔÉÏÖ±½Ó×ß TargetName£¬ÒªÑéÖ¤ÊÇ·ñºÍµ±Ç° Configuration µÄÄ¿Â¼Ò»ÖÂ
  if Options <> nil then
    Result := _CnExtractFilePath(Options.TargetName)
  else
    Result := ProjectDir;
  {$ELSE}
  if Options <> nil then
  begin
    Dir := Options.GetOptionValue('OutputDir');
    OutputDir := VarToStr(Dir);

    if OutputDir <> '' then // $(Config)/$(Platform) µÄÐÎÊ½£¬ÐèÒªÌæ»»
      Result := LinkPath(ProjectDir, ReplaceToActualPath(OutputDir));
  end;

  if Result = '' then
    Result := ProjectDir;
  {$ENDIF}
end;

function CnOtaGetActiveProjectOption(const Option: string; var Value: Variant): Boolean;
var
  ProjectOptions: IOTAProjectOptions;
begin
  Result := False;
  Value := '';
  ProjectOptions := CnOtaGetActiveProjectOptions;
  if Assigned(ProjectOptions) then
  begin
    Value := ProjectOptions.Values[Option];
    Result := True;
  end;
end;

function CnOtaGetActiveProjectOptions(Project: IOTAProject = nil): IOTAProjectOptions;
begin
  if Assigned(Project) then
  begin
    Result := Project.ProjectOptions;
    Exit;
  end;

  Project := CnOtaGetCurrentProject;
  if Assigned(Project) then
    Result := Project.ProjectOptions
  else
    Result := nil;
end;

function _CnChangeFileExt(const FileName, Extension: string): string;
{$IFDEF DELPHIXE3_UP}
var
  I: Integer;
begin
  I := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (I = 0) or (FileName[I] <> '.') then
    I := MaxInt;
  Result := Copy(FileName, 1, I - 1) + Extension;
end;
{$ELSE}

begin
  Result := ChangeFileExt(FileName, Extension);
end;
{$ENDIF}


function _CnExtractFileName(const FileName: string): string;
{$IFDEF DELPHIXE3_UP}
var
  I: Integer;
begin
  I := LastDelimiter(PathDelim + DriveDelim, FileName);
  Result := Copy(FileName, I + 1, MaxInt);
end;
{$ELSE}

begin
  Result := ExtractFileName(FileName);
end;
{$ENDIF}


procedure ExploreFile(const AFile: string; ShowDir: Boolean);
var
  strExecute: AnsiString;
begin
  if not ShowDir then
    strExecute := AnsiString(Format('EXPLORER.EXE /select, "%s"', [AFile]))
  else
    strExecute := AnsiString(Format('EXPLORER.EXE /e, /select, "%s"', [AFile]));
  WinExec(PAnsiChar(strExecute), SW_SHOWNORMAL);
end;

procedure ExploreDir(const APath: string; ShowDir: Boolean);
var
  strExecute: AnsiString;
begin
  if not ShowDir then
    strExecute := AnsiString(Format('EXPLORER.EXE "%s"', [APath]))
  else
    strExecute := AnsiString(Format('EXPLORER.EXE /e, "%s"', [APath]));
  WinExec(PAnsiChar(strExecute), SW_SHOWNORMAL);
end;

end.
