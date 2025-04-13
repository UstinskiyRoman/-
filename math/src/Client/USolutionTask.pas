unit USolutionTask;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.OleCtrls, SHDocVw, WinApi.ShellApi, Vcl.ExtCtrls, Generics.Collections,
  //MSHTML, UTaskMetaInfo,
  UResolutionDisplay, Vcl.Buttons, UFormBase, System.Math,
  UconfigClient;

type
  TFSolutionTask = class(TFormBase)
    PanelBgControls: TPanel;
    GroupBox2: TGroupBox;
    Memo1: TMemo;
    Panel3: TPanel;
    btnNext: TBitBtn;
    GroupBox1: TGroupBox;
    Memo2: TMemo;
    procedure btnNextClick(Sender: TObject);
//    procedure ShowCondition();
//    procedure ListBox2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
//    procedure WebBrowser1DocumentComplete(ASender: TObject;
//      const pDisp: IDispatch; const URL: OleVariant);
  protected
    procedure ExecuteClose(); override;
  private
    CONST
      ZOOM_TASK = 0.75;
    var
//      ArrDisplayConditions: array of integer;

//    procedure InitWebTask();
    procedure InitItemConditions();
  public
    { Public declarations }
  end;

var
  FSolutionTask: TFSolutionTask;

implementation

uses UTester;

{$R *.dfm}

//procedure CustomCallFunctionJS(NameFuction: string; Param: String; arrAnswers: string; WB: TWebBrowser);
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

procedure TFSolutionTask.ExecuteClose();
begin
  btnNext.Click;
end;

procedure TFSolutionTask.InitItemConditions();
//var
//  itemCondition: String;
begin
 Memo2.Text:=FTester.M1.Text;
 Memo1.Text:=FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo;
//  for itemCondition in FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Conditions do
//  begin
//    ListBox2.Items.Add(itemCondition);
//  end;
end;

//procedure TFSolutionTask.ShowCondition();
//var
//  i:Integer;
//  vvod_otv:Variant;
//  arrVariants: TList<integer>;
//  variantAnswers: string;
//
////  itemExplanation: TItemExplanation;
//  itemTrueAnswers: Integer;
//  itemVariantAnswers: Integer;
//begin
//  arrVariants:=TList<integer>.Create;
//  i:=0;

//  for itemExplanation in FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Explanations do
//  begin
//    if( POS(itemExplanation.ConditionText, ListBox2.Items[ListBox2.ItemIndex]) > 0)then
//    begin
//        for itemTrueAnswers in itemExplanation.TrueAnswers do
//        begin
//          vvod_otv:=FSolutionTask.Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemTrueAnswers)+'t');
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
//          vvod_otv:=FSolutionTask.Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemVariantAnswers)+'t');
//
//          if(ArrDisplayConditions[i] <> -1)then
//          begin
//            //double click for enable 3 state checkbox
//            vvod_otv.Click;
//            vvod_otv.Click;
//          end;
//        end;
//
//        ArrDisplayConditions[i]:=-1;
//    end;
//
//    Inc(i);
//  end;

//  if(arrVariants.Count > 0)then
//  begin
//    variantAnswers:='[';
//    for i := 0 to arrVariants.Count-2 do
//      variantAnswers:=variantAnswers + IntToStr(arrVariants[i]) + ', ';
//
//    variantAnswers:=variantAnswers + IntToStr(arrVariants[arrVariants.Count-1]) + ']';
//    CustomCallFunctionJS('startShowCondition', '(%s)', variantAnswers, FSolutionTask.Webbrowser1);
//  end;
//
//  arrVariants.Free;
//end;

//procedure TFSolutionTask.WebBrowser1DocumentComplete(ASender: TObject;
//  const pDisp: IDispatch; const URL: OleVariant);
//begin
//  WebBrowser1.OleObject.Document.Body.Style.Zoom:=ZOOM_TASK;
//
//  // selected first item of condition
//  ListBox2.ItemIndex := 0;
//  ListBox2.OnClick(ASender);
//end;

procedure TFSolutionTask.btnNextClick(Sender: TObject);
begin
  FTester.btnPauseTest.Click;
  FTester.PreLoadTask();// TODO очистку ответов сделать через js нужно

//  CustomCallFunctionJS('endShowCondition', '()', '', FSolutionTask.Webbrowser1);
  Self.Close;
  FTester.Show();
end;

//procedure TFSolutionTask.InitWebTask();
//begin
//  WebBrowser1.Navigate('file://' + FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].SaveHtmlTaskToFile(False, Config.PathToTempFolder, Config.ResNameTemplateHtmlTask).PathToHtmlTask);
//end;

//procedure TFSolutionTask.ListBox2Click(Sender: TObject);
//var
//  itemExpl: TItemExplanation;
//begin
//  if ListBox2.ItemIndex =-1 then exit;
//
//  Memo1.Clear;
//
////  for itemExpl in FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Explanations do
////  begin
////    if( POS(itemExpl.ConditionText, ListBox2.Items[ListBox2.ItemIndex]) > 0)then
////    begin
////      Memo1.Lines.Text:=itemExpl.ExplanationText;
////    end;
////  end;
//
//  ShowCondition();
//end;

procedure TFSolutionTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  FSolutionTask:=nil;
end;

//procedure SetScrollWidth;
//var
//  I, MaxWidth: Integer;
//begin
//  MaxWidth := -1;
//  // assign control's font to canvas
//  FSolutionTask.ListBox2.Canvas.Font := FSolutionTask.ListBox2.Font;
//  for I := 0 to FSolutionTask.ListBox2.Items.Count - 1 do
//    MaxWidth := Max(MaxWidth, FSolutionTask.ListBox2.Canvas.TextWidth(FSolutionTask.ListBox2.Items[I]));
//  // consider non-client area
//  if MaxWidth <> -1 then
//    FSolutionTask.ListBox2.ScrollWidth := MaxWidth + FSolutionTask.ListBox2.Width - FSolutionTask.ListBox2.ClientWidth;
//end;

procedure TFSolutionTask.FormShow(Sender: TObject);
begin
  FSolutionTask.Memo2.Clear;
  FSolutionTask.Memo1.Clear;

  InitItemConditions();
//  InitWebTask();

//  SetLength(ArrDisplayConditions, FTester.CoursesData[IndexCourse].Lessons[IndexLesson].Tasks[IndexTask].MetaInfo.Conditions.Count);

//  SetScrollWidth();
end;

end.
