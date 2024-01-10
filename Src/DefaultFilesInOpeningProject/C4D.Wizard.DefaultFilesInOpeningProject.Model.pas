unit C4D.Wizard.DefaultFilesInOpeningProject.Model;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  C4D.Wizard.DefaultFilesInOpeningProject.Interfaces,
  C4D.Wizard.Consts;

type
  TC4DWizardDefaultFilesInOpeningProjectModel = class(TInterfacedObject, IC4DWizardDefaultFilesInOpeningProjectModel)
  private
    function GetIniFile: TIniFile;
  protected
    procedure WriteInIniFile(const AFilePathProject: string; const AListFilePathDefault: string);
    function ReadInIniFile(const AFilePathProject: string): string;
    procedure RemoveInIniFile(const AFilePathProject: string);
  public
    class function New: IC4DWizardDefaultFilesInOpeningProjectModel;
  end;

implementation

uses
  C4D.Wizard.Utils;

class function TC4DWizardDefaultFilesInOpeningProjectModel.New: IC4DWizardDefaultFilesInOpeningProjectModel;
begin
  Result := Self.Create;
end;

function TC4DWizardDefaultFilesInOpeningProjectModel.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniDefaultFilesInOpeningProject);
end;

procedure TC4DWizardDefaultFilesInOpeningProjectModel.WriteInIniFile(const AFilePathProject: string;
  const AListFilePathDefault: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := Self.GetIniFile;
  try
    LIniFile.Writestring(AFilePathProject,
      TC4DConsts.DEFAULT_FILES_IN_OPENING_PROJECT_INI_ListFilePathDefault,
      AListFilePathDefault);
  finally
    LIniFile.Free;
  end;
end;

function TC4DWizardDefaultFilesInOpeningProjectModel.ReadInIniFile(const AFilePathProject: string): string;
var
  LIniFile: TIniFile;
begin
  if(AFilePathProject.Trim.IsEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    Result := LIniFile.Readstring(AFilePathProject,
      TC4DConsts.DEFAULT_FILES_IN_OPENING_PROJECT_INI_ListFilePathDefault,
      '');
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardDefaultFilesInOpeningProjectModel.RemoveInIniFile(const AFilePathProject: string);
var
  LIniFile: TIniFile;
begin
  LIniFile := Self.GetIniFile;
  try
    LIniFile.EraseSection(AFilePathProject);
  finally
    LIniFile.Free;
  end;
end;

end.
