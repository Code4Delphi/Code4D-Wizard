unit C4D.Wizard.Register;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Dialogs,
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

procedure register;

implementation

procedure RegisterAll;
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

procedure register;
begin
  RegisterAll;
end;

end.
