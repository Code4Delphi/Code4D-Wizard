unit C4D.Wizard.DefaultFilesInOpeningProject.Interfaces;

interface

uses
  System.SysUtils,
  System.Classes;

type
  IC4DWizardDefaultFilesInOpeningProject = interface
    ['{0710FBFE-F205-4F60-ADE2-D1BBDE3678F6}']
    procedure OpenFilesOfProject;
    procedure GetListFilesPathsDefaults(Astrings: TStrings);
    procedure SelectionFilesForDefaultOpening;
  end;

  IC4DWizardDefaultFilesInOpeningProjectModel = interface
    ['{FAC72037-7F08-454F-9F16-98978F2C46BE}']
    procedure WriteInIniFile(const AFilePathProject: string; const AListFilePathDefault: string);
    function ReadInIniFile(const AFilePathProject: string): string;
    procedure RemoveInIniFile(const AFilePathProject: string);
  end;

implementation

end.
