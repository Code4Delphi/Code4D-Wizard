unit C4D.Wizard.IDE.Shortcuts;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Menus,
  ToolsAPI,
  C4D.Wizard.LogFile;

type
  TC4DWizardIDEShortcuts = class(TNotifierObject, IOTAKeyboardBinding)
  private
  protected
    function GetBindingType: TBindingType;
    function GetDisplayName: string;
    function GetName: string;
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
  public
    class function New: IOTAKeyboardBinding;
  end;

var
  IndexRegShortcuts: Integer = -1;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Settings.Model,
  C4D.Wizard.Utils.OTA;

procedure RegisterSelf;
begin
  if(IndexRegShortcuts < 0)then
    IndexRegShortcuts := TC4DWizardUtilsOTA.GetIOTAKeyboardServices.AddKeyboardBinding(TC4DWizardIDEShortcuts.New);
end;

class function TC4DWizardIDEShortcuts.New: IOTAKeyboardBinding;
begin
  Result := Self.Create;
end;

function TC4DWizardIDEShortcuts.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TC4DWizardIDEShortcuts.GetDisplayName: string;
begin
  Result := Self.ClassName;
end;

function TC4DWizardIDEShortcuts.GetName: string;
begin
  Result := Self.ClassName;
end;

procedure TC4DWizardIDEShortcuts.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  //BindingServices.AddKeyBinding([ShortCut(Ord('C'), [ssCtrl, ssAlt])], Self.KeyProcUsesOrganization, nil, 0, '', TC4DConsts.MENU_IDE_ORGANIZATION_NAME);
  //BindingServices.AddKeyBinding([TextToShortcut('Ins')], Self.KeyProcInsert, nil);

  {if(C4DWizardSettingsModel.BlockKeyInsert)then
   BindingServices.AddKeyBinding([Shortcut(VK_INSERT, [])], Self.KeyProcInsert, nil);}
end;

{procedure TC4DWizardIDEShortcuts.KeyProcInsert(const Context: IOTAKeyContext; KeyCode: TShortcut; var BindingResult: TKeyBindingResult);
 begin
 //Context.EditBuffer.EditBlock.Copy(False);
 //Context.EditBuffer.TopView.Block.Text

 LogFile.AddLog('**KeyProcInsert**');
 if(not C4DWizardSettingsModel.BlockKeyInsert)then
 begin
 BindingResult := krUnhandled;
 keybd_event(VK_CANCEL, 0, 0, 0);
 LogFile.AddLog(Context.EditBuffer.TopView.GetEditWindow.StatusBar.Panels[2].Text);
 Exit;
 end;

 LogFile.AddLog('ShortCutToText(KeyCode) DEPOIS: ' + ShortCutToText(KeyCode));
 BindingResult := krHandled;
 end; }

initialization

finalization
  if(IndexRegShortcuts >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTAKeyboardServices.RemoveKeyboardBinding(IndexRegShortcuts);
    IndexRegShortcuts := -1;
  end;

end.
