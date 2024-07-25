unit C4D.Wizard.IDE.ToolBars.Register;

interface

uses
  System.SysUtils,
  System.Classes,
  C4D.Wizard.Utils,
  C4D.Wizard.IDE.ToolBars.Notifier,
  C4D.Wizard.IDE.ToolBars.Build,
  C4D.Wizard.IDE.ToolBars.VsCodeIntegration,
  C4D.Wizard.IDE.ToolBars.Utilities,
  C4D.Wizard.IDE.ToolBars.Branch;

type
  TC4DWizardIDEToolBarsRegister = class
  private
  public
    class procedure Process;
    class procedure ProcessWithThread;
  end;

implementation

class procedure TC4DWizardIDEToolBarsRegister.Process;
begin
  C4D.Wizard.IDE.ToolBars.Notifier.RegisterSelf;
  C4D.Wizard.IDE.ToolBars.Build.RegisterSelf;
  C4D.Wizard.IDE.ToolBars.VsCodeIntegration.RegisterSelf;
  C4D.Wizard.IDE.ToolBars.Utilities.RegisterSelf;
  C4D.Wizard.IDE.ToolBars.Branch.RegisterSelf;
end;

class procedure TC4DWizardIDEToolBarsRegister.ProcessWithThread;
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Sleep(200);
      TThread.Synchronize(TThread.CurrenTThread,
        procedure
        begin
          Self.Process;
        end);
    end).Start;
end;

end.
