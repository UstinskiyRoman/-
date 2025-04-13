object FTeacherMain: TFTeacherMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1043#1083#1072#1074#1085#1086#1077' '#1084#1077#1085#1102'. '#1052#1077#1090#1086#1076#1080#1089#1090
  ClientHeight = 571
  ClientWidth = 1018
  Color = clWindow
  Constraints.MinHeight = 600
  Constraints.MinWidth = 1024
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  DesignSize = (
    1018
    571)
  PixelsPerInch = 96
  TextHeight = 13
  object btnExit: TButton
    Left = 320
    Top = 496
    Width = 361
    Height = 57
    Anchors = [akBottom]
    Caption = #1042#1099#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnExitClick
  end
  object btnUserEditor: TButton
    Left = 320
    Top = 40
    Width = 361
    Height = 57
    Anchors = [akTop]
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
    Enabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Visible = False
  end
  object btnTaskEditor: TButton
    Left = 320
    Top = 216
    Width = 361
    Height = 57
    Anchors = [akTop]
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1079#1072#1076#1072#1095
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = btnTaskEditorClick
  end
  object btnCourseEditor: TButton
    Left = 320
    Top = 128
    Width = 361
    Height = 57
    Anchors = [akTop]
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1091#1088#1086#1082#1086#1074
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    OnClick = btnCourseEditorClick
  end
  object grpbTaskEditorMenu: TGroupBox
    Left = 264
    Top = 31
    Width = 473
    Height = 459
    Anchors = [akTop]
    Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1079#1072#1076#1072#1095'. '#1052#1077#1085#1102
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    Visible = False
    DesignSize = (
      473
      459)
    object btnUpdateTasksMenu: TButton
      Left = 144
      Top = 128
      Width = 185
      Height = 57
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = btnUpdateTasksMenuClick
    end
    object btnCloseTaskEditorMenu: TButton
      Left = 144
      Top = 385
      Width = 185
      Height = 57
      Anchors = [akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 0
      OnClick = btnCloseTaskEditorMenuClick
    end
    object btnCreateTask: TButton
      Left = 144
      Top = 48
      Width = 185
      Height = 57
      Caption = #1057#1086#1079#1076#1072#1090#1100
      TabOrder = 1
      OnClick = btnCreateTaskClick
    end
    object grpbUpdateTasksMenu: TGroupBox
      Left = 16
      Top = 32
      Width = 441
      Height = 417
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      TabOrder = 2
      Visible = False
      object lblCourses: TLabel
        Left = 16
        Top = 33
        Width = 90
        Height = 24
        Caption = #1058#1077#1084#1072#1090#1080#1082#1072
      end
      object lblLessons: TLabel
        Left = 16
        Top = 103
        Width = 59
        Height = 24
        Caption = #1059#1088#1086#1082#1080
      end
      object lblTasks: TLabel
        Left = 16
        Top = 178
        Width = 67
        Height = 24
        Caption = #1047#1072#1076#1072#1095#1080
      end
      object btnCloseUpdTask: TButton
        Left = 128
        Top = 353
        Width = 185
        Height = 57
        Caption = #1047#1072#1082#1088#1099#1090#1100
        TabOrder = 0
        OnClick = btnCloseUpdTaskClick
      end
      object cmbCourses: TComboBox
        Left = 16
        Top = 58
        Width = 409
        Height = 32
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnChange = cmbCoursesChange
      end
      object cmbLessons: TComboBox
        Left = 16
        Top = 128
        Width = 409
        Height = 32
        Style = csDropDownList
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = cmbLessonsChange
      end
      object cmbTasks: TComboBox
        Left = 16
        Top = 208
        Width = 409
        Height = 32
        Style = csDropDownList
        TabOrder = 3
      end
      object btnPreviewTask: TButton
        Left = 16
        Top = 264
        Width = 161
        Height = 41
        Caption = #1055#1088#1077#1076#1087#1088#1086#1089#1084#1086#1090#1088
        TabOrder = 4
        OnClick = btnPreviewTaskClick
      end
      object btnUpdateTask: TButton
        Left = 272
        Top = 264
        Width = 153
        Height = 41
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        TabOrder = 5
        OnClick = btnUpdateTaskClick
      end
    end
  end
end
