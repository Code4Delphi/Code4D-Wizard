unit C4D.Wizard.IDE.MainMenu;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Menus,
  ToolsAPI,
  C4D.Wizard.Interfaces;

type
  TC4DWizardIDEMainMenu = class(TInterfacedObject, IC4DWizardIDEMainMenu)
  private
    FMainMenuIDE: TMainMenu;
    FMenuItemC4D: TMenuItem;
    constructor Create;
    procedure CreateMenuCode4DelphiInIDEMenu;
    function CreateSubMenu(AName: string; ACaption: string; AOnClick: TNotifyEvent; AImgIndex: Integer = -1; AShortCutStr: string = ''): TMenuItem;
    function GetShortcutUsesOrganization: string;
    function GetShortcutReopenFileHistory: string;
    function GetShortcutOpenInGitHubDesktop: string;
    function GetShortcutTranslateText: string;
    function GetShortcutIndent: string;
    function GetShortcutReplace: string;
    function GetShortcutNotes: string;
    function GetShortcutFind: string;
    function GetShortcutDefaultFilesInOpeningProject: string;
  protected
    procedure CreateMenus;
  public
    class function GetInstance: IC4DWizardIDEMainMenu;
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.IDE.MainMenu.Clicks,
  C4D.Wizard.Settings.Model,
  C4D.Wizard.IDE.MainMenu.OpenExternal,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.IDE.MainMenu.Backup;

var
  Instance: IC4DWizardIDEMainMenu;

class function TC4DWizardIDEMainMenu.GetInstance: IC4DWizardIDEMainMenu;
begin
  if(not Assigned(Instance))then
    Instance := Self.Create;
  Result := Instance;
end;

constructor TC4DWizardIDEMainMenu.Create;
begin
  FMainMenuIDE := TC4DWizardUtilsOTA.GetINTAServices.MainMenu;
end;

destructor TC4DWizardIDEMainMenu.Destroy;
begin
  if(Assigned(FMenuItemC4D))then
    FreeAndNil(FMenuItemC4D);
  inherited;
end;

procedure TC4DWizardIDEMainMenu.CreateMenus;
begin
  Self.CreateMenuCode4DelphiInIDEMenu;

  TC4DWizardIDEMainMenuOpenExternal.New(FMenuItemC4D).CreateMenusOpenExternal;

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_ORGANIZATION_NAME,
    TC4DConsts.C_MENU_IDE_ORGANIZATION_CAPTION,
    TC4DWizardIDEMainMenuClicks.UsesOrganizationClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexUsesOrganization,
    Self.GetShortcutUsesOrganization);

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_REOPEN_NAME,
    TC4DConsts.C_MENU_IDE_REOPEN_CAPTION,
    TC4DWizardIDEMainMenuClicks.ReopenClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexFolderOpen,
    Self.GetShortcutReopenFileHistory);

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_TRANSLATE_NAME,
    TC4DConsts.C_MENU_IDE_TRANSLATE_CAPTION,
    TC4DWizardIDEMainMenuClicks.TranslateTextClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexTranslate,
    Self.GetShortcutTranslateText);

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_INDENT_NAME,
    TC4DConsts.C_MENU_IDE_INDENT_CAPTION,
    TC4DWizardIDEMainMenuClicks.IndentClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexIndent,
    Self.GetShortcutIndent);

  {Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_FormatSource_NAME,
    TC4DConsts.C_MENU_IDE_FormatSource_CAPTION,
    TC4DWizardIDEMainMenuClicks.FormatSourceClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgVerifyDocument); }

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_FIND_NAME,
    TC4DConsts.C_MENU_IDE_FIND_CAPTION,
    TC4DWizardIDEMainMenuClicks.FindClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexFind,
    Self.GetShortcutFind);

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_REPLACE_NAME,
    TC4DConsts.C_MENU_IDE_REPLACE_CAPTION,
    TC4DWizardIDEMainMenuClicks.ReplaceClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexReplace,
    Self.GetShortcutReplace);

  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_NOTES_NAME,
    TC4DConsts.C_MENU_IDE_NOTES_CAPTION,
    TC4DWizardIDEMainMenuClicks.NotesClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexNotes,
    Self.GetShortcutNotes);

  Self.CreateSubMenu('C4DSeparator50', '-', nil);
  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_DefaultFilesInOpeningProject_NAME,
    TC4DConsts.C_ITEM_MENU_DefaultFilesInOpeningProject_CAPTION,
    TC4DWizardIDEMainMenuClicks.DefaultFilesInOpeningProjectClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexLinkToFile,
    Self.GetShortcutDefaultFilesInOpeningProject);

  Self.CreateSubMenu('C4DSeparator60', '-', nil);
  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_SETTINGS_NAME,
    TC4DConsts.C_MENU_IDE_SETTINGS_CAPTION,
    TC4DWizardIDEMainMenuClicks.SettingsClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexGear);

  TC4DWizardIDEMainMenuBakcups.New(FMenuItemC4D).Process;

  Self.CreateSubMenu('C4DSeparator70', '-', nil);
  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_OpenInGitHubDesktop_NAME,
    TC4DConsts.C_ITEM_MENU_OpenInGitHubDesktop_CAPTION,
    TC4DWizardIDEMainMenuClicks.OpenInGitHubDesktopClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexGithubDesktop,
    Self.GetShortcutOpenInGitHubDesktop);

  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_ViewInRemoteRepository_NAME,
    TC4DConsts.C_ITEM_MENU_ViewInRemoteRepository_CAPTION,
    TC4DWizardIDEMainMenuClicks.ViewInRemoteRepositoryClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexGitRemote);

  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_ViewInfRemoteRepository_NAME,
    TC4DConsts.C_ITEM_MENU_ViewInfRemoteRepository_CAPTION,
    TC4DWizardIDEMainMenuClicks.ViewInfRemoteRepositoryClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexGitInf);

  Self.CreateSubMenu('C4DSeparator80', '-', nil);
  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_ViewFileProjInExplorer_NAME,
    TC4DConsts.C_ITEM_MENU_ViewFileProjInExplorer_CAPTION,
    TC4DWizardIDEMainMenuClicks.ViewFileProjectInExplorerClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexOpenInExplorer);

  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_ViewCurFileInExplorer_NAME,
    TC4DConsts.C_ITEM_MENU_ViewCurFileInExplorer_CAPTION,
    TC4DWizardIDEMainMenuClicks.ViewCurrentFileInExplorerClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexOpenInExplorerFile);

  Self.CreateSubMenu(TC4DConsts.C_ITEM_MENU_ViewCurExeInExplorer_NAME,
    TC4DConsts.C_ITEM_MENU_ViewCurExeInExplorer_CAPTION,
    TC4DWizardIDEMainMenuClicks.ViewCurrentExeInExplorerClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexBinary);

  Self.CreateSubMenu('C4DSeparator90', '-', nil);
  Self.CreateSubMenu(TC4DConsts.C_MENU_IDE_ABOUT_NAME,
    TC4DConsts.C_MENU_IDE_ABOUT_CAPTION,
    TC4DWizardIDEMainMenuClicks.AboutClick,
    TC4DWizardIDEImageListMain.GetInstance.ImgIndexC4D_Logo);
end;

procedure TC4DWizardIDEMainMenu.CreateMenuCode4DelphiInIDEMenu;
var
  LMenuItemTabs: TMenuItem;
  LMenuItemTools: TMenuItem;
begin
  FMenuItemC4D := TMenuItem(FMainMenuIDE.FindComponent(TC4DConsts.C_ITEM_MENU_Code4D_NAME));
  if(Assigned(FMenuItemC4D))then
    FreeAndNil(FMenuItemC4D);

  FMenuItemC4D := TMenuItem.Create(FMainMenuIDE);
  FMenuItemC4D.Name := TC4DConsts.C_ITEM_MENU_Code4D_NAME;
  FMenuItemC4D.Caption := TC4DConsts.C_ITEM_MENU_Code4D_CAPTION;

  LMenuItemTabs := FMainMenuIDE.Items.Find('Tabs');
  if(Assigned(LMenuItemTabs))then
  begin
    FMainMenuIDE.Items.Insert(FMainMenuIDE.Items.IndexOf(LMenuItemTabs), FMenuItemC4D);
    Exit;
  end;

  LMenuItemTools := FMainMenuIDE.Items.Find('Tools');
  if(Assigned(LMenuItemTools))then
  begin
    FMainMenuIDE.Items.Insert(FMainMenuIDE.Items.IndexOf(LMenuItemTools) + 1, FMenuItemC4D);
    Exit;
  end;

  FMainMenuIDE.Items.Add(FMenuItemC4D);
end;

function TC4DWizardIDEMainMenu.CreateSubMenu(AName: string; ACaption: string; AOnClick: TNotifyEvent; AImgIndex: Integer = -1; AShortCutStr: string = ''): TMenuItem;
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(FMenuItemC4D);
  LMenuItem.Name := AName;
  LMenuItem.Caption := ACaption;
  LMenuItem.OnClick := AOnClick;
  LMenuItem.ImageIndex := AImgIndex;
  LMenuItem.ShortCut := TextToShortCut(TC4DWizardUtils.RemoveSpacesAll(AShortCutStr));
  FMenuItemC4D.Add(LMenuItem);
  Result := LMenuItem;
end;

function TC4DWizardIDEMainMenu.GetShortcutUsesOrganization: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutUsesOrganizationUse)and(not C4DWizardSettingsModel.ShortcutUsesOrganization.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutUsesOrganization.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutReopenFileHistory: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutReopenFileHistoryUse)and(not C4DWizardSettingsModel.ShortcutReopenFileHistory.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutReopenFileHistory.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutOpenInGitHubDesktop: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutGitHubDesktopUse)and(not C4DWizardSettingsModel.ShortcutGitHubDesktop.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutGitHubDesktop.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutTranslateText: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutTranslateTextUse)and(not C4DWizardSettingsModel.ShortcutTranslateText.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutTranslateText.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutIndent: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutIndentUse)and(not C4DWizardSettingsModel.ShortcutIndent.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutIndent.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutFind: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutFindInFilesUse)and(not C4DWizardSettingsModel.ShortcutFIndInFiles.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutFIndInFiles.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutReplace: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutReplaceFilesUse)and(not C4DWizardSettingsModel.ShortcutReplaceFiles.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutReplaceFiles.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutNotes: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutNotesUse)and(not C4DWizardSettingsModel.ShortcutNotes.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutNotes.Trim;
end;

function TC4DWizardIDEMainMenu.GetShortcutDefaultFilesInOpeningProject: string;
begin
  Result := '';
  if(C4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProjectUse)and(not C4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProject.Trim.IsEmpty)then
    Result := C4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProject.Trim;
end;

initialization

finalization
  if(Assigned(Instance))then
    Instance := nil;

end.
