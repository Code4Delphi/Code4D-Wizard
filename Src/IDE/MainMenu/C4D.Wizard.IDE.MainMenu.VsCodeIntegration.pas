unit C4D.Wizard.IDE.MainMenu.VsCodeIntegration;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Menus;

type
  IC4DWizardIDEMainMenuVsCodeIntegration = interface
    ['{9B729013-F7A2-4B98-AC35-994E236682A0}']
    function Process: IC4DWizardIDEMainMenuVsCodeIntegration;
  end;

  TC4DWizardIDEMainMenuVsCodeIntegration = class(TInterfacedObject, IC4DWizardIDEMainMenuVsCodeIntegration)
  private
    FMenuItemC4D: TMenuItem;
    FMenuItemVsCodeIntegration: TMenuItem;
    procedure AddMenuVsCodeIntegration;
    procedure AddSubMenuItemOpen;
    procedure AddSubMenuInstallDelphiLSP;
    procedure AddSeparator(AName: string);
    function GetShortcutOpenInVsCode: string;
  protected
    function Process: IC4DWizardIDEMainMenuVsCodeIntegration;
  public
    class function New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuVsCodeIntegration;
    constructor Create(AMenuItemParent: TMenuItem);
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.IDE.MainMenu.Clicks,
  C4D.Wizard.Settings.Model;

class function TC4DWizardIDEMainMenuVsCodeIntegration.New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuVsCodeIntegration;
begin
  Result := Self.Create(AMenuItemParent);
end;

constructor TC4DWizardIDEMainMenuVsCodeIntegration.Create(AMenuItemParent: TMenuItem);
begin
  FMenuItemC4D := AMenuItemParent;
end;

function TC4DWizardIDEMainMenuVsCodeIntegration.Process: IC4DWizardIDEMainMenuVsCodeIntegration;
begin
  Self.AddMenuVsCodeIntegration;
  Self.AddSubMenuItemOpen;
  Self.AddSeparator('C4DVsCodeIntegrationSeparator01');
  Self.AddSubMenuInstallDelphiLSP;
end;

procedure TC4DWizardIDEMainMenuVsCodeIntegration.AddSeparator(AName: string);
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(FMenuItemVsCodeIntegration);
  LMenuItem.Name := AName;
  LMenuItem.Caption := '-';
  LMenuItem.ImageIndex := -1;
  LMenuItem.OnClick := nil;
  FMenuItemVsCodeIntegration.Add(LMenuItem);
end;

procedure TC4DWizardIDEMainMenuVsCodeIntegration.AddMenuVsCodeIntegration;
begin
  FMenuItemVsCodeIntegration := TMenuItem.Create(FMenuItemC4D);
  FMenuItemVsCodeIntegration.Name := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_NAME;
  FMenuItemVsCodeIntegration.Caption := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_CAPTION;
  FMenuItemVsCodeIntegration.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexVsCode;
  FMenuItemC4D.Add(FMenuItemVsCodeIntegration);
end;

procedure TC4DWizardIDEMainMenuVsCodeIntegration.AddSubMenuItemOpen;
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(FMenuItemVsCodeIntegration);
  LMenuItem.Name := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_OPEN_NAME;
  LMenuItem.Caption := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_OPEN_CAPTION;
  LMenuItem.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexVsCode;
  LMenuItem.OnClick := TC4DWizardIDEMainMenuClicks.VsCodeIntegrationOpenInVsCodeClick;
  LMenuItem.ShortCut := TextToShortCut(TC4DWizardUtils.RemoveSpacesAll(Self.GetShortcutOpenInVsCode));
  FMenuItemVsCodeIntegration.Add(LMenuItem);
end;

procedure TC4DWizardIDEMainMenuVsCodeIntegration.AddSubMenuInstallDelphiLSP;
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(FMenuItemVsCodeIntegration);
  LMenuItem.Name := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_INSTALL_DELPHILSP_NAME;
  LMenuItem.Caption := TC4DConsts.MENU_IDE_VSCODE_INTEGRATION_INSTALL_DELPHILSP_CAPTION;
  LMenuItem.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexImport;
  LMenuItem.OnClick := TC4DWizardIDEMainMenuClicks.VsCodeIntegrationInstallDelphiLSPClick;
  FMenuItemVsCodeIntegration.Add(LMenuItem);
end;

function TC4DWizardIDEMainMenuVsCodeIntegration.GetShortcutOpenInVsCode: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpenUse)and(not C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen.Trim;
end;

end.
