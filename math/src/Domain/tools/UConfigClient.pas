unit UConfigClient;

interface

uses System.SysUtils, System.Classes, Generics.Collections, UConfigBase;

type
  TAccessToFiles=class(TConfigBase)
    private
//      CONST
//        ResNameZoomerPlus = 'zoom_plus_small';
//        ResNameZoomerMinus = 'zoom_minus_small';

      procedure InitPaths(); override;
//      function GetFullPathWithoutCheck(index: integer):string;
    public
{$IfDeF RELEASE}
      CONST
      ResNameSoundWin = 'data\temp\sound_win.wav';
      ResNameSoundInvalid = 'data\temp\invalid_answer.wav';
{$EndIf}
{$IfDeF DEBUG}
      CONST
      ResNameSoundWin = '..\..\..\..\data\temp\sound_win.wav';
      ResNameSoundInvalid = '..\..\..\..\data\temp\invalid_answer.wav';
{$EndIf}
//        ResNameSoundWin = 'SoundWin';
//        ResNameSoundInvalid = '..\..\..\..\data\temp\SoundInvalid.wav';
//        ResNamePenCursor = 'Pen';

      property PathDataBase: string Index 0 read GetFullPath;
//      property PathManual: string Index 1 read GetFullPath;
//      property PathJSForTester: string Index 2 read GetFullPath;
      property PathToTempFolder: string Index 1 read GetFullPath;
      property PathToResourceDataBase: string Index 2 read GetFullPath;
      property PathToSQLiteLib: string Index 3 read GetFullPath;
      property PathToEmptySound: string Index 4 read GetFullPath;
//      property PathToSavedAudio: string Index 5 read GetFullPathWithoutCheck;
end;

var
  Config:TAccessToFiles;

implementation

procedure TAccessToFiles.InitPaths();
{$IfDeF RELEASE}
CONST PathToDataBase = 'data\LogicDB.mdb';
//      PathToManual = 'data\manual.docx';
//      PathToJS_For_Tester = 'data\js-css-files\common_js.js';
      PathToTempFolder = 'data\temp\';
      PathToResourceDataBase = 'data\LogicDBResources.db';
      PathToSQLiteLib = 'data\external-libs\sqlite3.dll';
      PathToEmptySound = 'data\temp\EmptyWav.wav';
//      PathToSavedAudio = 'data\temp\audio.wav';
{$EndIf}
{$IfDeF DEBUG}
CONST PathToDataBase = '..\..\..\..\data\LogicDB.mdb';
//      PathToManual = '..\..\..\..\data\manual.docx';
//      PathToJS_For_Tester = '..\..\..\..\data\js-css-files\common_js.js';
      PathToTempFolder = '..\..\..\..\data\temp\';
      PathToResourceDataBase = '..\..\..\..\data\LogicDBResources.db';
      PathToSQLiteLib = '..\..\..\..\data\external-libs\sqlite3.dll';
      PathToEmptySound = '..\..\..\..\data\temp\EmptyWav.wav';
//      PathToSavedAudio = '..\..\..\..\data\temp\audio.wav';
{$EndIf}
begin
  CreateTempDirectory(PathToTempFolder);

  Paths := TList<string>.Create;
  Paths.Add(GetPath(PathToDataBase));
//  Paths.Add(GetPath(PathToManual));
//  Paths.Add(GetPath(PathToJS_For_Tester));
  Paths.Add(GetPath(PathToTempFolder));
  Paths.Add(GetPath(PathToResourceDataBase));
  Paths.Add(GetPath(PathToSQLiteLib));
  Paths.Add(GetPath(PathToEmptySound));
//	Paths.Add(GetPathWithoutCheck(PathToSavedAudio));

//  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameZoomerPlus, 'png');
//  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameZoomerMinus, 'png');
//  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNamePenCursor, 'ico');
end;

//function TAccessToFiles.GetFullPathWithoutCheck(index: integer):string;
//begin
//  Result := Paths[index];
//end;


end.
