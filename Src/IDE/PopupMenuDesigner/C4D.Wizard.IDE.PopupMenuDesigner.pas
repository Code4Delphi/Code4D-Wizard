unit C4D.Wizard.IDE.PopupMenuDesigner;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  Vcl.Dialogs,
  DesignIntf,
  DesignMenus;

type
  TC4DWizardIDEPopupMenuDesigner = class(TBaseSelectionEditor, ISelectionEditor)
  private
  protected
    procedure ExecuteVerb(Index: Integer; const List: IDesignerSelections);
    function GetVerb(Index: Integer): string;
    function GetVerbCount: Integer;
    procedure PrepareItem(Index: Integer; const AItem: IMenuItem);
    procedure RequiresUnits(Proc: TGetStrProc);
  public
  end;

implementation

uses
  C4D.Wizard.IDE.PopupMenuDesigner.ComponentSel;

procedure TC4DWizardIDEPopupMenuDesigner.ExecuteVerb(Index: Integer; const List: IDesignerSelections);
begin

end;

function TC4DWizardIDEPopupMenuDesigner.GetVerb(Index: Integer): string;
begin
  Result := 'C4D Wizard Editor Menu';
end;

function TC4DWizardIDEPopupMenuDesigner.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TC4DWizardIDEPopupMenuDesigner.PrepareItem(Index: Integer; const AItem: IMenuItem);
begin
  AItem.Visible := True;
  TC4DWizardIDEPopupMenuDesignerComponentSel.AddSubItems(AItem);
  //AItem.AddLine();
  //AItem.AddItem('SubItem 05', TextToShortCut(''), False, True);
end;

procedure TC4DWizardIDEPopupMenuDesigner.RequiresUnits(Proc: TGetStrProc);
begin

end;

initialization
  RegisterSelectionEditor(TComponent, TC4DWizardIDEPopupMenuDesigner);

finalization

end.
