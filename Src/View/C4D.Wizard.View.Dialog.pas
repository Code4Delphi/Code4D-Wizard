unit C4D.Wizard.View.Dialog;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  Vcl.Dialogs,
  C4D.Wizard.Types,
  Vcl.ClipBrd,
  Vcl.Menus,
  System.ImageList;

type
  TC4DWizardViewDialog = class(TForm)
    pnButtons: TPanel;
    btnOK: TButton;
    pnTop: TPanel;
    pnDetailsLabel: TPanel;
    pnDetails: TPanel;
    mmDetails: TMemo;
    lbViewDetails: TLabel;
    btnCancel: TButton;
    pnImg: TPanel;
    ImageList1: TImageList;
    imgImageMsg: TImage;
    Panel1: TPanel;
    lbMsg: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lbViewDetails02: TLabel;
    PopupMenu1: TPopupMenu;
    Copy1: TMenuItem;
    N1: TMenuItem;
    ShowAll1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbViewDetailsClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure ShowAll1Click(Sender: TObject);
  private
    FMsg: string;
    FDetails: string;
    FButtons: TC4DButtons;
    FIcon: TC4DWizardIcon;
    FBtnFocu: TC4DBtnFocu;
    procedure DefaultValues;
    procedure ConfHeightForm;
    procedure ConfButtons;
  public
    property Msg: string write FMsg;
    property Details: string write FDetails;
    property Icon: TC4DWizardIcon write FIcon;
    property Buttons: TC4DButtons write FButtons;
    property BtnFocu: TC4DBtnFocu write FBtnFocu;
  end;

var
  C4DWizardViewDialog: TC4DWizardViewDialog;

implementation

uses
  C4D.Wizard.Utils.OTA;

{$R *.dfm}

procedure TC4DWizardViewDialog.FormCreate(Sender: TObject);
begin
  Self.DefaultValues;
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardViewDialog, Self);
  Self.Constraints.MinHeight := pnTop.Height + (pnButtons.Height * 2) + 3;
  Self.Constraints.MinWidth := Self.Width;
end;

procedure TC4DWizardViewDialog.FormShow(Sender: TObject);
begin
  imgImageMsg.Picture := nil;
  ImageList1.GetIcon(Integer(FIcon), imgImageMsg.Picture.Icon);

  Self.ModalResult := mrCancel;
  Self.ConfButtons;
  lbMsg.Caption := FMsg;
  mmDetails.Visible := False;
  mmDetails.Lines.Clear;
  mmDetails.Lines.Add(FDetails);
  Self.ConfHeightForm;
end;

procedure TC4DWizardViewDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.DefaultValues;
end;

procedure TC4DWizardViewDialog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
    begin
      if(btnCancel.Visible)then
        btnCancel.Click
      else
        Self.Close;
    end;
  end;
end;

procedure TC4DWizardViewDialog.DefaultValues;
begin
  FMsg := '';
  FDetails := '';
  FButtons := TC4DButtons.OK;
  FIcon := TC4DWizardIcon.Information;
end;

procedure TC4DWizardViewDialog.ConfHeightForm;
begin
  pnDetailsLabel.Visible := True;
  pnDetails.Visible := True;
  if(FDetails.Trim.IsEmpty)then
  begin
    pnDetailsLabel.Visible := False;
    pnDetails.Visible := False;
  end;
  Self.Height := 0;
end;

procedure TC4DWizardViewDialog.Copy1Click(Sender: TObject);
begin
  Clipboard.AsText := lbMsg.Caption;
end;

procedure TC4DWizardViewDialog.ConfButtons;
begin
  btnCancel.Visible := FButtons = TC4DButtons.OK_Cancel;
  btnOK.SetFocus;
  if(btnCancel.Visible)and(FBtnFocu = TC4DBtnFocu.Cancel)then
    btnCancel.SetFocus;
end;

procedure TC4DWizardViewDialog.lbViewDetailsClick(Sender: TObject);
begin
  try
    if(mmDetails.Visible)then
    begin
      mmDetails.Visible := False;
      lbViewDetails02.Caption := '>>';
      Self.Height := Self.Constraints.MinHeight;
    end
    else
    begin
      mmDetails.Visible := True;
      lbViewDetails02.Caption := '<<';
      Self.Height := Self.Constraints.MinHeight * 2;
    end;
  except
  end;
  Self.Refresh;
  Self.Repaint;
end;

procedure TC4DWizardViewDialog.ShowAll1Click(Sender: TObject);
begin
   ShowMessage(lbMsg.Caption);
end;

procedure TC4DWizardViewDialog.btnCancelClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardViewDialog.btnOKClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrOK;
end;

end.
