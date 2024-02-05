unit C4D.Wizard.OpenExternal;

interface

uses
  C4D.Wizard.Types;

type
  TC4DWizardOpenExternal = class
  private
    FGuid: string;
    FDescription: string;
    FPath: string;
    FParameters: string;
    FKind: TC4DWizardOpenExternalKind;
    FOrder: Integer;
    FShortcut: string;
    FVisible: Boolean;
    FVisibleInToolBarUtilities: Boolean;
    FIconHas: Boolean;
    FGuidMenuMaster: string;
    FCreated: Boolean;
  public
    property Guid: string read FGuid write FGuid;
    property Description: string read FDescription write FDescription;
    property Path: string read FPath write FPath;
    property Parameters: string read FParameters write FParameters;
    property Kind: TC4DWizardOpenExternalKind read FKind write FKind;
    property Order: Integer read FOrder write FOrder;
    property Shortcut: string read FShortcut write FShortcut;
    property Visible: Boolean read FVisible write FVisible;
    property VisibleInToolBarUtilities: Boolean read FVisibleInToolBarUtilities write FVisibleInToolBarUtilities;
    property IconHas: Boolean read FIconHas write FIconHas;
    property GuidMenuMaster: string read FGuidMenuMaster write FGuidMenuMaster;
    property Created: Boolean read FCreated write FCreated;
    procedure Clear;
    constructor Create;
  end;

implementation

constructor TC4DWizardOpenExternal.Create;
begin
  Self.Clear;
end;

procedure TC4DWizardOpenExternal.Clear;
begin
  FGuid := '';
  FDescription := '';
  FPath := '';
  FParameters := '';
  FKind := TC4DWizardOpenExternalKind.None;
  FOrder := 0;
  FShortcut := '';
  FVisible := False;
  FVisibleInToolBarUtilities := False;
  FIconHas := False;
  FGuidMenuMaster := '';
  FCreated := False;
end;

end.
