object C4DWizardGroupsAddEditView: TC4DWizardGroupsAddEditView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Groups XXX'
  ClientHeight = 179
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 144
    Width = 450
    Height = 35
    Align = alBottom
    BevelEdges = [beLeft, beRight, beBottom]
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    TabOrder = 0
    object btnConfirm: TButton
      AlignWithMargins = True
      Left = 222
      Top = 2
      Width = 110
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Confirm'
      TabOrder = 0
      OnClick = btnConfirmClick
      ExplicitLeft = 224
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 335
      Top = 2
      Width = 110
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
      ExplicitLeft = 336
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 450
    Height = 144
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object Label1: TLabel
      Left = 32
      Top = 34
      Width = 58
      Height = 13
      Caption = 'Name group'
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 140
      Width = 450
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object edtName: TEdit
      Left = 32
      Top = 50
      Width = 377
      Height = 21
      TabOrder = 0
    end
    object ckDefault: TCheckBox
      Left = 32
      Top = 88
      Width = 58
      Height = 17
      Cursor = crHandPoint
      Caption = 'Default'
      TabOrder = 1
    end
  end
end
