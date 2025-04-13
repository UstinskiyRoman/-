unit UTaskEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UFormBase, Vcl.StdCtrls, UCustomMessageBox,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus, UNotifyEventWrapper, UWebPreviewTask,
  //UConfigEditor,
  UDataModuleBase, Generics.Collections, UCourse, ULessonInfo,
  UDataModuleEditor, Soap.EncdDecd, UTypeTasks, UModes, UTools, System.NetEncoding,
  //XML.XMLDoc, XML.XMLIntf, UResourceImage, Vcl.ClipBrd,
  UTaskInfo,System.IOUtils,
  UDataModuleSQLiteBase, UTaskResources, UTaskResourcesManager,
  {for supporting different images format}
  //Vcl.Imaging.Jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg, Vcl.Graphics,
  Vcl.MPlayer;

type
  TFTaskEditor = class(TFormBase)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    MenuExit: TMenuItem;
    MenuSaveTask: TMenuItem;
    MenuUpdateTask: TMenuItem;
    MenuCheckTask: TMenuItem;
    OpenDialogForAudio: TOpenDialog;
    OpenDialogForVideo: TOpenDialog;
    N2: TMenuItem;
    LoadAudioCondition: TMenuItem;
    LoadVideoSolutionForTable: TMenuItem;
    N3: TMenuItem;
    LoadTemplateForBodyTask: TMenuItem;
    LoadTemplateForConditionTask: TMenuItem;
    LoadTemplateForMetaInfoTask: TMenuItem;
    cmbModes: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    lblCourse: TLabel;
    cmbLessonsForTask: TComboBox;
    ChB1: TCheckBox;
    Bevel1: TBevel;
    ChBV1: TCheckBox;
    Lb1: TLabel;
    Ed1: TEdit;
    Bt1: TButton;
    Panel1: TPanel;
    Bevel2: TBevel;
    ChB2: TCheckBox;
    ChBV2: TCheckBox;
    Label3: TLabel;
    Ed2: TEdit;
    Bt2: TButton;
    Bevel3: TBevel;
    ChB3: TCheckBox;
    ChBV3: TCheckBox;
    Label4: TLabel;
    Ed3: TEdit;
    Bt3: TButton;
    Bevel4: TBevel;
    ChB4: TCheckBox;
    ChBV4: TCheckBox;
    Label5: TLabel;
    Ed4: TEdit;
    Bt4: TButton;
    Bevel5: TBevel;
    ChB5: TCheckBox;
    ChBV5: TCheckBox;
    Label6: TLabel;
    Ed5: TEdit;
    Bt5: TButton;
    Bevel6: TBevel;
    ChBVe: TCheckBox;
    Label7: TLabel;
    Ede: TEdit;
    Bte: TButton;
    Er: TEdit;
    M1: TMemo;
    Label8: TLabel;
    M2: TMemo;
    Label9: TLabel;
    Label10: TLabel;
    LbE: TLabel;
    procedure MenuExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuCheckTaskClick(Sender: TObject);
    procedure MenuSaveTaskClick(Sender: TObject);
    procedure cmbLessonsForTaskDropDown(Sender: TObject);
    procedure cmbLessonsForTaskChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MenuUpdateTaskClick(Sender: TObject);
    procedure LoadAudioConditionClick(Sender: TObject);
    procedure LoadVideoSolutionForTableClick(Sender: TObject);
    procedure ChBV1Click(Sender: TObject);
    procedure Bt1Click(Sender: TObject);
    procedure ChBVeClick(Sender: TObject);
    procedure BteClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    lessons: TDictionary<integer, TLesson>;
    taskForUpdate: TTask;
    audioCondition: TBytesStream;
    tableVideoSolution: TBytesStream;
    mTaskBody,mConditionBody,mMetaInfo:TStrings;

    procedure InitListLessons();
    procedure InitListModes();
    procedure GetForm;
    procedure InternalCreateTask(task: TTask; resources: TTaskResources);
    procedure InternalUpdateTask(task: TTask);
    function GetResourcesForTask(): TTaskResources;
    function ConvertRawDataToTask(needForPreview: boolean):TTask;
    procedure SetForm;
  public
    procedure LoadTaskForUpdate(taskId: integer);
  end;

var
  FTaskEditor: TFTaskEditor;
  tools: TTools;

implementation

uses UTeacherMain;

{$R *.dfm}


procedure TFTaskEditor.GetForm;
var
 ChB:TCheckBox;
 i:Integer;
 s:String;
begin
 mTaskBody.Clear;
 mConditionBody.Clear;
 mMetaInfo.Clear;
 s:='';
 mTaskBody.Add('Components');
 for i:=1 to 5 do
  begin
   ChB:=(FindComponent('ChB'+IntToStr(i)) As TCheckBox);
   if ChB.Enabled then
    begin
     mTaskBody.Add(ChB.Name+';'+ChB.Caption+';');
     if ChB.Checked then s:=s+ChB.Name+';';
    end;
  end;
 if Er.Enabled then
  begin
   mTaskBody.Add('Er;'+Lbe.Caption+';');
   s:=s+Er.Text+';';
  end;
 mTaskBody.Add('end');
 mConditionBody.Add(s);
 for i:=0 to M1.Lines.Count-1 do
  mTaskBody.Add(M1.Lines[i]);
 mMetaInfo.Assign(M2.Lines);
end;


procedure TFTaskEditor.SetForm;
var
 i:Integer;
 s,s1:String;
 ChB:TCheckBox;
begin
 i:=1;
 while mTaskBody[i]<>'end' do
  begin
   s:=MTaskBody[i];
   if s[1]='C' then
    begin
     s1:=Copy(s,4,Pos(';',s)-4);
     (FindComponent('ChB'+s1) As TCheckBox).Enabled:=True;
     (FindComponent('ChBV'+s1) As TCheckBox).Checked:=True;
     (FindComponent('Ed'+s1) As TEdit).Enabled:=True;
     (FindComponent('Bt'+s1) As TButton).Enabled:=True;
     Delete(s,1,Pos(';',s));
     (FindComponent('ChB'+s1) As TCheckBox).Caption:=Copy(s,1,Pos(';',s)-1);
     (FindComponent('Ed'+s1) As TEdit).Text:=Copy(s,1,Pos(';',s)-1);
    end
   else
    begin
     ChBVe.Checked:=True;
     Ede.Enabled:=True;
     Bte.Enabled:=True;
     Er.Enabled:=True;
     Delete(s,1,Pos(';',s));
     Lbe.Caption:=Copy(s,1,Pos(';',s)-1);
     Ede.Text:=Lbe.Caption;
    end;
   Inc(i);
  end;
 Inc(i);
 M1.Lines.Clear;
 while i<=mTaskBody.Count-1 do
  begin
   M1.Lines.Add(mTaskBody[i]);
   Inc(i);
  end;
 M2.Lines.Clear;
 M2.Lines.Assign(mMetaInfo);

 s:=mConditionBody[0];
 while Pos(';',s)>0 do
  begin
   if s[1]='C' then
    (FindComponent('ChB'+Copy(s,4,Pos(';',s)-4)) As TCheckBox).Checked:=True
   else
    Er.Text:=Copy(s,1,Pos(';',s)-1);
   Delete(s,1,Pos(';',s));
  end;


end;


procedure TFTaskEditor.InitListLessons();
begin
  cmbLessonsForTask.Clear;
  lessons := TDictionary<integer, TLesson>.Create;

  for var lesson in DataModuleBase.GetLessons() do
  begin
    cmbLessonsForTask.Items.Add(lesson.Name);

    lessons.Add(cmbLessonsForTask.Items.Count - 1, lesson);
  end;
end;

procedure TFTaskEditor.InitListModes();
begin
  cmbModes.Clear;
  cmbModes.Items.Add(tools.GetNameModeTest(TMode.ClassWork));
  cmbModes.Items.Add(tools.GetNameModeTest(TMode.SelfWork));
  cmbModes.Items.Add(tools.GetNameModeTest(TMode.Diagnostic));
end;



function AnonProc2NotifyEvent(Owner: TComponent; Proc: TProc<TObject>): TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(Owner, Proc).Event;
end;


function TFTaskEditor.ConvertRawDataToTask(needForPreview: boolean):TTask;
begin
  if (not needForPreview) and (cmbModes.ItemIndex = -1)then raise Exception.Create('Укажите режим тестирования, в котором будет находится задача.');
  if (not needForPreview) and (cmbLessonsForTask.ItemIndex = -1)then raise Exception.Create('Выберите урок, для которого будет создана задача.');
  GetForm;
  if (needForPreview) then
  begin
    Result := TTask.CreateForPreview(mTaskBody.Text, mConditionBody.Text);
    Exit;
  end;

  Result := TTask.Create(0, mTaskBody.Text, mConditionBody.Text, TTypeTask.Table, lessons[cmbLessonsForTask.ItemIndex].ID, tools.GetModeByName(cmbModes.Items[cmbModes.ItemIndex]), mMetaInfo.Text, EmptyStr, true);
end;



function TFTaskEditor.GetResourcesForTask(): TTaskResources;
begin
  if (audioCondition.Size = 0) and (tableVideoSolution.Size = 0) then
  begin
    Result := nil;
    Exit;
  end;
                                  //imgRowsXml, imgColsXml,
  Result := TTaskResources.Create(audioCondition.Bytes, tableVideoSolution.Bytes);
end;

procedure TFTaskEditor.InternalCreateTask(task: TTask; resources: TTaskResources);
begin
  DataModuleEditor.CreateTask(task, resources);
end;



procedure TFTaskEditor.LoadTaskForUpdate(taskId: integer);
var
  lesson: TLesson;
begin
  MenuSaveTask.Enabled := False;

  taskForUpdate := DataModuleEditor.GetTaskById(taskId);

  mTaskBody.Text := taskForUpdate.TaskBody;
  mConditionBody.Text := taskForUpdate.ConditionBody;
  mMetaInfo.Text := taskForUpdate.MetaInfo;
  cmbModes.ItemIndex := Ord(taskForUpdate.ModeType);

  SetForm;

  for var i := 0 to lessons.Count - 1 do
  begin
    if (lessons.TryGetValue(i, lesson)) and (lesson.ID = taskForUpdate.LessonID) then
    begin
      cmbLessonsForTask.ItemIndex := i;
      cmbLessonsForTaskChange(cmbLessonsForTask);
      Break;
    end;
  end;

  if (taskForUpdate.ResourceId <> EmptyStr) then
  begin
    var manager := TTaskResourcesManager.CreateBySavedResources(taskForUpdate.ResourceId);


    if (manager.HasAudioCondition) then
    begin
      audioCondition := TBytesStream.Create(manager.GetAudioCondition());
    end;

    if (manager.HasTableVideoSolution) then
    begin
      tableVideoSolution := TBytesStream.Create(manager.GetTableVideoSolution());
    end;

    FreeAndNil(manager);
  end;
end;

procedure TFTaskEditor.InternalUpdateTask(task: TTask);
begin
  if(mTaskBody.Text = EmptyStr)then raise Exception.Create('Тело задачи пустое.');
  if(mConditionBody.Text = EmptyStr)then raise Exception.Create('Тело условия пустое.');
//  if(mMetaInfo.Text = EmptyStr)then raise Exception.Create('Мета информация пуста.');
  if(cmbModes.ItemIndex = -1)then raise Exception.Create('Укажите режим тестирования, в котором будет находится задача.');
  if(cmbLessonsForTask.ItemIndex = -1)then raise Exception.Create('Выберите урок, для которого будет создана задача.');

  task.ModeType := tools.GetModeByName(cmbModes.Items[cmbModes.ItemIndex]);
  task.TaskBody := mTaskBody.Text;
  task.ConditionBody := mConditionBody.Text;
  task.MetaInfo := mMetaInfo.Text;
  task.LessonID := lessons[cmbLessonsForTask.ItemIndex].ID;

  var resources := GetResourcesForTask();
  if (resources <> nil) and (task.ResourceId = EmptyStr) then
  begin
    task.ResourceId := TGUID.NewGuid.ToString();
  end;

  DataModuleEditor.UpdateTask(task, resources);
end;



procedure TFTaskEditor.Bt1Click(Sender: TObject);
var
 s:String;
 Ed:TEdit;
 Ch:TCheckBox;
begin
 s:=(Sender As TButton).Name;
 s:=copy(s,Pos('t',s)+1,Length(s));
 Ed:=(FindComponent('Ed'+s) As TEdit);
 Ch:=(FindComponent('ChB'+s) As TCheckBox);
 Ch.Caption:=Ed.Text;
end;

procedure TFTaskEditor.BteClick(Sender: TObject);
begin
 Lbe.Caption:=Ede.Text;
end;

procedure TFTaskEditor.ChBV1Click(Sender: TObject);
var
 s:String;
 Ed:TEdit;
 Ch:TCheckBox;
 Bt:TButton;
begin
 s:=(Sender As TCheckBox).Name;
 s:=copy(s,Pos('V',s)+1,Length(s));
 Ed:=(FindComponent('Ed'+s) As TEdit);
 Ch:=(FindComponent('ChB'+s) As TCheckBox);
 Bt:=(FindComponent('Bt'+s) As TButton);
 Ch.Enabled:=(Sender As TCheckBox).Checked;
 Ed.Enabled:=(Sender As TCheckBox).Checked;
 Bt.Enabled:=(Sender As TCheckBox).Checked;
end;

procedure TFTaskEditor.ChBVeClick(Sender: TObject);
begin
 Er.Enabled:=ChBVe.Checked;
 Ede.Enabled:=ChBVe.Checked;
 Bte.Enabled:=ChBVe.Checked;
 Lbe.Enabled:=ChBVe.Checked;
end;

procedure TFTaskEditor.cmbLessonsForTaskChange(Sender: TObject);
begin
  var selectedLesson := (Sender as TComboBox).ItemIndex;

  for var course in DataModuleBase.GetSortedCoursesWithSortedLessons() do
  begin
    for var lesson in course.Lessons do
    begin
      if lesson.ID = lessons[selectedLesson].ID then
      begin
        lblCourse.Caption := Format('Тематика: %s', [course.Name]);
        Break;
      end;
    end;
  end;
end;


procedure TFTaskEditor.cmbLessonsForTaskDropDown(Sender: TObject);
begin
  InitListLessons();
  lblCourse.Caption := EmptyStr;
end;

procedure TFTaskEditor.ExecuteClose();
begin
  MenuExit.Click;
end;

procedure TFTaskEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(Self.audioCondition);
  FreeAndNil(Self.tableVideoSolution);
  FreeAndNil(Self.lessons);
  FreeAndNil(Self.taskForUpdate);
  mTaskBody.Free;
  mConditionBody.Free;
  mMetaInfo.Free;

  action := caFree;
  FTaskEditor := nil;
end;

procedure TFTaskEditor.FormCreate(Sender: TObject);
begin
  audioCondition := TBytesStream.Create();
  tableVideoSolution := TBytesStream.Create();
  tools := TTools.Create;
  mTaskBody:=TStringList.Create;
  mConditionBody:=TStringList.Create;
  mMetaInfo:=TStringList.Create;
  InitListLessons();
  InitListModes();

  // skip for next creating or updating task
//  DeleteFile(Config.PathToSavedAudio);
end;

procedure TFTaskEditor.MenuExitClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите выйти?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    if taskForUpdate <> nil then
    begin
      FTeacherMain.RefreshTaskForPreview(taskForUpdate.ID);
    end;

    FTeacherMain.Show();
    Self.Close;
  end;
end;

procedure TFTaskEditor.MenuSaveTaskClick(Sender: TObject);
begin
  try
    if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите создать задачу?', TTypeMessage.msgOKCancel) = mrOk)then
    begin
      var task := ConvertRawDataToTask(false);
      var resources := GetResourcesForTask();
      if (resources <> nil) then task.ResourceId := TGUID.NewGuid.ToString();

      InternalCreateTask(task, resources);
      FCustomMessageBox.SetMessage('Информация', 'Задача успешно создана', TTypeMessage.msgOK);
    end;
  except on E : Exception do
    raise Exception.Create('Ошибка при создании задачи. '+E.Message);
  end;
end;

procedure TFTaskEditor.MenuUpdateTaskClick(Sender: TObject);
begin
  try
    if(FCustomMessageBox.SetMessage('Внимание', 'Вы действительно хотите обновить задачу?', TTypeMessage.msgOKCancel) = mrOk)then
    begin
      GetForm;
      InternalUpdateTask(taskForUpdate);
      FCustomMessageBox.SetMessage('Информация', 'Задача успешно обновлена', TTypeMessage.msgOK);
    end;
  except on E : Exception do
    raise Exception.Create('Ошибка при обновлении задачи. '+E.Message);
  end;
end;



procedure TFTaskEditor.MenuCheckTaskClick(Sender: TObject);
var
  manager: TTaskResourcesManager;
begin
  // always getting the resources from editor, not from db; that required to validate for maybe changes
  var resources := GetResourcesForTask();
  if (resources <> nil) then
    manager := TTaskResourcesManager.CreateByInMemoryResources(resources)
  else
    manager := nil;

 var preview := TFWebPreviewTask.Create(nil, ConvertRawDataToTask(false), manager);
 preview.CheckTask();
end;

procedure TFTaskEditor.LoadAudioConditionClick(Sender: TObject);
begin
  if (audioCondition.Size = 0) or
     ((audioCondition.Size > 0) and (FCustomMessageBox.SetMessage('Внимание!', 'Аудио условие уже загружено. Хотите обновить?', TTypeMessage.msgOKCancel) = mrOk)) then
  begin
    if (OpenDialogForAudio.Execute) then audioCondition.LoadFromFile(OpenDialogForAudio.FileName);
  end;
end;

procedure TFTaskEditor.LoadVideoSolutionForTableClick(Sender: TObject);
begin
  if (tableVideoSolution.Size = 0) or
     ((tableVideoSolution.Size > 0) and (FCustomMessageBox.SetMessage('Внимание!', 'Видео решение для таблиц уже загружено. Хотите обновить?', TTypeMessage.msgOKCancel) = mrOk)) then
  begin
    if (OpenDialogForVideo.Execute) then tableVideoSolution.LoadFromFile(OpenDialogForVideo.FileName);
  end;
end;


end.
