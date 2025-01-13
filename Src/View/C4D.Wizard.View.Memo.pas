unit C4D.Wizard.View.Memo;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Winapi.Windows;

type
  TC4DWizardViewMemo = class(TForm)
    pnMemo: TPanel;
    pnButtons: TPanel;
    btnOK: TButton;
    mmMessage: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure mmMessageKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
  protected
  public
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

{$R *.dfm}


procedure TC4DWizardViewMemo.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardViewMemo, Self);
end;

procedure TC4DWizardViewMemo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F4:
      if ssAlt in Shift then
        Key := 0;
    VK_ESCAPE:
      if Shift = [] then
        btnOK.Click;
  end;
end;

procedure TC4DWizardViewMemo.mmMessageKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = $41) and (Shift = [ssCtrl]) then
    mmMessage.SelectAll;
end;

procedure TC4DWizardViewMemo.btnOKClick(Sender: TObject);
begin
  Self.Close;
end;

end.
