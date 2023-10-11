unit C4D.Wizard.UsesOrganization;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Generics.Collections,
  System.Types,
  ToolsAPI,
  C4D.Wizard.Interfaces,
  C4D.Wizard.Types,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Messages.Simple;

type
  TC4DWizardUsesOrganization = class(TInterfacedObject, IC4DWizardUsesOrganization)
  private
    FParams: IC4DWizardUsesOrganizationParams;
    FGroupUsesList: TList<IC4DWizardUsesOrganizationList>;
    FListOldFile: TStringList;
    FListNewFile: TStringList;
    FListUsesInterface: TStringList;
    FListAllUses: TStringList;
    FFilePath: string;
    FMsg: IC4DWizardMessagesSimple;
    FStrAllUses: string;
    FIOTAEditView: IOTAEditView;
    FCountAlterFiles: Integer;
    FCountError: Integer;
    FImplementationIni: Boolean;
    FImplementationEnd: Boolean;
    procedure ProcessaStrUses;
    function StrHasUses(ALineText: string): Boolean;
    procedure ProcReplaceLineInFileOpenInIDE;
    procedure ReplaceInFileClosed;
    procedure ReplaceInFileOpenInIDE;
    procedure LoopInLinesUnit;
    procedure ProcessMsg;
    procedure ProcessMsgError(const AMessage: string);
    procedure FillListAllUses;
    function GetTextAllUses: string;
    procedure RemoveDuplicateUses;
  protected
    function Params: IC4DWizardUsesOrganizationParams;
    function CountAlterFiles: Integer;
    function GetGroupNameMsg: string;
    procedure UsesOrganizationInFile(AInfoFile: TC4DWizardInfoFile);
    function ResetValues: IC4DWizardUsesOrganization;
  public
    class function New: IC4DWizardUsesOrganization;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.UsesOrganization.List,
  C4D.Wizard.UsesOrganization.Params,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

class function TC4DWizardUsesOrganization.New: IC4DWizardUsesOrganization;
begin
  Result := Self.Create;
end;

constructor TC4DWizardUsesOrganization.Create;
begin
  FParams := TC4DWizardUsesOrganizationParams.New(Self);
  FListOldFile := TStringList.Create;
  FListNewFile := TStringList.Create;
  FListUsesInterface := TStringList.Create;
  FListAllUses := TStringList.Create;
  FGroupUsesList := TList<IC4DWizardUsesOrganizationList>.Create;
  FMsg := TC4DWizardMessagesSimple.New;
  Self.ResetValues
end;

destructor TC4DWizardUsesOrganization.Destroy;
begin
  FGroupUsesList.Free;
  inherited;
end;

function TC4DWizardUsesOrganization.ResetValues: IC4DWizardUsesOrganization;
begin
  Result := Self;
  FFilePath := '';
  FCountAlterFiles := 0;
  FCountError := 0;
end;

function TC4DWizardUsesOrganization.Params: IC4DWizardUsesOrganizationParams;
begin
  Result := FParams;
end;

function TC4DWizardUsesOrganization.StrHasUses(ALineText: string): Boolean;
begin
  Result := False;
  if(ALineText.Trim.ToLower = 'uses')then
    Exit(True);

  if(Copy(ALineText.TrimLeft.ToLower, 1, 5) = 'uses ')then
    Exit(True);
end;

function TC4DWizardUsesOrganization.CountAlterFiles: Integer;
begin
  Result := FCountAlterFiles;
end;

function TC4DWizardUsesOrganization.GetGroupNameMsg: string;
begin
  Result := 'Uses Organization';
end;

procedure TC4DWizardUsesOrganization.UsesOrganizationInFile(AInfoFile: TC4DWizardInfoFile);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      try
        FFilePath := AInfoFile.Path;
        if(TC4DWizardUtilsOTA.FileIsOpenInIDE(FFilePath))then
          Self.ReplaceInFileOpenInIDE
        else
          Self.ReplaceInFileClosed;
      except
        on E: Exception do
          Self.ProcessMsgError(E.Message);
      end;
    end);
end;

procedure TC4DWizardUsesOrganization.ReplaceInFileOpenInIDE;
var
  LIOTAModule: IOTAModule;
  LStrListUnit: TStringList;
begin
  LIOTAModule := TC4DWizardUtilsOTA.GetModule(FFilePath);
  if(not Assigned(LIOTAModule))then
    Exit;

  FListOldFile.Clear;
  LStrListUnit := TC4DWizardUtilsOTA.EditorAsStringList(LIOTAModule);
  try
    FListOldFile.Text := LStrListUnit.Text;
  finally
    LStrListUnit.Free;
  end;

  try
    FIOTAEditView := TC4DWizardUtilsOTA.GetIOTAEditView(LIOTAModule);
    Self.LoopInLinesUnit;
    if(FListOldFile.Text <> FListNewFile.Text)then
    begin
      Self.ProcReplaceLineInFileOpenInIDE;
      LIOTAModule.MarkModified;
      Inc(FCountAlterFiles);
      Self.ProcessMsg;
    end;
  finally
    FListOldFile.Clear;
  end;
end;

procedure TC4DWizardUsesOrganization.ProcReplaceLineInFileOpenInIDE;
var
  LNumLine: Integer;
  LCountLineMax: Integer;
  LLength: Integer;
  I: Integer;
  LNumLinesAddInEnd: Integer;
  LStrLine: string;
begin
  LCountLineMax := Pred(FListOldFile.Count);
  if(Pred(FListNewFile.Count) > LCountLineMax)then
    LCountLineMax := Pred(FListNewFile.Count);

  for LNumLine := 0 to LCountLineMax do
  begin
    LStrLine := TC4DWizardUtils.UTF8ToStr(FListOldFile[LNumLine]);
    if(LStrLine.Trim.Equals('end.'))then
    begin
      LLength := LStrLine.Length;
      FIOTAEditView.Buffer.EditPosition.GotoLine(LNumLine + 1);
      FIOTAEditView.Buffer.EditPosition.Delete(LLength);
      FIOTAEditView.Buffer.EditPosition.GotoLine(LNumLine);
      LNumLinesAddInEnd := LCountLineMax - LNumLine;
      for I := 1 to LNumLinesAddInEnd do
        FIOTAEditView.Buffer.EditPosition.InsertText(Chr(13));
      Break;
    end;

    LLength := LStrLine.Length;
    if(LLength > 0)then
    begin
      FIOTAEditView.Buffer.EditPosition.GotoLine(LNumLine + 1);
      FIOTAEditView.Buffer.EditPosition.Delete(LLength);
    end;
  end;

  for LNumLine := 0 to Pred(FListNewFile.Count) do
  begin
    FIOTAEditView.Buffer.EditPosition.GotoLine(LNumLine + 1);
    LStrLine := FListNewFile[LNumLine];
    FIOTAEditView.Buffer.EditPosition.InsertText(LStrLine);
  end;
end;

procedure TC4DWizardUsesOrganization.ReplaceInFileClosed;
begin
  try
    FListOldFile.Clear;
    FListOldFile.LoadFromFile(FFilePath);
    Self.LoopInLinesUnit;
    if(FListOldFile.Text <> FListNewFile.Text)then
    begin
      FListNewFile.SavetoFile(FFilePath);
      Inc(FCountAlterFiles);
      Self.ProcessMsg;
    end;
  finally
    FListOldFile.Clear;
    FListNewFile.Clear;
  end;
end;

procedure TC4DWizardUsesOrganization.LoopInLinesUnit;
var
  LNumLine: Integer;
  LLineHasSemicolon: Boolean;
  LStrLine: string;
  LDirectivaIni: Boolean;
begin
  try
    FListNewFile.Clear;
    LNumLine := 0;
    FImplementationIni := False;
    FImplementationEnd := False;
    FListUsesInterface.Clear;
    FListAllUses.Clear;
    while(LNumLine <= Pred(FListOldFile.Count))do
    begin
      LStrLine := FListOldFile.Strings[LNumLine];
      if(LStrLine.ToLower = 'implementation')then
        FImplementationIni := True;

      //SE NÃO É A LINHA COM A STR USES ADD A LINHA INTEIRA
      if(FImplementationEnd)or(not Self.StrHasUses(LStrLine))then
      begin
        FListNewFile.Add(LStrLine);
        Inc(LNumLine);
        Continue;
      end;

      FStrAllUses := '';
      LLineHasSemicolon := False;
      LDirectivaIni := False;
      //PEGA TODOS OS USES ATE O ;
      while(not LLineHasSemicolon)or(LDirectivaIni)do
      begin
        LStrLine := TC4DWizardUtils.RemoveCommentAfterTwoBars(LStrLine);
        if(not LDirectivaIni)then
          LDirectivaIni := (ContainsStr(LStrLine, '{$IF'))and(not ContainsStr(LStrLine, '{$ENDIF}'))
        else
          LDirectivaIni := not ContainsStr(LStrLine, '{$ENDIF}');

        if(not LLineHasSemicolon)then
          LLineHasSemicolon := ContainsStr(LStrLine, ';');

        FStrAllUses := FStrAllUses + LStrLine;
        Inc(LNumLine);
        LStrLine := FListOldFile.Strings[LNumLine];
      end;
      Self.ProcessaStrUses;
      Self.FillListAllUses;
      Self.RemoveDuplicateUses;

      if(not FImplementationIni)then
        FListUsesInterface.Text := FListUsesInterface.Text + FListAllUses.Text;

      FListNewFile.Text := FListNewFile.Text + Self.GetTextAllUses;

      if(FImplementationIni)then
        FImplementationEnd := True;
    end;
  except
    on E: Exception do
      raise Exception.Create('The error occurred: ' + E.Message + sLineBreak + '. File: ' + FFilePath);
  end;
end;

procedure TC4DWizardUsesOrganization.ProcessaStrUses;
var
  LStrUsesAux: string;
  LStrBetween: string;
  LContinue: Boolean;
  LPrefix: string;
  LSuffix: string;
begin
  FGroupUsesList.Clear;
  FStrAllUses := StringReplace(FStrAllUses, 'uses', '', [rfIgnoreCase]);
  FStrAllUses := TC4DWizardUtils.RemoveLastSemicolon(FStrAllUses);
  FStrAllUses := TC4DWizardUtils.RemoveEnter(FStrAllUses);
  FStrAllUses := TC4DWizardUtils.RemoveSpacesExtras(FStrAllUses);
  LStrUsesAux := FStrAllUses;
  LStrBetween := '';
  LContinue := True;
  while(LContinue)do
  begin
    LPrefix := '{$IF';
    LSuffix := '{$ENDIF}';
    LStrBetween := TC4DWizardUtils.GetTextBetween(LStrUsesAux, LPrefix, LSuffix);
    LContinue := False;
    if(not LStrBetween.Trim.IsEmpty)then
    begin
      LPrefix := TC4DWizardUtils.GetTextBetween(LStrBetween, '{', '}');
      FGroupUsesList.Add(
        TC4DWizardUsesOrganizationList.New(FParams)
          .StringListUnit(FListOldFile)
          .Kind(TC4DWizardListUsesKind.Directiva)
          .Prefix(LPrefix)
          .Suffix(LSuffix)
          .ImplementationIni(FImplementationIni)
          .ListUsesInterface(FListUsesInterface)
          .Text(LStrBetween)
      );
      LStrUsesAux := StringReplace(LStrUsesAux, LStrBetween, '', [rfIgnoreCase]);
      LContinue := True;
    end;
  end;

  FGroupUsesList.Add(
    TC4DWizardUsesOrganizationList.New(FParams)
      .StringListUnit(FListOldFile)
      .Kind(TC4DWizardListUsesKind.Normal)
      .ImplementationIni(FImplementationIni)
      .ListUsesInterface(FListUsesInterface)
      .Text(LStrUsesAux)
  );
end;

procedure TC4DWizardUsesOrganization.FillListAllUses;
var
  LItem: IC4DWizardUsesOrganizationList;
begin
  if(FGroupUsesList.Count < 0)then
    Exit;

  FListAllUses.Clear;
  for LItem in FGroupUsesList do
    FListAllUses.Text := FListAllUses.Text + LItem.GetTextListUses;
end;

procedure TC4DWizardUsesOrganization.RemoveDuplicateUses;
var
  LContListAll: integer;
  LUseLaco: string;
  LListAux: TStringList;
  LContListAux: Integer;
  LUseAux: string;
  LHas: Boolean;

  function ConfStr(const Value: string): string;
  begin
    Result := Value
      .Trim
      .Replace(',', '', [rfReplaceAll, rfIgnoreCase])
      .Replace(';', '', [rfReplaceAll, rfIgnoreCase]);
  end;
begin
  //FAZ O LACO NA LIST FListAllUses, DEPOIS FAZ O LACO NA LIST LListAux, CASO A LListAux AINDA NAO TENHO O ITEM, ELE HE ADICIONADO
  LListAux := TStringList.Create;
  try
    LListAux.Clear;
    for LContListAll := 0 to Pred(FListAllUses.Count) do
    begin
      LUseLaco := FListAllUses.Strings[LContListAll];

      LHas := False;
      if(not LUseLaco.Trim.IsEmpty)then
      begin
        for LContListAux := 0 to Pred(LListAux.Count) do
        begin
          LUseAux := LListAux.Strings[LContListAux];
          LHas := ConfStr(LUseLaco) = ConfStr(LUseAux);
          if(LHas)then
            Break;
        end;
      end;

      if(not LHas)then
        LListAux.Add(LUseLaco);
    end;

    //SE A LIST LListAux PEGOU ALGUM ITEM, LIMPA A FListAllUses E PEGA OS DADOS DA LListAux
    if(LListAux.Count > 0)then
    begin
      FListAllUses.Clear;
      FListAllUses.Text := LListAux.Text;
    end;
  finally
    LListAux.Free;
  end;
end;

function TC4DWizardUsesOrganization.GetTextAllUses: string;
var
  i: Integer;
  LUse: string;
  LNumCharacters: Integer;
begin
  Result :=
    'uses' + sLineBreak +
    FListAllUses.Text;

  if(not FParams.OneUsesPerLine)then
  begin
    LNumCharacters := 0;
    Result := 'uses' + sLineBreak + stringOfChar(' ', FParams.OneUsesLineNumColBefore - 1);
    for i := 0 to Pred(FListAllUses.Count)do
    begin
      LUse := ' ' + TC4DWizardUtils.RemoveSpacesExtras(FListAllUses.Strings[i]);

      LNumCharacters := LNumCharacters + LUse.Length;
      if(LNumCharacters >= FParams.MaxCharactersPerLine)then
      begin
         //NEW LINE
         Result :=  Result + sLineBreak + stringOfChar(' ', FParams.OneUsesLineNumColBefore - 1);
         LNumCharacters := LUse.Length;
      end;

      Result := Result + LUse;
    end;
  end;

  Result := TC4DWizardUtils.ChangeLastComma(Result, ';');
end;

procedure TC4DWizardUsesOrganization.ProcessMsg;
var
  LGroupName: string;
begin
  if(not FParams.ShowMessages)then
    Exit;

  LGroupName := Self.GetGroupNameMsg;
  if(FCountAlterFiles <= 1)then
    FMsg.ClearMessageGroup(LGroupName);

  FMsg
    .FileName(FFilePath)
    .Line(0)
    .Column(0)
    .GroupName(LGroupName)
    .Msg('')
    .AddMsg;
end;

procedure TC4DWizardUsesOrganization.ProcessMsgError(const AMessage: string);
var
  LGroupName: string;
begin
  Inc(FCountError);

  if(not FParams.ShowMessages)then
    Exit;

  LGroupName := Self.GetGroupNameMsg;
  if(FCountAlterFiles <= 1)then
    FMsg.ClearMessageGroup(LGroupName);

  FMsg
    .Prefix('')
    .FileName(FFilePath)
    .Line(0)
    .Column(0)
    .GroupName(LGroupName)
    .Msg(Format('%s%s%s', ['<clRed><n>', 'An error occurred when processing file. Message: ' + AMessage, '</n></clRed>']))
    .AddMsg;
end;

end.
