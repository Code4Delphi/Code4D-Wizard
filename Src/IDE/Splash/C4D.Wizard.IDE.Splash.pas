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
  SplashScreenServices.AddPluginBitmap(TC4DConsts.ABOUT_TITLE, LoadBitmap(HInstance, TC4DConsts.RESOURCE_c4d_logo_24x24),
    TC4DConsts.IS_UNREGISTERED, TC4DConsts.WIZARD_LICENSE);
end;

initialization
  RegisterSplashScreen;

finalization

end.
