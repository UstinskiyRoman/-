unit UDataModuleEditor;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, UDataModuleBase,
  UDataModuleSQLiteBase, UTypeTasks, UModes, ULessonInfo, Generics.Collections,
  UTaskInfo, UConfigClient, //UConfigEditor,
   UTaskResources;

type
  TDataModuleEditor = class(TDataModule)
    ADOQuery1: TADOQuery;
    ADOQueryEditor: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure CreateLesson(lessonName: string; description: string; theory: string; courseId: integer; orderNumber:integer; cl_num:Integer);
    procedure RemoveLesson(id: integer);
    procedure UpdateLessons(id: integer; lessonName: string; description: string; theory: string; CurseId:Integer; orderNumber:integer; cl_num:Integer);
    procedure CreateTask(task: TTask; resource: TTaskResources);
    procedure UpdateTask(task: TTask; resource: TTaskResources);
    function GetTasksByLessonId(lessonId: integer): TObjectList<TTask>;
    function GetTaskById(taskId: integer):TTask;
    function GetTotalTasksByCourseId(courseId: integer): integer;
    function GetTotalTasksByLessonId(lessonId: integer): integer;
  end;

var
  DataModuleEditor: TDataModuleEditor;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModuleEditor.DataModuleCreate(Sender: TObject);
begin
//  DataModuleBase.Init(Config.PathDataBase);
//  DataModuleSQLiteBase.Init(Config.PathToResourceDataBase, Config.PathToSQLiteLib);
end;

procedure TDataModuleEditor.CreateLesson(lessonName: string; description: string; theory: string; courseId: integer; orderNumber:integer; cl_num:Integer);
begin
  if(lessonname = EmptyStr)then raise Exception.Create('Lesson name is empty');
  if(courseId <= 0)then raise Exception.Create('Course Id is empty');
  ADOQueryEditor.Close;
//  with ADOQueryEditor do
//  begin
//    Close;
    ADOQueryEditor.SQL.Clear;
    ADOQueryEditor.SQL.Text := 'SELECT NameCourse FROM Courses WHERE Id=:courseId';
    ADOQueryEditor.Parameters.ParamByName('courseId').Value:=courseId;
    ADOQueryEditor.Open;

    if ADOQueryEditor.Fields[0].AsString = EmptyStr then
     raise Exception.Create(Format('Course with Id = %d not found', [courseId]));
//  end;

//  with ADOQueryEditor do
//  begin
    ADOQueryEditor.Close;
    ADOQueryEditor.SQL.Clear;
    ADOQueryEditor.SQL.Text := 'SELECT LessonName FROM Lessons WHERE LessonName=:lslName';
    ADOQueryEditor.Parameters.ParamByName('lslName').Value:=lessonName;
    ADOQueryEditor.Open;

    if ADOQueryEditor.Fields[0].AsString <> EmptyStr then
     raise Exception.Create(Format('Lesson with name %s already exist', [lessonName]));
//  end;

//  with ADOQueryEditor do
//  begin
    ADOQueryEditor.Close;
    ADOQueryEditor.SQL.Clear;
    ADOQueryEditor.SQL.Add('INSERT INTO [Lessons]([LessonName], [Description], [Theory], [CourseID], [OrderNumber],[cl_num]) VALUES(:lessonName, :lessonDescription, :lessonTheory, :courseId, :orderNumber, :cl_num)');
    ADOQueryEditor.Parameters.ParamByName('lessonName').Value:=lessonName;
    ADOQueryEditor.Parameters.ParamByName('lessonDescription').Value:=description;
    ADOQueryEditor.Parameters.ParamByName('theory').Value:=theory;
    ADOQueryEditor.Parameters.ParamByName('courseId').Value:=courseId;
    ADOQueryEditor.Parameters.ParamByName('orderNumber').Value:=orderNumber;
    ADOQueryEditor.Parameters.ParamByName('cl_num').Value:=cl_num;
    ADOQueryEditor.ExecSQL;
//  end;
end;

procedure TDataModuleEditor.UpdateLessons(id: integer; lessonName: string; description: string; theory: string; CurseId:Integer; orderNumber:integer; cl_num:Integer);
begin
  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('UPDATE Lessons SET LessonName=:lessonName, Description=:description, Theory=:theory, CourseId=:curseid, OrderNumber=:ordNumber,cl_num=:cl_num WHERE Id=:lessonId');
    Parameters.ParamByName('lessonId').Value:=id;
    Parameters.ParamByName('lessonName').Value:=lessonName;
    Parameters.ParamByName('description').Value:=description;
    Parameters.ParamByName('theory').Value:=theory;
    Parameters.ParamByName('CurseId').Value:=CurseId;
    Parameters.ParamByName('ordNumber').Value:=orderNumber;
    Parameters.ParamByName('cl_num').Value:=cl_num;
    ExecSQL;
  end;
end;

procedure TDataModuleEditor.RemoveLesson(id: integer);
begin
  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Add('DELETE FROM Lessons WHERE Id=:lessonId');
    Parameters.ParamByName('lessonId').Value:=id;
    ExecSQL;
  end;
end;


procedure TDataModuleEditor.CreateTask(task: TTask; resource: TTaskResources);
var
  lesson: TLesson;
begin
  if(task.TaskBody = EmptyStr)then raise Exception.Create('Html body task is empty');
  if(task.ConditionBody = EmptyStr)then raise Exception.Create('Html condition body task is empty');
//  if(task.MetaInfo.RawInfo = EmptyStr)then raise Exception.Create('Meta info task is empty');

  lesson := DataModuleBase.GetLesson(task.LessonID);
  if (lesson.ID = 0) or (lesson.Name = EmptyStr) then raise Exception.Create('Lesson not found');

  if not ADOQueryEditor.Connection.InTransaction then ADOQueryEditor.Connection.BeginTrans;

  try
    with ADOQueryEditor do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO [Tasks]([TaskBody], [ConditionBody], [TypeTask], [LessonID], [ModeType], [ResourceName], [MetaInfo])');
      SQL.Add('VALUES(:htmlBody, :htmlConditionBody, :typeTask, :lessonId, :modeType, :resName, :rawMetaInfoTask)');
      Parameters.ParamByName('htmlBody').Value := task.TaskBody;
      Parameters.ParamByName('htmlConditionBody').Value := task.ConditionBody;
      Parameters.ParamByName('typeTask').Value := Ord(task.TypeTask);
      Parameters.ParamByName('lessonId').Value := task.LessonId;
      Parameters.ParamByName('modeType').Value := Ord(task.ModeType);
      Parameters.ParamByName('resName').Value := task.ResourceId;
      Parameters.ParamByName('rawMetaInfoTask').Value := task.MetaInfo;
      ExecSQL;
    end;

    if (task.ResourceId <> EmptyStr) and (resource <> nil) then
    begin                                          //resource.RawXmlImageRows, resource.RawXmlImageCols,
      DataModuleSQLiteBase.Insert(task.ResourceId, resource.AudioCondition, resource.TableVideoSolution, nil);
    end;

    ADOQueryEditor.Connection.CommitTrans;
  except
    begin
      ADOQueryEditor.Connection.RollbackTrans;
      raise;
    end;
  end;
end;

procedure TDataModuleEditor.UpdateTask(task: TTask; resource: TTaskResources);
begin
  if not ADOQueryEditor.Connection.InTransaction then ADOQueryEditor.Connection.BeginTrans;

  try
    with ADOQueryEditor do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE Tasks SET TaskBody=:body, ConditionBody=:condition, LessonID=:lessonId, ModeType=:mode, MetaInfo=:metainfo, ResourceName=:resName WHERE Id=:taskId');
      Parameters.ParamByName('body').Value := task.TaskBody;
      Parameters.ParamByName('condition').Value := task.ConditionBody;
      Parameters.ParamByName('lessonId').Value := task.LessonID;
      Parameters.ParamByName('mode').Value := Ord(task.ModeType);
      Parameters.ParamByName('metainfo').Value := task.MetaInfo;
      Parameters.ParamByName('taskId').Value := task.ID;
      Parameters.ParamByName('resName').Value := task.ResourceId;
      ExecSQL;
    end;

    if (task.ResourceId <> EmptyStr) and (resource <> nil) then
    begin
      if (DataModuleSQLiteBase.HasResourcesInDataBase(task.ResourceId)) then
      begin                                          //resource.RawXmlImageRows, resource.RawXmlImageCols,
        DataModuleSQLiteBase.Update(task.ResourceId, resource.AudioCondition, resource.TableVideoSolution, nil);
      end else
      begin                                         // resource.RawXmlImageRows, resource.RawXmlImageCols,
        DataModuleSQLiteBase.Insert(task.ResourceId, resource.AudioCondition, resource.TableVideoSolution, nil);
      end;
    end;

    ADOQueryEditor.Connection.CommitTrans;
  except
    begin
      ADOQueryEditor.Connection.RollbackTrans;
      raise;
    end;
  end;

  ADOQueryEditor.Close;
  ADOQueryEditor.Active:=False;
end;

function TDataModuleEditor.GetTasksByLessonId(lessonId: integer): TObjectList<TTask>;
var
  task:TTask;
begin
  Result := TObjectList<TTask>.Create;

  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT Id, TaskBody, MetaInfo, TypeTask, LessonID, ConditionBody, ModeType, ResourceName FROM Tasks WHERE LessonID=:lessonId ORDER BY ModeType, Id';
    Parameters.ParamByName('lessonId').Value := lessonId;
    Open;
    First;
    while not(eof) do
    begin
      task := TTask.Create(Fields[0].AsInteger,
                            Fields[1].AsString,
                            Fields[5].AsString,
                            TTypeTask(Fields[3].AsInteger),
                            Fields[4].AsInteger,
                            TMode(Fields[6].AsInteger),
                            Fields[2].AsString,
                            Fields[7].AsString,
                            true);

      Result.Add(task);

      Next;
    end;
  end;

  ADOQueryEditor.Close;
  ADOQueryEditor.Active:=False;
end;

function TDataModuleEditor.GetTaskById(taskId: integer):TTask;
begin
  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT Id, TaskBody, MetaInfo, TypeTask, LessonID, ConditionBody, ModeType, ResourceName FROM Tasks WHERE Id=:taskId';
    Parameters.ParamByName('taskId').Value := taskId;
    Open;
    Result := TTask.Create(Fields[0].AsInteger,
                           Fields[1].AsString,
                           Fields[5].AsString,
                           TTypeTask(Fields[3].AsInteger),
                           Fields[4].AsInteger,
                           TMode(Fields[6].AsInteger),
                           Fields[2].AsString,
                           Fields[7].AsString,
                           true);
  end;

  ADOQueryEditor.Close;
  ADOQueryEditor.Active:=False;
end;

function TDataModuleEditor.GetTotalTasksByCourseId(courseId: integer): integer;
begin
  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT COUNT(Tasks.Id) FROM Tasks INNER JOIN Lessons ON Tasks.LessonId = Lessons.Id WHERE Lessons.CourseId=:courseId';
    Parameters.ParamByName('courseId').Value := courseId;
    Open;

    Result := Fields[0].AsInteger;
  end;
end;

function TDataModuleEditor.GetTotalTasksByLessonId(lessonId: integer): integer;
begin
  with ADOQueryEditor do
  begin
    Close;
    SQL.Clear;
    SQL.Text:='SELECT COUNT(Id) FROM Tasks WHERE LessonId=:lessonId';
    Parameters.ParamByName('lessonId').Value := lessonId;
    Open;

    Result := Fields[0].AsInteger;
  end;
end;

end.
