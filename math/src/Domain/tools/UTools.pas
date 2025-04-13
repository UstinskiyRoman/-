unit UTools;

interface

uses UUserInfo, System.SysUtils, WinApi.Windows,UModes, // UTaskMetaInfo, UDifficulty,
 IdHashMessageDigest;

type
  TTools = class
    public                                   //TDifficulty
      function GetNameDifficulty(_difficulty:Integer):String;
      function GetStrTimeBySeconds(allSeconds:Integer):string;
      function GetCurrentTimeStr():String;
      function GetNameModeTest(modeTest: TMode):String;
//      function GetSizeTask(sizeTaskStr:String):TSizeTask;
      function GetNumberDifficulty(_difficulty:Integer):Integer;
      function StringToHash(s:string):string;
      function GetModeByName(name:string):TMode;
end;

var
  AppTools:TTools;

implementation

function TTools.GetModeByName(name:string):TMode;
begin
  if(name = EmptyStr)then raise Exception.Create('Name of mode test is empty');

  if(GetNameModeTest(TMode.ClassWork) = name)then Result := TMode.ClassWork;
  if(GetNameModeTest(TMode.SelfWork) = name)then Result := TMode.SelfWork;
  if(GetNameModeTest(TMode.Diagnostic) = name)then Result := TMode.Diagnostic;
end;
//
function TTools.GetNameDifficulty(_difficulty:Integer):String;
begin
//  case _difficulty of
//    VeryEasy : begin Result:='1. Математика'; Exit; end;
//    Easy : begin Result:='2. Экономика'; Exit; end;
//    Simple : begin Result:='3. Физика'; Exit; end;
//    Hard : begin Result:='4. Химия'; Exit; end;
//    VeryHard : begin Result:='5. Самый сложный'; Exit; end;
//  end;

  Result:=EmptyStr;
end;
//
function TTools.GetNumberDifficulty(_difficulty:Integer):Integer;
begin
//  case _difficulty of
//    VeryEasy : begin Result:=1; Exit; end;
//    Easy : begin Result:=2; Exit; end;
//    Simple : begin Result:=3; Exit; end;
//    Hard : begin Result:=4; Exit; end;
//    VeryHard : begin Result:=5; Exit; end;
//  end;

  Result:=-1;
end;

function TTools.GetStrTimeBySeconds(allSeconds:Integer):string;
begin
  Result:=Format('%.2d:%.2d', [allSeconds div 60, allSeconds mod 60]);
end;

function TTools.GetCurrentTimeStr():String;
var
  today : TDateTime;
begin
  today := Now;
  Result:=FormatDateTime('dd.mm.yyyy hh:nn:ss', today);
end;

function TTools.GetNameModeTest(modeTest: TMode):String;
begin
  case modeTest of
    ClassWork: begin Result:='Классная работа'; Exit; end;
    SelfWork: begin Result:='Самостоятельная работа'; Exit; end;
    Diagnostic: begin Result:='Диагностика'; Exit; end;
  end;

  Result:=EmptyStr;
end;
//
//function TTools.GetSizeTask(sizeTaskStr:String):TSizeTask;
//var
//  rows:String;
//  columns:String;
//  allSize:Integer;
//
//  resSizeTask:TSizeTask;
//begin
//  if(sizeTaskStr = EmptyStr)then raise Exception.Create('Ошибка. Размер задания задан неверно!');
//
//  rows:=COPY(sizeTaskStr, 0, POS('x', sizeTaskStr)-1);
//  columns:=COPY(sizeTaskStr,POS('x', sizeTaskStr)+1,LENGTH(sizeTaskStr));
//  allSize:=StrToInt(rows)*StrToInt(columns);
//
//  resSizeTask.Columns:=StrToInt(columns);
//  resSizeTask.Rows:=StrToInt(rows);
//  resSizeTask.DecartSize:=allSize;
//  resSizeTask.SizeStr:=sizeTaskStr;
//
//  Result:=resSizeTask;
//end;

function TTools.StringToHash(s:string):string;
var
  MD5: TIdHashMessageDigest5;
  hash:string;
begin
  MD5 := TIdHashMessageDigest5.Create;
  hash := MD5.HashStringAsHex(s);
  MD5.Free;

  Result:=hash;
end;

end.
