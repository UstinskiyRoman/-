unit URegistration;

interface

uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.ComCtrls,
  UDataModuleClient, UUserInfo, System.StrUtils, Generics.Collections, UTypeUser,
  UClassGroupInfo, UFormBase, UCustomMessageBox, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.Components;

type
  TFRegistration = class(TFormBase)
    btnBack: TButton;
    btnRegistration: TButton;
    Panel2: TPanel;
    Label7: TLabel;
    editFirstName: TEdit;
    Label8: TLabel;
    editSecondName: TEdit;
    Label10: TLabel;
    comboboxClassGroup: TComboBox;
    CheckBox1: TCheckBox;
    DateTimePickerBirthday: TDateTimePicker;
    Label11: TLabel;
    Label1: TLabel;
    editPassword: TEdit;
    procedure btnBackClick(Sender: TObject);
//    procedure RadioButton4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRegistrationClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
//    procedure RadioButtonTeacherClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    procedure ExecuteClose(); override;
  private
    typeUser:TTypeUser;
    listClasses:TList<TClassGroup>;
  public
    { Public declarations }
  end;

var
  FRegistration: TFRegistration;

CONST
  PASS_CREATE_TEACHER = '123456789';

implementation

uses UMainMenu, UUserProfile;

{$R *.dfm}

procedure TFRegistration.ExecuteClose();
begin
  btnBack.Click;
end;

procedure TFRegistration.btnBackClick(Sender: TObject);
begin
  Self.Close;
  FMainMenu.Show();
end;

//procedure TFRegistration.RadioButton4Click(Sender: TObject);
//begin
//  Label10.Visible:=true;
//  comboboxClassGroup.Visible:=true;
//
////  label10.Caption:='Группа';
////  label10.Caption:='Класс';
//  typeUser:=Schoolkid;
//end;
//
//procedure TFRegistration.RadioButtonTeacherClick(Sender: TObject);
//begin
//  if not(InputBox('Необходим пароль', 'Введите пароль для регистрации учителя:', '') = PASS_CREATE_TEACHER)then
//  begin
//    FCustomMessageBox.SetMessage('Ошибка', 'Для создания учителя нужен пароль.', TTypeMessage.msgOK);
//    RadioButton4.Checked:=true;
//    Exit;
//  end;
//
//  Label10.Visible:=false;
//  comboboxClassGroup.Visible:=false;
//
//  typeUser:=Teacher;
//end;

procedure TFRegistration.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  FRegistration:=nil;
end;

procedure TFRegistration.FormShow(Sender: TObject);
var
  i:Integer;
begin
  comboboxClassGroup.Items.Clear();

//  RadioButton4.Checked:=true;

//  if(RadioButton3.Checked = true)then
//      label10.Caption:='Класс';

  listClasses:=DataModuleClient.GetAllClassesGroups();

  for i := 0 to listClasses.Count-1 do
  begin
    comboboxClassGroup.Items.Add(listClasses.Items[i].Name);
  end;
end;

procedure TFRegistration.btnRegistrationClick(Sender: TObject);
var
  i:integer;
  userInfo:TUserInfo;
  selectedClass:TClassGroup;
  birthday:TDateTime;
begin
  if(editFirstName.Text = EmptyStr)or(editSecondName.Text = EmptyStr)or(editPassword.Text = EmptyStr)or((comboboxClassGroup.Text = EmptyStr)and(typeUser <> TTypeUser.Teacher))then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Не все поля были заполнены!', TTypeMessage.msgOK);
    Exit;
  end;

  for i := 0 to listClasses.Count-1 do
  begin
     if(listClasses.Items[i].Name = comboboxClassGroup.Items[comboboxClassGroup.ItemIndex])then
      selectedClass:=listClasses.Items[i];
  end;

  if(selectedClass.Name = EmptyStr)and(typeUser <> TTypeUser.Teacher)then
  begin
      try
        if(typeUser = Schoolkid)then
        begin
          if not(Ord(comboboxClassGroup.Text[1]) in [Ord('0')..Ord('9')])then
          begin
            raise Exception.Create('Класс должен начинаться с цифры');
          end;
        end;

        selectedClass:=DataModuleClient.AddNewClassGroup(comboboxClassGroup.Text);
      except on E : Exception do
        begin
          FCustomMessageBox.SetMessage('Ошибка', 'Ошибка при создании нового класса. '+e.Message, TTypeMessage.msgOK);
          Exit;
        end;
      end;
  end;


  if(selectedClass.Name = EmptyStr)and(typeUser <> TTypeUser.Teacher)then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Класс не выбран.', TTypeMessage.msgOK);
    Exit;
  end;

  try
    if(CheckBox1.Checked)then
      birthday:=DateTimePickerBirthday.DateTime
    else
      birthday:=0;

    userInfo:=DataModuleClient.AddNewUser(editFirstName.Text, editSecondName.Text, selectedClass.ID,
                                            editPassword.Text, typeUser, birthday);
    except on E : Exception do
      begin
        FCustomMessageBox.SetMessage('Ошибка', 'Ошибка при создании нового пользователя. '+e.Message, TTypeMessage.msgOK);
        Exit;
      end;
  end;

  FCustomMessageBox.SetMessage('Внимание', Format('Вы, "%s %s", зарегистрированы.', [editSecondName.Text, editFirstName.Text]), TTypeMessage.msgOK);

  FMainMenu.UserInfo:=userInfo;

  FRegistration.Close;

  if(userInfo.TypeUser <> Teacher)then
    FMainMenu.ShowUserProfile();

  if(userInfo.TypeUser = Teacher)then
  begin
    FMainMenu.Show();
  end;
end;

procedure TFRegistration.CheckBox1Click(Sender: TObject);
begin
  DateTimePickerBirthday.Enabled:=CheckBox1.Checked;
end;

end.
