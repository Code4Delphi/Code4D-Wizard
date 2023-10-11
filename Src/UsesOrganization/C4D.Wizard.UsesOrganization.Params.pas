unit C4D.Wizard.UsesOrganization.Params;

interface

uses
  C4D.Wizard.Interfaces,
  System.Classes,
  System.SysUtils,
  C4D.Wizard.UsesOrganization.ListOfUses;

type
  TC4DWizardUsesOrganizationParams = class(TInterfacedObject, IC4DWizardUsesOrganizationParams)
  private
    [weak]
    FParent: IC4DWizardUsesOrganization;
    FOrderUsesInAlphabeticalOrder: Boolean;
    FOneUsesPerLine: Boolean;
    FOneUsesLineNumColBefore: Integer;
    FMaxCharactersPerLine: Integer;
    FGroupUnitsByNamespaces: Boolean;
    FLineBreakBetweenNamespaces: Boolean;
    FShowMessages: Boolean;
    FUsesToRemoveList: IC4DWizardUsesOrganizationListOfUses;
    FUsesToAddList: IC4DWizardUsesOrganizationListOfUses;
  protected
    function OrderUsesInAlphabeticalOrder: Boolean; overload;
    function OrderUsesInAlphabeticalOrder(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function OneUsesPerLine: Boolean; overload;
    function OneUsesPerLine(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function OneUsesLineNumColBefore: Integer; overload;
    function OneUsesLineNumColBefore(Value: Integer): IC4DWizardUsesOrganizationParams; overload;
    function MaxCharactersPerLine: Integer; overload;
    function MaxCharactersPerLine(Value: Integer): IC4DWizardUsesOrganizationParams; overload;
    function GroupUnitsByNamespaces: Boolean; overload;
    function GroupUnitsByNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function LineBreakBetweenNamespaces: Boolean; overload;
    function LineBreakBetweenNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function UsesToRemoveList: IC4DWizardUsesOrganizationListOfUses;
    function UsesToAddList: IC4DWizardUsesOrganizationListOfUses;
    function ShowMessages: Boolean; overload;
    function ShowMessages(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function End_: IC4DWizardUsesOrganization;
  public
    class function New(AParent: IC4DWizardUsesOrganization): IC4DWizardUsesOrganizationParams;
    constructor Create(AParent: IC4DWizardUsesOrganization);
    destructor Destroy; override;
  end;

implementation

class function TC4DWizardUsesOrganizationParams.New(AParent: IC4DWizardUsesOrganization): IC4DWizardUsesOrganizationParams;
begin
  Result := Self.Create(AParent);
end;

constructor TC4DWizardUsesOrganizationParams.Create(AParent: IC4DWizardUsesOrganization);
begin
  FParent := AParent;
  FUsesToRemoveList := TC4DWizardUsesOrganizationListOfUses.New(Self);
  FUsesToAddList := TC4DWizardUsesOrganizationListOfUses.New(Self);
  FOrderUsesInAlphabeticalOrder := False;
  FOneUsesPerLine := True;
  FOneUsesLineNumColBefore := 2;
  FMaxCharactersPerLine := 90;
  FGroupUnitsByNamespaces := False;
  FLineBreakBetweenNamespaces := False;
  FShowMessages := True;
end;

destructor TC4DWizardUsesOrganizationParams.Destroy;
begin
  inherited;
end;

function TC4DWizardUsesOrganizationParams.OrderUsesInAlphabeticalOrder: Boolean;
begin
  Result := FOrderUsesInAlphabeticalOrder;
end;

function TC4DWizardUsesOrganizationParams.OrderUsesInAlphabeticalOrder(Value: Boolean): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FOrderUsesInAlphabeticalOrder := Value;
end;

function TC4DWizardUsesOrganizationParams.OneUsesPerLine: Boolean;
begin
  Result := FOneUsesPerLine;
end;

function TC4DWizardUsesOrganizationParams.OneUsesPerLine(Value: Boolean): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FOneUsesPerLine := Value;
end;

function TC4DWizardUsesOrganizationParams.OneUsesLineNumColBefore: Integer;
begin
  Result := FOneUsesLineNumColBefore;
end;

function TC4DWizardUsesOrganizationParams.OneUsesLineNumColBefore(Value: Integer): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FOneUsesLineNumColBefore := Value;
end;

function TC4DWizardUsesOrganizationParams.MaxCharactersPerLine: Integer;
begin
  Result := FMaxCharactersPerLine;
end;

function TC4DWizardUsesOrganizationParams.MaxCharactersPerLine(Value: Integer): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FMaxCharactersPerLine := Value;
end;

function TC4DWizardUsesOrganizationParams.GroupUnitsByNamespaces: Boolean;
begin
  Result := FGroupUnitsByNamespaces;
end;

function TC4DWizardUsesOrganizationParams.GroupUnitsByNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FGroupUnitsByNamespaces := Value;
end;

function TC4DWizardUsesOrganizationParams.LineBreakBetweenNamespaces: Boolean;
begin
  Result := FLineBreakBetweenNamespaces;
end;

function TC4DWizardUsesOrganizationParams.LineBreakBetweenNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FLineBreakBetweenNamespaces := Value;
end;

function TC4DWizardUsesOrganizationParams.UsesToRemoveList: IC4DWizardUsesOrganizationListOfUses;
begin
  Result := FUsesToRemoveList;
end;

function TC4DWizardUsesOrganizationParams.UsesToAddList: IC4DWizardUsesOrganizationListOfUses;
begin
  Result := FUsesToAddList;
end;

function TC4DWizardUsesOrganizationParams.ShowMessages: Boolean;
begin
  Result := FShowMessages;
end;

function TC4DWizardUsesOrganizationParams.ShowMessages(Value: Boolean): IC4DWizardUsesOrganizationParams;
begin
  Result := Self;
  FShowMessages := Value;
end;

function TC4DWizardUsesOrganizationParams.End_: IC4DWizardUsesOrganization;
begin
  Result := FParent;
end;

end.
