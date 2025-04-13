unit ULTheory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFLTheory = class(TForm)
    MTheory: TMemo;
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    theory: String;
  end;

var
  FLTheory: TFLTheory;

implementation

{$R *.dfm}



procedure TFLTheory.FormShow(Sender: TObject);
begin
  FLTheory.MTheory.Clear;
  FLTheory.MTheory.Lines.Add(theory);
end;

end.
