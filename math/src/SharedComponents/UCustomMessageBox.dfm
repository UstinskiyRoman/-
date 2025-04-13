object FCustomMessageBox: TFCustomMessageBox
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'FCustomMessageBox'
  ClientHeight = 159
  ClientWidth = 414
  Color = 15792605
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    414
    159)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTextBox: TLabel
    Left = 16
    Top = 0
    Width = 385
    Height = 90
    Alignment = taCenter
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = '1'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object panelOk: TPanel
    Left = 0
    Top = 96
    Width = 414
    Height = 63
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object btnOk: TBitBtn
      Left = 296
      Top = 8
      Width = 105
      Height = 49
      Caption = #1044#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnOkClick
    end
  end
  object panelOkCancel: TPanel
    Left = 0
    Top = 96
    Width = 414
    Height = 63
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btn_questionOK: TBitBtn
      Left = 16
      Top = 8
      Width = 81
      Height = 49
      Caption = #1044#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 0
      OnClick = btnOkClick
    end
    object btn_questionCancel: TBitBtn
      Left = 288
      Top = 8
      Width = 113
      Height = 49
      Caption = #1053#1077#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -27
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 1
      OnClick = btn_questionCancelClick
    end
  end
end
