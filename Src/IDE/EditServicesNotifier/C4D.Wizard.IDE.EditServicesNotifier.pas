unit C4D.Wizard.IDE.EditServicesNotifier;

interface

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  Vcl.Dialogs,
  DockForm;

type
  TC4DWizardIDEEditServicesNotifier = class(TNotifierObject, INTAEditServicesNotifier)
  private
  protected
    procedure WindowShow(const EditWindow: INTAEditWindow; Show, LoadedFromDesktop: Boolean);
    procedure WindowNotification(const EditWindow: INTAEditWindow; Operation: TOperation);
    procedure WindowActivated(const EditWindow: INTAEditWindow);
    procedure WindowCommand(const EditWindow: INTAEditWindow; Command, Param: Integer; var Handled: Boolean);
    procedure EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
    procedure DockFormVisibleChanged(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormUpdated(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
    procedure DockFormRefresh(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
  public
    constructor Create;
    destructor Destroy; override;
  end;

procedure RegisterSelf;

implementation

uses
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.IDE.ToolBars.Register;

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
  begin
    IndexNotifier := TC4DWizardUtilsOTA.GetIOTAEditorServices.AddNotifier(TC4DWizardIDEEditServicesNotifier.Create);
    {$IFNDEF C4D_WIZARD_DLL}
    TC4DWizardIDEToolBarsRegister.ProcessWithThread;
    {$ENDIF}
  end;
end;

constructor TC4DWizardIDEEditServicesNotifier.Create;
begin

end;

destructor TC4DWizardIDEEditServicesNotifier.Destroy;
begin
  inherited;
end;

procedure TC4DWizardIDEEditServicesNotifier.DockFormRefresh(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin

end;

procedure TC4DWizardIDEEditServicesNotifier.DockFormUpdated(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin

end;

procedure TC4DWizardIDEEditServicesNotifier.DockFormVisibleChanged(const EditWindow: INTAEditWindow; DockForm: TDockableForm);
begin

end;

procedure TC4DWizardIDEEditServicesNotifier.EditorViewActivated(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
  TC4DWizardIDEToolBarsRegister.Process;
end;

procedure TC4DWizardIDEEditServicesNotifier.EditorViewModified(const EditWindow: INTAEditWindow; const EditView: IOTAEditView);
begin
  //   ShowMessage('EditorViewModified: Texto alterado no Editor' + sLineBreak +
  //               'Linha atual: '       + EditView.Buffer.EditPosition.Row.Tostring     + sLineBreak  +
  //               'Coluna atual: '      + EditView.Buffer.EditPosition.Column.Tostring  + sLineBreak  +
  //               'Última linha: '      + EditView.Buffer.EditPosition.LastRow.Tostring + sLineBreak);
end;

procedure TC4DWizardIDEEditServicesNotifier.WindowActivated(const EditWindow: INTAEditWindow);
begin

end;

procedure TC4DWizardIDEEditServicesNotifier.WindowCommand(const EditWindow: INTAEditWindow; Command, Param: Integer; var Handled: Boolean);
begin
  //   ShowMessage('WindowCommand' + sLineBreak +
  //               'Command: ' + Command.Tostring + sLineBreak +
  //               'Param: '   + Param.Tostring);

  //   if(Command = 22)then
  //   begin
  //      ShowMessage('Você teclou Ctrl + C e essa opção não é permitida');
  //      Abort;
  //   end;
end;

procedure TC4DWizardIDEEditServicesNotifier.WindowNotification(const EditWindow: INTAEditWindow; Operation: TOperation);
begin

end;

procedure TC4DWizardIDEEditServicesNotifier.WindowShow(const EditWindow: INTAEditWindow; Show, LoadedFromDesktop: Boolean);
begin
  //   ShowMessage('WindowShow: Quando o Delphi é aberto e quando outras janelas são abertas' + sLineBreak +
  //               'Show: '              + BoolToStr(Show, True)              + sLineBreak +
  //               'LoadedFromDesktop: ' + BoolToStr(LoadedFromDesktop, True));

  TC4DWizardIDEToolBarsRegister.Process;
end;

initialization

finalization
  if(IndexNotifier >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTAEditorServices.RemoveNotifier(IndexNotifier);
    IndexNotifier := -1;
  end;

end.
