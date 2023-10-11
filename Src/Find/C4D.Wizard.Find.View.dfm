object C4DWizardFindView: TC4DWizardFindView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Find In Files'
  ClientHeight = 457
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
  object Panel1: TPanel
    Left = 0
    Top = 420
    Width = 584
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
      Left = 469
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
    object btnFind: TButton
      AlignWithMargins = True
      Left = 243
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Find'
      TabOrder = 0
      OnClick = btnFindClick
    end
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 356
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
    object ckCloseFormFinished: TCheckBox
      AlignWithMargins = True
      Left = 14
      Top = 10
      Width = 191
      Height = 17
      Cursor = crHandPoint
      Margins.Left = 10
      Margins.Top = 8
      Margins.Bottom = 8
      Align = alLeft
      Caption = 'Close form when finished searching'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object pnBody: TPanel
    Left = 0
    Top = 0
    Width = 584
    Height = 420
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 416
      Width = 584
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
      Left = 291
      Top = 114
      Width = 1
      Height = 199
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alLeft
      Shape = bsLeftLine
      ExplicitLeft = 209
      ExplicitTop = 76
      ExplicitHeight = 174
    end
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 110
      Width = 584
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = -16
      ExplicitTop = 138
    end
    object Bevel5: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 53
      Width = 584
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alTop
      Shape = bsTopLine
      ExplicitTop = 46
    end
    object Bevel6: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 316
      Width = 584
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitLeft = -16
      ExplicitTop = 334
    end
    object gBoxText: TGroupBox
      Left = 0
      Top = 0
      Width = 584
      Height = 53
      Align = alTop
      Caption = ' Text '
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      DesignSize = (
        584
        53)
      object Label2: TLabel
        Left = 12
        Top = 24
        Width = 57
        Height = 13
        Caption = 'Search for: '
        Transparent = True
        Layout = tlCenter
      end
      object cBoxSearchFor: TComboBox
        Left = 72
        Top = 20
        Width = 496
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 0
        OnKeyDown = cBoxSearchForKeyDown
      end
    end
    object rdGroupScope: TRadioGroup
      Left = 292
      Top = 114
      Width = 292
      Height = 202
      Align = alClient
      Caption = ' Scope '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentBackground = False
      ParentColor = False
      ParentFont = False
      TabOrder = 3
      OnClick = rdGroupScopeClick
    end
    object Panel2: TPanel
      Left = 0
      Top = 114
      Width = 291
      Height = 202
      Align = alLeft
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 2
      object Bevel3: TBevel
        AlignWithMargins = True
        Left = 0
        Top = 82
        Width = 291
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
        Width = 291
        Height = 82
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
          Width = 267
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
          Width = 267
          Height = 17
          Cursor = crHandPoint
          Hint = 'Apenas palavras inteiras'
          Align = alTop
          Caption = 'Whole Word Only'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
        end
        object ckDisplayAccountant: TCheckBox
          Left = 12
          Top = 54
          Width = 267
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
        Top = 86
        Width = 291
        Height = 116
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
          Width = 267
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
          Width = 267
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
          Width = 267
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
          Width = 267
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
          Width = 267
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
    object GroupBox1: TGroupBox
      Left = 0
      Top = 57
      Width = 584
      Height = 53
      Align = alTop
      Caption = ' Text to ignore '
      TabOrder = 1
      DesignSize = (
        584
        53)
      object cBoxTextIgnore: TComboBox
        Left = 205
        Top = 20
        Width = 363
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 0
        OnKeyDown = cBoxSearchForKeyDown
      end
      object cBoxTextIgnoreLocal: TComboBox
        Left = 14
        Top = 20
        Width = 188
        Height = 21
        Hint = 
          'Nenhum'#13#10'Ignorar caso a linha possua o texto'#13#10'Ignorar caso a pala' +
          'vra encontrada possua o texto'
        Style = csDropDownList
        ItemIndex = 2
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'If the word found has the text'
        OnClick = cBoxTextIgnoreLocalClick
        Items.Strings = (
          'None'
          'If the line has the text'
          'If the word found has the text')
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 320
      Width = 584
      Height = 96
      Align = alBottom
      Caption = ' Search Directory Options '
      TabOrder = 4
      ExplicitTop = 319
      DesignSize = (
        584
        96)
      object Label1: TLabel
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
