unit C4D.Wizard.Settings.Model;

interface

uses
  System.SysUtils,
  System.IniFiles,
  C4D.Wizard.Interfaces;

type
  TC4DWizardSettingsModel = class(TInterfacedObject, IC4DWizardSettingsModel)
  private
    FIniFile: TIniFile;
    FShortcutUsesOrganizationUse: Boolean;
    FShortcutUsesOrganization: string;
    FShortcutDefaultFilesInOpeningProjectUse: Boolean;
    FShortcutDefaultFilesInOpeningProject: string;
    FShortcutReopenFileHistoryUse: Boolean;
    FShortcutReopenFileHistory: string;
    FShortcutTranslateTextUse: Boolean;
    FShortcutTranslateText: string;
    FShortcutIndentUse: Boolean;
    FShortcutIndent: string;
    FShortcutFindInFilesUse: Boolean;
    FShortcutFindInFiles: string;
    FShortcutReplaceFilesUse: Boolean;
    FShortcutReplaceFiles: string;
    FShortcutNotesUse: Boolean;
    FShortcutNotes: string;
    FShortcutVsCodeIntegrationOpenUse: Boolean;
    FShortcutVsCodeIntegrationOpen: string;
    FShortcutGitHubDesktopUse: Boolean;
    FShortcutGitHubDesktop: string;
    FBlockKeyInsert: Boolean;
    FBeforeCompilingCheckRunning: Boolean;

  const
    C_SESSION = 'Settings';
    C_ShortcutUsesOrganizationUse = 'ShortcutUsesOrganizationUse';
    C_ShortcutUsesOrganization = 'ShortcutUsesOrganization';
    C_ShortcutUsesOrganizationDefu = 'Ctrl + Shift + Alt + Y';
    C_ShortcutReopenFileHistoryUse = 'ShortcutReopenFileHistoryUse';
    C_ShortcutReopenFileHistory = 'ShortcutReopenFileHistory';
    C_ShortcutReopenFileHistoryDef = 'Ctrl + Shift + Alt + H';
    C_ShortcutTranslateTextUse = 'ShortcutTranslateTextUse';
    C_ShortcutTranslateText = 'ShortcutTranslateText';
    C_ShortcutTranslateTextDefu = 'Ctrl + Shift + Alt + T';
    C_ShortcutIndentUse = 'ShortcutIndentUse';
    C_ShortcutIndent = 'ShortcutIndent';
    C_ShortcutIndentDefu = 'Ctrl + Shift + Alt + I';
    C_ShortcutFindInFilesUse = 'ShortcutFindInFilesUse';
    C_ShortcutFindInFiles = 'ShortcutFindInFiles';
    C_ShortcutFindInFilesDefu = 'Ctrl + Shift + Alt + F';
    C_ShortcutReplaceFilesUse = 'ShortcutReplaceFilesUse';
    C_ShortcutReplaceFiles = 'ShortcutReplaceFiles';
    C_ShortcutReplaceFilesDefu = 'Ctrl + Shift + Alt + R';
    C_ShortcutNotesUse = 'ShortcutNotesUse';
    C_ShortcutNotes = 'ShortcutNotes';
    C_ShortcutNotesDefu = 'Ctrl + Shift + Alt + N';
    C_ShortcutVsCodeIntegrationOpenUse = 'ShortcutVsCodeIntegrationOpenUse';
    C_ShortcutVsCodeIntegrationOpen = 'ShortcutVsCodeIntegrationOpen';
    C_ShortcutVsCodeIntegrationOpenDefu = 'Ctrl + Shift + Alt + V';
    C_ShortcutGitHubDesktopUse = 'ShortcutGitHubDesktopUse';
    C_ShortcutGitHubDesktop = 'ShortcutGitHubDesktop';
    C_ShortcutGitHubDesktopDefu = 'Ctrl + Shift + Alt + G';
    C_ShortcutDefaultFilesInOpeningProjectUse = 'ShortcutDefaultFilesInOpeningProjectUse';
    C_ShortcutDefaultFilesInOpeningProject = 'ShortcutDefaultFilesInOpeningProject';
    C_ShortcutDefaultFilesInOpeningProjectDefu = '';
    C_BlockKeyInsert = 'BlockKeyInsert';
    C_BeforeCompilingCheckRunning = 'BeforeCompilingCheckRunning';

  protected
    function ShortcutUsesOrganizationUse: Boolean; overload;
    function ShortcutUsesOrganizationUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutUsesOrganization: string; overload;
    function ShortcutUsesOrganization(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutReopenFileHistoryUse: Boolean; overload;
    function ShortcutReopenFileHistoryUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutReopenFileHistory: string; overload;
    function ShortcutReopenFileHistory(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutTranslateTextUse: Boolean; overload;
    function ShortcutTranslateTextUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutTranslateText: string; overload;
    function ShortcutTranslateText(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutIndentUse: Boolean; overload;
    function ShortcutIndentUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutIndent: string; overload;
    function ShortcutIndent(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutFindInFilesUse: Boolean; overload;
    function ShortcutFindInFilesUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutFindInFiles: string; overload;
    function ShortcutFindInFiles(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutReplaceFilesUse: Boolean; overload;
    function ShortcutReplaceFilesUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutReplaceFiles: string; overload;
    function ShortcutReplaceFiles(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutNotesUse: Boolean; overload;
    function ShortcutNotesUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutNotes: string; overload;
    function ShortcutNotes(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutVsCodeIntegrationOpenUse: Boolean; overload;
    function ShortcutVsCodeIntegrationOpenUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutVsCodeIntegrationOpen: string; overload;
    function ShortcutVsCodeIntegrationOpen(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutGitHubDesktopUse: Boolean; overload;
    function ShortcutGitHubDesktopUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutGitHubDesktop: string; overload;
    function ShortcutGitHubDesktop(Value: string): IC4DWizardSettingsModel; overload;

    function ShortcutDefaultFilesInOpeningProjectUse: Boolean; overload;
    function ShortcutDefaultFilesInOpeningProjectUse(Value: Boolean): IC4DWizardSettingsModel; overload;
    function ShortcutDefaultFilesInOpeningProject: string; overload;
    function ShortcutDefaultFilesInOpeningProject(Value: string): IC4DWizardSettingsModel; overload;

    function BlockKeyInsert: Boolean; overload;
    function BlockKeyInsert(Value: Boolean): IC4DWizardSettingsModel; overload;

    function BeforeCompilingCheckRunning: Boolean; overload;
    function BeforeCompilingCheckRunning(Value: Boolean): IC4DWizardSettingsModel; overload;

    function WriteIniFile: IC4DWizardSettingsModel;
    function ReadIniFile: IC4DWizardSettingsModel;
  public
    class function New: IC4DWizardSettingsModel;
    constructor Create;
    destructor Destroy; override;
  end;

var
  C4DWizardSettingsModel: IC4DWizardSettingsModel;

implementation

uses
  C4D.Wizard.Utils;

class function TC4DWizardSettingsModel.New: IC4DWizardSettingsModel;
begin
  Result := Self.Create;
end;

constructor TC4DWizardSettingsModel.Create;
begin
  FIniFile := TIniFile.Create(TC4DWizardUtils.GetPathFileIniGeneralSettings);
  Self.ReadIniFile;
end;

destructor TC4DWizardSettingsModel.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TC4DWizardSettingsModel.ShortcutUsesOrganizationUse: Boolean;
begin
  Result := FShortcutUsesOrganizationUse;
end;

function TC4DWizardSettingsModel.ShortcutUsesOrganizationUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutUsesOrganizationUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutUsesOrganization: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutUsesOrganization);
end;

function TC4DWizardSettingsModel.ShortcutUsesOrganization(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutUsesOrganization := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutReopenFileHistoryUse: Boolean;
begin
  Result := FShortcutReopenFileHistoryUse;
end;

function TC4DWizardSettingsModel.ShortcutReopenFileHistoryUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutReopenFileHistoryUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutReopenFileHistory: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutReopenFileHistory);
end;

function TC4DWizardSettingsModel.ShortcutReopenFileHistory(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutReopenFileHistory := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutTranslateTextUse: Boolean;
begin
  Result := FShortcutTranslateTextUse;
end;

function TC4DWizardSettingsModel.ShortcutTranslateTextUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutTranslateTextUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutTranslateText: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutTranslateText);
end;

function TC4DWizardSettingsModel.ShortcutTranslateText(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutTranslateText := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutIndentUse: Boolean;
begin
  Result := FShortcutIndentUse;
end;

function TC4DWizardSettingsModel.ShortcutIndentUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutIndentUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutIndent: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutIndent);
end;

function TC4DWizardSettingsModel.ShortcutIndent(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutIndent := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutFindInFilesUse: Boolean;
begin
  Result := FShortcutFindInFilesUse;
end;

function TC4DWizardSettingsModel.ShortcutFindInFilesUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutFindInFilesUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutFindInFiles: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutFindInFiles);
end;

function TC4DWizardSettingsModel.ShortcutFindInFiles(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutFindInFiles := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutReplaceFilesUse: Boolean;
begin
  Result := FShortcutReplaceFilesUse;
end;

function TC4DWizardSettingsModel.ShortcutReplaceFilesUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutReplaceFilesUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutReplaceFiles: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutReplaceFiles);
end;

function TC4DWizardSettingsModel.ShortcutReplaceFiles(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutReplaceFiles := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutNotesUse: Boolean;
begin
  Result := FShortcutNotesUse;
end;

function TC4DWizardSettingsModel.ShortcutNotesUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutNotesUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutNotes: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutNotes);
end;

function TC4DWizardSettingsModel.ShortcutNotes(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutNotes := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutVsCodeIntegrationOpenUse: Boolean;
begin
  Result := FShortcutVsCodeIntegrationOpenUse;
end;

function TC4DWizardSettingsModel.ShortcutVsCodeIntegrationOpenUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutVsCodeIntegrationOpenUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutVsCodeIntegrationOpen);
end;

function TC4DWizardSettingsModel.ShortcutVsCodeIntegrationOpen(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutVsCodeIntegrationOpen := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutGitHubDesktopUse: Boolean;
begin
  Result := FShortcutGitHubDesktopUse;
end;

function TC4DWizardSettingsModel.ShortcutGitHubDesktopUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutGitHubDesktopUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutGitHubDesktop: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutGitHubDesktop);
end;

function TC4DWizardSettingsModel.ShortcutGitHubDesktop(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutGitHubDesktop := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProjectUse: Boolean;
begin
  Result := FShortcutDefaultFilesInOpeningProjectUse;
end;

function TC4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProjectUse(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutDefaultFilesInOpeningProjectUse := Value;
end;

function TC4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProject: string;
begin
  Result := TC4DWizardUtils.RemoveSpacesAll(FShortcutDefaultFilesInOpeningProject);
end;

function TC4DWizardSettingsModel.ShortcutDefaultFilesInOpeningProject(Value: string): IC4DWizardSettingsModel;
begin
  Result := Self;
  FShortcutDefaultFilesInOpeningProject := TC4DWizardUtils.RemoveSpacesAll(Value);
end;

function TC4DWizardSettingsModel.BlockKeyInsert: Boolean;
begin
  Result := FBlockKeyInsert;
end;

function TC4DWizardSettingsModel.BlockKeyInsert(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FBlockKeyInsert := Value;
end;

function TC4DWizardSettingsModel.BeforeCompilingCheckRunning: Boolean;
begin
  Result := FBeforeCompilingCheckRunning;
end;

function TC4DWizardSettingsModel.BeforeCompilingCheckRunning(Value: Boolean): IC4DWizardSettingsModel;
begin
  Result := Self;
  FBeforeCompilingCheckRunning := Value;
end;

function TC4DWizardSettingsModel.WriteIniFile: IC4DWizardSettingsModel;
begin
  FIniFile.WriteBool(C_SESSION, C_ShortcutUsesOrganizationUse, FShortcutUsesOrganizationUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutUsesOrganization, FShortcutUsesOrganization);
  FIniFile.WriteBool(C_SESSION, C_ShortcutReopenFileHistoryUse, FShortcutReopenFileHistoryUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutReopenFileHistory, FShortcutReopenFileHistory);
  FIniFile.WriteBool(C_SESSION, C_ShortcutTranslateTextUse, FShortcutTranslateTextUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutTranslateText, FShortcutTranslateText);
  FIniFile.WriteBool(C_SESSION, C_ShortcutIndentUse, FShortcutIndentUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutIndent, FShortcutIndent);
  FIniFile.WriteBool(C_SESSION, C_ShortcutFindInFilesUse, FShortcutFindInFilesUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutFindInFiles, FShortcutFindInFiles);
  FIniFile.WriteBool(C_SESSION, C_ShortcutReplaceFilesUse, FShortcutReplaceFilesUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutReplaceFiles, FShortcutReplaceFiles);
  FIniFile.WriteBool(C_SESSION, C_ShortcutNotesUse, FShortcutNotesUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutNotes, FShortcutNotes);
  FIniFile.WriteBool(C_SESSION, C_ShortcutVsCodeIntegrationOpenUse, FShortcutVsCodeIntegrationOpenUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutVsCodeIntegrationOpen, FShortcutVsCodeIntegrationOpen);
  FIniFile.WriteBool(C_SESSION, C_ShortcutGitHubDesktopUse, FShortcutGitHubDesktopUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutGitHubDesktop, FShortcutGitHubDesktop);
  FIniFile.WriteBool(C_SESSION, C_ShortcutDefaultFilesInOpeningProjectUse, FShortcutDefaultFilesInOpeningProjectUse);
  FIniFile.Writestring(C_SESSION, C_ShortcutDefaultFilesInOpeningProject, FShortcutDefaultFilesInOpeningProject);
  FIniFile.WriteBool(C_SESSION, C_BlockKeyInsert, FBlockKeyInsert);
  FIniFile.WriteBool(C_SESSION, C_BeforeCompilingCheckRunning, FBeforeCompilingCheckRunning);
end;

function TC4DWizardSettingsModel.ReadIniFile: IC4DWizardSettingsModel;
begin
  FShortcutUsesOrganizationUse := FIniFile.ReadBool(C_SESSION, C_ShortcutUsesOrganizationUse, True);
  FShortcutUsesOrganization := FIniFile.Readstring(C_SESSION, C_ShortcutUsesOrganization, C_ShortcutUsesOrganizationDefu);
  FShortcutReopenFileHistoryUse := FIniFile.ReadBool(C_SESSION, C_ShortcutReopenFileHistoryUse, True);
  FShortcutReopenFileHistory := FIniFile.Readstring(C_SESSION, C_ShortcutReopenFileHistory, C_ShortcutReopenFileHistoryDef);
  FShortcutTranslateTextUse := FIniFile.ReadBool(C_SESSION, C_ShortcutTranslateTextUse, True);
  FShortcutTranslateText := FIniFile.Readstring(C_SESSION, C_ShortcutTranslateText, C_ShortcutTranslateTextDefu);
  FShortcutIndentUse := FIniFile.ReadBool(C_SESSION, C_ShortcutIndentUse, True);
  FShortcutIndent := FIniFile.Readstring(C_SESSION, C_ShortcutIndent, C_ShortcutIndentDefu);
  FShortcutFindInFilesUse := FIniFile.ReadBool(C_SESSION, C_ShortcutFindInFilesUse, True);
  FShortcutFindInFiles := FIniFile.Readstring(C_SESSION, C_ShortcutFindInFiles, C_ShortcutFindInFilesDefu);
  FShortcutReplaceFilesUse := FIniFile.ReadBool(C_SESSION, C_ShortcutReplaceFilesUse, True);
  FShortcutReplaceFiles := FIniFile.Readstring(C_SESSION, C_ShortcutReplaceFiles, C_ShortcutReplaceFilesDefu);
  FShortcutNotesUse := FIniFile.ReadBool(C_SESSION, C_ShortcutNotesUse, True);
  FShortcutNotes := FIniFile.Readstring(C_SESSION, C_ShortcutNotes, C_ShortcutNotesDefu);
  FShortcutVsCodeIntegrationOpenUse := FIniFile.ReadBool(C_SESSION, C_ShortcutVsCodeIntegrationOpenUse, True);
  FShortcutVsCodeIntegrationOpen := FIniFile.Readstring(C_SESSION, C_ShortcutVsCodeIntegrationOpen, C_ShortcutVsCodeIntegrationOpenDefu);
  FShortcutGitHubDesktopUse := FIniFile.ReadBool(C_SESSION, C_ShortcutGitHubDesktopUse, False);
  FShortcutGitHubDesktop := FIniFile.Readstring(C_SESSION, C_ShortcutGitHubDesktop, C_ShortcutGitHubDesktopDefu);
  FShortcutDefaultFilesInOpeningProjectUse := FIniFile.ReadBool(C_SESSION, C_ShortcutDefaultFilesInOpeningProjectUse, False);
  FShortcutDefaultFilesInOpeningProject := FIniFile.Readstring(C_SESSION, C_ShortcutDefaultFilesInOpeningProject, C_ShortcutDefaultFilesInOpeningProjectDefu);
  FBlockKeyInsert := FIniFile.ReadBool(C_SESSION, C_BlockKeyInsert, False);
  FBeforeCompilingCheckRunning := FIniFile.ReadBool(C_SESSION, C_BeforeCompilingCheckRunning, True);
end;

initialization
  C4DWizardSettingsModel := TC4DWizardSettingsModel.New;

finalization

end.
