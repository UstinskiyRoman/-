unit UShowStat;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VclTee.TeeGDIPlus, Data.DB,
  VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.DBChart,
  Data.Win.ADODB;

type
  TShowStats = class(TForm)
    ADOTable1: TADOTable;
    ADOConnection1: TADOConnection;
    DBChart1: TDBChart;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowStats: TShowStats;

implementation

{$R *.dfm}

procedure TShowStats.FormCreate(Sender: TObject);
var curpath, a, b: widestring;
HasErrors : Boolean;
begin

curpath:=ExtractFilePath(Application.ExeName); {строка получается сразу со слешем "\" на конце}
  ADOTable1.Active := false;
  a:='Provider=Microsoft.Jet.OLEDB.4.0;Data Source=';{это взял из свойства ConnectionString компонента TADOConnection}
  b:=';Persist Security Info=False'; {и это тоже взял из свойства ConnectionString компонента TADOConnection}
//ADOTable1.ConnectionString:=a+curpath+'db\DB.mdb'+b;{у меня база "dbase.mdb" находится в папке dbase}
  try
    ADOConnection1.Connected := False;
    ADOConnection1.ConnectionString :=
        'Provider=Microsoft.Jet.OLEDB.4.0;'+
        'User ID=Admin;'+
        'Data Source="..\..\..\..\data\LogicDB.mdb";'+
        'Mode=Share Deny None;'+
        'Extended Properties="";'+
        'Jet OLEDB:System database="";'+
        'Jet OLEDB:Registry Path="";'+
        'Jet OLEDB:Database Password="1";'+
        'Jet OLEDB:Engine Type=5;'+
        'Jet OLEDB:Database Locking Mode=1;'+
        'Jet OLEDB:Global Partial Bulk Ops=2;'+
        'Jet OLEDB:Global Bulk Transactions=1;'+
        'Jet OLEDB:New Database Password="1";'+
        'Jet OLEDB:Create System Database=False;'+
        'Jet OLEDB:Encrypt Database=False;'+
        'Jet OLEDB:Don'+'''t Copy Locale on Compact=False;'+
        'Jet OLEDB:Compact Without Replica Repair=False;'+
        'Jet OLEDB:SFP=False';

    ADOConnection1.Connected := true;
  except on E : Exception do
    begin
      HasErrors := true;
      raise Exception.Create(Format('Ошибка. Нет соединения с Базой Данных. %s', [E.Message]));
    end;
  end;
  ADOTable1.Active := true;
end;

end.
