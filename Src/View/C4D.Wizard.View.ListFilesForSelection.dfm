object C4DWizardViewListFilesForSelection: TC4DWizardViewListFilesForSelection
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'List Files For Selection'
  ClientHeight = 412
  ClientWidth = 934
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
  object pnButtons: TPanel
    Left = 0
    Top = 376
    Width = 934
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
    object btnClose: TButton
      AlignWithMargins = True
      Left = 819
      Top = 2
      Width = 110
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Close'
      TabOrder = 1
      OnClick = btnCloseClick
    end
    object btnOk: TButton
      AlignWithMargins = True
      Left = 706
      Top = 2
      Width = 110
      Height = 32
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'OK'
      TabOrder = 0
      OnClick = btnOkClick
    end
  end
  object pnBody: TPanel
    Left = 0
    Top = 0
    Width = 934
    Height = 376
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 372
      Width = 934
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 127
      ExplicitWidth = 555
    end
    object Splitter1: TSplitter
      Left = 465
      Top = 0
      Width = 6
      Height = 372
      ExplicitLeft = 369
      ExplicitHeight = 391
    end
    object pnOrigin: TPanel
      Left = 0
      Top = 0
      Width = 465
      Height = 372
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object pnControls: TPanel
        Left = 406
        Top = 0
        Width = 59
        Height = 372
        Align = alRight
        BevelOuter = bvNone
        Padding.Left = 6
        Padding.Top = 41
        ParentBackground = False
        TabOrder = 0
        object btnAdd: TButton
          AlignWithMargins = True
          Left = 6
          Top = 41
          Width = 53
          Height = 27
          Cursor = crHandPoint
          Hint = 'Add item selected'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 4
          Align = alTop
          Caption = '>'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImageAlignment = iaCenter
          ImageIndex = 0
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnRemove: TButton
          AlignWithMargins = True
          Left = 6
          Top = 72
          Width = 53
          Height = 27
          Cursor = crHandPoint
          Hint = 'Remove item selected'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 4
          Align = alTop
          Caption = '<'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImageAlignment = iaCenter
          ImageIndex = 1
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnRemoveClick
        end
        object btnRemoveAll: TButton
          AlignWithMargins = True
          Left = 6
          Top = 103
          Width = 53
          Height = 27
          Cursor = crHandPoint
          Hint = 'Remove all items'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 4
          Align = alTop
          Caption = '<|'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImageAlignment = iaCenter
          ImageIndex = 2
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnRemoveAllClick
        end
        object btnAddAllOpens: TButton
          AlignWithMargins = True
          Left = 6
          Top = 175
          Width = 53
          Height = 27
          Cursor = crHandPoint
          Hint = 'Add all open units'
          Margins.Left = 0
          Margins.Top = 0
          Margins.Right = 0
          Margins.Bottom = 4
          Align = alTop
          Caption = 'Open >'
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ImageAlignment = iaCenter
          ImageIndex = 0
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          TabOrder = 3
          OnClick = btnAddAllOpensClick
        end
        object Panel1: TPanel
          Left = 6
          Top = 134
          Width = 53
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 4
        end
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 406
        Height = 372
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object Label3: TLabel
          AlignWithMargins = True
          Left = 4
          Top = 3
          Width = 20
          Height = 13
          Margins.Left = 4
          Margins.Bottom = 2
          Align = alTop
          Caption = 'Find'
        end
        object pnTotalOrigin: TPanel
          Left = 0
          Top = 352
          Width = 406
          Height = 20
          Align = alBottom
          BevelOuter = bvNone
          Padding.Left = 3
          TabOrder = 0
          object lbCountOrigin: TLabel
            Left = 42
            Top = 0
            Width = 7
            Height = 13
            Align = alLeft
            Caption = '0'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
          object Label1: TLabel
            Left = 3
            Top = 0
            Width = 39
            Height = 13
            Align = alLeft
            Caption = 'Count: '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            Layout = tlCenter
          end
        end
        object ListViewOrigin: TListView
          Left = 0
          Top = 42
          Width = 406
          Height = 310
          Align = alClient
          Columns = <
            item
              Caption = 'Name'
              Width = 320
            end
            item
              AutoSize = True
              Caption = 'Path'
            end
            item
              Caption = 'File Is Open'
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Tahoma'
          Font.Style = []
          ReadOnly = True
          RowSelect = True
          ParentFont = False
          PopupMenu = PopupMenuOrigin
          SortType = stText
          TabOrder = 1
          ViewStyle = vsReport
          OnCustomDrawItem = ListViewOriginCustomDrawItem
          OnDblClick = ListViewOriginDblClick
          OnKeyDown = ListViewOriginKeyDown
        end
        object edtFindOrigin: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 18
          Width = 400
          Height = 21
          Margins.Top = 0
          Align = alTop
          TabOrder = 2
          OnKeyDown = edtFindOriginKeyDown
        end
      end
    end
    object Panel4: TPanel
      Left = 471
      Top = 0
      Width = 463
      Height = 372
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label4: TLabel
        AlignWithMargins = True
        Left = 4
        Top = 3
        Width = 20
        Height = 13
        Margins.Left = 4
        Margins.Bottom = 2
        Align = alTop
        Caption = 'Find'
      end
      object ListViewDestiny: TListView
        Left = 0
        Top = 42
        Width = 463
        Height = 310
        Align = alClient
        Columns = <
          item
            Caption = 'Name'
            Width = 320
          end
          item
            AutoSize = True
            Caption = 'Path'
          end
          item
            Caption = 'File Is Open'
          end>
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = []
        ReadOnly = True
        RowSelect = True
        ParentFont = False
        PopupMenu = PopupMenuDestiny
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
        OnCustomDrawItem = ListViewDestinyCustomDrawItem
        OnDblClick = ListViewDestinyDblClick
        OnKeyDown = ListViewDestinyKeyDown
      end
      object pnCountDestiny: TPanel
        Left = 0
        Top = 352
        Width = 463
        Height = 20
        Align = alBottom
        BevelOuter = bvNone
        Padding.Left = 3
        TabOrder = 1
        object lbCountDestiny: TLabel
          Left = 42
          Top = 0
          Width = 7
          Height = 13
          Align = alLeft
          Caption = '0'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
        object Label2: TLabel
          Left = 3
          Top = 0
          Width = 39
          Height = 13
          Align = alLeft
          Caption = 'Count: '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
        end
      end
      object edtFindDestiny: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 18
        Width = 457
        Height = 21
        Margins.Top = 0
        Align = alTop
        TabOrder = 2
        OnKeyDown = edtFindDestinyKeyDown
      end
    end
  end
  object PopupMenuOrigin: TPopupMenu
    Left = 288
    Top = 216
    object CopyNameOrigin1: TMenuItem
      Caption = 'Copy Name'
      OnClick = CopyNameOrigin1Click
    end
    object CopyPathOrigin1: TMenuItem
      Caption = 'Copy Path'
      OnClick = CopyPathOrigin1Click
    end
  end
  object PopupMenuDestiny: TPopupMenu
    Left = 504
    Top = 216
    object CopyNameDestiny1: TMenuItem
      Caption = 'Copy Name'
      OnClick = CopyNameDestiny1Click
    end
    object CopyPathDestiny1: TMenuItem
      Caption = 'Copy Path'
      OnClick = CopyPathDestiny1Click
    end
  end
end
