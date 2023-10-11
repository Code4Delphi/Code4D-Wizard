unit C4D.Wizard.Find.View;

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
  C4D.Wizard.Find.Interfaces,
  C4D.Wizard.Find.Model,
  C4D.Wizard.Model.Files.Loop;

type
  TC4DWizardFindView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnFind: TButton;
    btnCancel: TButton;
    pnBody: TPanel;
    Bevel1: TBevel;
    Bevel4: TBevel;
    gBoxText: TGroupBox;
    Label2: TLabel;
    rdGroupScope: TRadioGroup;
    Panel2: TPanel;
    Bevel3: TBevel;
    gBoxOptions: TGroupBox;
    ckCaseSensitive: TCheckBox;
    ckWholeWordOnly: TCheckBox;
    gBoxExtension: TGroupBox;
    ckExtensionPas: TCheckBox;
    ckExtensionDFM: TCheckBox;
    ckExtensionFMX: TCheckBox;
    ckExtensionDPRandDPK: TCheckBox;
    ckExtensionDPROJ: TCheckBox;
    ckCloseFormFinished: TCheckBox;
    cBoxSearchFor: TComboBox;
    GroupBox1: TGroupBox;
    cBoxTextIgnore: TComboBox;
    Bevel2: TBevel;
    Bevel5: TBevel;
    cBoxTextIgnoreLocal: TComboBox;
    GroupBox2: TGroupBox;
    btnSearchDirectory: TButton;
    cBoxSearchDirectory: TComboBox;
    Label1: TLabel;
    Bevel6: TBevel;
    ckIncludeSubdirectories: TCheckBox;
    ckDisplayAccountant: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCloseClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cBoxSearchForKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cBoxTextIgnoreLocalClick(Sender: TObject);
    procedure btnSearchDirectoryClick(Sender: TObject);
    procedure rdGroupScopeClick(Sender: TObject);
  private
    FC4DWizardFindModel: IC4DWizardFindModel;
    FC4DWizardModelFilesLoop: IC4DWizardModelFilesLoop;
    procedure DoFind(AInfoFile: TC4DWizardInfoFile);
    function GetExtensions: TC4DExtensionsOfFiles;
    procedure ReadConfigurationScreen;
    procedure WriteConfigurationScreen;
    procedure WaitingFormON;
    procedure WaitingFormOFF;
    procedure ShowMsgSuccess;
    procedure ProcessMsgCancel;
    procedure ReloadConfigurationScreen;
    procedure ConfTextIgnore;
    procedure ConfScope;
  public

  end;

var
  C4DWizardFindView: TC4DWizardFindView;

implementation

uses
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.Messages.Custom;

{$R *.dfm}


procedure TC4DWizardFindView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardFindView, Self);
  FC4DWizardFindModel := TC4DWizardFindModel.New;
  FC4DWizardModelFilesLoop := TC4DWizardModelFilesLoop.New;
  TC4DWizardUtils.ExtensionFillTStringsWithValid(rdGroupScope.Items);
end;

procedure TC4DWizardFindView.FormShow(Sender: TObject);
var
  LBlockTextSelect: string;
begin
  Self.WaitingFormOFF;

  cBoxTextIgnore.Clear;
  cBoxSearchFor.Clear;
  cBoxSearchDirectory.Clear;
  LBlockTextSelect := TC4DWizardUtilsOTA.GetBlockTextSelect;
  if(not LBlockTextSelect.Trim.IsEmpty)then
    cBoxSearchFor.Items.Add(LBlockTextSelect);

  Self.ReadConfigurationScreen;

  cBoxTextIgnoreLocal.ItemIndex := 0;
  Self.ConfTextIgnore;
  Self.ConfScope;

  if(cBoxSearchDirectory.Items.Count >= 0)then
    cBoxSearchDirectory.ItemIndex := 0;

  if(cBoxSearchFor.Items.Count >= 0)then
    cBoxSearchFor.ItemIndex := 0;
  cBoxSearchFor.SetFocus;
end;

procedure TC4DWizardFindView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardFindView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(cBoxSearchFor)
    .Write(ckCaseSensitive)
    .Write(ckWholeWordOnly)
    .Write(ckDisplayAccountant)
    .Write(ckExtensionPas)
    .Write(ckExtensionDFM)
    .Write(ckExtensionFMX)
    .Write(ckExtensionDPRandDPK)
    .Write(ckExtensionDPROJ)
    .Write(rdGroupScope)
    .Write(ckCloseFormFinished)
    .Write(cBoxTextIgnore)
    .Write(cBoxSearchDirectory)
    .Write(ckIncludeSubdirectories);
end;

procedure TC4DWizardFindView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(cBoxSearchFor, '')
    .Read(ckCaseSensitive, False)
    .Read(ckWholeWordOnly, False)
    .Read(ckDisplayAccountant, True)
    .Read(ckExtensionPas, True)
    .Read(ckExtensionDFM, False)
    .Read(ckExtensionFMX, False)
    .Read(ckExtensionDPRandDPK, False)
    .Read(ckExtensionDPROJ, False)
    .Read(rdGroupScope, 0)
    .Read(ckCloseFormFinished, True)
    .Read(cBoxTextIgnore, '')
    .Read(cBoxSearchDirectory, '')
    .Read(ckIncludeSubdirectories, True);
end;

procedure TC4DWizardFindView.WaitingFormON;
begin
  Screen.Cursor := crHourGlass;
  pnBody.Enabled := False;
  ckCloseFormFinished.Enabled := False;
  btnFind.Enabled := False;
  btnClose.Enabled := False;
  btnCancel.Enabled := True;
end;

procedure TC4DWizardFindView.WaitingFormOFF;
begin
  Screen.Cursor := crDefault;
  pnBody.Enabled := True;
  ckCloseFormFinished.Enabled := True;
  btnFind.Enabled := True;
  btnClose.Enabled := True;
  btnCancel.Enabled := False;
end;

procedure TC4DWizardFindView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

function TC4DWizardFindView.GetExtensions: TC4DExtensionsOfFiles;
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

procedure TC4DWizardFindView.btnFindClick(Sender: TObject);
var
  LC4DWizardExtensions: TC4DExtensionsOfFiles;
  LC4DTextIgnore: string;
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

  LC4DTextIgnore := '';
  if(TC4DTextIgnoreEscope(cBoxTextIgnoreLocal.ItemIndex) <> TC4DTextIgnoreEscope.None)then
  begin
    LC4DTextIgnore := Trim(cBoxTextIgnore.Text);
    if(LC4DTextIgnore.Trim.IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Text to ignore not informed', cBoxTextIgnore);
  end;

  LTask := TTask.Create(
    procedure
    begin
      Self.WaitingFormON;
      try
        try
          FC4DWizardFindModel
            .ResetValues
            .WholeWordOnly(ckWholeWordOnly.Checked)
            .DisplayAccountant(ckDisplayAccountant.Checked)
            .CaseSensitive(ckCaseSensitive.Checked)
            .SearchFor(cBoxSearchFor.Text)
            .TextIgnoreEscope(TC4DTextIgnoreEscope(cBoxTextIgnoreLocal.ItemIndex))
            .TextIgnore(LC4DTextIgnore);

          FC4DWizardModelFilesLoop
            .Extensions(LC4DWizardExtensions)
            .Escope(TC4DWizardEscope(rdGroupScope.ItemIndex))
            .DirectoryForSearch(cBoxSearchDirectory.Text)
            .IncludeSubdirectories(ckIncludeSubdirectories.Checked)
            .LoopInFiles(Self.DoFind);
        except
          on E: Exception do
            TThread.Synchronize(nil,
              procedure
              begin
                TC4DWizardUtils.ShowMsg('It was not possible to perform the search in the files.' + sLineBreak +
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

            if(not FC4DWizardModelFilesLoop.Canceled)
              and(ckCloseFormFinished.Checked)
              and(FC4DWizardFindModel.GetCountFind > 0)
            then
              btnClose.Click;
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

procedure TC4DWizardFindView.btnSearchDirectoryClick(Sender: TObject);
begin
  cBoxSearchDirectory.Text := TC4DWizardUtils.SelectFolder(cBoxSearchDirectory.Text);
end;

procedure TC4DWizardFindView.ReloadConfigurationScreen;
var
  LStrSearchFor: string;
  LStrSearchDirectory: string;
begin
  LStrSearchFor := cBoxSearchFor.Text;
  LStrSearchDirectory := cBoxSearchDirectory.Text;
  cBoxSearchFor.Clear;
  cBoxSearchDirectory.Clear;

  Self.ReadConfigurationScreen;

  cBoxSearchFor.Text := LStrSearchFor;
  cBoxSearchDirectory.Text := LStrSearchDirectory;
end;

procedure TC4DWizardFindView.cBoxSearchForKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if(Key = VK_RETURN)then
    btnFind.Click;
end;

procedure TC4DWizardFindView.btnCancelClick(Sender: TObject);
begin
  FC4DWizardModelFilesLoop.Cancel;
end;

procedure TC4DWizardFindView.DoFind(AInfoFile: TC4DWizardInfoFile);
begin
  FC4DWizardFindModel.FindInFile(AInfoFile);
end;

procedure TC4DWizardFindView.cBoxTextIgnoreLocalClick(Sender: TObject);
begin
  Self.ConfTextIgnore;
end;

procedure TC4DWizardFindView.ConfTextIgnore;
begin
  cBoxTextIgnore.Enabled := TC4DTextIgnoreEscope(cBoxTextIgnoreLocal.ItemIndex) <> TC4DTextIgnoreEscope.None;
end;

procedure TC4DWizardFindView.ShowMsgSuccess;
begin
  if(FC4DWizardFindModel.GetCountFind <= 0)then
  begin
    TC4DWizardUtils.ShowMsg('Search string '+ QuotedStr(cBoxSearchFor.Text) +' not found');
    Exit;
  end;

  TC4DWizardMessageCustom.GetInstance
    .Clear
    .GroupName(FC4DWizardFindModel.GetGroupNameMsg)
    .Style([fsBold])
    .Prefix(DateTimeToStr(Now))
    .Msg(Format('Find complete for: %s', [cBoxSearchFor.Text]))
    .AddMsg
    .ShowMessages
    .Prefix('')
    .Color(clGreen)
    .Msg(Format('%d found in %d files', [FC4DWizardFindModel.GetCountFind, FC4DWizardFindModel.GetCountArqFind]))
    .AddMsg
    .ShowMessages;

  if(FC4DWizardFindModel.GetCountError > 0)then
    TC4DWizardMessageCustom.GetInstance
      .GroupName(FC4DWizardFindModel.GetGroupNameMsg)
      .Color(clRed)
      .Msg(Format('%d erros occurred', [FC4DWizardFindModel.GetCountError]))
      .AddMsg
      .ShowMessages;
end;

procedure TC4DWizardFindView.ProcessMsgCancel;
begin
  TC4DWizardMessageCustom.GetInstance
    .Clear
    .GroupName(FC4DWizardFindModel.GetGroupNameMsg)
    .Style([fsBold])
    .Prefix(DateTimeToStr(Now))
    .Msg(Format('%d found in %d files', [FC4DWizardFindModel.GetCountFind, FC4DWizardFindModel.GetCountArqFind]))
    .AddMsg
    .Color(clRed)
    .Msg('Search canceled before completion')
    .AddMsg
    .ShowMessages;
end;

procedure TC4DWizardFindView.rdGroupScopeClick(Sender: TObject);
begin
  Self.ConfScope;
end;

procedure TC4DWizardFindView.ConfScope;
begin
  cBoxSearchDirectory.Enabled := TC4DWizardEscope(rdGroupScope.ItemIndex) = TC4DWizardEscope.FilesInDirectories;
  btnSearchDirectory.Enabled := cBoxSearchDirectory.Enabled;
  ckIncludeSubdirectories.Enabled := cBoxSearchDirectory.Enabled;
end;

end.
