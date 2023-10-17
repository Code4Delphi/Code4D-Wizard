unit C4D.Wizard.Notes.View;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Math,
  System.DateUtils,
  System.ImageList,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.ImgList,
  Vcl.Menus,
  DockForm,
  DeskUtil;

type
  TC4DWizardNotesView = class(TDockableForm)
    pnTop: TPanel;
    pnBack: TPanel;
    Bevel1: TBevel;
    ImageList1: TImageList;
    btnColor: TButton;
    ColorDialog1: TColorDialog;
    RichEdit: TRichEdit;
    cBoxSizeFont: TComboBox;
    btnAlignmentLeft: TButton;
    btnAlignmentCenter: TButton;
    btnAlignmentRight: TButton;
    Bevel2: TBevel;
    btnUnderline: TButton;
    btnItalic: TButton;
    btnBold: TButton;
    FontDialog1: TFontDialog;
    btnFont: TButton;
    Bevel3: TBevel;
    btnOpen: TButton;
    btnSaveAs: TButton;
    btnSave: TButton;
    PopupMenu1: TPopupMenu;
    BackgroundColor1: TMenuItem;
    BackgroundSelectColor1: TMenuItem;
    BackgroundeDefaultColor1: TMenuItem;
    btnStrikethrough: TButton;
    SelectAll1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    N2: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure cBoxSizeFontKeyPress(Sender: TObject; var Key: Char);
    procedure cBoxSizeFontClick(Sender: TObject);
    procedure btnAlignmentLeftClick(Sender: TObject);
    procedure btnAlignmentCenterClick(Sender: TObject);
    procedure btnAlignmentRightClick(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure BackgroundSelectColor1Click(Sender: TObject);
    procedure BackgroundeDefaultColor1Click(Sender: TObject);
    procedure btnStrikethroughClick(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
  private
    procedure ReadFromFile;
    procedure WriteToFile;
    procedure ChangeStyle(const AStyle: TFontStyle);
    procedure ChangeAlignment(const AAlignment: TAlignment);
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
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

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
  DeskSection := Self.Name;
  AutoSave := True;
  SaveStateNecessary := True;
  RichEdit.Lines.Clear;
end;

procedure TC4DWizardNotesView.FormCreate(Sender: TObject);
begin
  RichEdit.Lines.Clear;
end;

procedure TC4DWizardNotesView.FormShow(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardNotesView, Self);
  Self.Constraints.MinWidth := 300;
  Self.Constraints.MinHeight := 300;
  RichEdit.Font.Color := TC4DWizardUtilsOTA.ActiveThemeColorDefaul;
  Self.ReadFromFile;
end;

procedure TC4DWizardNotesView.FormHide(Sender: TObject);
begin
  Self.WriteToFile;
end;

procedure TC4DWizardNotesView.ReadFromFile;
begin
  if(FileExists(TC4DWizardUtils.GetPathFileNotes))then
    RichEdit.Lines.LoadFromFile(TC4DWizardUtils.GetPathFileNotes)
end;

procedure TC4DWizardNotesView.WriteToFile;
begin
  RichEdit.Lines.SaveToFile(TC4DWizardUtils.GetPathFileNotes);
end;

procedure TC4DWizardNotesView.btnOpenClick(Sender: TObject);
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

procedure TC4DWizardNotesView.btnSaveClick(Sender: TObject);
begin
  Self.WriteToFile;
end;

procedure TC4DWizardNotesView.btnSaveAsClick(Sender: TObject);
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

procedure TC4DWizardNotesView.btnColorClick(Sender: TObject);
begin
  if(ColorDialog1.Execute)then
    RichEdit.SelAttributes.Color := ColorDialog1.Color;
  RichEdit.SetFocus;
end;

procedure TC4DWizardNotesView.cBoxSizeFontClick(Sender: TObject);
var
  LSize: Integer;
begin
  LSize := StrToIntDef(cBoxSizeFont.Text, 0);
  if(LSize > 7)then
    RichEdit.SelAttributes.Size := LSize;
end;

procedure TC4DWizardNotesView.cBoxSizeFontKeyPress(Sender: TObject; var Key: Char);
begin
  if not(CharInSet(Key, ['0'..'9', #8]))then
    key := #0;
end;

procedure TC4DWizardNotesView.BackgroundSelectColor1Click(Sender: TObject);
begin
  if(ColorDialog1.Execute)then
    RichEdit.Color := ColorDialog1.Color;
  RichEdit.SetFocus;
end;

procedure TC4DWizardNotesView.BackgroundeDefaultColor1Click(Sender: TObject);
begin
  RichEdit.ParentColor := True;
  RichEdit.SetFocus;
end;

procedure TC4DWizardNotesView.btnFontClick(Sender: TObject);
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

procedure TC4DWizardNotesView.btnAlignmentLeftClick(Sender: TObject);
begin
  Self.ChangeAlignment(taLeftJustify);
end;

procedure TC4DWizardNotesView.btnAlignmentCenterClick(Sender: TObject);
begin
  Self.ChangeAlignment(taCenter);
end;

procedure TC4DWizardNotesView.btnAlignmentRightClick(Sender: TObject);
begin
  Self.ChangeAlignment(taRightJustify);
end;

procedure TC4DWizardNotesView.ChangeAlignment(const AAlignment: TAlignment);
begin
  RichEdit.Paragraph.Alignment := AAlignment;
  RichEdit.SetFocus;
end;

procedure TC4DWizardNotesView.btnBoldClick(Sender: TObject);
begin
  Self.ChangeStyle(fsBold);
end;

procedure TC4DWizardNotesView.btnItalicClick(Sender: TObject);
begin
  Self.ChangeStyle(fsItalic);
end;

procedure TC4DWizardNotesView.btnUnderlineClick(Sender: TObject);
begin
  Self.ChangeStyle(fsUnderline);
end;

procedure TC4DWizardNotesView.btnStrikethroughClick(Sender: TObject);
begin
  Self.ChangeStyle(fsStrikeOut);
end;

procedure TC4DWizardNotesView.ChangeStyle(const AStyle: TFontStyle);
begin
  if(AStyle in RichEdit.SelAttributes.Style)then
    RichEdit.SelAttributes.Style := RichEdit.SelAttributes.Style - [AStyle]
  else
    RichEdit.SelAttributes.Style := RichEdit.SelAttributes.Style + [AStyle];
  RichEdit.SetFocus;
end;

procedure TC4DWizardNotesView.Cut1Click(Sender: TObject);
begin
  RichEdit.CutToClipboard;
end;

procedure TC4DWizardNotesView.Copy1Click(Sender: TObject);
begin
  RichEdit.CopyToClipboard;
end;

procedure TC4DWizardNotesView.Paste1Click(Sender: TObject);
begin
  RichEdit.PasteFromClipboard;
end;

procedure TC4DWizardNotesView.SelectAll1Click(Sender: TObject);
begin
  RichEdit.SelectAll;
end;

initialization

finalization
  Unregister;

end.
