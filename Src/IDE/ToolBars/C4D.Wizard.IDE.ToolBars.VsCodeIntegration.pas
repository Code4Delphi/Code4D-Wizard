unit C4D.Wizard.IDE.ToolBars.VsCodeIntegration;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Menus,
  ToolsAPI,
  C4D.Wizard.OpenExternal;

type
  TC4DWizardIDEToolBarsVsCodeIntegration = class
  private
    FINTAServices: INTAServices;
    FToolBarVsCodeIntegration: TToolBar;
    FToolButtonOpenInVsCode: TToolButton;
    procedure NewToolBarVsCodeIntegration;
    procedure OnC4DToolButtonOpenInVsCodeClick(Sender: TObject);
    procedure RemoveToolBarVsCodeIntegration;
    procedure AddButtonOpenInVsCode;
    function GetIniFile: TIniFile;
    procedure RemoveToolButtons;
    procedure CreateAllButtons;
    function GetShortcutOpenInVsCode: string;
  protected
    constructor Create;
  public
    destructor Destroy; override;
    procedure SetVisibleInINI(AVisible: Boolean);
    function GetVisibleInINI: Boolean;
    procedure RefreshButtons;
  end;

var
  C4DWizardIDEToolBarsVsCodeIntegration: TC4DWizardIDEToolBarsVsCodeIntegration;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.IDE.ToolBars.Utils,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.OpenExternal.Model,
  C4D.Wizard.OpenExternal.Utils,
  C4D.Wizard.VsCodeIntegration,
  C4D.Wizard.Settings.Model;

procedure RegisterSelf;
begin
  if(not Assigned(C4DWizardIDEToolBarsVsCodeIntegration))then
    C4DWizardIDEToolBarsVsCodeIntegration := TC4DWizardIDEToolBarsVsCodeIntegration.Create;
end;

constructor TC4DWizardIDEToolBarsVsCodeIntegration.Create;
begin
  FINTAServices := TC4DWizardUtilsOTA.GetINTAServices;
  Self.NewToolBarVsCodeIntegration;
end;

destructor TC4DWizardIDEToolBarsVsCodeIntegration.Destroy;
begin
  Self.RemoveToolBarVsCodeIntegration;
  inherited;
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.NewToolBarVsCodeIntegration;
begin
  Self.RemoveToolBarVsCodeIntegration;
  FToolBarVsCodeIntegration := FINTAServices.NewToolbar(TC4DConsts.TOOL_BAR_VsCodeIntegration_NAME,
    TC4DConsts.TOOL_BAR_VsCodeIntegration_CAPTION, TC4DWizardIDEToolBarsUtils.GetReferenceToolbarName, True);
  FToolBarVsCodeIntegration.Visible := False;
  FToolBarVsCodeIntegration.Flat := True;
  FToolBarVsCodeIntegration.Images := TC4DWizardUtilsOTA.GetINTAServices.ImageList;
  FToolBarVsCodeIntegration.ShowCaptions := False;
  FToolBarVsCodeIntegration.AutoSize := True;

  Self.CreateAllButtons;
  FToolBarVsCodeIntegration.Visible := Self.GetVisibleInINI;
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.CreateAllButtons;
begin
  Self.AddButtonOpenInVsCode;
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.RefreshButtons;
begin
  Self.RemoveToolButtons;
  Self.CreateAllButtons;
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.RemoveToolBarVsCodeIntegration;
begin
  Self.RemoveToolButtons;

  if(not Assigned(FToolBarVsCodeIntegration))then
    FToolBarVsCodeIntegration := FINTAServices.ToolBar[TC4DConsts.TOOL_BAR_VsCodeIntegration_NAME];

  if(Assigned(FToolBarVsCodeIntegration))then
  begin
    FToolBarVsCodeIntegration.Visible := False;
    if(not TC4DWizardUtilsOTA.CurrentProjectIsC4DWizardDPROJ)then
      FreeAndNil(FToolBarVsCodeIntegration);
  end;
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.RemoveToolButtons;
var
  i: Integer;
begin
  FToolBarVsCodeIntegration := FINTAServices.ToolBar[TC4DConsts.TOOL_BAR_VsCodeIntegration_NAME];
  if(Assigned(FToolBarVsCodeIntegration))then
  begin
    for i := Pred(FToolBarVsCodeIntegration.ButtonCount) DownTo 0 do
      FToolBarVsCodeIntegration.Buttons[i].Free;
  end;
end;

function TC4DWizardIDEToolBarsVsCodeIntegration.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniGeneralSettings);
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.SetVisibleInINI(AVisible: Boolean);
begin
  Self.GetIniFile.WriteBool(TC4DConsts.TOOL_BAR_VsCodeIntegration_NAME,
    TC4DConsts.TOOL_BAR_VsCodeIntegration_INI_Visible, AVisible);
end;

function TC4DWizardIDEToolBarsVsCodeIntegration.GetVisibleInINI: Boolean;
begin
  Result := Self.GetIniFile.ReadBool(TC4DConsts.TOOL_BAR_VsCodeIntegration_NAME,
    TC4DConsts.TOOL_BAR_VsCodeIntegration_INI_Visible, True);
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.AddButtonOpenInVsCode;
begin
  FToolButtonOpenInVsCode := TToolButton(FToolBarVsCodeIntegration.FindComponent(TC4DConsts.TOOL_BAR_VsCodeIntegration_TOOL_BUTTON_OpenInVsCode_NAME));
  if(FToolButtonOpenInVsCode <> nil)then
    FToolButtonOpenInVsCode.Free;

  FToolButtonOpenInVsCode := TToolButton.Create(FToolBarVsCodeIntegration);
  FToolButtonOpenInVsCode.Parent := FToolBarVsCodeIntegration;
  FToolButtonOpenInVsCode.Caption := TC4DConsts.TOOL_BAR_VsCodeIntegration_TOOL_BUTTON_OpenInVsCode_CAPTION + Self.GetShortcutOpenInVsCode;
  FToolButtonOpenInVsCode.Hint := FToolButtonOpenInVsCode.Caption;
  FToolButtonOpenInVsCode.ShowHint := True;
  FToolButtonOpenInVsCode.Name := TC4DConsts.TOOL_BAR_VsCodeIntegration_TOOL_BUTTON_OpenInVsCode_NAME;
  FToolButtonOpenInVsCode.Style := tbsButton;
  FToolButtonOpenInVsCode.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexVsCode;
  FToolButtonOpenInVsCode.Visible := True;
  FToolButtonOpenInVsCode.OnClick := OnC4DToolButtonOpenInVsCodeClick;
  FToolButtonOpenInVsCode.AutoSize := True;
  FToolButtonOpenInVsCode.Left := 0;
end;

function TC4DWizardIDEToolBarsVsCodeIntegration.GetShortcutOpenInVsCode: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpenUse)and(not C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen.Trim.IsEmpty)then
    Result := ' (' + C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen.Trim + ')';
end;

procedure TC4DWizardIDEToolBarsVsCodeIntegration.OnC4DToolButtonOpenInVsCodeClick(Sender: TObject);
begin
  TC4DWizardVsCodeIntegration.Open;
end;

initialization

finalization
  if(Assigned(C4DWizardIDEToolBarsVsCodeIntegration))then
    FreeAndNil(C4DWizardIDEToolBarsVsCodeIntegration);

end.
