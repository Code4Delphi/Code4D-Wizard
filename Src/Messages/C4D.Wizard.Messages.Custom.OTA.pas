unit C4D.Wizard.Messages.Custom.OTA;

interface

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Math,
  Winapi.Windows,
  ToolsAPI,
  Vcl.Graphics,
  C4D.Wizard.Messages.Custom.Interfaces;

type
  TC4DWizardMessagesCustomOTA = Class(TInterfacedObject, IOTACustomMessage, INTACustomDrawMessage, IC4DWizardMessageCustomOTA)
  private
    FMsg: string;
    FFileName: string;
    FPrefix: string;
    FLine: Integer;
    FColumn: Integer;
    FGroupName: string;
    FColor: TColor;
    FColorBack: TColor;
    FStyle: TFontStyles;
    FIOTAMessageServices: IOTAMessageServices;
    function CopyLower(const AStr: string; const AColIni, ACount: Integer): string;
    procedure CanvasTextOut(const Canvas: TCanvas; var X: Integer; const Y: Integer; var Text: string);
  protected
    //INTACustomDrawMessage
    function CalcRect(Canvas: TCanvas; MaxWidth: Integer; Wrap: Boolean): TRect;
    procedure Draw(Canvas: TCanvas; const Rect: TRect; Wrap: Boolean);
    //IOTACustomMessage
    function GetColumnNumber: Integer;
    function GetFileName: string;
    function GetLineNumber: Integer;
    function GetLineText: string;
    procedure ShowHelp;
    //IC4DWizardMessageCustomOTA
    function Msg(Value: string): IC4DWizardMessageCustomOTA;
    function FileName(Value: string): IC4DWizardMessageCustomOTA;
    function Prefix(Value: string): IC4DWizardMessageCustomOTA;
    function Line(Value: Integer): IC4DWizardMessageCustomOTA;
    function Column(Value: Integer): IC4DWizardMessageCustomOTA;
    function GroupName(Value: string): IC4DWizardMessageCustomOTA;
    function Color(Value: TColor): IC4DWizardMessageCustomOTA;
    function ColorBack(Value: TColor): IC4DWizardMessageCustomOTA;
    function Style(Value: TFontStyles): IC4DWizardMessageCustomOTA;
  public
    class function New: IC4DWizardMessageCustomOTA;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

class function TC4DWizardMessagesCustomOTA.New: IC4DWizardMessageCustomOTA;
begin
  Result := Self.Create;
end;

constructor TC4DWizardMessagesCustomOTA.Create;
begin
  FIOTAMessageServices := TC4DWizardUtilsOTA.GetIOTAMessageServices;
end;

destructor TC4DWizardMessagesCustomOTA.Destroy;
begin
  FIOTAMessageServices := nil;
  inherited;
end;

//INTACustomDrawMessage INI
function TC4DWizardMessagesCustomOTA.CalcRect(Canvas: TCanvas; MaxWidth: Integer; Wrap: Boolean): TRect;
begin
  Canvas.Font.Style := FStyle;
  Result := Canvas.ClipRect;
  Result.Bottom := Result.Top + Canvas.TextHeight('Wp');
  Result.Right := Result.Left + Canvas.TextWidth(FMsg);
end;

procedure TC4DWizardMessagesCustomOTA.Draw(Canvas: TCanvas; const Rect: TRect; Wrap: Boolean);
var
  LColLetra: Integer;
  LLetra: string;
  LX: Integer;
  LColor: TColor;
  LMsg: string;
  LPartText: string;
begin
  if(FColor <> clNone)then
    Canvas.Font.Color := FColor;

  if(FColorBack <> clNone)then
    Canvas.Brush.Color := FColorBack;

  Canvas.FillRect(Rect);
  Canvas.Font.Style := FStyle;

  LColor := Canvas.Font.Color;
  LX := Rect.Left;
  LColLetra := 1;
  LMsg := FMsg;
  LPartText := '';
  while(LColLetra <= LMsg.Length)do
  begin
    LLetra := LMsg[LColLetra];
    if(LLetra = '<')then
    begin
      if(CopyLower(LMsg, LColLetra, 3).Equals('<n>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 3);
        Canvas.Font.Style := Canvas.Font.Style + [fsBold];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 4).Equals('</n>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 4);
        Canvas.Font.Style := Canvas.Font.Style - [fsBold];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 3).Equals('<s>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 3);
        Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 4).Equals('</s>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 4);
        Canvas.Font.Style := Canvas.Font.Style - [fsUnderline];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 3).Equals('<r>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 3);
        Canvas.Font.Style := Canvas.Font.Style + [fsStrikeOut];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 4).Equals('</r>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 4);
        Canvas.Font.Style := Canvas.Font.Style - [fsStrikeOut];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 3).Equals('<i>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 3);
        Canvas.Font.Style := Canvas.Font.Style + [fsItalic];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 4).Equals('</i>'))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 4);
        Canvas.Font.Style := Canvas.Font.Style - [fsItalic];
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 7).Equals(LowerCase('<clRed>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 7);
        Canvas.Font.Color := clRed;
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 8).Equals(LowerCase('</clRed>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 8);
        Canvas.Font.Color := LColor;
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 10).Equals(LowerCase('<clYellow>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 10);
        Canvas.Font.Color := clYellow;
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 11).Equals(LowerCase('</clYellow>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 11);
        Canvas.Font.Color := LColor;
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 9).Equals(LowerCase('<clGreen>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 9);
        Canvas.Font.Color := clGreen;
        Continue;
      end
      else if(CopyLower(LMsg, LColLetra, 10).Equals(LowerCase('</clGreen>')))then
      begin
        Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
        Inc(LColLetra, 10);
        Canvas.Font.Color := LColor;
        Continue;
      end;
    end;

    LPartText := LPartText + LLetra;
    Inc(LColLetra);
  end;
  Self.CanvasTextOut(Canvas, LX, Rect.Top, LPartText);
end;
//INTACustomDrawMessage FIM

procedure TC4DWizardMessagesCustomOTA.CanvasTextOut(const Canvas: TCanvas; var X: Integer; const Y: Integer; var Text: string);
begin
  if(Text.Trim.IsEmpty)then
    Exit;

  Canvas.TextOut(X, Y, Text);
  X := X + Canvas.TextWidth(Text) + IfThen(fsBold in Canvas.Font.Style, 1, 0);;
  Text := '';
end;

//IOTACustomMessage INI
function TC4DWizardMessagesCustomOTA.GetColumnNumber: Integer;
begin
  Result := FColumn;
end;

function TC4DWizardMessagesCustomOTA.GetFileName: string;
begin
  Result := FFileName;
end;

function TC4DWizardMessagesCustomOTA.GetLineNumber: Integer;
begin
  Result := FLine;
end;

function TC4DWizardMessagesCustomOTA.GetLineText: string;
begin
  Result := FMsg;
end;

procedure TC4DWizardMessagesCustomOTA.ShowHelp;
begin

end;
//IOTACustomMessage END

function TC4DWizardMessagesCustomOTA.Msg(Value: string): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FMsg := StringReplace(Value, #$D#$A, '', [rfReplaceAll, rfIgnoreCase]);
end;

function TC4DWizardMessagesCustomOTA.FileName(Value: string): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FFileName := Value;
end;

function TC4DWizardMessagesCustomOTA.Prefix(Value: string): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FPrefix := Value;
end;

function TC4DWizardMessagesCustomOTA.Line(Value: Integer): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FLine := Value;
end;

function TC4DWizardMessagesCustomOTA.Column(Value: Integer): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FColumn := Value;
end;

function TC4DWizardMessagesCustomOTA.GroupName(Value: string): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FGroupName := Value;
end;

function TC4DWizardMessagesCustomOTA.Color(Value: TColor): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FColor := Value;
end;

function TC4DWizardMessagesCustomOTA.ColorBack(Value: TColor): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FColorBack := Value;
end;

function TC4DWizardMessagesCustomOTA.Style(Value: TFontStyles): IC4DWizardMessageCustomOTA;
begin
  Result := Self;
  FStyle := Value;
end;

function TC4DWizardMessagesCustomOTA.CopyLower(const AStr: string; const AColIni, ACount: Integer): string;
begin
  Result := LowerCase(copy(AStr, AColIni, ACount));
end;

end.
