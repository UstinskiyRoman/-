unit UDataModuleSQLiteBase;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, Generics.Collections,
  UTaskResourceType,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Comp.UI;

type
  TDataModuleSQLiteBase = class(TDataModule)
    FDConnectionBase: TFDConnection;
    FDQueryBase: TFDQuery;
    FDPhysSQLiteDriverLinkBase: TFDPhysSQLiteDriverLink;
    FDSQLiteValidateBase: TFDSQLiteValidate;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDSQLiteSecurity1: TFDSQLiteSecurity;
  private
    CONST DRIVER_ID = 'SQLite3';
    CONST ENCRYPT_TYPE = 'aes-256';
    CONST PASSWORD_TO_DB = '';

    procedure Sweep(pathToDatabase: string);
  public
    HasErrors: boolean;

    procedure Init(pathToDatabase: string; pathToLib: string);
    function GetSQLiteVersion(): string;
    // imageBase64Rows: string; imageBase64Columns: string;
    procedure Insert(id: string; audioCondition: TStream; tableSolutionVideo: TStream; schemeSolutionVideo: TStream);
                                // imageBase64Rows: string; imageBase64Columns: string;
    procedure Update(id: string; audioCondition: TStream; tableSolutionVideo: TStream; schemeSolutionVideo: TStream);
    function GetAudioCondition(resourceId: string): TBytes;
    function GetImagesByRowsAndColumns(resourceId: string): TDictionary<string, string>;
    function GetTableVideoSolution(resourceId: string):TBytes;
    function HasResourcesInDataBase(resourceId: string): Boolean;
    function HasResourceInDataBase(resourceId: string; resourceType: TaskResourceType): Boolean;
  end;

var
  DataModuleSQLiteBase: TDataModuleSQLiteBase;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModuleSQLiteBase.Init(pathToDatabase: string; pathToLib: string);
begin
  try
    FDPhysSQLiteDriverLinkBase.DriverID := DRIVER_ID;
    // TODO since delphi 10.4, during encrypt/decrypt the DB FireDac will be throw exception, when use dynamic link to sqlite dll
    //FDPhysSQLiteDriverLinkBase.VendorLib := pathToLib;

//    FDSQLiteSecurity1.Database := pathToDatabase;
//    FDSQLiteSecurity1.Password := ENCRYPT_TYPE + ':' + PASSWORD_TO_DB;

    // Use TFDSQLiteSecurity.CheckEncryption to request database encryption status:
    // <unencrypted> - database is unencrypted.
    // <encrypted> - database is encrypted, but the algorythm / password is wrong.
    // encryption algorythm name - database is encrypted, and the algorythm / password are correct.
//    var encryption := FDSQLiteSecurity1.CheckEncryption;
//    if (encryption = 'unencrypted') then
//    begin
//      raise Exception.Create('База данных не имеет шифрования');
//    end;
//    if (encryption = 'encrypted') then
//    begin
//      raise Exception.Create('Неверный пароль');
//    end;

    FDSQLiteValidateBase.Database := pathToDatabase;

    FDConnectionBase.Params.Clear;
    FDConnectionBase.DriverName := DRIVER_ID;
    FDConnectionBase.Params.Database := pathToDatabase;
//    FDConnectionBase.Params.Values['Encrypt'] := ENCRYPT_TYPE;
//    FDConnectionBase.Params.Password :=PASSWORD_TO_DB;
    FDConnectionBase.Params.Add('OpenMode=CreateUTF16');
    FDConnectionBase.Params.Add('GUIDFormat=String');
    FDConnectionBase.Params.Add('LockingMode=Normal');
    FDConnectionBase.Connected := True;
    FDConnectionBase.Open;
  except on E : Exception do
    begin
      HasErrors := true;
      raise Exception.Create(Format('Ошибка. Нет соединения с Базой Данных ресурсов. %s', [E.Message]));
    end;
  end;
end;

procedure TDataModuleSQLiteBase.Sweep(pathToDatabase: string);
begin
  try
    FDSQLiteValidateBase.Sweep;
  except
    raise Exception.Create(Format('Ошибка при оптимизации БД ресурсов "%s"', [pathToDatabase]));
  end;
end;

function TDataModuleSQLiteBase.GetSQLiteVersion(): string;
begin
  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'select sqlite_version();';
    Open;
    Result := Fields[0].AsString;
  end;
end;
                                                  // imageBase64Rows: string; imageBase64Columns: string;
procedure TDataModuleSQLiteBase.Insert(id: string; audioCondition: TStream; tableSolutionVideo: TStream; schemeSolutionVideo: TStream);
begin
  if (//(imageBase64Rows = EmptyStr) and
      //(imageBase64Columns = EmptyStr) and
      (audioCondition = nil) and
      (tableSolutionVideo = nil) and
      (schemeSolutionVideo = nil) or
      (id = EmptyStr) or
      (id = TGuid.Empty.ToString)) then
  begin
    raise Exception.Create('Ошибка при записи в БД ресурсов. Не указаны данные для вставки.');
  end;

  try
    with FDQueryBase do
    begin
      var queryNameColumns := TList<string>.Create;
      var queryValueColumns := TList<string>.Create;

//      if (imageBase64Rows <> EmptyStr) then
//      begin
//        queryNameColumns.Add('ImageBase64Rows');
//        queryValueColumns.Add(':imgRows');
//      end;
//      if (imageBase64Columns <> EmptyStr) then
//      begin
//        queryNameColumns.Add('ImageBase64Columns');
//        queryValueColumns.Add(':imgCols');
//      end;
      if (audioCondition <> nil) then
      begin
        queryNameColumns.Add('AudioCondition');
        queryValueColumns.Add(':audioCond');
      end;
      if (tableSolutionVideo <> nil) then
      begin
        queryNameColumns.Add('TableSolutionVideo');
        queryValueColumns.Add(':tableSolVideo');
      end;
      if (schemeSolutionVideo <> nil) then
      begin
        queryNameColumns.Add('SchemeSolutionVideo');
        queryValueColumns.Add(':schemeSolVideo');
      end;

      Close;
      SQL.Clear;
      SQL.Add(Format('INSERT INTO TaskResources (ID, %s)VALUES(:id, %s)', [String.Join(',', queryNameColumns.ToArray), String.Join(',', queryValueColumns.ToArray)]));
      ParamByName('id').Value := id;
//      if (imageBase64Rows <> EmptyStr) then ParamByName('imgRows').Value := imageBase64Rows;
//      if (imageBase64Columns <> EmptyStr) then ParamByName('imgCols').Value := imageBase64Columns;
      if (audioCondition <> nil) then ParamByName('audioCond').LoadFromStream(audioCondition, ftBlob);
      if (tableSolutionVideo <> nil) then ParamByName('tableSolVideo').LoadFromStream(tableSolutionVideo, ftBlob);
      if (schemeSolutionVideo <> nil) then ParamByName('schemeSolVideo').LoadFromStream(schemeSolutionVideo, ftBlob);
      ExecSQL;
    end;
  except on E : Exception do
    begin
      raise Exception.Create(Format('Ошибка при записи в БД ресурсов. %s', [E.Message]));
    end;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;
                                                   //imageBase64Rows: string; imageBase64Columns: string;
procedure TDataModuleSQLiteBase.Update(id: string; audioCondition: TStream; tableSolutionVideo: TStream; schemeSolutionVideo: TStream);
begin
  if (//(imageBase64Rows = EmptyStr) and
      //(imageBase64Columns = EmptyStr) and
      (audioCondition = nil) and
      (tableSolutionVideo = nil) and
      (schemeSolutionVideo = nil) or
      (id = EmptyStr) or
      (id = TGuid.Empty.ToString)) then
  begin
    raise Exception.Create('Ошибка при обновлении строки в БД ресурсов. Не указаны данные для обновления.');
  end;

  try
    with FDQueryBase do
    begin
      var query := TList<string>.Create;
//      if (imageBase64Rows <> EmptyStr) then
//      begin
//        query.Add('ImageBase64Rows=:imgRows');
//      end;
//      if (imageBase64Columns <> EmptyStr) then
//      begin
//        query.Add('ImageBase64Columns=:imgCols');
//      end;
      if (audioCondition <> nil) then
      begin
        query.Add('AudioCondition=:audioCond');
      end;
      if (tableSolutionVideo <> nil) then
      begin
        query.Add('TableSolutionVideo=:tableSolVideo');
      end;
      if (schemeSolutionVideo <> nil) then
      begin
        query.Add('SchemeSolutionVideo=:schemeSolVideo');
      end;

      Close;
      SQL.Clear;
      SQL.Add(Format('UPDATE TaskResources SET %s WHERE ID=:id', [String.Join(',', query.ToArray)]));
      ParamByName('id').Value := id;
//      if (imageBase64Rows <> EmptyStr) then ParamByName('imgRows').Value := imageBase64Rows;
//      if (imageBase64Columns <> EmptyStr) then ParamByName('imgCols').Value := imageBase64Columns;
      if (audioCondition <> nil) then ParamByName('audioCond').LoadFromStream(audioCondition, ftBlob);
      if (tableSolutionVideo <> nil) then ParamByName('tableSolVideo').LoadFromStream(tableSolutionVideo, ftBlob);
      if (schemeSolutionVideo <> nil) then ParamByName('schemeSolVideo').LoadFromStream(schemeSolutionVideo, ftBlob);
      ExecSQL;
    end;
  except on E : Exception do
    begin
      raise Exception.Create(Format('Ошибка при обновлении строки в БД ресурсов. %s', [E.Message]));
    end;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

function TDataModuleSQLiteBase.GetTableVideoSolution(resourceId: string):TBytes;
var
  stream: TFDBlobStream;
begin
  if (resourceId = EmptyStr) then
  begin
    Result := nil;
    Exit;
  end;

  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT TableSolutionVideo FROM TaskResources WHERE ID=:id';
    ParamByName('id').Value := resourceId;
    Open;

    try
      stream := TFDBlobStream.Create(TBlobField(FieldByName('TableSolutionVideo')), bmRead);
      SetLength(Result, stream.Size);
      stream.ReadBuffer(Result[0], stream.Size);
    finally
      FreeAndNil(stream);
    end;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

function TDataModuleSQLiteBase.GetImagesByRowsAndColumns(resourceId: string): TDictionary<string, string>;
begin
  if (resourceId = EmptyStr) then
  begin
    Result := nil;
    Exit;
  end;

  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT ImageBase64Rows, ImageBase64Columns FROM TaskResources WHERE ID=:id';
    ParamByName('id').Value := resourceId;
    Open;

    if (Fields[0].asString = EmptyStr) or (Fields[1].asString = EmptyStr) then
    begin
      Result := nil;
      Exit;
    end;

    Result := TDictionary<string, string>.Create(2);
    Result.Add('Rows', Fields[0].asString);
    Result.Add('Columns', Fields[1].asString);
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

function TDataModuleSQLiteBase.GetAudioCondition(resourceId: string): TBytes;
var
  stream: TFDBlobStream;
begin
  if (resourceId = EmptyStr) then
  begin
    Result := nil;
    Exit;
  end;

  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT AudioCondition FROM TaskResources WHERE ID=:id';
    ParamByName('id').Value := resourceId;
    Open;

    try
      stream := TFDBlobStream.Create(TBlobField(FieldByName('AudioCondition')), bmRead);
      SetLength(Result, stream.Size);
      if (stream.Size > 0) then stream.ReadBuffer(Result[0], stream.Size);
    finally
      FreeAndNil(stream);
    end;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

function TDataModuleSQLiteBase.HasResourcesInDataBase(resourceId: string): Boolean;
begin
  if (resourceId = EmptyStr) then
  begin
    Exit;
  end;

  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := 'SELECT ID FROM TaskResources WHERE ID=:id';
    ParamByName('id').Value := resourceId;
    Open;

    Result := Fields[0].AsString = resourceId;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

function TDataModuleSQLiteBase.HasResourceInDataBase(resourceId: string; resourceType: TaskResourceType): Boolean;
begin
  if (resourceId = EmptyStr) then
  begin
    Exit;
  end;

  var sqlQuery := IfThen(resourceType = TaskResourceType.ImagesForTaskBody, 'ImageBase64Rows IS NOT NULL AND ImageBase64Columns IS NOT NULL',
                  IfThen(resourceType = TaskResourceType.AudioCondition, 'TYPEOF(AudioCondition) != "null"',
                  IfThen(resourceType = TaskResourceType.TableVideoSolution, 'TYPEOF(TableSolutionVideo) != "null"',
                  IfThen(resourceType = TaskResourceType.SchemeVideoSolution, 'TYPEOF(SchemeSolutionVideo) != "null"', 'ID=:id'))));

  with FDQueryBase do
  begin
    Close;
    SQL.Clear;
    SQL.Text := Format('SELECT ID FROM TaskResources WHERE ID=:id AND %s', [sqlQuery]);
    ParamByName('id').Value := resourceId;
    Open;

    Result := Fields[0].AsString = resourceId;
  end;

  FDQueryBase.Close;
  FDQueryBase.Active := false;
end;

end.
