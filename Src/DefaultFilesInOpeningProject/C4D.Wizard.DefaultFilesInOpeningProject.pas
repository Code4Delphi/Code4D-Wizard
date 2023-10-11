unit C4D.Wizard.DefaultFilesInOpeningProject;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Controls,
  C4D.Wizard.DefaultFilesInOpeningProject.Interfaces,
  C4D.Wizard.DefaultFilesInOpeningProject.Model,
  C4D.Wizard.View.ListFilesForSelection;

type
  TC4DWizardDefaultFilesInOpeningProject = class(TInterfacedObject, IC4DWizardDefaultFilesInOpeningProject)
  private
    FFilePathProjectOrGroup: string;
    FModel: IC4DWizardDefaultFilesInOpeningProjectModel;
  protected
    procedure OpenFilesOfProject;
    procedure GetListFilesPathsDefaults(Astrings: TStrings);
    procedure SelectionFilesForDefaultOpening;
  public
    class function New(const AFilePathProjectOrGroup: string): IC4DWizardDefaultFilesInOpeningProject;
    constructor Create(const AFilePathProjectOrGroup: string);
  end;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

class function TC4DWizardDefaultFilesInOpeningProject.New(const AFilePathProjectOrGroup: string): IC4DWizardDefaultFilesInOpeningProject;
begin
  Result := Self.Create(AFilePathProjectOrGroup);
end;

constructor TC4DWizardDefaultFilesInOpeningProject.Create(const AFilePathProjectOrGroup: string);
begin
  FFilePathProjectOrGroup := AFilePathProjectOrGroup;
  FModel := TC4DWizardDefaultFilesInOpeningProjectModel.New;
end;

procedure TC4DWizardDefaultFilesInOpeningProject.OpenFilesOfProject;
var
  LStrings: TStrings;
  LItem: string;
begin
  //TC4DWizardUtilsOTA.CloseFilesOpened([TC4DExtensionsFiles.pas]);
  LStrings := TStringList.Create;
  try
    Self.GetListFilesPathsDefaults(LStrings);
    if(LStrings.Count < 0)then
      Exit;

    for LItem in LStrings do
    begin
      if(LItem.Trim.IsEmpty)then
        Continue;

      //LAbsolutePath := TC4DWizardUtils.PathRelativeToAbsolute(LItem, ExtractFileDir(FFilePathProjectOrGroup));
      TC4DWizardUtilsOTA.OpenFilePathInIDE(LItem);
    end;
  finally
    LStrings.Free;
  end;
end;

procedure TC4DWizardDefaultFilesInOpeningProject.GetListFilesPathsDefaults(Astrings: TStrings);
var
  LListFilesPathsDefaults: string;
  i: Integer;
  LAbsolutePath: string;
begin
  Astrings.Clear;
  LListFilesPathsDefaults := FModel.ReadInIniFile(FFilePathProjectOrGroup).Trim;
  if(LListFilesPathsDefaults.IsEmpty)then
    Exit;

  TC4DWizardUtils.ExplodeList(LListFilesPathsDefaults, ';', Astrings);
  for i := 0 to Pred(Astrings.Count)do
  begin
    if(Astrings[i].Trim.IsEmpty)then
      Continue;

    LAbsolutePath := TC4DWizardUtils.PathRelativeToAbsolute(Astrings[i], ExtractFileDir(FFilePathProjectOrGroup));
    Astrings[i] := LAbsolutePath;
  end;
end;

procedure TC4DWizardDefaultFilesInOpeningProject.SelectionFilesForDefaultOpening;
var
  LC4DWizardViewListFilesForSelection: TC4DWizardViewListFilesForSelection;
  LListFilesPathsDefaults: TStrings;
  LPathListInStr: string;
begin
  LC4DWizardViewListFilesForSelection := TC4DWizardViewListFilesForSelection.Create(nil);
  try
    LListFilesPathsDefaults := TStringList.Create;
    try
      Self.GetListFilesPathsDefaults(LListFilesPathsDefaults);

      LC4DWizardViewListFilesForSelection.FilePathProjectOrGroupForFilter := FFilePathProjectOrGroup;
      LC4DWizardViewListFilesForSelection.ListFilesPathsDefaults := LListFilesPathsDefaults;
      if(LC4DWizardViewListFilesForSelection.ShowModal <> mrOK)then
        Exit;
    finally
      LListFilesPathsDefaults.Free;
    end;

    LPathListInStr := LC4DWizardViewListFilesForSelection.GetPathListInstring(';');
  finally
    LC4DWizardViewListFilesForSelection.Free;
  end;

  FModel.WriteInIniFile(FFilePathProjectOrGroup, LPathListInStr);;
end;

end.
