unit C4D.Wizard.FormatSource.View;

interface

uses
  C4D.Wizard.Types,
  System.Classes,
  System.SysUtils,
  System.Threading,
  Winapi.Windows,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.StdCtrls,
  C4D.Wizard.Interfaces,
  C4D.Wizard.Messages.Custom.Interfaces,
  C4D.Wizard.Messages.Simple;

type
  TC4DWizardFormatSourceView = class(TForm)
    Panel1: TPanel;
    btnClose: TButton;
    btnFormatSource: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    pnBody: TPanel;
    GroupBox1: TGroupBox;
    ckDisplayResultInMsgTab: TCheckBox;
    ckShowConfimationBeforeReplace: TCheckBox;
    rdGroupScope: TRadioGroup;
    Bevel2: TBevel;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    btnSearchDirectory: TButton;
    cBoxSearchDirectory: TComboBox;
    ckIncludeSubdirectories: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnFormatSourceClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure rdGroupScopeClick(Sender: TObject);
    procedure btnSearchDirectoryClick(Sender: TObject);
  private
    FListNewFile: TStringList;
    FC4DWizardModelFilesLoop: IC4DWizardModelFilesLoop;
    FFilePath: string;
    FCountError: Integer;
    FCountAlterFiles: Integer;
    FMsg: IC4DWizardMessagesSimple;
    procedure WriteConfigurationScreen;
    procedure ReadConfigurationScreen;
    procedure WaitingFormON;
    procedure WaitingFormOFF;
    procedure DoFormatSource(AInfoFile: TC4DWizardInfoFile);
    procedure ShowMsgSuccess;
    procedure ProcessMsgCancel;
    procedure ReplaceInFileClosed;
    procedure LoopInLinesUnit(const AStrListUnit: TStringList);
    procedure ProcessMsgError(const AMessage: string);
    function GetGroupNameMsg: string;
    procedure ProcessMsg;
    procedure ConfScope;
    procedure ProcessTwoPoints(var AStrLine: string);
    procedure RemoveSpaceExtraBefore(var AStrLine: string; const ASep: string);
    procedure RemoveSpaceExtraAfter(var AStrLine: string; const ASep: string);
    procedure RemoveSpaceExtra(var AStrLine: string; const ASep: string);
  public

  end;

implementation

uses
  C4D.Wizard.Model.Files.Loop,
  C4D.Wizard.Model.IniFile.Components,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

{$R *.dfm}

procedure TC4DWizardFormatSourceView.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardFormatSourceView, Self);
  FListNewFile := TStringList.Create;
  FC4DWizardModelFilesLoop := TC4DWizardModelFilesLoop.New;
  FMsg := TC4DWizardMessagesSimple.New;
end;

procedure TC4DWizardFormatSourceView.FormShow(Sender: TObject);
begin
  Self.WaitingFormOFF;

  cBoxSearchDirectory.Clear;

  Self.ReadConfigurationScreen;
  Self.ConfScope;

  if(cBoxSearchDirectory.Items.Count >= 0)then
    cBoxSearchDirectory.ItemIndex := 0;

  btnClose.SetFocus;
end;

procedure TC4DWizardFormatSourceView.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TC4DWizardFormatSourceView.WriteConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Write(rdGroupScope)
    .Write(ckShowConfimationBeforeReplace)
    .Write(ckDisplayResultInMsgTab)
    .Write(cBoxSearchDirectory)
    .Write(ckIncludeSubdirectories);
end;

procedure TC4DWizardFormatSourceView.ReadConfigurationScreen;
begin
  TC4DWizardModelIniFileComponents
    .New(Self.Name)
    .Read(rdGroupScope, 0)
    .Read(ckShowConfimationBeforeReplace, True)
    .Read(ckDisplayResultInMsgTab, True)
    .Read(cBoxSearchDirectory, '')
    .Read(ckIncludeSubdirectories, True);
end;

procedure TC4DWizardFormatSourceView.WaitingFormON;
begin
  Screen.Cursor := crHourGlass;
  pnBody.Enabled := False;
  btnFormatSource.Enabled := False;
  btnClose.Enabled := False;
  btnCancel.Enabled := True;
end;

procedure TC4DWizardFormatSourceView.WaitingFormOFF;
begin
  Screen.Cursor := crDefault;
  pnBody.Enabled := True;
  btnFormatSource.Enabled := True;
  btnClose.Enabled := True;
  btnCancel.Enabled := False;
end;

procedure TC4DWizardFormatSourceView.btnCancelClick(Sender: TObject);
begin
  FC4DWizardModelFilesLoop.Cancel;
end;

procedure TC4DWizardFormatSourceView.btnCloseClick(Sender: TObject);
begin
  Self.Close;
  Self.ModalResult := mrCancel;
end;

procedure TC4DWizardFormatSourceView.btnFormatSourceClick(Sender: TObject);
var
  LTask: ITask;
  LC4DWizardEscope: TC4DWizardEscope;
begin
  if(ckShowConfimationBeforeReplace.Checked)then
    if(not TC4DWizardUtils.ShowQuestion('Confirm format source?'))then
      Exit;

  if(rdGroupScope.ItemIndex = 2)then
  begin
    if(Trim(cBoxSearchDirectory.Text).IsEmpty)then
      TC4DWizardUtils.ShowMsgAndAbort('Directories for Search not informed', cBoxSearchDirectory);
  end;

  FCountError := 0;
  FCountAlterFiles := 0;

  case rdGroupScope.ItemIndex of
    0: LC4DWizardEscope := TC4DWizardEscope.FilesInGroup;
    1: LC4DWizardEscope := TC4DWizardEscope.FilesInProject;
    2: LC4DWizardEscope := TC4DWizardEscope.FilesInDirectories;
  end;

  LTask := TTask.Create(
    procedure
    begin
      Self.WaitingFormON;
      try
        try
          FC4DWizardModelFilesLoop
            .Extensions([TC4DExtensionsFiles.PAS])
            .Escope(LC4DWizardEscope)
            .DirectoryForSearch(cBoxSearchDirectory.Text)
            .IncludeSubdirectories(ckIncludeSubdirectories.Checked)
            .LoopInFiles(Self.DoFormatSource);
        except
          on E: Exception do
            TThread.Synchronize(nil,
              procedure
              begin
                TC4DWizardUtils.ShowMsg('It was not possible to execute the Format Source in the files.' + sLineBreak +
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

            {if(not FC4DWizardModelFilesLoop.Canceled)then
            begin
              Self.Close;
              Self.ModalResult := mrOk;
            end;}
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

procedure TC4DWizardFormatSourceView.btnSearchDirectoryClick(Sender: TObject);
begin
  cBoxSearchDirectory.Text := TC4DWizardUtils.SelectFolder(cBoxSearchDirectory.Text);
end;

procedure TC4DWizardFormatSourceView.DoFormatSource(AInfoFile: TC4DWizardInfoFile);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      try
        FFilePath := AInfoFile.Path;
        Self.ReplaceInFileClosed;
      except
        on E: Exception do
          Self.ProcessMsgError(E.Message);
      end;
    end);
end;

procedure TC4DWizardFormatSourceView.ReplaceInFileClosed;
var
  LStrListUnit: TStringList;
begin
  LStrListUnit := TStringList.Create;
  try
    LStrListUnit.LoadFromFile(FFilePath);
    Self.LoopInLinesUnit(LStrListUnit);
    if(LStrListUnit.Text <> FListNewFile.Text)then
    begin
      FListNewFile.SavetoFile(FFilePath);
      Inc(FCountAlterFiles);
      Self.ProcessMsg;
    end;
  finally
    LStrListUnit.Free;
    FListNewFile.Clear;
  end;
end;

procedure TC4DWizardFormatSourceView.LoopInLinesUnit(const AStrListUnit: TStringList);
var
  LNumLine: Integer;
  LStrLine: string;
  LLinePriorEmpty: Boolean;
  LImplementationIni: Boolean;
  LBlankSpaceInBegin: Integer;
  LNumSpaceToRemove: Integer;
  LNumSpaceRemoveLinePrior: Integer;
  LStrPriorLine: string;
  LTryIni: Boolean;
  LTryFinallyOrExceptIni: Boolean;
  LTryBlankSpaceInBegin: Integer;
  LTControllerIni: Boolean;
  LTControllerIniBlankSpaceInBegin: Integer;
  LLinePriorNumSpaceBegin: Integer;
  LStr: string;
  LQuoteIni: Boolean;
begin
  try
    FListNewFile.Clear;
    LLinePriorEmpty := False;
    LImplementationIni := False;
    LNumSpaceRemoveLinePrior := 0;
    LTryIni := False;
    LTryFinallyOrExceptIni := False;
    LTryBlankSpaceInBegin := 0;
    LTControllerIni := False;
    LTControllerIniBlankSpaceInBegin := 0;
    LLinePriorNumSpaceBegin := 0;
    LQuoteIni := False;
    for LNumLine := 0 to Pred(AStrListUnit.Count) do
    begin
      LStrLine := AStrListUnit.Strings[LNumLine];
      //PARA NAO DUPLICAR QUEBRA DE LINHA
      if(LLinePriorEmpty)and(LStrLine.Trim.IsEmpty)then
        Continue;

      {$REGION 'IMPLEMENTATION'}
      if(LStrLine.ToLower = 'implementation')then
        LImplementationIni := True;

      //ATE O IMPLEMENTATION NAO FAZ ALTERACOES
      if(not LImplementationIni)then
      begin
        FListNewFile.Add(LStrLine);
        Continue;
      end;
      {$ENDREGION}

      {$REGION 'ESPACOS DO COMECO'}
      LBlankSpaceInBegin := TC4DWizardUtils.BlankSpaceInBegin(LStrLine);
      LNumSpaceToRemove := 0;
      //PRIMEIROS CARACTERES NAO VAZIO NÃO FOREM ASPA, IfThen, sLineBreak
      if(copy(LStrLine.TrimLeft, 1, 1) <> Chr(39))
        and(copy(LStrLine.TrimLeft.ToLower, 1, 6) <> 'ifthen')
        and(copy(LStrLine.TrimLeft.ToLower, 1, 10) <> 'slinebreak')
      then
      begin
        case LBlankSpaceInBegin of
          01: LStrLine := ' ' + LStrLine;

          03: LNumSpaceToRemove := 1;
          05: LNumSpaceToRemove := 1; //SE ANTERIOR FOI 3

          06: LNumSpaceToRemove := 2;
          07: LNumSpaceToRemove := 1; //SE ANTERIOR FOI 4
          08: LNumSpaceToRemove := 2; //SE ANTERIOR FOI 6

          09:
          begin
            LStr := TC4DWizardUtils.RemoveSpacesAll(LStrLine);
            //se 1:, 2: ...
            if(copy(LStr, 2, 1) = ':')or(copy(LStr, 3, 1) = ':')then
              LNumSpaceToRemove := 1
            else
              LNumSpaceToRemove := 3;
          end;
          10: LNumSpaceToRemove := 2; //SE ANTERIOR FOI 7
          11: LNumSpaceToRemove := 3;

          12: LNumSpaceToRemove := 4;
          13: LNumSpaceToRemove := 3; //SE ANTERIOR FOI 10
          14: LNumSpaceToRemove := 4; //SE ANTERIOR FOI 10

          15: LNumSpaceToRemove := 5;
          16: LNumSpaceToRemove := 4;
          17: LNumSpaceToRemove := 5;

          18: LNumSpaceToRemove := 6;
          19: LNumSpaceToRemove := 5;
          20: LNumSpaceToRemove := 6;

          21: LNumSpaceToRemove := 7;
          22: LNumSpaceToRemove := 6;
          23: LNumSpaceToRemove := 7;

          24: LNumSpaceToRemove := 8;
          25: LNumSpaceToRemove := 7;
          26: LNumSpaceToRemove := 8;
        end;
      end;

      //SE NAO E PARA REMOVER ESPACOS DO COMECO
      if(LNumSpaceToRemove <= 0)//and(LBlankSpaceInBegin < 30)
        and(LBlankSpaceInBegin > 4) //NUM DE ESPACO EM BRANCOS, MAIOR QUE 4
        //PRIMEIROS CARACTERES NAO VAZIO FOR ASPA OU IfThen
        //and((copy(LStrLine.TrimLeft, 1, 1) = Chr(39))or(copy(LStrLine.TrimLeft.ToLower, 1, 6) = 'ifthen'))
        //ULTIMO CARACTER NAO VAZIO NÃO FOR ASPA ;
        and(copy(LStrLine.TrimRight, (LStrLine.TrimRight.Length - 1), 1) <> ';')
      then
        LNumSpaceToRemove := LNumSpaceRemoveLinePrior
      else
        LNumSpaceRemoveLinePrior := LNumSpaceToRemove;

      if(LNumSpaceToRemove > 0)then
        TC4DWizardUtils.RemoveBlankSpaceInBegin(LStrLine, LNumSpaceToRemove);
      {$ENDREGION}

      {$REGION 'REMOVE ESPACOS ANTES E DEPOIS'}
      //Self.RemoveSpaceExtra(LStrLine, ':');
      Self.RemoveSpaceExtra(LStrLine, ':=');
      Self.RemoveSpaceExtra(LStrLine, '+');

      Self.ProcessTwoPoints(LStrLine);
      {$ENDREGION}

      {$REGION 'Try'}
      //SE INICIO DO TRY
      if(LStrLine.Trim.ToLower.Equals('try'))then
      begin
        LTryIni := True;
        LTryBlankSpaceInBegin := TC4DWizardUtils.BlankSpaceInBegin(LStrLine);
      end
      else if(LTryIni)then
      begin
        if(LStrLine.Trim.ToLower.Contains('finally'))or(LStrLine.Trim.ToLower.Contains('except'))then
          LTryFinallyOrExceptIni := True;

        //SE JA PASSOU PELO finally OU except E ACHAR UM END
        if(LTryFinallyOrExceptIni)and(LStrLine.Trim.ToLower.Contains('end;'))then
          LTryIni := False;

        if(LTryIni)then
        begin
          if(not LStrLine.Trim.ToLower.Contains('finally'))and( not LStrLine.Trim.ToLower.Contains('except'))then
            if(TC4DWizardUtils.BlankSpaceInBegin(LStrLine) <= LTryBlankSpaceInBegin)then
              LStrLine := StringOfChar(' ', LTryBlankSpaceInBegin + 2) + LStrLine.TrimLeft;
        end;
      end;
      {$ENDREGION}

      {$REGION 'TController'}
      //SE CONTEM tcontroller.new E NÃO TEM ;
      if(LStrLine.ToLower.Contains('tcontroller.new'))and(not LStrLine.Contains(';'))then
      begin
        LTControllerIni := True;
        LTControllerIniBlankSpaceInBegin := TC4DWizardUtils.BlankSpaceInBegin(LStrLine);
      end
      else if(LTControllerIni)then
      begin
        if(TC4DWizardUtils.BlankSpaceInBegin(LStrLine) > LTControllerIniBlankSpaceInBegin)then
          LStrLine := StringOfChar(' ', LTControllerIniBlankSpaceInBegin + 2) + LStrLine.TrimLeft;

        if(LStrLine.Contains(';'))then
          LTControllerIni := False;
      end;
      {$ENDREGION}

      {$REGION 'Aspas-ou-IfThen'}
      //SE PRIMEIROS CARACTERES NAO VAZIO FOR ASPA OU IfThen
      LStr := LStrLine.TrimLeft.ToLower;
      if((copy(LStr, 1, 1) = Chr(39))or(copy(LStr, 1, 6) = 'ifthen'))then
      begin
        //SE ESPACO ATUAL MAIOR QUE ESPACO DA ULTIMA LINHA
        if(TC4DWizardUtils.BlankSpaceInBegin(LStrLine) > LLinePriorNumSpaceBegin)then
        begin
          if(LQuoteIni)then
            LStrLine := StringOfChar(' ', LLinePriorNumSpaceBegin) + LStrLine.TrimLeft
          else
          begin
            LStrLine := StringOfChar(' ', LLinePriorNumSpaceBegin + 2) + LStrLine.TrimLeft;
            LQuoteIni := True;
          end;
        end;
      end
      else
        LQuoteIni := False;
      {$ENDREGION}

      FListNewFile.Add(LStrLine);
      LLinePriorNumSpaceBegin := TC4DWizardUtils.BlankSpaceInBegin(LStrLine);
      LStrPriorLine := LStrLine;
      LLinePriorEmpty := LStrLine.Trim.IsEmpty;
    end;
  except
    on E: Exception do
      raise Exception.Create('The error occurred: ' + E.Message + sLineBreak + '. File: ' + FFilePath);
  end;
end;

procedure TC4DWizardFormatSourceView.RemoveSpaceExtra(var AStrLine: string; const ASep: string);
begin
  Self.RemoveSpaceExtraBefore(AStrLine, ASep);
  Self.RemoveSpaceExtraAfter(AStrLine, ASep);
end;

procedure TC4DWizardFormatSourceView.RemoveSpaceExtraBefore(var AStrLine: string; const ASep: string);
var
  LHas: Boolean;
  LStrFind: string;
begin
  LStrFind := ' ' + ASep;
  LHas := True;
  while(LHas)do
  begin
    AStrLine := AStrLine.Replace(LStrFind, ASep, [rfIgnoreCase]);
    LHas := AStrLine.Contains(LStrFind);
  end;
  AStrLine := AStrLine.Replace(ASep, LStrFind, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TC4DWizardFormatSourceView.RemoveSpaceExtraAfter(var AStrLine: string; const ASep: string);
var
  LHas: Boolean;
  LStrFind: string;
begin
  LStrFind := ASep + ' ';
  LHas := True;
  while(LHas)do
  begin
    AStrLine := AStrLine.Replace(LStrFind, ASep, [rfIgnoreCase]);
    LHas := AStrLine.Contains(LStrFind);
  end;
  AStrLine := AStrLine.Replace(ASep, LStrFind, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TC4DWizardFormatSourceView.ProcessTwoPoints(var AStrLine: string);
var
  LHas: Boolean;
begin
  LHas := True;
  while(LHas)do
  begin
    AStrLine := AStrLine.Replace(' ;', ';');
    LHas := AStrLine.Contains(' ;')
  end;
end;

procedure TC4DWizardFormatSourceView.ShowMsgSuccess;
var
  LMsg: string;
begin
  LMsg := 'Format Source complete. %s Format in X files';

  TC4DWizardUtils.ShowV(Format(LMsg, [sLineBreak]));

  if(ckDisplayResultInMsgTab.Checked)then //and(FC4DWizardUsesOrganization.CountAlterFiles > 0)then
    TC4DWizardMessagesSimple.New
      .FileName('')
      .Line(0)
      .Column(0)
      .GroupName('Teste Format Source')
      .Msg(Format(LMsg, ['']))
      .AddMsg
      .ShowMessages('Mensagem');
end;

procedure TC4DWizardFormatSourceView.ProcessMsgCancel;
begin
  TC4DWizardMessagesSimple.New
    .GroupName('Teste Format Source')
    .Msg('Format Source in X files')
    .AddMsg
    .Msg('Format Source canceled before completion')
    .AddMsg
    .ShowMessages;
end;

function TC4DWizardFormatSourceView.GetGroupNameMsg: string;
begin
  Result := 'Format Source';
end;

procedure TC4DWizardFormatSourceView.ProcessMsg;
var
  LGroupName: string;
begin
  if(not ckDisplayResultInMsgTab.Checked)then
    Exit;

  LGroupName := Self.GetGroupNameMsg;
  if(FCountAlterFiles <= 1)then
    FMsg.ClearMessageGroup(LGroupName);

  FMsg
    .FileName(FFilePath)
    .Line(0)
    .Column(0)
    .GroupName(LGroupName)
    .Msg('')
    .AddMsg;
end;

procedure TC4DWizardFormatSourceView.ProcessMsgError(const AMessage: string);
var
  LGroupName: string;
begin
  Inc(FCountError);

  if(not ckDisplayResultInMsgTab.Checked)then
    Exit;

  LGroupName := Self.GetGroupNameMsg;
  if(FCountAlterFiles <= 1)then
    FMsg.ClearMessageGroup(LGroupName);

  FMsg
    .Prefix('')
    .FileName(FFilePath)
    .Line(0)
    .Column(0)
    .GroupName(LGroupName)
    .Msg(Format('%s%s%s', ['<clRed><n>', 'An error occurred when processing file. Message: ' + AMessage, '</n></clRed>']))
    .AddMsg;
end;

procedure TC4DWizardFormatSourceView.rdGroupScopeClick(Sender: TObject);
begin
  Self.ConfScope;
end;

procedure TC4DWizardFormatSourceView.ConfScope;
begin
  cBoxSearchDirectory.Enabled := rdGroupScope.ItemIndex = 2;
  btnSearchDirectory.Enabled := cBoxSearchDirectory.Enabled;
  ckIncludeSubdirectories.Enabled := cBoxSearchDirectory.Enabled;
end;

end.
