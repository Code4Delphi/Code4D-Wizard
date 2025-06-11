object C4DWizardUsesOrganizationView: TC4DWizardUsesOrganizationView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Uses Organization '
  ClientHeight = 573
  ClientWidth = 584
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
  object Bevel1: TBevel
    AlignWithMargins = True
    Left = 0
    Top = 533
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
    Top = 537
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
      Height = 32
      Align = alLeft
      Caption = '* Comments after two slashes will be removed'
      Layout = tlCenter
      ExplicitHeight = 13
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
    object btnOrganizeUses: TButton
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
      Caption = 'Organize Uses'
      TabOrder = 0
      OnClick = btnOrganizeUsesClick
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
    Height = 533
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    object Bevel2: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 529
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
      Height = 200
      Align = alClient
      Caption = ' Options '
      Color = clBtnFace
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      object Label1: TLabel
        Left = 21
        Top = 147
        Width = 223
        Height = 13
        Caption = 'Number of columns at the beginning of the line'
      end
      object Label3: TLabel
        Left = 141
        Top = 42
        Width = 188
        Height = 13
        Caption = 'Maximum number of characters per line'
      end
      object ckOrderUsesInAlphabeticalOrder: TCheckBox
        Left = 21
        Top = 20
        Width = 176
        Height = 17
        Cursor = crHandPoint
        Hint = 'Ordenar uses em ordem alfab'#233'tica'
        Caption = 'Order uses in alphabetical order'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object ckOneUsesPerLine: TCheckBox
        Left = 21
        Top = 40
        Width = 107
        Height = 17
        Cursor = crHandPoint
        Hint = 'Uma uses por linha'
        Caption = 'One uses per line'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 1
        OnClick = ckOneUsesPerLineClick
      end
      object ckGroupUnitsByNamespaces: TCheckBox
        Left = 21
        Top = 60
        Width = 158
        Height = 17
        Cursor = crHandPoint
        Hint = 'Agrupar unidades por namespaces'
        Caption = 'Group units by namespaces'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = ckOneUsesPerLineClick
      end
      object ckLineBreakBetweenNamespaces: TCheckBox
        Left = 36
        Top = 82
        Width = 179
        Height = 17
        Cursor = crHandPoint
        Hint = 'Quebra de linha entre namespaces'
        Caption = 'Line break between namespaces'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
      end
      object edtOneUsesLineNumColBefore: TEdit
        Left = 21
        Top = 162
        Width = 33
        Height = 21
        MaxLength = 2
        NumbersOnly = True
        TabOrder = 2
        Text = '2'
      end
      object ckDisplayResultInMsgTab: TCheckBox
        Left = 21
        Top = 103
        Width = 168
        Height = 17
        Cursor = crHandPoint
        Caption = 'Display Result in Message Tab'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        State = cbChecked
        TabOrder = 5
      end
      object ckShowConfimationBeforeReplace: TCheckBox
        Left = 21
        Top = 124
        Width = 187
        Height = 17
        Cursor = crHandPoint
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
        TabOrder = 6
      end
      object edtMaxCharactersPerLine: TEdit
        Left = 334
        Top = 38
        Width = 33
        Height = 21
        MaxLength = 3
        NumbersOnly = True
        TabOrder = 7
        Text = '90'
      end
    end
    object rdGroupScope: TRadioGroup
      Left = 0
      Top = 401
      Width = 584
      Height = 128
      Align = alBottom
      Caption = ' Scope '
      Color = clBtnFace
      ItemIndex = 0
      Items.Strings = (
        'Current Unit'
        'Files in Project Group'
        'Files in Project'
        'All Opened Files')
      ParentBackground = False
      ParentColor = False
      TabOrder = 3
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 277
      Width = 584
      Height = 124
      Align = alBottom
      Caption = ' Uses to Add '
      TabOrder = 2
      DesignSize = (
        584
        124)
      object ckUsesToAdd: TCheckBox
        Left = 21
        Top = 20
        Width = 229
        Height = 17
        Cursor = crHandPoint
        Caption = 'Uses to add if needed (separate by comma)'
        TabOrder = 0
        OnClick = ckOneUsesPerLineClick
      end
      object ckUsesToAddStringsFilter: TCheckBox
        Left = 21
        Top = 67
        Width = 264
        Height = 17
        Cursor = crHandPoint
        Caption = 'Only if the unit has the string (separate by comma)'
        TabOrder = 2
        OnClick = ckOneUsesPerLineClick
      end
      object cBoxUsesToAdd: TComboBox
        Left = 21
        Top = 40
        Width = 540
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 1
      end
      object cBoxUsesToAddStringsFilter: TComboBox
        Left = 21
        Top = 87
        Width = 540
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 3
      end
    end
    object GroupBox3: TGroupBox
      Left = 0
      Top = 200
      Width = 584
      Height = 77
      Align = alBottom
      Caption = ' Uses to Remove '
      TabOrder = 1
      DesignSize = (
        584
        77)
      object ckUsesToRemove: TCheckBox
        Left = 21
        Top = 20
        Width = 201
        Height = 17
        Cursor = crHandPoint
        Caption = 'Uses to remove (separate by comma)'
        TabOrder = 0
        OnClick = ckOneUsesPerLineClick
      end
      object cBoxUsesToRemove: TComboBox
        Left = 21
        Top = 40
        Width = 540
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DropDownCount = 20
        TabOrder = 1
      end
    end
  end
end
