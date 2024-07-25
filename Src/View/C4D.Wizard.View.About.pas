unit C4D.Wizard.View.About;

interface

uses
  System.Classes,
  System.SysUtils,
  ToolsAPI,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Vcl.Dialogs,
  Winapi.Windows,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

type
  TC4DWizardViewAbout = class(TForm)
    pnBody: TPanel;
    Bevel1: TBevel;
    mmMensagem: TMemo;
    Panel2: TPanel;
    pnBackSite: TPanel;
    lbSiteCode4Delphi: TLabel;
    imgLogoC4D: TImage;
    pnBackGithub: TPanel;
    lbGitHubCode4Delphi: TLabel;
    imgGithub: TImage;
    pnButtons: TPanel;
    btnOK: TButton;
    btnTeste: TButton;
    Panel1: TPanel;
    lbDonateToCode4Delphi: TLabel;
    imgDonate: TImage;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbSiteCode4DelphiClick(Sender: TObject);
    procedure lbSiteCode4DelphiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lbSiteCode4DelphiMouseLeave(Sender: TObject);
    procedure lbGitHubCode4DelphiClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
    procedure lbDonateToCode4DelphiClick(Sender: TObject);
  private

  public

  end;

var
  C4DWizardViewAbout: TC4DWizardViewAbout;

implementation

{$R *.dfm}


procedure TC4DWizardViewAbout.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardViewAbout, Self);
end;

procedure TC4DWizardViewAbout.FormShow(Sender: TObject);
begin
  Self.Caption := 'About Code4Delphi Wizard ' + TC4DConsts.SEMANTIC_VERSION;

  mmMensagem.Lines.Clear;
  mmMensagem.Lines.Add(TC4DConsts.ABOUT_COPY_RIGHT);
  mmMensagem.Lines.Add(TC4DConsts.ABOUT_DESCRIPTION);
  mmMensagem.Lines.Add(TC4DConsts.SEMANTIC_VERSION_LB);
  mmMensagem.Lines.Add(TC4DConsts.WIZARD_LICENSE);
end;

procedure TC4DWizardViewAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
      if(ssAlt in Shift)then
        Key := 0;
    VK_ESCAPE:
      if(Shift = [])then
        btnOK.Click;
  end;
end;

procedure TC4DWizardViewAbout.btnOKClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('http://www.code4delphi.com.br');
end;

procedure TC4DWizardViewAbout.lbGitHubCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('https://github.com/code4delphi');
end;

procedure TC4DWizardViewAbout.lbDonateToCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('https://pag.ae/7ZhEY1xKr');
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiMouseLeave(Sender: TObject);
begin
  //*SEVERAL
  TLabel(Sender).Font.Color := TC4DWizardUtilsOTA.ActiveThemeColorDefaul;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //*SEVERAL
  TLabel(Sender).Font.Color := clRed;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TC4DWizardViewAbout.btnTesteClick(Sender: TObject);
begin
  //
end;

end.
