unit Unit_CreateUser;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,IniFiles,
  System.ImageList, Vcl.ImgList, Data.DB, DBAccess, Uni,Unit_DM,fxn;

type
  TForm_CreateUser = class(TForm)
    Btn_Save: TButton;
    Btn_Close: TButton;
    Lbl_Username: TLabel;
    Edit_UserName: TEdit;
    Label1: TLabel;
    Edit_password: TEdit;
    Label2: TLabel;
    Edit_OrganizationCode: TEdit;
    Edit_ServerPort: TEdit;
    Edit_DatabaseSource: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Combo_ProviderName: TComboBox;
    Text_ServerName: TLabel;
    Edit_ServerName: TEdit;
    Upperpanel: TPanel;
    Label5: TLabel;
    ImageList1: TImageList;
    ConnectionList: TListBox;
    procedure Btn_CloseClick(Sender: TObject);
    procedure Btn_SaveClick(Sender: TObject);
    procedure ConnectionListClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearForm;
  private
    { Private declarations }
  public
   Ps_providerName, PS_oracleUserName, PS_um, Ps_pa,Ps_lab:string;
   ps_Srcdbpassword_orcl_Ini,PS_Srcdbport_orcl_ini,Ps_Srcdatabase_orcl_ini,ps_Srcdbserverini:string;
   ps_Srcdbusername_pos_Umini,ps_Srcdbpassword_pos_UmIni,ps_Srcdbserver_Pos_UmIni,ps_SrcdatabaseName_Pos_ini,ps_Srcdbport_pos_Umini,ps_Srcdatabase_Pos_Umini:string;
   ps_Srcdbusername_pos_Paini,ps_Srcdbpassword_pos_PaIni,ps_Srcdbserver_Pos_PaIni,ps_SrcdatabaseName_Pos_Paini,ps_Srcdbport_pos_Paini,ps_Srcdatabase_Pos_Paini:string;
   ps_Srcdbusername_pos_Labini,ps_Srcdbpassword_pos_labIni,ps_Srcdbserver_Pos_labIni,ps_SrcdatabaseName_Pos_labini,ps_Srcdbport_pos_labini,ps_Srcdatabase_Pos_labini:string;
     Index: Integer;
    { Public declarations }
  end;

var
  Form_CreateUser: TForm_CreateUser;
  save:TIniFile;
   Rect: TRect;

implementation

{$R *.dfm}

procedure TForm_CreateUser.Btn_CloseClick(Sender: TObject);
begin
 close;
end;

procedure TForm_CreateUser.Btn_SaveClick(Sender: TObject);
var
Ls_providerName, ls_oracle, ls_um, ls_pa,ls_lab:string;
begin

         if Edit_Username.Text = '' then
        begin
            ShowMessage('Please Enter Username!');
            Edit_Username.SetFocus;
            Exit;
           end
        else if Edit_Password.Text = '' then
          begin
            ShowMessage('Please Enter Password!');
            Edit_Password.SetFocus;
            Exit;
          end
          else if Edit_ServerPort.Text='' then
          begin
             ShowMessage('Please Enter ServerPort!');
             Edit_ServerPort.SetFocus;
             Exit;
          end
          else if Edit_DatabaseSource.Text='' then
             begin
             ShowMessage('Please Enter DataSource!');
             Edit_DatabaseSource.SetFocus;
             Exit;
          end
            else if Edit_ServerName.Text='' then
             begin
             ShowMessage('Please Enter ServerIP!');
             Edit_DatabaseSource.SetFocus;
             Exit;
          end
           else if Combo_ProviderName.Text='' then
             begin
             ShowMessage('Please choose ProviderName!');
             Edit_DatabaseSource.SetFocus;
             Exit;
          end;

          ls_ProviderName := Combo_ProviderName.Text;
          save:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'OracleInfo.ini');
          save.WriteString(ls_ProviderName,'UserName',Edit_Username.text);
          save.WriteString(ls_ProviderName,'Password',Edit_Password.text);
          save.WriteString(ls_ProviderName,'ServerPort',Edit_ServerPort.text);
          save.WriteString(ls_ProviderName,'OragnizationCode',Edit_OrganizationCode.text);
          save.WriteString(ls_ProviderName,'DatabaseSource',Edit_DatabaseSource.text);
          save.WriteString(ls_ProviderName,'ServerIP',Edit_ServerName.text);
          showmessage('Data Save Sucessfully for'+ls_ProviderName);

          ls_oracle := save.ReadString('Oracle','UserName','');
          ls_um := save.ReadString('UM','UserName','');
          ls_pa := save.ReadString('PA','UserName','');
          ls_lab := save.ReadString('LAB','UserName','');
          {note %if the all the not set it will not setuped%}
        if (ls_oracle<>'') and (ls_um<>'') and (ls_pa<>'') and (ls_lab<>'') then
          begin
          save.Free;
          Application.Terminate
          end;
            ClearForm;
            FormShow(sender);
      //  Form_CreateUser.Free;
end;

procedure TForm_CreateUser.ClearForm;
var
  I: Integer;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    if Components[I] is TEdit then
      (Components[I] as TEdit).Clear;

  end;
end;


procedure TForm_CreateUser.ConnectionListClick(Sender: TObject);
begin
///ConnectionList.Items.Add('Oracle is connected');

end;

procedure TForm_CreateUser.FormShow(Sender: TObject);
begin
    ConnectionList.Items.Clear;
  try
         save:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'OracleInfo.ini');
         {Oracle section}
          PS_oracleUserName := save.ReadString('Oracle','UserName','');
          ps_Srcdbpassword_orcl_Ini := save.ReadString('Oracle', 'Password', '');
          ps_Srcdbport_orcl_ini := save.ReadString('Oracle', 'ServerPort', '');
          ps_Srcdatabase_orcl_ini := save.ReadString('Oracle','DatabaseSource', '');
          ps_Srcdbserverini := save.ReadString('Oracle', 'ServerIP', '');

           ///section for UserManagemnt
          // ps_um := save.ReadString('UM','UserName','');
           ps_Srcdbusername_pos_Umini := save.ReadString('UM', 'UserName', '');
           ps_Srcdbpassword_pos_UmIni := save.ReadString('UM', 'Password', '');
           ps_Srcdbport_Pos_UmIni := save.ReadString('UM', 'ServerPort', '');
           ps_Srcdatabase_Pos_Umini := save.ReadString('UM','DatabaseSource', '');
           ps_Srcdbserver_Pos_UmIni := save.ReadString('UM', 'ServerIp', '');
           /////section for Pa
           //ps_pa := save.ReadString('PA','UserName','');
           ps_Srcdbusername_pos_Paini := save.ReadString('PA', 'UserName', '');
           ps_Srcdbpassword_pos_PaIni := save.ReadString('PA', 'Password', '');
           ps_Srcdbport_Pos_PaIni := save.ReadString('PA', 'ServerPort', '');
           ps_Srcdatabase_Pos_PaIni := save.ReadString('PA','DatabaseSource', '');
           ps_Srcdbserver_pos_PaIni := save.ReadString('PA', 'ServerIP', '');

            ///for lab
           ps_Srcdbusername_pos_labini := save.ReadString('LAB', 'UserName', '');
           ps_Srcdbpassword_pos_labIni := save.ReadString('LAB', 'Password', '');
           ps_Srcdbport_Pos_labIni := save.ReadString('LAB', 'ServerPort', '');
           ps_Srcdatabase_Pos_labini := save.ReadString('LAB','DatabaseSource', '');
           ps_Srcdbserver_Pos_labIni := save.ReadString('LAB', 'ServerIP', '');



         ps_lab := save.ReadString('LAB','UserName','');
      if (PS_oracleUserName)<>'' then
       begin

          DM := TDM.Create(nil);
          with DM.Connection_Source do
         begin
          Connected := False;
          ProviderName := 'Oracle';
          Server := ps_Srcdbserverini+':'+ps_Srcdbport_orcl_ini+'/'+ps_Srcdatabase_orcl_ini;
          Port := StrToInt(ps_Srcdbport_orcl_ini); // Assuming gs_Srcdbport is a string representation of the port
          Database := ps_Srcdatabase_orcl_ini;
          Username := PS_oracleUserName;
          Password := ps_Srcdbpassword_orcl_Ini;
          SpecificOptions.Values['Oracle.Direct'] := 'True'; // Set to 'False' if not using Direct mode
          Connected := True;
        end;
         ConnectionList.Items.Add('Oracle is connected');
          Font.Color := clGreen;
       end
       else
         ConnectionList.Items.Add('Oracle is not connected');

        if(ps_Srcdbusername_pos_Umini)<>'' then
        begin
       with DM.Connection_UM do
        begin
          ProviderName := 'PostgreSQL';
          Server := ps_Srcdbserver_Pos_UmIni;
          Port := StrToInt(ps_Srcdbport_Pos_UmIni); // Assuming gs_Desdbport is a string representation of the port
          Database := ps_Srcdatabase_Pos_Umini;
          Username := ps_Srcdbusername_pos_Umini;
          Password := ps_Srcdbpassword_pos_UmIni;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

        end;
        ConnectionList.Items.Add('UM is connected');
        end
        else
          ConnectionList.Items.Add('UM is Not connected');


          if(ps_Srcdbusername_pos_Paini)<>'' then
        begin
        with DM.Connection_PA do
        begin
          ProviderName := 'PostgreSQL';
          Server := ps_Srcdbserver_pos_PaIni;
          Port := StrToInt(ps_Srcdbport_Pos_PaIni); // Assuming gs_Desdbport is a string representation of the port
          Database := ps_Srcdatabase_Pos_PaIni;
          Username := ps_Srcdbusername_pos_Paini;
          Password := ps_Srcdbpassword_pos_PaIni;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

        end;
        ConnectionList.Items.Add('PA is connected');
        end
        else
        ConnectionList.Items.Add('PA is Not connected');

        if(ps_Srcdbusername_pos_labini)<>'' then
        begin
         with DM.Connection_Lab do
        begin
          ProviderName := 'PostgreSQL';
          Server := ps_Srcdbserver_pos_PaIni;
          Port := StrToInt(ps_Srcdbport_Pos_labIni); // Assuming gs_Desdbport is a string representation of the port
          Database := ps_Srcdatabase_Pos_labIni;
          Username := ps_Srcdbusername_pos_labini;
          Password := ps_Srcdbpassword_pos_labIni;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

       end;
       ConnectionList.Items.Add('Lab is connected');
       End
       else
        ConnectionList.Items.Add('Lab is Not connected');

      except
      on E: Exception do
      showMessage('Error'+E.Message);
  end;



end;

end.
