object C4DWizardBackupImportSelectFilesView: TC4DWizardBackupImportSelectFilesView
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Code4D - Select Files For Import Configs'
  ClientHeight = 318
  ClientWidth = 294
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
    Top = 281
    Width = 294
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
    ExplicitTop = 276
    ExplicitWidth = 298
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 179
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Cancel'
      TabOrder = 1
      OnClick = btnCancelClick
      ExplicitLeft = 183
    end
    object btnConfirm: TButton
      AlignWithMargins = True
      Left = 66
      Top = 2
      Width = 110
      Height = 33
      Cursor = crHandPoint
      Margins.Left = 0
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = 'Confirm'
      TabOrder = 0
      OnClick = btnConfirmClick
      ExplicitLeft = 70
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 0
    Width = 294
    Height = 281
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 1
    ExplicitTop = -1
    object Bevel1: TBevel
      AlignWithMargins = True
      Left = 0
      Top = 277
      Width = 294
      Height = 1
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Align = alBottom
      Shape = bsTopLine
      ExplicitTop = 158
      ExplicitWidth = 441
    end
    object ckGeneralSettings: TCheckBox
      Left = 65
      Top = 45
      Width = 98
      Height = 17
      Caption = 'General settings'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object ckGroups: TCheckBox
      Left = 65
      Top = 214
      Width = 54
      Height = 17
      Caption = 'Groups'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object ckOpenExternalPath: TCheckBox
      Left = 65
      Top = 129
      Width = 113
      Height = 17
      Caption = 'Open external path'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object ckReopenFileHistory: TCheckBox
      Left = 65
      Top = 171
      Width = 109
      Height = 17
      Caption = 'Reopen file history'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object ckDefaultFilesInOpeningProject: TCheckBox
      Left = 65
      Top = 87
      Width = 172
      Height = 17
      Caption = 'Default Files In Opening Project'
      Checked = True
      State = cbChecked
      TabOrder = 1
    end
  end
end
