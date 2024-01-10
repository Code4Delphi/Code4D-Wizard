unit C4D.Wizard.Reopen.Model;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  C4D.Wizard.Reopen.Interfaces,
  C4D.Wizard.Types,
  C4D.Wizard.Consts;

type
  TC4DWizardReopenModel = class(TInterfacedObject, IC4DWizardReopenModel)
  private
    function GetIniFile: TIniFile;
  protected
    procedure WriteFilePathInIniFile(AFilePath: string;
      AFavorite: TC4DWizardFavorite;
      AC4DWizardFileNotification: TC4DWizardFileNotification = TC4DWizardFileNotification.None);
    function ReadFilePathInIniFile(AFilePath: string): TC4DWizardReopenData;
    procedure ReadIniFile(AProc: TProc<TC4DWizardReopenData>);
    function ReadIniFileIfExistGuidGroup(AGuidGroup: string): Boolean;
    procedure RemoveFilePathInIniFile(AFilePath: string);
    procedure EditDataInIniFile(AC4DWizardReopenData: TC4DWizardReopenData);
  public
    class function New: IC4DWizardReopenModel;
  end;

implementation

uses
  C4D.Wizard.Utils;

class function TC4DWizardReopenModel.New: IC4DWizardReopenModel;
begin
  Result := Self.Create;
end;

function TC4DWizardReopenModel.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniReopen);
end;

procedure TC4DWizardReopenModel.WriteFilePathInIniFile(AFilePath: string;
  AFavorite: TC4DWizardFavorite;
  AC4DWizardFileNotification: TC4DWizardFileNotification = TC4DWizardFileNotification.None);
var
  LIniFile: TIniFile;
  LFolderGit: string;
begin
  {LExtension := ExtractFileExt(AFilePath);
   if(LExtension <> '.dproj')and(LExtension  <> '.groupproj')then
   Exit;
   if(AFilePath.Contains('Embarcadero'))then
   begin
   if(AFilePath.Contains(TC4DConsts.C4D_PROJECT_GROUP1))
   or(AFilePath.Contains('Project1.dproj'))
   or(AFilePath.Contains('Package1.dproj'))
   then
   Exit;
   end;}

  LIniFile := Self.GetIniFile;
  try
    LIniFile.Writestring(AFilePath, TC4DConsts.REOPEN_INI_FilePath, AFilePath);
    LIniFile.Writestring(AFilePath, TC4DConsts.REOPEN_INI_Name, ExtractFileName(AFilePath));
    case(AFavorite)of
      TC4DWizardFavorite.Yes:
      LIniFile.WriteBool(AFilePath, TC4DConsts.REOPEN_INI_Favorite, True);
      TC4DWizardFavorite.No:
      LIniFile.WriteBool(AFilePath, TC4DConsts.REOPEN_INI_Favorite, False);
      else
      //SE NAO EH APENAS ALTERACAO DE FAVORITO, ADD DATA
      if(AC4DWizardFileNotification = TC4DWizardFileNotification.FileClosing)then
      begin
        if(LIniFile.ReadDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastOpen, 0) <= 0)then
          LIniFile.WriteDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastOpen, Now);

        LIniFile.WriteDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastClose, Now);
      end
      else
        LIniFile.WriteDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastOpen, Now)
    end;

    //CASO NAO INFORMADO AINDA E ENCONTRE A PASTA DO GIT, JA ADD
    if(LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_FolderGit, EmptyStr).Trim.ISEmpty)then
    begin
      LFolderGit := ExtractFilePath(AFilePath);
      LFolderGit := IncludeTrailingPathDelimiter(LFolderGit + TC4DConsts.NAME_FOLDER_GIT);
      if(DirectoryExists(LFolderGit))then
        LIniFile.Writestring(AFilePath, TC4DConsts.REOPEN_INI_FolderGit, LFolderGit)
    end;
  finally
    LIniFile.Free;
  end;
end;

function TC4DWizardReopenModel.ReadFilePathInIniFile(AFilePath: string): TC4DWizardReopenData;
var
  LIniFile: TIniFile;
begin
  if(AFilePath.Trim.ISEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    Result.Favorite := LIniFile.ReadBool(AFilePath, TC4DConsts.REOPEN_INI_Favorite, False);
    Result.Nickname := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_Nickname, '');
    Result.Name := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_Name, '');
    Result.LastOpen := LIniFile.ReadDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastOpen, 0);
    Result.LastClose := LIniFile.ReadDateTime(AFilePath, TC4DConsts.REOPEN_INI_LastClose, 0);
    Result.FilePath := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_FilePath, '');
    Result.Color := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_Color, 'clBlack');
    Result.FolderGit := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_FolderGit, '');
    Result.GuidGroup := LIniFile.Readstring(AFilePath, TC4DConsts.REOPEN_INI_GuidGroup, '');
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardReopenModel.ReadIniFile(AProc: TProc<TC4DWizardReopenData>);
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        LC4DWizardReopenData.Favorite := LIniFile.ReadBool(LSessaoStr, TC4DConsts.REOPEN_INI_Favorite, False);
        LC4DWizardReopenData.Nickname := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_Nickname, '');
        LC4DWizardReopenData.Name := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_Name, '');
        LC4DWizardReopenData.LastOpen := LIniFile.ReadDateTime(LSessaoStr, TC4DConsts.REOPEN_INI_LastOpen, 0);
        LC4DWizardReopenData.LastClose := LIniFile.ReadDateTime(LSessaoStr, TC4DConsts.REOPEN_INI_LastClose, 0);
        LC4DWizardReopenData.FilePath := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_FilePath, '');
        LC4DWizardReopenData.Color := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_Color, 'clBlack');
        LC4DWizardReopenData.FolderGit := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_FolderGit, '');
        LC4DWizardReopenData.GuidGroup := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_GuidGroup, '');
        AProc(LC4DWizardReopenData);
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

function TC4DWizardReopenModel.ReadIniFileIfExistGuidGroup(AGuidGroup: string): Boolean;
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
  LGuidGroup: string;
begin
  Result := False;

  if(AGuidGroup.Trim.ISEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        LGuidGroup := LIniFile.Readstring(LSessaoStr, TC4DConsts.REOPEN_INI_GuidGroup, '');
        if(LGuidGroup = AGuidGroup)then
          Exit(True);
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardReopenModel.RemoveFilePathInIniFile(AFilePath: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := Self.GetIniFile;
  try
    LIniFile.EraseSection(AFilePath);
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardReopenModel.EditDataInIniFile(AC4DWizardReopenData: TC4DWizardReopenData);
var
  LIniFile: TIniFile;
begin
  if(AC4DWizardReopenData.FilePath.Trim.ISEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('File path not informed.');

  LIniFile := Self.GetIniFile;
  try
    LIniFile.Writestring(AC4DWizardReopenData.FilePath, TC4DConsts.REOPEN_INI_Nickname, AC4DWizardReopenData.Nickname);
    LIniFile.Writestring(AC4DWizardReopenData.FilePath, TC4DConsts.REOPEN_INI_Color, AC4DWizardReopenData.Color);
    LIniFile.Writestring(AC4DWizardReopenData.FilePath, TC4DConsts.REOPEN_INI_FolderGit, AC4DWizardReopenData.FolderGit);
    LIniFile.Writestring(AC4DWizardReopenData.FilePath, TC4DConsts.REOPEN_INI_GuidGroup, AC4DWizardReopenData.GuidGroup);

    LIniFile.WriteBool(AC4DWizardReopenData.FilePath, TC4DConsts.REOPEN_INI_Favorite, AC4DWizardReopenData.Favorite);
  finally
    LIniFile.Free;
  end;
end;

end.
