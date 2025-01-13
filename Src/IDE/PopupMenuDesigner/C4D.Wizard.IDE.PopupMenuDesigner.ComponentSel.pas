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
    class procedure AddItem(const AItem: IMenuItem; const ACaption: WideString;
      const AName: string = ''; AOnClick: TNotifyEvent = nil);
    class procedure CopyDataFieldsClick(Sender: TObject);
    class procedure CopyDataFields;
  public
    class procedure AddSubItems(const AItem: IMenuItem);
    class procedure CopyNames;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.AddSubItems(const AItem: IMenuItem);
begin
  Self.AddItem(AItem, 'Copy names of selected components', 'C4DWizardNamesComponentSel1', Self.CopyNamesClick);
  Self.AddItem(AItem, 'Copy DataField of selected components', 'C4DWizardDataFieldComponentSel1', Self.CopyDataFieldsClick);
end;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.AddItem(const AItem: IMenuItem; const ACaption: WideString;
  const AName: string = ''; AOnClick: TNotifyEvent = nil);
begin
  AItem.AddItem(ACaption, TextToShortCut(''), False, True, AOnClick, 0, AName);
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
  LNameComponent: String;
  LSelCount: Integer;
begin
  LIOTAModule := (BorlandIDEServices as IOTAModuleServices).CurrentModule;
  if not Assigned(LIOTAModule) then
    Exit;

  LIOTAFormEditor := TC4DWizardUtilsOTA.GetIOTAFormEditor(LIOTAModule);
  if not Assigned(LIOTAFormEditor) then
    Exit;

  LStrList := TStringList.Create;
  try
    for LSelCount := 0 to Pred(LIOTAFormEditor.GetSelCount) do
    begin
      LIOTAComponent := LIOTAFormEditor.GetSelComponent(LSelCount);
      LIOTAComponent.GetPropValueByName('Name', LNameComponent);
      LStrList.Add(LNameComponent);
    end;

    if not Trim(LStrList.Text).IsEmpty then
      Clipboard.AsText := LStrList.Text;
  finally
    LStrList.Free;
  end;
end;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.CopyDataFieldsClick(Sender: TObject);
begin
  Self.CopyDataFields;
end;

class procedure TC4DWizardIDEPopupMenuDesignerComponentSel.CopyDataFields;
var
  LIOTAModule: IOTAModule;
  LIOTAFormEditor: IOTAFormEditor;
  LIOTAComponent: IOTAComponent;
  LStrList: TStringList;
  LNameComponent: String;
  LSelCount: Integer;
begin
  LIOTAModule := (BorlandIDEServices as IOTAModuleServices).CurrentModule;
  if not Assigned(LIOTAModule) then
    Exit;

  LIOTAFormEditor := TC4DWizardUtilsOTA.GetIOTAFormEditor(LIOTAModule);
  if not Assigned(LIOTAFormEditor) then
    Exit;

  LStrList := TStringList.Create;
  try
    for LSelCount := 0 to Pred(LIOTAFormEditor.GetSelCount) do
    begin
      LIOTAComponent := LIOTAFormEditor.GetSelComponent(LSelCount);
      LIOTAComponent.GetPropValueByName('DataField', LNameComponent);
      if not LNameComponent.Trim.IsEmpty then
        LStrList.Add(LNameComponent);
    end;

    if not Trim(LStrList.Text).IsEmpty then
      Clipboard.AsText := LStrList.Text;
  finally
    LStrList.Free;
  end;
end;

end.
