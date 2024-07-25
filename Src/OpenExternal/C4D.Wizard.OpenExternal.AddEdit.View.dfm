object C4DWizardOpenExternalAddEditView: TC4DWizardOpenExternalAddEditView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Open External XXX'
  ClientHeight = 511
  ClientWidth = 676
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
  object Bevel2: TBevel
    AlignWithMargins = True
    Left = 0
    Top = 472
    Width = 676
    Height = 1
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Align = alBottom
    Shape = bsTopLine
    ExplicitLeft = -5
    ExplicitTop = 476
  end
  object Panel1: TPanel
    Left = 0
    Top = 476
    Width = 676
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
    object Label5: TLabel
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
      Left = 448
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
      Left = 561
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
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 676
    Height = 412
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      676
      412)
    object Label1: TLabel
      Left = 35
      Top = 54
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 408
      Width = 676
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 444
    end
    object Label2: TLabel
      Left = 35
      Top = 12
      Width = 20
      Height = 13
      Caption = 'Kind'
    end
    object Label3: TLabel
      Left = 35
      Top = 98
      Width = 72
      Height = 13
      Caption = 'Path (file / link)'
    end
    object Label4: TLabel
      Left = 35
      Top = 195
      Width = 28
      Height = 13
      Caption = 'Order'
    end
    object Label7: TLabel
      Left = 35
      Top = 243
      Width = 41
      Height = 13
      Caption = 'Shortcut'
    end
    object lbParameters: TLabel
      Left = 35
      Top = 145
      Width = 136
      Height = 13
      Caption = 'Parameters / Comandes XXX'
    end
    object Label6: TLabel
      Left = 35
      Top = 293
      Width = 95
      Height = 13
      Caption = 'Icon (.bmp 16 x 16)'
    end
    object Label9: TLabel
      Left = 183
      Top = 13
      Width = 62
      Height = 13
      Caption = 'Menu master'
    end
    object edtDescription: TEdit
      Left = 35
      Top = 70
      Width = 598
      Height = 21
      TabOrder = 1
    end
    object cBoxKind: TComboBox
      Left = 35
      Top = 28
      Width = 145
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cBoxKindChange
    end
    object edtPath: TEdit
      Left = 35
      Top = 114
      Width = 572
      Height = 21
      TabOrder = 2
    end
    object btnBath: TButton
      Left = 609
      Top = 113
      Width = 24
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
      TabOrder = 3
      OnClick = btnBathClick
    end
    object edtOrder: TEdit
      Left = 35
      Top = 210
      Width = 126
      Height = 21
      MaxLength = 4
      NumbersOnly = True
      TabOrder = 5
      Text = '0'
    end
    object UpDown1: TUpDown
      Left = 161
      Top = 210
      Width = 17
      Height = 21
      Cursor = crHandPoint
      Associate = edtOrder
      Max = 9999
      TabOrder = 6
    end
    object edtShortcut: THotKey
      Left = 35
      Top = 259
      Width = 598
      Height = 19
      Hint = 'Customize Shortcut'
      HotKey = 0
      InvalidKeys = [hcNone]
      Modifiers = []
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
    end
    object edtParameters: TEdit
      Left = 35
      Top = 164
      Width = 598
      Height = 21
      TabOrder = 4
    end
    object ckVisible: TCheckBox
      Left = 35
      Top = 343
      Width = 110
      Height = 17
      Cursor = crHandPoint
      Caption = 'Visible in MainMenu'
      TabOrder = 8
    end
    object edtPathIconLoad: TButton
      Left = 56
      Top = 308
      Width = 67
      Height = 23
      Cursor = crHandPoint
      Hint = 'Search icon'
      Caption = 'Load'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 9
      OnClick = edtPathIconLoadClick
    end
    object edtPathIconClear: TButton
      Left = 125
      Top = 308
      Width = 67
      Height = 23
      Cursor = crHandPoint
      Hint = 'Clear icon'
      Caption = 'Clear'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 10
      OnClick = edtPathIconClearClick
    end
    object Panel2: TPanel
      Left = 35
      Top = 310
      Width = 20
      Height = 20
      BevelKind = bkTile
      BevelOuter = bvNone
      TabOrder = 11
      object imgIcon: TImage
        Left = 0
        Top = 0
        Width = 16
        Height = 16
        Align = alClient
      end
    end
    object ckVisibleInToolBarUtilities: TCheckBox
      Left = 35
      Top = 366
      Width = 136
      Height = 17
      Cursor = crHandPoint
      Caption = 'Visible in ToolBar Utilities'
      TabOrder = 12
    end
    object cBoxMenuMaster: TComboBox
      Left = 183
      Top = 28
      Width = 450
      Height = 21
      Margins.Left = 10
      Margins.Top = 15
      Margins.Right = 0
      Margins.Bottom = 0
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 30
      TabOrder = 13
    end
  end
  object pnTagsBack: TPanel
    Left = 0
    Top = 412
    Width = 676
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    Padding.Left = 3
    Padding.Top = 3
    Padding.Right = 3
    Padding.Bottom = 3
    ParentBackground = False
    TabOrder = 2
    object Label8: TLabel
      Left = 3
      Top = 3
      Width = 305
      Height = 54
      Align = alLeft
      Caption = 
        'Tags for fields "Path (file / link)" and "Parameters / Comandes"' +
        ': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object mmTags: TMemo
      Left = 308
      Top = 3
      Width = 365
      Height = 54
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 0
    end
  end
end
