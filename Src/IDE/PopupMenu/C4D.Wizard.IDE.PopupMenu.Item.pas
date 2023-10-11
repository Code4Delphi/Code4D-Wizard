unit C4D.Wizard.IDE.PopupMenu.Item;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Types;

type
  TC4DWizardIDEPopupMenuItem = class(TNotifierObject, IOTALocalMenu, IOTAProjectManagerMenu)
  private
    FCaption: string;
    FIsMultiSelectable: Boolean;
    FChecked: Boolean;
    FEnabled: Boolean;
    FHelpContext: Integer;
    FName: string;
    FParent: string;
    FPosition: Integer;
    FVerb: string;
  protected
    FProject: IOTAProject;
    FOnExecute: TC4DWizardMenuContextList;
    function GetCaption: string;
    function GetChecked: Boolean;
    function GetEnabled: Boolean;
    function GetHelpContext: Integer;
    function GetName: string;
    function GetParent: string;
    function GetPosition: Integer;
    function GetVerb: string;
    procedure SetCaption(const Value: string);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetHelpContext(Value: Integer);
    procedure SetName(const Value: string);
    procedure SetParent(const Value: string);
    procedure SetPosition(Value: Integer);
    procedure SetVerb(const Value: string);
    function GetIsMultiSelectable: Boolean;
    procedure SetIsMultiSelectable(Value: Boolean);
    procedure Execute(const MenuContextList: IInterfaceList); virtual;
    function PreExecute(const MenuContextList: IInterfaceList): Boolean;
    function PostExecute(const MenuContextList: IInterfaceList): Boolean;
  public
    class function New(OnExecute: TC4DWizardMenuContextList): IOTAProjectManagerMenu; overload;
    constructor Create(OnExecute: TC4DWizardMenuContextList); overload;
  end;

implementation

class function TC4DWizardIDEPopupMenuItem.New(OnExecute: TC4DWizardMenuContextList): IOTAProjectManagerMenu;
begin
  Result := Self.Create(OnExecute);
end;

constructor TC4DWizardIDEPopupMenuItem.Create(OnExecute: TC4DWizardMenuContextList);
begin
  FOnExecute := OnExecute;
  FEnabled := True;
  FChecked := False;
  FIsMultiSelectable := False;
end;

procedure TC4DWizardIDEPopupMenuItem.Execute(const MenuContextList: IInterfaceList);
begin
  if(Assigned(FOnExecute))then
    FOnExecute(MenuContextList);
end;

function TC4DWizardIDEPopupMenuItem.GetCaption: string;
begin
  Result := FCaption;
end;

function TC4DWizardIDEPopupMenuItem.GetChecked: Boolean;
begin
  Result := FChecked;
end;

function TC4DWizardIDEPopupMenuItem.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

function TC4DWizardIDEPopupMenuItem.GetHelpContext: Integer;
begin
  Result := FHelpContext;
end;

function TC4DWizardIDEPopupMenuItem.GetIsMultiSelectable: Boolean;
begin
  Result := FIsMultiSelectable;
end;

function TC4DWizardIDEPopupMenuItem.GetName: string;
begin
  Result := FName;
end;

function TC4DWizardIDEPopupMenuItem.GetParent: string;
begin
  Result := FParent;
end;

function TC4DWizardIDEPopupMenuItem.GetPosition: Integer;
begin
  Result := FPosition;
end;

function TC4DWizardIDEPopupMenuItem.GetVerb: string;
begin
  Result := FVerb;
end;

function TC4DWizardIDEPopupMenuItem.PostExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True;
end;

function TC4DWizardIDEPopupMenuItem.PreExecute(const MenuContextList: IInterfaceList): Boolean;
begin
  Result := True;
end;

procedure TC4DWizardIDEPopupMenuItem.SetCaption(const Value: string);
begin
  FCaption := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetChecked(Value: Boolean);
begin
  FChecked := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetEnabled(Value: Boolean);
begin
  FEnabled := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetHelpContext(Value: Integer);
begin
  FHelpContext := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetIsMultiSelectable(Value: Boolean);
begin
  FIsMultiSelectable := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetParent(const Value: string);
begin
  FParent := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetPosition(Value: Integer);
begin
  FPosition := Value;
end;

procedure TC4DWizardIDEPopupMenuItem.SetVerb(const Value: string);
begin
  FVerb := Value;
end;

end.
