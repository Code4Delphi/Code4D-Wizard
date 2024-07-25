unit C4D.Wizard.OpenExternal.Model;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  C4D.Wizard.Consts,
  C4D.Wizard.OpenExternal.Interfaces,
  C4D.Wizard.OpenExternal;

type
  TC4DWizardOpenExternalModel = class(TInterfacedObject, IC4DWizardOpenExternalModel)
  private
    function GetIniFile: TIniFile;
  protected
    function WriteInIniFile(AC4DWizardOpenExternal: TC4DWizardOpenExternal): IC4DWizardOpenExternalModel;
    function SaveIconInFolder(const AGuid, APathIcon: string): IC4DWizardOpenExternalModel;
    //function ReadGuidInIniFile(AGuid: string): TC4DWizardOpenExternal;
    procedure ReadIniFile(AProc: TProc<TC4DWizardOpenExternal>);
    function ExistGuidInIniFile(const AGuid: string): Boolean;
    procedure RemoveGuidInIniFile(const AGuid: string);
  public
    class function New: IC4DWizardOpenExternalModel;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Types;

class function TC4DWizardOpenExternalModel.New: IC4DWizardOpenExternalModel;
begin
  Result := Self.Create;
end;

function TC4DWizardOpenExternalModel.GetIniFile: TIniFile;
var
  LPathIniFile: string;
begin
  LPathIniFile := TC4DWizardUtils.GetPathFileIniOpenExternal;
  Result := TIniFile.Create(LPathIniFile);
end;

function TC4DWizardOpenExternalModel.WriteInIniFile(AC4DWizardOpenExternal: TC4DWizardOpenExternal): IC4DWizardOpenExternalModel;
var
  LIniFile: TIniFile;
begin
  Result := Self;
  if(AC4DWizardOpenExternal.Guid.Trim.IsEmpty)or(AC4DWizardOpenExternal.Description.Trim.IsEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Description, AC4DWizardOpenExternal.Description);
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Path, AC4DWizardOpenExternal.Path);
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Parameters, AC4DWizardOpenExternal.Parameters);
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Kind, AC4DWizardOpenExternal.Kind.ToString);
    LIniFile.WriteBool(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Visible, AC4DWizardOpenExternal.Visible);
    LIniFile.WriteBool(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_VisibleInToolBarUtilities, AC4DWizardOpenExternal.VisibleInToolBarUtilities);
    LIniFile.WriteInteger(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Order, AC4DWizardOpenExternal.Order);
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_Shortcut, AC4DWizardOpenExternal.Shortcut);
    LIniFile.WriteBool(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_IconHas, AC4DWizardOpenExternal.IconHas);
    LIniFile.Writestring(AC4DWizardOpenExternal.Guid, TC4DConsts.OPEN_EXTERNAL_INI_GuidMenuMaster, AC4DWizardOpenExternal.GuidMenuMaster);
  finally
    LIniFile.Free;
  end;
end;

function TC4DWizardOpenExternalModel.SaveIconInFolder(const AGuid, APathIcon: string): IC4DWizardOpenExternalModel;
var
  LFileNameToSave: string;
begin
  Result := Self;

  if(AGuid.Trim.IsEmpty)then
    Exit;

  if(not FileExists(APathIcon))then
    Exit;

  LFileNameToSave := TC4DWizardUtils.GetPathFolderRoot +
    TC4DConsts.OPEN_EXTERNAL_INI_PREFIX_IMG +
    TC4DWizardUtils.GuidToFileName(AGuid, ExtractFileExt(APathIcon));

  TC4DWizardUtils.FileCopy(APathIcon, LFileNameToSave);
end;

function TC4DWizardOpenExternalModel.ExistGuidInIniFile(const AGuid: string): Boolean;
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
  LGuid: string;
begin
  Result := False;

  if(AGuid.Trim.ISEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        LGuid := LIniFile.Readstring(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_GuidMenuMaster, '');
        if(LGuid = AGuid)then
          Exit(True);
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

{function TC4DWizardOpenExternalModel.ReadGuidInIniFile(AGuid: string): TC4DWizardOpenExternal;
var
  LIniFile: TIniFile;
begin
  Result := nil;
  if(AGuid.Trim.IsEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    Result.Guid := AGuid;
    Result.Description := LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Description, '');
    Result.Path := LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Path, '');
    Result.Parameters := LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Parameters, '');
    Result.Kind := TC4DWizardUtils.StrToOpenExternalKind(LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Kind, ''));
    Result.Visible := LIniFile.ReadBool(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Visible, True);
    Result.VisibleInToolBarUtilities := LIniFile.ReadBool(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_VisibleInToolBarUtilities, False);
    Result.Order := LIniFile.ReadInteger(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Order, 0);
    Result.Shortcut := LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_Shortcut, '');
    Result.IconHas := LIniFile.ReadBool(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_IconHas, False);
    Result.GuidMenuMaster := LIniFile.ReadString(AGuid, TC4DConsts.OPEN_EXTERNAL_INI_GuidMenuMaster, '');
  finally
    LIniFile.Free;
  end;
end; }

procedure TC4DWizardOpenExternalModel.ReadIniFile(AProc: TProc<TC4DWizardOpenExternal>);
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
  LC4DWizardOpenExternal: TC4DWizardOpenExternal;
begin
  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        LC4DWizardOpenExternal := TC4DWizardOpenExternal.Create;
        try
          LC4DWizardOpenExternal.Guid := LSessaoStr;
          LC4DWizardOpenExternal.Description := LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Description, '');
          LC4DWizardOpenExternal.Path := LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Path, '');
          LC4DWizardOpenExternal.Parameters := LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Parameters, '');
          LC4DWizardOpenExternal.Kind := TC4DWizardUtils.StrToOpenExternalKind(LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Kind, ''));
          LC4DWizardOpenExternal.Visible := LIniFile.ReadBool(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Visible, True);
          LC4DWizardOpenExternal.VisibleInToolBarUtilities := LIniFile.ReadBool(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_VisibleInToolBarUtilities, False);
          LC4DWizardOpenExternal.Order := LIniFile.ReadInteger(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Order, 0);
          LC4DWizardOpenExternal.Shortcut := LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_Shortcut, '');
          LC4DWizardOpenExternal.IconHas := LIniFile.ReadBool(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_IconHas, False);
          LC4DWizardOpenExternal.GuidMenuMaster := LIniFile.ReadString(LSessaoStr, TC4DConsts.OPEN_EXTERNAL_INI_GuidMenuMaster, '');
          AProc(LC4DWizardOpenExternal);
        finally
          LC4DWizardOpenExternal.Free;
        end;
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardOpenExternalModel.RemoveGuidInIniFile(const AGuid: string);
var
  LIniFile: TIniFile;
begin
  if(AGuid.Trim.IsEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    LIniFile.EraseSection(AGuid);
  finally
    LIniFile.Free;
  end;
end;

end.
