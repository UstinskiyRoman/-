unit UModeTestMenu;
interface
uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Generics.Collections, Vcl.ImgList, Vcl.Buttons,
  System.Math, UDataModuleClient, UModes, UMainMenu, UViewStatistic, UStatisticInfo,
  //UDifficulty,
  UTools, UFormBase, Generics.Defaults, UCourse, ULessonInfo,
  UTaskInfo, System.ImageList, UCustomMessageBox, UTypeUser, UDataModuleBase,
  UDataModuleSQLiteBase, UTaskResourceType, URavenTest;
type
  TFModeTestMenu = class(TFormBase)
    btnExit: TButton;
    btnDiagnostic: TButton;
    btnClassWork: TButton;
     btnRaven: TButton;
    btnCloseaRaven: TButton;
    btnBack: TButton;
    btnSelfWork: TButton;
    grpboxCourses: TGroupBox;
    TreeViewCourses: TTreeView;
    ImageList1: TImageList;
    LabelAllStat: TLabel;
    grpboxClassWork: TGroupBox;
    btnVeryEasy: TBitBtn;
    btnCloseClassWork: TButton;
    btnCloseTree: TButton;
    grpboxDiagnostic: TGroupBox;
    btnCloseDiagnostic: TButton;
    treeViewLevelDiff: TTreeView;
    lblDifficulty: TLabel;
    btnRunDiagnostic: TButton;
    ImageListDiff: TImageList;
    btnRunSelfControl: TButton;
    btnShowDiagnosticStat: TBitBtn;
    btnShowClassWorkStat: TBitBtn;
    btnShowSelfWorkStat: TBitBtn;
    StatusBar1: TStatusBar;
    chbGroupWork: TCheckBox;
    cmbCurs: TComboBox;
    Label1: TLabel;
    cmbLesson: TComboBox;
    grpboxRaven: TGroupBox;
    ComboBox1: TComboBox;
    Label2: TLabel;
    btnRavenStart: TButton;
    Button1: TButton;
    btnStat: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure btnClassWorkClick(Sender: TObject);
    procedure btnDiagnosticClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSelfWorkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadTreeCourses();
    procedure TreeViewCoursesGetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeViewCoursesChange(Sender: TObject; Node: TTreeNode);
    procedure btnCloseClassWorkClick(Sender: TObject);
    procedure btnCloseTreeClick(Sender: TObject);
    procedure btnCloseDiagnosticClick(Sender: TObject);
    procedure btnRavenClick(Sender: TObject);
    procedure btnCloseaRavenClick(Sender: TObject);
    procedure treeViewLevelDiffGetSelectedIndex(Sender: TObject;
      Node: TTreeNode);
    procedure btnVeryEasyClick(Sender: TObject);
    procedure btnRunSelfControlClick(Sender: TObject);
    procedure btnRunDiagnosticClick(Sender: TObject);
    procedure treeViewLevelDiffChange(Sender: TObject; Node: TTreeNode);
    procedure btnShowDiagnosticStatClick(Sender: TObject);
    procedure btnShowClassWorkStatClick(Sender: TObject);
    procedure btnShowSelfWorkStatClick(Sender: TObject);
    procedure cmbCursChange(Sender: TObject);
    procedure btnRavenStartClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnStatClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    selectedCourse:String;
    selectedLesson:String;
    lessonsWithIds: TDictionary<integer, integer>;
    frmViewStat: TFViewStatistic;
    courses: TDictionary<integer, TCourse>;
    StrLessons: TDictionary<integer, TLesson>;
    procedure InitListCourses(diff:Integer);
    procedure InitListLesson();
    procedure EnableModeTest();
    procedure LoadProgressByDiagnostic();
    procedure LoadTest(courses:TObjectList<TCourse>; mode: TMode);
    procedure LoadClassWork(course:TCourse;diff:Integer);
    procedure LoadClassWorkLesson(course:TCourse;diff:Integer;lessonid:Integer);
    procedure InitFrameViewStatistic();
    procedure ShowStat(mode:TMode);
    procedure CloseFrameViewStatistic(Sender: TObject);
  public
    { Public declarations }
  end;
CONST
  INDEX_IMG_OK_DIAG = 2;
  INDEX_IMG_FAIL_DIAG = 1;
  INDEX_IMG_NOTYET_DIAG = 0;
var
  FModeTestMenu: TFModeTestMenu;
  HardLvl : integer;
implementation
uses UTester, UUserProfile, URavenClass, UShowStat;
{$R *.dfm}

procedure TFModeTestMenu.InitListCourses(diff:Integer);
var
  course: TCourse;
begin
  cmbCurs.Clear;
  courses := TDictionary<integer, TCourse>.Create;
  for course in DataModuleBase.GetCourses(diff) do
  begin
    cmbCurs.Items.Add(course.Name);
    courses.Add(cmbCurs.Items.Count - 1, course);
  end;
end;
procedure TFModeTestMenu.InitListLesson();
var
  //StrLesons: TLesson;
  cid: Integer;
begin
  cmbLesson.Clear;
  StrLessons := TDictionary<integer, TLesson>.Create;
  cid := courses[cmbCurs.ItemIndex].ID;
  var lessons := DataModuleBase.GetLessons(FMainMenu.UserInfo.ClassGroup.NumberClass, cid);
  for var lesson in lessons do
  begin
    cmbLesson.Items.Add(lesson.Name);
    StrLessons.Add(cmbLesson.Items.Count - 1, lesson);
    //lesson.Tasks.AddRange(GetTasks(modeTest, lesson.ID, isRandTasks));
  end;
  //for course in DataModuleBase.GetLesson(diff) do
  //begin
  //  cmbCurs.Items.Add(course.Name);
  //  courses.Add(cmbCurs.Items.Count - 1, course);
  //end;
end;
procedure TFModeTestMenu.ExecuteClose();
begin
  btnExit.Click;
end;
procedure TFModeTestMenu.CloseFrameViewStatistic(Sender: TObject);
begin
  frmViewStat.Visible:=false;
end;
procedure TFModeTestMenu.cmbCursChange(Sender: TObject);
begin
 btnVeryeasy.Enabled:=cmbCurs.Text<>'';
 cmbLesson.Enabled:=true;
 InitListLesson();
end;
procedure TFModeTestMenu.ShowStat(mode:TMode);
begin
  frmViewStat.ShowStatisticByMode(mode);
  frmViewStat.Visible:=true;
end;
procedure TFModeTestMenu.InitFrameViewStatistic();
begin
  frmViewStat := TFViewStatistic.Create(Self);
  frmViewStat.Parent:=Self;
  frmViewStat.Align:=alClient;
  frmViewStat.Visible:=false;
  frmViewStat.btnClose.OnClick:=CloseFrameViewStatistic;
end;
procedure TFModeTestMenu.LoadTest(courses:TObjectList<TCourse>; mode:TMode);
begin
  if(courses.Count = 0)then
  begin
    FCustomMessageBox.SetMessage('������', Format('��� �������� ��� "%s"', [AppTools.GetNameModeTest(mode)]), TTypeMessage.msgOK);
    Exit;
  end;
  for var i := 0 to Pred(courses.Count) do
  begin
    if(courses[i].CountTasks() = 0)then
    begin
      FCustomMessageBox.SetMessage('������', Format('��� ����� ��� �������� "%s" "%s"', [courses[i].Name, AppTools.GetNameModeTest(mode)]), TTypeMessage.msgOK);
      Exit;
    end;
  end;
  var idxLessonsForRemove:=TList<integer>.Create;
  for var i := 0 to Pred(courses.Count) do
  begin
    for var j := 0 to Pred(courses[i].Lessons.Count) do
    begin
      if(courses[i].Lessons[j].Tasks.Count = 0)then
        idxLessonsForRemove.Add(j);
    end;
    for var j := Pred(idxLessonsForRemove.Count) downto 0 do
    begin
      courses[i].Lessons.Delete(idxLessonsForRemove[j]);
    end;
  end;
  FreeAndNil(idxLessonsForRemove);
  FTester := TFTester.Create(nil);
  FTester.InitTester(courses, mode);
  Self.Close;
end;
procedure TFModeTestMenu.LoadClassWork(course:TCourse;diff:Integer);
begin
  var courses := TObjectList<TCourse>.Create;
  courses.Add(DataModuleClient.GetFullCourseByDiffculty(course,diff, ClassWork, not chbGroupWork.Checked));
//  DataModuleClient.GetFullCourseByDiffculty(course,diff, ClassWork, not chbGroupWork.Checked)
  LoadTest(courses, ClassWork);
end;
procedure TFModeTestMenu.LoadClassWorkLesson(course:TCourse;diff:Integer;lessonid:Integer);
begin
  var courses := TObjectList<TCourse>.Create;
  courses.Add(DataModuleClient.GetFullCourseByDiffcultyLesson(course,diff, ClassWork, not chbGroupWork.Checked, lessonid));
  LoadTest(courses, ClassWork);
end;
function IsContains(statCourses:TObjectList<TStatDiagnostic>; course:TCourse):Boolean;
var
  _statCourse:TStatDiagnostic;
begin
  for _statCourse in statCourses do
  begin
    if(_statCourse.CourseID = course.ID)then
    begin
      Result:=true;
      Exit;
    end;
  end;
  Result:=false;
end;
procedure TFModeTestMenu.LoadProgressByDiagnostic();
var
  node: TTreeNode;
  statisticsDiagnostic:TObjectList<TStatDiagnostic>;
  haveErrorInCourse: Boolean;
  courses: TObjectList<TCourse>;
begin
  treeViewLevelDiff.Items.Clear;
  haveErrorInCourse:=false;
  try
    courses := DataModuleBase.GetCourses(FMainMenu.UserInfo.ClassGroup.NumberClass);
    statisticsDiagnostic := DataModuleClient.GetStatDiagnosticByUserId(FMainMenu.UserInfo.ID);
    statisticsDiagnostic.Sort(TComparer<TStatDiagnostic>.Construct(
      function (const L, R: TStatDiagnostic): integer
      begin
        Result:=TComparer<Integer>.Default.Compare(Ord(R.Difficulty), Ord(L.Difficulty));
      end));
    for var course in courses do
    begin                                      //AppTools.GetNameDifficulty(course.Difficulty)
      node := treeViewLevelDiff.Items.Add(nil, course.Name);
      node.ImageIndex:=INDEX_IMG_NOTYET_DIAG;
      if(statisticsDiagnostic.Count = 0)then Continue;
      if(Ord(statisticsDiagnostic.First.Difficulty) >= Ord(course.Difficulty))then
      begin
        node.ImageIndex:=INDEX_IMG_OK_DIAG;
      end else if(not haveErrorInCourse)then
      begin
        haveErrorInCourse:=true;
        node.ImageIndex:=INDEX_IMG_FAIL_DIAG;
      end;
    end;
  finally
    FreeAndNil(courses);
    FreeAndNil(statisticsDiagnostic);
  end;
end;
procedure TFModeTestMenu.LoadTreeCourses();
var
  node: TTreeNode;
  child: TTreeNode;
  summBalls: Integer;
  summBallByCourse: Integer;
  avgBallByCourse: Integer;
  countCoursesWithBall: Integer;
  countLessonsInCourseWithBall:Integer;
  i: Integer;
  statsSelfWorkTree:TObjectList<TStatSelfWorkTree>;
  durtyLessons:TList<Integer>;
  durtyCourses:TList<String>;
begin
  countCoursesWithBall := 0;
  summBalls := 0;
  durtyLessons := TList<Integer>.Create;
  durtyCourses := TList<String>.Create;
  try
    statsSelfWorkTree := DataModuleClient.GetStatSelfWorkTreeByUserId(FMainMenu.UserInfo.ID,FMainMenu.UserInfo.ClassGroup.NumberClass);
    for i := 0 to Pred(statsSelfWorkTree.Count) do
    begin
      if (not durtyCourses.Contains(statsSelfWorkTree[i].CourseName))then
      begin
        countLessonsInCourseWithBall:=0;
        if(statsSelfWorkTree[i].Ball > 0)then
        begin
          inc(countCoursesWithBall);
          Inc(countLessonsInCourseWithBall);
        end;
        durtyCourses.Add(statsSelfWorkTree[i].CourseName);
        node := TreeViewCourses.Items.Add(nil, statsSelfWorkTree[i].CourseName);
        if(statsSelfWorkTree[i].Ball = 0)then
          node.ImageIndex:=0
        else
          node.ImageIndex:=statsSelfWorkTree[i].Ball - 1;
        summBallByCourse := statsSelfWorkTree[i].Ball;
      end else
      begin
        if(statsSelfWorkTree[i].Ball > 0)then
        begin
          if(summBallByCourse = 0)then inc(countCoursesWithBall);//only one course with ball
          Inc(countLessonsInCourseWithBall);
        end;
        summBallByCourse := summBallByCourse + statsSelfWorkTree[i].Ball;
        avgBallByCourse := Round(summBallByCourse / countLessonsInCourseWithBall);
        node.ImageIndex := IfThen(avgBallByCourse = 0, 0, avgBallByCourse - 1);
        if ((i = (statsSelfWorkTree.Count - 1)) or (statsSelfWorkTree[i].CourseName <> statsSelfWorkTree[i + 1].CourseName)) then summBalls := avgBallByCourse + summBalls;
      end;
      if (not durtyLessons.Contains(statsSelfWorkTree[i].Lesson.ID))then
      begin
        durtyLessons.Add(statsSelfWorkTree[i].Lesson.ID);
        child := TreeViewCourses.Items.AddChild(node, statsSelfWorkTree[i].Lesson.Name);
        lessonsWithIds.Add(child.AbsoluteIndex, statsSelfWorkTree[i].Lesson.ID);
        if(statsSelfWorkTree[i].Ball = 0)then
          child.ImageIndex:=0
        else
          child.ImageIndex:=statsSelfWorkTree[i].Ball - 1;
      end;
    end;
    if(countCoursesWithBall = 0)then
      LabelAllStat.Caption:=LabelAllStat.Caption+'0'
    else
      LabelAllStat.Caption:=LabelAllStat.Caption + IntToStr(Round(summBalls / countCoursesWithBall));
  finally
    begin
      FreeAndNil(durtyLessons);
      FreeAndNil(durtyCourses);
      FreeAndNil(statsSelfWorkTree);
    end;
  end;
  TreeViewCourses.FullExpand();
end;
procedure TFModeTestMenu.FormCreate(Sender: TObject);
begin
  lessonsWithIds := TDictionary<integer, integer>.Create;
  InitListCourses(FMainMenu.UserInfo.ClassGroup.NumberClass);
  LoadTreeCourses();
  LoadProgressByDiagnostic();
  InitFrameViewStatistic();
  StatusBar1.Panels[0].Text:=FMainMenu.UserInfo.ToString();
end;
procedure TFModeTestMenu.EnableModeTest();
begin
  btnRunSelfControl.Enabled:=true;
end;
procedure TFModeTestMenu.btnCloseaRavenClick(Sender: TObject);
begin
  btnRaven.Visible:= true;
  grpboxRaven.Visible:=false;
end;

procedure TFModeTestMenu.btnCloseClassWorkClick(Sender: TObject);
begin
  btnRaven.Visible:= true;
  grpboxClassWork.Visible:=false;
end;
procedure TFModeTestMenu.btnCloseDiagnosticClick(Sender: TObject);
begin
  btnRaven.Visible:= true;
  grpboxDiagnostic.Visible:=false;
end;
procedure TFModeTestMenu.btnCloseTreeClick(Sender: TObject);
begin
  btnRaven.Visible:= true;
  grpboxCourses.Visible:=false;
end;
procedure TFModeTestMenu.btnRavenClick(Sender: TObject);
begin
  btnRaven.Visible:= false;
  grpboxRaven.Visible:=true;

end;

procedure TFModeTestMenu.ComboBox1Change(Sender: TObject);
begin
  HardLvl := ComboBox1.ItemIndex;
end;

procedure TFModeTestMenu.btnRavenStartClick(Sender: TObject);
var Raven : TFRavenTest;
begin
  Raven := TFRavenTest.Create(Self);
 try
    Raven.ShowModal;
  finally
    Raven.Free;
  end;
end;

procedure TFModeTestMenu.btnRunDiagnosticClick(Sender: TObject);
var
  courses: TObjectList<TCourse>;
begin
//  if (FMainMenu.UserInfo.TypeUser = TTypeUser.Preschooler) then
//    courses := DataModuleClient.GetFullCoursesForDiagnosticMode(true, TaskResourceType.ImagesForTaskBody)
//  else
    courses := DataModuleClient.GetFullCoursesForDiagnosticMode(FMainMenu.UserInfo.ClassGroup.NumberClass, true, TaskResourceType.Any);
  LoadTest(Courses, Diagnostic);
end;
procedure TFModeTestMenu.btnRunSelfControlClick(Sender: TObject);
begin
  var courses := DataModuleBase.GetSortedCoursesWithSortedLessons();
  var tmpCourses := TObjectList<TCourse>.Create;
  if(selectedCourse <> EmptyStr)then
  begin
    var courseId := -1;
    for var i := 0 to Pred(Courses.Count) do
    begin
      if(Courses[i].Name = selectedCourse)then
      begin
        courseId := Courses[i].ID;
        Break;
      end;
    end;
    tmpCourses.Add(DataModuleClient.GetFullCourse(courseId, SelfWork, true));
  end;
  if(selectedLesson <> EmptyStr)then
  begin
    var lessonId := -1;
    for var i := 0 to Pred(Courses.Count) do
    begin
      for var j := 0 to Pred(Courses[i].Lessons.Count) do
      begin
        if(Courses[i].Lessons[j].ID = lessonsWithIds[TreeViewCourses.Selected.AbsoluteIndex])then
        begin
          lessonId := Courses[i].Lessons[j].ID;
          Break;
        end;
      end;
      if (lessonId <> -1) then Break;
    end;
    tmpCourses.Add(DataModuleClient.GetFullCourseByLessonId(lessonId, SelfWork, true));
  end;
  btnRaven.Visible:=false;
  FreeAndNil(courses);
  LoadTest(tmpCourses, SelfWork);
end;
procedure TFModeTestMenu.btnShowClassWorkStatClick(Sender: TObject);
begin
  ShowStat(ClassWork);
end;
procedure TFModeTestMenu.btnShowDiagnosticStatClick(Sender: TObject);
begin
  ShowStat(Diagnostic);
end;
procedure TFModeTestMenu.btnShowSelfWorkStatClick(Sender: TObject);
begin
  btnRaven.Visible:=False;
  ShowStat(SelfWork);
end;
procedure TFModeTestMenu.btnStatClick(Sender: TObject);
var Stat : TShowStats;
begin
  Stat := TShowStats.Create(Self);
 try
    Stat.ShowModal;
  finally
    Stat.Free;
  end;
end;

procedure TFModeTestMenu.btnVeryEasyClick(Sender: TObject);
begin
  if cmbLesson.Text = '' then
    LoadClassWork(courses[cmbCurs.ItemIndex],FMainMenu.UserInfo.ClassGroup.NumberClass)
  else
    LoadClassWorkLesson(courses[cmbCurs.ItemIndex],FMainMenu.UserInfo.ClassGroup.NumberClass, StrLessons[cmbLesson.ItemIndex].ID);
end;
procedure TFModeTestMenu.Button1Click(Sender: TObject);
var Raven : TRavenClass;
begin
  Raven := TRavenClass.Create(Self);
 try
    HardLvl1:=2;
    Raven.ShowModal;
  finally
    Raven.Free;
  end;

end;

procedure TFModeTestMenu.btnExitClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('��������', '�� ������������� ������ �����?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    FModeTestMenu.Close;
    FMainMenu.Close;
  end;
end;
procedure TFModeTestMenu.btnClassWorkClick(Sender: TObject);
begin
  cmbCurs.ItemIndex:=-1;
  btnVeryEasy.Enabled:=False;
  btnRaven.Visible:=False;
  grpboxClassWork.Visible:=true;
end;
procedure TFModeTestMenu.btnDiagnosticClick(Sender: TObject);
begin
  btnRaven.Visible:=False;
  grpboxDiagnostic.Visible:=true;
end;
procedure TFModeTestMenu.TreeViewCoursesChange(Sender: TObject; Node: TTreeNode);
begin
  if(TreeViewCourses.Selected.Text <> EmptyStr)then
  begin
    if(Node.Level = 0)then
    begin
      selectedLesson:=EmptyStr;
      selectedCourse:=TreeViewCourses.Selected.Text;
    end;
    if(Node.Level = 1)then
    begin
      selectedCourse:=EmptyStr;
      selectedLesson:=TreeViewCourses.Selected.Text;
    end;
    EnableModeTest();
  end;
end;
procedure TFModeTestMenu.TreeViewCoursesGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if(Node.Selected)then
    Node.SelectedIndex:=TreeViewCourses.Selected.ImageIndex;
end;
procedure TFModeTestMenu.treeViewLevelDiffChange(Sender: TObject; Node: TTreeNode);
begin
  treeViewLevelDiff.ClearSelection(false);
end;
procedure TFModeTestMenu.treeViewLevelDiffGetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  if(Node.Selected)then Node.SelectedIndex := treeViewLevelDiff.Selected.ImageIndex;
end;
procedure TFModeTestMenu.btnBackClick(Sender: TObject);
begin
  FUserProfile:=TFUserProfile.create(nil);
  FUserProfile.LoadUserInfo(FMainMenu.UserInfo);
  FUserProfile.Show;
  Self.Close;
end;
procedure TFModeTestMenu.btnSelfWorkClick(Sender: TObject);
begin
  grpboxCourses.Visible:=true;
  btnRunSelfControl.Enabled:=false;
  btnRaven.Visible :=false;
end;
procedure TFModeTestMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(lessonsWithIds);
  action:=caFree;
  FModeTestMenu:=nil;
end;
end.
