unit UResourceImage;

interface

type
  TResourceImage = class
    Id: integer;
    Name: string;
    Base64Content: string;
  public
    constructor Create(id:integer; name:string; base64Content:string);
end;

type
  TImagesTask = class
    ImagesRow: TArray<TResourceImage>;
    ImagesCol: TArray<TResourceImage>;

  public
    constructor Create(countImgCol: integer; countImgRow: integer);
    destructor Destroy; override;
end;

implementation

constructor TResourceImage.Create(id:integer; name:string; base64Content:string);
begin
  Self.Id := id;
  Self.Name := name;
  Self.Base64Content := base64Content;
end;

constructor TImagesTask.Create(countImgCol: integer; countImgRow: integer);
begin
  // TODO check this is!!!
//  Self.ImagesRow := TArray<TResourceImage>.Create();
//  Self.ImagesCol := TArray<TResourceImage>.Create();

  SetLength(Self.ImagesRow, countImgRow);
  SetLength(Self.ImagesCol, countImgCol);
end;

destructor TImagesTask.Destroy;
begin
  inherited;

  SetLength(Self.ImagesRow, 0);
  SetLength(Self.ImagesCol, 0);
end;

end.
