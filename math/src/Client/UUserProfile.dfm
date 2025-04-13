object FUserProfile: TFUserProfile
  Left = 285
  Top = 155
  BorderStyle = bsSingle
  Caption = #1055#1088#1086#1092#1080#1083#1100
  ClientHeight = 735
  ClientWidth = 1004
  Color = 16120810
  Constraints.MinHeight = 496
  Constraints.MinWidth = 393
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
    1004
    735)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 174
    Width = 440
    Height = 70
    Anchors = [akTop]
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 280
    Top = 56
    Width = 440
    Height = 70
    Anchors = [akTop]
    Caption = #1053#1072#1095#1072#1090#1100' '#1079#1072#1085#1103#1090#1080#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button5: TButton
    Left = 280
    Top = 616
    Width = 440
    Height = 70
    Anchors = [akBottom]
    Caption = #1042#1099#1081#1090#1080' '#1080#1079' '#1087#1088#1086#1092#1080#1083#1103
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -35
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button5Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 504
    Width = 419
    Height = 201
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    object Label4: TLabel
      Left = 3
      Top = 212
      Width = 205
      Height = 22
      Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072' '#1087#1086' '#1079#1072#1076#1072#1095#1072#1084
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 6
      Top = 35
      Width = 163
      Height = 22
      Caption = #1054#1073#1097#1072#1103' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DBGrid1: TDBGrid
      Left = 0
      Top = 240
      Width = 584
      Height = 166
      DataSource = DataSource1
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object DBGrid2: TDBGrid
      Left = 0
      Top = 56
      Width = 584
      Height = 137
      DataSource = DataSource2
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
    end
  end
  object StatusBarUserInfo: TStatusBar
    Left = 0
    Top = 705
    Width = 1004
    Height = 30
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBtnText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Panels = <
      item
        Width = 50
      end>
    UseSystemFont = False
  end
  object grpBoxSettings: TGroupBox
    Left = 8
    Top = 8
    Width = 225
    Height = 161
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    object Label3: TLabel
      Left = 16
      Top = 36
      Width = 72
      Height = 24
      Caption = #1055#1072#1088#1086#1083#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 16
      Top = 64
      Width = 186
      Height = 27
      Hint = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1074#1099#1081' '#1087#1072#1088#1086#1083#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      PasswordChar = '*'
      ShowHint = True
      TabOrder = 0
    end
    object Button3: TButton
      Left = 16
      Top = 97
      Width = 186
      Height = 40
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = Button3Click
    end
  end
  object DataSource1: TDataSource
    Enabled = False
    Left = 152
    Top = 464
  end
  object DataSource2: TDataSource
    Enabled = False
    Left = 240
    Top = 464
  end
end
