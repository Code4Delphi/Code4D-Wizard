unit C4D.Wizard.OpenExternal.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  C4D.Wizard.OpenExternal,
  C4D.Wizard.IDE.MainMenu,
  C4D.Wizard.Utils.ListView;

type
  TC4DWizardOpenExternalView = class(TForm)
    Panel1: TPanel;
    btnEdit: TButton;
    btnClose: TButton;
    ListViewHistory: TListView;
    pnTop: TPanel;
    btnSearch: TButton;
    edtSearch: TEdit;
    StatusBar1: TStatusBar;
    btnAdd: TButton;
    btnRemove: TButton;
    btnOpenRun: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewHistoryDblClick(Sender: TObject);
    procedure ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOpenRunClick(Sender: TObject);
    procedure ListViewHistoryColumnClick(Sender: TObject; Column: TListColumn);
  private
    FUtilsListView: IC4DWizardUtilsListView;
    FRecarregarMainMenuIDE: Boolean;
    procedure IniFileRead;
    procedure FillStatusBar(AItem: TListItem);
    procedure FillOpenExternalSelectedItem(var AC4DWizardOpenExternal: TC4DWizardOpenExternal);
    procedure ConfBtnOpenRun(AItem: TListItem);
  public

  end;

var
  C4DWizardOpenExternalView: TC4DWizardOpenExternalView;

procedure C4DWizardOpenExternalViewShow;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Types,
  C4D.Wizard.OpenExternal.Model,
  C4D.Wizard.OpenExternal.AddEdit.View,
  C4D.Wizard.ProcessDelphi,
  C4D.Wizard.OpenExternal.Utils,
  C4D.Wizard.IDE.ToolBars.Utilities;

{$R *.dfm}


const
  C_INDEX_SUBITEM_Order = 0;
  C_INDEX_SUBITEM_Shortcut = 1;
  C_INDEX_SUBITEM_Kind = 2;
  C_INDEX_SUBITEM_Visible = 3;
  C_INDEX_SUBITEM_VisibleToolBarUtilities = 4;
  C_INDEX_SUBITEM_Path = 5;
  C_INDEX_SUBITEM_Parameters = 6;
  C_INDEX_SUBITEM_IconHas = 7;
  C_INDEX_SUBITEM_Guid = 8;
  C_INDEX_SUBITEM_GuidMenuMaster = 9;

procedure C4DWizardOpenExternalViewShow;
begin
  C4DWizardOpenExternalView := TC4DWizardOpenExternalView.Create(nil);
  try
    C4DWizardOpenExternalView.ShowModal;
  finally
    FreeAndNil(C4DWizardOpenExternalView);
  end;
end;

procedure TC4DWizardOpenExternalView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardOpenExternalView, Self);
  FUtilsListView := TC4DWizardUtilsListView.New(ListViewHistory);
end;

procedure TC4DWizardOpenExternalView.FormShow(Sender: TObject);
begin
  Self.IniFileRead;

  if(ListViewHistory.Items.Count > 0)then
    ListViewHistory.Items.Item[0].Selected := True;
  FRecarregarMainMenuIDE := False;
  edtSearch.SetFocus;

  FUtilsListView
    .InvertOrder(False)
    .SortStyle(TC4DWizardUtilsListViewSortStyle.Numeric)
    .ColumnIndex(C_INDEX_SUBITEM_Order + 1)
    .CustomSort;
end;

procedure TC4DWizardOpenExternalView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if(FRecarregarMainMenuIDE)then
  begin
    TC4DWizardIDEMainMenu.GetInstance.CreateMenus;

    try
      if(Assigned(C4DWizardIDEToolBarsUtilities))then
        C4DWizardIDEToolBarsUtilities.RefreshButtons;
    except
      on E: Exception do
        TC4DWizardUtils.ShowError(E.Message);
    end;
  end;
end;

procedure TC4DWizardOpenExternalView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      btnClose.Click;
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

procedure TC4DWizardOpenExternalView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardOpenExternalView.btnSearchClick(Sender: TObject);
begin
  Self.IniFileRead;
end;

procedure TC4DWizardOpenExternalView.edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    Self.IniFileRead;
end;

procedure TC4DWizardOpenExternalView.IniFileRead;
var
  LStrSearch: string;
  LListItem: TListItem;
  LGuid: string;
begin
  LStrSearch := LowerCase(edtSearch.Text);

  if(ListViewHistory.Selected <> nil)then
    LGuid := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_Guid];

  ListViewHistory.Clear;
  TC4DWizardOpenExternalModel.New.ReadIniFile(
    procedure(AC4DWizardOpenExternal: TC4DWizardOpenExternal)
    begin
      if(LStrSearch.Trim.IsEmpty)
        or(AC4DWizardOpenExternal.Description.ToLower.Contains(LStrSearch))
        or(AC4DWizardOpenExternal.Path.ToLower.Contains(LStrSearch))
      then
      begin
        LListItem := ListViewHistory.Items.Add;
        LListItem.Caption := AC4DWizardOpenExternal.Description;
        LListItem.ImageIndex := -1;
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Order.ToString);
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Shortcut);
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Kind.ToString);
        LListItem.SubItems.Add(TC4DWizardUtils.BoolToStrC4D(AC4DWizardOpenExternal.Visible));
        LListItem.SubItems.Add(TC4DWizardUtils.BoolToStrC4D(AC4DWizardOpenExternal.VisibleInToolBarUtilities));
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Path);
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Parameters);
        LListItem.SubItems.Add(TC4DWizardUtils.BoolToStrC4D(AC4DWizardOpenExternal.IconHas));
        LListItem.SubItems.Add(AC4DWizardOpenExternal.Guid);
        LListItem.SubItems.Add(AC4DWizardOpenExternal.GuidMenuMaster);
      end;
    end
    );

  FUtilsListView
    .InvertOrder(False)
    .CustomSort;

  if(not LGuid.Trim.IsEmpty)then
    TC4DWizardUtils.FindListVewItem(ListViewHistory, C_INDEX_SUBITEM_Guid, LGuid);

  Self.FillStatusBar(ListViewHistory.Selected);
end;

procedure TC4DWizardOpenExternalView.ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  Self.FillStatusBar(Item);
  Self.ConfBtnOpenRun(Item);
end;

procedure TC4DWizardOpenExternalView.FillStatusBar(AItem: TListItem);
var
  LIndex: Integer;
  LPath: string;
  LParameters: string;
begin
  LIndex := -1;
  LPath := '';
  LParameters := '';
  if(AItem <> nil)then
  begin
    LIndex := AItem.Index;
    LPath := ListViewHistory.Items[LIndex].SubItems[C_INDEX_SUBITEM_Path];
    LParameters := ListViewHistory.Items[LIndex].SubItems[C_INDEX_SUBITEM_Parameters].Trim;
  end;

  StatusBar1.Panels[0].Text := Format('%d of %d', [LIndex + 1, ListViewHistory.Items.Count]);
  StatusBar1.Panels[1].Text := LPath + IfThen(LParameters.IsEmpty, '', ' ' + LParameters);
end;

procedure TC4DWizardOpenExternalView.ConfBtnOpenRun(AItem: TListItem);
var
  LKind: string;
begin
  btnOpenRun.Caption := 'Open path';
  btnOpenRun.Enabled := True;
  if(AItem = nil)then
    Exit;

  LKind := ListViewHistory.Items[AItem.Index].SubItems[C_INDEX_SUBITEM_Kind];
  if(LKind = TC4DWizardOpenExternalKind.CMD.ToString)then
    btnOpenRun.Caption := 'Run command'
  else if(LKind = TC4DWizardOpenExternalKind.Separators.ToString)then
    btnOpenRun.Enabled := False;
end;

procedure TC4DWizardOpenExternalView.ListViewHistoryColumnClick(Sender: TObject; Column: TListColumn);
var
  LSortStyle: TC4DWizardUtilsListViewSortStyle;
begin
  LSortStyle := TC4DWizardUtilsListViewSortStyle.AlphaNum;
  case(Column.Index)of
    C_INDEX_SUBITEM_Order + 1:
    LSortStyle := TC4DWizardUtilsListViewSortStyle.Numeric;
  end;

  FUtilsListView
    .InvertOrder(True)
    .SortStyle(LSortStyle)
    .ColumnIndex(Column.Index)
    .CustomSort;
end;

procedure TC4DWizardOpenExternalView.ListViewHistoryDblClick(Sender: TObject);
begin
  btnEdit.Click
end;

procedure TC4DWizardOpenExternalView.ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    btnEdit.Click
end;

procedure TC4DWizardOpenExternalView.btnAddClick(Sender: TObject);
var
  LC4DWizardOpenExternal: TC4DWizardOpenExternal;
begin
  LC4DWizardOpenExternal := TC4DWizardOpenExternal.Create;
  try
    LC4DWizardOpenExternal.Guid := TC4DWizardUtils.GetGuidStr;
    LC4DWizardOpenExternal.Visible := True;
    LC4DWizardOpenExternal.VisibleInToolBarUtilities := False;
    C4DWizardOpenExternalAddEditView := TC4DWizardOpenExternalAddEditView.Create(nil);
    try
      C4DWizardOpenExternalAddEditView.Caption := 'Code4D Open External - Adding';
      C4DWizardOpenExternalAddEditView.C4DWizardOpenExternal := LC4DWizardOpenExternal;
      if(C4DWizardOpenExternalAddEditView.ShowModal <> mrOk)then
        Exit;
      FRecarregarMainMenuIDE := True;
    finally
      FreeAndNil(C4DWizardOpenExternalAddEditView);
    end;
    Self.IniFileRead;
  finally
    LC4DWizardOpenExternal.Free;
  end;
end;

procedure TC4DWizardOpenExternalView.btnEditClick(Sender: TObject);
var
  LC4DWizardOpenExternal: TC4DWizardOpenExternal;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LC4DWizardOpenExternal := TC4DWizardOpenExternal.Create;
  try
    Self.FillOpenExternalSelectedItem(LC4DWizardOpenExternal);
    if(LC4DWizardOpenExternal.Description.Trim.IsEmpty)then
      TC4DWizardUtils.ShowMsgErrorAndAbort('Name group not found');

    C4DWizardOpenExternalAddEditView := TC4DWizardOpenExternalAddEditView.Create(nil);
    try
      C4DWizardOpenExternalAddEditView.Caption := 'Code4D Open External - Editing';
      C4DWizardOpenExternalAddEditView.C4DWizardOpenExternal := LC4DWizardOpenExternal;
      if(C4DWizardOpenExternalAddEditView.ShowModal <> mrOk)then
        Exit;
      FRecarregarMainMenuIDE := True;
    finally
      FreeAndNil(C4DWizardOpenExternalAddEditView);
    end;
    Self.IniFileRead;
  finally
    LC4DWizardOpenExternal.Free;
  end;
end;

procedure TC4DWizardOpenExternalView.btnOpenRunClick(Sender: TObject);
var
  LPath: string;
  LParameters: string;
  LKind: string;
  LItem: TListItem;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  LPath := LItem.SubItems[C_INDEX_SUBITEM_Path];
  if(LPath.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('Path is empty');

  LParameters := LItem.SubItems[C_INDEX_SUBITEM_Parameters];
  LKind := LItem.SubItems[C_INDEX_SUBITEM_Kind];
  if(LKind = TC4DWizardOpenExternalKind.CMD.ToString)then
    TC4DWizardProcessDelphi.RunCommand(TC4DWizardOpenExternalUtils.ProcessTags(LParameters))
  else
    TC4DWizardUtils.ShellExecuteC4D(TC4DWizardOpenExternalUtils.ProcessTags(LPath),
      TC4DWizardOpenExternalUtils.ProcessTags(LParameters));
end;

procedure TC4DWizardOpenExternalView.FillOpenExternalSelectedItem(var AC4DWizardOpenExternal: TC4DWizardOpenExternal);
var
  LListItem: TListItem;
begin
  AC4DWizardOpenExternal.Clear;
  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  AC4DWizardOpenExternal.Description := LListItem.Caption;
  AC4DWizardOpenExternal.Order := StrToIntDef(LListItem.SubItems[C_INDEX_SUBITEM_Order], 0);
  AC4DWizardOpenExternal.Shortcut := LListItem.SubItems[C_INDEX_SUBITEM_Shortcut];
  AC4DWizardOpenExternal.Kind := TC4DWizardUtils.StrToOpenExternalKind(LListItem.SubItems[C_INDEX_SUBITEM_Kind]);
  AC4DWizardOpenExternal.Visible := TC4DWizardUtils.StrToBoolC4D(LListItem.SubItems[C_INDEX_SUBITEM_Visible]);
  AC4DWizardOpenExternal.VisibleInToolBarUtilities := TC4DWizardUtils.StrToBoolC4D(LListItem.SubItems[C_INDEX_SUBITEM_VisibleToolBarUtilities]);

  AC4DWizardOpenExternal.Path := LListItem.SubItems[C_INDEX_SUBITEM_Path];
  AC4DWizardOpenExternal.Parameters := LListItem.SubItems[C_INDEX_SUBITEM_Parameters];
  AC4DWizardOpenExternal.IconHas := TC4DWizardUtils.StrToBoolC4D(LListItem.SubItems[C_INDEX_SUBITEM_IconHas]);
  AC4DWizardOpenExternal.Guid := LListItem.SubItems[C_INDEX_SUBITEM_Guid];
  AC4DWizardOpenExternal.GuidMenuMaster := LListItem.SubItems[C_INDEX_SUBITEM_GuidMenuMaster];
end;

procedure TC4DWizardOpenExternalView.btnRemoveClick(Sender: TObject);
var
  LGuid: string;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LGuid := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_Guid];
  if(LGuid.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Guid not found');

  if(TC4DWizardOpenExternalModel.New.ExistGuidInIniFile(LGuid))then
    TC4DWizardUtils.ShowMsgAndAbort('This registration cannot be deleted, as it is linked to other registration(s)');

  if(not TC4DWizardUtils.ShowQuestion2('Confirm remove?'))then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardOpenExternalModel.New.RemoveGuidInIniFile(LGuid);
    Self.IniFileRead;
  finally
    FRecarregarMainMenuIDE := True;
    Screen.Cursor := crDefault;
  end;
end;

end.
