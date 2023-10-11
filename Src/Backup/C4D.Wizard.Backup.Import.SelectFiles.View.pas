unit C4D.Wizard.Backup.Import.SelectFiles.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TC4DWizardBackupImportSelectFilesView = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnConfirm: TButton;
    Panel9: TPanel;
    Bevel1: TBevel;
    ckGeneralSettings: TCheckBox;
    ckGroups: TCheckBox;
    ckOpenExternalPath: TCheckBox;
    ckReopenFileHistory: TCheckBox;
    ckDefaultFilesInOpeningProject: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  C4DWizardBackupImportSelectFilesView: TC4DWizardBackupImportSelectFilesView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}


procedure TC4DWizardBackupImportSelectFilesView.FormCreate(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardBackupImportSelectFilesView, Self);
end;

procedure TC4DWizardBackupImportSelectFilesView.FormShow(Sender: TObject);
begin
  ckGeneralSettings.Checked := ckGeneralSettings.Enabled;
  ckDefaultFilesInOpeningProject.Checked := ckDefaultFilesInOpeningProject.Enabled;
  ckOpenExternalPath.Checked := ckOpenExternalPath.Enabled;
  ckReopenFileHistory.Checked := ckReopenFileHistory.Enabled;
  ckGroups.Checked := ckGroups.Enabled;
end;

procedure TC4DWizardBackupImportSelectFilesView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      Self.Close;
  end;
end;

procedure TC4DWizardBackupImportSelectFilesView.btnCancelClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardBackupImportSelectFilesView.btnConfirmClick(Sender: TObject);
begin
  if(not ckGeneralSettings.Checked)
    and(not ckDefaultFilesInOpeningProject.Checked)
    and(not ckOpenExternalPath.Checked)
    and(not ckReopenFileHistory.Checked)
    and(not ckGroups.Checked)
  then
    TC4DWizardUtils.ShowMsgAndAbort('Select at least one option');

  Self.Close;
  Self.ModalResult := mrOk;
end;

end.
