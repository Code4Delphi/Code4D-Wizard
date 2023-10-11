unit C4D.Wizard.Messages.Custom.Groups.OTA;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  ToolsAPI,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

type
  TDGHIDENotification = (
    dinWizard,
    dinMenuWizard,
    dinIDENotifier,
    dinVersionControlNotifier,
    dinCompileNotifier,
    dinMessageNotifier,
    dinIDEInsightNotifier,
    dinProjectFileStorageNotifier,
    dinEditorNotifier,
    dinDebuggerNotifier
    );

  TDGHNotifierObject = Class(TNotifierObject, IOTANotifier)
  strict private
  strict protected
    procedure DoNotification(strMessage: string);
  public
    constructor Create(strNotifier: string; iNotification: TDGHIDENotification);
    // IOTANotifier
    Procedure AfterSave;
    Procedure BeforeSave;
    Procedure Destroyed;
    Procedure Modified;
    Procedure AfterConstruction; Override;
    Procedure BeforeDestruction; Override;
  End;

  TC4DWizardMessagesCustomGroupsOTA = class(TDGHNotifierObject, IOTAMessageNotifier, INTAMessageNotifier)
  strict private
    procedure MessageGroupRepeatSearch1Click(Sender: TObject);
  Protected
  public
    // IOTAMessageNotifier
    procedure MessageGroupAdded(Const Group: IOTAMessageGroup);
    procedure MessageGroupDeleted(Const Group: IOTAMessageGroup);
    // INTAMessageNotifier
    procedure MessageViewMenuShown(Menu: TPopupMenu; const MessageGroup: IOTAMessageGroup; LineRef: Pointer);
  end;

procedure RegisterSelf;

implementation

var
  IndexNotifier: Integer = -1;

procedure RegisterSelf;
begin
  if(IndexNotifier < 0)then
    IndexNotifier := TC4DWizardUtilsOTA.GetIOTAMessageServices.AddNotifier(
      TC4DWizardMessagesCustomGroupsOTA.Create('IOTAMessageNotifier', dinMessageNotifier));
end;

{ TDGHNotifierObject }
procedure TDGHNotifierObject.AfterConstruction;
begin
  inherited;
end;

procedure TDGHNotifierObject.AfterSave;
begin

end;

procedure TDGHNotifierObject.BeforeDestruction;
begin
  inherited;
end;

procedure TDGHNotifierObject.BeforeSave;
begin

end;

constructor TDGHNotifierObject.Create(strNotifier: string; iNotification: TDGHIDENotification);
begin

end;

procedure TDGHNotifierObject.Destroyed;
begin

end;

procedure TDGHNotifierObject.DoNotification(strMessage: string);
begin

end;

procedure TDGHNotifierObject.Modified;
begin

end;

{ TC4DWizardMessagesCustomGroupsOTA }
procedure TC4DWizardMessagesCustomGroupsOTA.MessageGroupAdded(const Group: IOTAMessageGroup);
begin

end;

procedure TC4DWizardMessagesCustomGroupsOTA.MessageGroupDeleted(const Group: IOTAMessageGroup);
begin

end;

procedure TC4DWizardMessagesCustomGroupsOTA.MessageViewMenuShown(Menu: TPopupMenu; const MessageGroup: IOTAMessageGroup; LineRef: Pointer);
var
  LMenuItem: TMenuItem;
begin
  if(not MessageGroup.Name.StartsWith('Find for', True))then
    Exit;

  LMenuItem := TMenuItem.Create(Menu);
  LMenuItem.Name := 'C4DMessageGroupSeparator1';
  LMenuItem.Caption := '-';
  Menu.Items.Add(LMenuItem);

  LMenuItem := TMenuItem.Create(Menu);
  LMenuItem.Name := 'C4DMessageGroupRepeatSearch1';
  LMenuItem.Caption := 'Repeat Search';
  LMenuItem.ShortCut := TextToShortCut('F3');
  LMenuItem.OnClick := Self.MessageGroupRepeatSearch1Click;
  Menu.Items.Add(LMenuItem);
end;

procedure TC4DWizardMessagesCustomGroupsOTA.MessageGroupRepeatSearch1Click(Sender: TObject);
begin
  TC4DWizardUtils.ShowMsg('Under development');
end;

initialization

finalization
  if(IndexNotifier >= 0)then
  begin
    TC4DWizardUtilsOTA.GetIOTAMessageServices.RemoveNotifier(IndexNotifier);
    IndexNotifier := -1;
  end;

end.
