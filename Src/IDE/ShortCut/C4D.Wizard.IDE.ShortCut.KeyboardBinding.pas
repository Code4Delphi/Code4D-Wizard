unit C4D.Wizard.IDE.ShortCut.KeyboardBinding;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  ToolsAPI;

type
  TC4DWizardIDEShortCutKeyboardBinding = class(TNotifierObject, IOTAKeyboardBinding)
  private
    procedure SelectedComponents(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
  protected
    function GetBindingType: TBindingType;
    function GetDisplayName: string;
    function GetName: string;
    procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
  public
    class function New: IOTAKeyboardBinding;
  end;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.IDE.PopupMenuDesigner.ComponentSel;

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
    IndexNotifier := (BorlandIDEServices as IOTAKeyboardServices)
      .AddKeyboardBinding(TC4DWizardIDEShortCutKeyboardBinding.New);
end;

class function TC4DWizardIDEShortCutKeyboardBinding.New: IOTAKeyboardBinding;
begin
  Result := Self.Create;
end;

procedure TC4DWizardIDEShortCutKeyboardBinding.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
begin
  BindingServices.AddKeyBinding([TextToShortCut('Ctrl+Shift+Alt+A')], SelectedComponents, nil, 0, '', 'C4DWizardIDEPopupMenuDesignerComponentSel1'); //[ShortCut(Ord('A'), [ssCtrl, ssShift, ssAlt])]
end;

procedure TC4DWizardIDEShortCutKeyboardBinding.SelectedComponents(const Context: IOTAKeyContext; KeyCode: TShortCut;
  var BindingResult: TKeyBindingResult);
begin
  //TC4DWizardUtils.ShowMsg('ShortCutKeyboardBinding');
  TC4DWizardIDEPopupMenuDesignerComponentSel.CopyNames;
  BindingResult := krHandled;
end;

function TC4DWizardIDEShortCutKeyboardBinding.GetBindingType: TBindingType;
begin
  Result := btPartial;
end;

function TC4DWizardIDEShortCutKeyboardBinding.GetDisplayName: string;
begin
  Result := Self.ClassName;
end;

function TC4DWizardIDEShortCutKeyboardBinding.GetName: string;
begin
  Result := Self.ClassName;
end;

initialization

finalization
  if(IndexNotifier >= 0)then
    (BorlandIDEServices as IOTAKeyboardServices).RemoveKeyboardBinding(IndexNotifier);

end.
