unit C4D.Wizard.Groups.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  C4D.Wizard.Groups;

type
  TC4DWizardGroupsView = class(TForm)
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
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ListViewHistoryDblClick(Sender: TObject);
    procedure ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    procedure IniFileRead;
    procedure FillStatusBar(AItem: TListItem);
    procedure FillGroupsSelectedItem(var AC4DWizardGroups: TC4DWizardGroups);
  public

  end;

var
  C4DWizardGroupsView: TC4DWizardGroupsView;

procedure C4DWizardGroupsViewShow;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Groups.Model,
  C4D.Wizard.Groups.AddEdit.View,
  C4D.Wizard.Reopen.Model;

{$R *.dfm}


const
  C_INDEX_SUBITEM_DefaultGroup = 0;
  C_INDEX_SUBITEM_FixedSystem = 1;
  C_INDEX_SUBITEM_Guid = 2;

procedure C4DWizardGroupsViewShow;
begin
  C4DWizardGroupsView := TC4DWizardGroupsView.Create(nil);
  try
    C4DWizardGroupsView.ShowModal;
  finally
    FreeAndNil(C4DWizardGroupsView);
  end;
end;

procedure TC4DWizardGroupsView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardGroupsView, Self);
end;

procedure TC4DWizardGroupsView.FormShow(Sender: TObject);
begin
  Self.IniFileRead;
  if(ListViewHistory.Items.Count > 0)then
    ListViewHistory.Items.Item[0].Selected := True;
  edtSearch.SetFocus;
end;

procedure TC4DWizardGroupsView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardGroupsView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardGroupsView.btnSearchClick(Sender: TObject);
begin
  Self.IniFileRead;
end;

procedure TC4DWizardGroupsView.edtSearchKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    Self.IniFileRead;
end;

procedure TC4DWizardGroupsView.IniFileRead;
var
  LStrSearch: string;
  LListItem: TListItem;
  LGuid: string;
begin
  LStrSearch := LowerCase(edtSearch.Text);

  if(ListViewHistory.Selected <> nil)then
    LGuid := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_Guid];

  ListViewHistory.Clear;
  TC4DWizardGroupsModel.New.ReadIniFile(
    procedure(AC4DWizardGroups: TC4DWizardGroups)
    begin
      if(LStrSearch.Trim.IsEmpty)
        or(AC4DWizardGroups.Name.ToLower.Contains(LStrSearch))
      then
      begin
        LListItem := ListViewHistory.Items.Add;
        LListItem.Caption := AC4DWizardGroups.Name;
        LListItem.ImageIndex := -1;
        LListItem.SubItems.Add(TC4DWizardUtils.BoolToStrC4D(AC4DWizardGroups.DefaultGroup));
        LListItem.SubItems.Add(TC4DWizardUtils.BoolToStrC4D(AC4DWizardGroups.FixedSystem));
        LListItem.SubItems.Add(AC4DWizardGroups.Guid);
      end;
    end
    );

  if(not LGuid.Trim.IsEmpty)then
    TC4DWizardUtils.FindListVewItem(ListViewHistory, C_INDEX_SUBITEM_Guid, LGuid);

  Self.FillStatusBar(ListViewHistory.Selected);
end;

procedure TC4DWizardGroupsView.ListViewHistorySelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  Self.FillStatusBar(Item);
end;

procedure TC4DWizardGroupsView.FillStatusBar(AItem: TListItem);
var
  LIndex: Integer;
begin
  LIndex:= -1;
  if(AItem <> nil)then
    LIndex := AItem.Index;

  StatusBar1.Panels[0].Text := Format('%d of %d', [LIndex + 1, ListViewHistory.Items.Count]);
end;

procedure TC4DWizardGroupsView.ListViewHistoryDblClick(Sender: TObject);
begin
  btnEdit.Click
end;

procedure TC4DWizardGroupsView.ListViewHistoryKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    btnEdit.Click
end;

procedure TC4DWizardGroupsView.btnAddClick(Sender: TObject);
var
  LC4DWizardGroups: TC4DWizardGroups;
begin
  LC4DWizardGroups := TC4DWizardGroups.Create;
  try
    LC4DWizardGroups.Guid := TC4DWizardUtils.GetGuidStr;
    C4DWizardGroupsAddEditView := TC4DWizardGroupsAddEditView.Create(nil);
    try
      C4DWizardGroupsAddEditView.Caption := 'Code4D - Adding Group';
      C4DWizardGroupsAddEditView.C4DWizardGroups := LC4DWizardGroups;
      if(C4DWizardGroupsAddEditView.ShowModal <> mrOk)then
        Exit;
    finally
      FreeAndNil(C4DWizardGroupsAddEditView);
    end;
    TC4DWizardGroupsModel.New.WriteInIniFile(LC4DWizardGroups);
    Self.IniFileRead;
  finally
    LC4DWizardGroups.Free;
  end;
end;

procedure TC4DWizardGroupsView.btnEditClick(Sender: TObject);
var
  LC4DWizardGroups: TC4DWizardGroups;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LC4DWizardGroups := TC4DWizardGroups.Create;
  try
    Self.FillGroupsSelectedItem(LC4DWizardGroups);
    if(LC4DWizardGroups.Name.Trim.IsEmpty)then
      TC4DWizardUtils.ShowMsgErrorAndAbort('Name group not found');

    C4DWizardGroupsAddEditView := TC4DWizardGroupsAddEditView.Create(nil);
    try
      C4DWizardGroupsAddEditView.Caption := 'Code4D - Editing Group';
      C4DWizardGroupsAddEditView.C4DWizardGroups := LC4DWizardGroups;
      if(C4DWizardGroupsAddEditView.ShowModal <> mrOk)then
        Exit;
    finally
      FreeAndNil(C4DWizardGroupsAddEditView);
    end;

    TC4DWizardGroupsModel.New.WriteInIniFile(LC4DWizardGroups);
    Self.IniFileRead;
  finally
    LC4DWizardGroups.Free;
  end;
end;

procedure TC4DWizardGroupsView.FillGroupsSelectedItem(var AC4DWizardGroups: TC4DWizardGroups);
var
  LListItem: TListItem;
begin
  AC4DWizardGroups.Clear;
  if(ListViewHistory.Selected = nil)then
    Exit;

  LListItem := ListViewHistory.Items[ListViewHistory.Selected.Index];
  AC4DWizardGroups.Name := LListItem.Caption;
  AC4DWizardGroups.DefaultGroup := TC4DWizardUtils.StrToBoolC4D(LListItem.SubItems[C_INDEX_SUBITEM_DefaultGroup]);
  AC4DWizardGroups.FixedSystem := TC4DWizardUtils.StrToBoolC4D(LListItem.SubItems[C_INDEX_SUBITEM_FixedSystem]);
  AC4DWizardGroups.Guid := LListItem.SubItems[C_INDEX_SUBITEM_Guid];
end;

procedure TC4DWizardGroupsView.btnRemoveClick(Sender: TObject);
var
  LGuid: string;
begin
  if(ListViewHistory.Selected = nil)then
    Exit;

  LGuid := ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_Guid].Trim;
  if(LGuid.IsEmpty)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('Guid not found');

  if(TC4DWizardUtils.StrToBoolC4D(ListViewHistory.Items[ListViewHistory.Selected.Index].SubItems[C_INDEX_SUBITEM_FixedSystem]))then
    TC4DWizardUtils.ShowMsgAndAbort('It is not allowed to exclude fixed groups');

  if(LGuid.ToUpper = TC4DConsts.GROUPS_GUID_ALL)or(LGuid.ToUpper = TC4DConsts.GROUPS_GUID_NO_GROUP)then
    TC4DWizardUtils.ShowMsgAndAbort('This is a standard group and therefore cannot be deleted');

  if(TC4DWizardReopenModel.New.ReadIniFileIfExistGuidGroup(LGuid))then
    TC4DWizardUtils.ShowMsgAndAbort('This group cannot be deleted, as it is linked to a register of Reopen');

  if(not TC4DWizardUtils.ShowQuestion2('Confirm remove?'))then
    Exit;

  Screen.Cursor := crHourGlass;
  try
    TC4DWizardGroupsModel.New.RemoveGuidInIniFile(LGuid);
    Self.IniFileRead;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
