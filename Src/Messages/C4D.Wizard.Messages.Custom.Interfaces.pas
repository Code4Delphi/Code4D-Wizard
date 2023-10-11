unit C4D.Wizard.Messages.Custom.Interfaces;

interface

uses
  System.SysUtils,
  Vcl.Graphics,
  ToolsAPI,
  C4D.Wizard.Types;

type
  IC4DWizardMessagesSimple = interface
    ['{E4897D7C-590A-4531-8B8C-DBFD3F7F24F9}']
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
  end;

  IC4DWizardMessageCustom = interface
    ['{CC10991A-48AE-4E40-8DED-AE390A06F629}']
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
  end;

  IC4DWizardMessageCustomOTA = interface
    ['{F7FAFD2F-6454-45CA-8494-5D1D8A237625}']
    function Msg(Value: string): IC4DWizardMessageCustomOTA;
    function FileName(Value: string): IC4DWizardMessageCustomOTA;
    function Prefix(Value: string): IC4DWizardMessageCustomOTA;
    function Line(Value: Integer): IC4DWizardMessageCustomOTA;
    function Column(Value: Integer): IC4DWizardMessageCustomOTA;
    function GroupName(Value: string): IC4DWizardMessageCustomOTA;
    function Color(Value: TColor): IC4DWizardMessageCustomOTA;
    function ColorBack(Value: TColor): IC4DWizardMessageCustomOTA;
    function Style(Value: TFontStyles): IC4DWizardMessageCustomOTA;
  end;

implementation

end.
