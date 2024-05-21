unit C4D.Wizard.Model.Files.Loop;

interface

uses
  ToolsAPI,
  C4D.Wizard.Interfaces,
  C4D.Wizard.Types,
  System.Classes,
  System.IOUtils,
  System.SysUtils,
  Vcl.Forms;

type
  TC4DWizardModelFilesLoop = class(TInterfacedObject, IC4DWizardModelFilesLoop)
  private
    FExtensions: TC4DExtensionsOfFiles;
    FEscope: TC4DWizardEscope;
    FDirectoryForSearch: string;
    FIncludeSubdirectories: Boolean;
    FCancel: Boolean;
    FListFiles: TStrings;
    procedure ListFilesAdd(AFilePath: string);
    function ValidateExtensions(AExtension: string): Boolean;
    procedure GetFilesGroup;
    procedure GetFilesProject(AProject: IOTAProject);
    procedure GetFilesOpened;
    procedure GetFileCurrent;
    procedure GetFilesInDirectories;
    procedure ProcessEscope;
    procedure ShowListFilesFound;
  protected
    function Extensions(AValue: TC4DExtensionsOfFiles): IC4DWizardModelFilesLoop;
    function Escope(AValue: TC4DWizardEscope): IC4DWizardModelFilesLoop;
    function DirectoryForSearch(AValue: string): IC4DWizardModelFilesLoop;
    function IncludeSubdirectories(AValue: Boolean): IC4DWizardModelFilesLoop;
    function Cancel: IC4DWizardModelFilesLoop;
    function Canceled: Boolean;
    procedure LoopInFiles(AProc: TProc<TC4DWizardInfoFile>);
  public
    class function New: IC4DWizardModelFilesLoop;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Utils.ListOfFilesInFolder;

class function TC4DWizardModelFilesLoop.New: IC4DWizardModelFilesLoop;
begin
  Result := Self.Create;
end;

constructor TC4DWizardModelFilesLoop.Create;
begin
  FListFiles := TStringList.Create;
  FExtensions := [TC4DExtensionsFiles.PAS, TC4DExtensionsFiles.DFM];
  FEscope := TC4DWizardEscope.FileCurrent;
  FCancel := False;
end;

destructor TC4DWizardModelFilesLoop.Destroy;
begin
  FListFiles.Free;
  inherited;
end;

function TC4DWizardModelFilesLoop.Extensions(AValue: TC4DExtensionsOfFiles): IC4DWizardModelFilesLoop;
begin
  Result := Self;
  FExtensions := AValue;
end;

function TC4DWizardModelFilesLoop.Escope(AValue: TC4DWizardEscope): IC4DWizardModelFilesLoop;
begin
  Result := Self;
  FEscope := AValue;
end;

function TC4DWizardModelFilesLoop.DirectoryForSearch(AValue: string): IC4DWizardModelFilesLoop;
begin
  Result := Self;
  FDirectoryForSearch := AValue.Trim;
end;

function TC4DWizardModelFilesLoop.IncludeSubdirectories(AValue: Boolean): IC4DWizardModelFilesLoop;
begin
  Result := Self;
  FIncludeSubdirectories := AValue;
end;

function TC4DWizardModelFilesLoop.Cancel: IC4DWizardModelFilesLoop;
begin
  Result := Self;
  FCancel := True;
  Abort;
end;

function TC4DWizardModelFilesLoop.Canceled: Boolean;
begin
  Result := FCancel;
end;

function TC4DWizardModelFilesLoop.ValidateExtensions(AExtension: string): Boolean;
begin
  if(FExtensions = [TC4DExtensionsFiles.ALL])then
    Exit(True);
  Result := FExtensions.ContainsStr(AExtension);
end;

procedure TC4DWizardModelFilesLoop.GetFilesGroup;
var
  LGroup: IOTAProjectGroup;
  LContProj: Integer;
begin
  LGroup := TC4DWizardUtilsOTA.GetCurrentProjectGroup;
  if(not Assigned(LGroup))then
    raise Exception.Create('No Project Group was found');

  for LContProj := 0 to pred(LGroup.ProjectCount) do
    Self.GetFilesProject(LGroup.Projects[LContProj])
end;

procedure TC4DWizardModelFilesLoop.GetFilesProject(AProject: IOTAProject);
var
  LContModule: Integer;
  LFileName: string;
begin
  if(not Assigned(AProject))then
    raise Exception.Create('No Project was found');

  if(TC4DExtensionsFiles.DPROJ in FExtensions)then
  begin
    if(TC4DWizardUtils.IsDPROJ(AProject.FileName))then
      Self.ListFilesAdd(AProject.FileName);
  end;

  if(TC4DExtensionsFiles.DPR in FExtensions)then
  begin
    LFileName := TC4DWizardUtils.ChangeExtensionToDPR(AProject.FileName);
    if(FileExists(LFileName))then
      Self.ListFilesAdd(LFileName);
  end;

  if(TC4DExtensionsFiles.DPK in FExtensions)then
  begin
    LFileName := TC4DWizardUtils.ChangeExtensionToDPK(AProject.FileName);
    if(FileExists(LFileName))then
      Self.ListFilesAdd(LFileName);
  end;

  for LContModule := 0 to pred(AProject.GetModuleCount) do
    Self.ListFilesAdd(AProject.GetModule(LContModule).FileName);
end;

procedure TC4DWizardModelFilesLoop.GetFilesOpened;
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAEditor: IOTAEditor;
  LIOTASourceEditor: IOTASourceEditor;
  LContModule: Integer;
  LContFile: Integer;
  LIOTAModule: IOTAModule;
begin
  LIOTAModuleServices := TC4DWizardUtilsOTA.GetIOTAModuleServices;
  if(not Assigned(LIOTAModuleServices))then
    raise Exception.Create('No Units Opened was found');

  if(LIOTAModuleServices.ModuleCount = 1)then
    if(LIOTAModuleServices.GetModule(0).FileName = TC4DConsts.DEFAULT_HTM)then
      raise Exception.Create('No Units Opened was found.');

  for LContModule := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.GetModule(LContModule);
    for LContFile := 0 to Pred(LIOTAModule.GetModuleFileCount)do
    begin
      LIOTAEditor := LIOTAModule.GetModuleFileEditor(LContFile);
      if Supports(LIOTAEditor, IOTASourceEditor, LIOTASourceEditor) then
      begin
        if LIOTASourceEditor.EditViewCount > 0 then
        begin
          Self.ListFilesAdd(LIOTAEditor.FileName);
          Break;
        end;
      end;
    end;
  end;
end;

procedure TC4DWizardModelFilesLoop.GetFileCurrent;
var
  LFileName: string;
begin
  LFileName := TC4DWizardUtilsOTA.GetCurrentModuleFileName.Trim;
  if(LFileName.IsEmpty)or(LFileName = TC4DConsts.DEFAULT_HTM)then
    raise Exception.Create('No File Current was found');

  Self.ListFilesAdd(LFileName);
end;

procedure TC4DWizardModelFilesLoop.GetFilesInDirectories;
var
  LListFiles: TStrings;
  LNameFile: string;
begin
  if(FDirectoryForSearch.IsEmpty)then
    raise Exception.Create('Directory for search not informed');

  if(not DirectoryExists(FDirectoryForSearch))then
    raise Exception.Create('Directory for search not found');

  LListFiles := TStringList.Create;
  try
    TC4DWizardUtilsListOfFilesInFolder.New
      .FolderPath(FDirectoryForSearch)
      .IncludeSubdirectories(FIncludeSubdirectories)
      .ExtensionsOfFiles(FExtensions)
      .GetListOfFiles(LListFiles);

    for LNameFile in LListFiles do
      Self.ListFilesAdd(LNameFile);
  finally
    LListFiles.Free;
  end;
end;

procedure TC4DWizardModelFilesLoop.ListFilesAdd(AFilePath: string);
var
  LExtension: string;
  LFileDFM: string;
begin
  if(AFilePath.Trim.IsEmpty)then
    Exit;

  FListFiles.Add(AFilePath);
  LExtension := ExtractFileExt(AFilePath).ToLower.Trim;
  if(LExtension = '.pas')then
  begin
    LFileDFM := TC4DWizardUtils.ChangeExtensionToDFM(AFilePath);
    if(FileExists(LFileDFM))then
      FListFiles.Add(LFileDFM);
  end;
end;

procedure TC4DWizardModelFilesLoop.ProcessEscope;
begin
  case(FEscope)of
    TC4DWizardEscope.FilesInGroup:
      Self.GetFilesGroup;
    TC4DWizardEscope.FilesInProject:
      Self.GetFilesProject(TC4DWizardUtilsOTA.GetCurrentProject);
    TC4DWizardEscope.FilesOpened:
      Self.GetFilesOpened;
    TC4DWizardEscope.FileCurrent:
      Self.GetFileCurrent;
    TC4DWizardEscope.FilesInDirectories:
      Self.GetFilesInDirectories;
  end;
end;

procedure TC4DWizardModelFilesLoop.ShowListFilesFound;
begin
  Exit;

  TThread.Synchronize(nil,
    procedure
    begin
      TC4DWizardUtils.ShowMsgInMemo(FListFiles.Text);
    end);
end;

procedure TC4DWizardModelFilesLoop.LoopInFiles(AProc: TProc<TC4DWizardInfoFile>);
var
  LFilePath: string;
  LFileInfo: TC4DWizardInfoFile;
  LExtension: string;
  i: Integer;
begin
  FListFiles.Clear;

  if(FExtensions = [TC4DExtensionsFiles.None])then
    Exit;

  FCancel := False;
  Self.ProcessEscope;

  if(FListFiles.Count <= 0)then
    Exit;

  Self.ShowListFilesFound;

  for i := 0 to pred(FListFiles.Count) do
  begin
    if(FCancel)then
      Exit;

    LFilePath := FListFiles[i];
    LExtension := ExtractFileExt(LFilePath);
    if(not Self.ValidateExtensions(LExtension))then
      Continue;

    LFileInfo.Path := LFilePath;
    LFileInfo.LastAccess := 0;
    if(FileExists(LFilePath))then
      LFileInfo.LastAccess := System.IOUtils.TFile.GetLastWriteTime(LFilePath);

    AProc(LFileInfo);
  end;
end;

end.
