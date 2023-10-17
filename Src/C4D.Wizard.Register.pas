unit C4D.Wizard.Register;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Dialogs,
  {$IFDEF C4D_WIZARD_DLL}
  ToolsAPI,
  {$ENDIF}
  C4D.Wizard.IDE.MainMenu.Register,
  C4D.Wizard.IDE.Shortcuts,
  C4D.Wizard.IDE.Shortcuts.BlockKeyInsert,
  C4D.Wizard.IDE.PopupMenu,
  C4D.Wizard.IDE.FileNotification.Notifier,
  C4D.Wizard.Reopen.View,
  C4D.Wizard.Messages.Custom.Groups.OTA,
  C4D.Wizard.IDE.EditServicesNotifier,
  C4D.Wizard.IDE.CompileNotifier,
  C4D.Wizard.IDE.ShortCut.KeyboardBinding,
  C4D.Wizard.Notes.View;

{$IFDEF C4D_WIZARD_DLL}
function RegisterDLL(const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  var Terminate: TWizardTerminateProc): Boolean; stdcall;
{$ELSE}
procedure Register;
{$ENDIF}

implementation

procedure RegistrarAll;
begin
  C4D.Wizard.IDE.MainMenu.Register.RegisterSelf;
  C4D.Wizard.IDE.Shortcuts.BlockKeyInsert.RefreshRegister;
  C4D.Wizard.IDE.PopupMenu.RegisterSelf;
  C4D.Wizard.IDE.FileNotification.Notifier.RegisterSelf;
  C4D.Wizard.Reopen.View.RegisterSelf;
  C4D.Wizard.Messages.Custom.Groups.OTA.RegisterSelf;
  C4D.Wizard.IDE.EditServicesNotifier.RegisterSelf;
  C4D.Wizard.IDE.CompileNotifier.RegisterSelf;
  C4D.Wizard.Notes.View.RegisterSelf;
end;

{$IFDEF C4D_WIZARD_DLL}
procedure FinalizeWizard;
begin
  C4D.Wizard.IDE.MainMenu.Register.UnRegisterSelf;
end;

function RegisterDLL(const BorlandIDEServices: IBorlandIDEServices;
  RegisterProc: TWizardRegisterProc;
  var Terminate: TWizardTerminateProc): Boolean; stdcall;
begin
  Result := Assigned(BorlandIDEServices);
  if(not Result)then
    Exit;

  Terminate := FinalizeWizard;
  RegistrarAll;
end;

{$ELSE}
procedure Register;
begin
  RegistrarAll;
end;
{$ENDIF}

end.
