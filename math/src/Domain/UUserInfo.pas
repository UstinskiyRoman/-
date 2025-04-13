unit UUserInfo;

interface

uses System.SysUtils, UTypeUser, UClassGroupInfo;

type
  TUserInfo = class
    ID:Integer;
    FirstName:String;
    SecondName:String;
    Birthday:TDateTime;
    ClassGroup:TClassGroup;
    Password:String;
    TypeUser:TTypeUser;

    public
      constructor Create(id:Integer; firstName:string; secondName:String; classId:Integer;
            nameClass:String; password: String; typeUser: Integer; birthday: TDateTime = 0);

      function ToString(showBirthday: boolean = false): string; virtual;
end;

implementation

constructor TUserInfo.Create(id:Integer; firstName:string; secondName:String; classId:Integer;
            nameClass:String; password: String; typeUser: Integer; birthday: TDateTime = 0);
begin
  Self.ID:=id;
  Self.FirstName:=firstName;
  Self.SecondName:=secondName;
  Self.Birthday:=birthday;

  Self.Password:=password;

  Self.TypeUser:=TTypeUser(typeUser);

  Self.ClassGroup.ID:=classId;
  Self.ClassGroup.Name:=nameClass;
end;

function TUserInfo.ToString(showBirthday: boolean = false): string;
var
  resultStrInfo: String;
begin
  resultStrInfo:=Format('%s %s, %s', [Self.SecondName, Self.FirstName, Self.ClassGroup.Name]);

  if(showBirthday)then
  begin
    if(Self.Birthday = 0)then
      Result:=resultStrInfo
    else
      Result:=Format('%s %s, %s, Дата рождения: %s', [Self.SecondName, Self.FirstName, Self.ClassGroup.Name, DateToStr(Self.Birthday)]);
  end else
    Result:=resultStrInfo;
end;

end.
