unit UTaskResourcesManager;

interface

uses
  Generics.Collections, System.Classes, System.NetEncoding,
//  UXMLLoader, Xml.XMLIntf,
  System.SysUtils, UDataModuleSQLiteBase,
  UTaskResourceType, UTaskResources,
  WinApi.MMSystem, System.IOUtils, WinApi.ShellApi, WinApi.Windows;
  {for supporting different images format}
//  Vcl.Imaging.Jpeg, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg, Vcl.Graphics;


// возможно стоит передать UTaskResources
type
  TTaskResourcesManager = class
    private
      resourcesInMemory: TTaskResources;
      resourceId: string;
    public
      HasAudioCondition: boolean;
      HasTableVideoSolution: boolean;

      constructor CreateBySavedResources(resourceId: string);
      constructor CreateByInMemoryResources(resources: TTaskResources);
      destructor Destroy; override;

      procedure PlayAudioCondition();
      procedure PlayTableVideoSolution(pathToTempFolder: string; handle: HWND);
      function GetAudioCondition(): TBytes;
      function GetTableVideoSolution(): TBytes;
end;

implementation

constructor TTaskResourcesManager.CreateBySavedResources(resourceId: string);
begin
  if (resourceId = EmptyStr) then raise Exception.Create('The resource id of task is empty');

  Self.resourceId := resourceId;


  Self.HasAudioCondition := DataModuleSQLiteBase.HasResourceInDataBase(Self.resourceId, TaskResourceType.AudioCondition);
  Self.HasTableVideoSolution := DataModuleSQLiteBase.HasResourceInDataBase(Self.resourceId, TaskResourceType.TableVideoSolution);
end;

constructor TTaskResourcesManager.CreateByInMemoryResources(resources: TTaskResources);
begin
  if (resources = nil) then raise Exception.Create('The resources is empty');

  Self.resourcesInMemory := resources;

  Self.HasAudioCondition := (Self.resourcesInMemory.AudioCondition <> nil) and (Self.resourcesInMemory.AudioCondition.Size > 0);
  Self.HasTableVideoSolution := (Self.resourcesInMemory.TableVideoSolution <> nil) and (Self.resourcesInMemory.TableVideoSolution.Size > 0);
end;

destructor TTaskResourcesManager.Destroy;
begin
  inherited;
  FreeAndNil(Self.resourcesInMemory);
end;

procedure TTaskResourcesManager.PlayTableVideoSolution(pathToTempFolder: string; handle: HWND);
var
  video: TBytesStream;
begin
  try
    if (Self.resourceId <> EmptyStr) then
    begin
      video := TBytesStream.Create(DataModuleSQLiteBase.GetTableVideoSolution(Self.resourceId));
    end else
    begin
      video := TBytesStream.Create();
      video.CopyFrom(Self.resourcesInMemory.TableVideoSolution);
      video.Position := 0;
    end;

    var fullFileName := TPath.Combine(pathToTempFolder, 'video.mp4');
    video.SaveToFile(fullFileName);
    ShellExecute(handle, 'open', pwchar(fullFileName), nil, nil, SW_SHOWNORMAL);
  finally
    FreeAndNil(video);
  end;
end;


procedure TTaskResourcesManager.PlayAudioCondition();
begin
  if (self.resourceId <> EmptyStr) then
  begin
    try
      var audio := TBytesStream.Create(DataModuleSQLiteBase.GetAudioCondition(Self.resourceId));
      SndPlaySound(audio.Memory, (SND_ASYNC or SND_MEMORY));
    except on E : Exception do
      begin
        raise Exception.Create('Ошибка при воспроизведении аудио. '+E.Message);
      end;
    end;
  end else
  begin
    try
      SndPlaySound(Self.resourcesInMemory.AudioCondition.Memory, (SND_ASYNC or SND_MEMORY));
    except on E : Exception do
      begin
        raise Exception.Create('Ошибка при воспроизведении аудио. '+E.Message);
      end;
    end;
  end;
end;

function TTaskResourcesManager.GetAudioCondition(): TBytes;
begin
  if (self.resourceId <> EmptyStr) then
  begin
    Result := DataModuleSQLiteBase.GetAudioCondition(Self.resourceId);
    Exit;
  end else
  begin
    Result := Self.resourcesInMemory.AudioCondition.Bytes;
  end;
end;

function TTaskResourcesManager.GetTableVideoSolution(): TBytes;
begin
  if (self.resourceId <> EmptyStr) then
  begin
    Result := DataModuleSQLiteBase.GetTableVideoSolution(Self.resourceId);
    Exit;
  end else
  begin
    Result := Self.resourcesInMemory.TableVideoSolution.Bytes;
  end;
end;


end.
