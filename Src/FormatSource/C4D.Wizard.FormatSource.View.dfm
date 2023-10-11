object C4DWizardFormatSourceView: TC4DWizardFormatSourceView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Format Source'
  ClientHeight = 332
  ClientWidth = 584
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 0
    Top = 292
    Width = 584
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Align = alBottom
    Shape = bsTopLine
    ExplicitTop = 297
    ExplicitWidth = 581
  end
  object Panel1: TPanel
    Left = 0
    Top = 296
    Width = 584
    Height = 36
    Align = alBottom
    BevelEdges = [beLeft, beRight, beBottom]
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    TabOrder = 0
    object Label2: TLabel
      Left = 2
      Top = 2
      Width = 222
      Height = 13
      Align = alLeft
      Caption = '* Comments after two slashes will be removed'
      Layout = tlCenter
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 469
      Top = 2
      Width = 110
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnFormatSource: TButton
      AlignWithMargins = True
      Left = 243
      Top = 2
      Width = 110
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Format Source'
      TabOrder = 0
      OnClick = btnFormatSourceClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 356
      Top = 2
      Width = 110
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Cancel - Esc'
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object pnBody: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 292
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 194
      Width = 584
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 293
      ExplicitWidth = 581
    end
    object GroupBox1: TGroupBox
      Left = 0
      Top = 0
      Width = 584
      Height = 71
      Align = alClient
      Caption = ' Options '
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      object ckDisplayResultInMsgTab: TCheckBox
        Left = 12
        Top = 19
        Width = 164
        Height = 17
        Cursor = crHandPoint
        Caption = 'Display Result in Message Tab'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 0
      end
      object ckShowConfimationBeforeReplace: TCheckBox
        Left = 12
        Top = 40
        Width = 184
        Height = 17
        Cursor = crHandPoint
        Caption = 'Show Confirmation Before Replace'
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
        TabOrder = 1
      end
    end
    object rdGroupScope: TRadioGroup
      Left = 0
      Top = 71
      Width = 584
      Height = 123
      Align = alBottom
      Caption = ' Scope '
      Color = clBtnFace
      ItemIndex = 0
      Items.Strings = (
        'Files in Project Group'
        'Files in Project'
        'Files in Directories')
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      OnClick = rdGroupScopeClick
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 198
      Width = 584
      Height = 94
      Align = alBottom
      Caption = ' Search Directory Options '
      TabOrder = 2
      DesignSize = (
        584
        94)
      object Label3: TLabel
        Left = 12
        Top = 21
        Width = 44
        Height = 13
        Caption = 'Directory'
        Transparent = True
        Layout = tlCenter
      end
      object btnSearchDirectory: TButton
        Left = 554
        Top = 35
        Width = 25
        Height = 23
        Cursor = crHandPoint
        Hint = 'Search folder'
        Anchors = [akTop, akRight]
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnSearchDirectoryClick
      end
      object cBoxSearchDirectory: TComboBox
        Left = 12
        Top = 36
        Width = 538
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 1
      end
      object ckIncludeSubdirectories: TCheckBox
        Left = 12
        Top = 61
        Width = 125
        Height = 17
        Cursor = crHandPoint
        Caption = 'Include subdirectories'
        TabOrder = 2
      end
    end
  end
end
