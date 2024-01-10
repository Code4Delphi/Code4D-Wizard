unit C4D.Wizard.IDE.About;

interface

implementation

uses
  System.SysUtils,
  Winapi.Windows,
  ToolsAPI,
  C4D.Wizard.Consts;

var
  OTAAboutBoxServices: IOTAAboutBoxServices = nil;
  IndexAboutBox: Integer = 0;

procedure RegisterAboutBox;
var
  LDescription: string;
begin
  if(not Supports(BorlandIDEServices, IOTAAboutBoxServices, OTAAboutBoxServices))then
    Exit;

  LDescription := TC4DConsts.ABOUT_COPY_RIGHT + sLineBreak + TC4DConsts.ABOUT_DESCRIPTION + sLineBreak +
    TC4DConsts.GITHUB_Code4D_Wizard + sLineBreak + TC4DConsts.SEMANTIC_VERSION_LB + sLineBreak + TC4DConsts.WIZARD_LICENSE;

  IndexAboutBox := OTAAboutBoxServices.AddPluginInfo(TC4DConsts.ABOUT_TITLE, LDescription,
    LoadBitmap(HInstance, TC4DConsts.RESOURCE_c4d_logo_48x48), TC4DConsts.IS_UNREGISTERED, TC4DConsts.WIZARD_LICENSE);
end;

procedure UnregisterAboutBox;
begin
  if(IndexAboutBox > 0)and Assigned(OTAAboutBoxServices)then
  begin
    OTAAboutBoxServices.RemovePluginInfo(IndexAboutBox);
    IndexAboutBox := 0;
    OTAAboutBoxServices := nil;
  end;
end;

initialization
  RegisterAboutBox;

finalization
  UnregisterAboutBox;

end.
