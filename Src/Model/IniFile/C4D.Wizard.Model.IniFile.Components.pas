unit C4D.Wizard.Model.IniFile.Components;

interface

uses
  System.IniFiles,
  System.SysUtils,
  System.Classes,
  Vcl.ExtCtrls,
  Vcl.StdCtrls,
  C4D.Wizard.Interfaces;

type
  TC4DWizardModelIniFileComponents = class(TInterfacedObject, IC4DWizardModelIniFile)
  private
    FIniFile: TIniFile;
    FSection: string;
    function GetIniFile: TIniFile;
  protected
    function Write(const AComponent: TCheckBox): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TRadioGroup): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TEdit): IC4DWizardModelIniFile; overload;
    function Write(const AComponent: TComboBox; const AMaxItemsSave: Integer = 40): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TCheckBox; AValueDefault: Boolean): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TRadioGroup; AValueDefault: Integer): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TEdit; AValueDefault: string): IC4DWizardModelIniFile; overload;
    function Read(var AComponent: TComboBox; AValueDefault: string): IC4DWizardModelIniFile; overload;
  public
    class function New(ASectionName: string): IC4DWizardModelIniFile;
    constructor Create(ASectionName: string);
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Utils;

const
  C_COMBOBOX_SEPARATOR_TEXT = '<br/>;';

class function TC4DWizardModelIniFileComponents.New(ASectionName: string): IC4DWizardModelIniFile;
begin
  Result := Self.Create(ASectionName);
end;

constructor TC4DWizardModelIniFileComponents.Create(ASectionName: string);
begin
  FIniFile := Self.GetIniFile;
  FSection := ASectionName
end;

destructor TC4DWizardModelIniFileComponents.Destroy;
begin
  FIniFile.Free;
  inherited;
end;

function TC4DWizardModelIniFileComponents.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniGeneralSettings);
end;

function TC4DWizardModelIniFileComponents.Write(const AComponent: TCheckBox): IC4DWizardModelIniFile;
begin
  Result := Self;
  FIniFile.WriteBool(FSection, AComponent.Name, AComponent.Checked);
end;

function TC4DWizardModelIniFileComponents.Write(const AComponent: TRadioGroup): IC4DWizardModelIniFile;
begin
  Result := Self;
  FIniFile.WriteInteger(FSection, AComponent.Name, AComponent.ItemIndex);
end;

function TC4DWizardModelIniFileComponents.Write(const AComponent: TEdit): IC4DWizardModelIniFile;
begin
  Result := Self;
  FIniFile.Writestring(FSection, AComponent.Name, AComponent.Text);
end;

function TC4DWizardModelIniFileComponents.Write(const AComponent: TComboBox; const AMaxItemsSave: Integer = 40): IC4DWizardModelIniFile;
var
  LComboBox: TComboBox;
  LItem: string;
  LStrWrite: string;
  LNumItemsSave: Integer;
  LFirstItem: string;
begin
  Result := Self;
  if(AComponent = nil)then
    Exit;

  LComboBox := AComponent;
  if(LComboBox.Items.Count < 0)then
    Exit;

  LFirstItem := '';
  LNumItemsSave := 0;
  LStrWrite := '';
  if(LComboBox.Text <> '')then
  begin
    LStrWrite := LComboBox.Text + C_COMBOBOX_SEPARATOR_TEXT;
    LFirstItem := LComboBox.Text;
    Inc(LNumItemsSave);
  end;

  for LItem in LComboBox.Items do
  begin
    if(LNumItemsSave = AMaxItemsSave)then
      Break;

    if(LItem = LFirstItem)then
      Continue;

    LStrWrite := LStrWrite + LItem + C_COMBOBOX_SEPARATOR_TEXT;
    Inc(LNumItemsSave);
    if(LFirstItem.Trim.IsEmpty)then
      LFirstItem := LItem;
  end;

  FIniFile.Writestring(FSection, AComponent.Name, LStrWrite);
end;

function TC4DWizardModelIniFileComponents.Read(var AComponent: TCheckBox; AValueDefault: Boolean): IC4DWizardModelIniFile;
begin
  Result := Self;
  AComponent.Checked := FIniFile.ReadBool(FSection, AComponent.Name, AValueDefault);
end;

function TC4DWizardModelIniFileComponents.Read(var AComponent: TRadioGroup; AValueDefault: Integer): IC4DWizardModelIniFile;
begin
  Result := Self;
  AComponent.ItemIndex := FIniFile.ReadInteger(FSection, AComponent.Name, AValueDefault);
end;

function TC4DWizardModelIniFileComponents.Read(var AComponent: TEdit; AValueDefault: string): IC4DWizardModelIniFile;
begin
  Result := Self;
  AComponent.Text := FIniFile.Readstring(FSection, AComponent.Name, AValueDefault);
end;

function TC4DWizardModelIniFileComponents.Read(var AComponent: TComboBox; AValueDefault: string): IC4DWizardModelIniFile;
var
  LComboBox: TComboBox;
  LTextInFileIni: string;
  LStrings: TStrings;
  LItem: string;
  LItemExisting: string;
begin
  Result := Self;
  if(AComponent = nil)then
    Exit;

  LComboBox := AComponent;
  LTextInFileIni := FIniFile.Readstring(FSection, LComboBox.Name, AValueDefault);
  if(LTextInFileIni.IsEmpty)then
    Exit;

  LItemExisting := '';
  if(LComboBox.Items.Count >= 0)then
    LItemExisting := LComboBox.Items[0];

  LStrings := TStringList.Create;
  try
    TC4DWizardUtils.ExplodeList(LTextInFileIni, C_COMBOBOX_SEPARATOR_TEXT, LStrings);
    for LItem in LStrings do
    begin
      if(LItem <> LItemExisting)then
        LComboBox.Items.Add(LItem);
    end;
  finally
    LStrings.Free;
  end;
end;

end.
