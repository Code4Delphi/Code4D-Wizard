unit C4D.Wizard.IDE.PopupMenu;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Types,
  C4D.Wizard.Reopen.Model,
  C4D.Wizard.IDE.PopupMenu.Item;

type
  TC4DWizardIDEPopupMenuNotifier = class(TNotifierObject, IOTAProjectMenuItemCreatorNotifier)
  private
    FProject: IOTAProject;
    FPosition: Integer;
    function AddItemInMenu(const ACaption: string): IOTAProjectManagerMenu;
    function AddSubItemInMenu(const ACaption: string;
      const AOnExecute: TC4DWizardMenuContextList = nil;
      const AChecked: Boolean = False): IOTAProjectManagerMenu;
    procedure CheckFileNameProject;
    function GetReopenDataOfFileName: TC4DWizardReopenData;
    procedure OnExecuteMarkAsFavorite(const MenuContextList: IInterfaceList);
    procedure OnExecuteMarkAsUnfavorite(const MenuContextList: IInterfaceList);
    procedure OnExecuteEditInformations(const MenuContextList: IInterfaceList);
    procedure OnExecuteDefaultFilesInOpeningProject(const MenuContextList: IInterfaceList);
    procedure OnExecuteOpenInGitHubDesktop(const MenuContextList: IInterfaceList);
    procedure OnExecuteViewInRemoteRepository(const MenuContextList: IInterfaceList);
    procedure OnExecuteViewInfRemoteRepository(const MenuContextList: IInterfaceList);
    procedure OnExecuteViewFileInExplorer(const MenuContextList: IInterfaceList);
    procedure OnExecuteViewExeInExplorer(const MenuContextList: IInterfaceList);
  protected
    procedure AddMenu(const Project: IOTAProject; const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
  public
    class function New: IOTAProjectMenuItemCreatorNotifier;
  end;

var
  IndexRegPopupMenu: Integer = -1;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Reopen.Controller,
  C4D.Wizard.DefaultFilesInOpeningProject;

procedure RegisterSelf;
begin
  IndexRegPopupMenu := TC4DWizardUtilsOTA
    .GetIOTAProjectManager
    .AddMenuItemCreatorNotifier(TC4DWizardIDEPopupMenuNotifier.New);
end;

class function TC4DWizardIDEPopupMenuNotifier.New: IOTAProjectMenuItemCreatorNotifier;
begin
  Result := Self.Create;
end;

procedure TC4DWizardIDEPopupMenuNotifier.AddMenu(const Project: IOTAProject; const IdentList: TStrings; const ProjectManagerMenuList: IInterfaceList; IsMultiSelect: Boolean);
begin
  if(not Assigned(ProjectManagerMenuList))then
    Exit;

  if(IdentList.IndexOf(sProjectContainer) >= 0)then
    FPosition := pmmpUninstall
  else if(IdentList.IndexOf(sProjectGroupContainer) >= 0)then
    FPosition := pmmpRename
  else
    Exit;

  FProject := Project;
  FPosition := FPosition + 200;
  ProjectManagerMenuList.Add(Self.AddItemInMenu('-'));
  ProjectManagerMenuList.Add(Self.AddItemInMenu(TC4DConsts.ITEM_MENU_Code4D_CAPTION));

  if(System.SysUtils.FileExists(FProject.FileName))and(Self.GetReopenDataOfFileName.Favorite)then
    ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_Mark_Unfavorite_CAPTION,
      OnExecuteMarkAsUnfavorite))
  else
    ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_Mark_Favorite_CAPTION,
      OnExecuteMarkAsFavorite));

  ProjectManagerMenuList.Add(Self.AddSubItemInMenu('-'));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_EditInformations_CAPTION,
    OnExecuteEditInformations));

  ProjectManagerMenuList.Add(Self.AddSubItemInMenu('-'));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_DefaultFilesInOpeningProject_CAPTION,
    OnExecuteDefaultFilesInOpeningProject));

  ProjectManagerMenuList.Add(Self.AddSubItemInMenu('-'));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_OpenInGitHubDesktop_CAPTION,
    OnExecuteOpenInGitHubDesktop));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_ViewInRemoteRepository_CAPTION,
    OnExecuteViewInRemoteRepository));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_ViewInfRemoteRepository_CAPTION,
    OnExecuteViewInfRemoteRepository));

  ProjectManagerMenuList.Add(Self.AddSubItemInMenu('-'));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_ViewFileInExplorer_CAPTION,
    OnExecuteViewFileInExplorer));
  ProjectManagerMenuList.Add(Self.AddSubItemInMenu(TC4DConsts.ITEM_MENU_ViewExeInExplorer_CAPTION,
    OnExecuteViewExeInExplorer));
end;

procedure TC4DWizardIDEPopupMenuNotifier.CheckFileNameProject;
begin
  if(FProject.FileName.Trim.IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('File name is empty');

  if(not System.SysUtils.FileExists(FProject.FileName))then
    TC4DWizardUtils.ShowMsgAndAbort('File not found');
end;

function TC4DWizardIDEPopupMenuNotifier.GetReopenDataOfFileName: TC4DWizardReopenData;
begin
  Result := TC4DWizardReopenModel.New.ReadFilePathInIniFile(FProject.FileName);
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteMarkAsFavorite(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenModel.New.WriteFilePathInIniFile(FProject.FileName, TC4DWizardFavorite.Yes);
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteMarkAsUnfavorite(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenModel.New.WriteFilePathInIniFile(FProject.FileName, TC4DWizardFavorite.No);
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteEditInformations(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenController.New(FProject.FileName).EditInformations;
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteDefaultFilesInOpeningProject(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardDefaultFilesInOpeningProject.New(FProject.FileName).SelectionFilesForDefaultOpening;
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteViewInfRemoteRepository(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenController.New(FProject.FileName).ViewInformationRemoteRepository;
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteOpenInGitHubDesktop(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenController.New(FProject.FileName).OpenInGitHubDesktop;
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteViewInRemoteRepository(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardReopenController.New(FProject.FileName).ViewInRemoteRepository;
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteViewFileInExplorer(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardUtils.OpenFile(FProject.FileName);
end;

procedure TC4DWizardIDEPopupMenuNotifier.OnExecuteViewExeInExplorer(const MenuContextList: IInterfaceList);
begin
  Self.CheckFileNameProject;
  TC4DWizardUtilsOTA.OpenBinaryPath(FProject);
end;

function TC4DWizardIDEPopupMenuNotifier.AddItemInMenu(const ACaption: string): IOTAProjectManagerMenu;
begin
  Result := TC4DWizardIDEPopupMenuItem.New({$IF CompilerVersion = 30} TC4DWizardMenuContextList(nil) {$ELSE} nil {$ENDIF});
  Result.Caption := ACaption;
  Result.Verb := ACaption;
  Result.Parent := '';
  Result.Position := TC4DWizardUtils.IncInt(FPosition);
  Result.Checked := False;
  Result.IsMultiSelectable := False;
end;

function TC4DWizardIDEPopupMenuNotifier.AddSubItemInMenu(const ACaption: string;
  const AOnExecute: TC4DWizardMenuContextList = nil;
  const AChecked: Boolean = False): IOTAProjectManagerMenu;
begin
  Result := TC4DWizardIDEPopupMenuItem.New(AOnExecute);
  Result.Caption := ACaption;
  Result.Verb := ACaption;
  Result.Parent := TC4DConsts.ITEM_MENU_Code4D_CAPTION;
  Result.Position := TC4DWizardUtils.IncInt(FPosition);
  Result.Checked := AChecked;
  Result.IsMultiSelectable := False;
end;

initialization

finalization
  if(IndexRegPopupMenu >= 0)then
    TC4DWizardUtilsOTA.GetIOTAProjectManager.RemoveMenuItemCreatorNotifier(IndexRegPopupMenu);

end.
