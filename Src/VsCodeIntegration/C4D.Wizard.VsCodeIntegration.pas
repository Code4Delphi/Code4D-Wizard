unit C4D.Wizard.VsCodeIntegration;

interface

uses
  System.SysUtils,
  ToolsAPI;

type
  TC4DWizardVsCodeIntegration = class
  private
    class procedure RunCommandInstallExtension(const AIdentifierExtension: string);
  public
    class procedure Open;
    class procedure InstallGithubCopilot;
    class procedure InstallDelphiLSP;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.ProcessDelphi;

class procedure TC4DWizardVsCodeIntegration.Open;
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModule: IOTAModule;
  LIOTASourceEditor: IOTASourceEditor;
  LIOTAEditView: IOTAEditView;
  LFileNameModule: string;
  LIOTAProject: IOTAProject;
  LFilePathProject: string;
  LCursorPos: TOTAEditPos;
  LComand: string;
begin
  LIOTAModuleServices := TC4DWizardUtilsOTA.GetIOTAModuleServices;

  LIOTAModule := LIOTAModuleServices.CurrentModule;
  if LIOTAModule = nil then
    TC4DWizardUtils.ShowMsgAndAbort('No current module');

  if not Supports(LIOTAModule.CurrentEditor, IOTASourceEditor, LIOTASourceEditor) then
    TC4DWizardUtils.ShowMsgAndAbort('Feature not currently supported');

  LIOTAEditView := LIOTASourceEditor.GetEditView(0);
  if LIOTAEditView = nil then
    TC4DWizardUtils.ShowMsgAndAbort('Editor view cannot be located');

  LIOTAProject := LIOTAModuleServices.GetActiveProject;
  if LIOTAProject = nil then
    TC4DWizardUtils.ShowMsgAndAbort('No active projects were found');
  LFilePathProject := ExtractFilePath(LIOTAProject.FileName);

  LFileNameModule := TC4DWizardUtilsOTA.GetFileNameDprOrDpkIfDproj(LIOTAModule);

  TC4DWizardUtilsOTA.SaveAllModifiedModules;

  LCursorPos := LIOTAEditView.CursorPos;
  //REFERENCE: https://code.visualstudio.com/docs/editor/command-line
  LComand := Format('"code -n %s -g %s:%d:%d"', [LFilePathProject, LFileNameModule, LCursorPos.Line, LCursorPos.Col]);
  TC4DWizardProcessDelphi.RunCommand([LComand]);
end;

class procedure TC4DWizardVsCodeIntegration.InstallGithubCopilot;
begin
  Self.RunCommandInstallExtension('github.copilot');
end;

class procedure TC4DWizardVsCodeIntegration.InstallDelphiLSP;
begin
  Self.RunCommandInstallExtension('embarcaderotechnologies.delphilsp');
end;

class procedure TC4DWizardVsCodeIntegration.RunCommandInstallExtension(const AIdentifierExtension: string);
var
  LComand: string;
begin
  if AIdentifierExtension.Trim.IsEmpty then
    Exit;

  LComand := Format('"code --install-extension %s --force"', [AIdentifierExtension]);
  TC4DWizardProcessDelphi.RunCommand([LComand]);

  TC4DWizardUtils.ShowMsg('Extension installation pushed to VS Code!');
end;

end.
