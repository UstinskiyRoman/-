object FResults: TFResults
  Left = 98
  Top = 150
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
  ClientHeight = 491
  ClientWidth = 1095
  Color = 16120810
  Constraints.MinHeight = 530
  Constraints.MinWidth = 914
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  WindowState = wsMaximized
  OnClose = FormClose
  DesignSize = (
    1095
    491)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 755
    Top = 400
    Width = 332
    Height = 54
    Anchors = [akRight, akBottom]
    Caption = #1044#1072#1083#1077#1077
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Georgia'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object btnShowExtendResults: TBitBtn
    Left = 8
    Top = 400
    Width = 249
    Height = 54
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    Visible = False
    OnClick = btnShowExtendResultsClick
  end
  object btnShowResults: TBitBtn
    Left = 263
    Top = 400
    Width = 258
    Height = 54
    Anchors = [akLeft, akBottom]
    Caption = #1055#1086#1089#1084#1086#1090#1088#1077#1090#1100' '#1084#1086#1081' '#1091#1088#1086#1074#1077#1085#1100
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    Visible = False
    OnClick = btnShowResultsClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 461
    Width = 1095
    Height = 30
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBtnText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Panels = <
      item
        Width = 430
      end
      item
        Width = 330
      end
      item
        Width = 250
      end>
    ParentShowHint = False
    ShowHint = True
    UseSystemFont = False
  end
  object StringGrid1: TStringGrid
    Left = 0
    Top = 0
    Width = 1095
    Height = 377
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultRowHeight = 34
    FixedCols = 0
    RowCount = 2
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
    ParentFont = False
    TabOrder = 5
    ColWidths = (
      64
      121
      135
      125
      230)
  end
  object panelCongratulations: TPanel
    Left = 0
    Top = 0
    Width = 1095
    Height = 377
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
end
