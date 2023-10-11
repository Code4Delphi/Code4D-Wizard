unit C4D.Wizard.Indent;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Interfaces,
  System.Generics.Collections;

type
  TC4DWizardIndent = class(TInterfacedObject, IC4DWizardIndent)
  private
    FText: string;
    FListSeparator: TStringList;
    procedure ProcessTwoPoints(var AStrLine: string);
    procedure RemoveSpaceExtraBefore(var AStrLine: string; const ASep: string);
    procedure RemoveSpaceExtraAfter(var Astring: string; const ASep: string);
    procedure AddSpaceAfter(var AStrLine: string; const ASep: string);
    procedure AddSpaceBefore(var AStrLine: string; const ASep: string);
    function ValidateSeparators(AStrLine: string; AColCur: Integer; ASep: string): Boolean;
    function Process: IC4DWizardIndent;
  protected
    procedure ProcessBlockSelected;
  public
    class function New: IC4DWizardIndent;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

const
  C_ONE_SPACE = ' ';
  C_TWO_SPACE = '  ';

  C_SEP_TwoPoints_Equal = ':=';
  C_SEP_Equal = '=';
  C_SEP_TwoPoints = ':';
  C_SEP_Minor = '<';
  C_SEP_Major = '>';
  C_SEP_Different = '<>';
  C_SEP_MinorEqual = '<=';
  C_SEP_MajorEqual = '>=';
  C_SEP_Addition = '+';
  C_SEP_Subtraction = '-';
  C_SEP_Multiplication = '*';
  //C_SEP_Division = '/';
  C_SEP_ParenthesesOpen = '(';
  C_SEP_ParenthesesClose = ')';
  C_SEP_sLineBreak = 'sLineBreak';

constructor TC4DWizardIndent.Create;
begin
  FListSeparator := TStringList.Create;
  FListSeparator.Add(C_SEP_TwoPoints_Equal);
  FListSeparator.Add(C_SEP_Equal);
  FListSeparator.Add(C_SEP_TwoPoints);
  //FListSeparator.Add(C_SEP_Minor); //TREAT GENERICS
  //FListSeparator.Add(C_SEP_Major); //TREAT GENERICS
  //FListSeparator.Add(C_SEP_Different);
  //FListSeparator.Add(C_SEP_MinorEqual);
  //FListSeparator.Add(C_SEP_MajorEqual);
  //FListSeparator.Add(C_SEP_Addition);
  //FListSeparator.Add(C_SEP_Subtraction);
  //FListSeparator.Add(C_SEP_Multiplication);
  //FListSeparator.Add(C_SEP_ParenthesesOpen);
  //FListSeparator.Add(C_SEP_ParenthesesClose);
  FListSeparator.Add(C_SEP_sLineBreak);
end;

destructor TC4DWizardIndent.Destroy;
begin
  FListSeparator.Free;
  inherited;
end;

class function TC4DWizardIndent.New: IC4DWizardIndent;
begin
  Result := Self.Create;
end;

function TC4DWizardIndent.ValidateSeparators(AStrLine: string; AColCur: Integer; ASep: string): Boolean;
var
  LCharBefore: string;
  LCharAfter: string;
begin
  Result := True;
  LCharBefore := copy(AStrLine, AColCur - 1, 1);
  LCharAfter := copy(AStrLine, AColCur + 1, 1);

  if(ASep = C_SEP_TwoPoints)then
    if(LCharAfter = C_SEP_Equal)then
      Exit(False);

  if(ASep = C_SEP_Equal)then
  begin
    if(LCharBefore = C_SEP_TwoPoints)then
      Exit(False);

    if(LCharBefore = C_SEP_Minor)then
      Exit(False);

    if(LCharBefore = C_SEP_Major)then
      Exit(False);
  end;

  if(ASep = C_SEP_Minor)then
  begin
    if(LCharAfter = C_SEP_Major)then
      Exit(False);

    if(LCharAfter = C_SEP_Equal)then
      Exit(False);
  end;

  if(ASep = C_SEP_Major)then
  begin
    if(LCharBefore = C_SEP_Minor)then
      Exit(False);

    if(LCharAfter = C_SEP_Equal)then
      Exit(False);
  end;
end;

procedure TC4DWizardIndent.ProcessTwoPoints(var AStrLine: string);
var
  LHas: Boolean;
begin
  LHas := True;
  while(LHas)do
  begin
    AStrLine := AStrLine.Replace(' ;', ';');
    LHas := AStrLine.Contains(' ;')
  end;
end;

procedure TC4DWizardIndent.AddSpaceBefore(var AStrLine: string; const ASep: string);
var
  LHas: Boolean;
  LColCur: Integer;
begin
  if(ASep = C_SEP_TwoPoints)then
    Exit;

  if(ASep = C_SEP_ParenthesesOpen)or(ASep = C_SEP_ParenthesesClose)then
    Exit;

  LColCur := 1;
  LHas := True;
  while(LHas)do
  begin
    LHas := False;
    LColCur := pos(ASep, AStrLine, LColCur);
    if(LColCur > 0)then
    begin
      try
        LHas := True;
        if(not Self.ValidateSeparators(AStrLine, LColCur, ASep))then
          Continue;
        AStrLine.Insert(LColCur - 1, C_ONE_SPACE);
      finally
        LColCur := LColCur + 2;
      end;
    end;
  end;
end;

procedure TC4DWizardIndent.AddSpaceAfter(var AStrLine: string; const ASep: string);
var
  LHas: Boolean;
  LColCur: Integer;
  LSepLenght: Integer;
  LOneSpace: string;
begin
  if(ASep = C_SEP_ParenthesesOpen)or(ASep = C_SEP_ParenthesesClose)then
    Exit;

  LOneSpace := C_ONE_SPACE;
  LSepLenght := ASep.Length;
  LColCur := 1;
  LHas := True;
  while(LHas)do
  begin
    LHas := False;
    LColCur := pos(ASep, AStrLine, LColCur);
    if(LColCur > 0)then
    begin
      try
        LHas := True;
        if(not Self.ValidateSeparators(AStrLine, LColCur, ASep))then
          Continue;

        if(copy(AStrLine, LColCur + LSepLenght, 1) = C_ONE_SPACE)then
          Continue;

        Insert(LOneSpace, AStrLine, LColCur + LSepLenght);
      finally
        LColCur := LColCur + 1;
      end;
    end;
  end;
end;

procedure TC4DWizardIndent.RemoveSpaceExtraBefore(var AStrLine: string; const ASep: string);
var
  LHas: Boolean;
  LColCur: Integer;
begin
  LColCur := 1;
  LHas := True;
  while(LHas)do
  begin
    LHas := False;
    LColCur := pos(ASep, AStrLine, LColCur);
    if(LColCur > 0)then
    begin
      LHas := True;
      if(not Self.ValidateSeparators(AStrLine, LColCur, ASep))then
      begin
        Inc(LColCur);
        Continue;
      end;

      if(copy(AStrLine, LColCur - 1, 1) <> C_ONE_SPACE)then
      begin
        Inc(LColCur);
        Continue;
      end;

      Dec(LColCur);
      Delete(AStrLine, LColCur, 1);
    end;
  end;
end;

procedure TC4DWizardIndent.RemoveSpaceExtraAfter(var Astring: string; const ASep: string);
var
  LHas: Boolean;
  LStrRemove: string;
begin
  LStrRemove := ASep + C_TWO_SPACE;
  LHas := True;
  while(LHas)do
  begin
    Astring := Astring.Replace(LStrRemove, ASep);
    LHas := Astring.Contains(LStrRemove)
  end;
end;

function TC4DWizardIndent.Process: IC4DWizardIndent;
var
  LList: TStringList;
  LSep: string;
  LContLine: Integer;
  LStrLine: string;
  LColCur: Integer;
  LColLarger: Integer;
  LColDif: Integer;
  ListIndexSep: TDictionary<Integer, string>;
  LKey: Integer;
  LArrayOrder: TArray<Integer>;
begin
  Result := Self;
  if(FText.Trim.IsEmpty)then
    Exit;

  LList := TStringList.Create;
  ListIndexSep := TDictionary<Integer, string>.Create;
  try
    LList.Text := FText;
    for LSep in FListSeparator do
    begin
      //REMOVE SPACE EXTRA
      for LContLine := 0 to pred(LList.Count) do
      begin
        LStrLine := LList[LContLine];
        Self.ProcessTwoPoints(LStrLine);
        Self.RemoveSpaceExtraBefore(LStrLine, LSep);
        Self.AddSpaceBefore(LStrLine, LSep);
        Self.RemoveSpaceExtraAfter(LStrLine, LSep);
        Self.AddSpaceAfter(LStrLine, LSep);
        LList[LContLine] := LStrLine;
      end;
    end;

    //GET POSITION OF SEP
    for LContLine := 0 to pred(LList.Count) do
    begin
      LStrLine := LList[LContLine];
      LColCur := 1;
      for LSep in FListSeparator do
      begin
        LColCur := pos(LSep, LStrLine, LColCur);
        while(LColCur > 0)do
        begin
          if(not ListIndexSep.ContainsKey(LColCur))then
            ListIndexSep.Add(LColCur, LSep);
          LColCur := pos(LSep, LStrLine, LColCur + 1);
        end;
        LColCur := 1;
      end;
    end;

    //ALTER STR LINE
    LArrayOrder := ListIndexSep.Keys.ToArray;
    TArray.Sort<Integer>(LArrayOrder);
    for LKey in LArrayOrder do
    begin
      LSep := ListIndexSep.Items[LKey];
      //GET LARGER COL
      LColLarger := 0;
      for LContLine := 0 to pred(LList.Count) do
      begin
        LStrLine := LList[LContLine];
        LColCur := pos(LSep, LStrLine);
        if(LColCur > LColLarger)then
        begin
          if(not Self.ValidateSeparators(LStrLine, LColCur, LSep))then
            Continue;
          LColLarger := LColCur;
        end;
        LList[LContLine] := LStrLine;
      end;

      //ADD SPACE BEFORE SEPARATOR
      for LContLine := 0 to pred(LList.Count) do
      begin
        LStrLine := LList[LContLine];
        LColCur := pos(LSep, LStrLine);
        if(LColCur > 0)then
        begin
          if(LColCur < LColLarger)then
          begin
            LColDif := LColLarger - LColCur;
            LStrLine.Insert(LColCur - 1, stringOfChar(C_ONE_SPACE, LColDif));
          end;
        end;
        LList[LContLine] := LStrLine;
      end;
    end;
    FText := LList.Text;
  finally
    ListIndexSep.Free;
    LList.Free;
  end;
end;

procedure TC4DWizardIndent.ProcessBlockSelected;
var
  LIOTAEditorServices: IOTAEditorServices;
  LIOTAEditView: IOTAEditView;
  LStartRow: Integer;
  LIOTAEditBlock: IOTAEditBlock;
begin
  LIOTAEditorServices := TC4DWizardUtilsOTA.GetIOTAEditorServices;
  LIOTAEditView := LIOTAEditorServices.TopView;
  if(LIOTAEditView = nil)then
    TC4DWizardUtils.ShowMsgAndAbort('No projects or files selected');

  LIOTAEditBlock := LIOTAEditView.Block;
  if not Assigned(LIOTAEditBlock) then
    Exit;

  FText := LIOTAEditBlock.Text;
  if(FText.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('Not text selected');

  Self.Process;
  LStartRow := LIOTAEditBlock.StartingRow;
  LIOTAEditBlock.Delete;
  LIOTAEditView.Position.Move(LStartRow, 1);
  TC4DWizardUtilsOTA.InsertBlockTextIntoEditor(FText);
end;

end.
