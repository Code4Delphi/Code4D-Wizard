unit C4D.Wizard.Settings.View;

interface

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus;

type
  TC4DWizardSettingsView = class(TForm)
    Panel9: TPanel;
    Bevel1: TBevel;
    Panel1: TPanel;
    btnConfirm: TButton;
    btnClose: TButton;
    Label4: TLabel;
    gBoxShortcut: TGroupBox;
    ckShortcutUsesOrganizationUse: TCheckBox;
    ckShortcutReopenFileHistoryUse: TCheckBox;
    ckShortcutGitHubDesktopUse: TCheckBox;
    ckShortcutTranslateTextUse: TCheckBox;
    edtShortcutUsesOrganization: THotKey;
    edtShortcutReopenFileHistory: THotKey;
    edtShortcutGitHubDesktop: THotKey;
    edtShortcutTranslateText: THotKey;
    ckShortcutIndentUse: TCheckBox;
    edtShortcutIndent: THotKey;
    ckShortcutReplaceFilesUse: TCheckBox;
    edtShortcutReplaceFiles: THotKey;
    ckShortcutFindInFilesUse: TCheckBox;
    edtShortcutFindInFiles: THotKey;
    ckShortcutDefaultFilesInOpeningProjectUse: TCheckBox;
    edtShortcutDefaultFilesInOpeningProject: THotKey;
    gboxData: TGroupBox;
    btnOpenDataFolder: TButton;
    gBoxSettings: TGroupBox;
    ckBlockKeyInsert: TCheckBox;
    ckBeforeCompilingCheckRunning: TCheckBox;
    ckShortcutNotesUse: TCheckBox;
    edtShortcutNotes: THotKey;
    ckShortcutVsCodeIntegrationOpenUse: TCheckBox;
    edtShortcutVsCodeIntegrationOpen: THotKey;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ckShortcutUsesOrganizationUseClick(Sender: TObject);
    procedure btnOpenDataFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure ConfComponents;
    procedure WriteConfigurationScreen;
    procedure ReadConfigurationScreen;
  public

  end;

var
  C4DWizardSettingsView: TC4DWizardSettingsView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Settings.Model,
  C4D.Wizard.IDE.MainMenu,
  C4D.Wizard.IDE.Shortcuts.BlockKeyInsert;

{$R *.dfm}


procedure TC4DWizardSettingsView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardSettingsView, Self);
end;

procedure TC4DWizardSettingsView.FormShow(Sender: TObject);
begin
  Self.ReadConfigurationScreen;
  Self.ConfComponents;
end;

procedure TC4DWizardSettingsView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  C4D.Wizard.IDE.Shortcuts.BlockKeyInsert.RefreshRegister;
end;

procedure TC4DWizardSettingsView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      btnClose.Click;
  end;
end;

procedure TC4DWizardSettingsView.ConfComponents;
begin
  edtShortcutUsesOrganization.Enabled := ckShortcutUsesOrganizationUse.Checked;
  edtShortcutReopenFileHistory.Enabled := ckShortcutReopenFileHistoryUse.Checked;
  edtShortcutTranslateText.Enabled := ckShortcutTranslateTextUse.Checked;
  edtShortcutIndent.Enabled := ckShortcutIndentUse.Checked;
  edtShortcutFindInFiles.Enabled := ckShortcutFindInFilesUse.Checked;
  edtShortcutReplaceFiles.Enabled := ckShortcutReplaceFilesUse.Checked;
  edtShortcutNotes.Enabled := ckShortcutNotesUse.Checked;
  edtShortcutVsCodeIntegrationOpen.Enabled := ckShortcutVsCodeIntegrationOpenUse.Checked;
  edtShortcutDefaultFilesInOpeningProject.Enabled := ckShortcutDefaultFilesInOpeningProjectUse.Checked;
  edtShortcutGitHubDesktop.Enabled := ckShortcutGitHubDesktopUse.Checked;
end;

procedure TC4DWizardSettingsView.ReadConfigurationScreen;
begin
  C4DWizardSettingsModel.ReadIniFile;
  ckShortcutUsesOrganizationUse.Checked := C4DWizardSettingsModel.ShortcutUsesOrganizationUse;
  edtShortcutUsesOrganization.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutUsesOrganization);
  ckShortcutReopenFileHistoryUse.Checked := C4DWizardSettingsModel.ShortcutReopenFileHistoryUse;
  edtShortcutReopenFileHistory.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutReopenFileHistory);
  ckShortcutTranslateTextUse.Checked := C4DWizardSettingsModel.ShortcutTranslateTextUse;
  edtShortcutTranslateText.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutTranslateText);
  ckShortcutIndentUse.Checked := C4DWizardSettingsModel.ShortcutIndentUse;
  edtShortcutIndent.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutIndent);
  ckShortcutFindInFilesUse.Checked := C4DWizardSettingsModel.ShortcutFindInFilesUse;
  edtShortcutFindInFiles.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutFindInFiles);
  ckShortcutReplaceFilesUse.Checked := C4DWizardSettingsModel.ShortcutReplaceFilesUse;
  edtShortcutReplaceFiles.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutReplaceFiles);
  ckShortcutNotesUse.Checked := C4DWizardSettingsModel.ShortcutNotesUse;
  edtShortcutNotes.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutNotes);
  ckShortcutVsCodeIntegrationOpenUse.Checked := C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpenUse;
  edtShortcutVsCodeIntegrationOpen.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen);
  ckShortcutDefaultFilesInOpeningProjectUse.Checked := C4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProjectUse;
  edtShortcutDefaultFilesInOpeningProject.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProject);
  ckShortcutGitHubDesktopUse.Checked := C4DWizardSettingsModel.ShortcutGitHubDesktopUse;
  edtShortcutGitHubDesktop.HotKey := TextToShortCut(C4DWizardSettingsModel.ShortcutGitHubDesktop);
  ckBlockKeyInsert.Checked := C4DWizardSettingsModel.BlockKeyInsert;
  ckBeforeCompilingCheckRunning.Checked := C4DWizardSettingsModel.BeforeCompilingCheckRunning;
end;

procedure TC4DWizardSettingsView.WriteConfigurationScreen;
begin
  C4DWizardSettingsModel
    .ShortcutUsesOrganizationUse(ckShortcutUsesOrganizationUse.Checked)
    .ShortcutUsesOrganization(ShortCutToText(edtShortcutUsesOrganization.HotKey))
    .ShortcutReopenFileHistoryUse(ckShortcutReopenFileHistoryUse.Checked)
    .ShortcutReopenFileHistory(ShortCutToText(edtShortcutReopenFileHistory.HotKey))
    .ShortcutTranslateTextUse(ckShortcutTranslateTextUse.Checked)
    .ShortcutTranslateText(ShortCutToText(edtShortcutTranslateText.HotKey))
    .ShortcutIndentUse(ckShortcutIndentUse.Checked)
    .ShortcutIndent(ShortCutToText(edtShortcutIndent.HotKey))
    .ShortcutFindInFilesUse(ckShortcutFindInFilesUse.Checked)
    .ShortcutFindInFiles(ShortCutToText(edtShortcutFindInFiles.HotKey))
    .ShortcutReplaceFilesUse(ckShortcutReplaceFilesUse.Checked)
    .ShortcutReplaceFiles(ShortCutToText(edtShortcutReplaceFiles.HotKey))
    .ShortcutNotesUse(ckShortcutNotesUse.Checked)
    .ShortcutNotes(ShortCutToText(edtShortcutNotes.HotKey))
    .ShortcutVsCodeIntegrationOpenUse(ckShortcutVsCodeIntegrationOpenUse.Checked)
    .ShortcutVsCodeIntegrationOpen(ShortCutToText(edtShortcutVsCodeIntegrationOpen.HotKey))
    .ShortcutDefaultFilesInOpeningProjectUse(ckShortcutDefaultFilesInOpeningProjectUse.Checked)
    .ShortcutDefaultFilesInOpeningProject(ShortCutToText(edtShortcutDefaultFilesInOpeningProject.HotKey))
    .ShortcutGitHubDesktopUse(ckShortcutGitHubDesktopUse.Checked)
    .ShortcutGitHubDesktop(ShortCutToText(edtShortcutGitHubDesktop.HotKey))
    .BlockKeyInsert(ckBlockKeyInsert.Checked)
    .BeforeCompilingCheckRunning(ckBeforeCompilingCheckRunning.Checked)
    .WriteIniFile;
end;

procedure TC4DWizardSettingsView.btnConfirmClick(Sender: TObject);
begin
  Self.WriteConfigurationScreen;
  TC4DWizardIDEMainMenu.GetInstance.CreateMenus;
  Self.Close;
  Self.ModalResult := mrOk;
end;

procedure TC4DWizardSettingsView.ckShortcutUsesOrganizationUseClick(Sender: TObject);
begin
  //**SEVERAL
  Self.ConfComponents;
end;

procedure TC4DWizardSettingsView.btnOpenDataFolderClick(Sender: TObject);
var
  LPathFolder: string;
begin
  LPathFolder := TC4DWizardUtils.GetPathFolderRoot;
  if(not DirectoryExists(LPathFolder))then
    TC4DWizardUtils.ShowMsg('Forder not found: ' + LPathFolder);

  TC4DWizardUtils.OpenFolder(LPathFolder);
end;

procedure TC4DWizardSettingsView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

end.
