object C4DWizardBackupExportView: TC4DWizardBackupExportView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Backup Export Configs'
  ClientHeight = 248
  ClientWidth = 666
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
    Top = 211
    Width = 666
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
      Left = 551
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
    object btnExport: TButton
      AlignWithMargins = True
      Left = 438
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Export'
      TabOrder = 0
      OnClick = btnExportClick
    end
    object ckOpenFolderAfterExport: TCheckBox
      AlignWithMargins = True
      Left = 9
      Top = 5
      Width = 141
      Height = 27
      Cursor = crHandPoint
      Margins.Left = 5
      Align = alLeft
      Caption = 'Open folder after export'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 2
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 211
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object lbFolderForExport: TLabel
      Left = 20
      Top = 37
      Width = 119
      Height = 13
      Caption = 'Folder default for export'
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 207
      Width = 666
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object lbProgressFile: TLabel
      Left = 20
      Top = 87
      Width = 345
      Height = 13
      AutoSize = False
      Caption = 'Progress file'
    end
    object lbProgressBarGeneral: TLabel
      Left = 20
      Top = 133
      Width = 81
      Height = 13
      Caption = 'Progress general'
    end
    object lbPorcentFile: TLabel
      Left = 623
      Top = 88
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbPorcentGeneral: TLabel
      Left = 623
      Top = 134
      Width = 23
      Height = 13
      Alignment = taRightJustify
      Caption = '0 %'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtFolderDefault: TEdit
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
    object ProgressBarFile: TProgressBar
      Left = 20
      Top = 104
      Width = 628
      Height = 20
      Smooth = True
      TabOrder = 2
    end
    object ProgressBarGeneral: TProgressBar
      Left = 20
      Top = 150
      Width = 628
      Height = 20
      Step = 1
      TabOrder = 3
    end
  end
end
