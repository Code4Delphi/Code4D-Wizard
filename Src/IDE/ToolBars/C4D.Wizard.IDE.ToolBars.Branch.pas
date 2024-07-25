unit C4D.Wizard.IDE.ToolBars.Branch;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Threading,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.ToolWin,
  Vcl.Graphics,
  ToolsAPI;

type
  TC4DWizardIDEToolBarsBranch = class
  private
    FINTAServices: INTAServices;
    FToolBarBranch: TToolBar;
    FToolButton: TToolButton;
    FLabel: TLabel;
    procedure OnC4DLabelBranchClick(Sender: TObject);
    procedure OnC4DLabelBranchMouseLeave(Sender: TObject);
    procedure OnC4DLabelBranchMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure NewToolBarC4D;
    procedure OnC4DToolButtonBranchClick(Sender: TObject);
    procedure RemoveToolBarC4D;
    procedure AddButtonRefreshBranch;
    procedure AddLabelBranch;
    function GetReferenceToolBar: string;
    function GetIniFile: TIniFile;
  protected
    constructor Create;
  public
    destructor Destroy; override;
    function ProcessRefreshCaptionLabel(const AForceRefresh: Boolean = False): string;
    procedure SetVisibleInINI(AVisible: Boolean);
    function GetVisibleInINI: Boolean;
  end;

var
  C4DWizardIDEToolBarsBranch: TC4DWizardIDEToolBarsBranch;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.LogFile,
  C4D.Wizard.Reopen.Controller,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.Git,
  C4D.Wizard.Utils.OTA;

const
  STR_WAIT = '...';
  STR_NO_BRANCH = 'No branch';

procedure RegisterSelf;
begin
  if(not Assigned(C4DWizardIDEToolBarsBranch))then
    C4DWizardIDEToolBarsBranch := TC4DWizardIDEToolBarsBranch.Create;

  C4DWizardIDEToolBarsBranch.ProcessRefreshCaptionLabel;
end;

constructor TC4DWizardIDEToolBarsBranch.Create;
begin
  FINTAServices := TC4DWizardUtilsOTA.GetINTAServices;
  Self.NewToolBarC4D;
  Self.ProcessRefreshCaptionLabel;
end;

destructor TC4DWizardIDEToolBarsBranch.Destroy;
begin
  Self.RemoveToolBarC4D;
  inherited;
end;

function TC4DWizardIDEToolBarsBranch.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniGeneralSettings);
end;

procedure TC4DWizardIDEToolBarsBranch.SetVisibleInINI(AVisible: Boolean);
begin
  Self.GetIniFile.WriteBool(TC4DConsts.TOOL_BAR_BRANCH_NAME,
    TC4DConsts.TOOL_BAR_BRANCH_INI_Visible,
    AVisible);
  if(AVisible)then
    Self.ProcessRefreshCaptionLabel(True);
end;

function TC4DWizardIDEToolBarsBranch.GetVisibleInINI: Boolean;
begin
  Result := Self.GetIniFile.ReadBool(TC4DConsts.TOOL_BAR_BRANCH_NAME,
    TC4DConsts.TOOL_BAR_BRANCH_INI_Visible,
    True);
end;

function TC4DWizardIDEToolBarsBranch.GetReferenceToolBar: string;
var
  LStandardToolBar: TToolBar;
  LControlBar: TControlBar;
  LControl: TControl;
  i: Integer;
  LBiggerLeft: Integer;
begin
  Result := sBrowserToolbar;
  LStandardToolBar := FINTAServices.ToolBar[sStandardToolBar];
  if(not Assigned(LStandardToolBar))then
    Exit;
  LControlBar := LStandardToolBar.Parent as TControlBar;

  LBiggerLeft := 0;
  for i := 0 to Pred(LControlBar.ControlCount) do
  begin
    LControl := LControlBar.Controls[i];
    if(LControl.Visible)and(LControl.Left > LBiggerLeft)then
    begin
      Result := LControl.Name;
      LBiggerLeft := LControl.Left;
    end;
  end;
end;

procedure TC4DWizardIDEToolBarsBranch.NewToolBarC4D;
begin
  Self.RemoveToolBarC4D;
  FToolBarBranch := FINTAServices.NewToolbar(TC4DConsts.TOOL_BAR_BRANCH_NAME,
    TC4DConsts.TOOL_BAR_BRANCH_CAPTION, Self.GetReferenceToolBar, True);
  FToolBarBranch.Visible := False;
  FToolBarBranch.EdgeInner := esNone;
  FToolBarBranch.EdgeOuter := esNone;
  FToolBarBranch.Flat := True;
  FToolBarBranch.Images := TC4DWizardUtilsOTA.GetINTAServices.ImageList;
  FToolBarBranch.ShowCaptions := False;
  FToolBarBranch.AutoSize := True;

  Self.AddButtonRefreshBranch;
  Self.AddLabelBranch;
  FToolBarBranch.Visible := Self.GetVisibleInINI;
end;

procedure TC4DWizardIDEToolBarsBranch.RemoveToolBarC4D;
var
  i: Integer;
begin
  FToolBarBranch := FINTAServices.ToolBar[TC4DConsts.TOOL_BAR_BRANCH_NAME];
  if(Assigned(FToolBarBranch))then
  begin
    for i := Pred(FToolBarBranch.ButtonCount) DownTo 0 do
      FToolBarBranch.Buttons[i].Free;

    FToolBarBranch.Visible := False;
    if(not TC4DWizardUtilsOTA.CurrentProjectIsC4DWizardDPROJ)then
      FreeAndNil(FToolBarBranch);
  end;
end;

procedure TC4DWizardIDEToolBarsBranch.AddButtonRefreshBranch;
begin
  FToolButton := TToolButton(FToolBarBranch.FindComponent(TC4DConsts.TOOL_BAR_BRANCH_TOOL_BUTTON_NAME));
  if(FToolButton <> nil)then
    FToolButton.Free;

  FToolButton := TToolButton.Create(FToolBarBranch);
  FToolButton.Parent := FToolBarBranch;
  FToolButton.Caption := 'Get Name Current Branch';
  FToolButton.Hint := FToolButton.Caption;
  FToolButton.ShowHint := True;
  FToolButton.Name := TC4DConsts.TOOL_BAR_BRANCH_TOOL_BUTTON_NAME;
  FToolButton.Style := tbsButton;
  FToolButton.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexRefresh;
  FToolButton.Visible := True;
  FToolButton.Left := 0;
  FToolButton.OnClick := OnC4DToolButtonBranchClick;
  FToolButton.AutoSize := True;
end;

procedure TC4DWizardIDEToolBarsBranch.AddLabelBranch;
begin
  FLabel := TLabel(FToolBarBranch.FindComponent(TC4DConsts.TOOL_BAR_BRANCH_LABEL_NAME));
  if(FLabel <> nil)then
    FLabel.Free;

  FLabel := TLabel.Create(FToolBarBranch);
  FLabel.Parent := FToolBarBranch;
  FLabel.AutoSize := True; //False;
  FLabel.Width := 300;
  FLabel.Constraints.MinWidth := 50;
  FLabel.Constraints.MaxWidth := 300;
  FLabel.Layout := tlCenter;
  FLabel.Alignment := taLeftJustify;
  FLabel.Hint := 'Name Current Branch';
  FLabel.ShowHint := True;
  FLabel.Name := TC4DConsts.TOOL_BAR_BRANCH_LABEL_NAME;
  FLabel.OnClick := Self.OnC4DLabelBranchClick;
  FLabel.OnMouseLeave := OnC4DLabelBranchMouseLeave;
  FLabel.OnMouseMove := OnC4DLabelBranchMouseMove;
  FLabel.Caption := STR_WAIT;

  FLabel.Left := 0;
  if(FToolBarBranch.ButtonCount > 0)then
    FLabel.Left := FToolBarBranch.Buttons[Pred(FToolBarBranch.ButtonCount)].Width +
      FToolBarBranch.Buttons[Pred(FToolBarBranch.ButtonCount)].Left;

  Self.ProcessRefreshCaptionLabel;
end;

procedure TC4DWizardIDEToolBarsBranch.OnC4DToolButtonBranchClick(Sender: TObject);
begin
  FLabel.Caption := STR_WAIT;
  FLabel.Repaint;
  Sleep(200);
  Self.ProcessRefreshCaptionLabel;
end;

function TC4DWizardIDEToolBarsBranch.ProcessRefreshCaptionLabel(const AForceRefresh: Boolean = False): string;
var
  LCurrentProjectFileName: string;
  LFolderGit: string;
  LTask: ITask;
begin
  if(FLabel = nil)then
    Exit;

  FLabel.Caption := STR_NO_BRANCH;
  FLabel.Font.Color := TC4DWizardUtilsOTA.ActiveThemeColorDefaul;

  if(not AForceRefresh)and(not FToolBarBranch.Visible)then
    Exit;

  FLabel.Caption := STR_WAIT;

  LTask := TTask.Create(
    procedure
    begin
      try
        LCurrentProjectFileName := TC4DWizardUtilsOTA.GetCurrentProjectFileName;
        if(not FileExists(LCurrentProjectFileName))then
          Exit;

        LFolderGit := TC4DWizardReopenController.New(LCurrentProjectFileName).GetC4DWizardReopenData.FolderGit;
        if(LFolderGit.Trim.IsEmpty)then
          Exit;

        FLabel.Caption := TC4DWizardUtilsGit.GetNameCurrentBranchInGit(LFolderGit).Trim;
      finally
        if(LowerCase(FLabel.Caption).Equals(STR_WAIT))then
          FLabel.Caption := STR_NO_BRANCH
        else if(LowerCase(FLabel.Caption).Equals('master'))or(LowerCase(FLabel.Caption).Equals('main'))then
          FLabel.Font.Color := clRed;
      end;
    end);
  LTask.Start;
end;

procedure TC4DWizardIDEToolBarsBranch.OnC4DLabelBranchClick(Sender: TObject);
var
  LCurrentProjectFileName: string;
begin
  LCurrentProjectFileName := TC4DWizardUtilsOTA.GetCurrentProjectFileName;
  if(FileExists(LCurrentProjectFileName))then
    TC4DWizardReopenController.New(LCurrentProjectFileName).ViewInformationRemoteRepository;
end;

procedure TC4DWizardIDEToolBarsBranch.OnC4DLabelBranchMouseLeave(Sender: TObject);
begin
  //*SEVERAL
  FLabel.Font.Style := FLabel.Font.Style - [fsUnderline, fsBold];
end;

procedure TC4DWizardIDEToolBarsBranch.OnC4DLabelBranchMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //*SEVERAL
  FLabel.Font.Style := FLabel.Font.Style + [fsUnderline, fsBold];
end;

initialization

finalization
  if(Assigned(C4DWizardIDEToolBarsBranch))then
    FreeAndNil(C4DWizardIDEToolBarsBranch);

end.
