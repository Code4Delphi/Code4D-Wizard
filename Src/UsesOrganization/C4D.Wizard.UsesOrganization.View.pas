unit C4D.Wizard.UsesOrganization.View;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Threading,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  C4D.Wizard.Types,
  C4D.Wizard.Interfaces,
  C4D.Wizard.Messages.Simple;

type
  TC4DWizardUsesOrganizationView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnOrganizeUses: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    pnBody: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ckOrderUsesInAlphabeticalOrder: TCheckBox;
    ckOneUsesPerLine: TCheckBox;
    ckGroupUnitsByNamespaces: TCheckBox;
    ckLineBreakBetweenNamespaces: TCheckBox;
    edtOneUsesLineNumColBefore: TEdit;
    ckDisplayResultInMsgTab: TCheckBox;
    ckShowConfimationBeforeReplace: TCheckBox;
    rdGroupScope: TRadioGroup;
    Bevel2: TBevel;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    ckUsesToAdd: TCheckBox;
    ckUsesToAddStringsFilter: TCheckBox;
    GroupBox3: TGroupBox;
    ckUsesToRemove: TCheckBox;
    cBoxUsesToRemove: TComboBox;
    cBoxUsesToAdd: TComboBox;
    cBoxUsesToAddStringsFilter: TComboBox;
    Label3: TLabel;
    edtMaxCharactersPerLine: TEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOrganizeUsesClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ckOneUsesPerLineClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FC4DWizardUsesOrganization: IC4DWizardUsesOrganization;
    FC4DWizardModelFilesLoop: IC4DWizardModelFilesLoop;
    procedure WriteConfigurationScreen;
    procedure ReadConfigurationScreen;
    procedure WaitingFormON;
    procedure WaitingFormOFF;
    procedure ConfForm;
    procedure DoUsesOrganization(AInfoFile: TC4DWizardInfoFile);
    procedure ShowMsgSuccess;
    procedure ProcessMsgCancel;
  public

  end;

implementation

uses
  C4D.Wizard.Model.Files.Loop,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.UsesOrganization,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}

procedure TC4DWizardUsesOrganizationView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardUsesOrganizationView, Self);
  FC4DWizardUsesOrganization := TC4DWizardUsesOrganization.New;
  FC4DWizardModelFilesLoop := TC4DWizardModelFilesLoop.New;
end;

procedure TC4DWizardUsesOrganizationView.FormShow(Sender: TObject);
begin
  Self.WaitingFormOFF;

  cBoxUsesToRemove.Clear;
  cBoxUsesToAdd.Clear;
  cBoxUsesToAddStringsFilter.Clear;

  Self.ReadConfigurationScreen;

  if(ckUsesToRemove.Checked)and(cBoxUsesToRemove.Items.Count >= 0)then
    cBoxUsesToRemove.ItemIndex := 0;

  if(ckUsesToAdd.Checked)and(cBoxUsesToAdd.Items.Count >= 0)then
    cBoxUsesToAdd.ItemIndex := 0;

  if(ckUsesToAddStringsFilter.Checked)and(cBoxUsesToAddStringsFilter.Items.Count >= 0)then
    cBoxUsesToAddStringsFilter.ItemIndex := 0;

  Self.ConfForm;
end;

procedure TC4DWizardUsesOrganizationView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
      if(ssAlt in Shift)then
        Key := 0;
    VK_ESCAPE:
      if(Shift = [])then
        btnClose.Click;
  end;
end;

procedure TC4DWizardUsesOrganizationView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(ckOrderUsesInAlphabeticalOrder)
    .Write(ckOneUsesPerLine)
    .Write(ckGroupUnitsByNamespaces)
    .Write(ckLineBreakBetweenNamespaces)
    //.Write(rdGroupScope)
    .Write(edtOneUsesLineNumColBefore)
    .Write(edtMaxCharactersPerLine)
    .Write(ckShowConfimationBeforeReplace)
    .Write(ckDisplayResultInMsgTab)
    .Write(ckUsesToRemove)
    .Write(cBoxUsesToRemove)
    .Write(ckUsesToAdd)
    .Write(cBoxUsesToAdd)
    .Write(ckUsesToAddStringsFilter)
    .Write(cBoxUsesToAddStringsFilter);
end;

procedure TC4DWizardUsesOrganizationView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(ckOrderUsesInAlphabeticalOrder, False)
    .Read(ckOneUsesPerLine, True)
    .Read(ckGroupUnitsByNamespaces, False)
    .Read(ckLineBreakBetweenNamespaces, False)
    .Read(rdGroupScope, 0)
    .Read(edtOneUsesLineNumColBefore, '2')
    .Read(edtMaxCharactersPerLine, '90')
    .Read(ckShowConfimationBeforeReplace, True)
    .Read(ckDisplayResultInMsgTab, True)
    .Read(ckUsesToRemove, False)
    .Read(cBoxUsesToRemove, '')
    .Read(ckUsesToAdd, False)
    .Read(cBoxUsesToAdd, '')
    .Read(ckUsesToAddStringsFilter, False)
    .Read(cBoxUsesToAddStringsFilter, '');
end;

procedure TC4DWizardUsesOrganizationView.WaitingFormON;
begin
  Screen.Cursor := crHourGlass;
  pnBody.Enabled := False;
  btnOrganizeUses.Enabled := False;
  btnClose.Enabled := False;
  btnCancel.Enabled := True;
end;

procedure TC4DWizardUsesOrganizationView.WaitingFormOFF;
begin
  Screen.Cursor := crDefault;
  pnBody.Enabled := True;
  btnOrganizeUses.Enabled := True;
  btnClose.Enabled := True;
  btnCancel.Enabled := False;
end;

procedure TC4DWizardUsesOrganizationView.ckOneUsesPerLineClick(Sender: TObject);
begin
  //*SEVERAL
  Self.ConfForm;
end;

procedure TC4DWizardUsesOrganizationView.ConfForm;
begin
  ckLineBreakBetweenNamespaces.Enabled := ckGroupUnitsByNamespaces.Checked and ckOneUsesPerLine.Checked;
  edtMaxCharactersPerLine.Enabled := not ckOneUsesPerLine.Checked;
  cBoxUsesToRemove.Enabled := ckUsesToRemove.Checked;
  cBoxUsesToAdd.Enabled := ckUsesToAdd.Checked;
  cBoxUsesToAddStringsFilter.Enabled := ckUsesToAddStringsFilter.Checked;
end;

procedure TC4DWizardUsesOrganizationView.btnCancelClick(Sender: TObject);
begin
  FC4DWizardModelFilesLoop.Cancel;
end;

procedure TC4DWizardUsesOrganizationView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardUsesOrganizationView.btnOrganizeUsesClick(Sender: TObject);
var
  LTask: ITask;
begin
  if(edtMaxCharactersPerLine.Enabled)then
    if(StrToIntDef(edtMaxCharactersPerLine.Text, 0) < 30)then
      TC4DWizardUtils.ShowMsgAndAbort('Minimum value for "Maximum number of characters per line" field is 30', edtMaxCharactersPerLine);

  if(ckUsesToRemove.Checked)then
    if(Trim(cBoxUsesToRemove.Text).IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Uses to Remove not informed', cBoxUsesToRemove);

  if(ckUsesToAdd.Checked)then
    if(Trim(cBoxUsesToAdd.Text).IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Uses to Add not informed', cBoxUsesToAdd);

  if(ckUsesToAddStringsFilter.Checked)then
    if(Trim(cBoxUsesToAddStringsFilter.Text).IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Field "Only if the unit has the string" not informed', cBoxUsesToAddStringsFilter);

  if(ckShowConfimationBeforeReplace.Checked)then
    if(not TC4DWizardUtils.ShowQuestion('Confirm uses organization?'))then
      Exit;

  LTask := TTask.Create(
    procedure
    begin
      Self.WaitingFormON;
      try
        try
          FC4DWizardUsesOrganization
            .Params
              .OrderUsesInAlphabeticalOrder(ckOrderUsesInAlphabeticalOrder.Checked)
              .OneUsesPerLine(ckOneUsesPerLine.Checked)
              .OneUsesLineNumColBefore(StrToIntDef(edtOneUsesLineNumColBefore.Text, 2))
              .MaxCharactersPerLine(StrToIntDef(edtMaxCharactersPerLine.Text, 90))
              .GroupUnitsByNamespaces(ckGroupUnitsByNamespaces.Checked)
              .LineBreakBetweenNamespaces(ckLineBreakBetweenNamespaces.Checked)
              .UsesToRemoveList
                .Enabled(ckUsesToRemove.Checked)
                .UsesStr(cBoxUsesToRemove.Text)
              .End_
              .UsesToAddList
                .Enabled(ckUsesToAdd.Checked)
                .UsesStr(cBoxUsesToAdd.Text)
                .StringsFiltersStr(IfThen(ckUsesToAddStringsFilter.Checked, cBoxUsesToAddStringsFilter.Text, ''))
              .End_
              .ShowMessages(ckDisplayResultInMsgTab.Checked)
            .End_;

          FC4DWizardModelFilesLoop
            .Extensions([TC4DExtensionsFiles.PAS])
            .Escope(TC4DWizardEscope(rdGroupScope.ItemIndex))
            .LoopInFiles(Self.DoUsesOrganization);
        except
          on E: Exception do
            TThread.Synchronize(nil,
              procedure
              begin
                TC4DWizardUtils.ShowMsg('It was not possible to execute the organization in the files.' + sLineBreak +
                  E.Message);
                Abort;
              end);
        end;

        TThread.Synchronize(nil,
          procedure
          begin
            if(FC4DWizardModelFilesLoop.Canceled)then
              Self.ProcessMsgCancel
            else
              Self.ShowMsgSuccess;

            Self.WriteConfigurationScreen;

            if(not FC4DWizardModelFilesLoop.Canceled)then
            begin
              Self.Close;
              Self.ModalResult := mrOk;
            end
          end);
      finally
        TThread.Synchronize(nil,
          procedure
          begin
            Self.WaitingFormOFF;
          end);
      end;
    end);
  LTask.Start;
end;

procedure TC4DWizardUsesOrganizationView.DoUsesOrganization(AInfoFile: TC4DWizardInfoFile);
begin
  FC4DWizardUsesOrganization.UsesOrganizationInFile(AInfoFile);
end;

procedure TC4DWizardUsesOrganizationView.ShowMsgSuccess;
var
  LMsg: string;
begin
  LMsg := 'Uses organization complete. %s' +
    'Organization in ' + FC4DWizardUsesOrganization.CountAlterFiles.ToString + ' files';

  TC4DWizardUtils.ShowV(Format(LMsg, [sLineBreak]));

  if(ckDisplayResultInMsgTab.Checked)and(FC4DWizardUsesOrganization.CountAlterFiles > 0)then
    TC4DWizardMessagesSimple.New
      .FileName('')
      .Line(0)
      .Column(0)
      .GroupName(FC4DWizardUsesOrganization.GetGroupNameMsg)
      .Msg(Format(LMsg, ['']))
      .AddMsg
      .ShowMessages(FC4DWizardUsesOrganization.GetGroupNameMsg);
end;

procedure TC4DWizardUsesOrganizationView.ProcessMsgCancel;
begin
  TC4DWizardMessagesSimple.New
    .GroupName(FC4DWizardUsesOrganization.GetGroupNameMsg)
    .Msg('Organization in ' + FC4DWizardUsesOrganization.CountAlterFiles.ToString + ' files')
    .AddMsg
    .Msg('Organization canceled before completion')
    .AddMsg
    .ShowMessages;
end;

end.
