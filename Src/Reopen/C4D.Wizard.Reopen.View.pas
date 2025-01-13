unit C4D.Wizard.Reopen.View;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Math,
  System.DateUtils,
  System.ImageList,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.Clipbrd,
  Vcl.ImgList,
  DockForm,
  C4D.Wizard.Types,
  C4D.Wizard.Utils.ListView;

type
  TC4DWizardReopenView = class(TDockableForm)
    pnTudo: TPanel;
    pnTop: TPanel;
    ListViewHistory: TListView;
    PopupMenuListViewHistory: TPopupMenu;
    MarkAsFavorite1: TMenuItem;
    MarkAsUnfavorite1: TMenuItem;
    ImageList1: TImageList;
    N1: TMenuItem;
    ViewFolderInExplorer1: TMenuItem;
    ViewFileInExplorer1: TMenuItem;
    N2: TMenuItem;
    RemoveSelectedFileFromHistory1: TMenuItem;
    StatusBar1: TStatusBar;
    EditInformations1: TMenuItem;
    N3: TMenuItem;
    btnSearch: TButton;
    edtSearch: TEdit;
    N4: TMenuItem;
    ViewInRemoteRepository1: TMenuItem;
    OpenInGitHubDesktop1: TMenuItem;
    Bevel1: TBevel;
    pnButtons: TPanel;
    btnOpen: TButton;
    btnRemove: TButton;
    btnMarkAsFavorite: TButton;
    btnMarkAsUnfavorite: TButton;
    btnEditInformations: TButton;
    btnOpenInGitHubDesktop: TButton;
    btnViewInRemoteRepository: TButton;
    btnViewFileInExplorer: TButton;
    tvGroup: TTreeView;
    Splitter1: TSplitter;
    ImageListGroups: TImageList;
    cBoxGroup: TComboBox;
    btnAddGroup: TButton;
    PopupMenuTvGroup: TPopupMenu;
    MarkGroupAsDefault1: TMenuItem;
    N5: TMenuItem;
    ManagerGroups1: TMenuItem;
    Copy1: TMenuItem;
    N6: TMenuItem;
    CopyNickname1: TMenuItem;
    CopyName1: TMenuItem;
    CopyPath1: TMenuItem;
    pnOpenPeriod: TPanel;
    dtpOpenPeriodIni: TDateTimePicker;
    dtpOpenPeriodEnd: TDateTimePicker;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewHistoryCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnSearchClick(Sender: TObject);
    procedure ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewHistoryDblClick(Sender: TObject);
    procedure MarkAsFavorite1Click(Sender: TObject);
    procedure MarkAsUnfavorite1Click(Sender: TObject);
    procedure ListViewHistoryColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListViewHistoryCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ViewFolderInExplorer1Click(Sender: TObject);
    procedure ViewFileInExplorer1Click(Sender: TObject);
    procedure RemoveSelectedFileFromHistory1Click(Sender: TObject);
    procedure ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure EditInformations1Click(Sender: TObject);
    procedure ViewInRemoteRepository1Click(Sender: TObject);
    procedure OpenInGitHubDesktop1Click(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cBoxGroupChange(Sender: TObject);
    procedure tvGroupChange(Sender: TObject; Node: TTreeNode);
    procedure btnAddGroupClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MarkGroupAsDefault1Click(Sender: TObject);
    procedure PopupMenuTvGroupPopup(Sender: TObject);
    procedure tvGroupContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure CopyNickname1Click(Sender: TObject);
    procedure CopyName1Click(Sender: TObject);
    procedure CopyPath1Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure tvGroupDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure tvGroupDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure dtpOpenPeriodEndClick(Sender: TObject);
    procedure dtpOpenPeriodIniClick(Sender: TObject);
  private
    FUtilsListView: IC4DWizardUtilsListView;
    FGroupChangeAllow: Boolean;
    FtvGroupWidthExpanded: Integer;
    FpnOpenPeriodWidthExpanded: Integer;
    FCheckedOpenPeriodIni: Boolean;
    FCheckedOpenPeriodEnd: Boolean;
    procedure GroupClear;
    procedure GroupLoad;
    procedure OpenItem;
    procedure IniFileRead;
    procedure MarkFavoriteYesNo(AC4DWizardFavorite: TC4DWizardFavorite);
    procedure FillReopenDataSelectedItem(var AC4DWizardReopenData: TC4DWizardReopenData);
    procedure ConfButton(ABig: Boolean);
    procedure ConfButtonCreate;
    procedure FillStatusBar(AItem: TListItem);
    procedure SelectNodeGroup(const AGuid: string);
    procedure SetOrderDefault;
    procedure CopyIndexSubItemListView(AIndexSubItem: Integer);
    procedure ProcessItemReopenData(AC4DWizardReopenData: TC4DWizardReopenData);
    function GetFilePathItemSelectedInListView: string;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  C4DWizardReopenView: TC4DWizardReopenView;

procedure RegisterSelf;
procedure Unregister;
procedure C4DWizardReopenViewShowDockableForm;

implementation

uses
  DeskUtil,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Reopen.Model,
  C4D.Wizard.Reopen.View.Edit,
  C4D.Wizard.Reopen.Controller,
  C4D.Wizard.Groups,
  C4D.Wizard.Groups.View,
  C4D.Wizard.Groups.Model;

{$R *.dfm}

const
  C_INDEX_SUBITEM_Nickname = 0;
  C_INDEX_SUBITEM_Name = 1;
  C_INDEX_SUBITEM_LastOpen = 2;
  C_INDEX_SUBITEM_LastClose = 3;
  C_INDEX_SUBITEM_FilePath = 4;
  C_INDEX_SUBITEM_Color = 5;
  C_INDEX_SUBITEM_FolderGit = 6;
  C_INDEX_SUBITEM_GuidGroup = 7;

procedure RegisterSelf;
begin
  if(not Assigned(C4DWizardReopenView))then
    C4DWizardReopenView := TC4DWizardReopenView.Create(nil);

  if(@RegisterFieldAddress <> nil)then
    RegisterFieldAddress(C4DWizardReopenView.Name, @C4DWizardReopenView);

  RegisterDesktopFormClass(TC4DWizardReopenView,
    C4DWizardReopenView.Name,
    C4DWizardReopenView.Name);
end;

procedure Unregister;
begin
  if(@UnRegisterFieldAddress <> nil)then
    UnRegisterFieldAddress(@C4DWizardReopenView);
  FreeAndNil(C4DWizardReopenView);
end;

procedure C4DWizardReopenViewShowDockableForm;
begin
  ShowDockableForm(C4DWizardReopenView);
  FocusWindow(C4DWizardReopenView);
end;

constructor TC4DWizardReopenView.Create(AOwner: TComponent);
begin
  inherited;
  DeskSection := Self.Name;
  AutoSave := True;
  SaveStateNecessary := True;
  Self.ConfButtonCreate;
end;

procedure TC4DWizardReopenView.FormCreate(Sender: TObject);
begin
  inherited;
  FtvGroupWidthExpanded := IfThen(tvGroup.Width > 2, tvGroup.Width, 130);
  FpnOpenPeriodWidthExpanded := IfThen(pnOpenPeriod.Width > 2, pnOpenPeriod.Width, 268);
  FUtilsListView := TC4DWizardUtilsListView.New(ListViewHistory);
  dtpOpenPeriodIni.Date := IncMonth(Date, -3);
  dtpOpenPeriodIni.Checked := False;
  FCheckedOpenPeriodIni := dtpOpenPeriodIni.Checked;
  dtpOpenPeriodEnd.Date := Date;
  dtpOpenPeriodEnd.Checked := False;
  FCheckedOpenPeriodEnd := dtpOpenPeriodEnd.Checked;
  cBoxGroup.Sorted := True;
end;

procedure TC4DWizardReopenView.FormShow(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardReopenView, Self);
  Self.Constraints.MinWidth := 300;
  Self.Constraints.MinHeight := 300;
  FGroupChangeAllow := True;
  Self.GroupLoad;
  Self.IniFileRead;
  Self.SetOrderDefault;
  if(ListViewHistory.Items.Count > 0)then
    ListViewHistory.Items.Item[0].Selected := True;
  edtSearch.SetFocus;
end;

procedure TC4DWizardReopenView.dtpOpenPeriodIniClick(Sender: TObject);
begin
  if(FCheckedOpenPeriodIni <> dtpOpenPeriodIni.Checked)then
  begin
    FCheckedOpenPeriodIni := dtpOpenPeriodIni.Checked;
    Self.IniFileRead;
  end;
end;

procedure TC4DWizardReopenView.dtpOpenPeriodEndClick(Sender: TObject);
begin
  if(FCheckedOpenPeriodEnd <> dtpOpenPeriodEnd.Checked)then
  begin
    FCheckedOpenPeriodEnd := dtpOpenPeriodEnd.Checked;
    Self.IniFileRead;
  end;
end;

procedure TC4DWizardReopenView.SetOrderDefault;
begin
  FUtilsListView
    .InvertOrder(False)
    .SortStyle(TC4DWizardUtilsListViewSortStyle.DateTime)
    .ColumnIndex(C_INDEX_SUBITEM_LastOpen + 1)
    .CustomSort;

  FUtilsListView
    .InvertOrder(False)
    .SortStyle(TC4DWizardUtilsListViewSortStyle.Numeric)
    .ColumnIndex(0)
    .CustomSort;
end;

procedure TC4DWizardReopenView.StatusBar1DblClick(Sender: TObject);
begin
  if(TC4DWizardUtils.StatusBarNumPanelDblClick(StatusBar1) = 1)then
    btnViewFileInExplorer.Click;
end;

procedure TC4DWizardReopenView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.GroupClear;
  inherited;
end;

procedure TC4DWizardReopenView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_DOWN, VK_UP:
    begin
      if(ListViewHistory <> ActiveControl)then
      begin
        case(Key)of
          VK_DOWN:
          if(ListViewHistory.ItemIndex < Pred(ListViewHistory.Items.Count))then
            ListViewHistory.ItemIndex := ListViewHistory.ItemIndex + 1;
          VK_UP:
          if(ListViewHistory.ItemIndex > 0)then
            ListViewHistory.ItemIndex := ListViewHistory.ItemIndex - 1;
        end;
        Key := 0;
      end;
    end;
  end;
end;

procedure TC4DWizardReopenView.FormResize(Sender: TObject);
begin
  if(Self.Width >= 700)then
  begin
    Self.ConfButton(True);
    if(tvGroup.Width <= 1)then
      tvGroup.Width := FtvGroupWidthExpanded;
    if(pnOpenPeriod.Width <= 1)then
    begin
      pnOpenPeriod.Width := FpnOpenPeriodWidthExpanded;
      pnOpenPeriod.Align := alLeft;
      pnOpenPeriod.Align := alRight;
    end;
  end
  else
  begin
    Self.ConfButton(False);
    if(tvGroup.Width > 1)then
    begin
      FtvGroupWidthExpanded := tvGroup.Width;
      tvGroup.Width := 1;
    end;
    if(pnOpenPeriod.Width > 1)then
    begin
      FpnOpenPeriodWidthExpanded := pnOpenPeriod.Width;
      pnOpenPeriod.Width := 1;
    end;
  end;
end;

procedure TC4DWizardReopenView.edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    Self.IniFileRead;
end;

procedure TC4DWizardReopenView.ListViewHistoryCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  {ListViewHistory.Canvas.Brush.Color := clWhite;
   if(Item.Index mod 2 = 0)then
   ListViewHistory.Canvas.Brush.Color := $00E6ECEC;
   Sender.Canvas.Font.Color := ListViewHistory.Canvas.Brush.Color;}
end;

procedure TC4DWizardReopenView.ListViewHistoryCustomDrawSubItem(Sender: TCustomListView; Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LColorStr: string;
  LColor: TColor;
begin
  LColorStr := Item.SubItems[C_INDEX_SUBITEM_Color].Trim;
  if(not LColorStr.IsEmpty)then
  begin
    LColor := TC4DWizardUtils.StringToColorDef(LColorStr);
    if(LColor <> clBlack)then
      Sender.Canvas.Font.Color := LColor
  end;
end;

procedure TC4DWizardReopenView.MarkAsFavorite1Click(Sender: TObject);
begin
  Self.MarkFavoriteYesNo(TC4DWizardFavorite.Yes);
end;

procedure TC4DWizardReopenView.MarkAsUnfavorite1Click(Sender: TObject);
begin
  Self.MarkFavoriteYesNo(TC4DWizardFavorite.No);
end;

procedure TC4DWizardReopenView.MarkFavoriteYesNo(AC4DWizardFavorite: TC4DWizardFavorite);
var
  LListItem: TListItem;
  LFilePath: string;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  LFilePath := LListItem.SubItems[C_INDEX_SUBITEM_FilePath];
  TC4DWizardReopenModel.New.WriteFilePathInIniFile(LFilePath, AC4DWizardFavorite);
  Self.IniFileRead;
end;

procedure TC4DWizardReopenView.ListViewHistoryDblClick(Sender: TObject);
begin
  Self.OpenItem;
end;

procedure TC4DWizardReopenView.ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    Self.OpenItem;
end;

procedure TC4DWizardReopenView.OpenItem;
var
  LListItem: TListItem;
  LFilePath: string;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  LFilePath := LListItem.SubItems[C_INDEX_SUBITEM_FilePath];
  if(not FileExists(LFilePath))then
  begin
    TC4DWizardUtils.ShowMsg('File not found');
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardUtilsOTA.OpenFilePathInIDE(LFilePath);
    ModalResult := mrOk;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardReopenView.btnOpenClick(Sender: TObject);
begin
  Self.OpenItem;
end;

procedure TC4DWizardReopenView.btnSearchClick(Sender: TObject);
begin
  Self.IniFileRead;
end;

procedure TC4DWizardReopenView.IniFileRead;
var
  LFilePath: string;
begin
  Screen.Cursor := crHourGlass;
  try
    if(ListViewHistory.Selected <> nil)then
      LFilePath := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_FilePath];

    ListViewHistory.Clear;
    TC4DWizardReopenModel.New.ReadIniFile(Self.ProcessItemReopenData);

    Self.SetOrderDefault;
    if(not LFilePath.Trim.IsEmpty)then
      TC4DWizardUtils.FindListVewItem(ListViewHistory, C_INDEX_SUBITEM_FilePath, LFilePath);
    Self.FillStatusBar(ListViewHistory.Selected);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardReopenView.ProcessItemReopenData(AC4DWizardReopenData: TC4DWizardReopenData);
var
  LStrSearch: string;
  LGuidGroup: string;
  LListItem: TListItem;
begin
  LStrSearch := LowerCase(edtSearch.Text);
  LGuidGroup := '';
  if(cBoxGroup.Items.Count > 0)and(cBoxGroup.ItemIndex >= 0)then
    LGuidGroup := TC4DWizardGroups(cBoxGroup.Items.Objects[cBoxGroup.ItemIndex]).Guid.Trim;

  if not(
    (LStrSearch.Trim.IsEmpty)
    or(AC4DWizardReopenData.FilePath.ToLower.Contains(LStrSearch))
    or(AC4DWizardReopenData.Nickname.ToLower.Contains(LStrSearch))
    or(AC4DWizardReopenData.Name.ToLower.Contains(LStrSearch))
    or(TC4DWizardUtils.DateTimeToStrEmpty(AC4DWizardReopenData.LastOpen).Contains(LStrSearch))
    or(TC4DWizardUtils.DateTimeToStrEmpty(AC4DWizardReopenData.LastClose).Contains(LStrSearch))
    or(AC4DWizardReopenData.FolderGit.ToLower.Contains(LStrSearch))
    )
  then
    Exit;

  if not(
    ((LGuidGroup.IsEmpty)or(LGuidGroup = TC4DConsts.GROUPS_GUID_ALL)or(AC4DWizardReopenData.GuidGroup = LGuidGroup))
    or((LGuidGroup = TC4DConsts.GROUPS_GUID_NO_GROUP)and(AC4DWizardReopenData.GuidGroup.Trim.IsEmpty))
    )
  then
    Exit;

  if(dtpOpenPeriodIni.Checked)and(dtpOpenPeriodEnd.Checked)then
  begin
    if(not DateInRange(AC4DWizardReopenData.LastOpen, dtpOpenPeriodIni.Date, dtpOpenPeriodEnd.Date))then
      Exit;
  end
  else if(dtpOpenPeriodIni.Checked)then
  begin
    if(AC4DWizardReopenData.LastOpen < dtpOpenPeriodIni.Date)then
      Exit;
  end
  else if(dtpOpenPeriodEnd.Checked)then
  begin
    if(AC4DWizardReopenData.LastOpen > dtpOpenPeriodEnd.Date)then
      Exit;
  end;

  LListItem := ListViewHistory.Items.Add;
  LListItem.Caption := IfThen(AC4DWizardReopenData.Favorite, '1', '0');
  LListItem.ImageIndex := IfThen(AC4DWizardReopenData.Favorite, 1, 0);
  LListItem.SubItems.Add(AC4DWizardReopenData.Nickname);
  LListItem.SubItems.Add(AC4DWizardReopenData.Name);
  LListItem.SubItems.Add(TC4DWizardUtils.DateTimeToStrEmpty(AC4DWizardReopenData.LastOpen));
  LListItem.SubItems.Add(TC4DWizardUtils.DateTimeToStrEmpty(AC4DWizardReopenData.LastClose));
  LListItem.SubItems.Add(AC4DWizardReopenData.FilePath);
  LListItem.SubItems.Add(AC4DWizardReopenData.Color);
  LListItem.SubItems.Add(AC4DWizardReopenData.FolderGit);
  LListItem.SubItems.Add(AC4DWizardReopenData.GuidGroup);
end;

procedure TC4DWizardReopenView.FillStatusBar(AItem: TListItem);
var
  LIndex: Integer;
  LFilePath: string;
begin
  LIndex := -1;
  LFilePath := '';
  if(AItem <> nil)then
  begin
    LIndex := AItem.Index;
    LFilePath := ListViewHistory.Items[LIndex].SubItems[C_INDEX_SUBITEM_FilePath];
  end;
  StatusBar1.Panels[0].Text := Format('%d of %d', [LIndex + 1, ListViewHistory.Items.Count]);
  StatusBar1.Panels[1].Text := LFilePath;
end;

procedure TC4DWizardReopenView.ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  Self.FillStatusBar(Item);
end;

procedure TC4DWizardReopenView.ListViewHistoryColumnClick(Sender: TObject; Column: TListColumn);
var
  LSortStyle: TC4DWizardUtilsListViewSortStyle;
begin
  LSortStyle := TC4DWizardUtilsListViewSortStyle.AlphaNum;
  case(Column.Index)of
    0:
    LSortStyle := TC4DWizardUtilsListViewSortStyle.Numeric;
    3, 4:
    LSortStyle := TC4DWizardUtilsListViewSortStyle.DateTime;
  end;

  FUtilsListView
    .InvertOrder(True)
    .SortStyle(LSortStyle)
    .ColumnIndex(Column.Index)
    .CustomSort;
end;

function TC4DWizardReopenView.GetFilePathItemSelectedInListView: string;
begin
  Result := '';
  if(ListViewHistory.Selected = nil)then
    Exit;

  Result := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_FilePath];
end;

procedure TC4DWizardReopenView.ViewFolderInExplorer1Click(Sender: TObject);
var
  LFilePath: string;
  LPathFolder: string;
begin
  LFilePath := Self.GetFilePathItemSelectedInListView;
  if(LFilePath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Path file not found');

  LPathFolder := ExtractFilePath(LFilePath);
  if(not System.SysUtils.DirectoryExists(LPathFolder))then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Folder not found');

  TC4DWizardUtils.OpenFolder(LPathFolder);
end;

procedure TC4DWizardReopenView.ViewFileInExplorer1Click(Sender: TObject);
var
  LFilePath: string;
begin
  LFilePath := Self.GetFilePathItemSelectedInListView;
  if(not System.SysUtils.FileExists(LFilePath))then
    TC4DWizardUtils.ShowMsgErrorAndAbort('File not found');

  TC4DWizardUtils.OpenFile(LFilePath);
end;

procedure TC4DWizardReopenView.RemoveSelectedFileFromHistory1Click(Sender: TObject);
var
  LFilePath: string;
begin
  LFilePath := Self.GetFilePathItemSelectedInListView;

  if(LFilePath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Path file not found');

  if(not TC4DWizardUtils.ShowQuestion2('Confirm remove?'))then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardReopenModel.New.RemoveFilePathInIniFile(LFilePath);
    Self.IniFileRead;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardReopenView.FillReopenDataSelectedItem(var AC4DWizardReopenData: TC4DWizardReopenData);
var
  LListItem: TListItem;
begin
  AC4DWizardReopenData.Clear;
  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  AC4DWizardReopenData.Favorite := LListItem.Caption = '1';
  AC4DWizardReopenData.Nickname := LListItem.SubItems[C_INDEX_SUBITEM_Nickname];
  AC4DWizardReopenData.Name := LListItem.SubItems[C_INDEX_SUBITEM_Name];
  AC4DWizardReopenData.LastOpen := StrToDateTimeDef(LListItem.SubItems[C_INDEX_SUBITEM_LastOpen], 0);
  AC4DWizardReopenData.LastClose := StrToDateTimeDef(LListItem.SubItems[C_INDEX_SUBITEM_LastClose], 0);
  AC4DWizardReopenData.FilePath := LListItem.SubItems[C_INDEX_SUBITEM_FilePath];
  AC4DWizardReopenData.Color := LListItem.SubItems[C_INDEX_SUBITEM_Color];
  AC4DWizardReopenData.FolderGit := LListItem.SubItems[C_INDEX_SUBITEM_FolderGit];
  AC4DWizardReopenData.GuidGroup := LListItem.SubItems[C_INDEX_SUBITEM_GuidGroup];
end;

procedure TC4DWizardReopenView.EditInformations1Click(Sender: TObject);
var
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  Self.FillReopenDataSelectedItem(LC4DWizardReopenData);
  if(LC4DWizardReopenData.FilePath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Path file not found');

  C4DWizardReopenViewEdit := TC4DWizardReopenViewEdit.Create(nil);
  try
    C4DWizardReopenViewEdit.C4DWizardReopenData := LC4DWizardReopenData;
    if(C4DWizardReopenViewEdit.ShowModal <> mrOk)then
      Exit;
    LC4DWizardReopenData := C4DWizardReopenViewEdit.C4DWizardReopenData;
  finally
    FreeAndNil(C4DWizardReopenViewEdit);
  end;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardReopenModel.New.EditDataInIniFile(LC4DWizardReopenData);
    Self.IniFileRead;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardReopenView.OpenInGitHubDesktop1Click(Sender: TObject);
var
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  Self.FillReopenDataSelectedItem(LC4DWizardReopenData);
  TC4DWizardReopenController.New(LC4DWizardReopenData).OpenInGitHubDesktop;
end;

procedure TC4DWizardReopenView.ViewInRemoteRepository1Click(Sender: TObject);
var
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  Self.FillReopenDataSelectedItem(LC4DWizardReopenData);
  TC4DWizardReopenController.New(LC4DWizardReopenData).ViewInRemoteRepository;
end;

procedure TC4DWizardReopenView.ConfButtonCreate;
begin
  btnOpen.Tag := btnOpen.Width;
  btnEditInformations.Tag := btnEditInformations.Width;
  btnMarkAsFavorite.Tag := btnMarkAsFavorite.Width;
  btnMarkAsUnfavorite.Tag := btnMarkAsUnfavorite.Width;
  btnRemove.Tag := btnRemove.Width;
  btnOpenInGitHubDesktop.Tag := btnOpenInGitHubDesktop.Width;
  btnViewInRemoteRepository.Tag := btnViewInRemoteRepository.Width;
  btnViewFileInExplorer.Tag := btnViewFileInExplorer.Width;
end;

procedure TC4DWizardReopenView.ConfButton(ABig: Boolean);
const
  WIDTH_SMALL = 35;
var
  LImageMarginsRight: Integer;
begin
  if(ABig)then
  begin
    LImageMarginsRight := 8;
    btnOpen.Width := btnOpen.Tag;
    btnEditInformations.Width := btnEditInformations.Tag;
    btnMarkAsFavorite.Width := btnMarkAsFavorite.Tag;
    btnMarkAsUnfavorite.Width := btnMarkAsUnfavorite.Tag;
    btnRemove.Width := btnRemove.Tag;
    btnOpenInGitHubDesktop.Width := btnOpenInGitHubDesktop.Tag;
    btnViewInRemoteRepository.Width := btnViewInRemoteRepository.Tag;
    btnViewFileInExplorer.Width := btnViewFileInExplorer.Tag;
  end
  else
  begin
    LImageMarginsRight := 200;
    btnOpen.Width := WIDTH_SMALL;
    btnEditInformations.Width := WIDTH_SMALL;
    btnMarkAsFavorite.Width := WIDTH_SMALL;
    btnMarkAsUnfavorite.Width := WIDTH_SMALL;
    btnRemove.Width := WIDTH_SMALL;
    btnOpenInGitHubDesktop.Width := WIDTH_SMALL;
    btnViewInRemoteRepository.Width := WIDTH_SMALL;
    btnViewFileInExplorer.Width := WIDTH_SMALL;
  end;
  btnOpen.ImageMargins.Right := LImageMarginsRight;
  btnEditInformations.ImageMargins.Right := LImageMarginsRight;
  btnMarkAsFavorite.ImageMargins.Right := LImageMarginsRight;
  btnMarkAsUnfavorite.ImageMargins.Right := LImageMarginsRight;
  btnRemove.ImageMargins.Right := LImageMarginsRight;
  btnOpenInGitHubDesktop.ImageMargins.Right := LImageMarginsRight;
  btnViewInRemoteRepository.ImageMargins.Right := LImageMarginsRight;
  btnViewFileInExplorer.ImageMargins.Right := LImageMarginsRight;
end;

procedure TC4DWizardReopenView.GroupClear;
var
  I: Integer;
  LC4DWizardReopenGroups: TC4DWizardGroups;
begin
  FGroupChangeAllow := False;
  for I := Pred(tvGroup.Items.Count) downto 0 do
  begin
    if(tvGroup.Items[I].Level = 0)then
    begin
      LC4DWizardReopenGroups := tvGroup.Items[I].Data;
      LC4DWizardReopenGroups.Free;
      tvGroup.Items[I].Data := nil;
    end;
  end;
  tvGroup.Items.Clear;
  cBoxGroup.Items.Clear;
end;

procedure TC4DWizardReopenView.GroupLoad;
var
  LNameDefaultGroup: string;
begin
  FGroupChangeAllow := False;
  Self.GroupClear;

  LNameDefaultGroup := '';
  TC4DWizardGroupsModel.New.ReadIniFile(
    procedure(AC4DWizardGroups: TC4DWizardGroups)
    var
      LTreeNode: TTreeNode;
      LC4DWizardGroups: TC4DWizardGroups;
    begin
      LC4DWizardGroups := TC4DWizardGroups.Create;
      LC4DWizardGroups.Guid := AC4DWizardGroups.Guid;
      LC4DWizardGroups.Name := AC4DWizardGroups.Name + IfThen(AC4DWizardGroups.DefaultGroup, '*', '');
      LC4DWizardGroups.DefaultGroup := AC4DWizardGroups.DefaultGroup;
      //TREEVIEW
      LTreeNode := tvGroup.Items.AddObject(nil, LC4DWizardGroups.Name, LC4DWizardGroups);
      LTreeNode.Selected := False;
      LTreeNode.ImageIndex := 0;
      LTreeNode.SelectedIndex := 1;

      //cBoxGroup
      cBoxGroup.Items.AddObject(LC4DWizardGroups.Name, LC4DWizardGroups);

      if(AC4DWizardGroups.DefaultGroup)then
      begin
        LTreeNode.Selected := True;
        LNameDefaultGroup := LC4DWizardGroups.Name;
      end;
    end
    );

  if(not LNameDefaultGroup.Trim.IsEmpty)then
    cBoxGroup.ItemIndex := cBoxGroup.Items.IndexOf(LNameDefaultGroup);

  tvGroup.SortType := stNone;
  tvGroup.SortType := stText
end;

procedure TC4DWizardReopenView.cBoxGroupChange(Sender: TObject);
begin
  if(cBoxGroup.ItemIndex < 0)then
    Exit;

  Self.SelectNodeGroup(TC4DWizardGroups(cBoxGroup.Items.Objects[cBoxGroup.ItemIndex]).Guid);
  btnSearch.Click;
end;

procedure TC4DWizardReopenView.SelectNodeGroup(const AGuid: string);
var
  LTreeNode: TTreeNode;
begin
  if(AGuid.Trim.IsEmpty)then
    Exit;

  LTreeNode := tvGroup.Items.GetFirstNode;
  while(LTreeNode <> nil)do
  begin
    if(TC4DWizardGroups(LTreeNode.Data).Guid = AGuid)then
    begin
      FGroupChangeAllow := False;
      tvGroup.Selected := LTreeNode;
      LTreeNode.MakeVisible;
      Break;
    end;
    LTreeNode := LTreeNode.GetNext;
  end;
end;

procedure TC4DWizardReopenView.tvGroupChange(Sender: TObject; Node: TTreeNode);
var
  I: Integer;
  LGuid: string;
begin
  if(Node = nil)then
    Exit;

  if(Node.Data = nil)then
    Exit;

  if(not FGroupChangeAllow)then
  begin
    FGroupChangeAllow := True;
    Exit;
  end;

  LGuid := TC4DWizardGroups(Node.Data).Guid;
  for I := 0 to Pred(cBoxGroup.Items.Count) do
  begin
    if(TC4DWizardGroups(cBoxGroup.Items.Objects[I]).Guid = LGuid)then
    begin
      cBoxGroup.ItemIndex := I;
      Break;
    end;
  end;
  btnSearch.Click;
end;

procedure TC4DWizardReopenView.tvGroupContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  LTreeNode: TTreeNode;
begin
  LTreeNode := tvGroup.GetNodeAt(MousePos.X, MousePos.Y);
  if(LTreeNode <> nil)then
    tvGroup.Selected := LTreeNode;
end;

procedure TC4DWizardReopenView.btnAddGroupClick(Sender: TObject);
begin
  C4DWizardGroupsViewShow;
  Self.GroupLoad;
end;

procedure TC4DWizardReopenView.PopupMenuTvGroupPopup(Sender: TObject);
begin
  MarkGroupAsDefault1.Checked := False;
  if(tvGroup.Selected <> nil)then
    MarkGroupAsDefault1.Checked := TC4DWizardGroups(tvGroup.Selected.Data).DefaultGroup;
end;

procedure TC4DWizardReopenView.MarkGroupAsDefault1Click(Sender: TObject);
var
  LTreeNode: TTreeNode;
  LC4DWizardGroups: TC4DWizardGroups;
begin
  if(tvGroup.Selected = nil)then
    Exit;

  LTreeNode := tvGroup.Selected;
  LC4DWizardGroups := TC4DWizardGroups(LTreeNode.Data);
  if(LC4DWizardGroups.Guid.Trim.IsEmpty)then
    Exit;
  if(LC4DWizardGroups.DefaultGroup)then
    Exit;

  LC4DWizardGroups.DefaultGroup := True;
  TC4DWizardGroupsModel.New.WriteInIniFile(LC4DWizardGroups);
  Self.GroupLoad;
end;

procedure TC4DWizardReopenView.CopyNickname1Click(Sender: TObject);
begin
  Self.CopyIndexSubItemListView(C_INDEX_SUBITEM_Nickname);
end;

procedure TC4DWizardReopenView.CopyName1Click(Sender: TObject);
begin
  Self.CopyIndexSubItemListView(C_INDEX_SUBITEM_Name);
end;

procedure TC4DWizardReopenView.CopyPath1Click(Sender: TObject);
begin
  Self.CopyIndexSubItemListView(C_INDEX_SUBITEM_FilePath);
end;

procedure TC4DWizardReopenView.CopyIndexSubItemListView(AIndexSubItem: Integer);
var
  LListItemSel: TListItem;
  LStrCopy: string;
begin
  if(AIndexSubItem < 0)then
    Exit;

  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItemSel := ListViewHistory.Items[ListViewHistory.Selected.Index];
  LStrCopy := LListItemSel.SubItems[AIndexSubItem];
  if(not LStrCopy.Trim.IsEmpty)then
    Clipboard.AsText := LStrCopy;
end;

procedure TC4DWizardReopenView.tvGroupDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListView);
end;

procedure TC4DWizardReopenView.tvGroupDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  LTreeNode: TTreeNode;
  LC4DWizardGroups: TC4DWizardGroups;
  LGroupsGuid: string;
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  LTreeNode := (Sender as TTreeView).GetNodeAt(X, Y);
  if(LTreeNode = nil)then
    Exit;
  LC4DWizardGroups := TC4DWizardGroups(LTreeNode.Data);
  LGroupsGuid := LC4DWizardGroups.Guid;
  if(LGroupsGuid = TC4DConsts.GROUPS_GUID_ALL)then
    Exit;

  Self.FillReopenDataSelectedItem(LC4DWizardReopenData);
  if(LC4DWizardReopenData.FilePath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Path file not found');

  Screen.Cursor := crHourGlass;
  try
    LC4DWizardReopenData.GuidGroup := LGroupsGuid;
    TC4DWizardReopenModel.New.EditDataInIniFile(LC4DWizardReopenData);
    Self.IniFileRead;
  finally
    Screen.Cursor := crDefault;
  end;
end;

initialization

finalization
  Unregister;

end.
