unit C4D.Wizard.IDE.ToolBars.Notifier;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  Vcl.Controls;

type
  TC4DWizardIDEToolBarsNotifier = class(TNotifierObject, IOTANotifier, INTACustomizeToolbarNotifier)
  protected
    procedure CreateButton(AOwner: TComponent; var Button: TControl; Action: TBasicAction);
    procedure FilterAction(Action: TBasicAction; ViewingAllCommands: Boolean;
      var DisplayName: string; var Display: Boolean; var Handled: Boolean);
    procedure FilterCategory(var Category: string; var Display: Boolean; var Handled: Boolean);
    procedure ResetToolbar(var Toolbar: TWinControl);
    procedure ShowToolbar(Toolbar: TWinControl; Show: Boolean);
    procedure ToolbarModified(Toolbar: TWinControl);
  public
    constructor Create;
  end;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.IDE.ToolBars.Branch,
  C4D.Wizard.IDE.ToolBars.Build;

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
    IndexNotifier := TC4DWizardUtilsOTA.GetINTAServices.RegisterToolbarNotifier(TC4DWizardIDEToolBarsNotifier.Create);
end;

constructor TC4DWizardIDEToolBarsNotifier.Create;
begin
  //
end;

procedure TC4DWizardIDEToolBarsNotifier.CreateButton(AOwner: TComponent; var Button: TControl; Action: TBasicAction);
begin
  //
end;

procedure TC4DWizardIDEToolBarsNotifier.FilterAction(Action: TBasicAction; ViewingAllCommands: Boolean; var DisplayName: string; var Display, Handled: Boolean);
begin
  //ACIONADO AO ACESSAR A OPÇÃO Customize... (POR SEGUNDO)
end;

procedure TC4DWizardIDEToolBarsNotifier.FilterCategory(var Category: string; var Display, Handled: Boolean);
begin
  //ACIONADO AO ACESSAR A OPÇÃO Customize... (POR PRIMEIRO)
end;

procedure TC4DWizardIDEToolBarsNotifier.ResetToolbar(var Toolbar: TWinControl);
begin
  //
end;

procedure TC4DWizardIDEToolBarsNotifier.ShowToolbar(Toolbar: TWinControl; Show: Boolean);
begin
  //AO CLICAR NOS ITENS DO CheckListBox DO FORM DE Customize
  if(Toolbar.Name = TC4DConsts.TOOL_BAR_BRANCH_NAME)then
  begin
    if(Assigned(C4DWizardIDEToolBarsBranch))then
      C4DWizardIDEToolBarsBranch.SetVisibleInINI(Show);
  end
  else if(Toolbar.Name = TC4DConsts.TOOL_BAR_BUILD_NAME)then
  begin
    if(Assigned(C4DWizardIDEToolBarsBuild))then
      C4DWizardIDEToolBarsBuild.SetVisibleInINI(Show);
  end;
end;

procedure TC4DWizardIDEToolBarsNotifier.ToolbarModified(Toolbar: TWinControl);
begin
  //
end;

initialization

finalization
  if(IndexNotifier >= 0)then
  begin
    TC4DWizardUtilsOTA.GetINTAServices.UnregisterToolbarNotifier(IndexNotifier);
    //IndexNotifier := -1;
  end;

end.
