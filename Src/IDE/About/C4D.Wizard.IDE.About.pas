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
begin
  if(Supports(BorlandIDEServices, IOTAAboutBoxServices, OTAAboutBoxServices))then
    IndexAboutBox := OTAAboutBoxServices.AddPluginInfo(TC4DConsts.C_ABOUT_TITLE,
      TC4DConsts.C_ABOUT_COPY_RIGHT + sLineBreak + TC4DConsts.C_ABOUT_DESCRIPTION + sLineBreak + TC4DConsts.C_WIZARD_LICENSE,
      LoadBitmap(HInstance, TC4DConsts.C_RESOURCE_c4d_logo_48x48), TC4DConsts.IS_UNREGISTERED, TC4DConsts.C_WIZARD_LICENSE);
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
