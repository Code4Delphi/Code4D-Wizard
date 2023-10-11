unit C4D.Wizard.Find.Model;

interface

uses
  System.Classes,
  System.SysUtils,
  Vcl.Dialogs,
  Vcl.Graphics,
  ToolsAPI,
  C4D.Wizard.Find.Interfaces,
  C4D.Wizard.Messages.Custom,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Types,
  C4D.Wizard.Utils.GetIniPositionStr;

type
  TC4DWizardFindModel = class(TInterfacedObject, IC4DWizardFindModel)
  private
    FFilePath: string;
    FUtilsGetIniPositionStr: IC4DWizardUtilsGetIniPositionStr;
    FMsg: IC4DWizardMessageCustom;
    FWholeWordOnly: Boolean;
    FDisplayAccountant: Boolean;
    FCaseSensitive: Boolean;
    FSearchFor: string;
    FTextIgnoreEscope: TC4DTextIgnoreEscope;
    FTextIgnore: string;
    FCountFind: Integer;
    FCountFindFiles: Integer;
    FCountError: Integer;
    procedure FindInFileOpenInIDE;
    procedure FindInFileClosed;
    procedure ProcessMsg(const ANumLine, ANumCol: Integer; const AMsg: string);
    procedure LoopInLinesUnit(var AStrListUnit: TStringList);
    procedure ProcessMsgError(const AMessage: string);
  protected
    function ResetValues: IC4DWizardFindModel;
    function WholeWordOnly(AValue: Boolean): IC4DWizardFindModel;
    function DisplayAccountant(AValue: Boolean): IC4DWizardFindModel;
    function CaseSensitive(AValue: Boolean): IC4DWizardFindModel;
    function SearchFor(AValue: string): IC4DWizardFindModel;
    function TextIgnoreEscope(AValue: TC4DTextIgnoreEscope): IC4DWizardFindModel;
    function TextIgnore(AValue: string): IC4DWizardFindModel;
    function GetCountFind: Integer;
    function GetCountArqFind: Integer;
    function GetCountError: Integer;
    function GetGroupNameMsg: string;
    procedure FindInFile(AInfoFile: TC4DWizardInfoFile);
  public
    class function New: IC4DWizardFindModel;
    constructor Create;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

class function TC4DWizardFindModel.New: IC4DWizardFindModel;
begin
  Result := Self.Create
end;

constructor TC4DWizardFindModel.Create;
begin
  FUtilsGetIniPositionStr := TC4DWizardUtilsGetIniPositionStr.New;
  FMsg := TC4DWizardMessageCustom.GetInstance;
  Self.ResetValues;
end;

function TC4DWizardFindModel.ResetValues: IC4DWizardFindModel;
begin
  Result := Self;
  FMsg.Clear;
  FFilePath := '';
  FWholeWordOnly := True;
  FDisplayAccountant := True;
  FCaseSensitive := False;
  FCountFind :=0;
  FCountFindFiles := 0;
  FCountError := 0;
end;

function TC4DWizardFindModel.WholeWordOnly(AValue: Boolean): IC4DWizardFindModel;
begin
  Result := Self;
  FWholeWordOnly := AValue;
end;

function TC4DWizardFindModel.DisplayAccountant(AValue: Boolean): IC4DWizardFindModel;
begin
  Result := Self;
  FDisplayAccountant := AValue;
end;

function TC4DWizardFindModel.CaseSensitive(AValue: Boolean): IC4DWizardFindModel;
begin
  Result := Self;
  FCaseSensitive := AValue;
end;

function TC4DWizardFindModel.SearchFor(AValue: string): IC4DWizardFindModel;
begin
  Result := Self;
  FSearchFor := AValue;
end;

function TC4DWizardFindModel.TextIgnoreEscope(AValue: TC4DTextIgnoreEscope): IC4DWizardFindModel;
begin
  Result := Self;
  FTextIgnoreEscope := AValue;
end;

function TC4DWizardFindModel.TextIgnore(AValue: string): IC4DWizardFindModel;
begin
  Result := Self;
  FTextIgnore := AValue;
end;

function TC4DWizardFindModel.GetCountFind: Integer;
begin
  Result := FCountFind;
end;

function TC4DWizardFindModel.GetCountArqFind: Integer;
begin
  Result := FCountFindFiles;
end;

function TC4DWizardFindModel.GetCountError: Integer;
begin
  Result := FCountError;
end;

procedure TC4DWizardFindModel.ProcessMsg(const ANumLine, ANumCol: Integer; const AMsg: string);
var
  LPrefix: string;
begin
  FMsg.GroupName(Self.GetGroupNameMsg);
  if(FCountFind <= 0)then
  begin
    FMsg.ClearMessageGroup;
    FMsg.ShowMessages;
  end;

  LPrefix := '';
  if(FDisplayAccountant)then
    LPrefix := Format('%.3d', [(FCountFind + 1)]);

  FMsg
    .Prefix(LPrefix)
    .FileName(FFilePath)
    .Line(ANumLine)
    .Column(ANumCol)
    .Msg(AMsg)
    .SubstrContrast(FSearchFor)
    .WholeWordOnly(FWholeWordOnly)
    .CaseSensitive(FCaseSensitive)
    .AddMsg;
end;

procedure TC4DWizardFindModel.ProcessMsgError(const AMessage: string);
begin
  FMsg.GroupName(Self.GetGroupNameMsg);
  if(FCountFind <= 0)then
  begin
    FMsg.ClearMessageGroup;
    FMsg.ShowMessages;
  end;

  FMsg
    .Prefix('')
    .FileName(FFilePath)
    .Line(0)
    .Column(0)
    .Msg(Format('%s%s%s', ['<clRed><n>', 'An error occurred when processing file. Message: ' + AMessage, '</n></clRed>']))
    .SubstrContrast(EmptyStr)
    .AddMsg;

  Inc(FCountError);
end;

function TC4DWizardFindModel.GetGroupNameMsg: string;
var
  LName: string;
begin
  LName := FSearchFor;
  if(LName.Length > 53)then
    LName := copy(LName, 1, 50) + '...';
  Result := 'Find for ' + QuotedStr(LName);
end;

procedure TC4DWizardFindModel.FindInFile(AInfoFile: TC4DWizardInfoFile);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      FFilePath := AInfoFile.Path;

      FUtilsGetIniPositionStr
        .WholeWordOnly(FWholeWordOnly)
        .CaseSensitive(FCaseSensitive);

      if(FTextIgnoreEscope = TC4DTextIgnoreEscope.Word)then
        FUtilsGetIniPositionStr.TextIgnore(FTextIgnore);

      try
        if(TC4DWizardUtilsOTA.FileIsOpenInIDE(FFilePath))then
          Self.FindInFileOpenInIDE
        else
          Self.FindInFileClosed;
      except
        on E: Exception do
          Self.ProcessMsgError(E.Message);
      end;
    end);
end;

procedure TC4DWizardFindModel.FindInFileOpenInIDE;
var
  LIOTAModule: IOTAModule;
  LStrListUnit: TStringList;
begin
  LIOTAModule := TC4DWizardUtilsOTA.GetModule(FFilePath);
  LStrListUnit := TC4DWizardUtilsOTA.EditorAsStringList(LIOTAModule);
  try
    Self.LoopInLinesUnit(LStrListUnit);
  finally
    LStrListUnit.Free;
  end;
end;

procedure TC4DWizardFindModel.FindInFileClosed;
var
  LStrListUnit: TStringList;
begin
  LStrListUnit := TStringList.Create;
  try
    LStrListUnit.LoadFromFile(FFilePath);
    Self.LoopInLinesUnit(LStrListUnit);
  finally
    LStrListUnit.Free;
  end;
end;

procedure TC4DWizardFindModel.LoopInLinesUnit(var AStrListUnit: TStringList);
var
  LNumLine: Integer;
  LColIni: Integer;
  LColIniPlusOne: Integer;
  LStrLine: string;
  LAlterInFile: Boolean;
  LTextIgnore: string;
begin
  LAlterInFile := False;
  for LNumLine := 0 to Pred(AStrListUnit.Count) do
  begin
    if(FTextIgnoreEscope = TC4DTextIgnoreEscope.Line)then
    begin
      if(not FTextIgnore.Trim.IsEmpty)then
      begin
        LStrLine := AStrListUnit[LNumLine];
        LTextIgnore := FTextIgnore;
        if(not FCaseSensitive)then
        begin
          LStrLine := LStrLine.ToLower;
          LTextIgnore := LTextIgnore.ToLower;
        end;

        if(LStrLine.Contains(LTextIgnore))then
          Continue;
      end;
    end;

    LStrLine := AStrListUnit[LNumLine];
    LColIni := 0;
    LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStrLine, FSearchFor, LColIni);
    if(LColIni > -1)then
    begin
      while(LColIni > -1)do
      begin
        LColIniPlusOne := LColIni + 1;
        Self.ProcessMsg(LNumLine + 1, LColIniPlusOne, LStrLine);
        Inc(FCountFind);
        LColIni := LColIni + FSearchFor.Length + 1;//*
        LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStrLine, FSearchFor, LColIni);
      end;
      LAlterInFile := True;
    end;
  end;

  if(LAlterInFile)then
    Inc(FCountFindFiles);
end;

end.
