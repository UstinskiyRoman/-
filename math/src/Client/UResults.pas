unit UResults;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, UDataModuleClient, UModes, Generics.Collections,
  UStatistic, System.StrUtils, UTools, Vcl.ExtCtrls, UFormBase, Vcl.Buttons;

type
  TFResults = class(TFormBase)
    Button1: TButton;
    panelCongratulations: TPanel;
    StringGrid1: TStringGrid;
    StatusBar1: TStatusBar;
    btnShowExtendResults: TBitBtn;
    btnShowResults: TBitBtn;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnShowExtendResultsClick(Sender: TObject);
    procedure btnShowResultsClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    ModeTest: TMode;
    StatisticTest: TObjectList<TStatCourse>;

    procedure SaveStatistic();
    procedure Init();
  public
    procedure ShowResult(mode: TMode; statsTest: TObjectList<TStatCourse>);
  end;

var
  FResults: TFResults;

implementation

Uses
  UTester, UModeTestMenu, UMainMenu;

{$R *.dfm}

procedure TFResults.ExecuteClose();
begin
  Button1.Click;
end;

procedure TFResults.SaveStatistic();
begin
  if(ModeTest = ClassWork)then
    DataModuleClient.SaveStatisticClassWork(StatisticTest, FMainMenu.UserInfo.ID);

  if(ModeTest = SelfWork)then
    DataModuleClient.SaveStatisticSelfWork(StatisticTest, FMainMenu.UserInfo.ID);

  if(ModeTest = Diagnostic)then
    DataModuleClient.SaveStatisticDiagnostic(StatisticTest, FMainMenu.UserInfo.ID);
end;

procedure TFResults.Init();
begin
  Self.Caption := Self.Caption +'. '+ FMainMenu.UserInfo.ToString;

  StringGrid1.ColCount:=9;
  StringGrid1.RowCount:=6;
  StringGrid1.RowHeights[0]:=50;

  StringGrid1.ColWidths[0]:=220;
  StringGrid1.ColWidths[1]:=285;
  StringGrid1.ColWidths[2]:=112;
  StringGrid1.ColWidths[3]:=78;
  StringGrid1.ColWidths[4]:=200;

  if(ModeTest = Diagnostic)then
  begin
    btnShowExtendResults.Visible:=true;
    btnShowResults.Visible:=true;

    StringGrid1.ColWidths[5]:=-1;
    StringGrid1.ColWidths[6]:=-1;
    StringGrid1.ColWidths[8]:=-1;
    StringGrid1.ColWidths[1]:=-1;
    StringGrid1.ColWidths[2]:=-1;
  end else
  begin
    StringGrid1.ColWidths[5]:=140;
    StringGrid1.ColWidths[6]:=120;
  end;

  if(ModeTest = ClassWork)then
  begin
    StringGrid1.ColWidths[7]:=-1;
    StringGrid1.ColWidths[8]:=-1;
  end else
  begin
    StringGrid1.ColWidths[7]:=195;

    if(ModeTest <> Diagnostic)then
      StringGrid1.ColWidths[8]:=119;
  end;

  StringGrid1.Cells[0,0]:='Курс';
  StringGrid1.Cells[1,0]:='Урок';
  StringGrid1.Cells[2,0]:='№ задачи';
  StringGrid1.Cells[3,0]:='Время';
  StringGrid1.Cells[4,0]:='Верно/Не верно';
  StringGrid1.Cells[5,0]:='Подсказок';
  StringGrid1.Cells[6,0]:='Попыток';
  StringGrid1.Cells[7,0]:='Эффективность';
  StringGrid1.Cells[8,0]:='Оценка';

  StatusBar1.Panels[0].Text:=FMainMenu.UserInfo.ToString;
end;

procedure TFResults.ShowResult(mode: TMode; statsTest: TObjectList<TStatCourse>);
var
  statTask: TStatTask;
  statLesson:TStatLesson;
  statCourse:TStatCourse;

  i:Integer;
  numberTask: integer;
  AllTimeCourses: Integer;
  AllValidTasks: Integer;
  countTasksAllCourses: Integer;
  ball:Integer;

  IsDiagnosticFail: Boolean;

  toolStatic:TStatistic;
begin
  ModeTest := mode;
  StatisticTest := statsTest;
  Init();

  IsDiagnosticFail:=false;

  i:=0;
  numberTask:=0;
  AllTimeCourses:=0;
  AllValidTasks:=0;
  countTasksAllCourses:=0;
  ball:=0;

  toolStatic:=TStatistic.Create;

  for statCourse in StatisticTest do
  begin
    //пропускаем курс и урок, в котором хотя бы одна задача не пройдена
    if(ModeTest = Diagnostic) and ((IsDiagnosticFail) or (statCourse.TimeSeconds = 0))then
    begin
      Break;
    end;

    StringGrid1.Cells[0, i + 1]:=statCourse.Difficulty; //AppTools.GetNameDifficulty(statCourse.Difficulty);

    numberTask:=0;

    for statLesson in statCourse.Lessons do
    begin
      if (statLesson.TimeSeconds = 0) then Continue;

      StringGrid1.RowCount:=StringGrid1.RowCount + statLesson.Tasks.Count;

      numberTask:=0;

      if(ModeTest = SelfWork)then AllValidTasks:=0;

      StringGrid1.Cells[1, i + 1]:=statLesson.LessonName;

      for statTask in statLesson.Tasks do
      begin
        if(ModeTest = SelfWork) or (ModeTest = Diagnostic)then
        begin
          Inc(countTasksAllCourses);

          if(statTask.IsTrue)then Inc(AllValidTasks);
        end;

        if(ModeTest = Diagnostic) and (not statTask.IsTrue)then
        begin
          IsDiagnosticFail:=true;
        end else if(ModeTest = Diagnostic)then
        begin
          StringGrid1.Visible := false;
          panelCongratulations.Visible := true;                     //AppTools.GetNameDifficulty(statCourse.Difficulty)
          panelCongratulations.Caption := Format('Ваш уровень: %s', [statCourse.Difficulty]);
        end;

        Inc(i);
        Inc(numberTask);

        StringGrid1.Cells[2, i]:=Format('%d', [numberTask]);
        StringGrid1.Cells[3, i]:=AppTools.GetStrTimeBySeconds(statTask.TimeSeconds);
        StringGrid1.Cells[4, i]:=IfThen(statTask.IsTrue, 'Верно', 'Не верно');
        StringGrid1.Cells[5, i]:=Format('%d', [ statTask.CountHelpClick ]);
        StringGrid1.Cells[6, i]:=Format('%d', [ statTask.CountAttempts ]);
      end;

      if(ModeTest = SelfWork)then
      begin
        ball:=toolStatic.GetBall(AllValidTasks, statLesson.Tasks.Count);
        Inc(i);
        StringGrid1.Cells[7, i]:=toolStatic.GetEffectionStr(AllValidTasks, statLesson.Tasks.Count, statLesson.TimeSeconds, 2);
        StringGrid1.Cells[8, i]:=Format('%d', [ball]);
        StringGrid1.Cells[0, i] := 'Итоги урока:';
      end;
    end;

    if(ModeTest = Diagnostic) and (statCourse.TimeSeconds <> 0)then
    begin
      AllTimeCourses:=AllTimeCourses + statCourse.TimeSeconds;
    end;
  end;

  if(ModeTest = Diagnostic)then
  begin
    StringGrid1.Cells[7, i + 1]:=toolStatic.GetEffectionStr(AllValidTasks, countTasksAllCourses, AllTimeCourses, 2);
  end;

  if(ModeTest = Diagnostic)then
    StatusBar1.Panels[2].Text:='Общее время: '+AppTools.GetStrTimeBySeconds(AllTimeCourses)
  else
    StatusBar1.Panels[2].Text:='Общее время: '+AppTools.GetStrTimeBySeconds(StatisticTest.Items[0].TimeSeconds);

  StatusBar1.Panels[1].Text:=AppTools.GetNameModeTest(ModeTest);

  toolStatic.Free;

  Self.Show();
end;

procedure TFResults.btnShowExtendResultsClick(Sender: TObject);
begin
  StringGrid1.Visible := true;
  panelCongratulations.Visible := false;
end;

procedure TFResults.btnShowResultsClick(Sender: TObject);
begin
  StringGrid1.Visible := false;
  panelCongratulations.Visible := true;
end;

procedure TFResults.Button1Click(Sender: TObject);
begin
  SaveStatistic();
  FTester.Close;

  FModeTestMenu := TFModeTestMenu.Create(nil);
  FModeTestMenu.Show;

  Self.Close;
end;

procedure TFResults.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  FResults:=nil;
end;

end.
