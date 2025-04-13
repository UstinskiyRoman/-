unit UConfigEditor;

interface

uses System.SysUtils, System.Classes, Generics.Collections, WinApi.Windows, UConfigBase;

type
  TConfiguration = class(TConfigBase)
    private
      CONST
        ResNameZoomerPlus = 'zoom_plus_small';
        ResNameZoomerMinus = 'zoom_minus_small';
        ResNameEmptySound = 'EmptyWav';

      procedure InitPaths(); override;
      function GetFullPathWithoutCheck(index: integer):string;
    public
      CONST
        ResNameMetaInfoTemplate = 'MetaInfoTemplate';
        ResNameDefaultImage = 'DefaultImage';
        ResNameTemplateHtmlTask = 'TemplateHtmlTask';
        ResNameTemplateHtmlBody = 'TemplateHtmlBodyTask';
        ResNameTemplateHtmlCondition = 'TemplateHtmlCondition';
        ResNamePenCursor = 'Pen';

      property PathDataBase: string Index 0 read GetFullPath;
      property PathToTempFolder: string Index 1 read GetFullPath;
      property PathToEmptySound: string Index 2 read GetFullPath;
      property PathToSavedAudio: string Index 3 read GetFullPathWithoutCheck;
      property PathToResourceDataBase: string Index 4 read GetFullPath;
      property PathToSQLiteLib: string Index 5 read GetFullPath;
  end;

var
  BConfig: TConfiguration;

implementation

procedure TConfiguration.InitPaths();
{$IfDeF RELEASE}
CONST PathToDataBase = 'data\LogicDB.mdb';
      PathToTempFolder = 'data\temp\';
      PathToEmptySound = 'data\temp\EmptyWav.wav';
      PathToSavedAudio = 'data\temp\audio.wav';
      PathToResourceDataBase = 'data\LogicDBResources.db';
      PathToSQLiteLib = 'data\external-libs\sqlite3.dll';
{$EndIf}
{$IfDeF DEBUG}
CONST PathToDataBase = '..\..\..\..\data\LogicDB.mdb';
      PathToTempFolder = '..\..\..\..\data\temp\';
      PathToEmptySound = '..\..\..\..\data\temp\EmptyWav.wav';
      PathToSavedAudio = '..\..\..\..\data\temp\audio.wav';
      PathToResourceDataBase = '..\..\..\..\data\LogicDBResources.db';
      PathToSQLiteLib = '..\..\..\..\data\external-libs\sqlite3.dll';
{$EndIf}
begin
  CreateTempDirectory(PathToTempFolder);

  Paths := TList<string>.Create;

  Paths.Add(GetPath(PathToDataBase));
  Paths.Add(GetPath(PathToTempFolder));

  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameZoomerPlus, 'png');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameZoomerMinus, 'png');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameMetaInfoTemplate, 'xml');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameTemplateHtmlBody, 'txt');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameTemplateHtmlCondition, 'txt');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameDefaultImage, 'bmp');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNameEmptySound, 'wav');
  SaveFilesFromResourse(GetPath(PathToTempFolder), ResNamePenCursor, 'ico');

  Paths.Add(GetPath(PathToEmptySound));
	Paths.Add(GetPathWithoutCheck(PathToSavedAudio));
	Paths.Add(GetPath(PathToResourceDataBase));
	Paths.Add(GetPath(PathToSQLiteLib));
end;

function TConfiguration.GetFullPathWithoutCheck(index: integer):string;
begin
  Result := Paths[index];
end;

end.
