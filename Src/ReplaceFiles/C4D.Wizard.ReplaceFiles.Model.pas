unit C4D.Wizard.ReplaceFiles.Model;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.ReplaceFiles.Interfaces,
  C4D.Wizard.Types,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Messages.Custom,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Utils.GetIniPositionStr;

type
  TC4DWizardReplaceFilesModel = class(TInterfacedObject, IC4DWizardReplaceFilesModel)
  private
    FFilePath: string;
    FUtilsGetIniPositionStr: IC4DWizardUtilsGetIniPositionStr;
    FMsg: IC4DWizardMessageCustom;
    FWholeWordOnly: Boolean;
    FDisplayAccountant: Boolean;
    FCaseSensitive: Boolean;
    FShowMessages: Boolean;
    FSearchFor: string;
    FReplaceBy: string;
    FCountReplace: Integer;
    FCountReplaceFiles: Integer;
    FCountError: Integer;
    FIOTAEditView: IOTAEditView;
    procedure ReplaceInFileOpenInIDE;
    procedure ReplaceInFileClosed;
    procedure ProcessMsg(const ANumLine, ANumCol: Integer; const AMsg: string);
    procedure ProcessMsgError(const AMessage: string);
    procedure LoopInLinesUnit(var AStrListUnit: TStringList; const AProcReplaceLine: TProcReplaceLine = nil);
    procedure ProcReplaceLineInFileOpenInIDE(const ANumLine: Integer; const AStrLineOld, AStrLineNew: string);
  protected
    function ResetValues: IC4DWizardReplaceFilesModel;
    function WholeWordOnly(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function DisplayAccountant(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function CaseSensitive(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function ShowMessages(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function SearchFor(AValue: string): IC4DWizardReplaceFilesModel;
    function ReplaceBy(AValue: string): IC4DWizardReplaceFilesModel;
    function GetCountReplace: Integer;
    function GetCountArqReplace: Integer;
    function GetCountError: Integer;
    function GetGroupNameMsg: string;
    procedure ReplaceInFile(AInfoFile: TC4DWizardInfoFile);
  public
    class function New: IC4DWizardReplaceFilesModel;
    constructor Create;
  end;

implementation

class function TC4DWizardReplaceFilesModel.New: IC4DWizardReplaceFilesModel;
begin
  Result := Self.Create
end;

constructor TC4DWizardReplaceFilesModel.Create;
begin
  FUtilsGetIniPositionStr := TC4DWizardUtilsGetIniPositionStr.New;
  FMsg := TC4DWizardMessageCustom.GetInstance;
  Self.ResetValues;
end;

function TC4DWizardReplaceFilesModel.ResetValues: IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FMsg.Clear;
  FFilePath := '';
  FWholeWordOnly := True;
  FDisplayAccountant := True;
  FCaseSensitive := False;
  FShowMessages := False;
  FCountReplace := 0;
  FCountReplaceFiles := 0;
  FCountError := 0;
end;

function TC4DWizardReplaceFilesModel.WholeWordOnly(AValue: Boolean): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FWholeWordOnly := AValue;
end;

function TC4DWizardReplaceFilesModel.DisplayAccountant(AValue: Boolean): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FDisplayAccountant := AValue;
end;

function TC4DWizardReplaceFilesModel.CaseSensitive(AValue: Boolean): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FCaseSensitive := AValue;
end;

function TC4DWizardReplaceFilesModel.ShowMessages(AValue: Boolean): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FShowMessages := AValue;
end;

function TC4DWizardReplaceFilesModel.SearchFor(AValue: string): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FSearchFor := AValue;
end;

function TC4DWizardReplaceFilesModel.ReplaceBy(AValue: string): IC4DWizardReplaceFilesModel;
begin
  Result := Self;
  FReplaceBy := AValue;
end;

function TC4DWizardReplaceFilesModel.GetCountReplace: Integer;
begin
  Result := FCountReplace;
end;

function TC4DWizardReplaceFilesModel.GetCountArqReplace: Integer;
begin
  Result := FCountReplaceFiles;
end;

function TC4DWizardReplaceFilesModel.GetCountError: Integer;
begin
  Result := FCountError;
end;

procedure TC4DWizardReplaceFilesModel.ProcessMsg(const ANumLine, ANumCol: Integer; const AMsg: string);
var
  LPrefix: string;
begin
  if(not FShowMessages)then
    Exit;

  FMsg.GroupName(Self.GetGroupNameMsg);
  if(FCountReplace <= 0)then
  begin
    FMsg.ClearMessageGroup;
    FMsg.ShowMessages;
  end;

  LPrefix := '';
  if(FDisplayAccountant)then
    LPrefix := Format('%.3d', [(FCountReplace + 1)]);

  FMsg
    .Prefix(LPrefix)
    .FileName(FFilePath)
    .Line(ANumLine)
    .Column(ANumCol)
    .Msg(AMsg)
    .SubstrContrast(FReplaceBy)
    .WholeWordOnly(FWholeWordOnly)
    .CaseSensitive(FCaseSensitive)
    .AddMsg;
end;

procedure TC4DWizardReplaceFilesModel.ProcessMsgError(const AMessage: string);
begin
  FMsg.GroupName(Self.GetGroupNameMsg);
  if(FCountReplace <= 0)then
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

function TC4DWizardReplaceFilesModel.GetGroupNameMsg: string;
var
  LName: string;
begin
  LName := FSearchFor;
  if(LName.Length > 33)then
    LName := copy(LName, 1, 30) + '...';
  Result := 'Replace ' + QuotedStr(LName);
end;

procedure TC4DWizardReplaceFilesModel.ReplaceInFile(AInfoFile: TC4DWizardInfoFile);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      FFilePath := AInfoFile.Path;

      FUtilsGetIniPositionStr
        .WholeWordOnly(FWholeWordOnly)
        .CaseSensitive(FCaseSensitive);

      try
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

procedure TC4DWizardReplaceFilesModel.ReplaceInFileOpenInIDE;
var
  LIOTAModule: IOTAModule;
  LStrListUnit: TStringList;
  LTextUnitOld: string;
begin
  LIOTAModule := TC4DWizardUtilsOTA.GetModule(FFilePath);
  LStrListUnit := TC4DWizardUtilsOTA.EditorAsStringList(LIOTAModule);
  try
    FIOTAEditView := TC4DWizardUtilsOTA.GetIOTAEditView(LIOTAModule);
    LTextUnitOld := LStrListUnit.Text;
    Self.LoopInLinesUnit(LStrListUnit, ProcReplaceLineInFileOpenInIDE);

    if(LTextUnitOld <> LStrListUnit.Text)then
    begin
      LIOTAModule.MarkModified;
      FIOTAEditView.Paint;
    end;
  finally
    LStrListUnit.Free;
  end;
end;

procedure TC4DWizardReplaceFilesModel.ReplaceInFileClosed;
var
  LStrListUnit: TStringList;
  LTextUnitOld: string;
begin
  LStrListUnit := TStringList.Create;
  try
    LStrListUnit.LoadFromFile(FFilePath);
    LTextUnitOld := LStrListUnit.Text;
    Self.LoopInLinesUnit(LStrListUnit, nil);
    if(LTextUnitOld <> LStrListUnit.Text)then
      LStrListUnit.SavetoFile(FFilePath);
  finally
    LStrListUnit.Free;
  end;
end;

procedure TC4DWizardReplaceFilesModel.ProcReplaceLineInFileOpenInIDE(const ANumLine: Integer; const AStrLineOld, AStrLineNew: string);
begin
  FIOTAEditView.Buffer.EditPosition.GotoLine(ANumLine + 1);
  //FIOTAEditView.Buffer.EditPosition.Replace(AStrLineOld, '', False, False, True, sdForward, LErrorCode);
  FIOTAEditView.Buffer.EditPosition.Delete(AStrLineOld.Length);
  FIOTAEditView.Buffer.EditPosition.InsertText(AStrLineNew);
end;

procedure TC4DWizardReplaceFilesModel.LoopInLinesUnit(var AStrListUnit: TStringList; const AProcReplaceLine: TProcReplaceLine = nil);
var
  LNumLine: Integer;
  LColIni: Integer;
  LColIniPlusOne: Integer;
  LStrLineOld: string;
  LStrLineNew: string;
  LAlterInFile: Boolean;
begin
  LAlterInFile := False;
  for LNumLine := 0 to Pred(AStrListUnit.Count) do
  begin
    LStrLineOld := AStrListUnit[LNumLine];
    LStrLineNew := LStrLineOld;

    LColIni := 0;
    LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStrLineNew, FSearchFor, LColIni);
    if(LColIni > -1)then
    begin
      while(LColIni > -1)do
      begin
        LColIniPlusOne := LColIni + 1;
        Delete(LStrLineNew, LColIniPlusOne, FSearchFor.Length);
        Insert(FReplaceBy, LStrLineNew, LColIniPlusOne);
        Self.ProcessMsg(LNumLine + 1, LColIniPlusOne, LStrLineOld);
        Inc(FCountReplace);
        LColIni := LColIni + FSearchFor.Length;
        LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStrLineNew, FSearchFor, LColIni);
      end;

      if(LStrLineNew <> LStrLineOld)then
      begin
        AStrListUnit[LNumLine] := LStrLineNew;
        if(Assigned(AProcReplaceLine))then
          AProcReplaceLine(LNumLine, LStrLineOld, LStrLineNew);
      end;
      LAlterInFile := True;
    end;
  end;

  if(LAlterInFile)then
    Inc(FCountReplaceFiles);
end;

end.
