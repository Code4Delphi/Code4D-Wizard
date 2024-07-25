unit C4D.Wizard.Reopen.View.Edit;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  C4D.Wizard.Types;

type
  TC4DWizardReopenViewEdit = class(TForm)
    Panel9: TPanel;
    Panel1: TPanel;
    btnConfirm: TButton;
    btnClose: TButton;
    Label1: TLabel;
    edtNickname: TEdit;
    Label2: TLabel;
    Bevel1: TBevel;
    ColorBox1: TColorBox;
    Label4: TLabel;
    edtFolderGit: TEdit;
    btnFolderGit: TButton;
    cBoxGroup: TComboBox;
    Label3: TLabel;
    Bevel2: TBevel;
    mmFilePath: TMemo;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFolderGitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FC4DWizardReopenData: TC4DWizardReopenData;
    procedure GroupClear;
    procedure GroupLoad;
    procedure FillFields;
  public
    property C4DWizardReopenData: TC4DWizardReopenData read FC4DWizardReopenData write FC4DWizardReopenData;
  end;

var
  C4DWizardReopenViewEdit: TC4DWizardReopenViewEdit;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Groups,
  C4D.Wizard.Groups.Model;

{$R *.dfm}


procedure TC4DWizardReopenViewEdit.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Self.Height;
  Constraints.MinWidth := Self.Width;
  Self.ModalResult := mrCancel;
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardReopenViewEdit, Self);
end;

procedure TC4DWizardReopenViewEdit.FormDestroy(Sender: TObject);
begin
  Self.GroupClear;
end;

procedure TC4DWizardReopenViewEdit.FormShow(Sender: TObject);
begin
  Self.FillFields;
  Self.GroupLoad;
end;

procedure TC4DWizardReopenViewEdit.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardReopenViewEdit.FillFields;
var
  LFolderGit: string;
begin
  mmFilePath.Lines.Text := FC4DWizardReopenData.FilePath;
  ColorBox1.Selected := TC4DWizardUtils.StringToColorDef(FC4DWizardReopenData.Color);

  edtNickname.Text := FC4DWizardReopenData.Nickname;
  if(Trim(edtNickname.Text).IsEmpty)then
    edtNickname.Text := TC4DWizardUtils.GetNameFileNoExtension(FC4DWizardReopenData.FilePath);

  edtFolderGit.Text := FC4DWizardReopenData.FolderGit;
  //CASO NAO INFORMADO AINDA E ENCONTRE A PASTA DO GIT, JA ADD
  if(Trim(edtFolderGit.Text).IsEmpty)then
  begin
    LFolderGit := ExtractFilePath(FC4DWizardReopenData.FilePath);
    LFolderGit := IncludeTrailingPathDelimiter(LFolderGit + TC4DConsts.NAME_FOLDER_GIT);
    if(DirectoryExists(LFolderGit))then
      edtFolderGit.Text := LFolderGit;
  end;
end;

procedure TC4DWizardReopenViewEdit.btnConfirmClick(Sender: TObject);
begin
  FC4DWizardReopenData.Nickname := edtNickname.Text;
  FC4DWizardReopenData.Color := ColorToString(ColorBox1.Selected);
  FC4DWizardReopenData.FolderGit := Trim(edtFolderGit.Text);
  if(cBoxGroup.ItemIndex >= 0)then
    FC4DWizardReopenData.GuidGroup := TC4DWizardGroups(cBoxGroup.Items.Objects[cBoxGroup.ItemIndex]).Guid;
  Self.Close;
  Self.ModalResult := mrOK;
end;

procedure TC4DWizardReopenViewEdit.GroupClear;
var
  I: Integer;
  LC4DWizardReopenGroups: TC4DWizardGroups;
begin
  for I := Pred(cBoxGroup.Items.Count) downto 0 do
  begin
    LC4DWizardReopenGroups := TC4DWizardGroups(cBoxGroup.Items.Objects[I]);
    LC4DWizardReopenGroups.Free;
  end;
  cBoxGroup.Items.Clear;
end;

procedure TC4DWizardReopenViewEdit.GroupLoad;
var
  LItemIndexDefault: Integer;
begin
  Self.GroupClear;
  LItemIndexDefault := -1;
  TC4DWizardGroupsModel.New.ReadIniFile(
    procedure(AC4DWizardGroups: TC4DWizardGroups)
    var
      LC4DWizardGroups: TC4DWizardGroups;
      LItemIndex: Integer;
    begin
      LC4DWizardGroups := TC4DWizardGroups.Create;
      LC4DWizardGroups.Guid := AC4DWizardGroups.Guid;
      LC4DWizardGroups.Name := AC4DWizardGroups.Name + IfThen(AC4DWizardGroups.DefaultGroup, '*', '');
      LC4DWizardGroups.DefaultGroup := AC4DWizardGroups.DefaultGroup;
      LItemIndex := cBoxGroup.Items.AddObject(LC4DWizardGroups.Name, LC4DWizardGroups);
      if(FC4DWizardReopenData.GuidGroup = LC4DWizardGroups.Guid)then
        LItemIndexDefault := LItemIndex;
    end
    );
  if(LItemIndexDefault >= 0)then
    cBoxGroup.ItemIndex := LItemIndexDefault;
end;

procedure TC4DWizardReopenViewEdit.btnFolderGitClick(Sender: TObject);
var
  LDefaultFolder: string;
  LHasFolder: Boolean;
begin
  LDefaultFolder := edtFolderGit.Text;
  LHasFolder := True;
  if(LDefaultFolder.Trim.IsEmpty)then
  begin
    LDefaultFolder := ExtractFilePath(FC4DWizardReopenData.FilePath);
    LHasFolder := False;
  end;
  edtFolderGit.Text := TC4DWizardUtils.SelectFolder(LDefaultFolder, LHasFolder);
end;

procedure TC4DWizardReopenViewEdit.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

end.
