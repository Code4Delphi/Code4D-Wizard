unit C4D.Wizard.Reopen.Controller;

interface

uses
  System.SysUtils,
  C4D.Wizard.Types,
  C4D.Wizard.Reopen.Interfaces,
  Vcl.Forms,
  Vcl.Controls;

type
  TC4DWizardReopenController = class(TInterfacedObject, IC4DWizardReopenController)
  private
    FC4DWizardReopenData: TC4DWizardReopenData;
  protected
    function GetC4DWizardReopenData: TC4DWizardReopenData;
    procedure OpenInGitHubDesktop;
    procedure ViewInRemoteRepository;
    procedure ViewInformationRemoteRepository;
    procedure EditInformations;
    function GetPathFolderGit: string;
  public
    class function New(AFilePath: string): IC4DWizardReopenController; overload;
    class function New(AC4DWizardReopenData: TC4DWizardReopenData): IC4DWizardReopenController; overload;
    constructor Create(AFilePath: string); overload;
    constructor Create(AC4DWizardReopenData: TC4DWizardReopenData); overload;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Reopen.Model,
  C4D.Wizard.Reopen.View.Edit,
  C4D.Wizard.Utils.Git;

class function TC4DWizardReopenController.New(AFilePath: string): IC4DWizardReopenController;
begin
  Result := Self.Create(AFilePath);
end;

class function TC4DWizardReopenController.New(AC4DWizardReopenData: TC4DWizardReopenData): IC4DWizardReopenController;
begin
  Result := Self.Create(AC4DWizardReopenData);
end;

constructor TC4DWizardReopenController.Create(AFilePath: string);
begin
  Self.Create(TC4DWizardReopenModel.New.ReadFilePathInIniFile(AFilePath));
end;

constructor TC4DWizardReopenController.Create(AC4DWizardReopenData: TC4DWizardReopenData);
begin
  FC4DWizardReopenData := AC4DWizardReopenData;
end;

function TC4DWizardReopenController.GetC4DWizardReopenData: TC4DWizardReopenData;
begin
  Result := FC4DWizardReopenData;
end;

function TC4DWizardReopenController.GetPathFolderGit: string;
begin
  Result := FC4DWizardReopenData.FolderGit.Trim;
  if(Result.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('Folder .git not informed in settings');

  Result := TC4DWizardUtilsGit.GetPathFolderGitConfig(Result);
  if(Result.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('Folder .git not found');
end;

procedure TC4DWizardReopenController.OpenInGitHubDesktop;
begin
  TC4DWizardUtilsGit.OpenInGitHubDesktop(Self.GetPathFolderGit);
end;

procedure TC4DWizardReopenController.ViewInRemoteRepository;
begin
  TC4DWizardUtilsGit.ViewInRemoteRepository(Self.GetPathFolderGit);
end;

procedure TC4DWizardReopenController.ViewInformationRemoteRepository;
begin
  TC4DWizardUtilsGit.ViewInformationRemoteRepository(Self.GetPathFolderGit);
end;

procedure TC4DWizardReopenController.EditInformations;
begin
  if(FC4DWizardReopenData.FilePath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('File path not informed');

  C4DWizardReopenViewEdit := TC4DWizardReopenViewEdit.Create(nil);
  try
    C4DWizardReopenViewEdit.C4DWizardReopenData := FC4DWizardReopenData;
    if(C4DWizardReopenViewEdit.ShowModal <> mrOk)then
      Exit;
    FC4DWizardReopenData := C4DWizardReopenViewEdit.C4DWizardReopenData;
  finally
    FreeAndNil(C4DWizardReopenViewEdit);
  end;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardReopenModel.New.EditDataInIniFile(FC4DWizardReopenData);
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
