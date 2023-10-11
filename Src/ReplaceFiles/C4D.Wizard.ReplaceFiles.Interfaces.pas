unit C4D.Wizard.ReplaceFiles.Interfaces;

interface

uses
  C4D.Wizard.Types;

type
  IC4DWizardReplaceFilesModel = interface
    ['{CE4BE3EA-48D9-4270-BE7A-C34402D75944}']
    function ResetValues: IC4DWizardReplaceFilesModel;
    function WholeWordOnly(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function DisplayAccountant(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function CaseSensitive(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function ShowMessages(AValue: Boolean): IC4DWizardReplaceFilesModel;
    function SearchFor(AValue: string): IC4DWizardReplaceFilesModel;
    function ReplaceBy(AValue: string): IC4DWizardReplaceFilesModel;
    function GetCountReplace: Integer;
    function GetCountArqReplace: Integer;
    function GetCountError: Integer;
    function GetGroupNameMsg: string;
    procedure ReplaceInFile(AInfoFile: TC4DWizardInfoFile);
  end;

implementation

end.
