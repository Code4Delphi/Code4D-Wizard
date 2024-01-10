unit C4D.Wizard.Groups.Model;

interface

uses
  System.SysUtils,
  System.IniFiles,
  System.Classes,
  C4D.Wizard.Consts,
  C4D.Wizard.Groups.Interfaces,
  C4D.Wizard.Groups;

type
  TC4DWizardGroupsModel = class(TInterfacedObject, IC4DWizardGroupsModel)
  private
    function GetIniFile: TIniFile;
    procedure CreateIniFileWithGroupsFixed(var AIniFile: TIniFile);
    procedure WriteDefaultFalseInIniFile;
  protected
    procedure WriteInIniFile(AC4DWizardGroups: TC4DWizardGroups);
    function ReadGuidInIniFile(AGuid: string): TC4DWizardGroups;
    procedure ReadIniFile(AProc: TProc<TC4DWizardGroups>);
    procedure RemoveGuidInIniFile(AGuid: string);
  public
    class function New: IC4DWizardGroupsModel;
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Reopen.Model;

class function TC4DWizardGroupsModel.New: IC4DWizardGroupsModel;
begin
  Result := Self.Create;
end;

function TC4DWizardGroupsModel.GetIniFile: TIniFile;
var
  LPathIniFile: string;
begin
  LPathIniFile := TC4DWizardUtils.GetPathFileIniGroups;
  Result := TIniFile.Create(LPathIniFile);
  if(not FileExists(LPathIniFile))then
    Self.CreateIniFileWithGroupsFixed(Result);
end;

procedure TC4DWizardGroupsModel.CreateIniFileWithGroupsFixed(var AIniFile: TIniFile);
begin
  AIniFile.Writestring(TC4DConsts.GROUPS_GUID_ALL, TC4DConsts.GROUPS_INI_Name, '- Show ALL');
  AIniFile.WriteBool(TC4DConsts.GROUPS_GUID_ALL, TC4DConsts.GROUPS_INI_FixedSystem, True);
  AIniFile.WriteBool(TC4DConsts.GROUPS_GUID_ALL, TC4DConsts.GROUPS_INI_DefaultGroup, True);

  AIniFile.Writestring(TC4DConsts.GROUPS_GUID_NO_GROUP, TC4DConsts.GROUPS_INI_Name, '- No group');
  AIniFile.WriteBool(TC4DConsts.GROUPS_GUID_NO_GROUP, TC4DConsts.GROUPS_INI_FixedSystem, True);
  AIniFile.WriteBool(TC4DConsts.GROUPS_GUID_NO_GROUP, TC4DConsts.GROUPS_INI_DefaultGroup, False);
end;

procedure TC4DWizardGroupsModel.WriteInIniFile(AC4DWizardGroups: TC4DWizardGroups);
var
  LIniFile: TIniFile;
begin
  if(AC4DWizardGroups.Guid.Trim.IsEmpty)or(AC4DWizardGroups.Name.Trim.IsEmpty)then
    Exit;

  if(AC4DWizardGroups.DefaultGroup)then
    Self.WriteDefaultFalseInIniFile;

  LIniFile := Self.GetIniFile;
  try
    LIniFile.Writestring(AC4DWizardGroups.Guid, TC4DConsts.GROUPS_INI_Name, AC4DWizardGroups.Name);
    LIniFile.WriteBool(AC4DWizardGroups.Guid, TC4DConsts.GROUPS_INI_FixedSystem, AC4DWizardGroups.FixedSystem);
    LIniFile.WriteBool(AC4DWizardGroups.Guid, TC4DConsts.GROUPS_INI_DefaultGroup, AC4DWizardGroups.DefaultGroup);
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardGroupsModel.WriteDefaultFalseInIniFile;
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
begin
  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        if(LIniFile.ReadBool(LSessaoStr, TC4DConsts.GROUPS_INI_DefaultGroup, False))then
          LIniFile.WriteBool(LSessaoStr, TC4DConsts.GROUPS_INI_DefaultGroup, False);
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

function TC4DWizardGroupsModel.ReadGuidInIniFile(AGuid: string): TC4DWizardGroups;
var
  LIniFile: TIniFile;
begin
  Result := nil;
  if(AGuid.Trim.IsEmpty)then
    Exit;

  LIniFile := Self.GetIniFile;
  try
    Result.Guid := AGuid;
    Result.Name := LIniFile.Readstring(AGuid, TC4DConsts.GROUPS_INI_Name, '');
    Result.FixedSystem := LIniFile.ReadBool(AGuid, TC4DConsts.GROUPS_INI_FixedSystem, False);
    Result.DefaultGroup := LIniFile.ReadBool(AGuid, TC4DConsts.GROUPS_INI_DefaultGroup, False);
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardGroupsModel.ReadIniFile(AProc: TProc<TC4DWizardGroups>);
var
  LIniFile: TIniFile;
  LSections: TStrings;
  LSessaoStr: string;
  i: Integer;
  LC4DWizardGroups: TC4DWizardGroups;
begin
  LIniFile := Self.GetIniFile;
  try
    LSections := TStringList.Create;
    try
      LIniFile.ReadSections(LSections);
      for i := 0 to Pred(LSections.Count) do
      begin
        LSessaoStr := LSections[i];
        LC4DWizardGroups := TC4DWizardGroups.Create;
        try
          LC4DWizardGroups.Guid := LSessaoStr;
          LC4DWizardGroups.Name := LIniFile.Readstring(LSessaoStr, TC4DConsts.GROUPS_INI_Name, '');
          LC4DWizardGroups.FixedSystem := LIniFile.ReadBool(LSessaoStr, TC4DConsts.GROUPS_INI_FixedSystem, False);
          LC4DWizardGroups.DefaultGroup := LIniFile.ReadBool(LSessaoStr, TC4DConsts.GROUPS_INI_DefaultGroup, False);
          AProc(LC4DWizardGroups);
        finally
          LC4DWizardGroups.Free;
        end;
      end;
    finally
      LSections.Free;
    end;
  finally
    LIniFile.Free;
  end;
end;

procedure TC4DWizardGroupsModel.RemoveGuidInIniFile(AGuid: string);
var
  LIniFile: TIniFile;
begin
  if(AGuid.Trim.ToUpper = TC4DConsts.GROUPS_GUID_ALL)or(AGuid.Trim.ToUpper = TC4DConsts.GROUPS_GUID_NO_GROUP)then
    Exit;

  if(TC4DWizardReopenModel.New.ReadIniFileIfExistGuidGroup(AGuid))then
    TC4DWizardUtils.ShowMsgAndAbort('This group cannot be deleted, as it is linked to a register of Reopen.');

  LIniFile := Self.GetIniFile;
  try
    LIniFile.EraseSection(AGuid);
  finally
    LIniFile.Free;
  end;
end;

end.
