unit UCustomMessageBox;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TTypeMessage = (msgOK, msgOKCancel);

type
  TFCustomMessageBox = class(TForm)
    panelOk: TPanel;
    btnOk: TBitBtn;
    lblTextBox: TLabel;
    panelOkCancel: TPanel;
    btn_questionOK: TBitBtn;
    btn_questionCancel: TBitBtn;
    procedure btnOkClick(Sender: TObject);
    procedure btn_questionCancelClick(Sender: TObject);
  private
    const
      MAX_LENGTH_MSG = 75;
      DEFAULT_FONT_SIZE = 20;
      SMALL_FONT_SIZE = 15;

    procedure CleanTexts();
  public
    function SetMessage(title: String; text: String; _type:TTypeMessage):Integer;
  end;

var
  FCustomMessageBox: TFCustomMessageBox;

implementation

{$R *.dfm}

procedure TFCustomMessageBox.btnOkClick(Sender: TObject);
begin
  CleanTexts();
end;

procedure TFCustomMessageBox.btn_questionCancelClick(Sender: TObject);
begin
  CleanTexts();
end;

procedure TFCustomMessageBox.CleanTexts();
begin
  Self.Caption:=EmptyStr;
  Self.lblTextBox.Caption:=EmptyStr;
end;

function TFCustomMessageBox.SetMessage(title: String; text: String; _type:TTypeMessage): Integer;
begin
  Self.Caption := title;
  Self.lblTextBox.Caption := text;

  if(Length(text) > MAX_LENGTH_MSG)then
  begin
    Self.lblTextBox.Font.Size:=SMALL_FONT_SIZE;
  end else  Self.lblTextBox.Font.Size:=DEFAULT_FONT_SIZE;

  if(_type = TTypeMessage.msgOK)then
  begin
    panelOkCancel.Visible:=false;
    panelOk.Visible:=true;
  end;

  if(_type = TTypeMessage.msgOKCancel)then
  begin
    panelOkCancel.Visible:=true;
    panelOk.Visible:=false;
  end;

  Result := Self.ShowModal();
end;



end.
