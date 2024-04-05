unit C4D.Wizard.OpenExternal.Interfaces;

interface

uses
  System.SysUtils,
  C4D.Wizard.OpenExternal;

type
  IC4DWizardIDEMainMenuOpenExternal = interface
    ['{E9642ED4-94B4-4E17-94AA-6B869E4D285C}']
    function CreateMenusOpenExternal: IC4DWizardIDEMainMenuOpenExternal;
  end;

  IC4DWizardOpenExternalModel = interface
    ['{08D4836C-F789-4228-8773-D9A1DC15AB57}']
    function WriteInIniFile(AC4DWizardOpenExternal: TC4DWizardOpenExternal): IC4DWizardOpenExternalModel;
    function SaveIconInFolder(const AGuid, APathIcon: string): IC4DWizardOpenExternalModel;
    //function ReadGuidInIniFile(AGuid: string): TC4DWizardOpenExternal;
    procedure ReadIniFile(AProc: TProc<TC4DWizardOpenExternal>);
    function ExistGuidInIniFile(const AGuid: string): Boolean;
    procedure RemoveGuidInIniFile(const AGuid: string);
  end;

implementation

end.
