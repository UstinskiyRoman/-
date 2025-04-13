object FCourseLessonEditor: TFCourseLessonEditor
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1091#1088#1086#1082#1086#1074
  ClientHeight = 571
  ClientWidth = 1018
  Color = clBtnFace
  Constraints.MinHeight = 600
  Constraints.MinWidth = 1024
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1018
    571)
  PixelsPerInch = 96
  TextHeight = 13
  object btnExit: TButton
    Left = 872
    Top = 512
    Width = 129
    Height = 41
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 3
    OnClick = btnExitClick
  end
  object grpboxRemoveLessons: TGroupBox
    Left = 8
    Top = 435
    Width = 438
    Height = 118
    Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1091#1088#1086#1082#1086#1074
    TabOrder = 0
    object cmbLessonsForRemove: TComboBox
      Left = 11
      Top = 24
      Width = 166
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cmbLessonsForRemoveChange
      OnDropDown = cmbLessonsForRemoveDropDown
    end
    object memoRemovingLesson: TMemo
      Left = 203
      Top = 24
      Width = 222
      Height = 57
      Hint = #1054#1087#1080#1089#1072#1085#1080#1077' '#1091#1088#1086#1082#1072
      Enabled = False
      ParentShowHint = False
      ReadOnly = True
      ShowHint = True
      TabOrder = 1
    end
    object btnRemoveLesson: TButton
      Left = 312
      Top = 87
      Width = 113
      Height = 25
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1091#1088#1086#1082
      TabOrder = 2
      OnClick = btnRemoveLessonClick
    end
  end
  object grpboxUpdateLessons: TGroupBox
    Left = 8
    Top = 188
    Width = 438
    Height = 242
    Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1091#1088#1086#1082#1086#1074
    TabOrder = 1
    DesignSize = (
      438
      242)
    object Label3: TLabel
      Left = 11
      Top = 19
      Width = 29
      Height = 13
      Caption = #1059#1088#1086#1082':'
    end
    object Label4: TLabel
      Left = 203
      Top = 19
      Width = 28
      Height = 13
      Caption = #1050#1091#1088#1089':'
    end
    object Label5: TLabel
      Left = 374
      Top = 19
      Width = 33
      Height = 13
      Caption = #1050#1083#1072#1089#1089':'
    end
    object cmbLessonsForUpdate: TComboBox
      Left = 11
      Top = 34
      Width = 186
      Height = 21
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = True
      TabOrder = 5
      OnChange = cmbLessonsForUpdateChange
      OnDropDown = cmbLessonsForUpdateDropDown
    end
    object cmbCourses: TComboBox
      Left = 203
      Top = 34
      Width = 166
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnSelect = cmbCoursesSelect
    end
    object memoDescriptionUpdatingLessons: TMemo
      Left = 203
      Top = 111
      Width = 222
      Height = 65
      Hint = #1054#1087#1080#1089#1072#1085#1080#1077' '#1091#1088#1086#1082#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object btnApplyChanges: TButton
      Left = 312
      Top = 206
      Width = 113
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 2
      OnClick = btnApplyChangesClick
    end
    object lblEditUpdLesson: TLabeledEdit
      Left = 11
      Top = 111
      Width = 186
      Height = 21
      EditLabel.Width = 81
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1088#1086#1082#1072
      TabOrder = 3
    end
    object lbleditOrderLesson2: TLabeledEdit
      Left = 11
      Top = 154
      Width = 78
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1103#1076#1086#1082' '#1091#1088#1086#1082#1072
      NumbersOnly = True
      TabOrder = 4
    end
    object CmbUpdCl: TComboBox
      Left = 374
      Top = 34
      Width = 54
      Height = 21
      Style = csDropDownList
      TabOrder = 6
    end
  end
  object grpboxCreationLessons: TGroupBox
    Left = 8
    Top = 8
    Width = 438
    Height = 176
    Caption = #1057#1086#1079#1076#1072#1085#1080#1077' '#1091#1088#1086#1082#1086#1074
    TabOrder = 2
    DesignSize = (
      438
      176)
    object Label1: TLabel
      Left = 8
      Top = 24
      Width = 28
      Height = 13
      Caption = #1050#1091#1088#1089':'
    end
    object Label2: TLabel
      Left = 224
      Top = 25
      Width = 33
      Height = 13
      Caption = #1050#1083#1072#1089#1089':'
    end
    object editLessonName: TLabeledEdit
      Left = 11
      Top = 69
      Width = 186
      Height = 21
      EditLabel.Width = 81
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1088#1086#1082#1072
      TabOrder = 0
    end
    object memoDescriptionLesson: TMemo
      Left = 203
      Top = 69
      Width = 222
      Height = 57
      Hint = #1054#1087#1080#1089#1072#1085#1080#1077' '#1091#1088#1086#1082#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object cmboxCoursesForNewLessons: TComboBox
      Left = 43
      Top = 22
      Width = 166
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnSelect = cmboxCoursesForNewLessonsSelect
    end
    object btnCreateLesson: TButton
      Left = 312
      Top = 144
      Width = 113
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1091#1088#1086#1082
      TabOrder = 3
      OnClick = btnCreateLessonClick
    end
    object lbleditOrderLesson: TLabeledEdit
      Left = 11
      Top = 113
      Width = 78
      Height = 21
      EditLabel.Width = 77
      EditLabel.Height = 13
      EditLabel.Caption = #1055#1086#1088#1103#1076#1086#1082' '#1091#1088#1086#1082#1072
      NumbersOnly = True
      TabOrder = 4
    end
    object CmbClass: TComboBox
      Left = 265
      Top = 22
      Width = 77
      Height = 21
      Style = csDropDownList
      TabOrder = 5
    end
  end
end
