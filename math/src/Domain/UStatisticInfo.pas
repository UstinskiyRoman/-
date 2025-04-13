unit UStatisticInfo;

interface

//uses
//  UDifficulty;

type
  TStatDiagnostic = class
    ID: Integer;
    CourseID: Integer;
    CourseName:String;
    SpentTimeSeconds:Integer;
    Effect:double;
    DateTest:TDateTime;
    Difficulty: Integer;

    constructor Create(ID: Integer;CourseID: Integer;CourseName:String;SpentTimeSeconds:Integer;Effect:double;DateTest:TDateTime;Difficulty: Integer);
end;

type
  TStatSelfWork = class
    ID: Integer;
    DateTest:TDateTime;
    Ball: Integer;
    Effect: double;
    LessonId: Integer;

    constructor Create(id:integer; DateTest:TDateTime; Ball: Integer; Effect: double; LessonId: Integer);
end;

type
  TStatClassWork = class
    ID: Integer;
    TaskId:Integer;
    SpentTimeSec: Integer;
    NameDifficulty: String;
    CountHelpClick: Integer;
    CountAttempt: Integer;
    DateTest:TDateTime;

    constructor Create(id:integer; taskID:Integer; spentTimeSec:Integer; CountHelpClick: Integer; CountAttempt: Integer; DateTest:TDateTime);
end;

//------------------------------------------------------------------------------
type
  TLesson = record
    ID: Integer;
    Name: String;
end;

type
  TStatSelfWorkTree = class
    ID: Integer;
    CourseName: String;
    Difficulty: Integer;
    Lesson: TLesson;
    Ball: Integer;
    DateTest:TDateTime;

    constructor Create(id:integer; courseName:String; difficulty:Integer; lessonID:integer; lessonName:String; ball:Integer; dateTest:TDateTime);
end;
//------------------------------------------------------------------------------

implementation

constructor TStatSelfWork.Create(id:integer; DateTest:TDateTime; Ball: Integer; Effect: double; LessonId: Integer);
begin
  Self.ID:=id;
  Self.DateTest:=DateTest;
  Self.Ball:=Ball;
  Self.Effect:=Effect;
  Self.LessonId:=LessonId;
end;

constructor TStatClassWork.Create(id:integer; taskID:Integer; spentTimeSec:Integer; CountHelpClick:Integer; CountAttempt:Integer; DateTest:TDateTime);
begin
  Self.ID:=id;
  Self.TaskId:=taskID;
  Self.SpentTimeSec:=spentTimeSec;
  Self.NameDifficulty:=NameDifficulty;
  Self.CountHelpClick:=CountHelpClick;
  Self.CountAttempt:=CountAttempt;
  Self.DateTest:=DateTest;
end;

constructor TStatSelfWorkTree.Create(id:integer; courseName:String; difficulty:Integer; lessonID:integer; lessonName:String; ball:Integer; dateTest:TDateTime);
begin
  Self.ID:=id;
  Self.CourseName:=courseName;
  Self.Difficulty:=difficulty;
  Self.Lesson.ID:=lessonID;
  Self.Lesson.Name:=lessonName;
  Self.Ball:=ball;
  Self.DateTest:=dateTest;
end;

constructor TStatDiagnostic.Create(ID: Integer;CourseID: Integer;CourseName:String;SpentTimeSeconds:Integer;Effect:double;DateTest:TDateTime;Difficulty:Integer);
begin
  Self.ID:=ID;
  Self.CourseID:=CourseID;
  Self.CourseName:=CourseName;
  Self.SpentTimeSeconds:=SpentTimeSeconds;
  Self.Effect:=Effect;
  Self.DateTest:=DateTest;
  Self.Difficulty:=Difficulty;
end;

end.
