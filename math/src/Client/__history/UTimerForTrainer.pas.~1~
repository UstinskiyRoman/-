unit UTimerForTrainer;

interface

uses
  System.SysUtils, System.Classes, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TCustomDateTime = record
    seconds_: Integer;
    minutes_: Integer;
    stringFormatTime: String;
end;

type
  TTimerShare=class
  private
    Seconds: Integer;
    Minutes: Integer;
  public
    constructor Create();
    function GetCurrentSpentTime():TCustomDateTime;
    procedure ResetTime();
end;

implementation


constructor TTimerShare.Create();
begin
  Seconds:=0;
  Minutes:=0;
end;

procedure TTimerShare.ResetTime();
begin
  Seconds:=0;
  Minutes:=0;
end;

function TTimerShare.GetCurrentSpentTime():TCustomDateTime;
var
  sec_,min_:String;
begin
    Inc(Seconds);
    if(Seconds = 60)then
    begin
      Inc(Minutes);
      Seconds:=0;
    end;
    sec_:=IntToStr(Seconds);
    min_:=IntToStr(Minutes);
    if (Seconds < 10) then
      sec_:='0'+sec_;
    if (Minutes < 10) then
      min_:='0'+min_;

  Result.seconds_:=Seconds;
  Result.minutes_:=Minutes;
  Result.stringFormatTime := min_+':'+sec_;
end;


end.
