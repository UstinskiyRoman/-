object FTaskEditor: TFTaskEditor
  Left = -44
  Top = 0
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1079#1072#1076#1072#1095
  ClientHeight = 726
  ClientWidth = 1274
  Color = clBtnFace
  Constraints.MinHeight = 720
  Constraints.MinWidth = 1280
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    1274
    726)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 0
    Width = 1248
    Height = 680
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Panel1'
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    DesignSize = (
      1248
      680)
    object Label1: TLabel
      Left = 526
      Top = 40
      Width = 36
      Height = 13
      Caption = #1056#1077#1078#1080#1084':'
    end
    object Label2: TLabel
      Left = 526
      Top = 91
      Width = 29
      Height = 13
      Caption = #1059#1088#1086#1082':'
    end
    object lblCourse: TLabel
      Left = 526
      Top = 19
      Width = 62
      Height = 14
      Caption = #1058#1077#1084#1072#1090#1080#1082#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 8
      Top = 8
      Width = 449
      Height = 68
    end
    object Lb1: TLabel
      Left = 298
      Top = 35
      Width = 33
      Height = 13
      Caption = #1058#1077#1082#1089#1090':'
    end
    object Bevel2: TBevel
      Left = 8
      Top = 81
      Width = 449
      Height = 68
    end
    object Label3: TLabel
      Left = 298
      Top = 108
      Width = 33
      Height = 13
      Caption = #1058#1077#1082#1089#1090':'
    end
    object Bevel3: TBevel
      Left = 8
      Top = 154
      Width = 449
      Height = 68
    end
    object Label4: TLabel
      Left = 298
      Top = 181
      Width = 33
      Height = 13
      Caption = #1058#1077#1082#1089#1090':'
    end
    object Bevel4: TBevel
      Left = 8
      Top = 227
      Width = 449
      Height = 68
    end
    object Label5: TLabel
      Left = 298
      Top = 254
      Width = 33
      Height = 13
      Caption = #1058#1077#1082#1089#1090':'
    end
    object Bevel5: TBevel
      Left = 8
      Top = 300
      Width = 449
      Height = 68
    end
    object Label6: TLabel
      Left = 298
      Top = 327
      Width = 33
      Height = 13
      Caption = #1058#1077#1082#1089#1090':'
    end
    object Bevel6: TBevel
      Left = 8
      Top = 374
      Width = 449
      Height = 68
    end
    object Label7: TLabel
      Left = 298
      Top = 396
      Width = 94
      Height = 13
      Caption = #1074#1074#1077#1076#1080#1090#1077' '#1074#1077#1083#1080#1095#1080#1085#1091
    end
    object Label8: TLabel
      Left = 10
      Top = 472
      Width = 72
      Height = 13
      Caption = #1058#1077#1082#1089#1090' '#1079#1072#1076#1072#1095#1080':'
    end
    object Label9: TLabel
      Left = 617
      Top = 472
      Width = 48
      Height = 13
      Caption = #1056#1077#1096#1077#1085#1080#1077':'
    end
    object Label10: TLabel
      Left = 24
      Top = 384
      Width = 36
      Height = 13
      Caption = #1054#1090#1074#1077#1090':'
      Enabled = False
    end
    object LbE: TLabel
      Left = 151
      Top = 406
      Width = 12
      Height = 13
      Caption = '...'
      Enabled = False
    end
    object cmbModes: TComboBox
      Left = 526
      Top = 59
      Width = 210
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
    object cmbLessonsForTask: TComboBox
      Left = 526
      Top = 110
      Width = 210
      Height = 21
      Style = csDropDownList
      ParentShowHint = False
      ShowHint = False
      TabOrder = 1
      OnChange = cmbLessonsForTaskChange
      OnDropDown = cmbLessonsForTaskDropDown
    end
    object ChB1: TCheckBox
      Left = 24
      Top = 16
      Width = 265
      Height = 51
      Caption = 'ChB1'
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 5
      WordWrap = True
    end
    object ChBV1: TCheckBox
      Left = 298
      Top = 16
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 2
      OnClick = ChBV1Click
    end
    object Ed1: TEdit
      Left = 298
      Top = 50
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 3
    end
    object Bt1: TButton
      Left = 425
      Top = 46
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 4
      OnClick = Bt1Click
    end
    object ChB2: TCheckBox
      Left = 24
      Top = 89
      Width = 265
      Height = 51
      Caption = 'ChB2'
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 9
      WordWrap = True
    end
    object ChBV2: TCheckBox
      Left = 298
      Top = 89
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 6
      OnClick = ChBV1Click
    end
    object Ed2: TEdit
      Left = 298
      Top = 123
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 7
    end
    object Bt2: TButton
      Left = 425
      Top = 119
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 8
      OnClick = Bt1Click
    end
    object ChB3: TCheckBox
      Left = 24
      Top = 162
      Width = 265
      Height = 51
      Caption = 'ChB3'
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 13
      WordWrap = True
    end
    object ChBV3: TCheckBox
      Left = 298
      Top = 162
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 10
      OnClick = ChBV1Click
    end
    object Ed3: TEdit
      Left = 298
      Top = 196
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 11
    end
    object Bt3: TButton
      Left = 425
      Top = 192
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 12
      OnClick = Bt1Click
    end
    object ChB4: TCheckBox
      Left = 24
      Top = 235
      Width = 265
      Height = 51
      Caption = 'ChB4'
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 17
      WordWrap = True
    end
    object ChBV4: TCheckBox
      Left = 298
      Top = 235
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 14
      OnClick = ChBV1Click
    end
    object Ed4: TEdit
      Left = 298
      Top = 269
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 15
    end
    object Bt4: TButton
      Left = 425
      Top = 265
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 16
      OnClick = Bt1Click
    end
    object ChB5: TCheckBox
      Left = 24
      Top = 308
      Width = 265
      Height = 51
      Caption = 'ChB5'
      Ctl3D = True
      DoubleBuffered = False
      Enabled = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 21
      WordWrap = True
    end
    object ChBV5: TCheckBox
      Left = 298
      Top = 308
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 18
      OnClick = ChBV1Click
    end
    object Ed5: TEdit
      Left = 298
      Top = 342
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 19
    end
    object Bt5: TButton
      Left = 425
      Top = 338
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 20
      OnClick = Bt1Click
    end
    object ChBVe: TCheckBox
      Left = 298
      Top = 374
      Width = 97
      Height = 17
      Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1090#1100
      TabOrder = 22
      OnClick = ChBVeClick
    end
    object Ede: TEdit
      Left = 298
      Top = 415
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 23
    end
    object Bte: TButton
      Left = 425
      Top = 413
      Width = 25
      Height = 25
      Caption = #1054#1082
      Enabled = False
      TabOrder = 24
      OnClick = BteClick
    end
    object Er: TEdit
      Left = 24
      Top = 403
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 25
    end
    object M1: TMemo
      Left = 10
      Top = 491
      Width = 601
      Height = 183
      Anchors = [akLeft, akTop, akRight]
      ScrollBars = ssVertical
      TabOrder = 26
    end
    object M2: TMemo
      Left = 617
      Top = 491
      Width = 618
      Height = 183
      ScrollBars = ssVertical
      TabOrder = 27
    end
  end
  object MainMenu1: TMainMenu
    Left = 592
    Top = 328
    object N1: TMenuItem
      Caption = #1047#1072#1076#1072#1095#1072
      object MenuCheckTask: TMenuItem
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        OnClick = MenuCheckTaskClick
      end
      object MenuSaveTask: TMenuItem
        Caption = #1057#1086#1079#1076#1072#1090#1100
        OnClick = MenuSaveTaskClick
      end
      object MenuUpdateTask: TMenuItem
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        OnClick = MenuUpdateTaskClick
      end
      object MenuExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = MenuExitClick
      end
    end
    object N2: TMenuItem
      Caption = #1040#1091#1076#1080#1086' '#1080' '#1074#1080#1076#1077#1086' '#1079#1072#1076#1072#1095#1080
      object LoadAudioCondition: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1072#1091#1076#1080#1086' '#1091#1089#1083#1086#1074#1080#1077
        OnClick = LoadAudioConditionClick
      end
      object LoadVideoSolutionForTable: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1074#1080#1076#1077#1086' '#1088#1077#1096#1077#1085#1080#1077' '#1076#1083#1103' '#1090#1072#1073#1083#1080#1094
        OnClick = LoadVideoSolutionForTableClick
      end
    end
    object N3: TMenuItem
      Caption = #1064#1072#1073#1083#1086#1085#1099
      Visible = False
      object LoadTemplateForBodyTask: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1096#1072#1073#1083#1086#1085' '#1079#1072#1076#1072#1085#1080#1103
      end
      object LoadTemplateForConditionTask: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1096#1072#1073#1083#1086#1085' '#1091#1089#1083#1086#1074#1080#1103
      end
      object LoadTemplateForMetaInfoTask: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1096#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1084#1077#1090#1072' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080
      end
    end
  end
  object OpenDialogForAudio: TOpenDialog
    Filter = #1040#1091#1076#1080#1086' '#1091#1089#1083#1086#1074#1080#1077'|*.wav'
    Left = 584
    Top = 216
  end
  object OpenDialogForVideo: TOpenDialog
    Filter = #1042#1080#1076#1077#1086' '#1088#1077#1096#1077#1085#1080#1077'|*.AVI; *.WMV; *.MP4'
    Left = 584
    Top = 272
  end
end
