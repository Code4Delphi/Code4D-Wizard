unit C4D.Wizard.View.About;

interface

uses
  System.Classes,
  System.SysUtils,
  ToolsAPI,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Forms,
  Vcl.Graphics,
  Vcl.Imaging.pngimage,
  Vcl.StdCtrls,
  Vcl.Dialogs,
  Winapi.Windows,
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.Utils.OTA;

type
  TC4DWizardViewAbout = class(TForm)
    pnBody: TPanel;
    Bevel1: TBevel;
    mmMensagem: TMemo;
    Panel2: TPanel;
    pnBackSite: TPanel;
    lbSiteCode4Delphi: TLabel;
    imgLogoC4D: TImage;
    pnBackGithub: TPanel;
    lbGitHubCode4Delphi: TLabel;
    imgGithub: TImage;
    pnButtons: TPanel;
    btnOK: TButton;
    btnTeste: TButton;
    Panel1: TPanel;
    lbDonateToCode4Delphi: TLabel;
    imgDonate: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbSiteCode4DelphiClick(Sender: TObject);
    procedure lbSiteCode4DelphiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure lbSiteCode4DelphiMouseLeave(Sender: TObject);
    procedure lbGitHubCode4DelphiClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTesteClick(Sender: TObject);
    procedure lbDonateToCode4DelphiClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private

  public

  end;

var
  C4DWizardViewAbout: TC4DWizardViewAbout;

implementation

{$R *.dfm}


procedure TC4DWizardViewAbout.FormCreate(Sender: TObject);
begin
  TC4DWizardUtilsOTA.IDEThemingAll(TC4DWizardViewAbout, Self);
end;

procedure TC4DWizardViewAbout.FormShow(Sender: TObject);
begin
  Self.Caption := 'About Code4Delphi Wizard ' + TC4DConsts.SEMANTIC_VERSION;

  mmMensagem.Lines.Clear;
  mmMensagem.Lines.Add(TC4DConsts.ABOUT_COPY_RIGHT);
  mmMensagem.Lines.Add(TC4DConsts.ABOUT_DESCRIPTION);
  mmMensagem.Lines.Add(TC4DConsts.SEMANTIC_VERSION_LB);
  mmMensagem.Lines.Add(TC4DConsts.WIZARD_LICENSE);
end;

procedure TC4DWizardViewAbout.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case(Key)of
    VK_F4:
      if(ssAlt in Shift)then
        Key := 0;
    VK_ESCAPE:
      if(Shift = [])then
        btnOK.Click;
  end;
end;

procedure TC4DWizardViewAbout.btnOKClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('http://www.code4delphi.com.br');
end;

procedure TC4DWizardViewAbout.lbGitHubCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('https://github.com/code4delphi');
end;

procedure TC4DWizardViewAbout.lbDonateToCode4DelphiClick(Sender: TObject);
begin
  TC4DWizardUtils.OpenLink('https://pag.ae/7ZhEY1xKr');
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiMouseLeave(Sender: TObject);
begin
  //*SEVERAL
  TLabel(Sender).Font.Color := TC4DWizardUtilsOTA.ActiveThemeColorDefaul;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style - [fsUnderline];
end;

procedure TC4DWizardViewAbout.lbSiteCode4DelphiMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  //*SEVERAL
  TLabel(Sender).Font.Color := clRed;
  TLabel(Sender).Font.Style := TLabel(Sender).Font.Style + [fsUnderline];
end;

procedure TC4DWizardViewAbout.btnTesteClick(Sender: TObject);
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTASourceEditor: IOTASourceEditor;
  LFileName: string;
  i: integer;

  LIOTAModule: IOTAModule;
begin
  LIOTAModule := TC4DWizardUtilsOTA.GetCurrentModule;
  LFileName := '';
  LIOTASourceEditor := TC4DWizardUtilsOTA.GetIOTASourceEditor(LIOTAModule);
  if LIOTASourceEditor <> nil then
    LFileName := LIOTASourceEditor.FileName;

  TC4DWizardUtils.ShowMsg('Atual: ' + LFileName);
  //**

  LIOTAModuleServices := TC4DWizardUtilsOTA.GetIOTAModuleServices;
  if(not Assigned(LIOTAModuleServices))then
    raise Exception.Create('No Units Opened was found');

  mmMensagem.Lines.Clear;
  for i := 0 to pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.GetModule(i);

    LIOTASourceEditor := TC4DWizardUtilsOTA.GetIOTASourceEditor(LIOTAModule);
    if LIOTASourceEditor <> nil then
      if LIOTASourceEditor.CreateReader <> nil then
        mmMensagem.Lines.Add(LIOTAModule.FileName);



    {for LContFile := 0 to pred(LIOTAModule.GetModuleFileCount)do
    begin
      //LIOTAEditor := LIOTAModule.GetModuleFileEditor(LContFile);
      //if(Supports(LIOTAEditor, IOTASourceEditor, LIOTASourceEditor))then
      //begin
      //  Self.ListFilesAdd(LIOTAEditor.FileName);
      //  Break;
      //end;
    end;}
  end;
end;

function CnOtaGetFileEditorForModule(Module: IOTAModule; Index: Integer): IOTAEditor;
begin
  Result := nil;
  if not Assigned(Module) then
    Exit;

  try
    {$IFDEF BCB5}
    if IsCpp(Module.FileName) and (Module.GetModuleFileCount = 2) and (Index = 1) then
      Index := 2;
    {$ENDIF}
    Result := Module.GetModuleFileEditor(Index);
  except
    Result := nil;
  end;
end;

function CnOtaIsFileOpen(const FileName: string): Boolean;
var
  ModuleServices: IOTAModuleServices;
  Module: IOTAModule;
  FileEditor: IOTAEditor;
  I: Integer;
begin
  Result := False;

  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  if ModuleServices = nil then
    Exit;

  Module := ModuleServices.FindModule(FileName);
  if Assigned(Module) then
  begin
    for I := 0 to Module.GetModuleFileCount-1 do
    begin
      FileEditor := CnOtaGetFileEditorForModule(Module, I);
      Assert(Assigned(FileEditor));

      Result := CompareText(FileName, FileEditor.FileName) = 0;
      if Result then
        Exit;
    end;
  end;
end;

procedure TC4DWizardViewAbout.Button1Click(Sender: TObject);
var
  LIOTAModuleServices: IOTAModuleServices;
  I: Integer;
  LIOTAModule: IOTAModule;
  LIOTAEditor: IOTAEditor;
begin
  mmMensagem.Lines.Clear;

  LIOTAModuleServices := BorlandIDEServices as IOTAModuleServices;
  for I := 0 to LIOTAModuleServices.ModuleCount - 1 do
  begin
    LIOTAModule := LIOTAModuleServices.Modules[I];
    LIOTAEditor := LIOTAModule.CurrentEditor;
    if LIOTAEditor = nil then
      Continue;

    if not CnOtaIsFileOpen(LIOTAModule.FileName) then
      Continue;

    if not TC4DWizardUtilsOTA.FileIsOpenInIDE(LIOTAModule.FileName) then
      Continue;

    mmMensagem.Lines.Add(LIOTAModule.FileName);
  end;
end;

procedure TC4DWizardViewAbout.Button2Click(Sender: TObject);
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModule: IOTAModule;
  LIOTAEditor: IOTAEditor;
  i: Integer;
  LIOTASourceEditor: IOTASourceEditor;
  LIOTAEditView: IOTAEditView;
begin
  mmMensagem.Lines.Clear;

  LIOTAModuleServices := BorlandIDEServices as IOTAModuleServices;

  for i := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.Modules[i];

    mmMensagem.Lines.Add(LIOTAModule.FileName +
      ' / ' + LIOTAModule.OwnerCount.ToString + ' / ' + LIOTAModule.OwnerModuleCount.ToString +
      ' / ' + LIOTAModule.HasCoClasses.ToString(TUseBoolStrs.True) +
      ' / ' + LIOTAModule.ModuleFileCount.ToString +
      ' / ' + LIOTAModule.FileSystem);


    LIOTAEditor := LIOTAModule.CurrentEditor;

    LIOTASourceEditor := TC4DWizardUtilsOTA.GetIOTASourceEditor(LIOTAModule);
    if(LIOTASourceEditor <> nil)then
    begin
      mmMensagem.Lines.Add(' - LIOTASourceEditor: ' + LIOTASourceEditor.GetSubViewCount.ToString +
        ' / A: ' + LIOTASourceEditor.GetSubViewIndex.ToString +
        ' / B: ' + LIOTASourceEditor.GetLinesInBuffer.ToString +
        ' / C: ' + LIOTASourceEditor.EditViewCount.ToString);


      LIOTAEditView := TC4DWizardUtilsOTA.GetIOTAEditView(LIOTASourceEditor);
    end;




    {if LIOTAModule.OwnerCount > 0 then
      mmMensagem.Lines.Add(' - Owners: ' + LIOTAModule.Owners[0].FileName);

    if LIOTAModule.OwnerModuleCount > 0 then
      mmMensagem.Lines.Add(' - Owners: ' + LIOTAModule.OwnerModules[0].FileName);}

  end;
end;

procedure TC4DWizardViewAbout.Button3Click(Sender: TObject);
var
  LIOTAModuleServices: IOTAModuleServices;
  LIOTAModule: IOTAModule;
  LIOTASourceEditor: IOTASourceEditor;
  i: Integer;
begin
  mmMensagem.Lines.Clear;

  LIOTAModuleServices := BorlandIDEServices as IOTAModuleServices;
  for i := 0 to Pred(LIOTAModuleServices.ModuleCount) do
  begin
    LIOTAModule := LIOTAModuleServices.Modules[i];

    LIOTASourceEditor := TC4DWizardUtilsOTA.GetIOTASourceEditor(LIOTAModule);
    if(LIOTASourceEditor = nil)then
      Continue;

    if LIOTASourceEditor.EditViewCount <= 0 then
      Continue;

    mmMensagem.Lines.Add(LIOTAModule.FileName + ' / C: ' + LIOTASourceEditor.EditViewCount.ToString);
  end;
end;

end.
