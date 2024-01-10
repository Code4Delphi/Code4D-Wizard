unit C4D.Wizard.IDE.FileNotification.Notifier;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  C4D.Wizard.Types,
  C4D.Wizard.Consts;

type
  TC4DWizardIDEFileNotificationNotifier = class(TNotifierObject, IOTANotifier, IOTAIDENotifier)
  private
    FNotifyCode: TOTAFileNotification;
    FFileName: string;
    FExtension: string;
    procedure ProcessToolBarsBranch;
    procedure ProcessToolBarsBuild;
    procedure ProcessToolBarsUtilities;
    procedure ProcessReopen;
    procedure ProcessReopenSaveAs;
    procedure ProcessDefaultFilesInOpeningProject;
    class function New: IOTAIDENotifier;
  protected
    procedure FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
    procedure BeforeCompile(const Project: IOTAProject; var Cancel: Boolean); overload;
    procedure AfterCompile(Succeeded: Boolean); overload;
  public
  end;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Reopen.Model,
  C4D.Wizard.Reopen.SaveAs,
  C4D.Wizard.IDE.ToolBars.Branch,
  C4D.Wizard.IDE.ToolBars.Build,
  C4D.Wizard.IDE.ToolBars.Utilities,
  C4D.Wizard.DefaultFilesInOpeningProject;

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
    IndexNotifier := TC4DWizardUtilsOTA.GetIOTAServices.AddNotifier(TC4DWizardIDEFileNotificationNotifier.New);
end;

class function TC4DWizardIDEFileNotificationNotifier.New: IOTAIDENotifier;
begin
  Result := Self.Create;
end;

procedure TC4DWizardIDEFileNotificationNotifier.AfterCompile(Succeeded: Boolean);
begin

end;

procedure TC4DWizardIDEFileNotificationNotifier.BeforeCompile(const Project: IOTAProject; var Cancel: Boolean);
begin
  Cancel := False;
end;

procedure TC4DWizardIDEFileNotificationNotifier.FileNotification(NotifyCode: TOTAFileNotification; const FileName: string; var Cancel: Boolean);
begin
  Cancel := False;
  FNotifyCode := NotifyCode;
  FFileName := FileName;
  FExtension := ExtractFileExt(FFileName.ToLower);

  Self.ProcessReopen;
  Self.ProcessDefaultFilesInOpeningProject;
  Self.ProcessReopenSaveAs;
  Self.ProcessToolBarsBranch;
  Self.ProcessToolBarsBuild;
  Self.ProcessToolBarsUtilities;
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessReopen;
var
  LC4DWizardFileNotification: TC4DWizardFileNotification;
begin
  if(not(FNotifyCode in [ofnFileOpened, ofnFileClosing]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  LC4DWizardFileNotification := TC4DWizardUtilsOTA.OTAFileNotificationToC4DWizardFileNotification(FNotifyCode);
  TC4DWizardReopenModel.New.WriteFilePathInIniFile(FFileName, TC4DWizardFavorite.None, LC4DWizardFileNotification);
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessDefaultFilesInOpeningProject;
begin
  if(not(FNotifyCode in [ofnFileOpened]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  if(FExtension = '.groupproj')then
  begin
    if(FFileName.Contains('Embarcadero'))then
    begin
      if(FFileName.Contains(TC4DConsts.C4D_PROJECT_GROUP1))
        or(FFileName.Contains('Project1.dproj'))
        or(FFileName.Contains('Package1.dproj'))
      then
        Exit;
    end;
  end;

  TThread.CreateAnonymousThread(
    procedure
    begin
      TThread.Sleep(100);
      TThread.Synchronize(TThread.CurrenTThread,
        procedure
        begin
          TC4DWizardDefaultFilesInOpeningProject.New(FFileName).OpenFilesOfProject;
        end);
    end).Start;
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessReopenSaveAs;
begin
  if(not(FNotifyCode in [ofnFileOpened]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  if(TC4DWizardUtils.FileNameIsC4DWizardDPROJ(FFileName))then
    Exit;

  {$IFDEF RELEASE}
  TC4DWizardReopenSaveAs.New(FFileName);
  {$ELSE}
  //PARA TRATAR ERRO AO FECHAR O PROJETO C4DWizard APOS SUA COMPILACAO
  if(ExtractFileName(FFileName) <> TC4DConsts.C4D_PROJECT_GROUP1)then
    TC4DWizardReopenSaveAs.New(FFileName);
  {$ENDIF}
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessToolBarsBranch;
begin
  if(not(FNotifyCode in [ofnFileOpened, ofnFileClosing, ofnActiveProjectChanged]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  if(not Assigned(C4DWizardIDEToolBarsBranch))then
    Exit;

  C4DWizardIDEToolBarsBranch.ProcessRefreshCaptionLabel;
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessToolBarsBuild;
begin
  if(not(FNotifyCode in [ofnFileOpened, ofnFileClosing, ofnActiveProjectChanged, ofnPackageInstalled]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  if(not Assigned(C4D.Wizard.IDE.ToolBars.Build.C4DWizardIDEToolBarsBuild))then
    Exit;

  C4D.Wizard.IDE.ToolBars.Build.C4DWizardIDEToolBarsBuild.ProcessRefreshComboBox;
end;

procedure TC4DWizardIDEFileNotificationNotifier.ProcessToolBarsUtilities;
begin
  if(not(FNotifyCode in [ofnFileOpened, ofnFileClosing, ofnActiveProjectChanged]))then
    Exit;

  if(FExtension <> '.dproj')and(FExtension <> '.groupproj')then
    Exit;

  if(not Assigned(C4DWizardIDEToolBarsUtilities))then
    Exit;

  C4DWizardIDEToolBarsUtilities.ProcessRefresh;
end;

initialization

finalization
  if(IndexNotifier >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTAServices.RemoveNotifier(IndexNotifier);
    IndexNotifier := -1;
  end;

end.
