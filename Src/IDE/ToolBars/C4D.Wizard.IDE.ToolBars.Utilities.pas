unit C4D.Wizard.IDE.ToolBars.Utilities;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IniFiles,
  System.Generics.Collections,
  Winapi.Windows,
  Vcl.ComCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Menus,
  ToolsAPI,
  C4D.Wizard.OpenExternal;

type
  TC4DWizardIDEToolBarsUtilities = class
  private
    FCont: Integer;
    FINTAServices: INTAServices;
    FToolBarUtilities: TToolBar;
    FToolButtonUnitInReadOnly: TToolButton;
    FList: TObjectList<TC4DWizardOpenExternal>;
    procedure NewToolBarUtilities;
    procedure OnC4DToolButtonUnitInReadOnlyClick(Sender: TObject);
    procedure RemoveToolBarUtilities;
    procedure AddButtonUnitInReadOnly;
    function GetIniFile: TIniFile;
    procedure ProcessRefreshUnitInReadOnly;
    procedure ConfigButtonUnitInReadOnly(const AInReadOnly: Boolean);
    procedure OpenExternalFillList;
    procedure OpenExternalCreateButtonList;
    procedure OpenExternalCreateButton(const AC4DWizardOpenExternal: TC4DWizardOpenExternal);
    procedure ToolButtonOpenExternalClick(Sender: TObject);
    procedure RemoveToolButtons;
    procedure CreateAllButtons;
  protected
    constructor Create;
  public
    destructor Destroy; override;
    procedure ProcessRefresh(const AForceRefresh: Boolean = False);
    procedure SetVisibleInINI(AVisible: Boolean);
    function GetVisibleInINI: Boolean;
    procedure RefreshButtons;
  end;

var
  C4DWizardIDEToolBarsUtilities: TC4DWizardIDEToolBarsUtilities;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.IDE.ToolBars.Utils,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.OpenExternal.Model,
  C4D.Wizard.OpenExternal.Utils;

procedure RegisterSelf;
begin
  if(not Assigned(C4DWizardIDEToolBarsUtilities))then
    C4DWizardIDEToolBarsUtilities := TC4DWizardIDEToolBarsUtilities.Create;

  C4DWizardIDEToolBarsUtilities.ProcessRefresh;
end;

constructor TC4DWizardIDEToolBarsUtilities.Create;
begin
  FList := TObjectList<TC4DWizardOpenExternal>.Create;
  FCont := 0;
  FINTAServices := TC4DWizardUtilsOTA.GetINTAServices;
  Self.NewToolBarUtilities;
  Self.ProcessRefresh;
end;

destructor TC4DWizardIDEToolBarsUtilities.Destroy;
begin
  Self.RemoveToolBarUtilities;
  FList.Free;
  inherited;
end;

procedure TC4DWizardIDEToolBarsUtilities.NewToolBarUtilities;
begin
  Self.RemoveToolBarUtilities;
  FToolBarUtilities := FINTAServices.NewToolbar(TC4DConsts.TOOL_BAR_UTILITIES_NAME,
    TC4DConsts.TOOL_BAR_UTILITIES_CAPTION, TC4DWizardIDEToolBarsUtils.GetReferenceToolbarName, True);
  FToolBarUtilities.Visible := False;
  FToolBarUtilities.Flat := True;
  FToolBarUtilities.Images := TC4DWizardUtilsOTA.GetINTAServices.ImageList;
  FToolBarUtilities.ShowCaptions := False;
  FToolBarUtilities.AutoSize := True;

  Self.CreateAllButtons;
  FToolBarUtilities.Visible := Self.GetVisibleInINI;
end;

procedure TC4DWizardIDEToolBarsUtilities.CreateAllButtons;
begin
  Self.OpenExternalFillList;
  Self.OpenExternalCreateButtonList;
  Self.AddButtonUnitInReadOnly;
end;

procedure TC4DWizardIDEToolBarsUtilities.RefreshButtons;
begin
  Self.RemoveToolButtons;
  Self.CreateAllButtons;
end;

procedure TC4DWizardIDEToolBarsUtilities.RemoveToolBarUtilities;
begin
  Self.RemoveToolButtons;

  if(not Assigned(FToolBarUtilities))then
    FToolBarUtilities := FINTAServices.ToolBar[TC4DConsts.TOOL_BAR_UTILITIES_NAME];

  if(Assigned(FToolBarUtilities))then
  begin
    FToolBarUtilities.Visible := False;
    if(not TC4DWizardUtilsOTA.CurrentProjectIsC4DWizardDPROJ)then
      FreeAndNil(FToolBarUtilities);
  end;
end;

procedure TC4DWizardIDEToolBarsUtilities.RemoveToolButtons;
var
  i: Integer;
begin
  FToolBarUtilities := FINTAServices.ToolBar[TC4DConsts.TOOL_BAR_UTILITIES_NAME];
  if(Assigned(FToolBarUtilities))then
  begin
    for i := Pred(FToolBarUtilities.ButtonCount) DownTo 0 do
      FToolBarUtilities.Buttons[i].Free;
  end;
end;

function TC4DWizardIDEToolBarsUtilities.GetIniFile: TIniFile;
begin
  Result := TIniFile.Create(TC4DWizardUtils.GetPathFileIniGeneralSettings);
end;

procedure TC4DWizardIDEToolBarsUtilities.SetVisibleInINI(AVisible: Boolean);
begin
  Self.GetIniFile.WriteBool(TC4DConsts.TOOL_BAR_UTILITIES_NAME,
    TC4DConsts.TOOL_BAR_UTILITIES_INI_Visible, AVisible);

  if(AVisible)then
    Self.ProcessRefresh(True);
end;

function TC4DWizardIDEToolBarsUtilities.GetVisibleInINI: Boolean;
begin
  Result := Self.GetIniFile.ReadBool(TC4DConsts.TOOL_BAR_UTILITIES_NAME,
    TC4DConsts.TOOL_BAR_UTILITIES_INI_Visible, True);
end;

procedure TC4DWizardIDEToolBarsUtilities.AddButtonUnitInReadOnly;
begin
  FToolButtonUnitInReadOnly := TToolButton(FToolBarUtilities.FindComponent(TC4DConsts.TOOL_BAR_UTILITIES_TOOL_BUTTON_UnitInReadOnly_NAME));
  if(FToolButtonUnitInReadOnly <> nil)then
    FToolButtonUnitInReadOnly.Free;

  FToolButtonUnitInReadOnly := TToolButton.Create(FToolBarUtilities);
  FToolButtonUnitInReadOnly.Parent := FToolBarUtilities;
  FToolButtonUnitInReadOnly.Caption := '';
  FToolButtonUnitInReadOnly.Hint := FToolButtonUnitInReadOnly.Caption;
  FToolButtonUnitInReadOnly.ShowHint := True;
  FToolButtonUnitInReadOnly.Name := TC4DConsts.TOOL_BAR_UTILITIES_TOOL_BUTTON_UnitInReadOnly_NAME;
  FToolButtonUnitInReadOnly.Style := tbsButton;
  FToolButtonUnitInReadOnly.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexLockOFF;
  FToolButtonUnitInReadOnly.Visible := True;
  FToolButtonUnitInReadOnly.OnClick := OnC4DToolButtonUnitInReadOnlyClick;
  FToolButtonUnitInReadOnly.AutoSize := True;
  FToolButtonUnitInReadOnly.Left := 0;
end;

procedure TC4DWizardIDEToolBarsUtilities.OnC4DToolButtonUnitInReadOnlyClick(Sender: TObject);
var
  LIOTAEditBuffer: IOTAEditBuffer;
begin
  LIOTAEditBuffer := TC4DWizardUtilsOTA.GetIOTAEditBufferCurrentModule;
  if(LIOTAEditBuffer = nil)then
    Exit;

  LIOTAEditBuffer.IsReadOnly := not LIOTAEditBuffer.IsReadOnly;
  Self.ConfigButtonUnitInReadOnly(LIOTAEditBuffer.IsReadOnly);
end;

procedure TC4DWizardIDEToolBarsUtilities.ProcessRefresh(const AForceRefresh: Boolean = False);
begin
  if(not AForceRefresh)and(not FToolBarUtilities.Visible)then
    Exit;

  Self.ProcessRefreshUnitInReadOnly;
end;

procedure TC4DWizardIDEToolBarsUtilities.ProcessRefreshUnitInReadOnly;
begin
  if(FToolButtonUnitInReadOnly = nil)or(not FToolButtonUnitInReadOnly.Visible)then
    Exit;

  Self.ConfigButtonUnitInReadOnly(TC4DWizardUtilsOTA.CurrentModuleIsReadOnly);
end;

procedure TC4DWizardIDEToolBarsUtilities.ConfigButtonUnitInReadOnly(const AInReadOnly: Boolean);
begin
  FToolButtonUnitInReadOnly.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexLockOFF;
  FToolButtonUnitInReadOnly.Hint := 'Mark as read only';
  if(AInReadOnly)then
  begin
    FToolButtonUnitInReadOnly.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexLockON;
    FToolButtonUnitInReadOnly.Hint := 'Mark as not read-only';
  end;
end;

procedure TC4DWizardIDEToolBarsUtilities.OpenExternalFillList;
begin
  FList.Clear;
  TC4DWizardOpenExternalModel.New.ReadIniFile(
    procedure(AC4DWizardOpenExternal: TC4DWizardOpenExternal)
    var
      LC4DWizardOpenExternal: TC4DWizardOpenExternal;
    begin
      if(not AC4DWizardOpenExternal.VisibleInToolBarUtilities)then
        Exit;
      LC4DWizardOpenExternal := TC4DWizardOpenExternal.Create;
      LC4DWizardOpenExternal.Guid := AC4DWizardOpenExternal.Guid;
      LC4DWizardOpenExternal.Description := AC4DWizardOpenExternal.Description;
      LC4DWizardOpenExternal.Path := AC4DWizardOpenExternal.Path;
      LC4DWizardOpenExternal.Parameters := AC4DWizardOpenExternal.Parameters;
      LC4DWizardOpenExternal.Kind := AC4DWizardOpenExternal.Kind;
      LC4DWizardOpenExternal.Order := AC4DWizardOpenExternal.Order;
      LC4DWizardOpenExternal.Shortcut := AC4DWizardOpenExternal.Shortcut;
      LC4DWizardOpenExternal.IconHas := AC4DWizardOpenExternal.IconHas;
      LC4DWizardOpenExternal.GuidMenuMaster := AC4DWizardOpenExternal.GuidMenuMaster;
      FList.Add(LC4DWizardOpenExternal);
    end);
end;

procedure TC4DWizardIDEToolBarsUtilities.OpenExternalCreateButtonList;
var
  LItem: TC4DWizardOpenExternal;
  LListOrder: TList<Integer>;
  i: Integer;
begin
  if(FList.Count <= 0)then
    Exit;

  FCont := 0;

  LListOrder := TList<Integer>.Create;
  try
    for LItem in FList do
      if(LItem.Order > 0)and(not LListOrder.Contains(LItem.Order))then
        LListOrder.Add(LItem.Order);

    LListOrder.Sort;
    for i in LListOrder do
      for LItem in FList do
        if(LItem.Order = i)then
          Self.OpenExternalCreateButton(LItem);
  finally
    LListOrder.Free;
  end;

  for LItem in FList do
    if(LItem.Order = 0)then
      Self.OpenExternalCreateButton(LItem);
end;

procedure TC4DWizardIDEToolBarsUtilities.OpenExternalCreateButton(const AC4DWizardOpenExternal: TC4DWizardOpenExternal);
var
  LNameButton: string;
  LToolButton: TToolButton;
begin
  LNameButton := 'C4DToolBarsUtilities' + TC4DWizardUtils.IncInt(FCont).ToString;
  LToolButton := TToolButton(FToolBarUtilities.FindComponent(LNameButton));
  if(LToolButton <> nil)then
    LToolButton.Free;

  LToolButton := TToolButton.Create(FToolBarUtilities);
  LToolButton.Parent := FToolBarUtilities;
  LToolButton.Caption := AC4DWizardOpenExternal.Path + TC4DConsts.OPEN_EXTERNAL_Separator_PARAMETERS + AC4DWizardOpenExternal.Parameters;;
  LToolButton.Hint := AC4DWizardOpenExternal.Description;
  LToolButton.ShowHint := True;
  LToolButton.Name := LNameButton;
  LToolButton.Style := tbsButton;
  LToolButton.ImageIndex := TC4DWizardOpenExternalUtils.GetImageIndexIfExists(AC4DWizardOpenExternal, True);
  LToolButton.Visible := True;
  LToolButton.OnClick := Self.ToolButtonOpenExternalClick;
  LToolButton.AutoSize := True;

  LToolButton.Left := 0;
  if(FToolBarUtilities.ButtonCount > 0)then
    LToolButton.Left := FToolBarUtilities.Buttons[Pred(FToolBarUtilities.ButtonCount)].Width +
      FToolBarUtilities.Buttons[Pred(FToolBarUtilities.ButtonCount)].Left;
end;

procedure TC4DWizardIDEToolBarsUtilities.ToolButtonOpenExternalClick(Sender: TObject);
var
  LToolButton: TToolButton;
begin
  LToolButton := TToolButton(Sender);
  if(LToolButton = nil)then
    Exit;

  TC4DWizardOpenExternalUtils.ClickFromString(LToolButton.Caption);
end;

initialization

finalization
  if(Assigned(C4DWizardIDEToolBarsUtilities))then
    FreeAndNil(C4DWizardIDEToolBarsUtilities);

end.
