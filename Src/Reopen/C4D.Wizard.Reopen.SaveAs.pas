unit C4D.Wizard.Reopen.SaveAs;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Types,
  C4D.Wizard.LogFIle;

type
  TC4DWizardReopenSaveAs = class(TNotifierObject, IOTAModuleNotifier)
  private
    FIOTAModule: IOTAModule;
    FNotifierIndex: Integer;
    FFileNameOld: string;
  protected
    procedure ModuleRenamed(const NewName: string);
    function CheckOverwrite: Boolean;
  public
    class function New(AFileName: string): IOTAModuleNotifier;
    constructor Create(AFileName: string);
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Reopen.Model,
  C4D.Wizard.Reopen.Interfaces;

class function TC4DWizardReopenSaveAs.New(AFileName: string): IOTAModuleNotifier;
begin
  Result := Self.Create(AFileName);
end;

constructor TC4DWizardReopenSaveAs.Create(AFileName: string);
begin
  inherited Create;
  FIOTAModule := TC4DWizardUtilsOTA.GetModule(AFileName);
  FFileNameOld := FIOTAModule.FileName;
  FNotifierIndex := FIOTAModule.AddNotifier(Self);
end;

destructor TC4DWizardReopenSaveAs.Destroy;
begin
  if(FNotifierIndex >= 0)then
    FIOTAModule.RemoveNotifier(FNotifierIndex);

  inherited Destroy;
end;

function TC4DWizardReopenSaveAs.CheckOverwrite: Boolean;
begin
  Result := True;
end;

procedure TC4DWizardReopenSaveAs.ModuleRenamed(const NewName: string);
var
  LC4DWizardReopenModel: IC4DWizardReopenModel;
  LC4DWizardReopenData: TC4DWizardReopenData;
begin
  try
    LC4DWizardReopenModel := TC4DWizardReopenModel.New;
    LC4DWizardReopenData := LC4DWizardReopenModel.ReadFilePathInIniFile(FFileNameOld);
    if(LC4DWizardReopenData.FilePath.Trim.IsEmpty)then
      Exit;

    LC4DWizardReopenModel.RemoveFilePathInIniFile(FFileNameOld);
    LC4DWizardReopenModel.WriteFilePathInIniFile(NewName, TC4DWizardFavorite.None);
    LC4DWizardReopenData.FilePath := NewName;
    LC4DWizardReopenData.Name := ExtractFileName(NewName);
    LC4DWizardReopenModel.EditDataInIniFile(LC4DWizardReopenData);
  finally
    FFileNameOld := NewName;
  end;
end;

end.
