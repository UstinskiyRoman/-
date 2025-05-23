unit UDataModuleClient;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Dialogs, Generics.Collections,
  UConfigClient, Vcl.Graphics, UTools, System.Math, UUserInfo, UStatistic,  UStatisticInfo, //UDifficulty,
  UTaskInfo,UCourse, ULessonInfo, UModes, // UTaskMetaInfo,
  UTypeUser, UUserDTO, UClassGroupInfo, UDataModuleBase, UTypeTasks, UDataModuleSQLiteBase,
  UTaskResourceType;

type
  TDataModuleClient = class(TDataModule)
    ADOQueryGlobal: TADOQuery;
    ADOQuerySecond: TADOQuery;
    ADOQuerySecondSupp: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
//    function GetCourseByDiffculty(diff:Integer): TCourse;
    function GetTasks(modeTest: TMode; isRandom: boolean): TObjectList<TTask>; Overload;
    function GetTasks(modeTest: TMode; lessonId: integer; isRandom: boolean): TObjectList<TTask>; Overload;
  public
    procedure SaveStatisticClassWork(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
    procedure SaveStatisticSelfWork(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
    procedure SaveStatisticDiagnostic(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
    //procedure SaveStatisticRaven(userId:Integer {; HLevel: String; Sptime: Integer; TrAnswers: Integer});
    procedure SetPasswordUser(userID:Integer; newPassword: String);
    function AddNewUser(firstName:String; secondName:String; classGroupId: Integer; password:String; typeUser:TTypeUser; birthday:TDateTime = 0):TUserInfo;
    function AddNewClassGroup(nameClass:String):TClassGroup;

    function GetStatSelfWorkTreeByUserId(userId,cl_num:Integer):TObjectList<TStatSelfWorkTree>;
//    function GetStatSelfWorkByUserId(userId:Integer):TObjectList<TStatSelfWork>;
    function GetStatDiagnosticByUserId(userId:Integer):TObjectList<TStatDiagnostic>;
    function GetUserInfo(userID:Integer; password:string):TUserInfo;
    function GetAllClassesGroups():TList<TClassGroup>;
    function GetUsersByClass(classID:Integer):TList<TUserDTO>;
    function GetUsers(TUser:TTypeUser):TList<TUserDTO>;
//
    function GetFullCoursesForDiagnosticMode(cl_num:Integer;isRandTasks: boolean; preferableResTypeForTask: TaskResourceType):TObjectList<TCourse>;
    function GetFullCourseByDiffculty(course:TCourse;diff:Integer; modeTest:TMode; isRandTasks: boolean):TCourse;
    function GetFullCourseByDiffcultyLesson(course:TCourse;diff:Integer; modeTest:TMode; isRandTasks: boolean; lessonId: Integer):TCourse;
    function GetFullCourse(courseId: integer; modeTest:TMode; isRandTasks: boolean):TCourse;
    function GetFullCourseByLessonId(lessonId: integer; modeTest:TMode; isRandTasks: boolean):TCourse;
  end;

var
  DataModuleClient: TDataModuleClient;

implementation

{$R *.dfm}

procedure TDataModuleClient.DataModuleCreate(Sender: TObject);
begin
  DataModuleBase.Init(Config.PathDataBase);
  DataModuleSQLiteBase.Init(Config.PathToResourceDataBase, Config.PathToSQLiteLib);
end;

function TDataModuleClient.GetTasks(modeTest: TMode; lessonId: integer; isRandom: boolean): TObjectList<TTask>;
begin
  Result := TObjectList<TTask>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT Id, TaskBody, MetaInfo, TypeTask, ConditionBody, ModeType, ResourceName FROM Tasks WHERE ModeType=:modeTest AND LessonID=:lessonId';
    Parameters.ParamByName('modeTest').Value := Ord(modeTest);
    Parameters.ParamByName('lessonId').Value := lessonId;
    Open;
    First;
    while not(eof) do
    begin
      var task := TTask.Create(Fields[0].AsInteger, Fields[1].AsString, Fields[4].AsString,
                               TTypeTask(Fields[3].AsInteger),
                               lessonId,
                               TMode(Fields[5].AsInteger),
                               Fields[2].AsString,
                               Fields[6].AsString);

      Result.Add(task);

      Next;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;

  if isRandom then
  begin
    Randomize;
    for var i := Result.Count-1 downto 1 do
      Result.Exchange(i, Random(i + 1));
  end;
end;
//
function TDataModuleClient.GetTasks(modeTest: TMode; isRandom: boolean): TObjectList<TTask>;
begin
  Result := TObjectList<TTask>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT Id, TaskBody, MetaInfo, TypeTask, LessonID, ConditionBody, ModeType, ResourceName FROM Tasks WHERE ModeType=:modeTest';
    Parameters.ParamByName('modeTest').Value:=Ord(modeTest);
    Open;
    First;
    while not(eof) do
    begin
      var task := TTask.Create(Fields[0].AsInteger, Fields[1].AsString, Fields[5].AsString,
                            TTypeTask(Fields[3].AsInteger),
                            Fields[4].AsInteger,
                            TMode(Fields[6].AsInteger),
                            Fields[2].AsString,
                            Fields[7].AsString);

      Result.Add(task);

      Next;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;

  if isRandom then
  begin
    Randomize;
    for var i := Result.Count-1 downto 1 do
      Result.Exchange(i, Random(i + 1));
  end;
end;

function TDataModuleClient.GetFullCourseByLessonId(lessonId: integer; modeTest:TMode; isRandTasks: boolean):TCourse;
begin
  var lesson := DataModuleBase.GetLesson(lessonId);
  lesson.Tasks.AddRange(GetTasks(modeTest, lesson.ID, isRandTasks));

  Result := DataModuleBase.GetCourse(lesson.CourseID);
  Result.Lessons.Add(lesson);
end;

function TDataModuleClient.GetFullCourse(courseId: integer; modeTest:TMode; isRandTasks: boolean):TCourse;
begin
  var course := DataModuleBase.GetCourse(courseId);
  var lessons := DataModuleBase.GetLessons(course.ID);

  for var lesson in lessons do
  begin
    lesson.Tasks.AddRange(GetTasks(modeTest, lesson.ID, isRandTasks));
  end;

  course.Lessons.AddRange(lessons);

  Result := course;
end;

function TDataModuleClient.GetFullCourseByDiffculty(course:TCourse;diff:Integer; modeTest:TMode; isRandTasks: boolean):TCourse;
begin
//  var course := GetCourseByDiffculty(diff);
  course.Lessons.Clear;
  var lessons := DataModuleBase.GetLessons(diff,course.ID);

  for var lesson in lessons do
  begin
    lesson.Tasks.AddRange(GetTasks(modeTest, lesson.ID, isRandTasks));
  end;

  course.Lessons.AddRange(lessons);

  Result := course;
end;

function TDataModuleClient.GetFullCourseByDiffcultyLesson(course:TCourse;diff:Integer; modeTest:TMode; isRandTasks: boolean; lessonId: Integer):TCourse;
begin
//  var course := GetCourseByDiffculty(diff);
  course.Lessons.Clear;
  var lessons := DataModuleBase.GetLessons(diff,course.ID);

  for var lesson in lessons do
  begin
    if LessonID = Lesson.ID then
      lesson.Tasks.AddRange(GetTasks(modeTest, lesson.ID, isRandTasks));
  end;

  course.Lessons.AddRange(lessons);

  Result := course;
end;

function ContainsCourse(courses: TObjectList<TCourse>; courseId: integer):boolean;
var
  course: TCourse;
begin
  Result := false;
  for course in courses do
  begin
    if course.ID = courseId then
    begin
      Result := true;
      break;
    end;
  end;
end;
//
function ContainsLesson(lessons: TObjectList<TLesson>; lessonId: integer):boolean;
var
  lesson: TLesson;
begin
  Result := false;
  for lesson in lessons do
  begin
    if lesson.ID = lessonId then
    begin
      Result := true;
      break;
    end;
  end;
end;

function TDataModuleClient.GetFullCoursesForDiagnosticMode(cl_num:Integer;isRandTasks: boolean; preferableResTypeForTask: TaskResourceType):TObjectList<TCourse>;
begin
  Result := TObjectList<TCourse>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT Courses.Id, NameCourse, Courses.Description, Difficulty, Lessons.CourseID, Lessons.Id, Lessons.LessonName, Lessons.Description, Lessons.OrderNumber,Lessons.cl_num,Lessons.theory,'
              +' Tasks.LessonID, Tasks.Id, Tasks.TaskBody, Tasks.ConditionBody, Tasks.TypeTask, Tasks.ModeType, Tasks.MetaInfo, Tasks.ResourceName'
              +' FROM ((Courses'
              +' INNER JOIN Lessons ON Courses.Id = Lessons.CourseID)'
              +' INNER JOIN Tasks ON Lessons.ID = Tasks.LessonId)'
              +' WHERE Tasks.ModeType = :mt and Lessons.cl_num=:cl_num'
              +' ORDER BY Courses.id, Lessons.OrderNumber ASC';
    Parameters.ParamByName('mt').Value := Ord(Diagnostic);
    Parameters.ParamByName('cl_num').Value := cl_num;
    Open;
    First;
    while not(Eof) do
    begin
      if not ContainsCourse(Result, Fields[0].AsInteger) then Result.Add(TCourse.Create(Fields[0].AsInteger, Fields[1].AsString, Fields[2].AsString, Fields[3].AsInteger));

      for var course in Result do
      begin
        if not ContainsLesson(course.Lessons, Fields[5].AsInteger) then
        begin
          // check the course ID with course ID from lessons
          if (course.ID = Fields[4].AsInteger) then
          begin
            course.Lessons.Add(TLesson.Create(Fields[5].AsInteger, Fields[6].AsString, Fields[7].AsString, course.ID, Fields[8].AsInteger,Fields[9].AsInteger,Fields[10].AsString));
          end;
        end;

        for var lesson in course.Lessons do
        begin
          // check the lesson ID with lesson ID from task
          if (lesson.ID = Fields[11].AsInteger) then
          begin
            var task := TTask.Create(Fields[12].AsInteger, Fields[13].AsString, Fields[14].AsString,
                                     TTypeTask(Fields[15].AsInteger),
                                     lesson.ID,
                                     TMode(Fields[16].AsInteger),
                                     Fields[17].AsString,
                                     Fields[18].AsString);
            lesson.Tasks.Add(task);
          end;
        end;
      end;

      Next;
    end;
  end;

  for var i := 0 to Pred(Result.Count) do
  begin
    var indexesLessonsWithResources := TList<integer>.Create;
    var indexesLessonsWithoutResources := TList<integer>.Create;
    for var j := 0 to Pred(Result[i].Lessons.Count) do
    begin
      var countTasksWithResources := 0;
      for var t := 0 to Pred(Result[i].Lessons[j].Tasks.Count) do
      begin
        if (preferableResTypeForTask <> TaskResourceType.Any) and (DataModuleSQLiteBase.HasResourceInDataBase(Result[i].Lessons[j].Tasks[t].ResourceId, preferableResTypeForTask)) then
        begin
          inc(countTasksWithResources);
        end;

        if (countTasksWithResources > 1) then
        begin
          indexesLessonsWithResources.Add(j);
          break;
        end;
      end;

      if (countTasksWithResources <= 1) then indexesLessonsWithoutResources.Add(j);
    end;

    Randomize;
    // need only one lesson
    while (Result[i].Lessons.Count > 1) do
    begin
      if (preferableResTypeForTask <> TaskResourceType.Any) and (indexesLessonsWithResources.Count > 0) then
      begin
        var index := RandomRange(0, indexesLessonsWithResources.Count);
        var lesson := Result[i].Lessons.ExtractAt(indexesLessonsWithResources[index]);
        Result[i].Lessons.Clear;
        Result[i].Lessons.Add(lesson);
        break;
      end else
      begin
        var index := RandomRange(0, indexesLessonsWithoutResources.Count);
        var lesson := Result[i].Lessons.ExtractAt(indexesLessonsWithoutResources[index]);
        Result[i].Lessons.Clear;
        Result[i].Lessons.Add(lesson);
        break;
      end;
    end;

    var indexesTasksWithResources := TList<integer>.Create;
    var indexesTasksWithoutResources := TList<integer>.Create;
    for var j := 0 to Pred(Result[i].Lessons[0].Tasks.Count) do
    begin
      if (preferableResTypeForTask <> TaskResourceType.Any) and (DataModuleSQLiteBase.HasResourceInDataBase(Result[i].Lessons[0].Tasks[j].ResourceId, preferableResTypeForTask)) then
        indexesTasksWithResources.Add(j)
      else
        indexesTasksWithoutResources.Add(j);
    end;

    Randomize;
    // need only one task
    while (Result[i].Lessons[0].Tasks.Count > 1) do
    begin
      if (preferableResTypeForTask = TaskResourceType.Any) then
      begin
        var index := RandomRange(0, indexesTasksWithoutResources.Count);
        var task := Result[i].Lessons[0].Tasks.ExtractAt(indexesTasksWithoutResources[index]);
        Result[i].Lessons[0].Tasks.Clear();
        Result[i].Lessons[0].Tasks.Add(task);
        break;
      end else
      begin
        if indexesTasksWithResources.Count > 1 then
        begin
          var index := RandomRange(0, indexesTasksWithResources.Count);
          var task := Result[i].Lessons[0].Tasks.ExtractAt(indexesTasksWithResources[index]);
          Result[i].Lessons[0].Tasks.Clear();
          Result[i].Lessons[0].Tasks.Add(task);
          break;
        end;
        if indexesTasksWithoutResources.Count > 0 then
        begin
          var index := RandomRange(0, indexesTasksWithoutResources.Count);
          var task := Result[i].Lessons[0].Tasks.ExtractAt(indexesTasksWithoutResources[index]);
          Result[i].Lessons[0].Tasks.Clear();
          Result[i].Lessons[0].Tasks.Add(task);
          break;
        end;
      end;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;
end;

//function TDataModuleClient.GetStatSelfWorkByUserId(userId:Integer):TObjectList<TStatSelfWork>;
//begin
//  Result:=TObjectList<TStatSelfWork>.Create;
//
//  with ADOQueryGlobal do
//  begin
//    Close;
//    SQL.Clear;
//    SQL.Text:='SELECT id,DateTest,Ball,Effect,LessonId FROM StatisticUser WHERE UserId=:userID';
//    Parameters.ParamByName('userID').Value:=userId;
//    Open;
//    First;
//    while not(Eof) do
//    begin
//      Result.Add(TStatSelfWork.Create(Fields[0].AsInteger,Fields[1].AsDateTime,Fields[2].AsInteger,Fields[3].AsFloat,Fields[4].AsInteger));
//      Next;
//    end;
//  end;
//end;

function TDataModuleClient.GetStatSelfWorkTreeByUserId(userId,cl_num:Integer):TObjectList<TStatSelfWorkTree>;
begin
  Result:=TObjectList<TStatSelfWorkTree>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT course.id, course.NameCourse, lesson.cl_num, lesson.id, lesson.LessonName, stata.Ball_, stata.date_test FROM'+
              ' ((Courses AS course INNER JOIN Lessons AS lesson ON course.id=lesson.CourseID)'+
              ' LEFT JOIN (SELECT LessonId AS lessID, Ball AS Ball_, DateTest AS date_test FROM StatisticUser'+
              ' WHERE DateTest IN (SELECT MAX(DateTest) AS date_test FROM StatisticUser WHERE UserId=:userID GROUP BY LessonId))'+
              ' AS stata ON stata.lessID = lesson.id) WHERE lesson.cl_num=:clnum ORDER BY course.id,  lesson.OrderNumber';
    Parameters.ParamByName('userID').Value:=userId;
    Parameters.ParamByName('clnum').Value:=cl_num;
    Open;
    First;
    while Not(Eof) do
    begin
      Result.Add(TStatSelfWorkTree.Create(Fields[0].AsInteger, Fields[1].AsString,
                  Fields[2].AsInteger, Fields[3].AsInteger, Fields[4].AsString,
                  Fields[5].AsInteger, Fields[6].AsDateTime));
      Next;
    end;
  end;
end;

function TDataModuleClient.AddNewUser(firstName:String; secondName:String; classGroupId: Integer;
  password:String; typeUser:TTypeUser; birthday:TDateTime = 0) : TUserInfo;
var
  created: TDateTime;
  createdUserId:Integer;
begin
  created:=Now;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO [users]([FirstName],[SecondName],[birthday],[class_gr],[password],[type_user],[Created])'+
            ' VALUES(:ftName,:scname,:birthday_,:classID,:pass,:typeUser, :created)');
    Parameters.ParamByName('ftName').Value:=firstName;
    Parameters.ParamByName('scname').Value:=secondName;
    Parameters.ParamByName('birthday_').Value:=FormatDateTime('dd.mm.yyyy', birthday);
    Parameters.ParamByName('classID').Value:= IfThen(typeUser = TTypeUser.Teacher, 0, classGroupId);
    Parameters.ParamByName('pass').Value:=AppTools.StringToHash(password);
    Parameters.ParamByName('typeUser').Value:=typeUser;
    Parameters.ParamByName('created').Value:=FormatDateTime('dd.mm.yyyy hh:nn:ss', created);

    ExecSQL;
  end;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id FROM users WHERE Created=:created AND FirstName=:firstName AND SecondName=:secondName';
    Parameters.ParamByName('created').Value:=FormatDateTime('dd.mm.yyyy hh:nn:ss', created);
    Parameters.ParamByName('firstName').Value:=firstName;
    Parameters.ParamByName('secondName').Value:=secondName;
    Open;

    createdUserId:=Fields[0].AsInteger;
  end;

  Result:=GetUserInfo(createdUserId, password);
end;

function TDataModuleClient.AddNewClassGroup(nameClass:String) : TClassGroup;
begin
  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT id FROM class_ WHERE cl_gr=:clName';
    Parameters.ParamByName('clName').Value:=nameClass;
    Open;

    if(Fields[0].AsInteger <> 0)then
    begin
      raise Exception.Create('������. ����� ��� ����������.');
    end;

    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO [class_] ([cl_gr]) VALUES(:nameClass)');
    Parameters.ParamByName('nameClass').Value:=nameClass;
    ExecSQL;

    Close;
    SQL.Clear;
    SQL.Text:='SELECT id,cl_gr FROM class_ WHERE cl_gr=:clName';
    Parameters.ParamByName('clName').Value:=nameClass;
    Open;

    Result.ID:=Fields[0].AsInteger;
    Result.Name:=nameClass;
  end;
end;

procedure TDataModuleClient.SetPasswordUser(userID:Integer; newPassword: String);
begin
  with ADOQueryGlobal do
  begin
    SQL.Clear;
    SQL.Add('UPDATE [users] SET [password]=:newPass WHERE id=:userID');
    Parameters.ParamByName('newPass').Value:=AppTools.StringToHash(newPassword);
    Parameters.ParamByName('userID').Value:=userID;
    ExecSQL;

    ShowMessage('������ ������� �������.');
  end;
end;

procedure TDataModuleClient.SaveStatisticDiagnostic(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
var
  lastSuccessCourse:TStatCourse;
  statTask: TStatTask;
  statLesson:TStatLesson;
  statTools:TStatistic;

  effect_:real;
  allValidTasks: integer;
  allTasks:Integer;
  AllTimeCourses: Integer;
  i:Integer;
begin
  allValidTasks:=0;
  allTasks:=0;
  effect_:=0;
  AllTimeCourses:=0;

  if(not StatisticTest.First.Lessons.First.Tasks.First.IsTrue)then Exit;

  for i:=0 to StatisticTest.Count-1 do
  begin
    AllTimeCourses:=AllTimeCourses + StatisticTest[i].TimeSeconds;
    for statLesson in StatisticTest[i].Lessons do
    begin
      allTasks:=allTasks + statLesson.Tasks.Count;

      for statTask in statLesson.Tasks do
      begin
        if(statTask.IsTrue)then Inc(allValidTasks);

        if(not statTask.IsTrue)then
        begin
          lastSuccessCourse:=StatisticTest[i - 1];
          Break;
        end;
      end;
    end;

    if(lastSuccessCourse <> nil)then
    begin
      Break;
    end;
  end;

  if(lastSuccessCourse = nil)then
  begin
    lastSuccessCourse:=StatisticTest.Last;
  end;

  statTools:=TStatistic.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO [StatDiagnostic] ([CourseId],[SpentTime_Seconds],[Effect],[UserId],[DateTest])'+
              ' VALUES(:courseId,:timeSeconds,:effect,:userId,:dateTest);');
    Parameters.ParamByName('courseId').Value:=lastSuccessCourse.ID;
    Parameters.ParamByName('timeSeconds').Value:=AllTimeCourses;
    Parameters.ParamByName('effect').Value:=statTools.GetEffection(allValidTasks, allTasks, AllTimeCourses, 2);
    Parameters.ParamByName('userId').Value:=userId;
    Parameters.ParamByName('dateTest').Value:=AppTools.GetCurrentTimeStr();

    ExecSQL;
  end;

  FreeAndNil(statTools);
end;
//
procedure TDataModuleClient.SaveStatisticSelfWork(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
var
  allValidTasks: integer;
  ball_:integer;

  statTask: TStatTask;
  statLesson:TStatLesson;
  statCourse:TStatCourse;

  statTools:TStatistic;
begin
  ball_:=0;
  allValidTasks:=0;

  statTools:=TStatistic.Create;

  for statCourse in StatisticTest do
  begin
    for statLesson in statCourse.Lessons do
    begin
      allValidTasks:=0;

      for statTask in statLesson.Tasks do
      begin
        if(statTask.IsTrue)then
          Inc(allValidTasks);
      end;

      ball_:=statTools.GetBall(allValidTasks, statLesson.Tasks.Count);

      with ADOQueryGlobal do
      begin
        Close;
        SQL.Clear;
        SQL.Add('INSERT INTO [StatisticUser] ([UserId],[DateTest],[Ball],[Effect],[LessonId])VALUES(:usrID,:date_tets,:ball,:effect,:lessonId);');
        Parameters.ParamByName('usrID').Value:=userId;
        Parameters.ParamByName('date_tets').Value := AppTools.GetCurrentTimeStr();
        Parameters.ParamByName('ball').Value:=ball_;
        Parameters.ParamByName('effect').Value:=statTools.GetEffection(allValidTasks,statLesson.Tasks.Count,statLesson.TimeSeconds, 2);
        Parameters.ParamByName('lessonId').Value:=statLesson.ID;
        ExecSQL;
      end;
    end;
  end;

  FreeAndNil(statTools);
end;
//
procedure TDataModuleClient.SaveStatisticClassWork(StatisticTest: TObjectList<TStatCourse>; userId:Integer);
var
  statTask: TStatTask;
  statLesson:TStatLesson;
  statCourse:TStatCourse;
begin
  for statCourse in StatisticTest do
  begin
    for statLesson in statCourse.Lessons do
    begin
      for statTask in statLesson.Tasks do
      begin
        with ADOQueryGlobal do
        begin
          Close;
          SQL.Clear;
          SQL.Add('INSERT INTO [StatClassWork] ([UserId],[TaskId],[SpentTime_sec],[NameDifficulty],[CountHelpClick],[CountAttempt],[DateTest])'+
                  'VALUES(:userID,:taskID,:spentTime,:nameDiff,:countHelp,:countAtt,:dateTest);');
          Parameters.ParamByName('userID').Value:=userId;
          Parameters.ParamByName('taskID').Value:=statTask.ID;
          Parameters.ParamByName('spentTime').Value:=statTask.TimeSeconds;
          Parameters.ParamByName('nameDiff').Value:=statCourse.Difficulty; //AppTools.GetNameDifficulty(statCourse.Difficulty);
//          Parameters.ParamByName('nameDiff').Value:=statCourse. ;
          Parameters.ParamByName('countHelp').Value:=statTask.CountHelpClick;
          Parameters.ParamByName('countAtt').Value:=statTask.CountAttempts;
          Parameters.ParamByName('dateTest').Value:=AppTools.GetCurrentTimeStr();

          ExecSQL;
        end;

      end;
    end;
  end;
end;

//procedure TDataModuleClient.SaveStatisticRaven(userId:Integer {; HLevel: String; SpTime: Integer; TrAnswers: Integer});
//begin
  // with ADOQueryGlobal do
    //    begin
      //    Close;
        //  SQL.Clear;
          //SQL.Add('INSERT INTO [StatRaven] ([userID])'{,[HardLevel],[SpentTime_sec],[TrueAnswers],[DateTest])'}+
          //        'VALUES(:userID)' {,:hardlevel,:spentTime,:TrueAnswers, :dateTest);'});
          //Parameters.ParamByName('userID').Value:=4;
          //Parameters.ParamByName('hardlevel').Value:=HLevel;
          //Parameters.ParamByName('spentTime').Value:=SpTime;
          //Parameters.ParamByName('TrueAnswers').Value:=statCourse.Difficulty;
          //Parameters.ParamByName('dateTest').Value:=AppTools.GetCurrentTimeStr();

          //ExecSQL;
        //end;

//end;

function TDataModuleClient.GetStatDiagnosticByUserId(userId:Integer):TObjectList<TStatDiagnostic>;
begin
  Result:=TObjectList<TStatDiagnostic>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT Courses.Id,Courses.NameCourse,StatDiagnostic.DateTest,StatDiagnostic.SpentTime_Seconds,StatDiagnostic.Effect,Courses.Difficulty,'+
              'StatDiagnostic.Id FROM Courses INNER JOIN StatDiagnostic ON Courses.Id=StatDiagnostic.CourseId'+
              ' WHERE StatDiagnostic.UserId=:userID ORDER BY StatDiagnostic.DateTest ASC';
    Parameters.ParamByName('userID').Value:=userId;
//    Parameters.ParamByName('diff').Value:=diff;
    Open;
    First;
    while not(Eof) do
    begin
      Result.Add(TStatDiagnostic.Create(Fields[6].AsInteger, Fields[0].AsInteger,
                  Fields[1].AsString, Fields[3].AsInteger, Fields[4].AsFloat,
                  Fields[2].AsDateTime, Fields[0].AsInteger));
                                              //5
      Next;
    end;
  end;
end;

function TDataModuleClient.GetAllClassesGroups():TList<TClassGroup>;
var
  class_:TClassGroup;
begin
  Result:=TList<TClassGroup>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT [id],[cl_gr] FROM class_';
    Open;
    First;
    while not(Eof) do
    begin
      class_.ID:=Fields[0].AsInteger;
      class_.Name:=Fields[1].AsString;

      Result.Add(class_);
      Next;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;
end;

function TDataModuleClient.GetUsersByClass(classID:Integer):TList<TUserDTO>;
var
  user: TUserDTO;
begin
  Result:=TList<TUserDTO>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT users.id,users.FirstName,users.SecondName FROM users INNER JOIN class_ ON users.class_gr = class_.ID WHERE class_.ID=:classGrID';
    Parameters.ParamByName('classGrID').Value:=classID;
    Open;
    First;
    while not(Eof) do
    begin
      user.ID:=Fields[0].AsInteger;
      user.FirstName:=Fields[1].AsString;
      user.SecondName:=Fields[2].AsString;

      Result.Add(user);
      Next;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;
end;


function TDataModuleClient.GetUsers(TUser:TTypeUser):TList<TUserDTO>;
var
  user: TUserDTO;
begin
  Result:=TList<TUserDTO>.Create;

  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT users.id,users.FirstName,users.SecondName FROM users WHERE type_user=:tu';
    Parameters.ParamByName('tu').Value:=TUser;
    Open;
    First;
    while not(Eof) do
    begin
      user.ID:=Fields[0].AsInteger;
      user.FirstName:=Fields[1].AsString;
      user.SecondName:=Fields[2].AsString;

      Result.Add(user);
      Next;
    end;
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;
end;



function TDataModuleClient.GetUserInfo(userID:Integer; password:string):TUserInfo;
begin
  with ADOQueryGlobal do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT users.id, users.FirstName, users.SecondName, users.birthday, users.password, users.type_user, class_.ID, class_.cl_gr FROM'+
              ' users LEFT JOIN class_ ON users.class_gr = class_.ID'+
              ' WHERE users.password=:pass AND users.id=:userID';
    Parameters.ParamByName('pass').Value:= AppTools.StringToHash(password);
    Parameters.ParamByName('userID').Value:=userId;
    Open;

    if(Fields[0].AsInteger = 0)then
      Result:=nil
    else
      Result:=TUserInfo.Create(Fields[0].AsInteger, Fields[1].AsString, Fields[2].AsString,
                              Fields[6].AsInteger, Fields[7].AsString,
                              Fields[4].AsString, Fields[5].AsInteger, Fields[3].AsDateTime);
  end;

  ADOQueryGlobal.Close;
  ADOQueryGlobal.Active:=False;
end;

end.

