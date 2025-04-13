unit UTaskInfo;

interface

uses
  WinApi.Windows, System.SysUtils, Generics.Collections, //UTaskMetaInfo,
  System.Classes, UModes, UTypeTasks, System.IOUtils;

//type
//  THtmlTask = record
//    PathToHtmlTask: String;
//    ContentHtmlTask: String;
//  end;

type
  TTask = class
    ID: Integer;
    TaskBody: String;
    ConditionBody: String;
    MetaInfo: String; //TTaskMetaInfo;
    TypeTask: TTypeTask;
    LessonID: Integer;
    ModeType: TMode;
    ResourceId: String;

//  strict private
//    htmlTemplate: String;

  CONST
//    NAME_TEMP_TASK_HTML = 'task.html';
    NO_META_INFO_FOR_PREVIEW = 'NO_META_INFO_FOR_PREVIEW';
  public
    class function CreateForPreview(taskBodyHtml: String; conditionBodyHtml: String; ResourceId: String = ''):TTask; static;
    constructor Create(ID: Integer; taskBodyHtml: String; conditionBodyHtml: String; TypeTask: TTypeTask; LessonID: Integer; mode: TMode; rawMetaInfo: String; ResourceId: String = ''; isKeepRawInfo: Boolean = false);
    destructor Destroy; override;

//    function SaveHtmlTaskToFile(withCondition: Boolean; pathToTempFolder: string; resourceNameTemplateTask: string): THtmlTask;
  end;

implementation

class function TTask.CreateForPreview(taskBodyHtml: String; conditionBodyHtml: String; ResourceId: String = ''):TTask;
begin
  Result := TTask.Create(0, taskBodyHtml, conditionBodyHtml, TTypeTask.Table, 0, TMode.ClassWork, NO_META_INFO_FOR_PREVIEW, ResourceId);
end;

constructor TTask.Create(ID: Integer; taskBodyHtml: String; conditionBodyHtml: String; TypeTask: TTypeTask; LessonID: Integer; mode: TMode; rawMetaInfo: String; ResourceId: String = ''; isKeepRawInfo: Boolean = false);
begin
  Self.ID := ID;
  Self.TaskBody := taskBodyHtml;
  Self.ConditionBody := conditionBodyHtml;
  Self.TypeTask := TypeTask;
  Self.LessonID := LessonID;
  Self.ModeType := mode;
  Self.ResourceId := ResourceId;
  if (rawMetaInfo <> EmptyStr) and (rawMetaInfo <> NO_META_INFO_FOR_PREVIEW) then
  begin
//    Self.MetaInfo := TTaskMetaInfo.Create(rawMetaInfo, isKeepRawInfo);
    Self.MetaInfo := rawMetaInfo;
  end;
end;

destructor TTask.Destroy;
begin
  inherited;

  SetLength(Self.TaskBody, 0);
  SetLength(Self.ConditionBody, 0);
//  SetLength(Self.htmlTemplate, 0);
//  FreeAndNil(Self.MetaInfo);
end;

//function TTask.SaveHtmlTaskToFile(withCondition: Boolean; pathToTempFolder: string; resourceNameTemplateTask: string): THtmlTask;
//var
//  innerContent: TStringList;
//  resStream: TResourceStream;
//  templateContent: TStringList;
//  htmlTask: String;
//  resultHtmlTask: String;
//begin
//  innerContent := TStringList.Create;
//  templateContent := TStringList.Create;
//
//  // init html template
//  try
//    resStream := TResourceStream.Create(hInstance, resourceNameTemplateTask, RT_RCDATA);
//    templateContent.LoadFromStream(resStream);
//    Self.htmlTemplate := templateContent.Text;
//  finally
//    FreeAndNil(templateContent);
//    FreeAndNil(resStream);
//  end;
//
//  if (withCondition) then
//    htmlTask := Self.TaskBody + '<br>' + Self.ConditionBody
//  else
//    htmlTask := Self.TaskBody + '</center>';
//
//  resultHtmlTask := StringReplace(Self.htmlTemplate, '<task>', htmlTask, [rfReplaceAll, rfIgnoreCase]);
//  innerContent.Text := resultHtmlTask;
//  innerContent.SaveToFile(TPath.Combine(pathToTempFolder, NAME_TEMP_TASK_HTML), TEncoding.UTF8);
//  FreeAndNil(innerContent);
//
//  Result.PathToHtmlTask := TPath.Combine(pathToTempFolder, NAME_TEMP_TASK_HTML);
//  Result.ContentHtmlTask := resultHtmlTask;
//end;

end.
