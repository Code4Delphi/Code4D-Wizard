unit C4D.Wizard.ProcessDelphi;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TC4DWizardProcessDelphi = class
  private
    class procedure RunCommandInternal(const ACommand: string);
  public
    class procedure RunCommand(const ACommand: string); overload;
    class procedure RunCommand(const ACommands: array of string); overload;
  end;

implementation

uses
  C4D.Wizard.dprocess,
  C4D.Wizard.Utils;

class procedure TC4DWizardProcessDelphi.RunCommand(const ACommand: string);
var
  LStrings: TStrings;
  LItem: string;
begin
  if(ACommand.Trim.IsEmpty)then
    Exit;

  LStrings := TStringList.Create;
  try
    TC4DWizardUtils.ExplodeList(ACommand, '#', LStrings);
    for LItem in LStrings do
    begin
      if(LItem.Trim.IsEmpty)then
        Continue;

      Self.RunCommandInternal(LItem);
    end;
  finally
    LStrings.Free;
  end;
end;

class procedure TC4DWizardProcessDelphi.RunCommand(const ACommands: array of string);
var
  LItem: string;
begin
  if(High(ACommands) < 0)then
    Exit;

  for LItem in ACommands do
    Self.RunCommandInternal(LItem);
end;

class procedure TC4DWizardProcessDelphi.RunCommandInternal(const ACommand: string);
var
  LOutPut: AnsiString;
begin
  C4D.Wizard.dprocess.RunCommand('cmd', ['/c', ACommand], LOutPut, [poNoConsole]);
end;

end.
