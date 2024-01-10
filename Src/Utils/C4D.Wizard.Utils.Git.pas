unit C4D.Wizard.Utils.Git;

interface

uses
  System.Sysutils,
  System.IniFiles;

type
  TC4DWizardUtilsGit = class
  private
  public
    class function GetPathFolderGitConfig(const AFolderGit: string): string;
    class procedure OpenInGitHubDesktop(const AFolderGit: string);
    class function GetLinkRemoteRepository(const AFolderGit: string): string;
    class procedure ViewInRemoteRepository(const AFolderGit: string);
    class procedure ViewInformationRemoteRepository(const AFolderGit: string);
    class function GetNameCurrentBranchInGit(const AFolderGit: string): string;
  end;

implementation

uses
  C4D.Wizard.ProcessDelphi,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils;

class function TC4DWizardUtilsGit.GetPathFolderGitConfig(const AFolderGit: string): string;
begin
  Result := AFolderGit.Trim;
  if(Result.IsEmpty)then
    Exit;

  Result := IncludeTrailingPathDelimiter(Result);
  Result := Result.Replace(TC4DConsts.NAME_FOLDER_GIT, EmptyStr);
  Result := Result + TC4DConsts.NAME_FOLDER_GIT;
  Result := IncludeTrailingPathDelimiter(Result);
  if(not DirectoryExists(Result))then
    Result := '';
end;

class procedure TC4DWizardUtilsGit.OpenInGitHubDesktop(const AFolderGit: string);
var
  LFolderGit: string;
begin
  LFolderGit := IncludeTrailingPathDelimiter(AFolderGit.Replace(TC4DConsts.NAME_FOLDER_GIT, EmptyStr));
  TC4DWizardProcessDelphi.RunCommand(['github ' + LFolderGit]);
end;

class function TC4DWizardUtilsGit.GetLinkRemoteRepository(const AFolderGit: string): string;
var
  LFolderGit: string;
  LIniFile: TIniFile;
begin
  LFolderGit := Self.GetPathFolderGitConfig(AFolderGit);
  if(LFolderGit.IsEmpty)then
    Exit;

  LIniFile := TIniFile.Create(LFolderGit + 'config');
  try
    Result := LIniFile.Readstring('remote "origin"', 'url', EmptyStr);
  finally
    LIniFile.Free;
  end;
end;

class procedure TC4DWizardUtilsGit.ViewInRemoteRepository(const AFolderGit: string);
var
  LFolderGit: string;
  LUrlRemote: string;
begin
  LFolderGit := Self.GetPathFolderGitConfig(AFolderGit);
  if(LFolderGit.IsEmpty)then
    Exit;

  LUrlRemote := Self.GetLinkRemoteRepository(LFolderGit);
  LUrlRemote := LUrlRemote.Replace('.git', EmptyStr);
  if(not LUrlRemote.Trim.IsEmpty)then
    TC4DWizardUtils.OpenLink(LUrlRemote);
end;

class procedure TC4DWizardUtilsGit.ViewInformationRemoteRepository(const AFolderGit: string);
var
  LFolderGit: string;
  LUrlRemote: string;
  LTextFile: TextFile;
  LLineText: string;
  LBranch: string;
begin
  LFolderGit := Self.GetPathFolderGitConfig(AFolderGit);
  if(LFolderGit.IsEmpty)then
    Exit;

  LUrlRemote := Self.GetLinkRemoteRepository(LFolderGit);
  LUrlRemote := LUrlRemote.Replace('.git', EmptyStr);

  AssignFile(LTextFile, LFolderGit + 'HEAD');
  try
    Reset(LTextFile);
    ReadLn(LTextFile, LLineText);
  finally
    CloseFile(LTextFile);
  end;

  LBranch := '';
  if(not LLineText.Trim.IsEmpty)then
    LBranch := StringReplace(LLineText, 'ref: refs/heads/', '', [rfIgnoreCase, rfReplaceAll]);

  TC4DWizardUtils.ShowMsg(Format('%s %s Current Branch: %s', [LUrlRemote, sLineBreak, LBranch]));
end;

class function TC4DWizardUtilsGit.GetNameCurrentBranchInGit(const AFolderGit: string): string;
var
  LFolderGit: string;
  LTextFile: TextFile;
  LLineText: string;
begin
  Result := '';

  LFolderGit := Self.GetPathFolderGitConfig(AFolderGit);
  if(LFolderGit.IsEmpty)then
    Exit;

  AssignFile(LTextFile, LFolderGit + 'HEAD');
  try
    Reset(LTextFile);
    ReadLn(LTextFile, LLineText);
  finally
    CloseFile(LTextFile);
  end;

  if(not LLineText.Trim.IsEmpty)then
    Result := StringReplace(LLineText, 'ref: refs/heads/', '', [rfIgnoreCase, rfReplaceAll]);
end;

end.
