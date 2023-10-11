unit C4D.Wizard.Find.Interfaces;

interface

uses
  C4D.Wizard.Types;

type
  IC4DWizardFindModel = interface
    ['{CE4BE3EA-48D9-4270-BE7A-C34402D75944}']
    function ResetValues: IC4DWizardFindModel;
    function WholeWordOnly(AValue: Boolean): IC4DWizardFindModel;
    function DisplayAccountant(AValue: Boolean): IC4DWizardFindModel;
    function CaseSensitive(AValue: Boolean): IC4DWizardFindModel;
    function SearchFor(AValue: string): IC4DWizardFindModel;
    function TextIgnoreEscope(AValue: TC4DTextIgnoreEscope): IC4DWizardFindModel;
    function TextIgnore(AValue: string): IC4DWizardFindModel;
    function GetCountFind: Integer;
    function GetCountArqFind: Integer;
    function GetCountError: Integer;
    function GetGroupNameMsg: string;
    procedure FindInFile(AInfoFile: TC4DWizardInfoFile);
  end;

implementation

end.
