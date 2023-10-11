unit C4D.Wizard.Messages.Simple;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Types;

type
  TC4DWizardMessagesSimple = class(TInterfacedObject, IC4DWizardMessagesSimple)
  private
    FFileName: string;
    FPrefix: string;
    FMsg: string;
    FLine: Integer;
    FColumn: Integer;
    FGroupName: string;
  protected
    function FileName(AValue: string): IC4DWizardMessagesSimple;
    function Prefix(AValue: string): IC4DWizardMessagesSimple;
    function Msg(AValue: string): IC4DWizardMessagesSimple;
    function Line(AValue: Integer): IC4DWizardMessagesSimple;
    function Column(AValue: Integer): IC4DWizardMessagesSimple;
    function GroupName(AValue: string): IC4DWizardMessagesSimple;
    function ClearMessageGroup(const AGroupName: string): IC4DWizardMessagesSimple;
    function ClearMessages(const ATypesMsg: TC4DMsgsClear): IC4DWizardMessagesSimple;
    function ShowMessages(const AGroupName: string = ''): IC4DWizardMessagesSimple;
    function AddMsgGeneral(AMsg: string): IC4DWizardMessagesSimple;
    function AddMsg: IC4DWizardMessagesSimple;
  public
    class function New: IC4DWizardMessagesSimple;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

class function TC4DWizardMessagesSimple.New: IC4DWizardMessagesSimple;
begin
  Result := Self.Create;
end;

function TC4DWizardMessagesSimple.FileName(AValue: string): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FFileName := AValue;
end;

function TC4DWizardMessagesSimple.Prefix(AValue: string): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FPrefix := AValue;
end;

function TC4DWizardMessagesSimple.Msg(AValue: string): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FMsg := AValue;
end;

function TC4DWizardMessagesSimple.Line(AValue: Integer): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FLine := AValue;
end;

function TC4DWizardMessagesSimple.Column(AValue: Integer): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FColumn := AValue;
end;

function TC4DWizardMessagesSimple.GroupName(AValue: string): IC4DWizardMessagesSimple;
begin
  Result := Self;
  FGroupName := AValue;
end;

function TC4DWizardMessagesSimple.ClearMessages(const ATypesMsg: TC4DMsgsClear): IC4DWizardMessagesSimple;
var
  LIOTAMessageServices: IOTAMessageServices;
begin
  Result := Self;
  LIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
  if(TC4DMsgClear.All in ATypesMsg)or(TC4DMsgClear.Compiler in ATypesMsg)then
    LIOTAMessageServices.ClearCompilerMessages;
  if(TC4DMsgClear.All in ATypesMsg)or(TC4DMsgClear.Search in ATypesMsg)then
    LIOTAMessageServices.ClearSearchMessages;
  if(TC4DMsgClear.All in ATypesMsg)or(TC4DMsgClear.Tool in ATypesMsg)then
    LIOTAMessageServices.ClearToolMessages;
end;

function TC4DWizardMessagesSimple.ClearMessageGroup(const AGroupName: string): IC4DWizardMessagesSimple;
var
  LIOTAMessageServices: IOTAMessageServices;
  LIOTAMessageGroup: IOTAMessageGroup;
begin
  Result := Self;
  LIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
  LIOTAMessageGroup := LIOTAMessageServices.AddMessageGroup(AGroupName);
  LIOTAMessageServices.ClearMessageGroup(LIOTAMessageGroup);
end;

function TC4DWizardMessagesSimple.ShowMessages(const AGroupName: string = ''): IC4DWizardMessagesSimple;
var
  LIOTAMessageServices: IOTAMessageServices;
  LIOTAMessageGroup: IOTAMessageGroup;
begin
  Result := Self;
  LIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
  LIOTAMessageGroup := nil;
  if(not AGroupName.Trim.IsEmpty)then
    LIOTAMessageGroup := LIOTAMessageServices.AddMessageGroup(AGroupName);
  LIOTAMessageServices.ShowMessageView(LIOTAMessageGroup);
end;

function TC4DWizardMessagesSimple.AddMsgGeneral(AMsg: string): IC4DWizardMessagesSimple;
begin
  Result := Self;
  TC4DWizardUtilsOTA.GetIOTAMessageServices.AddTitleMessage(AMsg);
end;

function TC4DWizardMessagesSimple.AddMsg: IC4DWizardMessagesSimple;
var
  LIOTAMessageServices: IOTAMessageServices;
  LIOTAMessageGroup: IOTAMessageGroup;
  LLineRef: Pointer;
begin
  Result := Self;
  LIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
  LIOTAMessageGroup := nil;
  if(not FGroupName.Trim.IsEmpty)then
    LIOTAMessageGroup := LIOTAMessageServices.AddMessageGroup(FGroupName);
  LIOTAMessageServices.AddToolMessage(FFileName, FMsg, FPrefix, FLine, FColumn, nil, LLineRef, LIOTAMessageGroup);
end;

end.
