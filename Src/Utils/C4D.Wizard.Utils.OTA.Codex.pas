unit C4D.Wizard.Utils.OTA.Codex;

{******************************************************************************}
{ Unit Note:                                                                   }
{         This file is partly derived from Codex expert for Delphi IDE         }
{                                                                              }
{ Codex author:                                                                }
{                    https://github.com/DelphiWorlds/Codex                     }
{******************************************************************************}

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Forms,
  Vcl.ActnList,
  ToolsAPI;

type
  TC4DWizardUtilsOTACodex = class
  public
    class function ExecuteIDEAction(const AActionName: string): Boolean;
    class function FindActionGlobal(const AActionName: string; out AAction: TCustomAction): Boolean;
    class function FindComponentGlobal(const AComponentName: string; out AComponent: TComponent): Boolean;
    class function FindComponentRecurse(const AParent: TComponent; const AComponentName: string;
      out AComponent: TComponent): Boolean;
  end;

implementation

class function TC4DWizardUtilsOTACodex.ExecuteIDEAction(const AActionName: string): Boolean;
var
  LAction: TCustomAction;
begin
  Result := False;
  if Self.FindActionGlobal(AActionName, LAction) then
  begin
    LAction.Execute;
    Result := True;
  end;
end;

class function TC4DWizardUtilsOTACodex.FindActionGlobal(const AActionName: string;
  out AAction: TCustomAction): Boolean;
var
  LComponent: TComponent;
begin
  Result := False;
  if Self.FindComponentGlobal(AActionName, LComponent) and (LComponent is TCustomAction) then
  begin
    AAction := TCustomAction(LComponent);
    Result := True;
  end;
end;

class function TC4DWizardUtilsOTACodex.FindComponentGlobal(const AComponentName: string;
  out AComponent: TComponent): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to Pred(Screen.FormCount) do
  begin
    if Self.FindComponentRecurse(Screen.Forms[I], AComponentName, AComponent) then
    begin
      Result := True;
      Break;
    end;
  end;
  if not Result then
  begin
    for I := 0 to Pred(Screen.DataModuleCount) do
    begin
      if Self.FindComponentRecurse(Screen.DataModules[I], AComponentName, AComponent) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

class function TC4DWizardUtilsOTACodex.FindComponentRecurse(const AParent: TComponent;
  const AComponentName: string; out AComponent: TComponent): Boolean;
var
  I: Integer;
begin
  AComponent := AParent.FindComponent(AComponentName);
  Result := AComponent <> nil;
  if not Result then
  begin
    for I := 0 to AParent.ComponentCount - 1 do
    begin
      if Self.FindComponentRecurse(AParent.Components[I], AComponentName, AComponent) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

end.
