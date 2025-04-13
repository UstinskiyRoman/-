unit UTaskResources;

interface

uses
  Generics.Collections, System.Classes, System.NetEncoding, System.SysUtils;

type
  TTaskResources = class
  public
    TableVideoSolution: TBytesStream;
    AudioCondition: TBytesStream;

    // need for creating and updating of the task
//    RawXmlImageRows: string;
//    RawXmlImageCols: string;

    //xmlImagesForRows: string; xmlImagesForColumns: string;
    constructor Create(audioConditionBytes: TBytes; tableVideoSolutionBytes: TBytes);
    destructor Destroy; override;
end;

implementation

  //xmlImagesForRows: string; xmlImagesForColumns: string;
constructor TTaskResources.Create(audioConditionBytes: TBytes; tableVideoSolutionBytes: TBytes);
begin
//  Self.RawXmlImageRows := xmlImagesForRows;
//  Self.RawXmlImageCols := xmlImagesForColumns;

  if (audioConditionBytes <> nil) and (Length(audioConditionBytes) > 0) then
  begin
    Self.AudioCondition := TBytesStream.Create(audioConditionBytes);
  end;
  if (tableVideoSolutionBytes <> nil) and (Length(tableVideoSolutionBytes) > 0) then
  begin
    Self.TableVideoSolution := TBytesStream.Create(tableVideoSolutionBytes);
  end;
end;

destructor TTaskResources.Destroy;
begin
  inherited;

  FreeAndNil(Self.AudioCondition);
  FreeAndNil(Self.TableVideoSolution);
end;

end.
