unit C4D.Wizard.IDE.Splash;

interface

implementation

uses
  Windows,
  SysUtils,
  ToolsAPI,
  DesignIntf,
  C4D.Wizard.Consts;

procedure RegisterSplashScreen;
begin
  ForceDemandLoadState(dlDisable);
  SplashScreenServices.AddPluginBitmap(TC4DConsts.C_ABOUT_TITLE, LoadBitmap(HInstance, TC4DConsts.C_RESOURCE_c4d_logo_24x24),
    TC4DConsts.IS_UNREGISTERED, TC4DConsts.C_WIZARD_LICENSE);
end;

initialization
  RegisterSplashScreen;

finalization

end.
