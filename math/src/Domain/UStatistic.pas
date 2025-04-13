unit UStatistic;

interface

uses
  Generics.Collections, System.Classes,System.SysUtils; //UDifficulty;

type
  TStatTask = class
    UserAnswersByTask: TStrings;//TList<string>;
    CountHelpClick: Integer;
    TimeSeconds: Integer;
    CountAttempts: Integer;
    IsTrue: Boolean;
    IsView: Boolean;
    IsPassed: Boolean;
    ID:Integer;

    public
      constructor Create;
      destructor Destroy; override;
end;

type
  TStatLesson = class
    Tasks: TObjectList<TStatTask>;
    TimeSeconds: Integer;
    LessonName:string;
    ID:Integer;

    public
      constructor Create;
      destructor Destroy; override;
end;

type
  TStatCourse = class
    Lessons: TObjectList<TStatLesson>;
    Difficulty: String; //Integer;//TDifficulty;
    TimeSeconds: Integer;
    ID:Integer;

    public
      constructor Create;
      destructor Destroy; override;
end;

type
  TStatistic = class
    public
      function GetBall(countValidAnswers: integer; countAllTasks: integer):integer;
      function GetEffection(countValidTask:Integer; countAllTasks:Integer; allTimeSeconds:Integer; decimalPoint:Integer):Real;
      function GetEffectionStr(countValidTask:Integer; countAllTasks:Integer; allTimeSeconds:Integer; decimalPoint:Integer):String;
end;

implementation

constructor TStatCourse.Create;
begin
  Self.Lessons:=TObjectList<TStatLesson>.Create;
end;

destructor TStatCourse.Destroy;
begin
  inherited;
  Self.Lessons.Free;
end;

constructor TStatLesson.Create;
begin
  Self.Tasks:=TObjectList<TStatTask>.Create;
end;

destructor TStatLesson.Destroy;
begin
  inherited;
  Self.Tasks.Free;
end;

constructor TStatTask.Create;
begin
  Self.UserAnswersByTask := TStringList.Create; //TList<string>.Create;
end;

destructor TStatTask.Destroy;
begin
  inherited;
  Self.UserAnswersByTask.Free;
end;

function TStatistic.GetBall(countValidAnswers: integer; countAllTasks: integer):integer;
CONST
  PROCENT_BALL1=50;
  PROCENT_BALL2=75;
  PROCENT_BALL3=90;
begin
  if(Trunc((countValidAnswers / countAllTasks) * 100) <= PROCENT_BALL1)then
    Result:=2;
  if(Trunc((countValidAnswers / countAllTasks) * 100) >= PROCENT_BALL1)and(Trunc((countValidAnswers / countAllTasks) * 100) <= PROCENT_BALL2)then
    Result:=3;
  if(Trunc((countValidAnswers / countAllTasks) * 100) >= PROCENT_BALL2)and(Trunc((countValidAnswers / countAllTasks) * 100) <= PROCENT_BALL3)then
    Result:=4;
  if(Trunc((countValidAnswers / countAllTasks) * 100) >= PROCENT_BALL3)then
    Result:=5;
end;

function CustomRoundTo (Value: Real; Digits: Integer): Real;
var
  i: Integer;
  stage: Integer;
begin
  stage:=1;
  for i:=1 to Digits do
    stage:=stage*10;
  Value:=trunc(Value*stage)/stage;

  CustomRoundTo:=Value;
end;

function TStatistic.GetEffection(countValidTask:Integer; countAllTasks:Integer; allTimeSeconds:Integer; decimalPoint:Integer):Real;
begin
  Result:=CustomRoundTo((countValidTask/(countAllTasks * allTimeSeconds))*1000, decimalPoint);
end;

function TStatistic.GetEffectionStr(countValidTask:Integer; countAllTasks:Integer; allTimeSeconds:Integer; decimalPoint:Integer):String;
begin
  Result:=Format('%f', [GetEffection(countValidTask, countAllTasks, allTimeSeconds, decimalPoint)]);
end;

end.
