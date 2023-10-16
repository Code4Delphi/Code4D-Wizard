unit C4D.Wizard.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  C4D.Wizard.Types;

type
  IC4DWizardUsesOrganizationParams = interface;
  IC4DWizardUsesOrganizationListOfUses = interface;

  IC4DWizardIDEMainMenu = interface
    ['{AE2F4702-14B1-42A1-A791-CEBCAAF519E1}']
    procedure CreateMenus;
  end;

  IC4DWizardOneUseForLine = interface
    ['{BAB5ACC2-7CCC-435B-A237-4730BF0B2944}']
    procedure Process;
  end;

  IC4DWizardAbout = interface
    ['{D0120219-6F60-4047-893F-23B8E7D2AFA0}']
    procedure Show;
  end;

  IC4DWizardModelFilesLoop = interface
    ['{909B7294-442D-448E-8D35-07D6DFAF29D6}']
    function Extensions(AValue: TC4DExtensionsOfFiles): IC4DWizardModelFilesLoop;
    function Escope(AValue: TC4DWizardEscope): IC4DWizardModelFilesLoop;
    function DirectoryForSearch(AValue: string): IC4DWizardModelFilesLoop;
    function IncludeSubdirectories(AValue: Boolean): IC4DWizardModelFilesLoop;
    function Cancel: IC4DWizardModelFilesLoop;
    function Canceled: Boolean;
    procedure LoopInFiles(AProc: TProc<TC4DWizardInfoFile>);
  end;

  IC4DWizardUsesOrganization = interface
    ['{8C922CAB-2D74-495B-BED8-E02B2FDA8CD1}']
    function Params: IC4DWizardUsesOrganizationParams;
    function CountAlterFiles: Integer;
    function GetGroupNameMsg: string;
    procedure UsesOrganizationInFile(AInfoFile: TC4DWizardInfoFile);
    function ResetValues: IC4DWizardUsesOrganization;
  end;

  IC4DWizardUsesOrganizationParams = interface
    ['{5B90284A-8212-427C-AF71-F29289BDB9B5}']
    function OrderUsesInAlphabeticalOrder: Boolean; overload;
    function OrderUsesInAlphabeticalOrder(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function OneUsesPerLine: Boolean; overload;
    function OneUsesPerLine(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function OneUsesLineNumColBefore: Integer; overload;
    function OneUsesLineNumColBefore(Value: Integer): IC4DWizardUsesOrganizationParams; overload;
    function MaxCharactersPerLine: Integer; overload;
    function MaxCharactersPerLine(Value: Integer): IC4DWizardUsesOrganizationParams; overload;
    function GroupUnitsByNamespaces: Boolean; overload;
    function GroupUnitsByNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function LineBreakBetweenNamespaces: Boolean; overload;
    function LineBreakBetweenNamespaces(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function UsesToRemoveList: IC4DWizardUsesOrganizationListOfUses;
    function UsesToAddList: IC4DWizardUsesOrganizationListOfUses;
    function ShowMessages: Boolean; overload;
    function ShowMessages(Value: Boolean): IC4DWizardUsesOrganizationParams; overload;
    function End_: IC4DWizardUsesOrganization;
  end;

  IC4DWizardUsesOrganizationList = interface
    ['{F311BFA0-D396-4601-A045-3717DD09879B}']
    function StringListUnit(const Value: TStringList): IC4DWizardUsesOrganizationList;
    function Kind(const Value: TC4DWizardListUsesKind): IC4DWizardUsesOrganizationList;
    function Prefix(const Value: string): IC4DWizardUsesOrganizationList;
    function Suffix(const Value: string): IC4DWizardUsesOrganizationList;
    function ImplementationIni(const AImplementationIni: Boolean): IC4DWizardUsesOrganizationList;
    function ListUsesInterface(const Value: TStringList): IC4DWizardUsesOrganizationList;
    function Text(const Value: string): IC4DWizardUsesOrganizationList; overload;
    function Text: string; overload;
    function GetTextListUses: string;
  end;

  IC4DWizardUsesOrganizationListOfUses = interface
    ['{DC5B9D38-DF5E-44D3-82EF-03F00898B417}']
    function Enabled: Boolean; overload;
    function Enabled(const Value: Boolean): IC4DWizardUsesOrganizationListOfUses; overload;
    function List: TStringList;
    function UsesStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
    function StringsFiltersStr(const Value: string): IC4DWizardUsesOrganizationListOfUses;
    function StringsFiltersList: TStringList;
    function ContainsValue(const Value: string): Boolean;
    function End_: IC4DWizardUsesOrganizationParams;
  end;

  IC4DWizardModelIniFile = interface
    ['{B4426AA0-2D30-4E52-BA21-3BDAC60EB0F9}']
    function Write(const AComponent: TCheckBox): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TRadioGroup): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TEdit): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TComboBox; const AMaxItemsSave: Integer = 40): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TCheckBox; AValueDefault: Boolean): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TRadioGroup; AValueDefault: Integer): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TEdit; AValueDefault: string): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TComboBox; AValueDefault: string): IC4DWizardModelIniFile; overload;
  end;

  IC4DWizardSettingsModel = interface
    ['{0D5EE063-B22C-4578-90C0-5A3B731D0644}']
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
  end;

  IC4DWizardIndent = interface
    ['{15D5EFAE-958A-450F-8E20-BBB0D82DE64A}']
    procedure ProcessBlockSelected;
  end;

implementation

end.
