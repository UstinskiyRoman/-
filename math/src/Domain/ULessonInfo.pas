unit ULessonInfo;

interface

uses
  Generics.Collections, System.SysUtils, UTaskInfo;

type
  TLesson = class
    ID: integer;
    Name: string;
    Description: string;
    CourseID: Integer;
    Tasks: TObjectList<TTask>;
    OrderNumber: integer;
    cl_num: Integer;
    theory: string;
    public
      constructor Create(id:Integer; name:String; description: string; courseId:Integer; orderNumber: integer; cl_num: Integer; theory: string);
      destructor Destroy; override;
end;

implementation

constructor TLesson.Create(id:Integer; name:String; description: string; courseId:Integer; orderNumber: integer; cl_num: Integer; theory: string);
begin
  Self.ID := id;
  Self.Name := name;
  Self.Description := description;
  Self.CourseID := courseId;
  Self.Tasks := TObjectList<TTask>.Create;
  Self.OrderNumber := orderNumber;
  Self.cl_num := cl_num;
  Self.theory := theory;
end;

destructor TLesson.Destroy;
begin
  inherited;

  FreeAndNil(Self.Tasks);
end;

end.
