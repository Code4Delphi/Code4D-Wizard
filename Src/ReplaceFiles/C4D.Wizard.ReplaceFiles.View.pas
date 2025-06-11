unit C4D.Wizard.ReplaceFiles.View;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Threading,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  C4D.Wizard.Types,
  C4D.Wizard.Interfaces,
  C4D.Wizard.ReplaceFiles.Interfaces,
  C4D.Wizard.ReplaceFiles.Model;

type
  TC4DWizardReplaceFilesView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnReplace: TButton;
    ckShowConfimationBeforeReplace: TCheckBox;
    btnCancel: TButton;
    pnBody: TPanel;
    Bevel2: TBevel;
    Bevel1: TBevel;
    Bevel4: TBevel;
    gBoxText: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    rdGroupScope: TRadioGroup;
    Panel2: TPanel;
    Bevel3: TBevel;
    gBoxOptions: TGroupBox;
    ckCaseSensitive: TCheckBox;
    ckWholeWordOnly: TCheckBox;
    ckDisplayResultInMsgTab: TCheckBox;
    gBoxExtension: TGroupBox;
    ckExtensionPas: TCheckBox;
    ckExtensionDFM: TCheckBox;
    ckExtensionFMX: TCheckBox;
    ckExtensionDPRandDPK: TCheckBox;
    ckExtensionDPROJ: TCheckBox;
    cBoxSearchFor: TComboBox;
    cBoxReplaceBy: TComboBox;
    btnSearchForAndReplaceByEverEquals: TButton;
    ckSearchForAndReplaceByEverEqualsInShow: TCheckBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    btnSearchDirectory: TButton;
    cBoxSearchDirectory: TComboBox;
    ckIncludeSubdirectories: TCheckBox;
    Bevel5: TBevel;
    ckDisplayAccountant: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnReplaceClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSearchForAndReplaceByEverEqualsClick(Sender: TObject);
    procedure ckSearchForAndReplaceByEverEqualsInShowClick(Sender: TObject);
    procedure rdGroupScopeClick(Sender: TObject);
    procedure btnSearchDirectoryClick(Sender: TObject);
  private
    FC4DWizardReplaceFilesModel: IC4DWizardReplaceFilesModel;
    FC4DWizardModelFilesLoop: IC4DWizardModelFilesLoop;
    procedure DoReplace(AInfoFile: TC4DWizardInfoFile);
    function GetExtensions: TC4DExtensionsOfFiles;
    procedure ReadConfigurationScreen;
    procedure WriteConfigurationScreen;
    procedure WaitingFormON;
    procedure WaitingFormOFF;
    procedure ShowMsgSuccess;
    procedure ProcessMsgCancel;
    procedure ReloadConfigurationScreen;
    procedure ConfScope;
  public

  end;

var
  C4DWizardReplaceFilesView: TC4DWizardReplaceFilesView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Model.Files.Loop,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.Messages.Custom;

{$R *.dfm}


procedure TC4DWizardReplaceFilesView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardReplaceFilesView, Self);
  FC4DWizardReplaceFilesModel := TC4DWizardReplaceFilesModel.New;
  FC4DWizardModelFilesLoop := TC4DWizardModelFilesLoop.New;
  TC4DWizardUtils.ExtensionFillTStringsWithValid(rdGroupScope.Items);
  rdGroupScope.ItemIndex := 0;
end;

procedure TC4DWizardReplaceFilesView.FormShow(Sender: TObject);
var
  LBlockTextSelect: string;
begin
  Self.WaitingFormOFF;

  cBoxSearchFor.Clear;
  cBoxReplaceBy.Clear;
  cBoxSearchDirectory.Clear;
  LBlockTextSelect := TC4DWizardUtilsOTA.GetBlockTextSelect;
  if(not LBlockTextSelect.Trim.IsEmpty)then
    cBoxSearchFor.Items.Add(LBlockTextSelect);

  Self.ReadConfigurationScreen;
  Self.ConfScope;

  if(cBoxSearchDirectory.Items.Count >= 0)then
    cBoxSearchDirectory.ItemIndex := 0;

  if(cBoxSearchFor.Items.Count >= 0)then
    cBoxSearchFor.ItemIndex := 0;
  cBoxSearchFor.SetFocus;

  if(ckSearchForAndReplaceByEverEqualsInShow.Checked)then
    cBoxReplaceBy.Text := cBoxSearchFor.Text
  else if(cBoxReplaceBy.Items.Count >= 0)then
    cBoxReplaceBy.ItemIndex := 0;
end;

procedure TC4DWizardReplaceFilesView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
    if(ssAlt in Shift)then
      Key := 0;
    VK_ESCAPE:
    if(btnCancel.Enabled)then
      btnCancel.Click
    else if(Shift = [])and(btnClose.Enabled)then
      btnClose.Click;
  end;
end;

procedure TC4DWizardReplaceFilesView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(cBoxSearchFor, 30)
    .Write(cBoxReplaceBy, 30)
    .Write(ckCaseSensitive)
    .Write(ckWholeWordOnly)
    .Write(ckDisplayAccountant)
    .Write(ckDisplayResultInMsgTab)
    .Write(ckExtensionPas)
    .Write(ckExtensionDFM)
    .Write(ckExtensionFMX)
    .Write(ckExtensionDPRandDPK)
    .Write(ckExtensionDPROJ)
    .Write(rdGroupScope)
    .Write(ckShowConfimationBeforeReplace)
    .Write(ckSearchForAndReplaceByEverEqualsInShow)
    .Write(cBoxSearchDirectory)
    .Write(ckIncludeSubdirectories);
end;

procedure TC4DWizardReplaceFilesView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(cBoxSearchFor, '')
    .Read(cBoxReplaceBy, '')
    .Read(ckCaseSensitive, False)
    .Read(ckWholeWordOnly, False)
    .Read(ckDisplayAccountant, True)
    .Read(ckDisplayResultInMsgTab, True)
    .Read(ckExtensionPas, True)
    .Read(ckExtensionDFM, False)
    .Read(ckExtensionFMX, False)
    .Read(ckExtensionDPRandDPK, False)
    .Read(ckExtensionDPROJ, False)
    //.Read(rdGroupScope, 0)
    .Read(ckShowConfimationBeforeReplace, True)
    .Read(ckSearchForAndReplaceByEverEqualsInShow, False)
    .Read(cBoxSearchDirectory, '')
    .Read(ckIncludeSubdirectories, True);
end;

procedure TC4DWizardReplaceFilesView.WaitingFormON;
begin
  Screen.Cursor := crHourGlass;
  pnBody.Enabled := False;
  ckShowConfimationBeforeReplace.Enabled := False;
  btnReplace.Enabled := False;
  btnClose.Enabled := False;
  btnCancel.Enabled := True;
end;

procedure TC4DWizardReplaceFilesView.WaitingFormOFF;
begin
  Screen.Cursor := crDefault;
  pnBody.Enabled := True;
  ckShowConfimationBeforeReplace.Enabled := True;
  btnReplace.Enabled := True;
  btnClose.Enabled := True;
  btnCancel.Enabled := False;
end;

procedure TC4DWizardReplaceFilesView.btnCancelClick(Sender: TObject);
begin
  FC4DWizardModelFilesLoop.Cancel;
end;

procedure TC4DWizardReplaceFilesView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

function TC4DWizardReplaceFilesView.GetExtensions: TC4DExtensionsOfFiles;
begin
  Result := [];
  if(ckExtensionPas.Checked)then
    Result := Result + [TC4DExtensionsFiles.PAS];
  if(ckExtensionDFM.Checked)then
    Result := Result + [TC4DExtensionsFiles.DFM];
  if(ckExtensionFMX.Checked)then
    Result := Result + [TC4DExtensionsFiles.FMX];
  if(ckExtensionDPRandDPK.Checked)then
    Result := Result + [TC4DExtensionsFiles.DPR, TC4DExtensionsFiles.DPK];
  if(ckExtensionDPROJ.Checked)then
    Result := Result + [TC4DExtensionsFiles.DPROJ];
end;

procedure TC4DWizardReplaceFilesView.btnReplaceClick(Sender: TObject);
var
  LC4DWizardExtensions: TC4DExtensionsOfFiles;
  LTask: ITask;
begin
  if(Trim(cBoxSearchFor.Text).IsEmpty)then
    TC4DWizardUtils.ShowMsgAndAbort('Search for not informed', cBoxSearchFor);

  LC4DWizardExtensions := Self.GetExtensions;
  if(LC4DWizardExtensions = [])then
    TC4DWizardUtils.ShowMsgAndAbort('No selected extension');

  if(rdGroupScope.ItemIndex < 0)then
    TC4DWizardUtils.ShowMsgAndAbort('Scope not informed');

  if(TC4DWizardEscope(rdGroupScope.ItemIndex) = TC4DWizardEscope.FilesInDirectories)then
  begin
    if(Trim(cBoxSearchDirectory.Text).IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Directories for Search not informed', cBoxSearchDirectory);
  end;

  if(ckShowConfimationBeforeReplace.Checked)then
    if(not TC4DWizardUtils.ShowQuestion('Confirm replace?'))then
      Exit;

  LTask := TTask.Create(
    procedure
    begin
      Self.WaitingFormON;
      try
        try
          FC4DWizardReplaceFilesModel
            .ResetValues
            .WholeWordOnly(ckWholeWordOnly.Checked)
            .DisplayAccountant(ckDisplayAccountant.Checked)
            .CaseSensitive(ckCaseSensitive.Checked)
            .ShowMessages(ckDisplayResultInMsgTab.Checked)
            .SearchFor(cBoxSearchFor.Text)
            .ReplaceBy(cBoxReplaceBy.Text);

          FC4DWizardModelFilesLoop
            .Extensions(LC4DWizardExtensions)
            .Escope(TC4DWizardEscope(rdGroupScope.ItemIndex))
            .DirectoryForSearch(cBoxSearchDirectory.Text)
            .IncludeSubdirectories(ckIncludeSubdirectories.Checked)
            .LoopInFiles(Self.DoReplace);
        except
          on E: Exception do
            TThread.Synchronize(nil,
              procedure
              begin
                TC4DWizardUtils.ShowMsg('It was not possible to perform the replace in the files.' + sLineBreak +
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
            Self.ReloadConfigurationScreen;
            TC4DWizardUtilsOTA.RefreshProjectOrModule;
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

procedure TC4DWizardReplaceFilesView.ReloadConfigurationScreen;
var
  LStrSearchFor: string;
  LStrReplaceBy: string;
  LStrSearchDirectory: string;
begin
  LStrSearchFor := cBoxSearchFor.Text;
  LStrReplaceBy := cBoxReplaceBy.Text;
  LStrSearchDirectory := cBoxSearchDirectory.Text;
  cBoxSearchFor.Clear;
  cBoxReplaceBy.Clear;

  Self.ReadConfigurationScreen;

  cBoxSearchFor.Text := LStrSearchFor;
  cBoxReplaceBy.Text := LStrReplaceBy;
  cBoxSearchDirectory.Text := LStrSearchDirectory;
end;

procedure TC4DWizardReplaceFilesView.DoReplace(AInfoFile: TC4DWizardInfoFile);
begin
  FC4DWizardReplaceFilesModel.ReplaceInFile(AInfoFile);
end;

procedure TC4DWizardReplaceFilesView.btnSearchDirectoryClick(Sender: TObject);
begin
  cBoxSearchDirectory.Text := TC4DWizardUtils.SelectFolder(cBoxSearchDirectory.Text);
end;

procedure TC4DWizardReplaceFilesView.btnSearchForAndReplaceByEverEqualsClick(Sender: TObject);
begin
  cBoxReplaceBy.Text := cBoxSearchFor.Text;
  cBoxReplaceBy.SetFocus;
end;

procedure TC4DWizardReplaceFilesView.ckSearchForAndReplaceByEverEqualsInShowClick(Sender: TObject);
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(ckSearchForAndReplaceByEverEqualsInShow);
end;

procedure TC4DWizardReplaceFilesView.ShowMsgSuccess;
var
  LMsg: string;
begin
  LMsg := 'Replace complete: %s' +
    FC4DWizardReplaceFilesModel.GetCountReplace.ToString +' replacement in ' +
    FC4DWizardReplaceFilesModel.GetCountArqReplace.ToString + ' files';

  if(FC4DWizardReplaceFilesModel.GetCountReplace <= 0)then
  begin
    TC4DWizardUtils.ShowMsg(Format(LMsg, [sLineBreak]));
    Exit;
  end;

  TC4DWizardUtils.ShowV(Format(LMsg, [sLineBreak]));

  if(ckDisplayResultInMsgTab.Checked)then
    TC4DWizardMessageCustom.GetInstance
      .Clear
      .GroupName(FC4DWizardReplaceFilesModel.GetGroupNameMsg)
      .Style([fsBold])
      .Prefix(DateTimeToStr(Now))
      .Msg(Format(LMsg, ['']))
      .AddMsg
      .Prefix('')
      .Msg('<clRed>'+ QuotedStr(cBoxSearchFor.Text) +'</clRed>')
      .AddMsg
      .Msg('<clGreen>'+ QuotedStr(cBoxReplaceBy.Text) +'</clGreen>')
      .AddMsg
      .ShowMessages;
end;

procedure TC4DWizardReplaceFilesView.ProcessMsgCancel;
var
  LMsg: string;
begin
  LMsg := FC4DWizardReplaceFilesModel.GetCountReplace.ToString +' replacement in ' +
    FC4DWizardReplaceFilesModel.GetCountArqReplace.ToString + ' files';
  TC4DWizardMessageCustom.GetInstance
    .Clear
    .GroupName(FC4DWizardReplaceFilesModel.GetGroupNameMsg)
    .Style([fsBold])
    .Prefix(DateTimeToStr(Now))
    .Msg(LMsg)
    .AddMsg
    .Color(clRed)
    .Msg('Search canceled before completion')
    .AddMsg
    .ShowMessages;
end;

procedure TC4DWizardReplaceFilesView.rdGroupScopeClick(Sender: TObject);
begin
  Self.ConfScope;
end;

procedure TC4DWizardReplaceFilesView.ConfScope;
begin
  cBoxSearchDirectory.Enabled := TC4DWizardEscope(rdGroupScope.ItemIndex) = TC4DWizardEscope.FilesInDirectories;
  btnSearchDirectory.Enabled := cBoxSearchDirectory.Enabled;
  ckIncludeSubdirectories.Enabled := cBoxSearchDirectory.Enabled;
end;

end.
