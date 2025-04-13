unit UTaskMetaInfo;

interface

uses
  Generics.Collections, System.Classes, System.NetEncoding,
  //UXMLLoader, Xml.XMLIntf,
   System.SysUtils;

type
  TSizeTask = record
    Columns: Integer;
    Rows: Integer;
    DecartSize: Integer;
    SummSize: Integer;
    SizeStr: String;
  end;

type
  TItemExplanation = record
    TrueAnswers: TList<Integer>;
    Variants: TList<Integer>;
    ConditionText: String;
    ExplanationText: String;
  private
    procedure Destory();
  end;

type
  TTaskMetaInfo = class
    SizeTask: TSizeTask;
    TrueAnswers: TList<Integer>;
    Conditions: TList<String>;
    Explanations: TList<TItemExplanation>;
    ElementsDraw: TList<String>;
    ExtendingExplanations: String;
    ConditionText: String;
    RawInfo: string;
  public
//    constructor Create(xml: string; isKeepRawInfo: Boolean = false);
    destructor Destroy; override;

  private
//    procedure InitMetaInfo(Xml: string; isKeepRawInfo: Boolean = false);
  end;

implementation

//constructor TTaskMetaInfo.Create(xml: string; isKeepRawInfo: Boolean = false);
//begin
//  Self.TrueAnswers := TList<Integer>.Create;
//  Self.Conditions := TList<String>.Create;
//  Self.Explanations := TList<TItemExplanation>.Create;
//  Self.ElementsDraw := TList<String>.Create;
//
//  Self.InitMetaInfo(xml, isKeepRawInfo);
//end;

destructor TTaskMetaInfo.Destroy;
var
  i: Integer;
begin
  inherited;

  FreeAndNil(Self.TrueAnswers);
  FreeAndNil(Self.Conditions);
  FreeAndNil(Self.ElementsDraw);

  SetLength(Self.ConditionText, 0);
  SetLength(Self.ExtendingExplanations, 0);

  for i := 0 to Self.Explanations.Count - 1 do
    Self.Explanations[i].Destory();

  FreeAndNil(Self.Explanations);
end;

//procedure TTaskMetaInfo.InitMetaInfo(Xml: string; isKeepRawInfo: Boolean = false);
//var
//  ItemExplanation: TItemExplanation;
//  i, j: Integer;
//  RootNode: IXMLNode;
//begin
//  if (isKeepRawInfo) then Self.RawInfo := Xml;
//
//  RootNode := XMLLoader.XMLContentFromText(Xml);
//  Self.SizeTask.Rows := RootNode.ChildNodes['sizeTable'].ChildNodes['rows'].NodeValue;
//  Self.SizeTask.Columns := RootNode.ChildNodes['sizeTable'].ChildNodes['cols'].NodeValue;
//
//  Self.SizeTask.SizeStr := Format('%dx%d',[Self.SizeTask.Rows, Self.SizeTask.Columns]);
//  Self.SizeTask.DecartSize := Self.SizeTask.Rows * Self.SizeTask.Columns;
//  Self.SizeTask.SummSize := Self.SizeTask.Rows + Self.SizeTask.Columns;
//
//  Self.ExtendingExplanations := RootNode.ChildNodes['extendingExplanations'].Text;
//  Self.ConditionText := RootNode.ChildNodes['conditionText'].NodeValue;
//
//  for i := 0 to RootNode.ChildNodes['arrayTrueAnswers'].ChildNodes.Count - 1 do
//  begin
//    Self.TrueAnswers.Add(StrToInt(RootNode.ChildNodes['arrayTrueAnswers'].ChildNodes[i].Text));
//  end;
//  for i := 0 to RootNode.ChildNodes['itemsConditions'].ChildNodes.Count - 1 do
//  begin
//    Self.Conditions.Add(RootNode.ChildNodes['itemsConditions'].ChildNodes[i].Text);
//  end;
//  for i := 0 to RootNode.ChildNodes['itemsExplanations'].ChildNodes.Count - 1 do
//  begin
//    ItemExplanation.ConditionText := RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['condition'].Text;
//    ItemExplanation.ExplanationText := RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['explanation'].Text;
//
//    ItemExplanation.TrueAnswers := TList<Integer>.Create;
//    ItemExplanation.Variants := TList<Integer>.Create;
//
//    for j := 0 to RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['trueAnswers'].ChildNodes.Count - 1 do
//    begin
//      ItemExplanation.TrueAnswers.Add(RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['trueAnswers'].ChildNodes[j].NodeValue);
//    end;
//    for j := 0 to RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['variants'].ChildNodes.Count - 1 do
//    begin
//      ItemExplanation.Variants.Add(RootNode.ChildNodes['itemsExplanations'].ChildNodes[i].ChildNodes['variants'].ChildNodes[j].NodeValue);
//    end;
//    Self.Explanations.Add(ItemExplanation);
//  end;
//  for i := 0 to RootNode.ChildNodes['labelsForDraw'].ChildNodes.Count - 1 do
//  begin
//    Self.ElementsDraw.Add(RootNode.ChildNodes['labelsForDraw'].ChildNodes[i].NodeValue);
//  end;
//end;

procedure TItemExplanation.Destory();
begin
  inherited;

  SetLength(Self.ExplanationText, 0);
  SetLength(Self.ConditionText, 0);
  FreeAndNil(Self.Variants);
  FreeAndNil(Self.TrueAnswers);
end;

end.
