unit C4D.Wizard.Translate.View;

interface

uses
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Threading,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.OleCtrls,
  SHDocVw,
  Vcl.ClipBrd,
  System.ImageList,
  Vcl.ImgList;

type
  TC4DWizardTranslateView = class(TForm)
    pnTop: TPanel;
    bevelOrigin: TBevel;
    mmOrigin: TMemo;
    Splitter1: TSplitter;
    pnBody: TPanel;
    mmDestiny: TMemo;
    Panel1: TPanel;
    btnTranslate: TButton;
    btnOpenInGoogleTranslate: TButton;
    cBoxLanguageDestiny: TComboBox;
    cBoxLanguageOrigin: TComboBox;
    ImageList1: TImageList;
    btnInvertLanguage: TButton;
    Splitter2: TSplitter;
    Panel4: TPanel;
    btnOriginPaste: TButton;
    btnOriginCut: TButton;
    btnOriginCopy: TButton;
    pnDestiny: TPanel;
    pnDetails: TPanel;
    ListBoxDetails: TListBox;
    Panel2: TPanel;
    btnDestinyPaste: TButton;
    btnDestinyCut: TButton;
    btnDestinyCopy: TButton;
    Panel3: TPanel;
    btnDetailsCopy: TButton;
    pnBackAll: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure mmOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTranslateClick(Sender: TObject);
    procedure btnOpenInGoogleTranslateClick(Sender: TObject);
    procedure btnInvertLanguageClick(Sender: TObject);
    procedure ListBoxDetailsDblClick(Sender: TObject);
    procedure btnOriginCopyClick(Sender: TObject);
    procedure btnOriginCutClick(Sender: TObject);
    procedure btnOriginPasteClick(Sender: TObject);
    procedure btnDestinyCopyClick(Sender: TObject);
    procedure btnDestinyCutClick(Sender: TObject);
    procedure btnDestinyPasteClick(Sender: TObject);
    procedure btnDetailsCopyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FPnWebBrowser: TPanel;
    FWebBrowser: TWebBrowser;
    FStrTranslate: string;
    procedure TaskEnableCommands;
    function GetLink: string;
    procedure ProcessReturnMain;
    procedure ProcessReturnDetails;
    procedure ProcessReturnGenre;
    procedure WebBrowserCreateAndConf;
    procedure DownloadComplete(Sender: TObject);
    procedure CommandStateChange(ASender: TObject; Command: Integer; Enable: WordBool);
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    function StringIsValid(const AStr: string): Boolean;
  public
    property StrTranslate: string read FStrTranslate write FStrTranslate;
  end;

var
  C4DWizardTranslateView: TC4DWizardTranslateView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}

const
  C_URL = 'https://translate.google.com.br/?sl=%s&tl=%s&text=%s&op=translate';
  SC_MAXIMIZE2 = 61490;

procedure TC4DWizardTranslateView.WMSysCommand(var Message: TWMSysCommand);
begin
  inherited;
  if(Message.CmdType = SC_MAXIMIZE)or(Message.CmdType = SC_MAXIMIZE2)then
  begin
    Self.Width := Screen.Width - 50;
    Self.Height := Screen.Height - 100;
    Self.Left := 25;
    Self.Top := 25;
  end
  else
    if(Message.CmdType = SC_MINIMIZE)then
  begin
    Self.Width := Self.Constraints.MinWidth;
    Self.Height := Self.Constraints.MinHeight;
  end;
end;

procedure TC4DWizardTranslateView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardTranslateView, Self);
  Self.WebBrowserCreateAndConf;
end;

procedure TC4DWizardTranslateView.FormDestroy(Sender: TObject);
begin
  FWebBrowser.Free;
  FPnWebBrowser.Free;
end;

procedure TC4DWizardTranslateView.FormShow(Sender: TObject);
begin
  FPnWebBrowser.Visible := False;
  mmOrigin.Lines.Text := FStrTranslate;
  mmOrigin.SetFocus;
  mmDestiny.Lines.Clear;
  if(not mmOrigin.Lines.Text.Trim.IsEmpty)then
    btnTranslate.Click;
end;

procedure TC4DWizardTranslateView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_F6:
    if(Shift = [])then
      btnInvertLanguage.Click;
    VK_ESCAPE:
    if(Shift = [])then
      Self.Close;
    VK_RETURN:
    if(Shift = [ssCtrl])and(btnTranslate.Enabled)then
      btnTranslate.Click;
  end;
end;

procedure TC4DWizardTranslateView.WebBrowserCreateAndConf;
begin
  FPnWebBrowser := TPanel.Create(Self);
  FPnWebBrowser.Parent := Self;
  FWebBrowser := TWebBrowser.Create(nil);
  TWinControl(FWebBrowser).Parent := FPnWebBrowser;
  FWebBrowser.OnCommandStateChange := Self.CommandStateChange;
  FWebBrowser.OnDownloadComplete := Self.DownloadComplete;
end;

procedure TC4DWizardTranslateView.CommandStateChange(ASender: TObject; Command: Integer; Enable: WordBool);
begin
  Self.ProcessReturnDetails;
end;

procedure TC4DWizardTranslateView.DownloadComplete(Sender: TObject);
begin
  Self.ProcessReturnMain;
  //Self.ProcessReturnGenre;
end;

{$REGION 'CopyCutPast'}

procedure TC4DWizardTranslateView.btnOriginCopyClick(Sender: TObject);
begin
  if(not mmOrigin.Lines.Text.Trim.IsEmpty)then
    Clipboard.AsText := mmOrigin.Lines.Text;
end;

procedure TC4DWizardTranslateView.btnOriginCutClick(Sender: TObject);
begin
  if(not mmOrigin.Lines.Text.Trim.IsEmpty)then
    Clipboard.AsText := mmOrigin.Lines.Text;
  mmOrigin.Lines.Clear;
end;

procedure TC4DWizardTranslateView.btnOriginPasteClick(Sender: TObject);
begin
  mmOrigin.SelText := Clipboard.AsText;
end;

procedure TC4DWizardTranslateView.btnDestinyCopyClick(Sender: TObject);
begin
  if(not mmDestiny.Lines.Text.Trim.IsEmpty)then
    Clipboard.AsText := mmDestiny.Lines.Text;
end;

procedure TC4DWizardTranslateView.btnDestinyCutClick(Sender: TObject);
begin
  if(not mmDestiny.Lines.Text.Trim.IsEmpty)then
    Clipboard.AsText := mmDestiny.Lines.Text;
  mmDestiny.Lines.Clear;
end;

procedure TC4DWizardTranslateView.btnDestinyPasteClick(Sender: TObject);
begin
  mmDestiny.SelText := Clipboard.AsText;
end;

procedure TC4DWizardTranslateView.btnDetailsCopyClick(Sender: TObject);
var
  LStrItem: string;
begin
  if(ListBoxDetails.ItemIndex < 0)then
    Exit;
  LStrItem := ListBoxDetails.Items[ListBoxDetails.ItemIndex];
  if(not LStrItem.Trim.IsEmpty)then
    Clipboard.AsText := LStrItem;
end;
{$ENDREGION} //CopyCutPast

procedure TC4DWizardTranslateView.ListBoxDetailsDblClick(Sender: TObject);
begin
  if(TC4DWizardUtils.ShowQuestion('Copy text to clipboard?'))then
    Clipboard.AsText := ListBoxDetails.Items[ListBoxDetails.ItemIndex];
end;

procedure TC4DWizardTranslateView.btnInvertLanguageClick(Sender: TObject);
var
  LOrigin: string;
begin
  LOrigin := cBoxLanguageOrigin.Text;
  cBoxLanguageOrigin.Text := cBoxLanguageDestiny.Text;
  cBoxLanguageDestiny.Text := LOrigin;
end;

procedure TC4DWizardTranslateView.mmOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  //*SEVERAL
  if(Key = $41)and(Shift = [ssCtrl])then
    TMemo(Sender).SelectAll;
end;

function TC4DWizardTranslateView.GetLink: string;
var
  LText: string;
begin
  LText := mmOrigin.Lines.Text
    .Replace(#$D#$A, '%0A', [rfReplaceAll, rfIgnoreCase])
    .Replace(#13#10, '%0A', [rfReplaceAll, rfIgnoreCase])
    .Replace(' ', '%20', [rfReplaceAll, rfIgnoreCase]);
  Result := Format(C_URL, [cBoxLanguageOrigin.Text, cBoxLanguageDestiny.Text, LText]);
end;

procedure TC4DWizardTranslateView.TaskEnableCommands;
begin
  TTask.Run(
    procedure
    begin
      Sleep(3000);
      btnTranslate.Enabled := True;
      Screen.Cursor := crDefault;
    end);
end;

procedure TC4DWizardTranslateView.btnOpenInGoogleTranslateClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink(Self.GetLink);
end;

procedure TC4DWizardTranslateView.btnTranslateClick(Sender: TObject);
begin
  if(mmOrigin.Lines.Text.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('No informed text', mmOrigin);

  btnTranslate.Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    mmDestiny.Lines.Clear;
    ListBoxDetails.Clear;
    FWebBrowser.Navigate(Self.GetLink);
  finally
    Self.TaskEnableCommands;
  end;
end;

procedure TC4DWizardTranslateView.ProcessReturnMain;
const
  C_CLASS_NAME = 'Q4iAWc';
var
  LOleVariant: OleVariant;
  i: Integer;
begin
  try
    mmDestiny.Lines.Clear;
    LOleVariant := FWebBrowser.OleObject.document.getElementsByClassName(C_CLASS_NAME);
    for i := 0 to LOleVariant.Length -1 do
      mmDestiny.Lines.Add(LOleVariant.item(i).innerText);
  except
  end;

  Self.ProcessReturnGenre;

  try
    if(mmDestiny.Lines.Text.Trim.IsEmpty)then
    begin
      LOleVariant := FWebBrowser.OleObject.document.getElementsByClassName('ryNqvb');
      for i := 0 to LOleVariant.Length -1 do
        mmDestiny.Lines.Add(LOleVariant.item(i).innerText);
    end;
  except
  end;
end;

procedure TC4DWizardTranslateView.ProcessReturnDetails;
const
  C_CLASS_NAME = 'ryNqvb'; //'kgnlhe'; //'TKwHGb'
var
  LOleVariant: OleVariant;
  i: Integer;
  LList: TStringList;
  LItem: string;
begin
  try
    ListBoxDetails.Clear;
    LList := TStringList.Create;
    try
      LOleVariant := FWebBrowser.OleObject.document.getElementsByClassName(C_CLASS_NAME);
      for i := 0 to LOleVariant.Length -1 do
      begin
        LItem := LOleVariant.item(i).innerText;
        if(LList.IndexOf(LItem) < 0)then
          LList.Add(LItem);
      end;

      for LItem in LList do
        ListBoxDetails.Items.Add(LItem);
    finally
      LList.Free;
    end;
  except
  end;
end;

procedure TC4DWizardTranslateView.ProcessReturnGenre;
const
  C_CLASS_NAME = 'lRu31'; //lRu31 OU HwtZe
var
  LOleVariant: OleVariant;
  i: Integer;
  LList: TStringList;
  LItem: string;
begin
  if(not mmDestiny.Lines.Text.Trim.IsEmpty)then
    Exit;

  try
    LList := TStringList.Create;
    try
      LOleVariant := FWebBrowser.OleObject.document.getElementsByClassName(C_CLASS_NAME);
      for i := 0 to LOleVariant.Length -1 do
      begin
        LItem := LOleVariant.item(i).innerText;
        LItem := LItem
          .Trim
          .Replace(sLineBreak, '')
          .Replace('...(Editado)Restaurar original', '')
          .Replace('...(Edited)Restore original', '')
          .Replace('Não foi possível carregar todos os resultados', '')
          .Replace('Tente de novoTentando novamente...', '')
          .Replace('Revisada por colaboradores', '')
          .Replace('Esta tradução foi marcada como correta pelos usuários do Google Tradutor.Saiba mais', '');

        if(not Self.StringIsValid(LItem))then
          Continue;

        if(LList.IndexOf(LItem) >= 0)then
          Continue;

        LList.Add(LItem);
      end;

      for LItem in LList do
        mmDestiny.Lines.Add(LItem);
    finally
      LList.Free;
    end;
  except
  end;
end;

function TC4DWizardTranslateView.StringIsValid(const AStr: string): Boolean;
const
  STR_INVALIDA_01 = 'Não foi possível carregar todos os resultadosTente de novoTentando novamente...';
var
  LStr: string;
begin
  Result := False;

  if(AStr.Trim.IsEmpty)then
    Exit;

  LStr := copy(AStr, (AStr.Length - STR_INVALIDA_01.Length + 1), STR_INVALIDA_01.Length);
  if(LStr = STR_INVALIDA_01)then
    Exit;

  Result := True;
end;

end.
