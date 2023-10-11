unit C4D.Wizard.UsesOrganization.ListOfUses;

interface

uses
  System.SysUtils,
  System.Classes,
  C4D.Wizard.Interfaces;

type
  TC4DWizardUsesOrganizationListOfUses = class(TInterfacedObject, IC4DWizardUsesOrganizationListOfUses)
  private
    [weak]
    FParent: IC4DWizardUsesOrganizationParams;
    FEnabled: Boolean;
    FUsesStr: string;
    FStringsFilters: string;
    FList: TStringList;
    FListStringsFilter: TStringList;
    procedure FillList;
    procedure FillListStringsFilter;
  protected
    function Enabled: Boolean; overload;
    function Enabled(const Value: Boolean): IC4DWizardUsesOrganizationListOfUses; overload;
    function List: TStringList;
    function UsesStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
    function StringsFiltersStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
    function StringsFiltersList: TStringList;
    function ContainsValue(const Value: string): Boolean;
    function End_: IC4DWizardUsesOrganizationParams;
  public
    class function New(const AParent: IC4DWizardUsesOrganizationParams): IC4DWizardUsesOrganizationListOfUses;
    constructor Create(const AParent: IC4DWizardUsesOrganizationParams);
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils;

class function TC4DWizardUsesOrganizationListOfUses.New(const AParent: IC4DWizardUsesOrganizationParams): IC4DWizardUsesOrganizationListOfUses;
begin
  Result := Self.Create(AParent);
end;

constructor TC4DWizardUsesOrganizationListOfUses.Create(const AParent: IC4DWizardUsesOrganizationParams);
begin
  FParent := AParent;
  FList := TStringList.Create;
  FListStringsFilter := TStringList.Create;
  FUsesStr := '';
  FStringsFilters := '';
end;

destructor TC4DWizardUsesOrganizationListOfUses.Destroy;
begin
  FListStringsFilter.Free;
  FList.Free;
  inherited;
end;

function TC4DWizardUsesOrganizationListOfUses.Enabled: Boolean;
begin
  Result := FEnabled;
end;

function TC4DWizardUsesOrganizationListOfUses.Enabled(const Value: Boolean): IC4DWizardUsesOrganizationListOfUses;
begin
  Result := Self;
  FEnabled := Value;
end;

function TC4DWizardUsesOrganizationListOfUses.UsesStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
begin
  Result := Self;
  FUsesStr := Value.Trim;
  Self.FillList;
end;

procedure TC4DWizardUsesOrganizationListOfUses.FillList;
begin
  FList.Clear;
  TC4DWizardUtils.ExplodeList(FUsesStr, ',', FList);
end;

function TC4DWizardUsesOrganizationListOfUses.StringsFiltersStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
begin
  Result := Self;
  FStringsFilters := Value.Trim;
  Self.FillListStringsFilter;
end;

function TC4DWizardUsesOrganizationListOfUses.StringsFiltersList: TStringList;
begin
  Result := FListStringsFilter;
end;

procedure TC4DWizardUsesOrganizationListOfUses.FillListStringsFilter;
begin
  FListStringsFilter.Clear;
  TC4DWizardUtils.ExplodeList(FStringsFilters, ',', FListStringsFilter);
end;

function TC4DWizardUsesOrganizationListOfUses.List: TStringList;
begin
  Result := FList;
end;

function TC4DWizardUsesOrganizationListOfUses.ContainsValue(const Value: string): Boolean;
begin
  Result := False;
  if(FList.Count < 0)then
    Exit;

  Result := FList.IndexOf(Value) >= 0;
end;

function TC4DWizardUsesOrganizationListOfUses.End_: IC4DWizardUsesOrganizationParams;
begin
  Result := FParent;
end;

end.
