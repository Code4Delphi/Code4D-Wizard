unit C4D.Wizard.OpenExternal.AddEdit.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Menus,
  C4D.Wizard.Types,
  C4D.Wizard.OpenExternal,
  Vcl.ComCtrls;

type
  TC4DWizardOpenExternalAddEditView = class(TForm)
    Panel1: TPanel;
    btnConfirm: TButton;
    btnClose: TButton;
    Panel9: TPanel;
    Label1: TLabel;
    Bevel1: TBevel;
    edtDescription: TEdit;
    Label2: TLabel;
    cBoxKind: TComboBox;
    Label3: TLabel;
    edtPath: TEdit;
    btnBath: TButton;
    Label4: TLabel;
    edtOrder: TEdit;
    UpDown1: TUpDown;
    Label7: TLabel;
    edtShortcut: THotKey;
    Label5: TLabel;
    lbParameters: TLabel;
    edtParameters: TEdit;
    ckVisible: TCheckBox;
    Label6: TLabel;
    edtPathIconLoad: TButton;
    edtPathIconClear: TButton;
    Panel2: TPanel;
    imgIcon: TImage;
    pnTagsBack: TPanel;
    Bevel2: TBevel;
    Label8: TLabel;
    mmTags: TMemo;
    ckVisibleInToolBarUtilities: TCheckBox;
    Label9: TLabel;
    cBoxMenuMaster: TComboBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cBoxKindChange(Sender: TObject);
    procedure btnBathClick(Sender: TObject);
    procedure edtPathIconLoadClick(Sender: TObject);
    procedure edtPathIconClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FC4DWizardOpenExternal: TC4DWizardOpenExternal;
    FLastDescription: string;
    FLastPath: string;
    FLastParameters: string;
    FLastItemIndexMenuMaster: Integer;
    FAlterIcon: Boolean;
    FPathIconAlter: string;
    procedure ConfFieldsKind;
    procedure FillcBoxKind;
    procedure LoadIconCurrent;
    procedure FillTags;
    procedure MenuMasterLoad;
    procedure MenuMasterClear;
  public
    property C4DWizardOpenExternal: TC4DWizardOpenExternal read FC4DWizardOpenExternal write FC4DWizardOpenExternal;
  end;

var
  C4DWizardOpenExternalAddEditView: TC4DWizardOpenExternalAddEditView;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.OpenExternal.Model;

{$R *.dfm}


procedure TC4DWizardOpenExternalAddEditView.FormCreate(Sender: TObject);
begin
  Self.ModalResult := mrCancel;

  FLastDescription := '';
  FLastPath := '';
  FLastParameters := '';
  FLastItemIndexMenuMaster := 0;

  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardOpenExternalAddEditView, Self);
  Self.FillcBoxKind;
  Self.FillTags;
end;

procedure TC4DWizardOpenExternalAddEditView.FormDestroy(Sender: TObject);
begin
  Self.MenuMasterClear;
end;

procedure TC4DWizardOpenExternalAddEditView.FormShow(Sender: TObject);
begin
  edtDescription.Text := FC4DWizardOpenExternal.Description;
  cBoxKind.ItemIndex := cBoxKind.Items.IndexOf(FC4DWizardOpenExternal.Kind.ToString);
  edtPath.Text := FC4DWizardOpenExternal.Path;
  edtParameters.Text := FC4DWizardOpenExternal.Parameters;
  edtOrder.Text := FC4DWizardOpenExternal.Order.ToString;
  edtShortcut.HotKey := TextToShortCut(FC4DWizardOpenExternal.Shortcut);
  ckVisible.Checked := FC4DWizardOpenExternal.Visible;
  ckVisibleInToolBarUtilities.Checked := FC4DWizardOpenExternal.VisibleInToolBarUtilities;
  FAlterIcon := False;
  FPathIconAlter := '';
  Self.LoadIconCurrent;
  Self.ConfFieldsKind;
  Self.MenuMasterLoad;
  cBoxKind.SetFocus;
end;

procedure TC4DWizardOpenExternalAddEditView.MenuMasterClear;
var
  I: Integer;
  LC4DWizardOpenExternal: TC4DWizardOpenExternal;
begin
  for I := Pred(cBoxMenuMaster.Items.Count) downto 0 do
  begin
    LC4DWizardOpenExternal := TC4DWizardOpenExternal(cBoxMenuMaster.Items.Objects[I]);
    LC4DWizardOpenExternal.Free;
  end;
  cBoxMenuMaster.Items.Clear;
end;

procedure TC4DWizardOpenExternalAddEditView.MenuMasterLoad;
var
  LItemIndexDefault: Integer;
begin
  Self.MenuMasterClear;

  cBoxMenuMaster.Items.AddObject('None', nil);

  LItemIndexDefault := 0;
  TC4DWizardOpenExternalModel.New.ReadIniFile(
    procedure(AC4DWizardOpenExternal: TC4DWizardOpenExternal)
    var
      LC4DWizardOpenExternal: TC4DWizardOpenExternal;
      LItemIndex: Integer;
    begin
      if(AC4DWizardOpenExternal.Kind <> TC4DWizardOpenExternalKind.MenuMasterOnly)then
        Exit;

      LC4DWizardOpenExternal := TC4DWizardOpenExternal.Create;
      LC4DWizardOpenExternal.Guid := AC4DWizardOpenExternal.Guid;
      LC4DWizardOpenExternal.Description := AC4DWizardOpenExternal.Description;
      LItemIndex := cBoxMenuMaster.Items.AddObject(LC4DWizardOpenExternal.Description, LC4DWizardOpenExternal);
      if(FC4DWizardOpenExternal.GuidMenuMaster = LC4DWizardOpenExternal.Guid)then
        LItemIndexDefault := LItemIndex;
    end
    );

  cBoxMenuMaster.ItemIndex := LItemIndexDefault;
end;

procedure TC4DWizardOpenExternalAddEditView.LoadIconCurrent;
var
  LFilePath: string;
begin
  imgIcon.Picture := nil;
  if(not FC4DWizardOpenExternal.IconHas)then
    Exit;

  LFilePath := TC4DWizardUtils.GetPathImageOpenExternal(FC4DWizardOpenExternal.Guid);
  if(FileExists(LFilePath))then
    imgIcon.Picture.LoadFromFile(LFilePath);
end;

procedure TC4DWizardOpenExternalAddEditView.FillcBoxKind;
begin
  cBoxKind.Items.Clear;
  TC4DWizardUtils.OpenExternalKindFillItemsTStrings(cBoxKind.Items);
end;

procedure TC4DWizardOpenExternalAddEditView.FillTags;
begin
  mmTags.Lines.Clear;
  mmTags.Lines.Add(TC4DConsts.TAG_BLOCK_TEXT_SELECT);
  mmTags.Lines.Add(TC4DConsts.TAG_FOLDER_GIT);
  mmTags.Lines.Add(TC4DConsts.TAG_FILE_PATH_BINARY);
  mmTags.Lines.Text := mmTags.Lines.Text.Trim;
end;

procedure TC4DWizardOpenExternalAddEditView.btnBathClick(Sender: TObject);
var
  LDefaultPath: string;
begin
  LDefaultPath := edtPath.Text;
  if(LDefaultPath.Trim.IsEmpty)then
    LDefaultPath := ExtractFilePath(FC4DWizardOpenExternal.Path);
  if(cBoxKind.Text = TC4DWizardOpenExternalKind.Folders.ToString)then
    edtPath.Text := TC4DWizardUtils.SelectFolder(LDefaultPath)
  else
    edtPath.Text := TC4DWizardUtils.SelectFile(LDefaultPath);
end;

procedure TC4DWizardOpenExternalAddEditView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardOpenExternalAddEditView.btnConfirmClick(Sender: TObject);
begin
  if(cBoxKind.ItemIndex <= 0)then
    TC4DWizardUtils.ShowMsgAndAbort('No informed Kind', cBoxKind);

  if(Trim(edtDescription.Text).IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('No informed Description', edtDescription);

  FC4DWizardOpenExternal.Description := edtDescription.Text;
  FC4DWizardOpenExternal.Kind := TC4DWizardUtils.StrToOpenExternalKind(cBoxKind.Text);
  FC4DWizardOpenExternal.Path := edtPath.Text;
  FC4DWizardOpenExternal.Parameters := edtParameters.Text;
  FC4DWizardOpenExternal.Order := StrToIntDef(edtOrder.Text, 0);
  FC4DWizardOpenExternal.Shortcut := ShortCutToText(edtShortcut.HotKey);
  FC4DWizardOpenExternal.Visible := ckVisible.Checked;
  FC4DWizardOpenExternal.VisibleInToolBarUtilities := ckVisibleInToolBarUtilities.Checked;

  if(FAlterIcon)then
    FC4DWizardOpenExternal.IconHas := (not FPathIconAlter.Trim.IsEmpty)and(FileExists(FPathIconAlter));

  FC4DWizardOpenExternal.GuidMenuMaster := '';
  if(cBoxMenuMaster.ItemIndex >= 0)then
    if(TC4DWizardOpenExternal(cBoxMenuMaster.Items.Objects[cBoxMenuMaster.ItemIndex]) <> nil)then
      FC4DWizardOpenExternal.GuidMenuMaster := TC4DWizardOpenExternal(cBoxMenuMaster.Items.Objects[cBoxMenuMaster.ItemIndex]).Guid;

  TC4DWizardOpenExternalModel.New
    .SaveIconInFolder(FC4DWizardOpenExternal.Guid, FPathIconAlter)
    .WriteInIniFile(FC4DWizardOpenExternal);
  Self.Close;
  Self.ModalResult := mrOK;
end;

procedure TC4DWizardOpenExternalAddEditView.cBoxKindChange(Sender: TObject);
begin
  Self.ConfFieldsKind;
end;

procedure TC4DWizardOpenExternalAddEditView.ConfFieldsKind;
begin
  edtDescription.Enabled := True;
  edtPath.Enabled := True;
  edtParameters.Enabled := True;
  edtShortcut.Enabled := True;
  btnBath.Enabled := (cBoxKind.Text = TC4DWizardOpenExternalKind.Files.ToString)
    or(cBoxKind.Text = TC4DWizardOpenExternalKind.Folders.ToString);
  lbParameters.Caption := 'Parameters';
  cBoxMenuMaster.Enabled := True;

  if(cBoxKind.Text = TC4DWizardOpenExternalKind.Separators.ToString)then
  begin
    FLastDescription := edtDescription.Text;
    edtDescription.Text := '-';
    edtDescription.Enabled := False;
    FLastPath := edtPath.Text;
    edtPath.Text := '';
    edtPath.Enabled := False;
    FLastParameters := edtParameters.Text;
    edtParameters.Text := '';
    edtParameters.Enabled := False;
    edtShortcut.HotKey := $0000;
    edtShortcut.Enabled := False;
  end
  else if(cBoxKind.Text = TC4DWizardOpenExternalKind.MenuMasterOnly.ToString)then
  begin
    if(edtDescription.Text = '-')and(not FLastDescription.Trim.IsEmpty)then
      edtDescription.Text := FLastDescription;

    FLastPath := edtPath.Text;
    edtPath.Text := '';
    edtPath.Enabled := False;
    FLastParameters := edtParameters.Text;
    edtParameters.Text := '';
    edtParameters.Enabled := False;
    edtShortcut.HotKey := $0000;
    edtShortcut.Enabled := False;

    FLastItemIndexMenuMaster := cBoxMenuMaster.ItemIndex;
    cBoxMenuMaster.ItemIndex := 0;
    cBoxMenuMaster.Enabled := False;
  end
  else if(cBoxKind.Text = TC4DWizardOpenExternalKind.CMD.ToString)then
  begin
    if(edtDescription.Text = '-')and(not FLastDescription.Trim.IsEmpty)then
      edtDescription.Text := FLastDescription;

    FLastPath := edtPath.Text;
    edtPath.Text := TC4DWizardOpenExternalKind.CMD.ToString;
    edtPath.Enabled := False;

    if(Trim(edtParameters.Text).IsEmpty)then
      edtParameters.Text := FLastParameters;

    lbParameters.Caption := 'CMD Commands (use # to separate commands)';
  end
  else
  begin
    if(edtDescription.Text = '-')and(not FLastDescription.Trim.IsEmpty)then
      edtDescription.Text := FLastDescription;

    if(Trim(edtPath.Text).IsEmpty)then
      edtPath.Text := FLastPath;

    if(Trim(edtParameters.Text).IsEmpty)then
      edtParameters.Text := FLastParameters;
  end;

  if(cBoxKind.Text <> TC4DWizardOpenExternalKind.MenuMasterOnly.ToString)then
  begin
    if(cBoxMenuMaster.ItemIndex <= 0)then
      cBoxMenuMaster.ItemIndex := FLastItemIndexMenuMaster;
  end;
end;

procedure TC4DWizardOpenExternalAddEditView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardOpenExternalAddEditView.edtPathIconLoadClick(Sender: TObject);
var
  LPathIcon: string;
begin
  LPathIcon := FPathIconAlter;
  if(not LPathIcon.Trim.IsEmpty)then
    LPathIcon := ExtractFilePath(LPathIcon);

  LPathIcon := TC4DWizardUtils.SelectFile(LPathIcon, TC4DExtensionsFiles.Bmp);
  if(LPathIcon.Trim.IsEmpty)then
    Exit;

  if(not FileExists(LPathIcon))then
    Exit;

  imgIcon.Picture.LoadFromFile(LPathIcon);
  FAlterIcon := True;
  FPathIconAlter := LPathIcon;
end;

procedure TC4DWizardOpenExternalAddEditView.edtPathIconClearClick(Sender: TObject);
begin
  if(not TC4DWizardUtils.ShowQuestion('Confirm removal of this icon?'))then
    Exit;

  imgIcon.Picture := nil;
  FAlterIcon := True;
  FPathIconAlter := '';
end;

end.
