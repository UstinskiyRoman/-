unit UFormBase;

interface

uses
  Vcl.Forms, WinApi.Messages, WinApi.Windows, System.Classes;

type
  TFormBase = class(TForm)
  public
    constructor Create(AOwner: TComponent); override;
  protected
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMClose(var Message: TWMClose); message WM_CLOSE;

    procedure ExecuteClose(); dynamic; abstract;
  end;

implementation

{ UFormBase }

constructor TFormBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Self.Color := $00F0F9DD;
end;

procedure TFormBase.WMSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
    Application.Minimize
  else
    inherited;
end;

procedure TFormBase.WMClose(var Message: TWMClose);
begin
  ExecuteClose();
end;

end.
