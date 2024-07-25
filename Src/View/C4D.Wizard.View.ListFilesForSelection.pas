unit C4D.Wizard.View.ListFilesForSelection;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  C4D.Wizard.Utils,
  C4D.Wizard.Types,
  C4D.Wizard.Utils.OTA,
  Vcl.ComCtrls,
  Vcl.Menus;

type
  TC4DWizardViewListFilesForSelection = class(TForm)
    pnButtons: TPanel;
    btnClose: TButton;
    btnOk: TButton;
    pnBody: TPanel;
    Bevel1: TBevel;
    Splitter1: TSplitter;
    pnOrigin: TPanel;
    pnControls: TPanel;
    btnAdd: TButton;
    btnRemove: TButton;
    Panel2: TPanel;
    pnTotalOrigin: TPanel;
    ListViewOrigin: TListView;
    Panel4: TPanel;
    ListViewDestiny: TListView;
    pnCountDestiny: TPanel;
    lbCountOrigin: TLabel;
    lbCountDestiny: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edtFindOrigin: TEdit;
    PopupMenuOrigin: TPopupMenu;
    CopyNameOrigin1: TMenuItem;
    CopyPathOrigin1: TMenuItem;
    PopupMenuDestiny: TPopupMenu;
    CopyNameDestiny1: TMenuItem;
    CopyPathDestiny1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    edtFindDestiny: TEdit;
    btnRemoveAll: TButton;
    btnAddAllOpens: TButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure ListViewOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewOriginDblClick(Sender: TObject);
    procedure ListViewDestinyDblClick(Sender: TObject);
    procedure ListViewDestinyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtFindOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CopyNameOrigin1Click(Sender: TObject);
    procedure CopyPathOrigin1Click(Sender: TObject);
    procedure CopyPathDestiny1Click(Sender: TObject);
    procedure CopyNameDestiny1Click(Sender: TObject);
    procedure edtFindDestinyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ListViewOriginCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListViewDestinyCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnRemoveAllClick(Sender: TObject);
    procedure btnAddAllOpensClick(Sender: TObject);
  private
    FFilePathProjectOrGroupForFilter: string;
    FListFilesPathsDefaults: TStrings;
    procedure FillListViewsWithfilesProjectOrGroup;
    procedure ChangeItemBetweenListView(const AListViewOrigin, AListViewDestiny: TListView);
    procedure CountItems;
    procedure WaitingFormON;
    procedure WaitingFormOFF;
  public
    property FilePathProjectOrGroupForFilter: string write FFilePathProjectOrGroupForFilter;
    property ListFilesPathsDefaults: TStrings write FListFilesPathsDefaults;
    function GetPathListInstring(const ASeparator: string): string;
  end;

implementation

{$R *.dfm}


uses
  C4D.Wizard.Utils.ListView;

const
  C_INDEX_SUBITEM_Path = 0;
  C_INDEX_SUBITEM_FileIsOpen = 1;

procedure TC4DWizardViewListFilesForSelection.FormCreate(Sender: TObject);
begin
  Self.Width := Screen.Width - 200;
  Self.Height := Screen.Height - 250;
  pnOrigin.Width := (Self.Width div 2) - 10;
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardViewListFilesForSelection, Self);

  Self.Constraints.MinHeight := 300;
  Self.Constraints.MinWidth := 250;
end;

procedure TC4DWizardViewListFilesForSelection.FormShow(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
  Self.FillListViewsWithfilesProjectOrGroup;
end;

procedure TC4DWizardViewListFilesForSelection.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      btnOk.Click;
    VK_DOWN, VK_UP:
    begin
      if(ListViewOrigin <> ActiveControl)then
      begin
        case(Key)of
          VK_DOWN:
          if(ListViewOrigin.ItemIndex < Pred(ListViewOrigin.Items.Count))then
            ListViewOrigin.ItemIndex := ListViewOrigin.ItemIndex + 1;
          VK_UP:
          if(ListViewOrigin.ItemIndex > 0)then
            ListViewOrigin.ItemIndex := ListViewOrigin.ItemIndex - 1;
        end;
        Key := 0;
      end;
    end;
  end;
end;

procedure TC4DWizardViewListFilesForSelection.WaitingFormON;
begin
  Screen.Cursor := crHourGlass;
  pnBody.Enabled := False;
  btnOk.Enabled := False;
  btnClose.Enabled := False;
end;

procedure TC4DWizardViewListFilesForSelection.WaitingFormOFF;
begin
  Screen.Cursor := crDefault;
  pnBody.Enabled := True;
  btnOk.Enabled := True;
  btnClose.Enabled := True;
end;

procedure TC4DWizardViewListFilesForSelection.FillListViewsWithfilesProjectOrGroup;
begin
  ListViewOrigin.Clear;
  ListViewDestiny.Clear;

  TThread.CreateAnonymousThread(
    procedure
    var
      LStrings: TStrings;
      LListItem: TListItem;
    begin
      TThread.Synchronize(TThread.CurrenTThread,
        procedure
        begin
          Self.WaitingFormON;
          TC4DWizardUtils.WaitingScreenShow('Wait, loading files...');
        end);

      TThread.Sleep(100);
      LStrings := TStringList.Create;
      try
        TC4DWizardUtilsOTA.GetAllFilesFromProjectGroup(LStrings,
          FFilePathProjectOrGroupForFilter, [TC4DExtensionsFiles.PAS, TC4DExtensionsFiles.DPR]);

        TThread.Synchronize(nil,
          procedure
          var
            LItemFilePath: string;
            LFileIsSelected: Boolean;
          begin
            for LItemFilePath in LStrings do
            begin
              LFileIsSelected := FListFilesPathsDefaults.IndexOf(LItemFilePath) >= 0;
              if(LFileIsSelected)then
                LListItem := ListViewDestiny.Items.Add
              else
                LListItem := ListViewOrigin.Items.Add;
              LListItem.Caption := ExtractFileName(LItemFilePath);
              LListItem.ImageIndex := -1;
              LListItem.SubItems.Add(LItemFilePath);
              LListItem.SubItems.Add(TC4DWizardUtilsOTA.FileIsOpenInIDE(LItemFilePath).ToString(TUseBoolStrs.True));
            end;
          end);
      finally
        LStrings.Free;

        TThread.Synchronize(nil,
          procedure
          begin
            Self.WaitingFormOFF;
            TC4DWizardUtils.WaitingScreenHide;

            Self.CountItems;
            if(ListViewOrigin.Items.Count > 0)then
              ListViewOrigin.Items.Item[0].Selected := True;
            edtFindOrigin.SetFocus;
          end);
      end;
    end).Start;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewOriginCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LFileIsOpen: Boolean;
begin
  LFileIsOpen := Item.SubItems[C_INDEX_SUBITEM_FileIsOpen].Trim = 'True';
  if(LFileIsOpen)then
  begin
    Sender.Canvas.Font.Color := clGreen;
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
  end;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewDestinyCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  LFileIsOpen: Boolean;
begin
  LFileIsOpen := Item.SubItems[C_INDEX_SUBITEM_FileIsOpen].Trim = 'True';
  if(LFileIsOpen)then
  begin
    Sender.Canvas.Font.Color := clGreen;
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
  end;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewOriginDblClick(Sender: TObject);
begin
  btnAdd.Click;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    btnAdd.Click;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewDestinyDblClick(Sender: TObject);
begin
  btnRemove.Click;
end;

procedure TC4DWizardViewListFilesForSelection.ListViewDestinyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    btnRemove.Click;
end;

procedure TC4DWizardViewListFilesForSelection.btnAddClick(Sender: TObject);
begin
  Self.ChangeItemBetweenListView(ListViewOrigin, ListViewDestiny);
end;

procedure TC4DWizardViewListFilesForSelection.btnRemoveClick(Sender: TObject);
begin
  Self.ChangeItemBetweenListView(ListViewDestiny, ListViewOrigin);
end;

procedure TC4DWizardViewListFilesForSelection.btnRemoveAllClick(Sender: TObject);
begin
  if(ListViewDestiny.Items.Count <= 0)then
    Exit;

  ListViewDestiny.Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    while(ListViewDestiny.Items.Count > 0)do
    begin
      ListViewDestiny.Items.Item[0].Selected := True;
      Self.ChangeItemBetweenListView(ListViewDestiny, ListViewOrigin);
    end;
  finally
    ListViewDestiny.Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardViewListFilesForSelection.btnAddAllOpensClick(Sender: TObject);
var
  LIndexOrigin: Integer;
begin
  if(ListViewOrigin.Items.Count <= 0)then
    Exit;

  ListViewOrigin.Enabled := False;
  Screen.Cursor := crHourGlass;
  try
    for LIndexOrigin := Pred(ListViewOrigin.Items.Count) downto 0 do
    begin
      if(ListViewOrigin.Items[LIndexOrigin].SubItems[C_INDEX_SUBITEM_FileIsOpen] = 'True')then
      begin
        ListViewOrigin.Items[LIndexOrigin].Selected := True;
        Self.ChangeItemBetweenListView(ListViewOrigin, ListViewDestiny);
      end;
    end;
  finally
    ListViewOrigin.Enabled := True;
    Screen.Cursor := crDefault;
  end;
end;

procedure TC4DWizardViewListFilesForSelection.ChangeItemBetweenListView(const AListViewOrigin, AListViewDestiny: TListView);
var
  LListItem: TListItem;
  LIndexOrigin: Integer;
begin
  if(AListViewOrigin.Selected = nil)then
    Exit;

  LIndexOrigin := AListViewOrigin.Selected.Index;
  LListItem := AListViewDestiny.Items.Add;
  LListItem.Caption := AListViewOrigin.Items[LIndexOrigin].Caption;
  LListItem.ImageIndex := -1;
  LListItem.SubItems.Add(AListViewOrigin.Items[LIndexOrigin].SubItems[C_INDEX_SUBITEM_Path]);
  LListItem.SubItems.Add(AListViewOrigin.Items[LIndexOrigin].SubItems[C_INDEX_SUBITEM_FileIsOpen]);

  AListViewOrigin.Items[LIndexOrigin].Delete;
  if(AListViewOrigin.Items.Item[LIndexOrigin] <> nil)then
    AListViewOrigin.Items.Item[LIndexOrigin].Selected := True
  else if(AListViewOrigin.Items.Item[Pred(LIndexOrigin)] <> nil)then
    AListViewOrigin.Items.Item[Pred(LIndexOrigin)].Selected := True;

  AListViewDestiny.Items[LListItem.Index].Selected := True;
  Self.CountItems;
end;

procedure TC4DWizardViewListFilesForSelection.CopyNameOrigin1Click(Sender: TObject);
begin
  TC4DWizardUtilsListView.New(ListViewOrigin).CopyIndexListView(-1);
end;

procedure TC4DWizardViewListFilesForSelection.CopyPathOrigin1Click(Sender: TObject);
begin
  TC4DWizardUtilsListView.New(ListViewOrigin).CopyIndexListView(C_INDEX_SUBITEM_Path);
end;

procedure TC4DWizardViewListFilesForSelection.CopyNameDestiny1Click(Sender: TObject);
begin
  TC4DWizardUtilsListView.New(ListViewDestiny).CopyIndexListView(-1);
end;

procedure TC4DWizardViewListFilesForSelection.CopyPathDestiny1Click(Sender: TObject);
begin
  TC4DWizardUtilsListView.New(ListViewDestiny).CopyIndexListView(C_INDEX_SUBITEM_Path);
end;

procedure TC4DWizardViewListFilesForSelection.CountItems;
begin
  lbCountOrigin.Caption := '0';
  lbCountDestiny.Caption := '0';

  if(ListViewOrigin.Items.Count > 0)then
    lbCountOrigin.Caption := ListViewOrigin.Items.Count.ToString;

  if(ListViewDestiny.Items.Count > 0)then
    lbCountDestiny.Caption := ListViewDestiny.Items.Count.ToString;
end;

function TC4DWizardViewListFilesForSelection.GetPathListInstring(const ASeparator: string): string;
var
  LListItem: TListItem;
  LRelativePath: string;
begin
  Result := '';
  if(ListViewDestiny.Items.Count <= 0)then
    Exit;

  for LListItem in ListViewDestiny.Items do
  begin
    LRelativePath := LListItem.SubItems[C_INDEX_SUBITEM_Path];
    if(not FFilePathProjectOrGroupForFilter.Trim.IsEmpty)then
      LRelativePath := TC4DWizardUtils
        .PathAbsoluteToRelative(LRelativePath, ExtractFileDir(FFilePathProjectOrGroupForFilter));
    Result := Result + LRelativePath + ASeparator;
  end;
  Result := copy(Result, 1, Result.Length - ASeparator.Length);
end;

procedure TC4DWizardViewListFilesForSelection.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardViewListFilesForSelection.btnOkClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrOK;
end;

procedure TC4DWizardViewListFilesForSelection.edtFindOriginKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
  begin
    TC4DWizardUtilsListView
      .New(ListViewOrigin)
      .FindAndSelectItems(edtFindOrigin.Text, C_INDEX_SUBITEM_Path);
  end;
end;

procedure TC4DWizardViewListFilesForSelection.edtFindDestinyKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
  begin
    TC4DWizardUtilsListView
      .New(ListViewDestiny)
      .FindAndSelectItems(edtFindDestiny.Text, C_INDEX_SUBITEM_Path);
  end;
end;

end.
