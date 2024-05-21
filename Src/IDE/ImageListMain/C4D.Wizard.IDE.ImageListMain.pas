unit C4D.Wizard.IDE.ImageListMain;

interface

uses
  System.SysUtils,
  System.Classes;

type
  TC4DWizardIDEImageListMain = class
  private
    FImgIndexC4D_Logo: Integer;
    FImgIndexUsesOrganization: Integer;
    FImgIndexFolderOpen: Integer;
    FImgIndexGear: Integer;
    FImgIndexOpenInExplorer: Integer;
    FImgIndexOpenInExplorerFile: Integer;
    FImgIndexGitRemote: Integer;
    FImgIndexGitInf: Integer;
    FImgIndexGithubDesktop: Integer;
    FImgIndexTranslate: Integer;
    FImgIndexIndent: Integer;
    FImgIndexArrowGreen: Integer;
    FImgIndexFind: Integer;
    FImgIndexReplace: Integer;
    FImgIndexSave: Integer;
    FImgIndexExport: Integer;
    FImgIndexImport: Integer;
    FImgIndexBinary: Integer;
    FImgIndexRefresh: Integer;
    FImgIndexLinkToFile: Integer;
    FImgIndexPlayBlue: Integer;
    FImgIndexLockON: Integer;
    FImgIndexLockOFF: Integer;
    FImgIndexEmpty: Integer;
    FImgIndexBuildGroup: Integer;
    FImgIndexVerifyDocument: Integer;
    FImgIndexNotes: Integer;
    FImgIndexCleanAndStart: Integer;
    FImgIndexVsCode: Integer;
    constructor Create;
  public
    property ImgIndexC4D_Logo: Integer read FImgIndexC4D_Logo;
    property ImgIndexUsesOrganization: Integer read FImgIndexUsesOrganization;
    property ImgIndexFolderOpen: Integer read FImgIndexFolderOpen;
    property ImgIndexGear: Integer read FImgIndexGear;
    property ImgIndexOpenInExplorer: Integer read FImgIndexOpenInExplorer;
    property ImgIndexOpenInExplorerFile: Integer read FImgIndexOpenInExplorerFile;
    property ImgIndexGitRemote: Integer read FImgIndexGitRemote;
    property ImgIndexGitInf: Integer read FImgIndexGitInf;
    property ImgIndexGithubDesktop: Integer read FImgIndexGithubDesktop;
    property ImgIndexTranslate: Integer read FImgIndexTranslate;
    property ImgIndexIndent: Integer read FImgIndexIndent;
    property ImgIndexArrowGreen: Integer read FImgIndexArrowGreen;
    property ImgIndexFind: Integer read FImgIndexFind;
    property ImgIndexReplace: Integer read FImgIndexReplace;
    property ImgIndexSave: Integer read FImgIndexSave;
    property ImgIndexExport: Integer read FImgIndexExport;
    property ImgIndexImport: Integer read FImgIndexImport;
    property ImgIndexBinary: Integer read FImgIndexBinary;
    property ImgIndexRefresh: Integer read FImgIndexRefresh;
    property ImgIndexLinkToFile: Integer read FImgIndexLinkToFile;
    property ImgIndexPlayBlue: Integer read FImgIndexPlayBlue;
    property ImgIndexLockON: Integer read FImgIndexLockON;
    property ImgIndexLockOFF: Integer read FImgIndexLockOFF;
    property ImgIndexEmpty: Integer read FImgIndexEmpty;
    property ImgIndexBuildGroup: Integer read FImgIndexBuildGroup;
    property ImgIndexVerifyDocument: Integer read FImgIndexVerifyDocument;
    property ImgIndexNotes: Integer read FImgIndexNotes;
    property ImgIndexCleanAndStart: Integer read FImgIndexCleanAndStart;
    property ImgIndexVsCode: Integer read FImgIndexVsCode;
    class function GetInstance: TC4DWizardIDEImageListMain;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA;

var
  Instance: TC4DWizardIDEImageListMain;

class function TC4DWizardIDEImageListMain.GetInstance: TC4DWizardIDEImageListMain;
begin
  if(not Assigned(Instance))then
    Instance := Self.Create;
  Result := Instance;
end;

constructor TC4DWizardIDEImageListMain.Create;
begin
  FImgIndexC4D_Logo := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_logo');
  FImgIndexUsesOrganization := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_uses_organization');
  FImgIndexFolderOpen := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_folder_open');
  FImgIndexGear := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_gear');
  FImgIndexOpenInExplorer := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_open_in_explorer');
  FImgIndexOpenInExplorerFile := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_open_in_explorer_fle');
  FImgIndexGitRemote := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_git_remote');
  FImgIndexGitInf := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_git_inf');
  FImgIndexGithubDesktop := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_github_desktop');
  FImgIndexTranslate := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_translate');
  FImgIndexIndent := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_indent');
  FImgIndexArrowGreen := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_arrow_green');
  FImgIndexFind := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_find');
  FImgIndexReplace := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_replace');
  FImgIndexSave := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_save');
  FImgIndexExport := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_export');
  FImgIndexImport := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_import');
  FImgIndexBinary := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_binary');
  FImgIndexRefresh := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_refresh');
  FImgIndexLinkToFile := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_link_to_file');
  FImgIndexPlayBlue := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_play_blue');
  FImgIndexLockON := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_lock_on');
  FImgIndexLockOFF := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_lock_off');
  FImgIndexEmpty := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_empty');
  FImgIndexBuildGroup := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_build_group');
  FImgIndexVerifyDocument := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_verify_document');
  FImgIndexNotes := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_notes');
  FImgIndexCleanAndStart := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_clean_and_start');
  FImgIndexVsCode := TC4DWizardUtilsOTA.AddImgIDEResourceName('c4d_vscode');
end;

initialization
  Instance := TC4DWizardIDEImageListMain.GetInstance;

finalization
  if(Assigned(Instance))then
    Instance.Free;

end.
