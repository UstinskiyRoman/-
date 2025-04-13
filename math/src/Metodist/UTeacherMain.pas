unit UTeacherMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.IOUtils, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  UFormBase, UCustomMessageBox, UTaskEditor, UCourseLessonEditor, Generics.Collections, UCourse, UDataModuleBase,
  ULessonInfo, UTaskInfo, UDataModuleEditor, UTools, // UXMLLoader,UConfigEditor,
  UWebPreviewTask, UTaskResourcesManager;

type
  TFTeacherMain = class(TFormBase)
    btnExit: TButton;
    btnUserEditor: TButton;
    btnTaskEditor: TButton;
    btnCourseEditor: TButton;
    grpbTaskEditorMenu: TGroupBox;
    btnCloseTaskEditorMenu: TButton;
    btnCreateTask: TButton;
    grpbUpdateTasksMenu: TGroupBox;
    btnCloseUpdTask: TButton;
    cmbCourses: TComboBox;
    cmbLessons: TComboBox;
    cmbTasks: TComboBox;
    btnPreviewTask: TButton;
    btnUpdateTask: TButton;
    btnUpdateTasksMenu: TButton;
    lblCourses: TLabel;
    lblLessons: TLabel;
    lblTasks: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure btnTaskEditorClick(Sender: TObject);
    procedure btnCourseEditorClick(Sender: TObject);
    procedure btnCloseTaskEditorMenuClick(Sender: TObject);
    procedure btnCreateTaskClick(Sender: TObject);
    procedure btnCloseUpdTaskClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnUpdateTasksMenuClick(Sender: TObject);
    procedure cmbCoursesChange(Sender: TObject);
    procedure cmbLessonsChange(Sender: TObject);
    procedure btnPreviewTaskClick(Sender: TObject);
    procedure btnUpdateTaskClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    courses: TDictionary<integer, TCourse>;
    lessons: TDictionary<integer, TLesson>;
    tasks: TDictionary<integer, TTask>;

    procedure InitListCourses();
    procedure InitListLessonsByCourse(courseId: integer);
    procedure InitTasksByLesson(lessonId: integer);
    function GetFormattedTextForListTasks(task: TTask): string;
  public
    procedure RefreshTaskForPreview(taskId: integer);
  end;

var
  FTeacherMain: TFTeacherMain;

implementation

{$R *.dfm}

//uses UMainMenu;

function TFTeacherMain.GetFormattedTextForListTasks(task: TTask): string;
begin
  var modeName := Tools.GetNameModeTest(task.ModeType);
  Result := Format('ID: %d, %s', [task.ID, modeName]);//  %s,task.MetaInfo,
end;

procedure TFTeacherMain.InitListCourses();
var
  course: TCourse;
begin
  cmbCourses.Clear;

  courses := TDictionary<integer, TCourse>.Create;
  for course in DataModuleBase.GetCourses() do
  begin
    cmbCourses.Items.Add(course.Name);
    courses.Add(cmbCourses.Items.Count - 1, course);
  end;
end;

procedure TFTeacherMain.InitListLessonsByCourse(courseId: integer);
var
  lesson: TLesson;
begin
  cmbLessons.Clear;
  lessons := TDictionary<integer, TLesson>.Create;

  for lesson in DataModuleBase.GetLessons(courseId) do
  begin
    cmbLessons.Items.Add(lesson.Name);
    lessons.Add(cmbLessons.Items.Count - 1, lesson);
  end;
end;

procedure TFTeacherMain.InitTasksByLesson(lessonId: integer);
var
  task: TTask;
  modeName: string;
begin
  cmbTasks.Clear;
  tasks := TDictionary<integer, TTask>.Create;

  for task in DataModuleEditor.GetTasksByLessonId(lessonId) do
  begin
    modeName := Tools.GetNameModeTest(task.ModeType);
    cmbTasks.Items.Add(GetFormattedTextForListTasks(task));
    tasks.Add(cmbTasks.Items.Count - 1, task);
  end;
end;

procedure TFTeacherMain.RefreshTaskForPreview(taskId: integer);
begin
  if cmbTasks.Items.Count = 0 then raise Exception.Create('Ошибка при загрузке задачи с ID = ' + IntToStr(taskId));

  var task := DataModuleEditor.GetTaskById(taskId);

  if (lessons[cmbLessons.ItemIndex].ID <> task.LessonID) then
  begin
    for var lesson in lessons do
    begin
      if task.LessonID = lesson.Value.ID then
      begin
        cmbLessons.ItemIndex := lesson.Key;
        cmbLessonsChange(Self);
        Break;
      end;
    end;
  end;

  for var i := 0 to cmbTasks.Items.Count do
  begin
    if cmbTasks.Items[i] = GetFormattedTextForListTasks(task) then
    begin
      cmbTasks.ItemIndex := i;
      tasks[i] := task;
      Break;
    end;
  end;
end;

procedure TFTeacherMain.btnCloseTaskEditorMenuClick(Sender: TObject);
begin
  grpbTaskEditorMenu.Visible := false;
end;

procedure TFTeacherMain.btnCloseUpdTaskClick(Sender: TObject);
begin
  cmbLessons.Clear;
  cmbTasks.Clear;

  grpbUpdateTasksMenu.Visible := False;
end;

procedure TFTeacherMain.btnCourseEditorClick(Sender: TObject);
var
  CourseLessonEditor: TFCourseLessonEditor;
begin
  Self.Hide;
  CourseLessonEditor := TFCourseLessonEditor.Create(nil);
  CourseLessonEditor.Show();
end;

procedure TFTeacherMain.btnCreateTaskClick(Sender: TObject);
var
  taskEditor: TFTaskEditor;
begin
  Self.Hide;
  taskEditor := TFTaskEditor.Create(nil);
  taskEditor.MenuUpdateTask.Enabled := false;
  taskEditor.Show();
end;

procedure TFTeacherMain.btnExitClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите выйти?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    Self.Close;
//    FMainMenu.Show();
  end;
end;

procedure TFTeacherMain.btnPreviewTaskClick(Sender: TObject);
var
  preview: TFWebPreviewTask;
begin
  //if cmbTasks.ItemIndex = -1 then raise Exception.Create('Выберите задачу из списка');
  if cmbTasks.ItemIndex = -1 then
  begin
   FCustomMessageBox.SetMessage('Ошибка', 'Вы не выбрали задачу!', TTypeMessage.msgOK);
   Exit;
  end;

  if (tasks[cmbTasks.ItemIndex].ResourceId <> EmptyStr) then
  begin
    var manager := TTaskResourcesManager.CreateBySavedResources(tasks[cmbTasks.ItemIndex].ResourceId);
    preview := TFWebPreviewTask.Create(nil, tasks[cmbTasks.ItemIndex], manager);
  end else
  begin
    preview := TFWebPreviewTask.Create(nil, tasks[cmbTasks.ItemIndex], nil);
  end;
  preview.CheckTask();
end;

procedure TFTeacherMain.btnTaskEditorClick(Sender: TObject);
begin
  grpbTaskEditorMenu.Visible := true;
end;

procedure TFTeacherMain.btnUpdateTaskClick(Sender: TObject);
var
  taskEditor: TFTaskEditor;
begin
  if cmbTasks.ItemIndex = -1 then raise Exception.Create('Выберите задачу из списка');

  taskEditor := TFTaskEditor.Create(nil);
  taskEditor.LoadTaskForUpdate(tasks[cmbTasks.ItemIndex].ID);          //, размер: %s  , tasks[cmbTasks.ItemIndex].MetaInfo
	taskEditor.Caption := taskEditor.Caption +'. '+ Format('ID задачи: %d', [tasks[cmbTasks.ItemIndex].ID]);
  taskEditor.Show();

  Self.Hide;
end;

procedure TFTeacherMain.btnUpdateTasksMenuClick(Sender: TObject);
begin
  grpbUpdateTasksMenu.Visible := True;
end;

procedure TFTeacherMain.cmbCoursesChange(Sender: TObject);
begin
  if (cmbCourses.ItemIndex = -1) then raise Exception.Create('Пожалуйста, выберите тематику');

  cmbCourses.Hint := Format('Всего задач: %d', [DataModuleEditor.GetTotalTasksByCourseId(courses[cmbCourses.ItemIndex].ID)]);
  InitListLessonsByCourse(courses[cmbCourses.ItemIndex].ID);
  cmbTasks.Clear;
end;

procedure TFTeacherMain.cmbLessonsChange(Sender: TObject);
begin
  if (cmbLessons.ItemIndex = -1) then raise Exception.Create('Пожалуйста, выберите урок');

  InitTasksByLesson(lessons[cmbLessons.ItemIndex].ID);

  cmbLessons.Hint := Format('Всего задач: %d', [DataModuleEditor.GetTotalTasksByLessonId(lessons[cmbLessons.ItemIndex].ID)]);
end;

procedure TFTeacherMain.ExecuteClose();
begin
  btnExit.Click;
end;

procedure TFTeacherMain.FormCreate(Sender: TObject);
begin
  //XMLLoader := TXMLLoader.Create(FTeacherMain);
  InitListCourses();
end;

end.
