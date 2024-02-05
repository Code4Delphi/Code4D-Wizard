unit C4D.Wizard.IDE.PopupMenuDesigner.ComponentSel;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  Vcl.Dialogs,
  Vcl.ClipBrd,
  ToolsAPI,
  DesignMenus;

type
  TC4DWizardIDEPopupMenuDesignerComponentSel = class
  private
    class procedure CopyNamesClick(Sender: TObject);
  public
    class procedure AddSubItems(const AItem: IMenuItem);
    class procedure CopyNames;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.AddSubItems(const AItem: IMenuItem);
begin
  AItem.AddItem('Copy names of selected components', TextToShortCut(''), False, True, Self.CopyNamesClick, 0, 'C4DWizardIDEPopupMenuDesignerComponentSel1');
end;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.CopyNamesClick(Sender: TObject);
begin
  Self.CopyNames;
end;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.CopyNames;
var
  LIOTAModule: IOTAModule;
  LIOTAFormEditor: IOTAFormEditor;
  LIOTAComponent: IOTAComponent;
  LStrList: TStringList;
  LNomeComponente: String;
  LSelCount: Integer;
begin
  LIOTAModule := (BorlandIDEServices as IOTAModuleServices).CurrentModule;
  if(not Assigned(LIOTAModule))then
    Exit;

  LIOTAFormEditor := TC4DWizardUtilsOTA.GetIOTAFormEditor(LIOTAModule);
  if(not Assigned(LIOTAFormEditor))then
    Exit;

  LStrList := TStringList.Create;
  try
    for LSelCount := 0 to Pred(LIOTAFormEditor.GetSelCount) do
    begin
      LIOTAComponent := LIOTAFormEditor.GetSelComponent(LSelCount);
      LIOTAComponent.GetPropValueByName('Name', LNomeComponente);
      LStrList.Add(LNomeComponente)
    end;

    Clipboard.AsText := LStrList.Text;
  finally
    LStrList.Free;
  end;
end;

end.
