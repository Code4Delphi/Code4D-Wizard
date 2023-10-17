unit Teste;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  DockForm, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TDockableForm)
    ImageList1: TImageList;
    ColorDialog1: TColorDialog;
    FontDialog1: TFontDialog;
    PopupMenu1: TPopupMenu;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    SelectAll1: TMenuItem;
    N2: TMenuItem;
    BackgroundColor1: TMenuItem;
    BackgroundSelectColor1: TMenuItem;
    BackgroundeDefaultColor1: TMenuItem;
    pnBack: TPanel;
    RichEdit: TRichEdit;
    pnTop: TPanel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    btnColor: TButton;
    cBoxSizeFont: TComboBox;
    btnAlignmentLeft: TButton;
    btnAlignmentCenter: TButton;
    btnAlignmentRight: TButton;
    btnUnderline: TButton;
    btnItalic: TButton;
    btnBold: TButton;
    btnFont: TButton;
    btnOpen: TButton;
    btnSaveAs: TButton;
    btnSave: TButton;
    btnStrikethrough: TButton;
    Bevel1: TBevel;
    procedure FormShow(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure cBoxSizeFontClick(Sender: TObject);
    procedure cBoxSizeFontKeyPress(Sender: TObject; var Key: Char);
    procedure BackgroundSelectColor1Click(Sender: TObject);
    procedure BackgroundeDefaultColor1Click(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnAlignmentLeftClick(Sender: TObject);
    procedure btnAlignmentCenterClick(Sender: TObject);
    procedure btnAlignmentRightClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnStrikethroughClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    procedure ReadFromFile;
    procedure WriteToFile;
    procedure ChangeAlignment(const AAlignment: TAlignment);
    procedure ChangeStyle(const AStyle: TFontStyle);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  Form1: TForm1;

procedure RegisterSelf;
procedure Unregister;
procedure C4DWizardReopenViewShowDockableForm;

implementation

uses
  DeskUtil,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}

procedure RegisterSelf;
begin
  if(not Assigned(Form1))then
    Form1 := TForm1.Create(nil);

  if(@RegisterFieldAddress <> nil)then
    RegisterFieldAddress(Form1.Name, @Form1);

  RegisterDesktopFormClass(TForm1,
    Form1.Name,
    Form1.Name);
end;

procedure Unregister;
begin
  if(@UnRegisterFieldAddress <> nil)then
    UnRegisterFieldAddress(@Form1);
  FreeAndNil(Form1);
end;

procedure C4DWizardReopenViewShowDockableForm;
begin
  ShowDockableForm(Form1);
  FocusWindow(Form1);
end;

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := Self.Name;
  AutoSave := True;
  SaveStateNecessary := True;
  RichEdit.Lines.Clear;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TForm1, Self);
  Self.Constraints.MinWidth := 300;
  Self.Constraints.MinHeight := 300;
  RichEdit.Font.Color := TC4DWizardUtilsOTA.ActiveThemeColorDefaul;
  Self.ReadFromFile;
end;

procedure TForm1.FormHide(Sender: TObject);
begin
  //Self.WriteToFile;
end;

procedure TForm1.ReadFromFile;
begin
  if(FileExists(TC4DWizardUtils.GetPathFileNotes))then
    RichEdit.Lines.LoadFromFile(TC4DWizardUtils.GetPathFileNotes)
end;

procedure TForm1.WriteToFile;
begin
  RichEdit.Lines.SaveToFile(TC4DWizardUtils.GetPathFileNotes);
end;

procedure TForm1.btnOpenClick(Sender: TObject);
var
  LOpenDialog: TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(nil);
  try
    LOpenDialog.DefaultExt := 'rtf';
    LOpenDialog.Filter := 'File RTF|*.rtf';
    LOpenDialog.InitialDir := '';
    LOpenDialog.FileName := '';
    if(not LOpenDialog.Execute)then
      Exit;

    RichEdit.Lines.LoadFromFile(LOpenDialog.FileName);
  finally
    LOpenDialog.Free;
  end;
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  Self.WriteToFile;
end;

procedure TForm1.btnSaveAsClick(Sender: TObject);
var
 LSaveDialog: TSaveDialog;
begin
  LSaveDialog := TSaveDialog.Create(nil);
  try
    LSaveDialog.Title := 'Code4D-Wizard - Save File As';
    LSaveDialog.DefaulText := '*.rtf';
    LSaveDialog.Filter := 'Arquivos RTF (*.rtf)|*.rtf|Arquivos TXT (*.txt)|*.txt|Todos os Arquivos (*.*)|*.*';
    LSaveDialog.FileName := 'Code4D-Wizard-Notes-' + FormatDateTime('yyyyMMdd-hhnnss', now) + '.rtf';
    LSaveDialog.InitialDir := '';

    if(not LSaveDialog.Execute)then
      Exit;

    if(FileExists(LSaveDialog.FileName))then
      if(not TC4DWizardUtils.ShowQuestion2('There is already a file with the same name in this location. Want to replace it?'))then
        Exit;

    RichEdit.Lines.SaveToFile(LSaveDialog.FileName);
    TC4DWizardUtils.ShowV('Successful saving file');
  finally
    LSaveDialog.Free;
  end;
end;

procedure TForm1.btnColorClick(Sender: TObject);
begin
  if(ColorDialog1.Execute)then
    RichEdit.SelAttributes.Color := ColorDialog1.Color;
  RichEdit.SetFocus;
end;

procedure TForm1.cBoxSizeFontClick(Sender: TObject);
var
  LSize: Integer;
begin
  LSize := StrToIntDef(cBoxSizeFont.Text, 0);
  if(LSize > 7)then
    RichEdit.SelAttributes.Size := LSize;
end;

procedure TForm1.cBoxSizeFontKeyPress(Sender: TObject; var Key: Char);
begin
  if not(CharInSet(Key, ['0'..'9', #8]))then
    key := #0;
end;

procedure TForm1.BackgroundSelectColor1Click(Sender: TObject);
begin
  if(ColorDialog1.Execute)then
    RichEdit.Color := ColorDialog1.Color;
  RichEdit.SetFocus;
end;

procedure TForm1.BackgroundeDefaultColor1Click(Sender: TObject);
begin
  RichEdit.ParentColor := True;
  RichEdit.SetFocus;
end;

procedure TForm1.btnFontClick(Sender: TObject);
begin
  FontDialog1.Font.Color := RichEdit.SelAttributes.Color;
  FontDialog1.Font.Name := RichEdit.SelAttributes.Name;
  FontDialog1.Font.Size := RichEdit.SelAttributes.Size;
  FontDialog1.Font.Style := RichEdit.SelAttributes.Style;

  if(FontDialog1.Execute)then
  begin
    RichEdit.SelAttributes.Color := FontDialog1.Font.Color;
    RichEdit.SelAttributes.Name := FontDialog1.Font.Name;
    RichEdit.SelAttributes.Size := FontDialog1.Font.Size;
    cBoxSizeFont.Text := IntToStr(FontDialog1.Font.size);
    RichEdit.SelAttributes.Style := FontDialog1.Font.Style;

    btnBold.Default := fsbold in FontDialog1.Font.Style;
    btnItalic.Default := fsItalic in FontDialog1.Font.Style;
    btnUnderline.Default := fsUnderline in FontDialog1.Font.Style;
  end;
  RichEdit.SetFocus;
end;

procedure TForm1.btnBoldClick(Sender: TObject);
begin
  Self.ChangeStyle(fsBold);
end;

procedure TForm1.btnItalicClick(Sender: TObject);
begin
  Self.ChangeStyle(fsItalic);
end;

procedure TForm1.btnUnderlineClick(Sender: TObject);
begin
  Self.ChangeStyle(fsUnderline);
end;

procedure TForm1.btnStrikethroughClick(Sender: TObject);
begin
  Self.ChangeStyle(fsStrikeOut);
end;

procedure TForm1.ChangeStyle(const AStyle: TFontStyle);
begin
  if(AStyle in RichEdit.SelAttributes.Style)then
    RichEdit.SelAttributes.Style := RichEdit.SelAttributes.Style - [AStyle]
  else
    RichEdit.SelAttributes.Style := RichEdit.SelAttributes.Style + [AStyle];
  RichEdit.SetFocus;
end;

procedure TForm1.btnAlignmentLeftClick(Sender: TObject);
begin
  Self.ChangeAlignment(taLeftJustify);
end;

procedure TForm1.btnAlignmentCenterClick(Sender: TObject);
begin
  Self.ChangeAlignment(taCenter);
end;

procedure TForm1.btnAlignmentRightClick(Sender: TObject);
begin
  Self.ChangeAlignment(taRightJustify);
end;

procedure TForm1.ChangeAlignment(const AAlignment: TAlignment);
begin
  RichEdit.Paragraph.Alignment := AAlignment;
  RichEdit.SetFocus;
end;

procedure TForm1.Cut1Click(Sender: TObject);
begin
  RichEdit.CutToClipboard;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  RichEdit.CopyToClipboard;
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  RichEdit.PasteFromClipboard;
end;

procedure TForm1.SelectAll1Click(Sender: TObject);
begin
  RichEdit.SelectAll;
end;

initialization

finalization
  Unregister;

end.
