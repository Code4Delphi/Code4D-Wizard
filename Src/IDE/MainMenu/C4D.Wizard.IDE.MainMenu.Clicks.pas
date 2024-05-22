unit C4D.Wizard.IDE.MainMenu.Clicks;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Forms,
  ToolsAPI;

type
  TC4DWizardIDEMainMenuClicks = class
  private
    class function GetFileNameCurrentProject: string;
  public
    class procedure UsesOrganizationClick(Sender: TObject);
    class procedure ReopenClick(Sender: TObject);
    class procedure TranslateTextClick(Sender: TObject);
    class procedure IndentClick(Sender: TObject);
    class procedure FormatSourceClick(Sender: TObject);
    class procedure FindClick(Sender: TObject);
    class procedure ReplaceClick(Sender: TObject);
    class procedure NotesClick(Sender: TObject);
    class procedure VsCodeIntegrationOpenInVsCodeClick(Sender: TObject);
    class procedure VsCodeIntegrationInstallGithubCopilotClick(Sender: TObject);
    class procedure VsCodeIntegrationInstallDelphiLSPClick(Sender: TObject);
    class procedure DefaultFilesInOpeningProjectClick(Sender: TObject);
    class procedure BackupExportClick(Sender: TObject);
    class procedure BackupImportClick(Sender: TObject);
    class procedure SettingsClick(Sender: TObject);
    class procedure OpenInGitHubDesktopClick(Sender: TObject);
    class procedure ViewInRemoteRepositoryClick(Sender: TObject);
    class procedure ViewInfRemoteRepositoryClick(Sender: TObject);
    class procedure ViewFileProjectInExplorerClick(Sender: TObject);
    class procedure ViewCurrentFileInExplorerClick(Sender: TObject);
    class procedure ViewCurrentExeInExplorerClick(Sender: TObject);
    class procedure AboutClick(Sender: TObject);
  end;

implementation

uses
  C4D.Wizard.Reopen.Controller,
  C4D.Wizard.Reopen.View,
  C4D.Wizard.Settings.View,
  C4D.Wizard.UsesOrganization.View,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Translate.View,
  C4D.Wizard.Indent,
  C4D.Wizard.ReplaceFiles.View,
  C4D.Wizard.Find.View,
  C4D.Wizard.Backup.Export.View,
  C4D.Wizard.Backup.Import.View,
  C4D.Wizard.View.About,
  C4D.Wizard.DefaultFilesInOpeningProject,
  C4D.Wizard.FormatSource.View,
  C4D.Wizard.Notes.View,
  C4D.Wizard.VsCodeIntegration;

class procedure TC4DWizardIDEMainMenuClicks.UsesOrganizationClick(Sender: TObject);
var
  LC4DWizardUsesOrganizationView: TC4DWizardUsesOrganizationView;
begin
  if(TC4DWizardUtilsOTA.GetCurrentModule = nil)then
    TC4DWizardUtils.ShowMsgAndAbort('No projects or files selected');

  LC4DWizardUsesOrganizationView := TC4DWizardUsesOrganizationView.Create(nil);
  try
    LC4DWizardUsesOrganizationView.ShowModal;
    TC4DWizardUtilsOTA.RefreshProjectOrModule;
  finally
    LC4DWizardUsesOrganizationView.Free;
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.ReopenClick(Sender: TObject);
begin
  C4D.Wizard.Reopen.View.C4DWizardReopenViewShowDockableForm;
end;

class procedure TC4DWizardIDEMainMenuClicks.TranslateTextClick(Sender: TObject);
begin
  C4DWizardTranslateView := TC4DWizardTranslateView.Create(nil);
  try
    C4DWizardTranslateView.StrTranslate := TC4DWizardUtilsOTA.GetBlockTextSelect;
    C4DWizardTranslateView.ShowModal;
  finally
    FreeAndNil(C4DWizardTranslateView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.IndentClick(Sender: TObject);
begin
  TC4DWizardIndent.New.ProcessBlockSelected;
end;

class procedure TC4DWizardIDEMainMenuClicks.FormatSourceClick(Sender: TObject);
var
  LC4DWizardFormatSourceView: TC4DWizardFormatSourceView;
begin
  if(TC4DWizardUtilsOTA.GetCurrentModule = nil)then
    TC4DWizardUtils.ShowMsgAndAbort('No projects or files selected');

  LC4DWizardFormatSourceView := TC4DWizardFormatSourceView.Create(nil);
  try
    LC4DWizardFormatSourceView.ShowModal;
    TC4DWizardUtilsOTA.RefreshProjectOrModule;
  finally
    LC4DWizardFormatSourceView.Free;
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.FindClick(Sender: TObject);
begin
  C4DWizardFindView := TC4DWizardFindView.Create(nil);
  try
    C4DWizardFindView.ShowModal;
  finally
    FreeAndNil(C4DWizardFindView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.ReplaceClick(Sender: TObject);
begin
  C4DWizardReplaceFilesView := TC4DWizardReplaceFilesView.Create(nil);
  try
    C4DWizardReplaceFilesView.ShowModal;
  finally
    FreeAndNil(C4DWizardReplaceFilesView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.NotesClick(Sender: TObject);
begin
  C4D.Wizard.Notes.View.C4DWizardNotesViewShowDockableForm;
end;

class procedure TC4DWizardIDEMainMenuClicks.VsCodeIntegrationOpenInVsCodeClick(Sender: TObject);
begin
  TC4DWizardVsCodeIntegration.Open;
end;

class procedure TC4DWizardIDEMainMenuClicks.VsCodeIntegrationInstallGithubCopilotClick(Sender: TObject);
begin
  TC4DWizardVsCodeIntegration.InstallGithubCopilot;
end;

class procedure TC4DWizardIDEMainMenuClicks.VsCodeIntegrationInstallDelphiLSPClick(Sender: TObject);
begin
  TC4DWizardVsCodeIntegration.InstallDelphiLSP;
end;

class procedure TC4DWizardIDEMainMenuClicks.DefaultFilesInOpeningProjectClick(Sender: TObject);
begin
  TC4DWizardDefaultFilesInOpeningProject.New(Self.GetFileNameCurrentProject).SelectionFilesForDefaultOpening;
end;

class procedure TC4DWizardIDEMainMenuClicks.BackupExportClick(Sender: TObject);
begin
  C4DWizardBackupExportView := TC4DWizardBackupExportView.Create(nil);
  try
    C4DWizardBackupExportView.ShowModal;
  finally
    FreeAndNil(C4DWizardBackupExportView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.BackupImportClick(Sender: TObject);
begin
  C4DWizardBackupImportView := TC4DWizardBackupImportView.Create(nil);
  try
    C4DWizardBackupImportView.ShowModal;
  finally
    FreeAndNil(C4DWizardBackupImportView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.SettingsClick(Sender: TObject);
begin
  C4DWizardSettingsView := TC4DWizardSettingsView.Create(nil);
  try
    C4DWizardSettingsView.ShowModal;
  finally
    FreeAndNil(C4DWizardSettingsView);
  end;
end;

class procedure TC4DWizardIDEMainMenuClicks.OpenInGitHubDesktopClick(Sender: TObject);
begin
  TC4DWizardReopenController.New(Self.GetFileNameCurrentProject).OpenInGitHubDesktop;
end;

class procedure TC4DWizardIDEMainMenuClicks.ViewInRemoteRepositoryClick(Sender: TObject);
begin
  TC4DWizardReopenController.New(Self.GetFileNameCurrentProject).ViewInRemoteRepository;
end;

class procedure TC4DWizardIDEMainMenuClicks.ViewInfRemoteRepositoryClick(Sender: TObject);
begin
  TC4DWizardReopenController.New(Self.GetFileNameCurrentProject).ViewInformationRemoteRepository;
end;

class function TC4DWizardIDEMainMenuClicks.GetFileNameCurrentProject: string;
var
  LIOTAProject: IOTAProject;
begin
  Result := '';
  LIOTAProject := TC4DWizardUtilsOTA.GetCurrentProject;
  if(LIOTAProject = nil)then
    TC4DWizardUtils.ShowMsgAndAbort('No project or file selected');

  Result := LIOTAProject.FileName.Trim; //TC4DWizardUtilsOTA.GetCurrentProject.FileName.Trim;

  if(Result.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('No project or file selected.');

  if(not FileExists(Result))then
    TC4DWizardUtils.ShowMsgAndAbort('File project not found');
end;

class procedure TC4DWizardIDEMainMenuClicks.ViewFileProjectInExplorerClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenFile(Self.GetFileNameCurrentProject);
end;

class procedure TC4DWizardIDEMainMenuClicks.ViewCurrentFileInExplorerClick(Sender: TObject);
var
  LCurrentFilePath: string;
begin
  LCurrentFilePath := TC4DWizardUtilsOTA.GetCurrentModuleFileName;
  if(not FileExists(LCurrentFilePath))then
    TC4DWizardUtils.ShowMsgAndAbort('No file selected');
  TC4DWizardUtils.OpenFile(LCurrentFilePath);
end;

class procedure TC4DWizardIDEMainMenuClicks.ViewCurrentExeInExplorerClick(Sender: TObject);
begin
  TC4DWizardUtilsOTA.OpenBinaryPathCurrent;
end;

class procedure TC4DWizardIDEMainMenuClicks.AboutClick(Sender: TObject);
begin
  C4DWizardViewAbout := TC4DWizardViewAbout.Create(nil);
  try
    C4DWizardViewAbout.ShowModal;
  finally
    FreeAndNil(C4DWizardViewAbout);
  end;
end;

end.
