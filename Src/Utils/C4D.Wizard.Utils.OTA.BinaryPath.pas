unit C4D.Wizard.Utils.OTA.BinaryPath;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Variants,
  Winapi.Windows,
  ToolsAPI,
  Vcl.Forms;

type
  IC4DWizardUtilsOTABinaryPath = interface
    ['{C644F013-A9CC-49BF-9DA8-9748D94C7539}']
    function GetBinaryPathOfProject(AIOTAProject: IOTAProject): string;
  end;

  TC4DWizardUtilsOTABinaryPath = class(TInterfacedObject, IC4DWizardUtilsOTABinaryPath)
  private
    FIOTAProject: IOTAProject;
    FOutName: string;
    procedure ExploreExe;
  protected
    function GetBinaryPathOfProject(AIOTAProject: IOTAProject): string;
  public
    class function New: IC4DWizardUtilsOTABinaryPath;
    constructor Create;
  end;

implementation

uses
  C4D.Wizard.Utils.CnWizard;

class function TC4DWizardUtilsOTABinaryPath.New: IC4DWizardUtilsOTABinaryPath;
begin
  Result := Self.Create;
end;

constructor TC4DWizardUtilsOTABinaryPath.Create;
begin
  //
end;

function TC4DWizardUtilsOTABinaryPath.GetBinaryPathOfProject(AIOTAProject: IOTAProject): string;
begin
  Result := '';
  FOutName := '';
  FIOTAProject := AIOTAProject;
  Self.ExploreExe;
  Result := FOutName;
end;

{$DEFINE DELPHIXE_UP}

procedure TC4DWizardUtilsOTABinaryPath.ExploreExe;
var
  LDir, LProjectFileName: string;
  {$IFNDEF DELPHIXE_UP}
  LOutExt, LIntermediaDir: string;
  LVal: Variant;
  {$ENDIF}
begin
  if not Assigned(FIOTAProject) then
    Exit;

  LProjectFileName := FIOTAProject.GetFileName;
  if(LProjectFileName.Trim.IsEmpty)then
    Exit;

  LDir := CnOtaGetProjectOutputDirectory(FIOTAProject);
  if(LDir.Trim.IsEmpty)then
    Exit;

  {$IFDEF DELPHIXE_UP}
  if CnOtaGetActiveProjectOptions <> nil then
    FOutName := CnOtaGetActiveProjectOptions.TargetName;
  {$ELSE}
  try
    if CnOtaGetActiveProjectOption('GenPackage', LVal) and LVal then
      LOutExt := '.bpl';
  except
    ;
  end;

  try
    if (LOutExt = '') and CnOtaGetActiveProjectOption('GenStaticLibrary', LVal) and LVal then
      LOutExt := '.lib';
  except
    ;
  end;

  try
    if (LOutExt = '') and CnOtaGetActiveProjectOption('GenDll', LVal) and LVal then
      LOutExt := '.dll';
  except
    ;
  end;

  if LOutExt = '' then
    LOutExt := '.exe';

  {$IFDEF IDE_CONF_MANAGER}
  if not IsDelphiRuntime then
  begin
    {$IFDEF BDS2009_UP}
    if CnOtaGetActiveProjectOptionsConfigurations <> nil then
    begin
      if CnOtaGetActiveProjectOptionsConfigurations.GetActiveConfiguration <> nil then
      begin
        LIntermediaDir := MakePath(CnOtaGetActiveProjectOptionsConfigurations.GetActiveConfiguration.GetName);
      end;
    end;
    {$ELSE}
    try
      if CnOtaGetActiveProjectOption('UnitOutputDir', LVal) then
        LIntermediaDir := MakePath(VarToStr(LVal));
    except
      ;
    end;
    {$ENDIF}
  end;
  {$ENDIF}
  FOutName := MakePath(LDir) + LIntermediaDir + _CnChangeFileExt(_CnExtractFileName(LProjectFileName), LOutExt);
  {$ENDIF}
end;

end.
