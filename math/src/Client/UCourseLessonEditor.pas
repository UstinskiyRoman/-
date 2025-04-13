unit UCourseLessonEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UFormBase, UCustomMessageBox,
  Vcl.ExtCtrls, Generics.Collections, UCourse, ULessonInfo, UDataModuleBase,
  UDataModuleEditor;

type
  TFCourseLessonEditor = class(TFormBase)
    btnExit: TButton;
    grpboxRemoveLessons: TGroupBox;
    cmbLessonsForRemove: TComboBox;
    memoRemovingLesson: TMemo;
    btnRemoveLesson: TButton;
    cmbCourses: TComboBox;
    grpboxUpdateLessons: TGroupBox;
    cmbLessonsForUpdate: TComboBox;
    memoDescriptionUpdatingLessons: TMemo;
    btnApplyChanges: TButton;
    lblEditUpdLesson: TLabeledEdit;
    lbleditOrderLesson2: TLabeledEdit;
    grpboxCreationLessons: TGroupBox;
    editLessonName: TLabeledEdit;
    memoDescriptionLesson: TMemo;
    cmboxCoursesForNewLessons: TComboBox;
    btnCreateLesson: TButton;
    lbleditOrderLesson: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    CmbClass: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    CmbUpdCl: TComboBox;
    Label5: TLabel;
    procedure btnExitClick(Sender: TObject);
    procedure btnCreateLessonClick(Sender: TObject);
    procedure cmbLessonsForUpdateChange(Sender: TObject);
    procedure cmbLessonsForUpdateDropDown(Sender: TObject);
    procedure btnApplyChangesClick(Sender: TObject);
    procedure cmbLessonsForRemoveChange(Sender: TObject);
    procedure cmbLessonsForRemoveDropDown(Sender: TObject);
    procedure btnRemoveLessonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cmboxCoursesForNewLessonsSelect(Sender: TObject);
    procedure cmbCoursesSelect(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    lessons: TDictionary<integer, TLesson>;
    courses: TDictionary<integer, TCourse>;

    procedure InitListCourses();
    procedure InitListLessons();
    procedure CreateLessons();
    procedure UpdateLesson();
    procedure RemoveLesson();
  public
    { Public declarations }
  end;

var
  FCourseLessonEditor: TFCourseLessonEditor;

implementation

uses UTeacherMain;

{$R *.dfm}

procedure TFCourseLessonEditor.btnApplyChangesClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите сохранить изменения для выбранного урока?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    UpdateLesson();

    lblEditUpdLesson.Clear;
    lblEditOrderLesson2.Clear;
    memoDescriptionUpdatingLessons.Clear;
    cmbCourses.ItemIndex:=-1;
    cmbUpdCl.ItemIndex:=-1;
    InitListLessons();
  end;
end;

procedure TFCourseLessonEditor.btnCreateLessonClick(Sender: TObject);
begin
  CreateLessons();

  editLessonName.Clear;
  memoDescriptionLesson.Clear;
  //InitListCourses();
end;

procedure TFCourseLessonEditor.btnExitClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите выйти?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    FTeacherMain.Show();
    Self.Close;
  end;
end;

procedure TFCourseLessonEditor.btnRemoveLessonClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите удалить выбранный урок?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    RemoveLesson();
    memoRemovingLesson.Clear;
    InitListLessons();
  end;
end;

procedure TFCourseLessonEditor.cmbCoursesSelect(Sender: TObject);
var
  i:Integer;
begin
 cmbUpdCl.Items.Clear;
 for I := courses[cmbCourses.ItemIndex].difficulty to 11 do
  cmbUpdCl.Items.Add(IntToStr(i));
end;

procedure TFCourseLessonEditor.cmbLessonsForRemoveChange(Sender: TObject);
begin
  memoRemovingLesson.Text := lessons[cmbLessonsForRemove.ItemIndex].Description;
end;

procedure TFCourseLessonEditor.cmbLessonsForRemoveDropDown(Sender: TObject);
begin
  InitListLessons();
end;

procedure TFCourseLessonEditor.cmbLessonsForUpdateChange(Sender: TObject);
var
  i:Integer;
begin
  if cmbLessonsForUpdate.ItemIndex = -1 then exit;

  for i := 0 to courses.Count-1 do
   begin
    if lessons[cmbLessonsForUpdate.ItemIndex].CourseID = courses[i].ID then
     begin
      cmbCourses.ItemIndex:=i;
      cmbCoursesSelect(cmbCourses);
      break;
     end;
   end;


  for i:=0 to cmbUpdCl.Items.Count-1 do
   begin
    if cmbUpdCl.Items[i] = IntToStr(lessons[cmbLessonsForUpdate.ItemIndex].cl_num) then
     begin
      cmbUpdCl.ItemIndex:=i;
      break;
     end;
   end;

  memoDescriptionUpdatingLessons.Text := lessons[cmbLessonsForUpdate.ItemIndex].Description;
  lblEditUpdLesson.Text := lessons[cmbLessonsForUpdate.ItemIndex].Name;
  lbleditOrderLesson2.Text := IntToStr(lessons[cmbLessonsForUpdate.ItemIndex].OrderNumber);
end;

procedure TFCourseLessonEditor.cmbLessonsForUpdateDropDown(Sender: TObject);
begin
  InitListLessons();
end;

procedure TFCourseLessonEditor.cmboxCoursesForNewLessonsSelect(Sender: TObject);
var
  i:Integer;
begin
 cmbClass.Items.Clear;
 for I := courses[cmboxCoursesForNewLessons.ItemIndex].difficulty to 11 do
  cmbClass.Items.Add(IntToStr(i));
end;

procedure TFCourseLessonEditor.ExecuteClose();
begin
  btnExit.Click;
end;

procedure TFCourseLessonEditor.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  action := caFree;
  FCourseLessonEditor := nil;
end;

procedure TFCourseLessonEditor.FormCreate(Sender: TObject);
begin
  InitListLessons();
  InitListCourses();
end;

procedure TFCourseLessonEditor.InitListCourses();
var
  course: TCourse;
begin
  cmbCourses.Clear;
  cmboxCoursesForNewLessons.Clear;

  courses := TDictionary<integer, TCourse>.Create;
  for course in DataModuleBase.GetCourses() do
  begin
    cmbCourses.Items.Add(course.Name);
    cmboxCoursesForNewLessons.Items.Add(course.Name);

    courses.Add(cmbCourses.Items.Count - 1, course);
  end;
end;

procedure TFCourseLessonEditor.InitListLessons();
var
  lesson: TLesson;
begin
  cmbLessonsForRemove.Clear;
  cmbLessonsForUpdate.Clear;
  lessons := TDictionary<integer, TLesson>.Create;

  for lesson in DataModuleBase.GetLessons() do
  begin
    cmbLessonsForRemove.Items.Add(lesson.Name);
    cmbLessonsForUpdate.Items.Add(lesson.Name);

    lessons.Add(cmbLessonsForRemove.Items.Count - 1, lesson);
  end;
end;

procedure TFCourseLessonEditor.CreateLessons();
begin
  if editLessonName.Text = EmptyStr then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Название урока не задано.', TTypeMessage.msgOK);
    Exit;
  end;

  if cmboxCoursesForNewLessons.ItemIndex = -1 then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Выберите тематику, для которой хотите создать урок.', TTypeMessage.msgOK);
    exit;
  end;

  if cmbClass.ItemIndex = -1 then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Выберите класс, для которого хотите создать урок.', TTypeMessage.msgOK);
    exit;
  end;

  DataModuleEditor.CreateLesson(editLessonName.Text, memoDescriptionLesson.Text, courses[cmboxCoursesForNewLessons.ItemIndex].ID, StrToInt(lbleditOrderLesson.Text),StrToInt(cmbClass.Text));
  FCustomMessageBox.SetMessage('Информация', 'Урок успешно создан', TTypeMessage.msgOK);
end;

procedure TFCourseLessonEditor.UpdateLesson();
begin
  if cmbLessonsForUpdate.ItemIndex = -1 then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Выберите урок, который хотите обновить.', TTypeMessage.msgOK);
    exit;
  end;

  if lblEditUpdLesson.Text = EmptyStr then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Укажите имя урока.', TTypeMessage.msgOK);
    exit;
  end;

  DataModuleEditor.UpdateLessons(lessons[cmbLessonsForUpdate.ItemIndex].ID, lblEditUpdLesson.Text, memoDescriptionUpdatingLessons.Text,courses[cmbCourses.ItemIndex].ID, StrToInt(lbleditOrderLesson2.Text),StrToInt(cmbUpdCl.Text));
  FCustomMessageBox.SetMessage('Информация', 'Урок успешно изменён.', TTypeMessage.msgOK);
end;

procedure TFCourseLessonEditor.RemoveLesson();
begin
  if cmbLessonsForRemove.ItemIndex = -1 then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Выберите урок, который хотите удалить.', TTypeMessage.msgOK);
    exit;
  end;

  DataModuleEditor.RemoveLesson(lessons[cmbLessonsForRemove.ItemIndex].ID);
  FCustomMessageBox.SetMessage('Информация', 'Урок успешно удалён.', TTypeMessage.msgOK);
end;


end.
