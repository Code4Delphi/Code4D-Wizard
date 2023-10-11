object C4DWizardBackupImportView: TC4DWizardBackupImportView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Backup Restore Configs'
  ClientHeight = 157
  ClientWidth = 670
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 120
    Width = 670
    Height = 37
    Align = alBottom
    BevelEdges = [beLeft, beRight, beBottom]
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    TabOrder = 0
    object btnClose: TButton
      AlignWithMargins = True
      Left = 555
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnRestore: TButton
      AlignWithMargins = True
      Left = 442
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Restore'
      TabOrder = 0
      OnClick = btnRestoreClick
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 670
    Height = 120
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object lbFolder: TLabel
      Left = 20
      Top = 37
      Width = 67
      Height = 13
      Caption = 'Folder default'
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 116
      Width = 670
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object edtFolder: TEdit
      Left = 20
      Top = 53
      Width = 601
      Height = 21
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
    end
    object btnFindFolder: TButton
      Left = 623
      Top = 52
      Width = 25
      Height = 23
      Cursor = crHandPoint
      Hint = 'Search folder'
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnFindFolderClick
    end
  end
end
