unit UUserRating;

interface

uses UUserInfo, UDifficulty, UStatisticInfo, Generics.Collections;

type
  TRaiting = record
    NormalDifficultyForUser: TDifficulty;
    CurrentLevelDifficulty: TDifficulty;
    Comment: string;
    OldSpentTime: string;
    NowSpentTime: string;
    IsRecord: boolean;
    OldEffect: real;
    NowEffect: real;
end;

type
  TUserRating = class(TUserInfo)
    function GetRaiting(currentLevel:TDifficulty) : TRaiting;
end;

implementation

function TUserRating.GetRaiting(currentLevel:TDifficulty) : TRaiting;
var
  stats: TObjectList<TStatDiagnostic>;
begin
{  stats:=MainDM.GetStatDiagnosticByUserId(Self.ID);
  if(stats = nil)or(stats.Count = 0)then
  begin
    Result.CurrentLevelDifficulty:=currentLevel;

  end;}

end;

end.
