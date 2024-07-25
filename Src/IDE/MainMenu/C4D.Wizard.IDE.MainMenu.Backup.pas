unit C4D.Wizard.IDE.MainMenu.Backup;

interface

uses
  System.SysUtils,
  System.Classes,
  VCL.Menus,
  C4D.Wizard.Backup.Interfaces;

type
  TC4DWizardIDEMainMenuBackup = class(TInterfacedObject, IC4DWizardIDEMainMenuBackup)
  private
    FMenuItemC4D: TMenuItem;
    FMenuItemSave: TMenuItem;
    procedure AddMenuItemSave;
    procedure AddMenuItemExport;
    procedure AddMenuItemImport;
  protected
    function Process: IC4DWizardIDEMainMenuBackup;
  public
    class function New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuBackup;
    constructor Create(AMenuItemParent: TMenuItem);
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.IDE.MainMenu.Clicks;

class function TC4DWizardIDEMainMenuBackup.New(AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuBackup;
begin
  Result := Self.Create(AMenuItemParent);
end;

constructor TC4DWizardIDEMainMenuBackup.Create(AMenuItemParent: TMenuItem);
begin
  FMenuItemC4D := AMenuItemParent;
end;

function TC4DWizardIDEMainMenuBackup.Process: IC4DWizardIDEMainMenuBackup;
begin
  Self.AddMenuItemSave;
  Self.AddMenuItemExport;
  Self.AddMenuItemImport;
end;

procedure TC4DWizardIDEMainMenuBackup.AddMenuItemSave;
begin
  FMenuItemSave := TMenuItem.Create(FMenuItemC4D);
  FMenuItemSave.Name := TC4DConsts.MENU_IDE_BACKUP_NAME;
  FMenuItemSave.Caption := TC4DConsts.MENU_IDE_BACKUP_CAPTION;
  FMenuItemSave.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexSave;
  FMenuItemC4D.Add(FMenuItemSave);
end;

procedure TC4DWizardIDEMainMenuBackup.AddMenuItemExport;
var
  LItemExport: TMenuItem;
begin
  LItemExport := TMenuItem.Create(FMenuItemSave);
  LItemExport.Name := TC4DConsts.MENU_IDE_EXPORT_NAME;
  LItemExport.Caption := TC4DConsts.MENU_IDE_EXPORT_CAPTION;
  LItemExport.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexExport;
  LItemExport.OnClick := TC4DWizardIDEMainMenuClicks.BackupExportClick;
  FMenuItemSave.Add(LItemExport);
end;

procedure TC4DWizardIDEMainMenuBackup.AddMenuItemImport;
var
  LItemImport: TMenuItem;
begin
  LItemImport := TMenuItem.Create(FMenuItemSave);
  LItemImport.Name := TC4DConsts.MENU_IDE_IMPORT_NAME;
  LItemImport.Caption := TC4DConsts.MENU_IDE_IMPORT_CAPTION;
  LItemImport.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexImport;
  LItemImport.OnClick := TC4DWizardIDEMainMenuClicks.BackupImportClick;
  FMenuItemSave.Add(LItemImport);
end;

end.
