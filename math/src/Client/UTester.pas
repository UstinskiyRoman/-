unit UTester;
interface
uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.OleCtrls, Vcl.ComCtrls, Vcl.CheckLst,
  Vcl.ExtCtrls, Vcl.Buttons,WinApi.ShellApi, Vcl.Menus, // MSHTML, jsWebBrowser,
  UTimerForTrainer, UCourse, Generics.Collections, UModes, UStatistic,
  UFormBase, UTools, UConfigClient, //UExtendReasoning,  UTaskMetaInfo,
  UTaskInfo, UTypeTasks, WinApi.MMSystem, System.ImageList,
  Vcl.ImgList, UCustomMessageBox, SHDocVw, UMainMenu, //UReasoning,
  System.IOUtils,
  UTaskResourcesManager, UDataModuleBase, Data.DB, Data.Win.ADODB;
type
  TTimerMode = (Ena, Dis);
type
  TFTester = class(TFormBase)
    TimerAnimationSolution: TTimer;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    PanelWB: TPanel;
    panelBackground: TPanel;
    btnExit: TBitBtn;
    btnPauseTest: TBitBtn;
    btnSolutionTask: TBitBtn;
    btnBack: TBitBtn;
    btnNext: TBitBtn;
    btnReasoning: TBitBtn;
    btnExtendReasoning: TBitBtn;
    StatusBarUserInfo: TStatusBar;
    btnAudioCondition: TBitBtn;
    btnVideoSolutionTask: TBitBtn;
    TimerAnimationRunPause: TTimer;
    btnHelp: TBitBtn;
    ChB1: TCheckBox;
    ChB2: TCheckBox;
    ChB3: TCheckBox;
    ChB4: TCheckBox;
    ChB5: TCheckBox;
    LbE: TLabel;
    Er: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    M1: TMemo;
    questionImage: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    ADOQuery1: TADOQuery;
    ADOConnection1: TADOConnection;
    procedure TimerAnimationSolutionTimer(Sender: TObject);
    procedure btnSolutionTaskClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
//    procedure btnReasoningClick(Sender: TObject);
    procedure btnPauseTestClick(Sender: TObject);
//    procedure btnExtendReasoningClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
//    procedure WebBrowser1DocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
    procedure FormDestroy(Sender: TObject);
    procedure btnAudioConditionClick(Sender: TObject);
    procedure btnVideoSolutionTaskClick(Sender: TObject);
    procedure TimerAnimationRunPauseTimer(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    CONST
      SUCCESS_LOAD_TASK = 1;
      UNSUCCESS_LOAD_TASK = -1;
      HEIGHT_EXTEND_REASONING = 350;
      EMPTY_ANSWER = '0';
      EXCEPTION_ANSWER = '-';
    var
      StatTest: TObjectList<TStatCourse>;
      TimeTrainer: TTimerShare;
      IsFinishedTest: Boolean;
      TimerTest:TTimer;
      IsForwardDirection: Boolean;
      //frmExtReasoning:TFExtendReasoning;
//      ArrDisplayConditions: array of integer;
      CurrentHeightPanelBackgr: integer;
      theory: String;
    procedure OnTimerTest(Sender: TObject);
    procedure ReadCurrentAnswers();
    procedure TimeTestController(mode:TTimerMode);
    function IsTrueTask():boolean;
//    procedure LoadItemsCondition();
    function LoadTask(): Integer;
    procedure MoveIndex(isForward: Boolean);
    procedure ShowCurrentStat();
    procedure ClickOnItemCondition(var msg:TMsg; var handled:boolean);
    procedure ShowAnswerForItemCondition(selectItemCondition: String);
//    procedure ClearAndLoadArrDisplayCondition();
    procedure CustomPlaySound(isSuccessAnswer: boolean);
    procedure OnCloseExtendReasoning(Sender: TObject);
    function GetCountPassedTasksInDiagnostic(): Integer;
    procedure ShowInvalidAnswers();
    procedure ShowPreviewAnswer();
//    function HasExtendReasoning():boolean;
    procedure FinishedTest();
    procedure LoadDataForTest();
    procedure StopPlayAudio();
  public
    CoursesData: TObjectList<TCourse>;
    Manager: TTaskResourcesManager;
    ModeTest: TMode;
    CountConditional: Integer;
    ArrConditionals: TArray<String>;

    procedure InitTester(courses: TObjectList<TCourse>; mode: TMode);
    procedure PreLoadTask();
  end;
var
  FTester: TFTester;
  IndexTask: Integer;
  IndexLesson: Integer;
  IndexCourse: Integer;
implementation
uses UModeTestMenu, USolutionTask, UResults, ULTheory;
{$R *.dfm}
//procedure CustomCallFunctionJS(NameFuction: string; Param: string; arrAnswers: string; WB: TWebBrowser);
//var
//  Doc: IHTMLDocument2;      // current HTML document
//  HTMLWindow: IHTMLWindow2; // parent window of current HTML document
//  JSFn: string;             // stores JavaScipt function call
//begin
//  // Get reference to current document
//  Doc := WB.Document as IHTMLDocument2;
//  if not Assigned(Doc) then
//    Exit;
//  // Get parent window of current document
//  HTMLWindow := Doc.parentWindow;
//  if not Assigned(HTMLWindow) then
//    Exit;
//  // Run JavaScript
//  try
//    if(arrAnswers = '')then
//      JSFn := Format(NameFuction + Param, [])  // build function call
//    else
//      JSFn := Format(NameFuction + Param, [arrAnswers]);  // build function call
//    HTMLWindow.execScript(JSFn, 'JavaScript'); // execute function
//  except
//    // handle exception in case JavaScript fails to run
//  end;
//end;
//
//procedure LoadHtmlToWEB(WB: TWebBrowser; pathToHtmlFile: string);
//begin
//  if(pathToHtmlFile = EmptyStr)then raise Exception.Create('���� �� HTML ����� ����.');
//  if(WB = nil)then raise Exception.Create('WEB ���� �� ����������.');
//
//  WB.Navigate('file://' + pathToHtmlFile);
//end;
procedure TFTester.StopPlayAudio();
begin
	if btnAudioCondition.ImageIndex = 4 then
  begin
		sndPlaySound(nil, SND_ASYNC);
    btnAudioCondition.ImageIndex := 5;
    btnAudioCondition.Glyph.Assign(nil);
    ImageList1.GetBitmap(5, btnAudioCondition.Glyph);
    btnAudioCondition.Hint := '���������� �������';
  end;
end;
//function TFTester.HasExtendReasoning():boolean;
//begin
//  if(ModeTest = TMode.ClassWork) or (ModeTest = TMode.SelfWork)then
//  begin
//    if(CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.ExtendingExplanations = EmptyStr)then
//      Result:=False
//    else begin
//      frmExtReasoning.Memo1.Lines.Text:=CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.ExtendingExplanations;
//      Result:=true;
//    end;
//  end else Result:=False;
//end;
procedure TFTester.InitTester(courses: TObjectList<TCourse>; mode: TMode);
begin
  Self.CoursesData := courses;
  Self.ModeTest := mode;
  if (CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ResourceId <> EmptyStr) then
  begin
    Self.Manager := TTaskResourcesManager.CreateBySavedResources(CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ResourceId);
  end else
  begin
    Self.Manager := nil;
  end;
  LoadDataForTest();
//  btnExtendReasoning.Enabled := HasExtendReasoning();
  btnNext.Enabled := true;
  btnReasoning.Enabled := True;
  btnPauseTest.Enabled := True;
  btnPauseTest.Visible := true;
  PreLoadTask();
//  LoadItemsCondition();
  btnAudioCondition.Enabled := (Self.Manager <> nil) and (Self.Manager.HasAudioCondition);
  ShowCurrentStat();
  if(ModeTest = ClassWork) or (ModeTest = SelfWork)then
  begin
    btnBack.Enabled:=true;
//    Application.OnMessage := ClickOnItemCondition;
  end;
  Self.Show();
end;
procedure TFTester.ShowPreviewAnswer();
var
  checkboxValue:variant;
  i: integer;
begin
  for i := 0 to StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Count-1 do
  begin
//    checkboxValue:=webbrowser1.OleObject.document.getelementbyid('pos'+StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i]+'t');
    checkboxValue.value:=StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i];
    if(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i] <> EMPTY_ANSWER)and(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i] <> EXCEPTION_ANSWER)then
    begin
      checkboxValue.click;
    end;
    if(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i] = EXCEPTION_ANSWER)then
    begin
      checkboxValue.click;
      checkboxValue.click;
    end;
  end;
end;
function TFTester.GetCountPassedTasksInDiagnostic(): Integer;
var
  lesson:TStatLesson;
  task:TStatTask;
  countPassedTasks:Integer;
begin
  countPassedTasks:=0;
  for lesson in StatTest[0].Lessons do
  begin
    for task in lesson.Tasks do
    begin
      if(task.IsTrue)then Inc(countPassedTasks);
    end;
  end;
  Result:=countPassedTasks;
end;
procedure TFTester.OnCloseExtendReasoning(Sender: TObject);
begin
  panelBackground.Height:=CurrentHeightPanelBackgr;
//  frmExtReasoning.Visible:=false;
end;
procedure TFTester.CustomPlaySound(isSuccessAnswer: boolean);
var
  resNameSound: String;
begin
  if(isSuccessAnswer)then resNameSound := Config.ResNameSoundWin else resNameSound := Config.ResNameSoundInvalid;
  try
    PlaySound(PWCHAR(resNameSound), 0, SND_SYNC); //SND_RESOURCE or
  except
    begin
      FCustomMessageBox.SetMessage('������!', '������ ��� ��������������� �����.', TTypeMessage.msgOK);
    end;
  end;
end;
//procedure TFTester.ClearAndLoadArrDisplayCondition();
//begin
//  SetLength(ArrDisplayConditions, 0);
//  SetLength(ArrDisplayConditions, FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Conditions.Count);
//end;
procedure TFTester.ShowAnswerForItemCondition(selectItemCondition: String);
var
  i:Integer;
  vvod_otv:Variant;
  arrVariants: TList<integer>;
  variantAnswers: string;
//  itemExplanation: TItemExplanation;
  itemTrueAnswers: Integer;
  itemVariantAnswers: Integer;
begin
  arrVariants := TList<integer>.Create;
  i := 0;
//  for itemExplanation in FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Explanations do
//  begin
//    if( POS(itemExplanation.ConditionText, selectItemCondition) > 0)then
//    begin
//        for itemTrueAnswers in itemExplanation.TrueAnswers do
//        begin
////          vvod_otv := Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemTrueAnswers)+'t');
//
//          if(ArrDisplayConditions[i] <> -1)then
//          begin
//            vvod_otv.Click;
//          end;
//
//          arrVariants.Add(itemTrueAnswers);
//        end;
//
//        for itemVariantAnswers in itemExplanation.Variants do
//        begin
////          vvod_otv := Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemVariantAnswers)+'t');
//
//          if(ArrDisplayConditions[i] <> -1)then
//          begin
//            //double click for enable 3 state checkbox
//            vvod_otv.Click;
//            vvod_otv.Click;
//          end;
//        end;
//
//        ArrDisplayConditions[i] := -1;
//    end else
//    begin
////      CustomCallFunctionJS('endShowCondition', '()', '', Webbrowser1);
//    end;
//    Inc(i);
//  end;
//  if(arrVariants.Count > 0)then
//  begin
//    variantAnswers := '[';
//    for i := 0 to arrVariants.Count-2 do variantAnswers:=variantAnswers + IntToStr(arrVariants[i]) + ', ';
//
//    variantAnswers := variantAnswers + IntToStr(arrVariants[arrVariants.Count-1]) + ']';
//    CustomCallFunctionJS('startShowCondition', '(%s)', variantAnswers, Webbrowser1);
//  end;
  arrVariants.Free;
end;
procedure TFTester.ClickOnItemCondition(var msg:TMsg; var handled:boolean);
var
  X, Y: Integer;
  document, E: OleVariant;
begin
   Handled := False;
//   if (WebBrowser1 = nil) or (Msg.message <> WM_LBUTTONDOWN) then Exit;
//   Handled := IsDialogMessage(WebBrowser1.Handle, Msg);
//
//   if (Handled) then
//   begin
//     case (Msg.message) of
//       WM_LBUTTONDOWN:
//         begin
//          X := LOWORD(Msg.lParam);
//          Y := HIWORD(Msg.lParam);
//          document := WebBrowser1.document;
//          E := document.elementFromPoint(X, Y);
//
//          if(E.tagName = 'TD') and (E.getAttribute('abbr') = 'condition')then
//          begin
//            ShowAnswerForItemCondition(E.innerHTML);
//          end else
//          begin
//            CustomCallFunctionJS('endShowCondition', '()', '', Webbrowser1);
//          end;
//         end;
//
//     end;
//   end;
 end;

procedure TFTester.PreLoadTask();
var
 stbody:TStrings;
 i:Integer;
 s:String;
 Answer: String;
 ImageName:String;
 ChB:TCheckBox;
 HardLevel: String;
 t: TImage;
 dir: string;
begin



 stbody:=TStringList.Create;
 stbody.Text:=CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].TaskBody;
 for i := 1 to 5 do
  (FindComponent('ChB'+IntToStr(i)) As TCheckBox).Visible:=False;
 Er.Visible:=False;
 Lbe.Visible:=False;
 i:=1;
 while stbody[i]<>'end' do
  begin
   s:=stbody[i];
   if s[1]='C' then
    begin
     ChB:=(FindComponent(Copy(s,1,Pos(';',s)-1)) As TCheckBox);
     ChB.Visible:=True;
     ChB.Checked:=False;
     Delete(s,1,Pos(';',s));
     ChB.Caption:=Copy(s,1,Pos(';',s)-1);
    end
   else
    begin
     Lbe.Visible:=True;
     Er.Visible:=True;
     Er.Clear;
     Delete(s,1,Pos(';',s));
     Lbe.Caption:=Copy(s,1,Pos(';',s)-1);
    end;
   Inc(i);
  end;
 Inc(i);
 M1.Lines.Clear;
 while i<=stbody.Count-1 do
  begin
   M1.Lines.Add(stbody[i]);
   Inc(i);
  end;
 TimeTestController(TTimerMode.Ena);
 StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsView:=True;

//  var htmlTask := CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].SaveHtmlTaskToFile(True, Config.PathToTempFolder, Config.ResNameTemplateHtmlTask);
//  if (Self.Manager <> nil) and (Self.Manager.HasImagesForTaskBody) then
//  begin
//    Self.Manager.SaveImagesForHtmlView(Config.PathToTempFolder);
//  end;
//
//  WebBrowser1.Navigate('file://' + htmlTask.PathToHtmlTask);
end;
procedure TFTester.ShowCurrentStat();
var
  tools:TTools;
begin
  StatusBar1.Panels[1].Text:=Format('������: %d / %d', [IndexTask+1, CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Count]);
  StatusBar1.Panels[2].Text:=Format('����: %d / %d', [IndexLesson+1, CoursesData.Items[IndexCourse].Lessons.Count]);
  StatusBar1.Panels[3].Text:=Format('��������: %s', [CoursesData[IndexCourse].Name]);
  theory:= CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].theory;
end;
procedure TFTester.ReadCurrentAnswers();
var
  i:Integer;
  s:String;
 ChB:TCheckBox;
//  document: IHTMLDocument2;
//  docAll: IHTMLElementCollection;
//  firstElement: IHTMLElement;
//  iCheckbox:Integer;
begin
//  document := wb.Document as IHTMLDocument2;
//
  StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Clear;
 s:='';
 for i:=1 to 5 do
  begin
   ChB:=(FindComponent('ChB'+IntToStr(i)) As TCheckBox);
   if ChB.Visible then
     if ChB.Checked then s:=s+ChB.Name+';';
  end;
 if Er.Visible then
   s:=s+Er.Text+';';
 StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Add(s);
//
//  if Assigned(document) then
//  begin
//    docAll := document.all;
//    iCheckbox:=0;
//    for i := 0 to docAll.length - 1 do
//    begin
//      firstElement := docAll.Item(i, '') as IHTMLElement;
//      if(firstElement.tagName = 'INPUT') and (firstElement.getAttribute('type', 0) = 'checkbox')then
//      begin
//        Inc(iCheckbox);
//        if(firstElement.getAttribute('checked', 0) = True)then
//        begin
//          StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Add(IntToStr(iCheckbox));
//        end;
//      end;
//    end;
//  end;
end;
procedure TFTester.MoveIndex(isForward: Boolean);
begin
  if(isForward)then
  begin
    Inc(IndexTask);
    if(IndexTask >= CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Count )then
    begin
      if (ModeTest = ClassWork) then
      begin
        // if the next lesson is not last in current course
        if (IndexLesson + 1 < CoursesData.Items[IndexCourse].Lessons.Count) then
        begin
          if (FCustomMessageBox.SetMessage('��������', Format('�� ��������� ���� "%s". ������ ������� � ���������� �����?', [CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Name]), TTypeMessage.msgOKCancel) = mrOk) then
          begin
            IndexTask:=0;
            Inc(IndexLesson);
          end else
          begin
            IsFinishedTest := true;
            Exit;
          end;
        end else
        begin
          IndexTask:=0;
          Inc(IndexLesson);
        end;
      end else// for other modes Self work/Diagnostic
      begin
        IndexTask:=0;
        Inc(IndexLesson);
      end;
    end;
    if (ModeTest = Diagnostic) and (IndexLesson >= CoursesData.Items[IndexCourse].Lessons.Count)then
    begin
      IndexLesson:=0;
      Inc(IndexCourse);
    end;
  end;
  if not(isForward)then
  begin
    Dec(IndexTask);
    if(IndexTask < 0) and (IndexLesson > 0)then
    begin
      Dec(IndexLesson);
      IndexTask:=CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Count-1;
    end;
    if(IndexLesson < 0) or (IndexTask < 0)then
    begin
      IndexTask:=0;
      IndexLesson:=0;
    end;
  end;
  if((ModeTest = Diagnostic) and (IndexCourse >= CoursesData.Count))
    or((ModeTest = ClassWork) and (IndexLesson >= CoursesData.Items[IndexCourse].Lessons.Count))
    or((ModeTest = SelfWork) and ((IndexLesson >= CoursesData.Items[IndexCourse].Lessons.Count) or
      (IndexTask >= CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Count)))then
  begin
    IsFinishedTest:=true;
  end else IsFinishedTest:=false;
end;
function TFTester.IsTrueTask():boolean;
//var
// s,s1:String;
//  trueAnswers, i: Integer;
begin
//  trueAnswers:=0;
//  if(CoursesData.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Items[IndexTask].TypeTask = Table)then
//  begin
//    for i:=0 to CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.TrueAnswers.Count - 1 do
//    begin
//      if(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Contains( IntToStr(CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.TrueAnswers[i]) ))then
//      begin
//        Inc(trueAnswers);
//      end;
//    end;
//  end;
//  Result:=(trueAnswers = CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.TrueAnswers.Count) and
//          (StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Count = CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.TrueAnswers.Count);
 Result:=(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Text=CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ConditionBody);
end;
//procedure TFTester.WebBrowser1DocumentComplete(ASender: TObject;
//  const pDisp: IDispatch; const URL: OleVariant);
//var
//  i: Integer;
//begin
//  if not(IsFinishedTest)then
//  begin
//    TimeTestController(TTimerMode.&On);
//    StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsView:=True;
//
//    if(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsTrue)then
//    begin
//      PanelWB.Enabled:=false;// ��������� ����������� ������� �� ������
//      ShowPreviewAnswer();
//    end else PanelWB.Enabled:=true;
//
//    // resize task
//    CustomCallFunctionJS('CheckScrollBars', '()', '', WebBrowser1);
//
//  end else TimeTestController(TTimerMode.Off);
//end;
procedure TFTester.ShowInvalidAnswers();
var
  invalidAnsw: TStringList;
  i: integer;
begin
  invalidAnsw:=TStringList.Create;
  for i := 0 to StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask.Count-1 do
  begin
//    if not(CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.TrueAnswers.Contains(StrToInt(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i])))then
//    begin
//      invalidAnsw.Add(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[i]);
//    end;
  end;
  if not(invalidAnsw.CommaText = EmptyStr)then
//    CustomCallFunctionJS('checkAnswers', '(%s)', Format('[%s]', [invalidAnsw.CommaText]), Webbrowser1);
  invalidAnsw.Free;
end;
                       //TList<String>
function IsEmptyAnswer(answers:String):boolean;
//var
//  i, emptyElements:Integer;
begin
 Result:=answers='';
//  if(answers.Count = 0)then
//  begin
//    Result:=true;
//    Exit;
//  end;
//  emptyElements:=0;
//  for i:=0 to answers.Count-1 do
//  begin
//    if(answers[i] = FTester.EMPTY_ANSWER)then inc(emptyElements);
//  end;
//
//  Result:=(emptyElements = answers.Count);
end;
procedure TFTester.FinishedTest();
begin
  FResults := TFResults.Create(nil);
  FResults.ShowResult(ModeTest, StatTest);
  Self.Hide;
end;
function TFTester.LoadTask(): Integer;
var
  i: integer;
  IsTrueAnswer: Boolean;
begin
  ReadCurrentAnswers();
  if(IsEmptyAnswer(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].UserAnswersByTask[0])) and (IsForwardDirection)then
  begin
    FCustomMessageBox.SetMessage('��������', '�������, ����������, ������.', TTypeMessage.msgOK);
    Result:=UNSUCCESS_LOAD_TASK;
    Exit;
  end;
  // TODO coming soon will remove feature of go to previous completed a task
  if not IsForwardDirection then
  begin
    MoveIndex(IsForwardDirection);
    PreLoadTask();
//    LoadItemsCondition();
    btnNext.Enabled:=true;
  end else
  begin
    // TODO coming soon will remove feature of go to previous completed a task
    // case when we back to previous completed a task and go to next the task
    if(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsTrue)then
    begin
      TimerAnimationSolution.Enabled:=false;
      MoveIndex(IsForwardDirection);
      if IsFinishedTest then
      begin
        Exit;
      end;
      PreLoadTask();
//      LoadItemsCondition();
      Result:=SUCCESS_LOAD_TASK;
      Exit;
    end;
    IsTrueAnswer:=IsTrueTask();
    if not(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsPassed)then
    begin
      StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsTrue:=IsTrueAnswer;
      StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsPassed:=true;
    end;
    StatTest[IndexCourse].Difficulty:=CoursesData[IndexCourse].Name;
    StatTest[IndexCourse].ID:=CoursesData[IndexCourse].ID;
    StatTest[IndexCourse].Lessons[IndexLesson].LessonName:=CoursesData[IndexCourse].Lessons[IndexLesson].Name;
    StatTest[IndexCourse].Lessons[IndexLesson].ID:=CoursesData[IndexCourse].Lessons[IndexLesson].ID;
    StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ID:=CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ID;
    if(IsTrueAnswer)then
    begin
      CustomPlaySound(IsTrueAnswer);
      TimerAnimationSolution.Enabled:=false;
      if(ModeTest = ClassWork) or (ModeTest = SelfWork)then
      begin
        btnSolutionTask.Enabled := false;
        btnVideoSolutionTask.Enabled := false;
      end;
      MoveIndex(IsForwardDirection);
      if(IsFinishedTest)then
      begin
        Exit;
      end else
      begin
        if (CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ResourceId <> EmptyStr) then
        begin
          Self.Manager := TTaskResourcesManager.CreateBySavedResources(CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].ResourceId);
        end else
        begin
          Self.Manager := nil;
        end;
        PreLoadTask();
//        LoadItemsCondition();
      end;
    end else// ����� ������
    begin
      if(ModeTest = ClassWork)or(ModeTest = SelfWork)then
      begin
        TimeTestController(TTimerMode.Ena);
//        ShowInvalidAnswers();
        CustomPlaySound(IsTrueAnswer);
        StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].CountAttempts:=StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].CountAttempts + 1;
        TimerAnimationSolution.Enabled:=true;
        btnSolutionTask.Enabled := true;
        btnVideoSolutionTask.Enabled := (Self.Manager <> nil) and (Self.Manager.HasTableVideoSolution);
//        LoadItemsCondition();
      end;
      if(ModeTest = Diagnostic)then
      begin
        IsFinishedTest:=true;
        if not(IsFinishedTest)then // TODO need investigate this case!!!
        begin
          PreLoadTask();
//          LoadItemsCondition();
        end else
        begin
          CustomPlaySound(IsTrueAnswer);
          Exit;
        end;
      end;
    end;
  end;
  Result:=SUCCESS_LOAD_TASK;
end;
procedure TFTester.OnTimerTest(Sender: TObject);
begin
  if not(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsTrue)then
  begin
    StatTest[IndexCourse].TimeSeconds:=StatTest[IndexCourse].TimeSeconds + 1;
    StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].TimeSeconds:=StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].TimeSeconds+1;
    StatTest[IndexCourse].Lessons[IndexLesson].TimeSeconds:=StatTest[IndexCourse].Lessons[IndexLesson].TimeSeconds+1;
    StatusBar1.Panels[0].Text:='����� '+TimeTrainer.GetCurrentSpentTime().stringFormatTime;
  end;
end;
procedure TFTester.TimeTestController(mode: TTimerMode);
begin
  if(mode = TTimerMode.Ena)and not(IsFinishedTest)then
  begin
    if not(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsView)then
    begin
      StatusBar1.Panels[0].Text:='����� 00:00';
      TimeTrainer.ResetTime();
    end;
    TimerTest.Enabled:=true;
    if (StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsPassed) and not(StatTest[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].IsTrue) then
    begin
      TimerAnimationSolution.Enabled := true;
    end;
  end;
  if(mode = TTimerMode.Dis)then
  begin
    TimerTest.Enabled := False;
    if(TimerAnimationSolution.Enabled)then
    begin
      TimerAnimationSolution.Enabled := False;
    end;
  end;
  if(mode = TTimerMode.Dis)and(IsFinishedTest = true)then statusbar1.Panels[0].Text := EmptyStr;
end;
//procedure TFTester.LoadItemsCondition(); // ������ ������� ��� "�������"
//begin
//  ClearAndLoadArrDisplayCondition();
//end;
procedure TFTester.ExecuteClose();
begin
  btnExit.Click;
end;
procedure TFTester.LoadDataForTest();
var
  i,j,k: integer;
begin
  FTester.Caption:=FTester.Caption +'. '+ AppTools.GetNameModeTest(ModeTest);
  IndexTask:=0;
  IndexLesson:=0;
  IndexCourse:=0;
  TimerTest:=Ttimer.Create(FTester);
  TimerTest.Enabled:=false;
  TimerTest.OnTimer:=OnTimerTest;
  TimerTest.Interval:=1000;
  StatTest:=TObjectList<TStatCourse>.Create;
  for i := 0 to CoursesData.Count-1 do
  begin
    StatTest.Add(TStatCourse.Create);
    for j := 0 to CoursesData[i].Lessons.Count-1 do
    begin
      StatTest[i].Lessons.Add(TStatLesson.Create);
      for k := 0 to CoursesData[i].Lessons[j].Tasks.Count-1 do
      begin
        StatTest[i].Lessons[j].Tasks.Add(TStatTask.Create);
      end;
    end;
  end;
//  StatTest[IndexCourse].Difficulty:=CoursesData[IndexCourse].Difficulty;
  StatTest[IndexCourse].Difficulty:=CoursesData[IndexCourse].Name;
  StatTest[IndexCourse].ID:=CoursesData[IndexCourse].ID;
end;
procedure TFTester.TimerAnimationRunPauseTimer(Sender: TObject);
begin
  if not btnPauseTest.Glyph.Empty then
    btnPauseTest.Glyph.Assign(nil)
  else ImageList1.GetBitmap(1 ,btnPauseTest.Glyph);
end;
procedure TFTester.TimerAnimationSolutionTimer(Sender: TObject);
begin
  if not btnSolutionTask.Glyph.Empty then
    btnSolutionTask.Glyph.Assign(nil)
  else ImageList1.GetBitmap(2, btnSolutionTask.Glyph);
  if not btnVideoSolutionTask.Glyph.Empty then
    btnVideoSolutionTask.Glyph.Assign(nil)
  else ImageList1.GetBitmap(3, btnVideoSolutionTask.Glyph);
end;
procedure TFTester.btnSolutionTaskClick(Sender: TObject);
begin
  if(ModeTest = ClassWork) or (ModeTest = SelfWork)then
  begin
    StatTest.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Items[IndexTask].CountHelpClick := StatTest.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Items[IndexTask].CountHelpClick + 1;
    btnPauseTest.Click;
    FSolutionTask := TFSolutionTask.Create(nil);
    FSolutionTask.Show;
    Self.Hide;
  end else
  begin
    FCustomMessageBox.SetMessage('��������', '�� ������� ����� �����������, � ���� ������ ��� ��������� ������!', TTypeMessage.msgOK);
  end;
end;
procedure TFTester.btnVideoSolutionTaskClick(Sender: TObject);
begin
	if (Self.Manager <> nil) and (Self.Manager.HasTableVideoSolution) then
  begin
    try
      StatTest.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Items[IndexTask].CountHelpClick := StatTest.Items[IndexCourse].Lessons.Items[IndexLesson].Tasks.Items[IndexTask].CountHelpClick + 1;
      PreLoadTask();
      Self.Manager.PlayTableVideoSolution(Config.PathToTempFolder, Self.Handle);
      btnPauseTest.Click;
    except
      FCustomMessageBox.SetMessage('������', '��������� ������ ��� ��������������� �����.', TTypeMessage.msgOK);
    end;
  end else FCustomMessageBox.SetMessage('��������', '��� ������ ������ ��� �� ������ ����� �������.', TTypeMessage.msgOK);
end;
procedure TFTester.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TimerTest.Enabled:=false;
  TimerTest.OnTimer:=nil;
  TimerAnimationSolution.Enabled:=false;
	StopPlayAudio();
  SetLength(ArrConditionals, 0);
//  SetLength(ArrDisplayConditions, 0);
  FreeAndNil(CoursesData);
  FreeAndNil(TimeTrainer);
  FreeAndNil(Self.Manager);
  // the StatTest obj destroy on FResults side
  FreeAndNil(StatTest);
  action:=caFree;
  FTester:=nil;
end;

procedure TFTester.FormCreate(Sender: TObject);
begin
  CurrentHeightPanelBackgr := panelBackground.Height;
  IndexTask := 0;
  IndexLesson := 0;
  IndexCourse := 0;
//  frmExtReasoning := TFExtendReasoning.Create(Self);
//  frmExtReasoning.Parent := panelBackground;
//  frmExtReasoning.Align := alClient;
//  frmExtReasoning.Visible := false;
//  frmExtReasoning.btnClose.OnClick := Self.OnCloseExtendReasoning;
  TimeTrainer := TTimerShare.Create;
  IsFinishedTest:=false;
  StatusBarUserInfo.Panels[0].Text:=FMainMenu.UserInfo.ToString();
end;
procedure TFTester.FormDestroy(Sender: TObject);
begin
  if(ModeTest = TMode.ClassWork) or (ModeTest = TMode.SelfWork)then Application.OnMessage:=nil;
end;
procedure TFTester.btnAudioConditionClick(Sender: TObject);
begin
	if (Self.Manager <> nil) and (Self.Manager.HasAudioCondition) then
  begin
  	try
    	if btnAudioCondition.ImageIndex = 5 then
      begin
				Self.Manager.PlayAudioCondition();
        btnAudioCondition.Glyph.Assign(nil);
        ImageList1.GetBitmap(4, btnAudioCondition.Glyph);
        btnAudioCondition.ImageIndex := 4;
        btnAudioCondition.Hint := '���������� ������������� �������';
      end else
      begin
      	StopPlayAudio();
      end;
	  except
      begin
        FCustomMessageBox.SetMessage('������', '������ ��� ������ �� ������.', TTypeMessage.msgOK);
      end;
  	end;
  end;
end;
procedure TFTester.btnBackClick(Sender: TObject);
begin
  TimeTestController(TTimerMode.Dis);
  IsForwardDirection:=false;
  if(LoadTask() = UNSUCCESS_LOAD_TASK)then Exit;
	StopPlayAudio();
  //btnAudioCondition.Enabled := (CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].Resources <> nil) and (CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].Resources.HasAudioCondition);
  ShowCurrentStat();
end;
procedure TFTester.btnNextClick(Sender: TObject);
begin
	StopPlayAudio();
  TimeTestController(TTimerMode.Dis);
  IsForwardDirection := true;
  if(LoadTask() = UNSUCCESS_LOAD_TASK)then
  begin
    TimeTestController(TTimerMode.Ena);
    Exit;
  end;
  if(IsFinishedTest = true)then
  begin
    StatusBar1.Panels[1].Text := EmptyStr;
    StatusBar1.Panels[2].Text := EmptyStr;
    StatusBar1.Panels[3].Text := EmptyStr;
    if(ModeTest = TMode.ClassWork) or (ModeTest = TMode.SelfWork) then Application.OnMessage:=nil;
    FinishedTest();
  end else
  begin
    ShowCurrentStat();
//    btnExtendReasoning.Enabled := HasExtendReasoning();
    // Manager was initialized in LoadTask()
		btnAudioCondition.Enabled := (Self.Manager <> nil) and (Self.Manager.HasAudioCondition);
  end;
end;
//procedure TFTester.btnReasoningClick(Sender: TObject);
//begin
//  FReasoning := TFReasoning.Create(Self, CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask], Self.Manager, TPath.Combine(Config.PathToTempFolder, Config.ResNamePenCursor), ((Self.ModeTest = TMode.ClassWork) or (Self.ModeTest = TMode.SelfWork)));
//  FReasoning.ShowModal();
//end;
procedure TFTester.btnPauseTestClick(Sender: TObject);
begin
  if(TimerTest.Enabled)then
  begin
    btnPauseTest.Hint := '���������� �������';
    TimeTestController(TTimerMode.Dis);
    btnPauseTest.Glyph.Assign(nil);
    ImageList1.GetBitmap(1, btnPauseTest.Glyph);
    btnBack.Enabled:=false;
    btnNext.Enabled:=false;
    PanelWB.Visible:=false;
    btnExtendReasoning.Enabled:=false;
    btnReasoning.Enabled:=false;
    btnSolutionTask.Enabled:=false;
    btnVideoSolutionTask.Enabled:=false;
    btnAudioCondition.Enabled:=false;
   	StopPlayAudio();
    TimerAnimationRunPause.Enabled := true;
  end else
  begin
    btnPauseTest.Hint := '������������� �������';
    TimerAnimationRunPause.Enabled := false;
    TimeTestController(TTimerMode.Ena);
    PanelWB.Visible:=True;
//    btnExtendReasoning.Enabled:=HasExtendReasoning();
    btnSolutionTask.Enabled:=TimerAnimationSolution.Enabled;
    btnVideoSolutionTask.Enabled := (TimerAnimationSolution.Enabled) and (Self.Manager <> nil) and (Self.Manager.HasTableVideoSolution);
    btnAudioCondition.Enabled:=(Self.Manager <> nil) and (Self.Manager.HasAudioCondition);
    btnReasoning.Enabled:=true;
    btnPauseTest.Glyph.Assign(nil);
    ImageList1.GetBitmap(0, btnPauseTest.Glyph);
    btnBack.Enabled:=(ModeTest <> Diagnostic);
    btnNext.Enabled:=true;
  end;
end;
procedure TFTester.btnExitClick(Sender: TObject);
begin
  if(FCustomMessageBox.SetMessage('��������', '�� ������������� ������ �����?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
    if(ModeTest = Diagnostic) and (GetCountPassedTasksInDiagnostic() > 0)then// if mode is diagnostic & has any passed tasks
    begin
      FinishedTest();
      Exit;
    end;
    FModeTestMenu:=TFModeTestMenu.Create(nil);
    FModeTestMenu.Show;
//    FHelpTest.Close;
    Self.Close;
  end;
end;
//procedure TFTester.btnExtendReasoningClick(Sender: TObject);
//begin
//  panelBackground.Height:=HEIGHT_EXTEND_REASONING;
//  frmExtReasoning.Visible:=true;
//end;
procedure TFTester.btnHelpClick(Sender: TObject);
begin
  var rfg := theory;
  FLTheory:=TFLTheory.Create(nil);
  FLTheory.theory:= theory;
  FLTheory.Show;
end;
end.
