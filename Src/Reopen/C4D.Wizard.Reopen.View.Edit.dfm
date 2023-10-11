object C4DWizardReopenViewEdit: TC4DWizardReopenViewEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Edit Informations'
  ClientHeight = 330
  ClientWidth = 658
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
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 658
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      658
      295)
    object Label1: TLabel
      Left = 32
      Top = 45
      Width = 45
      Height = 13
      Caption = 'Nickname'
    end
    object Label2: TLabel
      Left = 32
      Top = 97
      Width = 25
      Height = 13
      Caption = 'Color'
    end
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 291
      Width = 658
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object Label4: TLabel
      Left = 32
      Top = 207
      Width = 49
      Height = 13
      Caption = 'Folder .git'
    end
    object Label3: TLabel
      Left = 32
      Top = 153
      Width = 29
      Height = 13
      Caption = 'Group'
    end
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 32
      Top = 25
      Width = 594
      Height = 1
      Margins.Left = 32
      Margins.Top = 0
      Margins.Right = 32
      Margins.Bottom = 0
      Align = alTop
      Shape = bsTopLine
      ExplicitLeft = 0
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object edtNickname: TEdit
      Left = 32
      Top = 60
      Width = 596
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object ColorBox1: TColorBox
      Left = 32
      Top = 112
      Width = 596
      Height = 22
      NoneColorColor = clNone
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 20
      TabOrder = 1
    end
    object edtFolderGit: TEdit
      Left = 32
      Top = 223
      Width = 567
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
    end
    object btnFolderGit: TButton
      Left = 602
      Top = 222
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
      TabOrder = 3
      OnClick = btnFolderGitClick
    end
    object cBoxGroup: TComboBox
      Left = 32
      Top = 168
      Width = 596
      Height = 21
      Margins.Left = 10
      Margins.Top = 15
      Margins.Right = 0
      Margins.Bottom = 0
      Style = csDropDownList
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 30
      TabOrder = 4
    end
    object mmFilePath: TMemo
      AlignWithMargins = True
      Left = 32
      Top = 8
      Width = 594
      Height = 17
      Margins.Left = 32
      Margins.Top = 0
      Margins.Right = 32
      Margins.Bottom = 0
      Align = alTop
      BorderStyle = bsNone
      ReadOnly = True
      TabOrder = 5
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 658
      Height = 8
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 6
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 295
    Width = 658
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
    object btnConfirm: TButton
      AlignWithMargins = True
      Left = 430
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
      Left = 543
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
