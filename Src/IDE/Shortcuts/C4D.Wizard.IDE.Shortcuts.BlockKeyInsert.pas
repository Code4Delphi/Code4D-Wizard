unit C4D.Wizard.IDE.Shortcuts.BlockKeyInsert;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Menus,
  ToolsAPI,
  C4D.Wizard.LogFile;

type
  TC4DWizardIDEShortcutsBlockKeyInsert = class(TNotifierObject, IOTAKeyboardBinding)
  private
    procedure KeyProcBlockInsert(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
  protected
    function GetBindingType: TBindingType;
    function GetDisplayName: string;
    function GetName: string;
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
  public
    class function New: IOTAKeyboardBinding;
    constructor Create;
    destructor Destroy; override;
  end;

procedure RefreshRegister;

implementation

uses
  C4D.Wizard.Settings.Model,
  C4D.Wizard.Utils.OTA;

var
  Index: Integer = -1;

procedure RegisterSelf;
begin
  if(Index < 0)and(C4DWizardSettingsModel.BlockKeyInsert)then
    Index := TC4DWizardUtilsOTA.GetIOTAKeyboardServices.AddKeyboardBinding(TC4DWizardIDEShortcutsBlockKeyInsert.New);
end;

procedure UnRegisterSelf;
begin
  if(Index >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTAKeyboardServices.RemoveKeyboardBinding(Index);
    Index := -1;
  end;
end;

procedure RefreshRegister;
begin
  UnRegisterSelf;
  RegisterSelf;
end;

class function TC4DWizardIDEShortcutsBlockKeyInsert.New: IOTAKeyboardBinding;
begin
  Result := Self.Create;
end;

constructor TC4DWizardIDEShortcutsBlockKeyInsert.Create;
begin

end;

destructor TC4DWizardIDEShortcutsBlockKeyInsert.Destroy;
begin
  inherited;
end;

function TC4DWizardIDEShortcutsBlockKeyInsert.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TC4DWizardIDEShortcutsBlockKeyInsert.GetDisplayName: string;
begin
  Result := Self.ClassName;
end;

function TC4DWizardIDEShortcutsBlockKeyInsert.GetName: string;
begin
  Result := Self.ClassName;
end;

procedure TC4DWizardIDEShortcutsBlockKeyInsert.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  if(C4DWizardSettingsModel.BlockKeyInsert)then
    BindingServices.AddKeyBinding([Shortcut(VK_INSERT, [])], Self.KeyProcBlockInsert, nil);
end;

procedure TC4DWizardIDEShortcutsBlockKeyInsert.KeyProcBlockInsert(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
begin
  if(C4DWizardSettingsModel.BlockKeyInsert)then
    BindingResult := krHandled
  else
    BindingResult := krUnhandled;
end;

initialization

finalization
  UnRegisterSelf;

end.
