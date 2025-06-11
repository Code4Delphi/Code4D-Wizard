object C4DWizardReplaceFilesView: TC4DWizardReplaceFilesView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Replace in Files'
  ClientHeight = 451
  ClientWidth = 689
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 414
    Width = 689
    Height = 37
    Align = alBottom
    BevelEdges = [beLeft, beRight, beBottom]
    BevelOuter = bvNone
    Padding.Left = 4
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    TabOrder = 1
    object btnClose: TButton
      AlignWithMargins = True
      Left = 574
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnReplace: TButton
      AlignWithMargins = True
      Left = 348
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Replace'
      TabOrder = 0
      OnClick = btnReplaceClick
    end
    object ckShowConfimationBeforeReplace: TCheckBox
      AlignWithMargins = True
      Left = 12
      Top = 10
      Width = 183
      Height = 17
      Cursor = crHandPoint
      Margins.Left = 8
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Show confirmation before replace'
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
      TabOrder = 3
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 461
      Top = 2
      Width = 110
      Height = 33
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
    Width = 689
    Height = 414
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 73
      Width = 689
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alTop
      Shape = bsTopLine
      ExplicitTop = 8
      ExplicitWidth = 584
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 310
      Width = 689
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 80
      ExplicitWidth = 632
    end
    object Bevel4: TBevel
      AlignWithMargins = True
      Left = 344
      Top = 77
      Width = 1
      Height = 230
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alLeft
      Shape = bsLeftLine
      ExplicitLeft = 209
      ExplicitTop = 76
      ExplicitHeight = 174
    end
    object Bevel5: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 410
      Width = 689
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 80
      ExplicitWidth = 632
    end
    object gBoxText: TGroupBox
      Left = 0
      Top = 0
      Width = 689
      Height = 73
      Align = alTop
      Caption = ' Text '
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      DesignSize = (
        689
        73)
      object Label1: TLabel
        Left = 10
        Top = 46
        Width = 60
        Height = 13
        Caption = 'Replace by: '
        Layout = tlCenter
      end
      object Label2: TLabel
        Left = 10
        Top = 20
        Width = 57
        Height = 13
        Caption = 'Search for: '
        Transparent = True
        Layout = tlCenter
      end
      object cBoxSearchFor: TComboBox
        Left = 69
        Top = 15
        Width = 505
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 0
      end
      object cBoxReplaceBy: TComboBox
        Left = 69
        Top = 42
        Width = 505
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 1
      end
      object btnSearchForAndReplaceByEverEquals: TButton
        Left = 578
        Top = 21
        Width = 20
        Height = 36
        Cursor = crHandPoint
        Hint = 'Copy text "Search For" to " Replace By"'
        Anchors = [akTop, akRight]
        Caption = ']'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnSearchForAndReplaceByEverEqualsClick
      end
      object ckSearchForAndReplaceByEverEqualsInShow: TCheckBox
        Left = 603
        Top = 32
        Width = 78
        Height = 17
        Cursor = crHandPoint
        Hint = 'Text "Replace By" Ever Equals "Search For" in Form Show'
        Anchors = [akTop, akRight]
        Caption = 'Ever equals'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ckSearchForAndReplaceByEverEqualsInShowClick
      end
    end
    object rdGroupScope: TRadioGroup
      Left = 345
      Top = 77
      Width = 344
      Height = 233
      Align = alClient
      Caption = ' Scope '
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 2
      OnClick = rdGroupScopeClick
    end
    object Panel2: TPanel
      Left = 0
      Top = 77
      Width = 344
      Height = 233
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 1
      object Bevel3: TBevel
        AlignWithMargins = True
        Left = 0
        Top = 99
        Width = 344
        Height = 1
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Align = alTop
        Shape = bsTopLine
        ExplicitLeft = -5
        ExplicitTop = 75
        ExplicitWidth = 484
      end
      object gBoxOptions: TGroupBox
        Left = 0
        Top = 0
        Width = 344
        Height = 99
        Align = alTop
        Caption = ' Options '
        Padding.Left = 10
        Padding.Top = 5
        Padding.Right = 10
        Padding.Bottom = 5
        TabOrder = 0
        object ckCaseSensitive: TCheckBox
          Left = 12
          Top = 20
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = 'Case Sensitive'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
        end
        object ckWholeWordOnly: TCheckBox
          Left = 12
          Top = 37
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Hint = 'Apenas palavras inteiras'
          Align = alTop
          Caption = 'Whole Word Only'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object ckDisplayResultInMsgTab: TCheckBox
          Left = 12
          Top = 71
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = 'Display Result in Message Tab'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 3
        end
        object ckDisplayAccountant: TCheckBox
          Left = 12
          Top = 54
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Hint = 'Adiciona [contador] no in'#237'cio da mensagem'
          Align = alTop
          Caption = 'Display Accountant'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
      end
      object gBoxExtension: TGroupBox
        Left = 0
        Top = 103
        Width = 344
        Height = 130
        Align = alClient
        Caption = ' Extension '
        Ctl3D = True
        Padding.Left = 10
        Padding.Top = 5
        Padding.Right = 10
        Padding.Bottom = 5
        ParentCtl3D = False
        TabOrder = 1
        object ckExtensionPas: TCheckBox
          Left = 12
          Top = 20
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = '.pas'
          Checked = True
          ParentShowHint = False
          ShowHint = True
          State = cbChecked
          TabOrder = 0
        end
        object ckExtensionDFM: TCheckBox
          Left = 12
          Top = 37
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = '.dfm'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object ckExtensionFMX: TCheckBox
          Left = 12
          Top = 54
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = '.fmx'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
        end
        object ckExtensionDPRandDPK: TCheckBox
          Left = 12
          Top = 71
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = '.dpr and .dpk'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
        end
        object ckExtensionDPROJ: TCheckBox
          Left = 12
          Top = 88
          Width = 320
          Height = 17
          Cursor = crHandPoint
          Align = alTop
          Caption = '.dproj'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 4
        end
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 314
      Width = 689
      Height = 96
      Align = alBottom
      Caption = ' Search Directory Options '
      TabOrder = 3
      DesignSize = (
        689
        96)
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
        Left = 650
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
        Width = 636
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 1
      end
      object ckIncludeSubdirectories: TCheckBox
        Left = 12
        Top = 64
        Width = 125
        Height = 17
        Cursor = crHandPoint
        Caption = 'Include subdirectories'
        TabOrder = 2
      end
    end
  end
end
