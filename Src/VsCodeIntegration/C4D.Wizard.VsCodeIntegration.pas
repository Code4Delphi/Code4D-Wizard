unit C4D.Wizard.VsCodeIntegration;

interface

uses
  System.SysUtils,
  ToolsAPI;

type
  TC4DWizardVsCodeIntegration = class
  private
  public
    class procedure Open;
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
    TC4DWizardUtils.ShowMsgAndAbort('Interface (IOTASourceEditor) not supported by current module');

  LIOTAEditView := LIOTASourceEditor.GetEditView(0);
  if LIOTAEditView = nil then
    TC4DWizardUtils.ShowMsgAndAbort('Editor view cannot be located');

  LFileNameModule := LIOTAModule.FileName;

  LIOTAProject := LIOTAModuleServices.GetActiveProject;
  if LIOTAProject = nil then
    TC4DWizardUtils.ShowMsgAndAbort('No active projects were found');
  LFilePathProject := ExtractFilePath(LIOTAProject.FileName);

  TC4DWizardUtilsOTA.SaveAllModifiedModules;

  LCursorPos := LIOTAEditView.CursorPos;

  //REFERENCE: https://code.visualstudio.com/docs/editor/command-line
  LComand := Format('"code -r %s -g %s:%d:%d"', [LFilePathProject, LFileNameModule, LCursorPos.Line, LCursorPos.Col]);
  TC4DWizardProcessDelphi.RunCommand([LComand]);
end;

class procedure TC4DWizardVsCodeIntegration.InstallDelphiLSP;
var
  LComand: string;
begin
  LComand := Format('"code --install-extension %s --force"', ['embarcaderotechnologies.delphilsp']);
  TC4DWizardProcessDelphi.RunCommand([LComand]);
end;

end.