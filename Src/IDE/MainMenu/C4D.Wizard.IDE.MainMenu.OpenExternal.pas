unit C4D.Wizard.IDE.MainMenu.OpenExternal;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.Menus,
  C4D.Wizard.OpenExternal.Interfaces,
  C4D.Wizard.OpenExternal,
  C4D.Wizard.OpenExternal.Model,
  System.Generics.Collections,
  C4D.Wizard.Types.ABMenuAction;

type
  TC4DWizardIDEMainMenuOpenExternal = class(TInterfacedObject, IC4DWizardIDEMainMenuOpenExternal)
  private
    FCont: Integer;
    FMenuItemParent: TMenuItem;
    FMenuItemOpenExternal: TMenuItem;
    FList: TObjectList<TC4DWizardOpenExternal>;
    procedure CreateItemMenuMain;
    function CreateSubMenu(const AMenuItemParent: TMenuItem; const AName: string; const ACaption: string; const AOnClick: TNotifyEvent): TMenuItem; overload;
    function CreateSubMenu(const AMenuItemParent: TMenuItem; const AC4DWizardOpenExternal: TC4DWizardOpenExternal): TMenuItem; overload;
    procedure CustomizeClick(Sender: TObject);
    procedure ItemMenuClick(Sender: TObject);
    procedure CreateMenuItemsList;
  protected
    function CreateMenusOpenExternal: IC4DWizardIDEMainMenuOpenExternal;
  public
    class function New(const AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuOpenExternal;
    constructor Create(const AMenuItemParent: TMenuItem);
    destructor Destroy; override;
  end;

implementation

uses
  C4D.Wizard.Consts,
  C4D.Wizard.Utils,
  C4D.Wizard.OpenExternal.View,
  C4D.Wizard.IDE.ImageListMain,
  C4D.Wizard.OpenExternal.Utils;

class function TC4DWizardIDEMainMenuOpenExternal.New(const AMenuItemParent: TMenuItem): IC4DWizardIDEMainMenuOpenExternal;
begin
  Result := Self.Create(AMenuItemParent);
end;

constructor TC4DWizardIDEMainMenuOpenExternal.Create(const AMenuItemParent: TMenuItem);
begin
  FMenuItemParent := AMenuItemParent;
  FList := TObjectList<TC4DWizardOpenExternal>.Create;
  FCont := 0;
end;

destructor TC4DWizardIDEMainMenuOpenExternal.Destroy;
begin
  FList.Free;
  inherited;
end;

function TC4DWizardIDEMainMenuOpenExternal.CreateMenusOpenExternal: IC4DWizardIDEMainMenuOpenExternal;
begin
  Self.CreateItemMenuMain;
  Self.CreateSubMenu(FMenuItemOpenExternal, 'C4DOpenExternalMenuItemCad1', 'Customize...', Self.CustomizeClick);
  Self.CreateSubMenu(FMenuItemOpenExternal, 'C4DOpenExternalSeparator01', '-', {$IF CompilerVersion = 30} TNotifyEvent(nil) {$ELSE} nil {$ENDIF});

  FList.Clear;
  TC4DWizardOpenExternalModel.New.ReadIniFile(
    procedure(AC4DWizardOpenExternal: TC4DWizardOpenExternal)
    var
      LC4DWizardOpenExternal: TC4DWizardOpenExternal;
    begin
      if(not AC4DWizardOpenExternal.Visible)then
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
      LC4DWizardOpenExternal.Created := False;
      FList.Add(LC4DWizardOpenExternal);
    end);
  Self.CreateMenuItemsList;
end;

procedure TC4DWizardIDEMainMenuOpenExternal.CreateMenuItemsList;
var
  LItem: TC4DWizardOpenExternal;
  LListOrder: TList<Integer>;
  LOrder: Integer;
  LMenuItem: TMenuItem;

 procedure AddSubMenuChildrens(const AC4DWizardOpenExternal: TC4DWizardOpenExternal; const AMenuItem: TMenuItem);
 var
   LOrder2: Integer;
   LItem2: TC4DWizardOpenExternal;
   LMenuItem2: TMenuItem;
 begin
   for LOrder2 in LListOrder do
     for LItem2 in FList do
     begin
       if(LItem2.Order = LOrder2)then
         if(not LItem2.Created)and(LItem2.GuidMenuMaster.Trim = AC4DWizardOpenExternal.Guid.Trim)then
         begin
           LMenuItem2 := Self.CreateSubMenu(AMenuItem, LItem2);
           LItem2.Created := True;
           //RETIRA O CLICK DO MENU PAI, PARA NAO EXECUTAR O CLICK AO PASSAR O MOUSE E ATIVAR O SUBMENU
           AMenuItem.OnClick := nil;

           AddSubMenuChildrens(LItem2, LMenuItem2);
         end;
     end;
 end;
begin
  if(FList.Count <= 0)then
    Exit;

  LListOrder := TList<Integer>.Create;
  try
    for LItem in FList do
    begin
      if(LItem.Order <= 0)then
        LItem.Order := 9999;

      if(not LListOrder.Contains(LItem.Order))then //(LItem.Order > 0)and
        LListOrder.Add(LItem.Order);
    end;

    LListOrder.Sort;

    //LACO NA LListOrder PARA ADD PELA ORDEM, ADD OS QUE NAO TEM MENU MASTER, E A CADA MENU MASTER ADD SEU FILHOS
    for LOrder in LListOrder do
      for LItem in FList do
      begin
        if(LItem.Order = LOrder)then
          if(not LItem.Created)and(LITem.GuidMenuMaster.Trim.IsEmpty)then
          begin
            LMenuItem := Self.CreateSubMenu(FMenuItemOpenExternal, LItem);
            LItem.Created := True;

            AddSubMenuChildrens(LItem, LMenuItem);
          end;
      end;

    //ADD TODOS QUE TENHA A ORDEM MAIOR QUE ZERO, E QUE AINDA NAO FORAM ADICIONADOS
    for LOrder in LListOrder do
      for LItem in FList do
      begin
        if(LItem.Order = LOrder)then
          if(not LItem.Created)then
          begin
            LMenuItem := Self.CreateSubMenu(FMenuItemOpenExternal, LItem);
            LItem.Created := True;

            AddSubMenuChildrens(LItem, LMenuItem);
          end;
      end;
  finally
    LListOrder.Free;
  end;
end;

procedure TC4DWizardIDEMainMenuOpenExternal.CreateItemMenuMain;
begin
  FMenuItemOpenExternal := TMenuItem.Create(FMenuItemParent);
  FMenuItemOpenExternal.Name := TC4DConsts.MENU_IDE_OpenExternal_NAME;
  FMenuItemOpenExternal.Caption := TC4DConsts.MENU_IDE_OpenExternal_CAPTION;
  FMenuItemOpenExternal.ImageIndex := TC4DWizardIDEImageListMain.GetInstance.ImgIndexArrowGreen;
  FMenuItemParent.Add(FMenuItemOpenExternal);
end;

function TC4DWizardIDEMainMenuOpenExternal.CreateSubMenu(const AMenuItemParent: TMenuItem; const AName: string; const ACaption: string; const AOnClick: TNotifyEvent): TMenuItem;
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(AMenuItemParent);
  LMenuItem.Name := AName;
  LMenuItem.Caption := ACaption;
  LMenuItem.OnClick := AOnClick;
  LMenuItem.Hint := '';
  LMenuItem.ImageIndex := -1;
  AMenuItemParent.Add(LMenuItem);
  Result := LMenuItem;
end;

function TC4DWizardIDEMainMenuOpenExternal.CreateSubMenu(const AMenuItemParent: TMenuItem; const AC4DWizardOpenExternal: TC4DWizardOpenExternal): TMenuItem;
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := TMenuItem.Create(AMenuItemParent);
  LMenuItem.Name := 'C4DOpenExternalItemMenu' + TC4DWizardUtils.IncInt(FCont).ToString;
  LMenuItem.Caption := AC4DWizardOpenExternal.Description;
  LMenuItem.OnClick := Self.ItemMenuClick;
  LMenuItem.Hint := AC4DWizardOpenExternal.Path + TC4DConsts.OPEN_EXTERNAL_Separator_PARAMETERS + AC4DWizardOpenExternal.Parameters;
  LMenuItem.Shortcut := TextToShortCut(AC4DWizardOpenExternal.Shortcut);
  LMenuItem.ImageIndex := TC4DWizardOpenExternalUtils.GetImageIndexIfExists(AC4DWizardOpenExternal);
  AMenuItemParent.Add(LMenuItem);
  Result := LMenuItem;
end;

procedure TC4DWizardIDEMainMenuOpenExternal.ItemMenuClick(Sender: TObject);
var
  LMenuItem: TMenuItem;
begin
  LMenuItem := GetMenuItemOfSender(Sender);
  if(LMenuItem = nil)then
    Exit;

  TC4DWizardOpenExternalUtils.ClickFromString(LMenuItem.Hint);
end;

procedure TC4DWizardIDEMainMenuOpenExternal.CustomizeClick(Sender: TObject);
begin
  C4DWizardOpenExternalViewShow;
end;

end.
