unit UCourse;

interface

uses
  Generics.Collections, ULessonInfo, Vcl.Dialogs, System.SysUtils; //UDifficulty,

type
  TCourse = class
    ID: integer;
    Name: string;
    Description: string;
    Difficulty: Integer; //TDifficulty;
    Lessons: TObjectList<TLesson>;

    public                                                                      //TDifficulty
      constructor Create(id:Integer; name:String; description:String; difficulty:Integer);
      destructor Destroy; override;

      function CountTasks():Integer;
end;

implementation

constructor TCourse.Create(id:Integer; name:String; description:String; difficulty:Integer);
begin
  Self.ID:=id;
  Self.Name:=name;
  Self.Description:=description;
  Self.Difficulty:=difficulty;

  Self.Lessons:=TObjectList<TLesson>.Create;
end;

destructor TCourse.Destroy;
begin
  inherited;

  Self.Lessons.Free;
end;

function TCourse.CountTasks():Integer;
var
  i: Integer;
  count:Integer;
begin
  if(Self.Lessons = nil)then ShowMessage(Format('Ошибка. Уроки для %s не загрузились', [Self.Name]));

  count:=0;

  for i := 0 to Self.Lessons.Count - 1 do
    count:=count + Self.Lessons[i].Tasks.Count;

  Result:=count;
end;

end.
