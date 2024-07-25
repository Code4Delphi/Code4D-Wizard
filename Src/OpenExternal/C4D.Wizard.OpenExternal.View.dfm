object C4DWizardOpenExternalView: TC4DWizardOpenExternalView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Open External'
  ClientHeight = 561
  ClientWidth = 884
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
    Top = 507
    Width = 884
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
    object btnEdit: TButton
      AlignWithMargins = True
      Left = 124
      Top = 2
      Width = 120
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Edit'
      TabOrder = 0
      OnClick = btnEditClick
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 770
      Top = 2
      Width = 110
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnAdd: TButton
      AlignWithMargins = True
      Left = 2
      Top = 2
      Width = 120
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Add new'
      TabOrder = 2
      OnClick = btnAddClick
    end
    object btnRemove: TButton
      AlignWithMargins = True
      Left = 246
      Top = 2
      Width = 120
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Remove'
      TabOrder = 3
      OnClick = btnRemoveClick
    end
    object btnOpenRun: TButton
      AlignWithMargins = True
      Left = 368
      Top = 2
      Width = 145
      Height = 31
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 2
      Margins.Bottom = 0
      Align = alLeft
      Caption = 'Open path / Run command'
      TabOrder = 4
      OnClick = btnOpenRunClick
    end
  end
  object ListViewHistory: TListView
    Left = 0
    Top = 50
    Width = 884
    Height = 457
    Align = alClient
    Columns = <
      item
        Caption = 'Description'
        Width = 200
      end
      item
        Alignment = taRightJustify
        Caption = 'Order'
        Width = 43
      end
      item
        Caption = 'Shortcut'
        Width = 150
      end
      item
        Caption = 'Kind'
        Width = 80
      end
      item
        Alignment = taCenter
        Caption = 'Visible'
        Width = 45
      end
      item
        Alignment = taCenter
        Caption = 'Visible ToolBar Utilities'
        Width = 90
      end
      item
        Caption = 'Path'
        Width = 265
      end
      item
        Caption = 'Parameters'
        Width = 200
      end
      item
        Alignment = taCenter
        Caption = 'IconHas'
        Width = 56
      end
      item
        Caption = 'Guid'
        Width = 0
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ListViewHistoryColumnClick
    OnDblClick = ListViewHistoryDblClick
    OnKeyDown = ListViewHistoryKeyDown
    OnSelectItem = ListViewHistorySelectItem
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 884
    Height = 50
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object btnSearch: TButton
      AlignWithMargins = True
      Left = 799
      Top = 14
      Width = 75
      Height = 27
      Cursor = crHandPoint
      Margins.Left = 2
      Margins.Top = 14
      Margins.Right = 10
      Margins.Bottom = 9
      Align = alRight
      Caption = 'Search'
      TabOrder = 0
      OnClick = btnSearchClick
      ExplicitTop = 11
    end
    object edtSearch: TEdit
      AlignWithMargins = True
      Left = 10
      Top = 15
      Width = 787
      Height = 25
      Margins.Left = 10
      Margins.Top = 15
      Margins.Right = 0
      Margins.Bottom = 10
      Align = alClient
      AutoSize = False
      TabOrder = 1
      OnKeyDown = edtSearchKeyDown
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 542
    Width = 884
    Height = 19
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
end
