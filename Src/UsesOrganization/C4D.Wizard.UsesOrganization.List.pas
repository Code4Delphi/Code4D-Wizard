unit C4D.Wizard.UsesOrganization.List;

interface

uses
  C4D.Wizard.Interfaces,
  C4D.Wizard.Types,
  System.Classes,
  System.StrUtils,
  System.SysUtils;

type
  TC4DWizardUsesOrganizationList = class(TInterfacedObject, IC4DWizardUsesOrganizationList)
  private
    FStringListUnit: TStringList;
    FParams: IC4DWizardUsesOrganizationParams;
    FKind: TC4DWizardListUsesKind;
    FPrefix: string;
    FSuffix: string;
    FImplementationIni: Boolean;
    FListUsesInterface: TStringList;
    FText: string;
    function InternalProcessListUsesNormal: string;
    function InternalProcessListUsesDirectives: string;
    function GetSpacesIniLine(AMultiplier: Integer = 1): string;
    function ProcessNamespaces(ACont: Integer; AUse: string; var ANamespacesOld: string): string;
    procedure ProcessListAdd(var AUses: TStringList);
    function ProcessStringsFiltersList: Boolean;
    function ListUsesInterfaceHas(const AUse: string): Boolean;
  protected
    function StringListUnit(const Value: TStringList): IC4DWizardUsesOrganizationList;
    function Kind(const Value: TC4DWizardListUsesKind): IC4DWizardUsesOrganizationList;
    function Prefix(const Value: string): IC4DWizardUsesOrganizationList;
    function Suffix(const Value: string): IC4DWizardUsesOrganizationList;
    function ImplementationIni(const AImplementationIni: Boolean): IC4DWizardUsesOrganizationList;
    function ListUsesInterface(const Value: TStringList): IC4DWizardUsesOrganizationList;
    function Text(const Value: string): IC4DWizardUsesOrganizationList; overload;
    function Text: string; overload;
    function GetTextListUses: string;
  public
    class function New(AParams: IC4DWizardUsesOrganizationParams): IC4DWizardUsesOrganizationList;
    constructor Create(AParams: IC4DWizardUsesOrganizationParams);
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.StringList;

class function TC4DWizardUsesOrganizationList.New(AParams: IC4DWizardUsesOrganizationParams): IC4DWizardUsesOrganizationList;
begin
  Result := Self.Create(AParams);
end;

constructor TC4DWizardUsesOrganizationList.Create(AParams: IC4DWizardUsesOrganizationParams);
begin
  FParams := AParams;
  FKind := TC4DWizardListUsesKind.Normal;
  FPrefix := '';
  FSuffix := '';
  FImplementationIni := False;
  FText := '';
end;

destructor TC4DWizardUsesOrganizationList.Destroy;
begin
  inherited;
end;

function TC4DWizardUsesOrganizationList.GetSpacesIniLine(AMultiplier: Integer): string;
begin
  Result := stringOfChar(' ', FParams.OneUsesLineNumColBefore * AMultiplier);
end;

function TC4DWizardUsesOrganizationList.StringListUnit(const Value: TStringList): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FStringListUnit := Value;
end;

function TC4DWizardUsesOrganizationList.Kind(const Value: TC4DWizardListUsesKind): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FKind := Value;
end;

function TC4DWizardUsesOrganizationList.Prefix(const Value: string): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FPrefix := Value;
end;

function TC4DWizardUsesOrganizationList.Suffix(const Value: string): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FSuffix := Value;
end;

function TC4DWizardUsesOrganizationList.Text(const Value: string): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FText := Value;
end;

function TC4DWizardUsesOrganizationList.Text: string;
begin
  Result := FText;
end;

function TC4DWizardUsesOrganizationList.GetTextListUses: string;
begin
  case(FKind)of
    TC4DWizardListUsesKind.Normal:
     Result := Self.InternalProcessListUsesNormal;
    TC4DWizardListUsesKind.Directiva:
      Result := Self.InternalProcessListUsesDirectives;
  end;
end;

function TC4DWizardUsesOrganizationList.InternalProcessListUsesNormal: string;
var
  LUses: TStringList;
  LUse: string;
  LUseWithSeparators: string;
  LSeparatorAfter: string;
  LSeparatorBefore: string;
  i: Integer;
  LNamespacesOld: string;
begin
  Result := '';
  LUses := TStringList.Create;
  try
    ExtracTStrings([','], [], PChar(FText), LUses);

    Self.ProcessListAdd(LUses);

    if(FParams.OrderUsesInAlphabeticalOrder)then
      LUses.CustomSort(TC4DWizardUtilsstringList.SortTrim);

    if(FParams.GroupUnitsByNamespaces)then
      LUses.CustomSort(TC4DWizardUtilsstringList.SortNamespaces);

    LSeparatorAfter := Self.GetSpacesIniLine;
    LSeparatorBefore := ',' + sLineBreak;
    for i := 0 to Pred(LUses.Count) do
    begin
      LUse := LUses.Strings[i].Trim;
      LUseWithSeparators := LSeparatorAfter + LUse + LSeparatorBefore;

      if(FParams.UsesToRemoveList.Enabled)then
        if(FParams.UsesToRemoveList.ContainsValue(LUse))then
          Continue;

      //SE FOR A USES DA IMPLEMENTACAO, VERIFICA SE A USES ESTA NA LISTA DE USES QUE ESTAO NA INTERFACE, E A RETIRA
      //PARA NAO FICAR DUPLICADO A USES TANTO NA INTERFACE QUANTO NA IMPLEMENTACAO
      //POIS ELA JA FOI INSERIDA NA USES DA INTERFACE
      //if(FParams.UsesToAddList.Enabled)then
      if(FImplementationIni)then
        if(Self.ListUsesInterfaceHas(LUse))then
          Continue;

      Result := Result + Self.ProcessNamespaces(i, LUse, LNamespacesOld) + LUseWithSeparators;
    end;
  finally
    LUses.Free;
  end;
end;

function TC4DWizardUsesOrganizationList.ListUsesInterfaceHas(const AUse: string): Boolean;
var
  i: Integer;
  LUse: string;
  LUseLaco: string;

  function ConfStr(const Value: string): string;
  begin
    Result := Value
      .Trim
      .Replace(',', '', [rfReplaceAll, rfIgnoreCase])
      .Replace(';', '', [rfReplaceAll, rfIgnoreCase]);
  end;
begin
  Result := False;
  LUse := ConfStr(AUse);
  for i := 0 to Pred(FListUsesInterface.Count) do
  begin
    LUseLaco := ConfStr(FListUsesInterface.Strings[i]);
    if(LUseLaco = LUse)then
      Exit(True);
  end;
end;

procedure TC4DWizardUsesOrganizationList.ProcessListAdd(var AUses: TStringList);
var
  LListToAdd: TStringList;
  LUseAdd: string;
  I: Integer;
begin
  if(not FParams.UsesToAddList.Enabled)then
    Exit;

  //SE FOR A USES DA IMPLEMENTACAO
  if(FImplementationIni)then
    Exit;

  LListToAdd := FParams.UsesToAddList.List;
  if(LListToAdd.Count < 0)then
    Exit;

  //SE INFORMADO STRING FILTERS, A USES SO SERA ADICIONADA SE A UNIT POSSUIR UMA DAS STRINGS DA LISTA
  if(not Self.ProcessStringsFiltersList)then
    Exit;

  for i := 0 to Pred(LListToAdd.Count) do
  begin
    LUseAdd := LListToAdd.Strings[i].Trim;

    if(AUses.IndexOf(LUseAdd) < 0)then
      AUses.Add(LUseAdd)
  end;
end;

function TC4DWizardUsesOrganizationList.ProcessStringsFiltersList: Boolean;
var
  LStringsFiltersList: TStringList;
  LTextUnit: string;
  LStrItem: string;
  i: Integer;
begin
  Result := True;

  LStringsFiltersList := FParams.UsesToAddList.StringsFiltersList;
  if(LStringsFiltersList.Text.Trim.IsEmpty)then
    Exit;

  Result := False;
  LTextUnit := LowerCase(FStringListUnit.Text);

  for i := 0 to Pred(LStringsFiltersList.Count) do
  begin
    LStrItem := LStringsFiltersList.Strings[i].ToLower;

    if(LTextUnit.Contains(LStrItem))then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function TC4DWizardUsesOrganizationList.ProcessNamespaces(ACont: Integer; AUse: string; var ANamespacesOld: string): string;
var
  LNamespacesNew: string;
begin
  Result := '';
  if(FParams.GroupUnitsByNamespaces)
    and(FParams.LineBreakBetweenNamespaces)
    and(ContainsStr(AUse, '.'))
  then
  begin
    LNamespacesNew := TC4DWizardUtils.GetNamespace(AUse);
    if(ACont > 0)and(LNamespacesNew <> ANamespacesOld)then
      Result := sLineBreak;
    ANamespacesOld := LNamespacesNew;
  end;
end;

function TC4DWizardUsesOrganizationList.ImplementationIni(const AImplementationIni: Boolean): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FImplementationIni := AImplementationIni;
end;

function TC4DWizardUsesOrganizationList.ListUsesInterface(const Value: TStringList): IC4DWizardUsesOrganizationList;
begin
  Result := Self;
  FListUsesInterface := Value;
end;

function TC4DWizardUsesOrganizationList.InternalProcessListUsesDirectives: string;
var
  LUses: TStringList;
  i: Integer;
  LText: string;
begin
  Result := '';
  LUses := TStringList.Create;
  try
    LText := FText;
    LText := LText
      .Trim
      .Replace(FPrefix, '', [rfIgnoreCase])
      .Replace(FSuffix, '', [rfIgnoreCase])
      .Replace(' ', '', [rfReplaceAll]);
    LText := TC4DWizardUtils.RemoveLastComma(LText);
    ExtracTStrings([','], [], PChar(LText), LUses);
    if(FParams.OrderUsesInAlphabeticalOrder)and(not ContainsText(LText, 'ELSE'))then
      LUses.Sort;
    for i := 0 to Pred(LUses.Count) do
    begin
      Result := Result + LUses.Strings[i].Trim;
      if(RightStr(Result.TrimRight, 1) <> ';')then
        Result := Result + ', ';
    end;

    Result := Result
      .Replace(', ', ',' + Self.GetSpacesIniLine + '  ')
      .Replace(',', ',' + sLineBreak)
      .Replace('}', '}' + Self.GetSpacesIniLine + '  ')
      .Replace('}', '}' + sLineBreak)
      .Replace(';', ';' + Self.GetSpacesIniLine)
      .Replace(';', ';' + sLineBreak);

    Result := Self.GetSpacesIniLine +
      FPrefix +
      sLineBreak + Self.GetSpacesIniLine + '  ' +
      Result.TrimRight +
      sLineBreak + Self.GetSpacesIniLine +
      FSuffix;
    Result := TC4DWizardUtils.ChangeEnterDuplicatedByOne(Result);
    Result := Result
      .Replace(Self.GetSpacesIniLine(2) + '{$', Self.GetSpacesIniLine + '{$', [rfReplaceAll, rfIgnoreCase])
      .Replace(Self.GetSpacesIniLine + '  {$', Self.GetSpacesIniLine + '{$', [rfReplaceAll, rfIgnoreCase]);;
    Result := Result + sLineBreak
  finally
    LUses.Free;
  end;
end;

end.
