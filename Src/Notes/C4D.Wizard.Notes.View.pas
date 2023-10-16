unit C4D.Wizard.Notes.View;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Math,
  System.DateUtils,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  DockForm;

type
  TC4DWizardNotesView = class(TDockableForm)
    procedure FormShow(Sender: TObject);
  private

  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  C4DWizardNotesView: TC4DWizardNotesView;

procedure RegisterSelf;
procedure Unregister;
procedure C4DWizardNotesViewShowDockableForm;

implementation

uses
  C4D.Wizard.Utils.OTA,
  DeskUtil;

{$R *.dfm}

procedure RegisterSelf;
begin
  if(not Assigned(C4DWizardNotesView))then
    C4DWizardNotesView := TC4DWizardNotesView.Create(nil);

  if(@RegisterFieldAddress <> nil)then
    RegisterFieldAddress(C4DWizardNotesView.Name, @C4DWizardNotesView);

  RegisterDesktopFormClass(TC4DWizardNotesView,
    C4DWizardNotesView.Name,
    C4DWizardNotesView.Name);
end;

procedure Unregister;
begin
  if(@UnRegisterFieldAddress <> nil)then
    UnRegisterFieldAddress(@C4DWizardNotesView);
  FreeAndNil(C4DWizardNotesView);
end;

procedure C4DWizardNotesViewShowDockableForm;
begin
  ShowDockableForm(C4DWizardNotesView);
  FocusWindow(C4DWizardNotesView);
end;

{ TC4DWizardNotesView }
constructor TC4DWizardNotesView.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := Name;
  AutoSave := True;
  SaveStateNecessary := True;
end;

procedure TC4DWizardNotesView.FormShow(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardNotesView, Self);
  Self.Constraints.MinWidth := 300;
  Self.Constraints.MinHeight := 300;
end;

initialization

finalization
  Unregister;

end.
