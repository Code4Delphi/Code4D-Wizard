unit C4D.Wizard.IDE.ToolBars.Utils;

interface

uses
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Controls,
  ToolsAPI;

type
  TC4DWizardIDEToolBarsUtils = class
  private
  public
    class function GetReferenceToolbarName: string;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Consts;

class function TC4DWizardIDEToolBarsUtils.GetReferenceToolbarName: string;
var
  LINTAServices: INTAServices;
  LStandardToolBar: TToolBar;
  LControlBar: TControlBar;
  LControl: TControl;
  i: integer;
  LBiggerLeft: integer;
begin
  Result := sBrowserToolbar;

  LINTAServices := TC4DWizardUtilsOTA.GetINTAServices;
  if(LINTAServices.ToolBar[TC4DConsts.TOOL_BAR_BRANCH_NAME] <> nil)then
    Result := TC4DConsts.TOOL_BAR_BRANCH_NAME;

  LStandardToolBar := LINTAServices.ToolBar[sStandardToolBar];
  if(not Assigned(LStandardToolBar))then
    Exit;
  LControlBar := LStandardToolBar.Parent as TControlBar;

  LBiggerLeft := 0;
  for i := 0 to Pred(LControlBar.ControlCount) do
  begin
    LControl := LControlBar.Controls[i];
    if(LControl.Visible)and(LControl.Left > LBiggerLeft)then
    begin
      Result := LControl.Name;
      LBiggerLeft := LControl.Left;
    end;
  end;
end;

end.
