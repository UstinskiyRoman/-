unit UConfigBase;

interface

uses System.SysUtils, System.Classes, Generics.Collections, WinApi.Windows, System.IOUtils;

type
  TConfigBase = class
    public
      Paths: TList<string>;

      constructor Create(); overload;

      procedure InitPaths(); virtual; abstract;

      procedure ChechExistsFile(pathToFile: string);
      procedure SaveFilesFromResourse(pathToSave: string; resourceName: string; fileExtension: string);
      procedure CreateTempDirectory(pathToTempFolder: string);
      function GetFullPath(index: integer): string;
      function GetPath(pathToFile: string): string;
      function GetPathWithoutCheck(pathToFile: string): string;
end;

implementation

constructor TConfigBase.Create();
begin
  InitPaths();
  inherited;
end;

procedure TConfigBase.ChechExistsFile(pathToFile: string);
begin
  if((ExtractFilePath(pathToFile) = pathToFile) and (not DirectoryExists(pathToFile))) or ((ExtractFilePath(pathToFile) <> pathToFile) and (not FileExists(pathToFile)))then
    raise Exception.Create(Format('Ошибка. Не найден путь до: %s', [pathToFile]));
end;

function TConfigBase.GetPathWithoutCheck(pathToFile: string): string;
begin
  Result := TPath.Combine(ExtractFilePath(ParamStr(0)), pathToFile);
end;

function TConfigBase.GetPath(pathToFile: string):string;
var
  shortPath: string;
  fullPath:String;
begin
  fullPath := TPath.Combine(ExtractFilePath(ParamStr(0)), pathToFile);
  shortPath := ExtractShortPathName(fullPath);

  if(shortPath = EmptyStr)then
    ChechExistsFile(fullPath)
  else
    ChechExistsFile(shortPath);

  Result := shortPath;
end;

function TConfigBase.GetFullPath(index: integer):string;
var
  path: String;
begin
  path := Paths[index];
  ChechExistsFile(path);

  Result:=path;
end;

procedure TConfigBase.SaveFilesFromResourse(pathToSave: string; resourceName: string; fileExtension: string);
var
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(hInstance, resourceName, RT_RCDATA);
  try
    ResStream.SaveToFile(TPath.Combine(pathToSave, resourceName) +'.'+ fileExtension);
  finally
    ResStream.Free;
  end;
end;

procedure TConfigBase.CreateTempDirectory(pathToTempFolder: string);
var
  fullPath: string;
begin
  if (pathToTempFolder = EmptyStr) then raise Exception.Create('Path to temp folder is empty');

  fullPath := TPath.Combine(ExtractFilePath(ParamStr(0)), pathToTempFolder);
  CreateDir(fullPath);
end;

end.
