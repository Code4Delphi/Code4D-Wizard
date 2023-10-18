unit C4D.Wizard.Consts;

interface

uses
  C4D.Wizard.Types;

type
  TC4DConsts = class
  public const
    C_SEMANTIC_VERSION = '1.15.0';
    C_NAME_FOLDER_GIT = '.git\';
    C_WIN_CONTROL_FOCU_NIL = nil;
    C_C4D_WIZARD_DPROJ = 'C4DWizard.dproj';
    C_C4D_WIZARD_BPL = 'C4DWizard.bpl';
    C_C4D_PROJECT_GROUP1 = 'ProjectGroup1.groupproj';
    C_NAME_FOLDER_TEMP = 'Temp';
    C_DEFAULT_HTM = 'default.htm';

    //BUILD TYPES
    C_BUILD_DEBUG = 'Debug';
    C_BUILD_RELEASE = 'Release';

    //TAGS
    C_TAG_BLOCK_TEXT_SELECT = '<BlockTextSelect/>';
    C_TAG_FOLDER_GIT = '<FolderGit/>';
    C_TAG_FILE_PATH_BINARY = '<FilePathBinary/>';

    //NAMES FILES .INI
    C_FILE_INI_GENERAL_SETTINGS = 'code4d-wizard.ini';
    C_FILE_INI_REOPEN = 'reopen.ini';
    C_FILE_INI_DEFAULT_FILES_IN_OPENING_PROJECT = 'default-files-in-opening-project.ini';
    C_FILE_INI_GROUPS = 'groups.ini';
    C_FILE_INI_OPEN_EXTERNAL = 'open-external.ini';

    //NAMES FILES .rtf
    C_FILE_RTF_NOTES = 'notes.rtf';

    //ABOUT AND SPLASH
    C_ABOUT_TITLE = 'Code4Delphi Wizard';
    C_ABOUT_COPY_RIGHT = 'Copyright 2023 Code4Delphi Team';
    C_ABOUT_DESCRIPTION = 'Code4delphi Wizard aims to help with productivity in development';
    C_WIZARD_LICENSE = ''; //Freeware

    //NAMES FILES AND IMAGES RESOURCE
    C_RESOURCE_c4d_logo_24x24 = 'c4d_logo_24x24';
    C_RESOURCE_c4d_logo_48x48 = 'c4d_logo_48x48';

    //CAPTIONS ITENS MAIN MENU IDE, AND POPUPMENU PROJ
    C_ITEM_MENU_Code4D_NAME = 'Code4DelphiItemMenu';
    C_ITEM_MENU_Code4D_CAPTION = 'Code4D';
    C_ITEM_MENU_Mark_Favorite_CAPTION = 'Mark as Favorite';
    C_ITEM_MENU_Mark_Unfavorite_CAPTION = 'Mark as Unfavorite';
    C_ITEM_MENU_EditInformations_CAPTION = 'Edit Informations';
    C_ITEM_MENU_DefaultFilesInOpeningProject_NAME = 'C4DWizarDefaultFilesInOpeningProject1';
    C_ITEM_MENU_DefaultFilesInOpeningProject_CAPTION = 'Default Files In Opening Project';
    C_ITEM_MENU_OpenInGitHubDesktop_NAME = 'C4DWizarOpenInGitHubDesktop1';
    C_ITEM_MENU_OpenInGitHubDesktop_CAPTION = 'Open in GitHub Desktop';
    C_ITEM_MENU_ViewInRemoteRepository_NAME = 'C4DWizarViewInRemoteRepository1';
    C_ITEM_MENU_ViewInRemoteRepository_CAPTION = 'View in Remote Repository';
    C_ITEM_MENU_ViewInfRemoteRepository_NAME = 'C4DWizarViewInfRemoteRepository1';
    C_ITEM_MENU_ViewInfRemoteRepository_CAPTION = 'View Information Remote Repository';
    C_ITEM_MENU_ViewFileInExplorer_NAME = 'C4DWizarViewFileInExplorer1';
    C_ITEM_MENU_ViewFileInExplorer_CAPTION = 'View File in Explorer';
    C_ITEM_MENU_ViewExeInExplorer_CAPTION = 'View Binary in Explorer';
    C_ITEM_MENU_ViewFileProjInExplorer_NAME = 'C4DWizarViewFileProjectInExplorer1';
    C_ITEM_MENU_ViewFileProjInExplorer_CAPTION = 'View File Project in Explorer';
    C_ITEM_MENU_ViewCurFileInExplorer_NAME = 'C4DWizarViewCurrentFileInExplorer1';
    C_ITEM_MENU_ViewCurFileInExplorer_CAPTION = 'View Current File in Explorer';
    C_ITEM_MENU_ViewCurExeInExplorer_NAME = 'C4DWizarViewCurrentExeInExplorer1';
    C_ITEM_MENU_ViewCurExeInExplorer_CAPTION = 'View Current Binary in Explorer';

    //MAIN MENU IDE NAME
    C_MENU_IDE_OpenExternal_NAME = 'C4DWizarOpenExternal1';
    C_MENU_IDE_OpenExternal_CAPTION = 'Open External Path';
    C_MENU_IDE_ORGANIZATION_NAME = 'C4DWizarUsesOrganization1';
    C_MENU_IDE_ORGANIZATION_CAPTION = 'Uses Organization';
    C_MENU_IDE_REOPEN_NAME = 'C4DWizarReopen1';
    C_MENU_IDE_REOPEN_CAPTION = 'Reopen File History';
    C_MENU_IDE_TRANSLATE_NAME = 'C4DWizarTranslateText1';
    C_MENU_IDE_TRANSLATE_CAPTION = 'Translate Text';
    C_MENU_IDE_INDENT_NAME = 'C4DWizarIndent1';
    C_MENU_IDE_INDENT_CAPTION = 'Indent Text Selected';
    C_MENU_IDE_FIND_NAME = 'C4DWizarFind1';
    C_MENU_IDE_FIND_CAPTION = 'Find in Files';
    C_MENU_IDE_REPLACE_NAME = 'C4DWizarReplace1';
    C_MENU_IDE_REPLACE_CAPTION = 'Replace in Files';
    C_MENU_IDE_BACKUP_NAME = 'C4DWizarBackupConfig1';
    C_MENU_IDE_BACKUP_CAPTION = 'Backup/Restore Configs';
    C_MENU_IDE_IMPORT_NAME = 'C4DWizarBackupImportConfig1';
    C_MENU_IDE_IMPORT_CAPTION = 'Import Configs';
    C_MENU_IDE_EXPORT_NAME = 'C4DWizarBackupExportConfig1';
    C_MENU_IDE_EXPORT_CAPTION = 'Export Configs';
    C_MENU_IDE_SETTINGS_NAME = 'C4DWizarSettings1';
    C_MENU_IDE_SETTINGS_CAPTION = 'Settings';
    C_MENU_IDE_ABOUT_NAME = 'C4DWizarAbout1';
    C_MENU_IDE_ABOUT_CAPTION = 'About Code4Delphi Wizard';
    C_MENU_IDE_FormatSource_NAME = 'C4DFormatSource1';
    C_MENU_IDE_FormatSource_CAPTION = 'Format Source';
    C_MENU_IDE_NOTES_NAME = 'C4DWizarNotes1';
    C_MENU_IDE_NOTES_CAPTION = 'Notes';

    //FILE .INI REOPEN
    C_REOPEN_INI_Favorite = 'Favorite';
    C_REOPEN_INI_Nickname = 'Nickname';
    C_REOPEN_INI_Name = 'Name';
    C_REOPEN_INI_LastOpen = 'LastOpen';
    C_REOPEN_INI_LastClose = 'LastClose';
    C_REOPEN_INI_FilePath = 'FilePath';
    C_REOPEN_INI_Color = 'Color';
    C_REOPEN_INI_FolderGit = 'FolderGit';
    C_REOPEN_INI_GuidGroup = 'GuidGroup';

    //FILE .INI DefaultFilesInOpeningProject
    C_DEFAULT_FILES_IN_OPENING_PROJECT_INI_ListFilePathDefault = 'ListFilePathDefault';

    //GROUPS FILE .INI
    C_GROUPS_GUID_ALL = 'ALL';
    C_GROUPS_GUID_NO_GROUP = 'NO-GROUP';
    C_GROUPS_INI_Name = 'Name';
    C_GROUPS_INI_FixedSystem = 'FixedSystem';
    C_GROUPS_INI_DefaultGroup = 'DefaultGroup';

    //OpenExternal FILE .INI
    C_OPEN_EXTERNAL_Separator_PARAMETERS = '|p|';
    C_OPEN_EXTERNAL_INI_Description = 'Description';
    C_OPEN_EXTERNAL_INI_Path = 'Path';
    C_OPEN_EXTERNAL_INI_Parameters = 'Parameters';
    C_OPEN_EXTERNAL_INI_Kind = 'Kind';
    C_OPEN_EXTERNAL_INI_Visible = 'Visible';
    C_OPEN_EXTERNAL_INI_VisibleInToolBarUtilities = 'VisibleInToolBarUtilities';
    C_OPEN_EXTERNAL_INI_Order = 'Order';
    C_OPEN_EXTERNAL_INI_Shortcut = 'Shortcut';
    C_OPEN_EXTERNAL_INI_IconHas = 'IconHas';
    C_OPEN_EXTERNAL_INI_PREFIX_IMG = 'OPEN_EXTERNAL_IMG_';

    //TOOLBAR BRANCH
    C_TOOL_BAR_BRANCH_NAME = 'C4DToolBarBranch';
    C_TOOL_BAR_BRANCH_CAPTION = 'C4D Branch';
    C_TOOL_BAR_BRANCH_TOOL_BUTTON_NAME = 'C4DToolButtonGetNameCurrentBranch';
    C_TOOL_BAR_BRANCH_LABEL_NAME = 'C4DToolLabelNameCurrentBranch';
    //TOOLBAR BRANCH INI
    C_TOOL_BAR_BRANCH_INI_Visible = 'Visible';

    //TOOLBAR BUILD
    C_TOOL_BAR_BUILD_NAME = 'C4DToolBarBuild';
    C_TOOL_BAR_BUILD_CAPTION = 'C4D Build';
    C_TOOL_BAR_BUILD_TOOL_BUTTON_BuildAllGroup_NAME = 'C4DToolButtonBuildAllGroup';
    C_TOOL_BAR_BUILD_TOOL_BUTTON_BuildInRelease_NAME = 'C4DToolButtonBuildInRelease';
    C_TOOL_BAR_BUILD_COMBOBOX_NAME = 'C4DToolComboBoxNameCurrentBuild';
    C_TOOL_BAR_BUILD_TOOL_BUTTON_REFRESH_NAME = 'C4DToolButtonBuildRefresh';
    //TOOLBAR BUILD INI
    C_TOOL_BAR_BUILD_INI_Visible = 'Visible';

    //TOOLBAR UTILITIES
    C_TOOL_BAR_UTILITIES_NAME = 'C4DToolBarUtilities';
    C_TOOL_BAR_UTILITIES_CAPTION = 'C4D Utilities';
    C_TOOL_BAR_UTILITIES_TOOL_BUTTON_UnitInReadOnly_NAME = 'C4DToolButtoUtilitiesUnitInReadOnly';
    C_TOOL_BAR_UTILITIES_TOOL_BUTTON_GithubDesktop_NAME = 'C4DToolButtonUtilitiesGithubDesktop';
    //TOOLBAR UTILITIES INI
    C_TOOL_BAR_UTILITIES_INI_Visible = 'Visible';

    C_EXTENSIONS_PERMITTED_BACKUP_EXPORT: TC4DExtensionsOfFiles = [TC4DExtensionsFiles.INI,
      TC4DExtensionsFiles.BMP];
  end;

implementation

end.
