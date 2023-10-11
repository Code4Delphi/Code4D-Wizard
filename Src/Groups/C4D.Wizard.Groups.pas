unit C4D.Wizard.Groups;

interface

type
  TC4DWizardGroups = class
  private
    FGuid: string;
    FName: string;
    FFixedSystem: Boolean;
    FDefaultGroup: Boolean;
  public
    property Guid: string read FGuid write FGuid;
    property Name: string read FName write FName;
    property FixedSystem: Boolean read FFixedSystem write FFixedSystem;
    property DefaultGroup: Boolean read FDefaultGroup write FDefaultGroup;
    procedure Clear;
    constructor Create;
  end;

implementation

constructor TC4DWizardGroups.Create;
begin
  Self.Clear;
end;

procedure TC4DWizardGroups.Clear;
begin
  FGuid := '';
  FName := '';
  FFixedSystem := False;
  FDefaultGroup := False;
end;

end.
