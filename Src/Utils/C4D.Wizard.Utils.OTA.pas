unit C4D.Wizard.Utils.OTA;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  ToolsAPI,
  C4D.Wizard.Types;

type
  TC4DWizardUtilsOTA = class
  private
    class function EditorAsString(AIOTAModule: IOTAModule): string;
    class procedure DoCloseFile(AInfoFile: TC4DWizardInfoFile);
  public
    class function CleanCurrentProject: Boolean;
    class function CurrentProjectIsC4DWizardDPROJ: Boolean;
    class function CurrentModuleIsReadOnly: Boolean;
    class procedure SaveAllModifiedModules;
    class procedure CloseFilesOpened(AC4DWizardExtensions: TC4DExtensionsOfFiles);
    class function AddImgIDEResourceName(AResourceName: string): Integer;
    class function AddImgIDEFilePath(AFilePath: string): Integer;
    class function EditorAsStringList(AIOTAModule: IOTAModule): TStringList;
    class procedure InsertBlockTextIntoEditor(const AText: string);
    class function OTAFileNotificationToC4DWizardFileNotification(AOTAFileNotification: TOTAFileNotification): TC4DWizardFileNotification;
    class procedure OpenFilePathInIDE(AFilePath: string);
    class procedure ShowFormProjectOptions;
    class function RefreshProject: Boolean;
    class function RefreshModule: Boolean;
    class procedure RefreshProjectOrModule;
    class function FileIsOpenInIDE(const APathFile: string): Boolean;
    class function CheckIfExistFileInCurrentsProjectGroups(const ANameFileWithExtension: string): Boolean;
    class procedure IDEThemingAll(AFormClass: TCustomFormClass; AForm: TForm);
    class function ActiveThemeColorDefaul: TColor;
    class function ActiveThemeIsDark: Boolean;
    class function GetIOTAFormEditor(const AIOTAModule: IOTAModule): IOTAFormEditor;
    {$IF CompilerVersion > 32} //Tokyo
    class function GetIOTAIDEThemingServices: IOTAIDEThemingServices;
    class function GetIOTAIDEThemingServices250: IOTAIDEThemingServices250;
    {$ENDIF}
    class function GetIOTACompileServices: IOTACompileServices;
    class function GetIOTAWizardServices: IOTAWizardServices;
    class function GetIOTAEditView(AIOTAModule: IOTAModule): IOTAEditView; overload;
    class function GetIOTAEditView(AIOTASourceEditor: IOTASourceEditor): IOTAEditView; overload;
    ///<summary> Get the active source editor (Tab selected in editor) </summary>
    class function GetIOTASourceEditor(AIOTAModule: IOTAModule): IOTASourceEditor; overload;
    ///<summary> Get the active source editor (Tab selected in editor) </summary>
    class function GetIOTASourceEditor(AIOTAEditor: IOTAEditor): IOTASourceEditor; overload;
    ///<summary> Get the active source editor (Tab selected in editor) </summary>
    class function GetIOTASourceEditor(AIOTAModule: IOTAModule; const AFileName: string): IOTASourceEditor; overload;
    class function GetIOTAEditBufferCurrentModule: IOTAEditBuffer;
    class function GetIOTAEditBuffer(AIOTAModule: IOTAModule): IOTAEditBuffer;
    class function GetIOTAMessageServices: IOTAMessageServices;
    class function GetIOTAProjectManager: IOTAProjectManager;
    class function GetIOTAKeyboardServices: IOTAKeyboardServices;
    class function GetIOTAServices: IOTAServices;
    class function GetIOTAActionServices: IOTAActionServices;
    class function GetINTAServices: INTAServices;
    class function GetIOTAModuleServices: IOTAModuleServices;
    class function GetIOTAEditorServices: IOTAEditorServices;
    class function GetBlockTextSelect: string;
    class function GetCurrentModule: IOTAModule;
    class function GetCurrentModuleFileName: string;
    class function GetModule(const AFileName: string): IOTAModule;
    class function GetCurrentProjectGroup: IOTAProjectGroup;
    class function GetCurrentProject: IOTAProject;
    class function GetCurrentProjectFileName: string;
    class function GetProjectName(const AIOTAProject: IOTAProject): string;
    class function GetFileNameDprOrDpkIfDproj(const AIOTAModule: IOTAModule): string;
    class function GetCurrentProjectOptions: IOTAProjectOptions;
    class function GetCurrentOutputDir: string;
    class function GetCurrentProjectOptionsConfigurations: IOTAProjectOptionsConfigurations;
    class function GetBinaryPath(AIOTAProject: IOTAProject): string;
    class procedure OpenBinaryPath(AIOTAProject: IOTAProject);
    class function GetBinaryPathCurrent: string;
    class procedure OpenBinaryPathCurrent;
    class function GetPathsFilesOpened: TList<string>;
    class procedure GetAllFilesFromProjectGroup(AListFiles: TStrings;
      const AFilePathProjectOrGroupForFilter: string;
      const AC4DWizardExtensions: TC4DExtensionsOfFiles);
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.LogFile,
  C4D.Wizard.Model.Files.Loop,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA.BinaryPath,
  C4D.Wizard.Utils.OTA.Codex;

class function TC4DWizardUtilsOTA.CleanCurrentProject: Boolean;
begin
  Result := TC4DWizardUtilsOTACodex.ExecuteIDEAction(TC4DConsts.COMMAND_ProjectCleanCommand);
end;

class function TC4DWizardUtilsOTA.CurrentProjectIsC4DWizardDPROJ: Boolean;
var
  LIOTAProject: IOTAProject;
begin
  Result := False;

  LIOTAProject := Self.GetCurrentProject;
  if(LIOTAProject = nil)then
    Exit;

  Result := TC4DWizardUtils.FileNameIsC4DWizardDPROJ(LIOTAProject.FileName);
end;

class function TC4DWizardUtilsOTA.CurrentModuleIsReadOnly: Boolean;
var
  LIOTAEditBuffer: IOTAEditBuffer;
begin
  Result := False;

  LIOTAEditBuffer := Self.GetIOTAEditBufferCurrentModule;
  if(LIOTAEditBuffer = nil)then
    Exit;

  Result := LIOTAEditBuffer.IsReadOnly;
end;

class procedure TC4DWizardUtilsOTA.SaveAllModifiedModules;
var
  LIOTAModuleServices: IOTAModuleServices;
  I: Integer;
  LIOTAModule: IOTAModule;
  LIOTAEditor: IOTAEditor;
begin
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  for I := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.Modules[I];
    LIOTAEditor := LIOTAModule.CurrentEditor;
    if LIOTAEditor = nil then
      continue;

    if LIOTAEditor.Modified then
      LIOTAModule.Save(False, True);
  end;
end;

class procedure TC4DWizardUtilsOTA.CloseFilesOpened(AC4DWizardExtensions: TC4DExtensionsOfFiles);
begin
  TC4DWizardModelFilesLoop.New
    .Extensions(AC4DWizardExtensions)
    .Escope(TC4DWizardEscope.FilesOpened)
    .LoopInFiles(Self.DoCloseFile);
end;

class procedure TC4DWizardUtilsOTA.DoCloseFile(AInfoFile: TC4DWizardInfoFile);
begin
  if(FileExists(AInfoFile.Path))then
    Self.GetIOTAActionServices.CloseFile(AInfoFile.Path);
end;

class function TC4DWizardUtilsOTA.AddImgIDEResourceName(AResourceName: string): Integer;
var
  LBitmap: TBitmap;
  LMaskColor: TColor;
begin
  Result := -1;
  if(FindResource(HInstance, PChar(AResourceName), RT_BITMAP) <= 0)then
    Exit;

  LBitmap := TBitmap.Create;
  try
    try
      LBitmap.LoadFromResourceName(HInstance, AResourceName);
      {$IF CompilerVersion = 35} //Alexandria
        LMaskColor := clLime;
      {$ELSE}
        LMaskColor := LBitmap.TransparentColor;
      {$ENDIF}
      Result := TC4DWizardUtilsOTA.GetINTAServices.AddMasked(LBitmap, LMaskColor); //, AResourceName
    except
      on E: Exception do
        LogFile
          .AddLog('Erro em TC4DWizardUtilsOTA.AddImgIDEResourceName')
          .AddLog('  AResourceName: ' + AResourceName)
          .AddLog('  Message: ' + E.Message);
    end;
  finally
    LBitmap.Free;
  end;
end;

class function TC4DWizardUtilsOTA.AddImgIDEFilePath(AFilePath: string): Integer;
var
  LBitmap: TBitmap;
  LMaskColor: TColor;
begin
  Result := -1;
  LBitmap := TBitmap.Create;
  try
    try
      LBitmap.LoadFromFile(AFilePath);
      {$IF CompilerVersion = 35} //Alexandria
        LMaskColor := clLime;
      {$ELSE}
        LMaskColor := LBitmap.TransparentColor;
      {$ENDIF}
      Result := TC4DWizardUtilsOTA.GetINTAServices.AddMasked(LBitmap, LMaskColor); // AFilePath
    except
      on E: Exception do
        LogFile
          .AddLog('Erro em TC4DWizardUtilsOTA.AddImgIDEFilePath')
          .AddLog('  AFilePath: ' + AFilePath)
          .AddLog('  Message: ' + E.Message);
    end;
  finally
    LBitmap.Free;
  end;
end;

class function TC4DWizardUtilsOTA.EditorAsStringList(AIOTAModule: IOTAModule): TStringList;
begin
  Result := TStringList.Create;
  try
    Result.Text := Self.EditorAsString(AIOTAModule);
  except
    Result.Free;
    raise;
  end;
end;

class function TC4DWizardUtilsOTA.EditorAsString(AIOTAModule: IOTAModule): string;
const
  BUFFER_SIZE: Integer = 1024;
var
  LIOTAEditReader: IOTAEditReader;
  LRead: Integer;
  LPosition: Integer;
  LStrBuffer: AnsiString;
begin
  Result := '';
  LIOTAEditReader := Self.GetIOTASourceEditor(AIOTAModule).CreateReader;
  try
    LPosition := 0;
    repeat
      SetLength(LStrBuffer, BUFFER_SIZE);
      LRead := LIOTAEditReader.GetText(LPosition, PAnsiChar(LStrBuffer), BUFFER_SIZE);
      SetLength(LStrBuffer, LRead);
      Result := Result + string(UTF8Tostring(LStrBuffer));
      Inc(LPosition, LRead);
    until LRead < BUFFER_SIZE;
  finally
    LIOTAEditReader := nil;
  end;
end;

class procedure TC4DWizardUtilsOTA.InsertBlockTextIntoEditor(const AText: string);
var
  LOTAEditorServices: IOTAEditorServices;
  LIOTAEditView: IOTAEditView;
  LPosition: Longint;
  LOTACharPos: TOTACharPos;
  LOTAEditPos: TOTAEditPos;
  LIOTAEditWriter: IOTAEditWriter;
begin
  LOTAEditorServices := Self.GetIOTAEditorServices;
  LIOTAEditView := LOTAEditorServices.TopView;
  LOTAEditPos := LIOTAEditView.CursorPos;
  LIOTAEditView.ConvertPos(True, LOTAEditPos, LOTACharPos);
  LPosition := LIOTAEditView.CharPosToPos(LOTACharPos);
  LIOTAEditWriter := LOTAEditorServices.GetTopBuffer.CreateUndoableWriter;;
  try
    LIOTAEditWriter.CopyTo(LPosition);
    LIOTAEditWriter.Insert(PAnsiChar(Utf8Encode(AText.TrimRight)));
  finally
    LIOTAEditWriter := nil;
  end;
  LIOTAEditView.MoveViewToCursor;
  LIOTAEditView.Paint;
end;

class function TC4DWizardUtilsOTA.GetBlockTextSelect: string;
var
  LIOTAEditorServices: IOTAEditorServices;
begin
  Result := '';
  LIOTAEditorServices := Self.GetIOTAEditorServices;
  if(LIOTAEditorServices.TopView <> nil)then
    Result := LIOTAEditorServices.TopView.GetBlock.Text;
end;

class function TC4DWizardUtilsOTA.OTAFileNotificationToC4DWizardFileNotification(AOTAFileNotification: TOTAFileNotification): TC4DWizardFileNotification;
begin
  Result := TC4DWizardFileNotification.None;
  case(AOTAFileNotification)of
    ofnFileOpened:
    Result := TC4DWizardFileNotification.FileOpened;
    ofnFileClosing:
    Result := TC4DWizardFileNotification.FileClosing;
  end;
end;

class procedure TC4DWizardUtilsOTA.OpenFilePathInIDE(AFilePath: string);
begin
  if(not FileExists(AFilePath))then
    Exit;

  if(TC4DWizardUtils.IsProject(AFilePath))then
    Self.GetIOTAActionServices.OpenProject(AFilePath, True)
  else
    Self.GetIOTAActionServices.OpenFile(AFilePath);
end;

class procedure TC4DWizardUtilsOTA.ShowFormProjectOptions;
begin
  GetCurrentProject.ProjectOptions.EditOptions;
end;

class function TC4DWizardUtilsOTA.RefreshProject: Boolean;
var
  LIOTAProject: IOTAProject;
begin
  Result := True;
  LIOTAProject := GetCurrentProject;
  if(LIOTAProject = nil)then
    Exit(False);
  LIOTAProject.Refresh(False);
end;

class function TC4DWizardUtilsOTA.RefreshModule: Boolean;
var
  LIOTAModule: IOTAModule;
begin
  Result := True;
  LIOTAModule := GetCurrentModule;
  if(LIOTAModule = nil)then
    Exit(False);
  LIOTAModule.Refresh(False);
end;

class procedure TC4DWizardUtilsOTA.RefreshProjectOrModule;
begin
  if(not Self.RefreshProject)then
    Self.RefreshModule;
end;

class function TC4DWizardUtilsOTA.FileIsOpenInIDE(const APathFile: string): Boolean;
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModule: IOTAModule;
  LIOTASourceEditor: IOTASourceEditor;
  i: Integer;
begin
  Result := False;
  if(APathFile.Trim.IsEmpty)then
    Exit;

  LIOTAModuleServices := Self.GetIOTAModuleServices;
  for i := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.Modules[i];

    LIOTASourceEditor := TC4DWizardUtilsOTA.GetIOTASourceEditor(LIOTAModule);
    if LIOTASourceEditor = nil then
      Continue;

    if LIOTASourceEditor.EditViewCount <= 0 then
      Continue;

    Result := SameFileName(APathFile, LIOTAModule.FileName);
    if(Result)then
      Exit;
  end;
end;

class function TC4DWizardUtilsOTA.CheckIfExistFileInCurrentsProjectGroups(const ANameFileWithExtension: string): Boolean;
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModuleCurrent: IOTAModule;
  LOTAProjectGroup: IOTAProjectGroup;
  LIOTAProjectCurrent: IOTAProject;
  LContModule: Integer;
  LContProject: Integer;
  LContFile: Integer;
  LFilePath: string;
begin
  Result := False;
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  if(LIOTAModuleServices = nil)then
    Exit;

  if(LIOTAModuleServices.ModuleCount = 0)then
    Exit;

  for LContModule := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModuleCurrent := LIOTAModuleServices.Modules[LContModule];
    if(ExtractFileName(LIOTAModuleCurrent.FileName) = ANameFileWithExtension)then
      Exit(True);

    if(Supports(LIOTAModuleCurrent, IOTAProjectGroup, LOTAProjectGroup))then
    begin
      for LContProject := 0 to Pred(LOTAProjectGroup.ProjectCount) do
      begin
        LIOTAProjectCurrent := LOTAProjectGroup.Projects[LContProject];
        for LContFile := 0 to Pred(LIOTAProjectCurrent.GetModuleCount) do
        begin
          LFilePath := LIOTAProjectCurrent.GetModule(LContFile).FileName;
          if(LFilePath.Trim.IsEmpty)then
            Continue;

          if(ExtractFileName(LFilePath) = ANameFileWithExtension)then
            Exit(True);
        end;
      end;
    end;
  end;
end;

class procedure TC4DWizardUtilsOTA.IDEThemingAll(AFormClass: TCustomFormClass; AForm: TForm);
{$IF CompilerVersion > 32}
var
  i: Integer;
  LIOTAIDEThemingServices250: IOTAIDEThemingServices250;
{$ENDIF}
begin
  AForm.Constraints.MinHeight := AForm.Height;
  AForm.Constraints.MinWidth := AForm.Width;

  {$IF CompilerVersion > 32}
  LIOTAIDEThemingServices250 := Self.GetIOTAIDEThemingServices250;
  LIOTAIDEThemingServices250.RegisterFormClass(AFormClass);
  LIOTAIDEThemingServices250.ApplyTheme(AForm);

  for i := 0 to Pred(AForm.ComponentCount) do
  begin
    if(AForm.Components[i] is TPanel)then
      TPanel(AForm.Components[i]).ParentBackground := True;

    LIOTAIDEThemingServices250.ApplyTheme(AForm.Components[i]);
  end
  {$ENDIF}
end;

class function TC4DWizardUtilsOTA.ActiveThemeColorDefaul: TColor;
begin
  Result := clWindowText;
  if(Self.ActiveThemeIsDark)then
    Result := clWhite;
end;

class function TC4DWizardUtilsOTA.ActiveThemeIsDark: Boolean;
const
  THEME_DARK = 'dark';
begin
  {$IF CompilerVersion > 32}
    Result := Self.GetIOTAIDEThemingServices.ActiveTheme.ToLower.Equals(THEME_DARK);
  {$ELSE}
    Result := False;
  {$ENDIF}
end;

class function TC4DWizardUtilsOTA.GetIOTAFormEditor(const AIOTAModule: IOTAModule): IOTAFormEditor;
var
  i: Integer;
  LIOTAEditor: IOTAEditor;
  LIOTAFormEditor: IOTAFormEditor;
begin
  Result := nil;
  if(not Assigned(AIOTAModule))then
    Exit;

  for i := 0 to Pred(AIOTAModule.GetModuleFileCount) do
  begin
    LIOTAEditor := AIOTAModule.GetModuleFileEditor(i);

    if(Supports(LIOTAEditor, IOTAFormEditor, LIOTAFormEditor))then
    begin
      Result := LIOTAFormEditor;
      Break;
    end;
  end;
end;

{$IF CompilerVersion > 32}
class function TC4DWizardUtilsOTA.GetIOTAIDEThemingServices: IOTAIDEThemingServices;
begin
  if(not Supports(BorlandIDEServices, IOTAIDEThemingServices, Result))then
    raise Exception.Create('Interface not supported: IOTAIDEThemingServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAIDEThemingServices250: IOTAIDEThemingServices250;
begin
  if(not Supports(BorlandIDEServices, IOTAIDEThemingServices250, Result))then
    raise Exception.Create('Interface not supported: IOTAIDEThemingServices250');
end;
{$ENDIF}


class function TC4DWizardUtilsOTA.GetIOTACompileServices: IOTACompileServices;
begin
  if(not Supports(BorlandIDEServices, IOTACompileServices, Result))then
    raise Exception.Create('Interface not supported: IOTACompileServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAWizardServices: IOTAWizardServices;
begin
  if(not Supports(BorlandIDEServices, IOTAWizardServices, Result))then
    raise Exception.Create('Interface not supported: IOTAWizardServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAEditView(AIOTAModule: IOTAModule): IOTAEditView;
var
  LIOTASourceEditor: IOTASourceEditor;
  LIOTAEditView: IOTAEditView;
begin
  LIOTASourceEditor := Self.GetIOTASourceEditor(AIOTAModule);
  if(LIOTASourceEditor = nil)then
    Exit;

  LIOTAEditView := Self.GetIOTAEditView(LIOTASourceEditor);
  if(LIOTAEditView = nil)then
    Exit;
  //LIOTASourceEditor.Show;
  Result := LIOTAEditView;
end;

class function TC4DWizardUtilsOTA.GetIOTAEditView(AIOTASourceEditor: IOTASourceEditor): IOTAEditView;
var
  LIOTAEditBuffer: IOTAEditBuffer;
begin
  Result := nil;

  if(not Supports(AIOTASourceEditor, IOTAEditBuffer, LIOTAEditBuffer))then
    raise Exception.Create('Interface not supported: IOTAEditBuffer');

  if(LIOTAEditBuffer <> nil)then
    Result := LIOTAEditBuffer.TopView
  else if AIOTASourceEditor.EditViewCount > 0 then
    Result := AIOTASourceEditor.EditViews[0];
end;

class function TC4DWizardUtilsOTA.GetIOTASourceEditor(AIOTAModule: IOTAModule): IOTASourceEditor;
var
  LIOTAModule: IOTAModule;
  i: Integer;
begin
  Result := nil;
  LIOTAModule := AIOTAModule;
  for i := 0 to Pred(LIOTAModule.ModuleFileCount) do
  begin
    if(LIOTAModule.ModuleFileEditors[i].QueryInterface(IOTASourceEditor, Result) = S_OK)then
      Break;
  end;
end;

class function TC4DWizardUtilsOTA.GetIOTASourceEditor(AIOTAEditor: IOTAEditor): IOTASourceEditor;
begin
  Result := nil;
  if(not Supports(AIOTAEditor, IOTASourceEditor, Result))then
    raise Exception.Create('Interface not supported: IOTASourceEditor');
end;

class function TC4DWizardUtilsOTA.GetIOTASourceEditor(AIOTAModule: IOTAModule; const AFileName: string): IOTASourceEditor;
var
  i: Integer;
  LIOTAEditor: IOTAEditor;
  LIOTASourceEditor: IOTASourceEditor;

  function GetFileEditorForModule(Module: IOTAModule; Index: Integer): IOTAEditor;
  begin
    Result := nil;
    if not Assigned(Module) then
      Exit;
    try
      {$IFDEF BCB5}
      if IsCpp(Module.FileName)and(Module.GetModuleFileCount = 2)and(Index = 1)then
        Index := 2;
      {$ENDIF}
      Result := Module.GetModuleFileEditor(Index);
    except
      Result := nil;
    end;
  end;

begin
  if(not Assigned(AIOTAModule))then
  begin
    Result := nil;
    Exit;
  end;

  for i := 0 to Pred(AIOTAModule.GetModuleFileCount) do
  begin
    LIOTAEditor := GetFileEditorForModule(AIOTAModule, i);
    if(Supports(LIOTAEditor, IOTASourceEditor, LIOTASourceEditor))then
    begin
      if(Assigned(LIOTASourceEditor))then
      begin
        if(AFileName = '')or(SameFileName(LIOTASourceEditor.FileName, AFileName))then
        begin
          Result := LIOTASourceEditor;
          Exit;
        end;
      end;
    end;
  end;
  Result := nil;
end;

class function TC4DWizardUtilsOTA.GetIOTAEditBufferCurrentModule: IOTAEditBuffer;
var
  LIOTAModule: IOTAModule;
begin
  Result := nil;

  LIOTAModule := Self.GetCurrentModule;
  if(LIOTAModule = nil)then
    Exit;

  Result := TC4DWizardUtilsOTA.GetIOTAEditBuffer(LIOTAModule);
end;

class function TC4DWizardUtilsOTA.GetIOTAEditBuffer(AIOTAModule: IOTAModule): IOTAEditBuffer;
var
  LIOTASourceEditor: IOTASourceEditor;
begin
  Result := nil;
  LIOTASourceEditor := Self.GetIOTASourceEditor(AIOTAModule);
  if(LIOTASourceEditor = nil)then
    Exit;

  if(not Supports(LIOTASourceEditor, IOTAEditBuffer, Result))then
    raise Exception.Create('Interface not supported: IOTAEditBuffer');
end;

class function TC4DWizardUtilsOTA.GetIOTAMessageServices: IOTAMessageServices;
begin
  if(not Supports(BorlandIDEServices, IOTAMessageServices, Result))then
    raise Exception.Create('Interface not supported: IOTAMessageServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAProjectManager: IOTAProjectManager;
begin
  if(not Supports(BorlandIDEServices, IOTAProjectManager, Result))then
    raise Exception.Create('Interface not supported: IOTAProjectManager');
end;

class function TC4DWizardUtilsOTA.GetIOTAKeyboardServices: IOTAKeyboardServices;
begin
  if(not Supports(BorlandIDEServices, IOTAKeyboardServices, Result))then
    raise Exception.Create('Interface not supported: IOTAKeyboardServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAServices: IOTAServices;
begin
  if(not Supports(BorlandIDEServices, IOTAServices, Result))then
    raise Exception.Create('Interface not supported: IOTAServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAActionServices: IOTAActionServices;
begin
  if(not Supports(BorlandIDEServices, IOTAActionServices, Result))then
    raise Exception.Create('Interface not supported: IOTAActionServices');
end;

class function TC4DWizardUtilsOTA.GetINTAServices: INTAServices;
begin
  if(not Supports(BorlandIDEServices, INTAServices, Result))then
    raise Exception.Create('Interface not supported: INTAServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAModuleServices: IOTAModuleServices;
begin
  if(not Supports(BorlandIDEServices, IOTAModuleServices, Result))then
    raise Exception.Create('Interface not supported: IOTAModuleServices');
end;

class function TC4DWizardUtilsOTA.GetIOTAEditorServices: IOTAEditorServices;
begin
  if(not Supports(BorlandIDEServices, IOTAEditorServices, Result))then
    raise Exception.Create('Interface not supported: IOTAEditorServices');
end;

class function TC4DWizardUtilsOTA.GetCurrentModule: IOTAModule;
var
  LIOTAModuleServices: IOTAModuleServices;
begin
  Result := nil;
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  if(LIOTAModuleServices <> nil)then
    Result := LIOTAModuleServices.CurrentModule;
end;

class function TC4DWizardUtilsOTA.GetCurrentModuleFileName: string;
var
  LIOTAModule: IOTAModule;
begin
  Result := '';
  LIOTAModule := Self.GetCurrentModule;
  if(Assigned(LIOTAModule))then
    Result := LIOTAModule.FileName.Trim;
end;

class function TC4DWizardUtilsOTA.GetModule(const AFileName: string): IOTAModule;
var
  LIOTAModuleServices: IOTAModuleServices;
begin
  Result := nil;
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  if(LIOTAModuleServices <> nil)then
    Result := LIOTAModuleServices.FindModule(AFileName);
end;

class function TC4DWizardUtilsOTA.GetCurrentProjectGroup: IOTAProjectGroup;
begin
  Result := Self.GetIOTAModuleServices.MainProjectGroup;
end;

class function TC4DWizardUtilsOTA.GetCurrentProject: IOTAProject;
var
  LIOTAProjectGroup: IOTAProjectGroup;
begin
  Result := nil;
  LIOTAProjectGroup := Self.GetCurrentProjectGroup;
  if(not Assigned(LIOTAProjectGroup))then
    Exit;

  try
    Result := LIOTAProjectGroup.ActiveProject;
  except
    ;
  end;
end;

class function TC4DWizardUtilsOTA.GetCurrentProjectFileName: string;
var
  LIOTAProject: IOTAProject;
begin
  Result := '';
  LIOTAProject := Self.GetCurrentProject;
  if(Assigned(LIOTAProject))then
    Result := LIOTAProject.FileName.Trim;
end;

class function TC4DWizardUtilsOTA.GetProjectName(const AIOTAProject: IOTAProject): string;
var
  i: Integer;
  LExt: string;
begin
  Result := ExtractFileName(AIOTAProject.FileName);
  for i := 0 to Pred(AIOTAProject.ModuleFileCount) do
  begin
    LExt := LowerCase(ExtractFileExt(AIOTAProject.ModuleFileEditors[i].FileName));
    if(LExt = TC4DExtensionsFiles.DPR.ToString)or(LExt = TC4DExtensionsFiles.DPK.ToString) Then
    begin
      Result := ChangeFileExt(Result, LExt);
      Break;
    end;
  end;
end;

class function TC4DWizardUtilsOTA.GetFileNameDprOrDpkIfDproj(const AIOTAModule: IOTAModule): string;
var
  i: Integer;
  LExt: string;
  LFileName: string;
begin
  Result := AIOTAModule.FileName;

  if ExtractFileExt(Result) = TC4DExtensionsFiles.DPROJ.ToStringWithPoint then
  begin
    for i := 0 to Pred(AIOTAModule.ModuleFileCount) do
    begin
      LFileName := AIOTAModule.ModuleFileEditors[i].FileName;
      LExt := ExtractFileExt(LFileName);

      if(LExt = TC4DExtensionsFiles.DPR.ToStringWithPoint)or(LExt = TC4DExtensionsFiles.DPK.ToStringWithPoint)then
        Result := LFileName;
    end;
  end;
end;

class function TC4DWizardUtilsOTA.GetCurrentProjectOptions: IOTAProjectOptions;
var
  LIOTAProject: IOTAProject;
begin
  Result := nil;
  LIOTAProject := Self.GetCurrentProject;
  if(LIOTAProject = nil)then
    Exit;

  Result := LIOTAProject.ProjectOptions;
end;

class function TC4DWizardUtilsOTA.GetCurrentOutputDir: string;
var
  LIOTAProjectOptions: IOTAProjectOptions;
begin
  LIOTAProjectOptions := Self.GetCurrentProjectOptions;
  if(LIOTAProjectOptions = nil)then
    Exit;

  Result := VarToStr(LIOTAProjectOptions.Values['OutputDir']);
end;

class function TC4DWizardUtilsOTA.GetCurrentProjectOptionsConfigurations: IOTAProjectOptionsConfigurations;
var
  LIOTAProjectOptions: IOTAProjectOptions;
begin
  LIOTAProjectOptions := Self.GetCurrentProjectOptions;
  if(LIOTAProjectOptions <> nil)then
    if(Supports(LIOTAProjectOptions, IOTAProjectOptionsConfigurations, Result))then
      Exit;

  Result := nil;
end;

class function TC4DWizardUtilsOTA.GetBinaryPath(AIOTAProject: IOTAProject): string;
begin
  Result := '';
  if(not Assigned(AIOTAProject))then
    TC4DWizardUtils.ShowMsgAndAbort('No project selected');

  Result := TC4DWizardUtilsOTABinaryPath.New.GetBinaryPathOfProject(AIOTAProject);
  if(not FileExists(Result))then
  begin
    Result := IncludeTrailingPathDelimiter(ExtractFileDir(Result));
    if(not DirectoryExists(Result))then
      Result := '';
  end;
end;

class procedure TC4DWizardUtilsOTA.OpenBinaryPath(AIOTAProject: IOTAProject);
var
  LPath: string;
begin
  LPath := TC4DWizardUtilsOTA.GetBinaryPath(AIOTAProject);
  if(LPath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('File or diretory not found: ' + LPath);
  TC4DWizardUtils.OpenFileOrFolder(LPath);
end;

class function TC4DWizardUtilsOTA.GetBinaryPathCurrent: string;
begin
  Result := Self.GetBinaryPath(Self.GetCurrentProject);
end;

class procedure TC4DWizardUtilsOTA.OpenBinaryPathCurrent;
begin
  Self.OpenBinaryPath(Self.GetCurrentProject);
end;

class function TC4DWizardUtilsOTA.GetPathsFilesOpened: TList<string>;
var
  LIOTAModuleServices: IOTAModuleServices;
  LFilePath: string;
  i: Integer;
begin
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  Result := TList<string>.Create;
  Result.Add('Opened');
  for i := 0 to Pred(LIOTAModuleServices.GetModuleCount) do
  begin
    LFilePath := LIOTAModuleServices.GetModule(i).FileName;
    Result.Add(LFilePath);
  end;
end;

class procedure TC4DWizardUtilsOTA.GetAllFilesFromProjectGroup(AListFiles: TStrings;
  const AFilePathProjectOrGroupForFilter: string;
  const AC4DWizardExtensions: TC4DExtensionsOfFiles);
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModuleCurrent: IOTAModule;
  LOTAProjectGroup: IOTAProjectGroup;
  LIOTAProjectCurrent: IOTAProject;
  LContModule: Integer;
  LContProject: Integer;
  LContFile: Integer;
  LFilePath: string;
  LFilterIsProjectGroup: Boolean;
  LFilterIsProject: Boolean;
begin
  LIOTAModuleServices := Self.GetIOTAModuleServices;
  if(LIOTAModuleServices = nil)then
    Exit;

  if(LIOTAModuleServices.ModuleCount = 0)then
    Exit;

  LFilterIsProjectGroup := False;
  LFilterIsProject := False;
  if(not AFilePathProjectOrGroupForFilter.Trim.IsEmpty)then
  begin
    if(TC4DWizardUtils.IsProjectGroup(AFilePathProjectOrGroupForFilter))then
      LFilterIsProjectGroup := True
    else if(TC4DWizardUtils.IsProject(AFilePathProjectOrGroupForFilter))
      or(TC4DWizardUtils.IsDPROJ(AFilePathProjectOrGroupForFilter))
    then
      LFilterIsProject := True;
  end;

  for LContModule := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModuleCurrent := LIOTAModuleServices.Modules[LContModule];
    LFilePath := LIOTAModuleCurrent.FileName;
    if(Supports(LIOTAModuleCurrent, IOTAProjectGroup, LOTAProjectGroup))then
    begin
      if(LFilterIsProjectGroup)and(LFilePath <> AFilePathProjectOrGroupForFilter)then
        Continue;

      for LContProject := 0 to Pred(LOTAProjectGroup.ProjectCount) do
      begin
        LIOTAProjectCurrent := LOTAProjectGroup.Projects[LContProject];

        if(LFilterIsProject)and(LIOTAProjectCurrent.FileName <> AFilePathProjectOrGroupForFilter)then
          Continue;

        for LContFile := 0 to Pred(LIOTAProjectCurrent.GetModuleCount) do
        begin
          LFilePath := LIOTAProjectCurrent.GetModule(LContFile).FileName;
          if(LFilePath.Trim.IsEmpty)then
            Continue;

          if(not AC4DWizardExtensions.ContainsStr(ExtractFileExt(LFilePath)))then
            Continue;

          AListFiles.Add(LFilePath);
        end;
      end;
    end;
  end;
end;

end.
