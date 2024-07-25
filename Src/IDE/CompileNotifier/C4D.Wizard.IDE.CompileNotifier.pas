unit C4D.Wizard.IDE.CompileNotifier;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI;

type
  TC4DWizardIDECompileNotifier = class(TNotifierObject, IOTACompileNotifier)
  private
  protected
    procedure ProjectCompileStarted(const Project: IOTAProject; Mode: TOTACompileMode);
    procedure ProjectCompileFinished(const Project: IOTAProject; Result: TOTACompileResult);
    procedure ProjectGroupCompileStarted(Mode: TOTACompileMode);
    procedure ProjectGroupCompileFinished(Result: TOTACompileResult);
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Settings.Model,
  C4D.Wizard.ProcessDelphi;

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
    IndexNotifier := TC4DWizardUtilsOTA.GetIOTACompileServices.AddNotifier(TC4DWizardIDECompileNotifier.Create);
end;

constructor TC4DWizardIDECompileNotifier.Create;
begin

end;

destructor TC4DWizardIDECompileNotifier.Destroy;
begin
  inherited;
end;

procedure TC4DWizardIDECompileNotifier.ProjectCompileStarted(const Project: IOTAProject; Mode: TOTACompileMode);
var
  LIOTAProject: IOTAProject;
  LCurrentBinaryPath: string;
  LCommand: string;
begin
  if(not C4DWizardSettingsModel.BeforeCompilingCheckRunning)then
    Exit;

  LIOTAProject := TC4DWizardUtilsOTA.GetCurrentProject;

  if(TC4DWizardUtils.FileNameIsC4DWizardDPROJ(LIOTAProject.FileName))then
    Exit;

  LCurrentBinaryPath := TC4DWizardUtilsOTA.GetBinaryPathCurrent;
  if(FileExists(LCurrentBinaryPath))then
  begin
    if(TC4DWizardUtils.ProcessWindowsExists(ExtractFileName(LCurrentBinaryPath), LCurrentBinaryPath))then
    begin
      if(not TC4DWizardUtils.ShowQuestion2('The application is already running, do you wish to continue (Kills current process)?'))then
        Abort;

      LCommand := 'taskkill /f /IM ' + ExtractFileName(Project.ProjectOptions.TargetName);
      TC4DWizardProcessDelphi.RunCommand([LCommand]);
      Sleep(1000);
    end;
  end;
end;

procedure TC4DWizardIDECompileNotifier.ProjectCompileFinished(const Project: IOTAProject; Result: TOTACompileResult);
begin

end;

procedure TC4DWizardIDECompileNotifier.ProjectGroupCompileStarted(Mode: TOTACompileMode);
begin

end;

procedure TC4DWizardIDECompileNotifier.ProjectGroupCompileFinished(Result: TOTACompileResult);
begin

end;

initialization

finalization
  if(IndexNotifier >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTACompileServices.RemoveNotifier(IndexNotifier);
    IndexNotifier := -1;
  end;

end.
