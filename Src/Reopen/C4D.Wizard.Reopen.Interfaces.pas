unit C4D.Wizard.Reopen.Interfaces;

interface

uses
  System.SysUtils,
  C4D.Wizard.Types;

type
  IC4DWizardReopenModel = interface
    ['{7BF9A8FC-96B1-4B2C-9A47-591163844A4C}']
    procedure WriteFilePathInIniFile(AFilePath: string;
      AFavorite: TC4DWizardFavorite;
      ANotifyEvent: TC4DWizardFileNotification = TC4DWizardFileNotification.None);
    function ReadFilePathInIniFile(AFilePath: string): TC4DWizardReopenData;
    procedure ReadIniFile(AProc: TProc<TC4DWizardReopenData>);
    function ReadIniFileIfExistGuidGroup(AGuidGroup: string): Boolean;
    procedure RemoveFilePathInIniFile(AFilePath: string);
    procedure EditDataInIniFile(AC4DWizardReopenData: TC4DWizardReopenData);
  end;

  IC4DWizardReopenController = interface
    ['{2C57A960-7801-47B2-B8CC-D4C70F29FE6E}']
    function GetC4DWizardReopenData: TC4DWizardReopenData;
    procedure OpenInGitHubDesktop;
    procedure ViewInRemoteRepository;
    procedure ViewInformationRemoteRepository;
    procedure EditInformations;
    function GetPathFolderGit: string;
  end;

implementation

end.
