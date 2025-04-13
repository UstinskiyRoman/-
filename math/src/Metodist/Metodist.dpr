program Metodist;

uses
  Vcl.Forms,
  UFormBase in '..\SharedComponents\UFormBase.pas',
  UTools in '..\Domain\tools\UTools.pas',
  UModes in '..\Domain\UModes.pas',
  UClassGroupInfo in '..\Domain\UClassGroupInfo.pas',
  UTypeUser in '..\Domain\UTypeUser.pas',
  UUserDTO in '..\Domain\UUserDTO.pas',
  UUserInfo in '..\Domain\UUserInfo.pas',
  UConfigBase in '..\Domain\tools\UConfigBase.pas',
  UConfigClient in '..\Domain\tools\UConfigClient.pas',
  UStatistic in '..\Domain\UStatistic.pas',
  UStatisticInfo in '..\Domain\UStatisticInfo.pas',
  UTeacherMain in 'UTeacherMain.pas' {FTeacherMain},
  UCustomMessageBox in '..\SharedComponents\UCustomMessageBox.pas' {FCustomMessageBox},
  UNotifyEventWrapper in '..\SharedComponents\tools\UNotifyEventWrapper.pas',
  UCourseLessonEditor in 'UCourseLessonEditor.pas' {FCourseLessonEditor},
  UTaskInfo in '..\Domain\UTaskInfo.pas',
  UTypeTasks in '..\Domain\UTypeTasks.pas',
  UTaskResourcesManager in '..\SharedComponents\UTaskResourcesManager.pas',
  UDataModuleSQLiteBase in '..\DataModule\UDataModuleSQLiteBase.pas' {DataModuleSQLiteBase: TDataModule},
  UTaskResourceType in '..\Domain\UTaskResourceType.pas',
  UTaskResources in '..\Domain\UTaskResources.pas',
  UDataModuleBase in '..\DataModule\UDataModuleBase.pas' {DataModuleBase: TDataModule},
  UCourse in '..\Domain\UCourse.pas',
  ULessonInfo in '..\Domain\ULessonInfo.pas',
  UDataModuleEditor in '..\DataModule\UDataModuleEditor.pas' {DataModuleEditor: TDataModule},
  UDataModuleClient in '..\DataModule\UDataModuleClient.pas' {DataModuleClient: TDataModule},
  UTaskEditor in 'UTaskEditor.pas' {FTaskEditor};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Config := TAccessToFiles.Create();
  AppTools := TTools.Create;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDataModuleSQLiteBase, DataModuleSQLiteBase);
  Application.CreateForm(TDataModuleBase, DataModuleBase);
  Application.CreateForm(TDataModuleClient, DataModuleClient);
  Application.CreateForm(TDataModuleEditor, DataModuleEditor);
  Application.CreateForm(TFTeacherMain, FTeacherMain);
  Application.CreateForm(TFCustomMessageBox, FCustomMessageBox);
  Application.CreateForm(TFTaskEditor, FTaskEditor);
  Application.Run;
end.
