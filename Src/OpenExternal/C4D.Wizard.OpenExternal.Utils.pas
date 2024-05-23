unit C4D.Wizard.OpenExternal.Utils;

interface

uses
  System.Sysutils,
  C4D.Wizard.OpenExternal,
  C4D.Wizard.Utils;

type
  TC4DWizardOpenExternalUtils = class
  private
  public
    class procedure ClickFromString(const AStringClick: String);
    class function GetImageIndexIfExists(const AC4DWizardOpenExternal: TC4DWizardOpenExternal;
      const AGetImgEmptyIfNotImg: Boolean = False): Integer;
    class function ProcessTags(const AText: string): string;
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Types,
  C4D.Wizard.ProcessDelphi,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.Reopen.Controller;

class procedure TC4DWizardOpenExternalUtils.ClickFromString(const AStringClick: String);
var
  LStringClick: string;
  LSeparator: string;
  LLink: string;
  LParameters: string;
begin
  LStringClick := AStringClick;
  LSeparator := TC4DConsts.OPEN_EXTERNAL_Separator_PARAMETERS;
  if(LStringClick.Trim.Replace(LSeparator, '').IsEmpty)then
    Exit;

  LLink := Copy(LStringClick, 1, pos(LSeparator, LStringClick) - 1);
  LParameters := Copy(LStringClick, (pos(LSeparator, LStringClick) + LSeparator.Length), LStringClick.Length);
  if(LLink = TC4DWizardOpenExternalKind.CMD.ToString)then
    TC4DWizardProcessDelphi.RunCommand(TC4DWizardOpenExternalUtils.ProcessTags(LParameters))
  else
    TC4DWizardUtils.ShellExecuteC4D(TC4DWizardOpenExternalUtils.ProcessTags(LLink),
      TC4DWizardOpenExternalUtils.ProcessTags(LParameters));
end;

class function TC4DWizardOpenExternalUtils.GetImageIndexIfExists(const AC4DWizardOpenExternal: TC4DWizardOpenExternal;
  const AGetImgEmptyIfNotImg: Boolean = False): Integer;
var
  LFilePath: string;
begin
  Result := -1;
  if(AGetImgEmptyIfNotImg)then
    Result := TC4DWizardIDEImageListMain.GetInstance.ImgIndexEmpty;

  if(not AC4DWizardOpenExternal.IconHas)then
    Exit;

  LFilePath := TC4DWizardUtils.GetPathImageOpenExternal(AC4DWizardOpenExternal.Guid);
  if(not FileExists(LFilePath))then
    Exit;

  Result := TC4DWizardUtilsOTA.AddImgIDEFilePath(LFilePath);
end;

class function TC4DWizardOpenExternalUtils.ProcessTags(const AText: string): string;
var
  LBlockTextSelect: string;
  LProjectFileName: string;
  LFolderGit: string;
begin
  Result := AText;

  if(Result.ToUpper.Contains(TC4DConsts.TAG_BLOCK_TEXT_SELECT.ToUpper))then
  begin
    LBlockTextSelect := TC4DWizardUtilsOTA.GetBlockTextSelect;
    Result := StringReplace(Result, TC4DConsts.TAG_BLOCK_TEXT_SELECT, LBlockTextSelect, [rfReplaceAll, rfIgnoreCase]);
  end;

  if(Result.ToUpper.Contains(TC4DConsts.TAG_FOLDER_GIT.ToUpper))then
  begin
    LFolderGit := '';
    LProjectFileName := TC4DWizardUtilsOTA.GetCurrentProjectFileName;
    if(not LProjectFileName.IsEmpty)then
    begin
      LFolderGit := TC4DWizardReopenController.New(LProjectFileName).GetPathFolderGit;
      LFolderGit := IncludeTrailingPathDelimiter(LFolderGit.Replace(TC4DConsts.NAME_FOLDER_GIT, EmptyStr));
    end;
    Result := StringReplace(Result, TC4DConsts.TAG_FOLDER_GIT, LFolderGit, [rfReplaceAll, rfIgnoreCase]);
  end;

  if(Result.ToUpper.Contains(TC4DConsts.TAG_FILE_PATH_BINARY.ToUpper))then
    Result := StringReplace(Result,
                            TC4DConsts.TAG_FILE_PATH_BINARY,
                            TC4DWizardUtilsOTA.GetBinaryPathCurrent,
                            [rfReplaceAll, rfIgnoreCase]);
end;

end.
