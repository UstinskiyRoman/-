unit UReasoning;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Generics.Collections, Vcl.Buttons, UFormBase,
  System.IOUtils, UTaskInfo, UTaskResourcesManager;

type
  TPositionDrawElements = record
    left:Integer;
    top:integer;
end;

type
  TFReasoning = class(TFormBase)
    Image2: TImage;
    Memo1: TMemo;
    panelControlBaclground: TPanel;
    Image1: TImage;
    sbtnSolidLine: TSpeedButton;
    sbtnDashLine: TSpeedButton;
    btnClear: TBitBtn;
    btnClose: TBitBtn;
    btnVideoHelp: TBitBtn;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnClearClick(Sender: TObject);
    procedure btnClearStateClick(Sender: TObject);
    procedure sbtnDashLineClick(Sender: TObject);
    procedure sbtnSolidLineClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure ExecuteClose(); override;
  private
    CONST
      HEIGHT_LABEL = 21;
      WIDTH_LABEL = 121;

      HEIGHT_IMG = 97;
      WIDTH_IMG = 98;
      PR_OFFSET_LEFT_POS_IMG = 9;
      SC_OFFSET_LEFT_POS_IMG = 440;
      STEP_TOP_IMG = 105;

      crPen = 5;

    var
      ConditionalLabels:array of Tlabel;
      ConditionalImages:TObjectList<TImage>;
      dwn,dwn2:boolean;
      x0,y0,x1,y1:integer;
      Positions:array of TPositionDrawElements;
      countLinesConditional:integer;
      IsImageConditional: Boolean;
      task: TTask;
      pathToPenIcon: string;
      imagesByRows: TArray<TBytesStream>;
      imagesByColumns: TArray<TBytesStream>;


    procedure LoadConditional();
    procedure LoadLabels();
    procedure LoadImages();
    procedure InitSchemeWindow();
  public
		constructor Create(AOwner : TComponent; task: TTask; manager: TTaskResourcesManager; pathToPenIcon: string; isEnableVideoHelp: boolean);overload;
  end;

	var
		FReasoning: TFReasoning;

implementation

{$R *.dfm}

constructor TFReasoning.Create(AOwner : TComponent; task: TTask; manager: TTaskResourcesManager; pathToPenIcon: string; isEnableVideoHelp: boolean);
begin
  inherited Create(AOwner);

  if (task = nil) then raise Exception.Create('The task is empty');

	Self.task := task;
  Self.pathToPenIcon := pathToPenIcon;

  Self.btnVideoHelp.Enabled := isEnableVideoHelp;

  if (manager <> nil) and (manager.HasImagesForTaskBody) then
  begin
    var images := manager.GetImagesForTaskBody();
    SetLength(Self.imagesByRows, images['Rows'].Count);
    SetLength(Self.imagesByColumns, images['Columns'].Count);

    for var i := 0 to images['Rows'].Count - 1 do
    begin
      Self.imagesByRows[i] := images['Rows'][i].ImageContent;
    end;

    for var i := 0 to images['Columns'].Count - 1 do
    begin
      Self.imagesByColumns[i] := images['Columns'][i].ImageContent;
    end;
  end;
end;

procedure TFReasoning.ExecuteClose();
begin
  btnClose.Click;
end;

procedure TFReasoning.InitSchemeWindow();
begin
  if ((imagesByRows = nil) and (imagesByColumns = nil)) or ((Length(imagesByRows) = 0) and (Length(imagesByColumns) = 0)) then
  begin
    IsImageConditional:=False;
    LoadLabels();
  end else
  begin
    IsImageConditional:=True;
    LoadImages();
  end;

  LoadConditional();

  // by defualt solid mode
  sbtnSolidLine.Down := true;
  sbtnSolidLine.Click;
end;

procedure TFReasoning.LoadConditional();
begin
  Memo1.Lines.Clear;
  Memo1.Lines.Text := task.MetaInfo.ConditionText;
end;

procedure TFReasoning.LoadLabels();
var
  i:integer;
  IndexRows:Integer;
  IndexColumns:Integer;
  rows:Integer;
begin
  rows := task.MetaInfo.SizeTask.Rows;
  IndexRows := 0;
  IndexColumns := 0;

  countLinesConditional := task.MetaInfo.SizeTask.SummSize;

  SetLength(ConditionalLabels, countLinesConditional);
  SetLength(Positions, countLinesConditional);

  for i:=0 to task.MetaInfo.ElementsDraw.Count - 1 do
  begin
    ConditionalLabels[i]:=TLabel.Create(Self);
    ConditionalLabels[i].Parent:=Self;
    ConditionalLabels[i].Width:=WIDTH_LABEL + 50;
    ConditionalLabels[i].Height:=HEIGHT_LABEL + 50;
    ConditionalLabels[i].Font.Size:=15;
    ConditionalLabels[i].Caption:=task.MetaInfo.ElementsDraw[i];
    ConditionalLabels[i].Cursor:=crSizeAll;
    ConditionalLabels[i].OnMouseDown:=image2.OnMouseDown;
    ConditionalLabels[i].OnMouseMove:=image2.OnMouseMove;
    ConditionalLabels[i].OnMouseUp:=image2.OnMouseUp;

    if(i < rows)then
    begin
      Inc(IndexRows);
      ConditionalLabels[i].Left:=10;
      ConditionalLabels[i].Top:=IndexRows * 25;
    end;

    if(i >= rows)then
    begin
      Inc(IndexColumns);
      ConditionalLabels[i].Left:=325;
      ConditionalLabels[i].Top:=IndexColumns * 25;
    end;

    Positions[i].left:=ConditionalLabels[i].Left;
    Positions[i].top:=ConditionalLabels[i].Top;
  end;
end;

procedure TFReasoning.LoadImages();
var
  i, k:integer;
  img:TImage;
begin
  ConditionalImages := TObjectList<TImage>.Create;
  countLinesConditional := task.MetaInfo.SizeTask.SummSize;

  SetLength(Positions, countLinesConditional);

  for i:=0 to Length(Self.imagesByRows) - 1 do
  begin
    img:=TImage.Create(Self);
    img.Parent:=Self;
    img.Width:=WIDTH_IMG;
    img.Height:=HEIGHT_IMG;
    img.AutoSize:=false;
    img.Stretch:=true;
    img.Center:=true;

    imagesByRows[i].Position:=0;
    img.Picture.LoadFromStream(imagesByRows[i]);

    img.Cursor:=crSizeAll;
    img.OnMouseDown:=image2.OnMouseDown;
    img.OnMouseMove:=image2.OnMouseMove;
    img.OnMouseUp:=image2.OnMouseUp;
    img.Left:=PR_OFFSET_LEFT_POS_IMG;
    img.Top:=(i) * STEP_TOP_IMG;

    ConditionalImages.Add(img);
    Positions[i].left:=img.Left;
    Positions[i].top:=img.Top;

    k:=i + 1;
  end;

  for i:=0 to Length(Self.imagesByColumns) - 1 do
  begin
    img:=TImage.Create(Self);
    img.Parent:=Self;
    img.Width:=WIDTH_IMG;
    img.Height:=HEIGHT_IMG;
    img.AutoSize:=false;
    img.Stretch:=true;
    img.Center:=true;

    imagesByColumns[i].Position:=0;
    img.Picture.LoadFromStream(imagesByColumns[i]);

    img.Cursor:=crSizeAll;
    img.OnMouseDown:=image2.OnMouseDown;
    img.OnMouseMove:=image2.OnMouseMove;
    img.OnMouseUp:=image2.OnMouseUp;
    img.Left:=SC_OFFSET_LEFT_POS_IMG;
    img.Top:=(i) * STEP_TOP_IMG;

    ConditionalImages.Add(img);
    Positions[i + k].left:=img.Left;
    Positions[i + k].top:=img.Top;
  end;
end;

procedure TFReasoning.sbtnDashLineClick(Sender: TObject);
begin
  // http://docs.embarcadero.com/products/rad_studio/delphiAndcpp2009/HelpUpdate2/EN/html/delphivclwin32/Graphics_TPen_Style.html
  // Dotted or dashed pen styles are not available when the Width property is not 1
  image1.Canvas.Pen.Width := 1;
  image1.Canvas.Pen.Style := psDash;
end;

procedure TFReasoning.sbtnSolidLineClick(Sender: TObject);
begin
  image1.Canvas.Pen.Width := 2;
  image1.Canvas.Pen.Style := psSolid;
end;

procedure TFReasoning.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  x0:=x;
  y0:=y;
  x1:=x;
  y1:=y;
  image1.Canvas.Pen.Mode := pmNotXor;
  dwn := true;
end;

procedure TFReasoning.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  image1.canvas.MoveTo(x0, y0); //стирание прежней линии;
  image1.canvas.LineTo(X1, Y1);
  image1.canvas.Pen.Mode := pmCopy; //рисование новой линии;
  image1.canvas.MoveTo(X0, Y0);
  image1.canvas.LineTo(X, Y);
  dwn := false;
end;

procedure TFReasoning.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if(dwn)then
  Begin
    image1.Canvas.MoveTo(x0,y0);
    image1.Canvas.LineTo(x1,y1);
    image1.Canvas.MoveTo(x0,y0);
    image1.Canvas.LineTo(x,y);
    x1:=x;
    y1:=y;
  end;
end;

procedure TFReasoning.Image2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  X0 := X;
  Y0 := Y;
  dwn2 := true;
end;

procedure TFReasoning.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if(dwn2)then
  begin
    if(not IsImageConditional)then
    begin
      Tlabel(sender).Left:=Tlabel(sender).Left + x - x0;
      Tlabel(sender).Top:=Tlabel(sender).Top + y - y0;
    end else
    begin
      TImage(sender).Left:=TImage(sender).Left + x - x0;
      TImage(sender).Top:=TImage(sender).Top + y - y0;
    end;
  end;
end;

procedure TFReasoning.Image2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  dwn2 := false;
end;

procedure TFReasoning.btnClearClick(Sender: TObject);
var
  i:Integer;
begin
  Image1.Picture:=nil;

  if(High(ConditionalLabels) > 0)then
  begin
    for i := 0 to countLinesConditional-1 do
    begin
      ConditionalLabels[i].Left:=Positions[i].left;
      ConditionalLabels[i].Top:=Positions[i].top;
    end;

    Exit;
  end;

  if(ConditionalImages.Count > 0)then
  begin
    for i := 0 to ConditionalImages.Count-1 do
    begin
      ConditionalImages[i].Left:=Positions[i].left;
      ConditionalImages[i].Top:=Positions[i].top;
    end;
  end;
end;

procedure TFReasoning.btnClearStateClick(Sender: TObject);
var
  i: Integer;
begin
  Image1.Picture := nil;

  if sbtnSolidLine.Down then sbtnSolidLine.Click;
  if sbtnDashLine.Down then sbtnDashLine.Click;

  if(High(ConditionalLabels) > 0)then
  begin
    for i := 0 to countLinesConditional-1 do
    begin
      ConditionalLabels[i].Left:=Positions[i].left;
      ConditionalLabels[i].Top:=Positions[i].top;
    end;

    Exit;
  end;

  if(ConditionalImages.Count > 0)then
  begin
    for i := 0 to ConditionalImages.Count-1 do
    begin
      ConditionalImages[i].Left:=Positions[i].left;
      ConditionalImages[i].Top:=Positions[i].top;
    end;
  end;
end;

procedure TFReasoning.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFReasoning.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	SetLength(Positions, 0);
  SetLength(ConditionalLabels, 0);
  SetLength(Self.imagesByColumns, 0);
  SetLength(Self.imagesByRows, 0);
	FreeAndNil(ConditionalImages);

  action:=caFree;
  FReasoning := nil;
end;

procedure TFReasoning.FormCreate(Sender: TObject);
begin
  Screen.Cursors[crPen] := LoadCursorFromFile(PWChar(pathToPenIcon + '.ico'));
  Image1.Cursor := crPen;

  image1.Canvas.Pen.Color := clBlack;
end;

procedure TFReasoning.FormDestroy(Sender: TObject);
begin
  DestroyCursor(Screen.Cursors[crPen]);
end;

procedure TFReasoning.FormShow(Sender: TObject);
begin
	InitSchemeWindow();
end;

end.
 