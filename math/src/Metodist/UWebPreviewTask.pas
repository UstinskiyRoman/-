unit UWebPreviewTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Generics.Collections, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, UTaskInfo, //UConfigEditor,
  //SHDocVw, MSHTML, UTaskMetaInfo,
   System.IOUtils, WinApi.MMSystem, UCustomMessageBox,
  UTaskResourcesManager, UFormBase; //UReasoning,

type
  TFWebPreviewTask = class(TFormBase)
    panelBackground: TPanel;
    btnCheckAnswer: TBitBtn;
    btnRefresh: TBitBtn;
    btnAudioCondition: TBitBtn;
    btnTableVideoSolution: TBitBtn;
    ChB1: TCheckBox;
    ChB2: TCheckBox;
    ChB3: TCheckBox;
    ChB4: TCheckBox;
    ChB5: TCheckBox;
    LbE: TLabel;
    Er: TEdit;
    M1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCheckAnswerClick(Sender: TObject);
    procedure btnReasoningClick(Sender: TObject);
    procedure btnAudioConditionClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTableVideoSolutionClick(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    userAnswersByTask: TList<string>;
    task: TTask;
    manager: TTaskResourcesManager;
    displayConditions: TArray<integer>;
//    pathToHtml: string;

    procedure SetForm;
    procedure ShowTrueAnswers();
//    procedure ClickOnItemCondition(var msg:TMsg; var handled:boolean);
//    procedure ShowAnswerForItemCondition(selectItemCondition: string);
    procedure ShowTask();
    procedure StopPlayAudio();
  public
    constructor Create(AOwner : TComponent; task: TTask; manager: TTaskResourcesManager);overload;
//    procedure ShowPreview();
    procedure CheckTask();
  end;

var
  FWebPreviewTask: TFWebPreviewTask;

implementation

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

constructor TFWebPreviewTask.Create(AOwner : TComponent; task: TTask; manager: TTaskResourcesManager);
begin
  inherited Create(AOwner);

  if (task = nil) then raise Exception.Create('The task or resources manager are empty');

	Self.task := task;
  Self.manager := manager;
end;

procedure TFWebPreviewTask.ExecuteClose();
begin
  Self.Close;
end;

procedure TFWebPreviewTask.btnTableVideoSolutionClick(Sender: TObject);
begin
  if not(Self.manager.HasTableVideoSolution) then Exit;

	StopPlayAudio();

  try
//    Self.manager.PlayTableVideoSolution(Config.PathToTempFolder, Self.Handle);
  except
    begin
      FCustomMessageBox.SetMessage('Ошибка!', 'Ошибка при работе с видео.', TTypeMessage.msgOK);
    end;
  end;
end;

procedure TFWebPreviewTask.btnAudioConditionClick(Sender: TObject);
begin
  if not(Self.manager.HasAudioCondition) then Exit;

  try
    if btnAudioCondition.NumGlyphs = 1 then
    begin
      Self.manager.PlayAudioCondition();
      btnAudioCondition.NumGlyphs := 2;
      btnAudioCondition.Hint := 'Остановить прослушивание условия';
    end else
    begin
      StopPlayAudio();
    end;
  except
    begin
      FCustomMessageBox.SetMessage('Ошибка!', 'Ошибка при работе со звуком.', TTypeMessage.msgOK);
    end;
  end;
end;

procedure TFWebPreviewTask.StopPlayAudio();
begin
	if btnAudioCondition.NumGlyphs = 2 then
  begin
		sndPlaySound(nil, SND_ASYNC);
		btnAudioCondition.NumGlyphs := 1;
    btnAudioCondition.Hint := 'Прослушать условие';
  end;
end;

procedure TFWebPreviewTask.btnCheckAnswerClick(Sender: TObject);
begin
  ShowTrueAnswers();
end;

procedure TFWebPreviewTask.btnReasoningClick(Sender: TObject);
begin
//  FReasoning := TFReasoning.Create(nil, Self.task, Self.manager, TPath.Combine(Config.PathToTempFolder, Config.ResNamePenCursor), true);
//  FReasoning.ShowModal();
end;

procedure TFWebPreviewTask.btnRefreshClick(Sender: TObject);
var
 i:Integer;
 ChB:TCheckBox;
begin
//  SetLength(displayConditions, 0);
//  Self.WebBrowser1.Navigate('file://' + pathToHtml);
 for i := 1 to 5 do
  begin
   ChB:=(FindComponent('ChB'+IntToStr(i)) As TCheckBox);
   if ChB.Visible then ChB.Checked:=False;
  end;
  if Er.Visible then  Er.Text:='';
end;


//procedure TFWebPreviewTask.ClickOnItemCondition(var msg:TMsg; var handled:boolean);
//var
//  X, Y: Integer;
//  document, E: OleVariant;
//begin
//   Handled := False;
//
//   if (WebBrowser1 = nil) or (Msg.message <> WM_LBUTTONDOWN) then Exit;
//
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
//     end;
//   end;
//end;

//procedure TFWebPreviewTask.ShowAnswerForItemCondition(selectItemCondition: String);
//var
//  i:integer;
//  vvod_otv:Variant;
//  arrVariants: TList<integer>;
//  variantAnswers: string;
//
//  itemExplanation: TItemExplanation;
//  itemTrueAnswers: Integer;
//  itemVariantAnswers: Integer;
//begin
//  if (Self.task.MetaInfo = nil) then Exit;
//
//  arrVariants := TList<integer>.Create;
//  i := 0;
//  SetLength(displayConditions, Self.task.MetaInfo.Conditions.Count + 1);
//
//  for itemExplanation in Self.task.MetaInfo.Explanations do
//  begin
//    if( POS(itemExplanation.ConditionText, selectItemCondition) > 0)then
//    begin
//        for itemTrueAnswers in itemExplanation.TrueAnswers do
//        begin
//          vvod_otv := Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemTrueAnswers)+'t');
//
//          if(displayConditions[i] <> -1)then
//          begin
//            vvod_otv.Click;
//          end;
//
//          arrVariants.Add(itemTrueAnswers);
//        end;
//
//        for itemVariantAnswers in itemExplanation.Variants do
//        begin
//          vvod_otv := Webbrowser1.OleObject.document.getelementByid('pos'+IntToStr(itemVariantAnswers)+'t');
//
//          if(displayConditions[i] <> -1)then
//          begin
//            //double click for enable 3 state checkbox
//            vvod_otv.Click;
//            vvod_otv.Click;
//          end;
//        end;
//
//        displayConditions[i] := -1;
//    end else
//    begin
//      CustomCallFunctionJS('endShowCondition', '()', '', Webbrowser1);
//    end;
//
//    Inc(i);
//  end;
//
//  if(arrVariants.Count > 0)then
//  begin
//    variantAnswers := '[';
//    for i := 0 to arrVariants.Count-2 do variantAnswers:=variantAnswers + IntToStr(arrVariants[i]) + ', ';
//
//    variantAnswers := variantAnswers + IntToStr(arrVariants[arrVariants.Count-1]) + ']';
//    CustomCallFunctionJS('startShowCondition', '(%s)', variantAnswers, Webbrowser1);
//  end;
//
//  arrVariants.Free;
//end;

procedure TFWebPreviewTask.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	StopPlayAudio();

  SetLength(Self.displayConditions, 0);

  FreeAndNil(Self.manager);

  action := caFree;
  FWebPreviewTask := nil;
end;


procedure TFWebPreviewTask.SetForm;
var
 stbody:TStrings;
 i:Integer;
 s:String;
 ChB:TCheckBox;
begin
 stbody:=TStringList.Create;
 stbody.Text:=task.TaskBody;
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
     Delete(s,1,Pos(';',s));
     ChB.Caption:=Copy(s,1,Pos(';',s)-1);
    end
   else
    begin
     Lbe.Visible:=True;
     Er.Visible:=True;
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

end;

procedure TFWebPreviewTask.FormCreate(Sender: TObject);
begin
//  Application.OnMessage := ClickOnItemCondition;
end;

procedure TFWebPreviewTask.FormDestroy(Sender: TObject);
begin
  Application.OnMessage := nil;
end;

procedure TFWebPreviewTask.ShowTask();
begin
  SetForm;
  Self.Show();

  btnAudioCondition.Enabled := (Self.manager <> nil) and (Self.manager.HasAudioCondition);
  btnTableVideoSolution.Enabled := (Self.manager <> nil) and (Self.manager.HasTableVideoSolution);
end;

//procedure TFWebPreviewTask.ShowPreview();
//begin
//  panelBackground.Visible := false;
//  ShowTask();
//end;

procedure TFWebPreviewTask.CheckTask();
begin
  panelBackground.Visible := true;
  ShowTask();
end;

procedure TFWebPreviewTask.ShowTrueAnswers();
var
 s:String;
begin
 s:=task.ConditionBody;
 while Pos(';',s)>0 do
  begin
   if s[1]='C' then
    (FindComponent(Copy(s,1,Pos(';',s)-1)) As TCheckBox).Checked:=True
   else
    Er.Text:=Copy(s,1,Pos(';',s)-1);
   Delete(s,1,Pos(';',s));
  end;

end;

end.
