unit C4D.Wizard.Messages.Custom;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  ToolsAPI,
  C4D.Wizard.Messages.Custom.OTA,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Utils.GetIniPositionStr;

type
  TC4DWizardMessageCustom = class(TInterfacedObject, IC4DWizardMessageCustom)
  private
    FIOTAMessageServices: IOTAMessageServices;
    FMessagesCustomOTAList: TInterfaceList;
    FIOTAMessageGroupList: TList<IOTAMessageGroup>;
    FUtilsGetIniPositionStr: IC4DWizardUtilsGetIniPositionStr;
    FMsg: string;
    FFileName: string;
    FPrefix: string;
    FLine: Integer;
    FColumn: Integer;
    FGroupName: string;
    FColor: TColor;
    FColorBack: TColor;
    FStyle: TFontStyles;
    FSubstrContrast: string;
    FWholeWordOnly: Boolean;
    FCaseSensitive: Boolean;
    function GetMessageGroup: IOTAMessageGroup;
    constructor Create;
    function AddContrastInSubstr(const AStr, ASubStr: string): string;
    procedure ConfigUtilsGetIniPositionStr;
  protected
    function Clear: IC4DWizardMessageCustom;
    function Msg(Value: string): IC4DWizardMessageCustom;
    function FileName(Value: string): IC4DWizardMessageCustom;
    function Prefix(Value: string): IC4DWizardMessageCustom;
    function Line(Value: Integer): IC4DWizardMessageCustom;
    function Column(Value: Integer): IC4DWizardMessageCustom;
    function GroupName(Value: string): IC4DWizardMessageCustom;
    function Color(Value: TColor): IC4DWizardMessageCustom;
    function ColorBack(Value: TColor): IC4DWizardMessageCustom;
    function Style(Value: TFontStyles): IC4DWizardMessageCustom;
    function SubstrContrast(Value: string): IC4DWizardMessageCustom;
    function WholeWordOnly(Value: Boolean): IC4DWizardMessageCustom;
    function CaseSensitive(Value: Boolean): IC4DWizardMessageCustom;
    function ClearMessageGroup: IC4DWizardMessageCustom; overload;
    function ClearMessageGroup(AIOTAMessageGroup: IOTAMessageGroup): IC4DWizardMessageCustom; overload;
    function ShowMessages: IC4DWizardMessageCustom;
    function AddMsg: IC4DWizardMessageCustom;
  public
    class function GetInstance: IC4DWizardMessageCustom;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

var
  Instance: IC4DWizardMessageCustom;

class function TC4DWizardMessageCustom.GetInstance: IC4DWizardMessageCustom;
begin
  if(not Assigned(Instance))then
    Instance := Self.Create;
  Result := Instance;
end;

constructor TC4DWizardMessageCustom.Create;
begin
  FIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
  FMessagesCustomOTAList := TInterfaceList.Create;
  FIOTAMessageGroupList := TList<IOTAMessageGroup>.Create;
  FUtilsGetIniPositionStr := TC4DWizardUtilsGetIniPositionStr.New;
  Self.Clear;
end;

destructor TC4DWizardMessageCustom.Destroy;
var
  LItem: IOTAMessageGroup;
begin
  try
    if(FIOTAMessageGroupList.Count > 0)then
    begin
      for LItem in FIOTAMessageGroupList do
      begin
        if(not LItem.GetGroupName.Trim.IsEmpty)and(FIOTAMessageServices.GetGroup(LItem.GetGroupName) <> nil)then
        begin
          Self.ClearMessageGroup(LItem);
          FIOTAMessageServices.RemoveMessageGroup(LItem);
        end;
      end;
    end;
  except
  end;
  FIOTAMessageGroupList.Free;
  FMessagesCustomOTAList.Free;
  inherited;
end;

function TC4DWizardMessageCustom.Clear: IC4DWizardMessageCustom;
begin
  Result := Self;
  FMsg := '';
  FFileName := '';
  FPrefix := '';
  FLine := 0;
  FColumn := 0;
  FGroupName := '';
  FColor := clNone;
  FColorBack := clNone;
  FStyle := [];
  FSubstrContrast := '';
  FWholeWordOnly := False;
  FCaseSensitive := False;
end;

function TC4DWizardMessageCustom.Msg(Value: string): IC4DWizardMessageCustom;
begin
  Result := Self;
  FMsg := Value;
end;

function TC4DWizardMessageCustom.FileName(Value: string): IC4DWizardMessageCustom;
begin
  Result := Self;
  FFileName := Value;
end;

function TC4DWizardMessageCustom.Prefix(Value: string): IC4DWizardMessageCustom;
begin
  Result := Self;
  FPrefix := Value;
end;

function TC4DWizardMessageCustom.Line(Value: Integer): IC4DWizardMessageCustom;
begin
  Result := Self;
  FLine := Value;
end;

function TC4DWizardMessageCustom.Column(Value: Integer): IC4DWizardMessageCustom;
begin
  Result := Self;
  FColumn := Value;
end;

function TC4DWizardMessageCustom.GroupName(Value: string): IC4DWizardMessageCustom;
begin
  Result := Self;
  FGroupName := Value;
end;

function TC4DWizardMessageCustom.Color(Value: TColor): IC4DWizardMessageCustom;
begin
  Result := Self;
  FColor := Value;
end;

function TC4DWizardMessageCustom.ColorBack(Value: TColor): IC4DWizardMessageCustom;
begin
  Result := Self;
  FColorBack := Value;
end;

function TC4DWizardMessageCustom.Style(Value: TFontStyles): IC4DWizardMessageCustom;
begin
  Result := Self;
  FStyle := Value;
end;

function TC4DWizardMessageCustom.SubstrContrast(Value: string): IC4DWizardMessageCustom;
begin
  Result := Self;
  FSubstrContrast := Value;
end;

function TC4DWizardMessageCustom.WholeWordOnly(Value: Boolean): IC4DWizardMessageCustom;
begin
  Result := Self;
  FWholeWordOnly := Value;
end;

function TC4DWizardMessageCustom.CaseSensitive(Value: Boolean): IC4DWizardMessageCustom;
begin
  Result := Self;
  FCaseSensitive := Value;
end;

function TC4DWizardMessageCustom.GetMessageGroup: IOTAMessageGroup;
begin
  Result := nil;
  if(FGroupName.Trim.IsEmpty)then
    Exit;

  //if(TC4DWizardUtils.FileNameIsC4DWizardDPROJ(TC4DWizardUtilsOTA.GetCurrentProject.FileName))then
  //  Exit;

  Result := FIOTAMessageServices.AddMessageGroup(FGroupName.Trim);
  FIOTAMessageGroupList.Add(Result);
end;

function TC4DWizardMessageCustom.ClearMessageGroup: IC4DWizardMessageCustom;
var
  LIOTAMessageGroup: IOTAMessageGroup;
begin
  Result := Self;
  LIOTAMessageGroup := Self.GetMessageGroup;
  FIOTAMessageServices.ClearMessageGroup(LIOTAMessageGroup);
end;

function TC4DWizardMessageCustom.ClearMessageGroup(AIOTAMessageGroup: IOTAMessageGroup): IC4DWizardMessageCustom;
begin
  Result := Self;
  if(AIOTAMessageGroup <> nil)then
    FIOTAMessageServices.ClearMessageGroup(AIOTAMessageGroup);
end;

function TC4DWizardMessageCustom.ShowMessages: IC4DWizardMessageCustom;
var
  LIOTAMessageGroup: IOTAMessageGroup;
begin
  Result := Self;
  LIOTAMessageGroup := Self.GetMessageGroup;
  FIOTAMessageServices.ShowMessageView(LIOTAMessageGroup);
end;

procedure TC4DWizardMessageCustom.ConfigUtilsGetIniPositionStr;
begin
  FUtilsGetIniPositionStr
    .WholeWordOnly(FWholeWordOnly)
    .CaseSensitive(FCaseSensitive);
end;

function TC4DWizardMessageCustom.AddContrastInSubstr(const AStr, ASubStr: string): string;
var
  LStr: string;
  LSubStrLength: Integer;
  LColIni: Integer;
  LTagIniStr: string;
  LTagIniLength: Integer;
  LTagFimStr: string;
  LTagFimLength: Integer;
begin
  Self.ConfigUtilsGetIniPositionStr;
  LStr := AStr;
  LColIni := 0;
  LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStr, ASubStr, LColIni);
  if(LColIni > -1)then
  begin
    LSubStrLength := ASubStr.Length;
    LTagIniStr := '<n><clGreen>';
    LTagIniLength := LTagIniStr.Length;
    LTagFimStr := '</n></clGreen>';
    LTagFimLength := LTagFimStr.Length;
    while(LColIni > -1)do
    begin
      LStr.Insert(LColIni, LTagIniStr);
      Inc(LColIni, LSubStrLength + LTagIniLength);
      LStr.Insert(LColIni, LTagFimStr);
      Inc(LColIni, LTagFimLength);
      LColIni := FUtilsGetIniPositionStr.GetInitialPosition(LStr, ASubStr, LColIni);
    end;
  end;
  Result := LStr;
end;

function TC4DWizardMessageCustom.AddMsg: IC4DWizardMessageCustom;
var
  LMessagesCustom: IC4DWizardMessageCustomOTA;
  LMsg: string;
begin
  Result := Self;
  LMsg := FMsg;

  if(not FSubstrContrast.IsEmpty)then
    LMsg := Self.AddContrastInSubstr(LMsg, FSubstrContrast);

  if(not FFileName.IsEmpty)then
    LMsg := FFileName + '('+ FLine.ToString +'): ' + LMsg;

  if(not FPrefix.IsEmpty)then
    LMsg := '['+ FPrefix +'] ' + LMsg;

  LMessagesCustom := TC4DWizardMessagesCustomOTA.New
    .Color(FColor)
    .ColorBack(FColorBack)
    .Style(FStyle)
    .Msg(LMsg)
    .FileName(FFileName)
    .Line(FLine)
    .Column(FColumn);

  FMessagesCustomOTAList.Add(LMessagesCustom);
  FIOTAMessageServices.AddCustomMessage(LMessagesCustom as IOTACustomMessage, Self.GetMessageGroup);
end;

initialization

finalization
  if(Assigned(Instance))then
    Instance := nil;

end.
