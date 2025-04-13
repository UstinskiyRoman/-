unit UMainMenu;
interface
uses
  WinApi.Windows, WinApi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, WinApi.ShellApi, Vcl.Buttons,
  System.DateUtils, UDataModuleClient, Data.DB, Data.Win.ADODB, Generics.Collections,
  Vcl.Imaging.GIFImg, UCustomMessageBox, UUserInfo,// UXMLLoader,
  UTypeUser, UUserDTO, UClassGroupInfo;
type
  TFMainMenu = class(TForm)
    btnExit: TButton;
    imgBackground: TImage;
    btnSignIn: TButton;
    btnRegistration: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    comboboxClassGroup: TComboBox;
    comboboxFIO: TComboBox;
    editPassword: TEdit;
    btnLogin: TButton;
    btnAbout: TButton;
    procedure btnExitClick(Sender: TObject);
    procedure btnRegistrationClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comboboxClassGroupChange(Sender: TObject);
    procedure btnSignInClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure RB1Click(Sender: TObject);
    procedure comboboxFIOChange(Sender: TObject);
    procedure editPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnAboutClick(Sender: TObject);
  private
    listClasses:TList<TClassGroup>;
    dictionaryUsers:TDictionary<integer, TUserDTO>;
  public
    UserInfo: TUserInfo;
    procedure ShowUserProfile();
  end;
var
  FMainMenu: TFMainMenu;
implementation
uses URegistration, UUserProfile, UAbout; //, UTeacherMain; //, UModeTestMenu, UAbout;
{$R *.dfm}

procedure TFMainMenu.ShowUserProfile();
begin
  FUserProfile:=TFUserProfile.Create(nil);
  FUserProfile.LoadUserInfo(UserInfo);
  FUserProfile.Show;
  Self.Hide;
end;

procedure TFMainMenu.btnExitClick(Sender: TObject);
begin
 if(FCustomMessageBox.SetMessage('Внимание', 'Вы уверены, что хотите выйти из программы?', TTypeMessage.msgOKCancel) = mrOk)then
  begin
   Self.Close;
  end;
end;
procedure TFMainMenu.btnRegistrationClick(Sender: TObject);
begin
  Hide();
  FRegistration:=TFRegistration.Create(nil);
  FRegistration.Show();
end;
procedure TFMainMenu.FormCreate(Sender: TObject);
begin
 // XMLLoader:=TXMLLoader.Create(FMainMenu);
  (imgBackground.Picture.Graphic as TGIFImage).Animate := True;
end;
procedure TFMainMenu.FormShow(Sender: TObject);
var
  i:Integer;
begin
  comboboxClassGroup.Clear;
  listClasses:=DataModuleClient.GetAllClassesGroups();
  for i := 0 to listClasses.Count-1 do
  begin
    comboboxClassGroup.Items.Add(listClasses.Items[i].Name);
  end;
end;
//procedure TFMainMenu.RB1Click(Sender: TObject);
//var
//  listUsers:TList<TUserDTO>;
//  i:Integer;
//begin
// Label1.Visible:=RB1.Checked;
// comboboxClassGroup.Visible:=RB1.Checked;
// if RB2.Checked then
//  begin
//   comboboxFIO.Clear;
//   listUsers:=DataModuleClient.GetUsers(Teacher);
//
//   dictionaryUsers:=TDictionary<integer, TUserDTO>.Create;
//
//   for i := 0 to listUsers.Count-1 do
//    begin
//     comboboxFIO.Items.Add(listUsers.Items[i].FirstName+' '+listUsers.Items[i].SecondName);
//     dictionaryUsers.Add(i, listUsers.Items[i]);
//    end;

//
//  end;
//end;

procedure TFMainMenu.comboboxClassGroupChange(Sender: TObject);
var
  i:Integer;
  selectedClass:TClassGroup;
  listUsers:TList<TUserDTO>;
begin
  comboboxFIO.Clear;
  for i := 0 to listClasses.Count-1 do
  begin
    if(listClasses.Items[i].Name = comboboxClassGroup.Items[comboboxClassGroup.ItemIndex])then
      selectedClass:=listClasses.Items[i];
  end;
  if(selectedClass.Name = EmptyStr)then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Класс не выбран.', TTypeMessage.msgOK);
    Exit;
  end;
  listUsers:=DataModuleClient.GetUsersByClass(selectedClass.ID);
  dictionaryUsers:=TDictionary<integer, TUserDTO>.Create;
  for i := 0 to listUsers.Count-1 do
  begin
    comboboxFIO.Items.Add(listUsers.Items[i].FirstName+' '+listUsers.Items[i].SecondName);
    dictionaryUsers.Add(i, listUsers.Items[i]);
  end;
end;

procedure TFMainMenu.comboboxFIOChange(Sender: TObject);
begin
  comboboxFIO.Hint:=comboboxFIO.Items[comboboxFIO.ItemIndex];
  comboboxFIO.ShowHint:=True;
end;
procedure TFMainMenu.editPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key = VK_RETURN then
  btnLogin.Click;

end;

procedure TFMainMenu.btnSignInClick(Sender: TObject);
begin
  if(GroupBox1.Visible)then
  begin
    GroupBox1.Visible:=false;
  end else
  begin
    GroupBox1.Visible:=true;
  end;
end;

procedure TFMainMenu.btnLoginClick(Sender: TObject);
begin
  if(comboboxClassGroup.ItemIndex = -1) then // and Rb1.Checked
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Вы не выбрали класс/группу!', TTypeMessage.msgOK);
    Exit;
  end;
  if(comboboxFIO.ItemIndex = -1)then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Вы не выбрали пользователя для входа!', TTypeMessage.msgOK);
    Exit;
  end;
  if(editPassword.Text = '')then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Вы не ввели пароль!', TTypeMessage.msgOK);
    Exit;
  end;
  UserInfo:=DataModuleClient.GetUserInfo(dictionaryUsers.Items[comboboxFIO.ItemIndex].ID, editPassword.Text);
  if(UserInfo = nil)then
  begin
    FCustomMessageBox.SetMessage('Ошибка', 'Вы ввели неверный пароль!', TTypeMessage.msgOK);
    Exit;
  end;
  editPassword.Text:=EmptyStr;
  comboboxFIO.ItemIndex:=-1;
  comboboxClassGroup.ItemIndex:=-1;
  if(UserInfo.TypeUser <> Teacher)then
   begin
    ShowUserProfile();
   end;
//  else
//  begin
//   Hide();
//   FTeacherMain:=TFTeacherMain.Create(nil);
//   FTeacherMain.Show;
//  end;
end;
procedure TFMainMenu.btnAboutClick(Sender: TObject);
begin
  FAbout.ShowModal();
end;
end.
