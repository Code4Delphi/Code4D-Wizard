unit C4D.Wizard.LogFile;

interface

uses
  System.SysUtils,
  System.IOUtils;

type
  TC4DWizardLogFile = class
  private
    FDir: string;
  public
    constructor Create;
    function SetDir(const ADir: string): TC4DWizardLogFile;
    function GetDir: string;
    function AddLog(AStrLog: string): TC4DWizardLogFile;
  end;

var
  LogFile: TC4DWizardLogFile;

implementation

uses
  C4D.Wizard.Utils;

const
  C_NAME_PATH_LOG = 'Logs';

constructor TC4DWizardLogFile.Create;
begin
  Self.SetDir(IncludeTrailingPathDelimiter(TC4DWizardUtils.GetPathFolderRoot + C_NAME_PATH_LOG));
end;

function TC4DWizardLogFile.SetDir(const ADir: string): TC4DWizardLogFile;
begin
  Result := Self;
  if not DirectoryExists(ADir)then
    ForceDirectories(ADir);
  FDir := ADir;
end;

function TC4DWizardLogFile.GetDir: string;
begin
  Result := FDir;
end;

function TC4DWizardLogFile.AddLog(AStrLog: string): TC4DWizardLogFile;
var
  LFilename: string;
  LTextFile: TextFile;
  LStrLog: string;
begin
  Result := Self;
  if(FDir.Trim.IsEmpty)then
    raise Exception.Create('Diretório para geração do log não informado: ' + FDir);

  LFilename := TPath.Combine(FDir, 'log_' + FormatDateTime('yyyy-mm-dd', Now()) + '.log');

  LStrLog := '[' + DateTimeToStr(Now) + '] ' + AStrLog;
  LStrLog := TC4DWizardUtils.RemoveAccentsSwapSymbols(LStrLog);
  AssignFile(LTextFile, LFilename);
  if(FileExists(LFilename))then
    Append(LTextFile)
  else
    Rewrite(LTextFile);
  try
    WriteLn(LTextFile, LStrLog);
  finally
    CloseFile(LTextFile);
  end;
end;

initialization
  LogFile := TC4DWizardLogFile.Create;

finalization
  if(Assigned(LogFile))then
    FreeAndNil(LogFile);

end.
