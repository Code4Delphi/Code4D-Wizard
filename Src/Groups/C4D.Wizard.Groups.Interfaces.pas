unit C4D.Wizard.Groups.Interfaces;

interface

uses
  System.SysUtils,
  C4D.Wizard.Groups;

type
  IC4DWizardGroupsModel = interface
    ['{08D4836C-F789-4228-8773-D9A1DC15AB57}']
    procedure WriteInIniFile(AC4DWizardGroups: TC4DWizardGroups);
    function ReadGuidInIniFile(AGuid: string): TC4DWizardGroups;
    procedure ReadIniFile(AProc: TProc<TC4DWizardGroups>);
    procedure RemoveGuidInIniFile(AGuid: string);
  end;

implementation

end.
