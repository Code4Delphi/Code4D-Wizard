unit C4D.Wizard.Git.Utils;

interface

uses
  System.Sysutils,
  System.IniFiles;

type
  TC4DWizardGitUtils = class
  private
  public
    class procedure OpenInGitHubDesktop(const AFolderGit: String);
    class function GetLinkRemoteRepository(const AFolderGit: String): String;
    class procedure ViewInRemoteRepository(const AFolderGit: String);
    class procedure ViewInformationRemoteRepository(const AFolderGit: String);
    class function GetNameCurrentBranchInGit(const AFolderGit: String): String;
  end;

implementation

uses
  C4D.Wizard.ProcessDelphi,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils;

class procedure TC4DWizardGitUtils.OpenInGitHubDesktop(const AFolderGit: String);
var
 LFolderGit: String;
begin
   LFolderGit := IncludeTrailingPathDelimiter(AFolderGit.Replace(TC4DConsts.C_NAME_FOLDER_GIT, EmptyStr));
   TC4DWizardProcessDelphi.RunCommand(['github ' + LFolderGit]);
end;

class function TC4DWizardGitUtils.GetLinkRemoteRepository(const AFolderGit: String): String;
var
 LIniFile: TIniFile;
begin
   LIniFile := TIniFile.Create(AFolderGit + 'config');
   try
     Result := LIniFile.ReadString('remote "origin"', 'url', EmptyStr);
   finally
     LIniFile.Free;
   end;
end;

class procedure TC4DWizardGitUtils.ViewInRemoteRepository(const AFolderGit: String);
var
 LUrlRemote: String;
begin
   LUrlRemote := Self.GetLinkRemoteRepository(AFolderGit);
   LUrlRemote := LUrlRemote.Replace('.git', EmptyStr);
   if(not LUrlRemote.Trim.IsEmpty)then
     TC4DWizardUtils.OpenLink(LUrlRemote);
end;

class procedure TC4DWizardGitUtils.ViewInformationRemoteRepository(const AFolderGit: String);
var
 LUrlRemote: String;
 LTextFile: TextFile;
 LLineText: String;
 LBranch: String;
begin
   LUrlRemote := Self.GetLinkRemoteRepository(AFolderGit);
   LUrlRemote := LUrlRemote.Replace('.git', EmptyStr);

   AssignFile(LTextFile, AFolderGit + 'HEAD');
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

class function TC4DWizardGitUtils.GetNameCurrentBranchInGit(const AFolderGit: String): String;
var
 LTextFile: TextFile;
 LLineText: String;
 LBranch: String;
begin
   Result := '';
   AssignFile(LTextFile, AFolderGit + 'HEAD');
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
