object C4DWizardSettingsView: TC4DWizardSettingsView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Settings'
  ClientHeight = 441
  ClientWidth = 686
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
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 686
    Height = 406
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 402
      Width = 686
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object gBoxShortcut: TGroupBox
      Left = 0
      Top = 0
      Width = 686
      Height = 239
      Align = alTop
      Caption = ' Shortcut '
      TabOrder = 0
      object ckShortcutUsesOrganizationUse: TCheckBox
        Left = 48
        Top = 26
        Width = 110
        Height = 17
        Cursor = crHandPoint
        Caption = 'Uses Organization'
        TabOrder = 0
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object ckShortcutReopenFileHistoryUse: TCheckBox
        Left = 48
        Top = 51
        Width = 117
        Height = 17
        Cursor = crHandPoint
        Caption = 'Reopen File History'
        TabOrder = 2
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object ckShortcutGitHubDesktopUse: TCheckBox
        Left = 48
        Top = 181
        Width = 97
        Height = 17
        Cursor = crHandPoint
        Caption = 'GitHub Desktop'
        TabOrder = 12
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object ckShortcutTranslateTextUse: TCheckBox
        Left = 48
        Top = 77
        Width = 94
        Height = 17
        Cursor = crHandPoint
        Caption = 'Translate Text'
        TabOrder = 4
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object edtShortcutUsesOrganization: THotKey
        Left = 226
        Top = 26
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object edtShortcutReopenFileHistory: THotKey
        Left = 226
        Top = 51
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
      object edtShortcutGitHubDesktop: THotKey
        Left = 226
        Top = 180
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
      end
      object edtShortcutTranslateText: THotKey
        Left = 226
        Top = 77
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object ckShortcutIndentUse: TCheckBox
        Left = 48
        Top = 103
        Width = 55
        Height = 17
        Cursor = crHandPoint
        Caption = 'Indent'
        TabOrder = 6
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object edtShortcutIndent: THotKey
        Left = 226
        Top = 103
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object ckShortcutReplaceFilesUse: TCheckBox
        Left = 48
        Top = 155
        Width = 95
        Height = 17
        Cursor = crHandPoint
        Caption = 'Replace in Files'
        TabOrder = 10
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object edtShortcutReplaceFiles: THotKey
        Left = 226
        Top = 154
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
      end
      object ckShortcutFindInFilesUse: TCheckBox
        Left = 48
        Top = 129
        Width = 78
        Height = 17
        Cursor = crHandPoint
        Caption = 'Find in Files'
        TabOrder = 8
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object edtShortcutFindInFiles: THotKey
        Left = 226
        Top = 128
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
      end
      object ckShortcutDefaultFilesInOpeningProjectUse: TCheckBox
        Left = 48
        Top = 207
        Width = 174
        Height = 17
        Cursor = crHandPoint
        Caption = 'Default Files In Opening Project'
        TabOrder = 14
        OnClick = ckShortcutUsesOrganizationUseClick
      end
      object edtShortcutDefaultFilesInOpeningProject: THotKey
        Left = 226
        Top = 206
        Width = 150
        Height = 19
        Cursor = crArrow
        Hint = 'Customize Shortcut'
        HotKey = 0
        InvalidKeys = [hcNone]
        Modifiers = []
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
      end
    end
    object gboxData: TGroupBox
      Left = 0
      Top = 344
      Width = 686
      Height = 58
      Align = alBottom
      Caption = ' Data '
      Padding.Left = 2
      Padding.Top = 5
      Padding.Bottom = 3
      TabOrder = 2
      object btnOpenDataFolder: TButton
        Left = 4
        Top = 20
        Width = 122
        Height = 33
        Cursor = crHandPoint
        Align = alLeft
        Caption = 'Open Data Folder'
        TabOrder = 0
        OnClick = btnOpenDataFolderClick
      end
    end
    object gBoxSettings: TGroupBox
      Left = 0
      Top = 239
      Width = 686
      Height = 105
      Align = alClient
      Caption = ' Settings '
      TabOrder = 1
      object ckBlockKeyInsert: TCheckBox
        Left = 48
        Top = 48
        Width = 134
        Height = 17
        Cursor = crHandPoint
        Caption = 'Block the INSERT Key'
        TabOrder = 1
      end
      object ckBeforeCompilingCheckRunning: TCheckBox
        Left = 48
        Top = 26
        Width = 244
        Height = 17
        Cursor = crHandPoint
        Caption = 'Before compiling, check if binary is not running'
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 406
    Width = 686
    Height = 35
    Align = alBottom
    BevelEdges = [beLeft, beRight, beBottom]
    BevelOuter = bvNone
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    TabOrder = 1
    object Label4: TLabel
      Left = 8
      Top = 3
      Width = 433
      Height = 13
      Caption = 
        '* Attention, some shortcut changes only work after restarting th' +
        'e Delphi IDE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnConfirm: TButton
      AlignWithMargins = True
      Left = 458
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
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 571
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
    end
  end
end
