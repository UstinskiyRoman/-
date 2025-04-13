object FRegistration: TFRegistration
  Left = 92
  Top = 111
  BorderStyle = bsSingle
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103
  ClientHeight = 624
  ClientWidth = 1007
  Color = 16120810
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  OnShow = FormShow
  DesignSize = (
    1007
    624)
  PixelsPerInch = 96
  TextHeight = 13
  object btnBack: TButton
    Left = 20
    Top = 544
    Width = 137
    Height = 55
    Anchors = [akLeft, akBottom]
    Caption = #1053#1072#1079#1072#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnBackClick
  end
  object btnRegistration: TButton
    Left = 687
    Top = 544
    Width = 297
    Height = 55
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1090#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = btnRegistrationClick
  end
  object Panel2: TPanel
    Left = 143
    Top = 167
    Width = 664
    Height = 282
    Anchors = [akTop]
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    DesignSize = (
      664
      282)
    object Label7: TLabel
      Left = 171
      Top = 37
      Width = 41
      Height = 24
      Anchors = [akTop]
      Caption = #1048#1084#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 121
      Top = 85
      Width = 91
      Height = 24
      Anchors = [akTop]
      Caption = #1060#1072#1084#1080#1083#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 150
      Top = 138
      Width = 58
      Height = 24
      Anchors = [akTop]
      Caption = #1050#1083#1072#1089#1089
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label11: TLabel
      Left = 71
      Top = 186
      Width = 141
      Height = 24
      Anchors = [akTop]
      Caption = #1044#1072#1090#1072' '#1088#1086#1078#1076#1077#1085#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 140
      Top = 234
      Width = 72
      Height = 24
      Anchors = [akTop]
      Caption = #1055#1072#1088#1086#1083#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object editFirstName: TEdit
      Left = 235
      Top = 36
      Width = 262
      Height = 30
      Anchors = [akTop]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object editSecondName: TEdit
      Left = 235
      Top = 84
      Width = 262
      Height = 30
      Anchors = [akTop]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object comboboxClassGroup: TComboBox
      Left = 235
      Top = 137
      Width = 262
      Height = 30
      Anchors = [akTop]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object CheckBox1: TCheckBox
      Left = 503
      Top = 173
      Width = 175
      Height = 55
      Anchors = [akTop]
      Caption = #1042#1082#1083#1102#1095#1080#1090#1100' '#1044#1072#1090#1091
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = CheckBox1Click
    end
    object DateTimePickerBirthday: TDateTimePicker
      Left = 235
      Top = 186
      Width = 262
      Height = 30
      Anchors = [akTop]
      Date = 43761.000000000000000000
      Time = 0.003023333330929745
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
    end
    object editPassword: TEdit
      Left = 235
      Top = 233
      Width = 262
      Height = 30
      Anchors = [akTop]
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      PasswordChar = '*'
      TabOrder = 5
    end
  end
end
