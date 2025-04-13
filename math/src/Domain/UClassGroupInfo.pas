unit UClassGroupInfo;

interface

uses System.SysUtils;

type
  TClassGroup = record
    private
      function GetNumberClass():Integer;
    public
      ID:Integer;
      Name:String;
     property NumberClass: Integer read GetNumberClass;
end;

implementation

function TClassGroup.GetNumberClass():Integer;
var
  i:Integer;
  numberStr: String;
begin
  for i := 1 to Length(Self.Name) do
  begin
    if(Self.Name[i] in ['0'..'9'])then numberStr:=numberStr+Self.Name[i];
  end;

  if(numberStr = EmptyStr)then Result:=0;

  Result:=StrToInt(numberStr);
end;

end.
