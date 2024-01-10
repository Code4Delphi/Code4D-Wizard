unit C4D.Wizard.Backup.Export.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Zip,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls;

type
  TC4DWizardBackupExportView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnExport: TButton;
    Panel9: TPanel;
    lbFolderForExport: TLabel;
    edtFolderDefault: TEdit;
    btnFindFolder: TButton;
    Bevel1: TBevel;
    lbProgressFile: TLabel;
    lbProgressBarGeneral: TLabel;
    lbPorcentFile: TLabel;
    lbPorcentGeneral: TLabel;
    ProgressBarFile: TProgressBar;
    ProgressBarGeneral: TProgressBar;
    ckOpenFolderAfterExport: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnFindFolderClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FListPathFilesForExports: TList<string>;
    FBytesAllFiles: Cardinal;
    FBytesProcessor: Cardinal;
    function GetSizeFile(const AFilePath: string): Integer;
    function GetSizeAllFile: Integer;
    procedure OnProgress(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
    procedure FillListPathFilesForExports;
    procedure ReadConfigurationScreen;
    procedure WriteConfigurationScreen;
    function GetFileNameForExport: string;
  public

  end;

var
  C4DWizardBackupExportView: TC4DWizardBackupExportView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils.ListOfFilesInFolder;

{$R *.dfm}


procedure TC4DWizardBackupExportView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardBackupExportView, Self);
  FListPathFilesForExports := TList<string>.Create;
  Self.FillListPathFilesForExports;
end;

procedure TC4DWizardBackupExportView.FormDestroy(Sender: TObject);
begin
  FListPathFilesForExports.Free;
end;

procedure TC4DWizardBackupExportView.FormShow(Sender: TObject);
begin
  Self.ReadConfigurationScreen;
end;

procedure TC4DWizardBackupExportView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(Shift = [])then
      if(btnClose.Enabled)then
        btnClose.Click;
  end;
end;

procedure TC4DWizardBackupExportView.FillListPathFilesForExports;
var
  LListFiles: TStrings;
  LNameFile: string;
begin
  FListPathFilesForExports.Clear;

  LListFiles := TStringList.Create;
  try
    TC4DWizardUtilsListOfFilesInFolder.New
      .FolderPath(TC4DWizardUtils.GetPathFolderRoot)
      .IncludeSubdirectories(False)
      .ExtensionsOfFiles(TC4DConsts.EXTENSIONS_PERMITTED_BACKUP_EXPORT)
      .GetListOfFiles(LListFiles);

    for LNameFile in LListFiles do
      FListPathFilesForExports.Add(LNameFile);
  finally
    LListFiles.Free;
  end;
end;

procedure TC4DWizardBackupExportView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(edtFolderDefault)
    .Write(ckOpenFolderAfterExport);
end;

procedure TC4DWizardBackupExportView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(edtFolderDefault, '')
    .Read(ckOpenFolderAfterExport, True);
end;

function TC4DWizardBackupExportView.GetSizeFile(const AFilePath: string): Integer;
var
  LFileStream: TFileStream;
begin
  LFileStream := TFileStream.Create(AFilePath, fmOpenRead);
  try
    Result := LFileStream.Size;
  finally
    LFileStream.Free;
  end;
end;

function TC4DWizardBackupExportView.GetSizeAllFile: Integer;
var
  LFile: string;
begin
  Result := 0;
  for LFile in FListPathFilesForExports do
    Result := Result + Self.GetSizeFile(LFile);
end;

procedure TC4DWizardBackupExportView.OnProgress(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
var
  LPorcentFile: Real;
  LPorcentGeneral: Real;
begin
  Application.ProcessMessages;
  LPorcentFile := Position / Header.UncompressedSize * 100;
  LPorcentGeneral := (FBytesProcessor + Position) / FBytesAllFiles * 100;
  lbPorcentFile.Caption := FormatFloat('#.## %', LPorcentFile);
  lbPorcentGeneral.Caption := FormatFloat('#.## %', LPorcentGeneral);
  ProgressBarFile.Position := Trunc(LPorcentFile);
  ProgressBarGeneral.Position := Trunc(LPorcentGeneral);
end;

procedure TC4DWizardBackupExportView.btnFindFolderClick(Sender: TObject);
begin
  edtFolderDefault.Text := TC4DWizardUtils.SelectFolder(edtFolderDefault.Text);
end;

procedure TC4DWizardBackupExportView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

function TC4DWizardBackupExportView.GetFileNameForExport: string;
var
  LSaveDialog: TSaveDialog;
begin
  Result := '';
  LSaveDialog := TSaveDialog.Create(nil);
  try
    LSaveDialog.DefaultExt := 'zip';
    LSaveDialog.Filter := 'Arquivo ZIP|*.zip';
    LSaveDialog.InitialDir := edtFolderDefault.Text;
    LSaveDialog.FileName := Format('C4DWizard-Configs-%s.zip', [FormatDateTime('yyyy-mm-dd-hhnnss', Now)]);
    if(not LSaveDialog.Execute)then
      Abort;

    Result := LSaveDialog.FileName;
  finally
    LSaveDialog.Free;
  end;
end;

procedure TC4DWizardBackupExportView.btnExportClick(Sender: TObject);
var
  LZipFile: TZipFile;
  LFile: string;
  LFileName: string;
begin
  LFileName := Self.GetFileNameForExport;
  if(LFileName.IsEmpty)then
    Exit;

  if(FListPathFilesForExports.Count <= 0)then
    TC4DWizardUtils.ShowMsgErrorAndAbort('No files were found to be exported');

  btnExport.Enabled := False;
  btnClose.Enabled := False;
  FBytesProcessor := 0;
  FBytesAllFiles := Self.GetSizeAllFile;
  LZipFile := TZipFile.Create;
  try
    LZipFile.Open(LFileName, zmWrite);
    LZipFile.OnProgress := Self.OnProgress;

    for LFile in FListPathFilesForExports do
    begin
      LZipFile.Add(LFile);
      FBytesProcessor := FBytesProcessor + LZipFile.FileInfo[Pred(LZipFile.FileCount)].UncompressedSize;
    end;

    TC4DWizardUtils.ShowV('Export completed');

    if(DirectoryExists(ExtractFileDir(LFileName)))then
      edtFolderDefault.Text := ExtractFileDir(LFileName);
    Self.WriteConfigurationScreen;

    if(ckOpenFolderAfterExport.Checked)then
      TC4DWizardUtils.OpenFile(LFileName);
  finally
    btnExport.Enabled := True;
    btnClose.Enabled := True;
    LZipFile.Free;
  end;
end;

end.
