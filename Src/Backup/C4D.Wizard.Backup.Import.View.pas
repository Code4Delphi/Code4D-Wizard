unit C4D.Wizard.Backup.Import.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Zip,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TC4DWizardBackupImportView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnRestore: TButton;
    Panel9: TPanel;
    lbFolder: TLabel;
    Bevel1: TBevel;
    edtFolder: TEdit;
    btnFindFolder: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
    procedure btnFindFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FNameFileZip: string;
    FPathFolderTempExtract: string;
    FImportGeneralSettings: Boolean;
    FImportDefaultFilesInOpeningProject: Boolean;
    FImportOpenExternalPath: Boolean;
    FImportReopenFileHistory: Boolean;
    FImportGroups: Boolean;
    FRecarregarMainMenuIDE: Boolean;
    procedure Clear;
    procedure GetFileNameZipForImport;
    procedure ExtractAllFiles;
    procedure GetPathFolderTempExtract;
    procedure ReadConfigurationScreen;
    procedure WriteConfigurationScreen;
    procedure ProcessSelectFilesForImport;
    procedure ProcessImportGeneralSettings;
    procedure ProcessImportDefaultFilesInOpeningProject;
    procedure ProcessImportOpenExternalPath;
    procedure ProcessImportReopenFileHistory;
    procedure ProcessImportGroups;
    procedure ProcessImportImages;
    procedure DeleteFolderTemp;
  public

  end;

var
  C4DWizardBackupImportView: TC4DWizardBackupImportView;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Backup.Import.SelectFiles.View,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.Types,
  C4D.Wizard.IDE.MainMenu,
  C4D.Wizard.Utils.ListOfFilesInFolder;

{$R *.dfm}


procedure TC4DWizardBackupImportView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if(FRecarregarMainMenuIDE)then
    TC4DWizardIDEMainMenu.GetInstance.CreateMenus;
end;

procedure TC4DWizardBackupImportView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardBackupImportView, Self);
end;

procedure TC4DWizardBackupImportView.FormShow(Sender: TObject);
begin
  FRecarregarMainMenuIDE := False;
  Self.ReadConfigurationScreen;
end;

procedure TC4DWizardBackupImportView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardBackupImportView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(edtFolder);
end;

procedure TC4DWizardBackupImportView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(edtFolder, '');
end;

procedure TC4DWizardBackupImportView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardBackupImportView.btnFindFolderClick(Sender: TObject);
begin
  edtFolder.Text := TC4DWizardUtils.SelectFolder(edtFolder.Text);
end;

procedure TC4DWizardBackupImportView.GetFileNameZipForImport;
var
  LOpenDialog: TOpenDialog;
begin
  LOpenDialog := TOpenDialog.Create(nil);
  try
    LOpenDialog.DefaultExt := 'zip';
    LOpenDialog.Filter := 'File ZIP|*.zip';
    LOpenDialog.InitialDir := edtFolder.Text;
    LOpenDialog.FileName := '';
    if(not LOpenDialog.Execute)then
      Abort;
    FNameFileZip := LOpenDialog.FileName;
  finally
    LOpenDialog.Free;
  end;
end;

procedure TC4DWizardBackupImportView.GetPathFolderTempExtract;
begin
  FPathFolderTempExtract := Format('%s%s%s',
    [IncludeTrailingPathDelimiter(TC4DWizardUtils.CreateIfNecessaryAndGetPathFolderTemp),
    'Restore-Configs-',
    FormatDateTime('yyyy-mm-dd-hhnnss', Now)]);

  if(DirectoryExists(FPathFolderTempExtract))then
    TC4DWizardUtils.DirectoryDelete(FPathFolderTempExtract);

  ForceDirectories(FPathFolderTempExtract);
  FPathFolderTempExtract := IncludeTrailingPathDelimiter(FPathFolderTempExtract);
end;

procedure TC4DWizardBackupImportView.ExtractAllFiles;
var
  LZipFile: TZipFile;
begin
  if(not FileExists(FNameFileZip))then
    TC4DWizardUtils.ShowMsgErrorAndAbort('File not found for extract: ' + FNameFileZip);

  try
    LZipFile := TZipFile.Create;
    try
      LZipFile.Open(FNameFileZip, zmReadWrite);
      LZipFile.ExtractAll(FPathFolderTempExtract);
      LZipFile.Close;
    finally
      LZipFile.Free;
    end;
  except
    on E: exception do
      TC4DWizardUtils.ShowMsgErrorAndAbort('It was not possible to extract the files: ' + E.Message);
  end;
end;

procedure TC4DWizardBackupImportView.ProcessSelectFilesForImport;
var
  LView: TC4DWizardBackupImportSelectFilesView;
begin
  C4DWizardBackupImportSelectFilesView := TC4DWizardBackupImportSelectFilesView.Create(nil);
  LView := C4DWizardBackupImportSelectFilesView;
  try
    LView.ckGeneralSettings.Enabled := FileExists(FPathFolderTempExtract + TC4DConsts.FILE_INI_GENERAL_SETTINGS);
    LView.ckDefaultFilesInOpeningProject.Enabled := FileExists(FPathFolderTempExtract + TC4DConsts.FILE_INI_DEFAULT_FILES_IN_OPENING_PROJECT);
    LView.ckOpenExternalPath.Enabled := FileExists(FPathFolderTempExtract + TC4DConsts.FILE_INI_OPEN_EXTERNAL);
    LView.ckReopenFileHistory.Enabled := FileExists(FPathFolderTempExtract + TC4DConsts.FILE_INI_REOPEN);
    LView.ckGroups.Enabled := FileExists(FPathFolderTempExtract + TC4DConsts.FILE_INI_GROUPS);

    if(LView.ShowModal <> mrOk)then
      Abort;

    FImportGeneralSettings := LView.ckGeneralSettings.Checked;
    FImportDefaultFilesInOpeningProject := LView.ckDefaultFilesInOpeningProject.Checked;
    FImportOpenExternalPath := LView.ckOpenExternalPath.Checked;
    FImportReopenFileHistory := LView.ckReopenFileHistory.Checked;
    FImportGroups := LView.ckGroups.Checked;
  finally
    LView.Free;
  end;
end;

procedure TC4DWizardBackupImportView.ProcessImportGeneralSettings;
var
  LPathCurrentFile: string;
  LPathNewFile: string;
begin
  if(not FImportGeneralSettings)then
    Exit;

  LPathNewFile := FPathFolderTempExtract + TC4DConsts.FILE_INI_GENERAL_SETTINGS;
  if(not FileExists(LPathNewFile))then
  begin
    TC4DWizardUtils.ShowMsg('File not found: '+ LPathNewFile);
    Exit;
  end;

  LPathCurrentFile := TC4DWizardUtils.GetPathFileIniGeneralSettings;
  if(FileExists(LPathCurrentFile))then
    System.SysUtils.DeleteFile(LPathCurrentFile);

  if(not TC4DWizardUtils.DirectoryOrFileMove(LPathNewFile, LPathCurrentFile))then
    TC4DWizardUtils.ShowMsg('File For General Settings not restored');
end;

procedure TC4DWizardBackupImportView.ProcessImportDefaultFilesInOpeningProject;
var
  LPathCurrentFile: string;
  LPathNewFile: string;
begin
  if(not FImportDefaultFilesInOpeningProject)then
    Exit;

  LPathNewFile := FPathFolderTempExtract + TC4DConsts.FILE_INI_DEFAULT_FILES_IN_OPENING_PROJECT;
  if(not FileExists(LPathNewFile))then
  begin
    TC4DWizardUtils.ShowMsg('File not found: '+ LPathNewFile);
    Exit;
  end;

  LPathCurrentFile := TC4DWizardUtils.GetPathFileIniDefaultFilesInOpeningProject;
  if(FileExists(LPathCurrentFile))then
    System.SysUtils.DeleteFile(LPathCurrentFile);

  if(not TC4DWizardUtils.DirectoryOrFileMove(LPathNewFile, LPathCurrentFile))then
    TC4DWizardUtils.ShowMsg('File For Default Files In Opening Project not restored');
end;

procedure TC4DWizardBackupImportView.ProcessImportOpenExternalPath;
var
  LPathCurrentFile: string;
  LPathNewFile: string;
begin
  if(not FImportOpenExternalPath)then
    Exit;

  LPathNewFile := FPathFolderTempExtract + TC4DConsts.FILE_INI_OPEN_EXTERNAL;
  if(not FileExists(LPathNewFile))then
  begin
    TC4DWizardUtils.ShowMsg('File not found: '+ LPathNewFile);
    Exit;
  end;

  LPathCurrentFile := TC4DWizardUtils.GetPathFileIniOpenExternal;
  if(FileExists(LPathCurrentFile))then
    System.SysUtils.DeleteFile(LPathCurrentFile);

  if(not TC4DWizardUtils.DirectoryOrFileMove(LPathNewFile, LPathCurrentFile))then
    TC4DWizardUtils.ShowMsg('File For Open External not restored');
end;

procedure TC4DWizardBackupImportView.ProcessImportReopenFileHistory;
var
  LPathCurrentFile: string;
  LPathNewFile: string;
begin
  if(not FImportReopenFileHistory)then
    Exit;

  LPathNewFile := FPathFolderTempExtract + TC4DConsts.FILE_INI_REOPEN;
  if(not FileExists(LPathNewFile))then
  begin
    TC4DWizardUtils.ShowMsg('File not found: '+ LPathNewFile);
    Exit;
  end;

  LPathCurrentFile := TC4DWizardUtils.GetPathFileIniReopen;
  if(FileExists(LPathCurrentFile))then
    System.SysUtils.DeleteFile(LPathCurrentFile);

  if(not TC4DWizardUtils.DirectoryOrFileMove(LPathNewFile, LPathCurrentFile))then
    TC4DWizardUtils.ShowMsg('File For Reopen file history not restored');
end;

procedure TC4DWizardBackupImportView.ProcessImportGroups;
var
  LPathCurrentFile: string;
  LPathNewFile: string;
begin
  if(not FImportGroups)then
    Exit;

  LPathNewFile := FPathFolderTempExtract + TC4DConsts.FILE_INI_GROUPS;
  if(not FileExists(LPathNewFile))then
  begin
    TC4DWizardUtils.ShowMsg('File not found: '+ LPathNewFile);
    Exit;
  end;

  LPathCurrentFile := TC4DWizardUtils.GetPathFileIniGroups;
  if(FileExists(LPathCurrentFile))then
    System.SysUtils.DeleteFile(LPathCurrentFile);

  if(not TC4DWizardUtils.DirectoryOrFileMove(LPathNewFile, LPathCurrentFile))then
    TC4DWizardUtils.ShowMsg('File For Groups not restored');
end;

procedure TC4DWizardBackupImportView.ProcessImportImages;
var
  LListFiles: TStrings;
  LNameFileOrigin: string;
  LPathFileDestiny: string;
begin
  LListFiles := TStringList.Create;
  try
    TC4DWizardUtilsListOfFilesInFolder.New
      .FolderPath(FPathFolderTempExtract)
      .IncludeSubdirectories(False)
      .ExtensionsOfFiles([TC4DExtensionsFiles.BMP])
      .GetListOfFiles(LListFiles);

    for LNameFileOrigin in LListFiles do
    begin
      LPathFileDestiny := TC4DWizardUtils.GetPathFolderRoot + ExtractFileName(LNameFileOrigin);
      if(FileExists(LPathFileDestiny))then
        System.SysUtils.DeleteFile(LPathFileDestiny);

      if(not TC4DWizardUtils.DirectoryOrFileMove(LNameFileOrigin, LPathFileDestiny))then
        TC4DWizardUtils.ShowMsg('Image not restored: ' + LNameFileOrigin);
    end;
  finally
    LListFiles.Free;
  end;
end;

procedure TC4DWizardBackupImportView.DeleteFolderTemp;
begin
  if(not FPathFolderTempExtract.IsEmpty)and(DirectoryExists(FPathFolderTempExtract))then
    TC4DWizardUtils.DirectoryDelete(FPathFolderTempExtract);
end;

procedure TC4DWizardBackupImportView.Clear;
begin
  FNameFileZip := '';
  FPathFolderTempExtract := '';
  FImportGeneralSettings := False;
  FImportDefaultFilesInOpeningProject := False;
  FImportOpenExternalPath := False;
  FImportReopenFileHistory := False;
  FImportGroups := False;
end;

procedure TC4DWizardBackupImportView.btnRestoreClick(Sender: TObject);
begin
  btnRestore.Enabled := False;
  btnClose.Enabled := False;
  try
    Self.GetFileNameZipForImport;
    Self.GetPathFolderTempExtract;
    Self.ExtractAllFiles;
    Self.ProcessSelectFilesForImport;
    Self.ProcessImportGeneralSettings;
    Self.ProcessImportDefaultFilesInOpeningProject;
    Self.ProcessImportOpenExternalPath;
    Self.ProcessImportImages;
    Self.ProcessImportReopenFileHistory;
    Self.ProcessImportGroups;
    TC4DWizardUtils.ShowV('Restore finished');
    Self.WriteConfigurationScreen;
  finally
    btnRestore.Enabled := True;
    btnClose.Enabled := True;
    FRecarregarMainMenuIDE := True;
    Self.DeleteFolderTemp;
    Self.Clear;
  end;
end;

end.
