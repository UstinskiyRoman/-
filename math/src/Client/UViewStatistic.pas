unit UViewStatistic;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, UModes, UMainMenu,
  UTools, UDataModuleClient, Generics.Collections, UStatisticInfo, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart;

type
  TFViewStatistic = class(TFrame)
    btnClose: TBitBtn;
    PageControl1: TPageControl;
    TabSheetDiagnosticStat: TTabSheet;
    TabSheetClassWorkStat: TTabSheet;
    TabSheetSelfWorkStat: TTabSheet;
    Chart1: TChart;
    Series1: TBarSeries;
    btnPrintDiagnostic: TBitBtn;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Chart2: TChart;
    BarSeries1: TBarSeries;
    Chart3: TChart;
    BarSeries2: TBarSeries;
    btnPrintClassWork: TBitBtn;
    btnPrintSelfWork: TBitBtn;
    procedure PageControl1Change(Sender: TObject);
    procedure btnPrintDiagnosticClick(Sender: TObject);
    procedure btnPrintClassWorkClick(Sender: TObject);
    procedure btnPrintSelfWorkClick(Sender: TObject);
  private
    _mode:TMode;
    { Private declarations }
    procedure LoadStatForDiagnostic();
    procedure LoadStatForClassWork();
    procedure LoadStatForSelfWork();
  public
    { Public declarations }
    procedure ShowStatisticByMode(mode:TMode);
  end;

implementation

{$R *.dfm}

procedure TFViewStatistic.PageControl1Change(Sender: TObject);
begin
  case _mode of
    Diagnostic: begin PageControl1.ActivePageIndex:=0; Exit; end;
    ClassWork: begin PageControl1.ActivePageIndex:=1; Exit; end;
    SelfWork: begin PageControl1.ActivePageIndex:=2; Exit; end;
  end;
end;

procedure TFViewStatistic.ShowStatisticByMode(mode:TMode);
begin
  _mode := mode;

  case _mode of
    Diagnostic: begin PageControl1.ActivePageIndex:=0; LoadStatForDiagnostic(); Exit; end;
    ClassWork: begin PageControl1.ActivePageIndex:=1; LoadStatForClassWork(); Exit; end;
    SelfWork: begin PageControl1.ActivePageIndex:=2; LoadStatForSelfWork(); Exit; end;
  end;
end;

procedure TFViewStatistic.btnPrintDiagnosticClick(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then
  begin
    Chart1.PrintResolution:=52;
    Chart1.Print;
  end;
end;

procedure TFViewStatistic.btnPrintClassWorkClick(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then
  begin
    Chart2.PrintResolution:=52;
    Chart2.Print;
  end;
end;

procedure TFViewStatistic.btnPrintSelfWorkClick(Sender: TObject);
begin
  if PrinterSetupDialog1.Execute then
  begin
    Chart3.PrintResolution:=52;
    Chart3.Print;
  end;
end;

procedure TFViewStatistic.LoadStatForDiagnostic();
var
  statisticsDiagnostic:TObjectList<TStatDiagnostic>;
  statDiagnostic:TStatDiagnostic;
  tools: TTools;
  title: string;
begin
  tools:=TTools.Create;
  statisticsDiagnostic:=DataModuleClient.GetStatDiagnosticByUserId(FMainMenu.UserInfo.ID);

  Chart1.Series[0].Clear;

  Chart1.Title.Clear;
  Chart1.Title.Text.Add(FMainMenu.UserInfo.ToString+', '+AppTools.GetCurrentTimeStr());

  for statDiagnostic in statisticsDiagnostic do
  begin
    title:=Format('Время:[%s]. %s',
                  [tools.GetStrTimeBySeconds(statDiagnostic.SpentTimeSeconds),
                  FormatDateTime('dd.mm.yyyy hh:nn:ss', statDiagnostic.DateTest)]);

    Chart1.Series[0].Add(Ord(statDiagnostic.Difficulty) + 1, title);
  end;

  tools.Free;
end;

procedure TFViewStatistic.LoadStatForClassWork();
var
  statisticsClassWork:TObjectList<TStatDiagnostic>;
  statDiagnostic:TStatDiagnostic;
  tools: TTools;
  title: string;
begin
  tools:=TTools.Create;
  statisticsClassWork:=DataModuleClient.GetStatDiagnosticByUserId(FMainMenu.UserInfo.ID);

  Chart2.Series[0].Clear;

  Chart2.Title.Clear;
  Chart2.Title.Text.Add(FMainMenu.UserInfo.ToString+', '+AppTools.GetCurrentTimeStr());

  for statDiagnostic in statisticsClassWork do
  begin
    title:=Format('Время:[%s]. %s',
                  [tools.GetStrTimeBySeconds(statDiagnostic.SpentTimeSeconds),
                  FormatDateTime('dd.mm.yyyy hh:nn:ss', statDiagnostic.DateTest)]);

    Chart1.Series[0].Add(Ord(statDiagnostic.Difficulty) + 1, title);
  end;

  tools.Free;
end;

procedure TFViewStatistic.LoadStatForSelfWork();
var
  statisticsDiagnostic:TObjectList<TStatDiagnostic>;
  statDiagnostic:TStatDiagnostic;
  tools: TTools;
  title: string;
begin
  tools:=TTools.Create;
  statisticsDiagnostic:=DataModuleClient.GetStatDiagnosticByUserId(FMainMenu.UserInfo.ID);

  Chart3.Series[0].Clear;

  Chart3.Title.Clear;
  Chart3.Title.Text.Add(FMainMenu.UserInfo.ToString+', '+AppTools.GetCurrentTimeStr());

  for statDiagnostic in statisticsDiagnostic do
  begin
    title:=Format('Время:[%s]. %s',
                  [tools.GetStrTimeBySeconds(statDiagnostic.SpentTimeSeconds),
                  FormatDateTime('dd.mm.yyyy hh:nn:ss', statDiagnostic.DateTest)]);

    Chart1.Series[0].Add(Ord(statDiagnostic.Difficulty) + 1, title);
  end;

  tools.Free;
end;

end.

