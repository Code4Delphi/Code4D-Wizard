unit C4D.Wizard.Utils.ListView;

interface

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.ComCtrls;

type
  {$SCOPEDENUMS ON}
  TC4DWizardUtilsListViewSortStyle = (AlphaNum, Numeric, DateTime);
  {$SCOPEDENUMS OFF}

  IC4DWizardUtilsListView = Interface
    ['{D22120F2-306D-40BB-9038-89E0AE33F893}']
    procedure FindAndSelectItems(const AStrFind: string;
      const ANumColumn: Integer;
      const AAutoRestart: Boolean = True);
    procedure CopyIndexListView(const AIndexSubItem: Integer);
    function SortStyle(const ASortStyle: TC4DWizardUtilsListViewSortStyle): IC4DWizardUtilsListView;
    function InvertOrder(const AInvertOrder: Boolean): IC4DWizardUtilsListView;
    function ColumnIndex(const AColumnIndex: Integer): IC4DWizardUtilsListView;
    procedure CustomSort;
  End;

  TC4DWizardUtilsListView = class(TInterfacedObject, IC4DWizardUtilsListView)
  private
    FListView: TListView;
    FColumnIndex: Integer;
    class var FInvertOrder: Boolean;
    class var FSortOrder: array[0..10] of Boolean;
    class var FSortStyle: TC4DWizardUtilsListViewSortStyle;
  protected
    procedure FindAndSelectItems(const AStrFind: string;
      const ANumColumn: Integer;
      const AAutoRestart: Boolean = True);
    procedure CopyIndexListView(const AIndexSubItem: Integer);
    function SortStyle(const ASortStyle: TC4DWizardUtilsListViewSortStyle): IC4DWizardUtilsListView;
    function InvertOrder(const AInvertOrder: Boolean): IC4DWizardUtilsListView;
    function ColumnIndex(const AColumnIndex: Integer): IC4DWizardUtilsListView;
    procedure CustomSort;
  public
    class function New(AListView: TListView): IC4DWizardUtilsListView;
    constructor Create(AListView: TListView);
  end;

implementation

uses
  Vcl.Clipbrd,
  C4D.Wizard.Utils.GetIniPositionStr;

{$REGION 'functions locais'}

function IsValidNumber(Astring: string; var AInteger: Integer): Boolean;
var
  LCode: Integer;
begin
  Val(Astring, AInteger, LCode);
  Result := (LCode = 0);
end;

function IsValidDate(Astring: string; var ADateTime: TDateTime): Boolean;
begin
  Result := True;
  try
    ADateTime := StrToDateTime(Astring);
  except
    ADateTime := 0;
    Result := False;
  end;
end;

function CompareDates(dt1, dt2: TDateTime): Integer;
begin
  Result := -1;
  if(dt1 > dt2)then
    Result := 1
  else if(dt1 = dt2)then
    Result := 0;
end;

function CompareNumeric(AInt1, AInt2: Integer): Integer;
begin
  Result := -1;
  if(AInt1 > AInt2)then
    Result := 1
  else if(AInt1 = AInt2)then
    Result := 0;
end;
{$ENDREGION}


procedure TC4DWizardUtilsListView.FindAndSelectItems(const AStrFind: string;
  const ANumColumn: Integer;
  const AAutoRestart: Boolean = True);
var
  LColIni: Integer;
  i: Integer;
  LIndexCurrent: Integer;
  LListItem: TListItem;
  LUtilsGetIniPositionStr: IC4DWizardUtilsGetIniPositionStr;
  LStrSource: string;
  LStrFind: string;
begin
  if(FListView.Items.Count <= 0)then
    Exit;

  LStrFind := AStrFind.ToLower;
  if(LStrFind.Trim.IsEmpty)then
    Exit;

  LUtilsGetIniPositionStr := TC4DWizardUtilsGetIniPositionStr.New
    .WholeWordOnly(False)
    .CaseSensitive(False);

  LIndexCurrent := 0;
  if(FListView.Selected <> nil)then
    LIndexCurrent := FListView.Selected.Index + 1;

  for i := LIndexCurrent to Pred(FListView.Items.Count) do
  begin
    LListItem := FListView.Items[i];
    if(ANumColumn = 0)then
      LStrSource := LowerCase(LListItem.Caption)
    else if(ANumColumn > 0)then
      LStrSource := LowerCase(LListItem.SubItems[Pred(ANumColumn)]);

    LColIni := 0;
    LColIni := LUtilsGetIniPositionStr.GetInitialPosition(LStrSource, LStrFind, LColIni);
    if(LColIni > -1)then
    begin
      FListView.Selected := LListItem;
      LListItem.MakeVisible(False);
      Exit;
    end;
  end;

  if(AAutoRestart)then
  begin
    if(FListView.Items.Count > 0)then
      FListView.Items.Item[0].Selected := True;
    Self.FindAndSelectItems(AStrFind, ANumColumn, False);
  end;
end;

procedure TC4DWizardUtilsListView.CopyIndexListView(const AIndexSubItem: Integer);
var
  LListItemSel: TListItem;
  LStrCopy: string;
begin
  if(AIndexSubItem < -1)then
    Exit;

  if(FListView.Selected = nil)then
    Exit;

  LListItemSel := FListView.Items[FListView.Selected.Index];
  if(AIndexSubItem = -1)then
    LStrCopy := LListItemSel.Caption
  else
    LStrCopy := LListItemSel.SubItems[AIndexSubItem];

  if(not LStrCopy.Trim.IsEmpty)then
    Clipboard.AsText := LStrCopy;
end;

function ListViewCustomSortProc(Item1, Item2: TListItem; SortColumn: Integer): Integer; stdcall;
var
  LStrItem1, LStrItem2: string;
  LIntItem1, LIntItem2: Integer;
  LValidItem1, LValidItem2: Boolean;
  LDhItem1, LDhItem2: TDateTime;
begin
  Result := 0;
  if(Item1 = nil)or(Item2 = nil)then
    Exit;

  case(SortColumn)of
    -1: //COMPARE CAPTIONS
    begin
      LStrItem1 := Item1.Caption;
      LStrItem2 := Item2.Caption;
    end;
    else //COMPARE SUBITEMS
    LStrItem1 := '';
    LStrItem2 := '';
    //CHECK RANGE
    if(SortColumn < Item1.SubItems.Count)then
      LStrItem1 := Item1.SubItems[SortColumn];
    if(SortColumn < Item2.SubItems.Count)then
      LStrItem2 := Item2.SubItems[SortColumn]
  end;

  //SORT STYLES
  case(TC4DWizardUtilsListView.FSortStyle)of
    TC4DWizardUtilsListViewSortStyle.AlphaNum:
    begin
      Result := lstrcmp(PChar(LStrItem1), PChar(LStrItem2));
    end;
    TC4DWizardUtilsListViewSortStyle.Numeric:
    begin
      LValidItem1 := IsValidNumber(LStrItem1, LIntItem1);
      LValidItem2 := IsValidNumber(LStrItem2, LIntItem2);
      Result := ord(LValidItem1 or LValidItem2);
      if(Result <> 0)then
      begin
        if(LIntItem1 = 0)then
          LIntItem1 := 99999999;
        if(LIntItem2 = 0)then
          LIntItem2 := 99999999;
        Result := CompareNumeric(LIntItem2, LIntItem1);
      end;
    end;
    TC4DWizardUtilsListViewSortStyle.DateTime:
    begin
      LValidItem1 := IsValidDate(LStrItem1, LDhItem1);
      LValidItem2 := IsValidDate(LStrItem2, LDhItem2);
      Result := ord(LValidItem1 or LValidItem2);
      if(Result <> 0)then
        Result := CompareDates(LDhItem1, LDhItem2);
    end;
  end;

  //SORT DIRECTION
  if(not TC4DWizardUtilsListView.FSortOrder[SortColumn + 1])then
    Result := - Result;
end;

{TC4DWizardUtilsListView}
class function TC4DWizardUtilsListView.New(AListView: TListView): IC4DWizardUtilsListView;
begin
  Result := Self.Create(AListView);
end;

constructor TC4DWizardUtilsListView.Create(AListView: TListView);
var
  i: Integer;
begin
  FListView := AListView;
  FInvertOrder := True;
  FColumnIndex := 0;
  for i := 0 to Length(FSortOrder) do
    FSortOrder[i] := False;
end;

function TC4DWizardUtilsListView.InvertOrder(const AInvertOrder: Boolean): IC4DWizardUtilsListView;
begin
  Result := Self;
  FInvertOrder := AInvertOrder;
end;

function TC4DWizardUtilsListView.SortStyle(const ASortStyle: TC4DWizardUtilsListViewSortStyle): IC4DWizardUtilsListView;
begin
  Result := Self;
  FSortStyle := ASortStyle;
end;

function TC4DWizardUtilsListView.ColumnIndex(const AColumnIndex: Integer): IC4DWizardUtilsListView;
begin
  Result := Self;
  FColumnIndex := AColumnIndex;
end;

procedure TC4DWizardUtilsListView.CustomSort;
begin
  if(FInvertOrder)then
    FSortOrder[FColumnIndex] := not FSortOrder[FColumnIndex];
  FListView.CustomSort(@ListViewCustomSortProc, FColumnIndex -1);
end;

end.
