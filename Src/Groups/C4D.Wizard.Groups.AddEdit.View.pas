unit C4D.Wizard.Groups.AddEdit.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  C4D.Wizard.Groups;

type
  TC4DWizardGroupsAddEditView = class(TForm)
    Panel1: TPanel;
    btnConfirm: TButton;
    btnClose: TButton;
    Panel9: TPanel;
    Label1: TLabel;
    Bevel1: TBevel;
    edtName: TEdit;
    ckDefault: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FC4DWizardGroups: TC4DWizardGroups;
  public
    property C4DWizardGroups: TC4DWizardGroups read FC4DWizardGroups write FC4DWizardGroups;
  end;

var
  C4DWizardGroupsAddEditView: TC4DWizardGroupsAddEditView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}


procedure TC4DWizardGroupsAddEditView.FormCreate(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardGroupsAddEditView, Self);
end;

procedure TC4DWizardGroupsAddEditView.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TC4DWizardGroupsAddEditView.FormShow(Sender: TObject);
begin
  edtName.Text := FC4DWizardGroups.Name;
  ckDefault.Checked := FC4DWizardGroups.DefaultGroup;
  edtName.SetFocus;
end;

procedure TC4DWizardGroupsAddEditView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardGroupsAddEditView.btnConfirmClick(Sender: TObject);
begin
  if(Trim(edtName.Text).IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('No informed name group', edtName);

  FC4DWizardGroups.Name := edtName.Text;
  FC4DWizardGroups.DefaultGroup := ckDefault.Checked;
  Self.Close;
  Self.ModalResult := mrOK;
end;

procedure TC4DWizardGroupsAddEditView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      btnClose.Click;
  end;
end;

end.
