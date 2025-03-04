unit fxn;

interface
uses
   Unit_DM,Messages,Dialogs,System.SysUtils,Uni,IniFiles;
var
gs_Srcdatabase,gs_Srcdbusername, gs_Srcdbpassword,
gs_Srcdbserver,gs_Srcdbport:string;

gs_Desdatabase,gs_Desdbusername, gs_Desdbpassword,
gs_Desdbserver,gs_Desdbport:string;
/// Orcale Parameter
gs_orgnamecode_ini,gs_Srcdbusername_orcl_ini,gs_Srcdbpassword_orcl_Ini,gs_Srcdatabase_orcl_ini,gs_Srcdbserverini,gs_Srcdbport_orcl_ini:string;
///UM Params
gs_Srcdbusername_pos_Umini,gs_Srcdbpassword_pos_UmIni,gs_Srcdbserver_Pos_UmIni,gs_SrcdatabaseName_Pos_ini,gs_Srcdbport_pos_Umini,gs_orgnamecode_Pos_Umini,gs_Srcdatabase_Pos_Umini:string;
///Lab
gs_Srcdbusername_pos_Labini,gs_Srcdbpassword_pos_labIni,gs_Srcdbserver_Pos_labIni,gs_SrcdatabaseName_Pos_labini,gs_Srcdbport_pos_labini,gs_orgnamecode_Pos_labini,gs_Srcdatabase_Pos_labini:string;
//Pa
gs_Srcdbusername_pos_Paini,gs_Srcdbpassword_pos_PaIni,gs_Srcdbserver_Pos_PaIni,gs_SrcdatabaseName_Pos_Paini,gs_Srcdbport_pos_Paini,gs_orgnamecode_Pos_Paini,gs_Srcdatabase_Pos_Paini:string;

pb_CheckFileExits: Boolean;
gs_SrcConnection, gs_Connection_UM, gs_Connection_PA, gs_Connection_Lab: TUniConnection;

gs_orgnamecode:string;
 save: TIniFile;
 filePath: string;
procedure Startup;
function checkIfFileExits: Boolean;

implementation

procedure startup;
var
ls_connectionString:string;
begin
     gs_orgnamecode := gs_orgnamecode_ini;
     gs_Srcdbusername := gs_Srcdbusername_orcl_ini;
     gs_Srcdbpassword := gs_Srcdbpassword_orcl_Ini;
     gs_Srcdbserver := gs_Srcdbserverini;
     gs_Srcdbport := gs_Srcdbport_orcl_ini;
     gs_Srcdatabase := gs_Srcdatabase_orcl_ini;
     DM := TDM.Create(nil);
     with DM.Connection_Source do
     begin
          Connected := False;
          ProviderName := 'Oracle';
          Server := gs_Srcdbserver+':'+gs_Srcdbport+'/'+gs_Srcdatabase;
          Port := StrToInt(gs_Srcdbport); // Assuming gs_Srcdbport is a string representation of the port
          Database := gs_Srcdatabase;
          Username := gs_Srcdbusername;
          Password := gs_Srcdbpassword;
          SpecificOptions.Values['Oracle.Direct'] := 'True'; // Set to 'False' if not using Direct mode
          Connected := True;
     end;


     gs_desdbusername :=gs_Srcdbusername_Pos_Umini;//'postgres';
     gs_desdbpassword := gs_Srcdbpassword_Pos_UmIni;     //'um-4GukbyTD';
     gs_desdbserver := gs_Srcdbserver_pos_umIni;//'pphl.midashealthservices.com.np';
     gs_Desdbport := gs_Srcdbport_Pos_Umini;     //'5436';
     gs_desdatabase := gs_Srcdatabase_Pos_Umini;      //'user_management';

     with DM.Connection_UM do
     begin
          ProviderName := 'PostgreSQL';
          Server := gs_Desdbserver;
          Port := StrToInt(gs_Desdbport); // Assuming gs_Desdbport is a string representation of the port
          Database := gs_Desdatabase;
          Username := gs_Desdbusername;
          Password := gs_Desdbpassword;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

     end;

     gs_desdbusername := gs_Srcdbusername_Pos_Paini;  //'postgres';
     gs_desdbpassword := gs_Srcdbpassword_Pos_PaIni ;     // 'pa-hdfjus8d';
     gs_desdbserver :=  gs_Srcdbserver_pos_PaIni;      //'pphl.midashealthservices.com.np';
     gs_Desdbport := gs_Srcdbport_Pos_Paini ;          //'5434';
     gs_desdatabase := gs_Srcdatabase_Pos_Paini;           //'pa';

     with DM.Connection_PA do
     begin
          ProviderName := 'PostgreSQL';
          Server := gs_Desdbserver;
          Port := StrToInt(gs_Desdbport); // Assuming gs_Desdbport is a string representation of the port
          Database := gs_Desdatabase;
          Username := gs_Desdbusername;
          Password := gs_Desdbpassword;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

     end;

     gs_desdbusername := gs_Srcdbusername_Pos_labini;//'postgres';
     gs_desdbpassword :=  gs_Srcdbpassword_Pos_labIni; //'lab-S9fswa3';
     gs_desdbserver :=gs_Srcdbserver_pos_labIni;       //'pphl.midashealthservices.com.np';
     gs_Desdbport := gs_Srcdbport_Pos_labini;         //'5433';
     gs_desdatabase :=gs_Srcdatabase_Pos_labini;    //'lab';

     with DM.Connection_Lab do
     begin
          ProviderName := 'PostgreSQL';
          Server := gs_Desdbserver;
          Port := StrToInt(gs_Desdbport); // Assuming gs_Desdbport is a string representation of the port
          Database := gs_Desdatabase;
          Username := gs_Desdbusername;
          Password := gs_Desdbpassword;
          SpecificOptions.Values['PostgreSQL.ProtocolVersion'] := 'pv30'; // Adjust the protocol version if needed
          Connected := True;

     end;

     gs_SrcConnection:=  DM.Connection_Source;
     gs_Connection_UM:=  DM.Connection_UM;
     gs_Connection_PA:=  DM.Connection_PA;
     gs_Connection_Lab:=  DM.Connection_Lab
end;

function checkIfFileExits: Boolean;
begin
        filePath := ExtractFilePath(ParamStr(0)) + 'OracleInfo.ini';
       if FileExists(filePath) then
     //if FileExists(ExtractFilePath(ParamStr(0)) + 'OrcaleInfo.ini') then
     begin
          // save := TIniFile.Create(filePath);
          save := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'OracleInfo.ini');
         // save:=TIniFile.Create(gs_IrdInfopath+'\'+'IrdInfo.ini');
         //for oracleDatabse
           gs_Srcdbusername_orcl_ini := save.ReadString('Oracle', 'UserName', '');
           gs_Srcdbpassword_orcl_Ini := save.ReadString('Oracle', 'Password', '');
           gs_Srcdbport_orcl_ini := save.ReadString('Oracle', 'ServerPort', '');
           gs_orgnamecode_ini := save.ReadString('Oracle', 'OragnizationCode', '');
           gs_Srcdatabase_orcl_ini := save.ReadString('Oracle','DatabaseSource', '');
           gs_Srcdbserverini := save.ReadString('Oracle', 'ServerIP', '');

           ///for Usmmangement
           gs_Srcdbusername_pos_Umini := save.ReadString('UM', 'UserName', '');
           gs_Srcdbpassword_pos_UmIni := save.ReadString('UM', 'Password', '');
           gs_Srcdbport_Pos_UmIni := save.ReadString('UM', 'ServerPort', '');
           gs_orgnamecode_Pos_Umini := save.ReadString('UM', 'OragnizationCode', '');
           gs_Srcdatabase_Pos_Umini := save.ReadString('UM','DatabaseSource', '');
           gs_Srcdbserver_Pos_UmIni := save.ReadString('UM', 'ServerIp', '');

           ///for lab
           gs_Srcdbusername_pos_labini := save.ReadString('LAB', 'UserName', '');
           gs_Srcdbpassword_pos_labIni := save.ReadString('LAB', 'Password', '');
           gs_Srcdbport_Pos_labIni := save.ReadString('LAB', 'ServerPort', '');
           gs_orgnamecode_Pos_labini := save.ReadString('LAB', 'OragnizationCode', '');
           gs_Srcdatabase_Pos_labini := save.ReadString('LAB','DatabaseSource', '');
           gs_Srcdbserver_Pos_labIni := save.ReadString('LAB', 'ServerIP', '');

           ///for Pa
           gs_Srcdbusername_pos_Paini := save.ReadString('PA', 'UserName', '');
           gs_Srcdbpassword_pos_PaIni := save.ReadString('PA', 'Password', '');
           gs_Srcdbport_Pos_PaIni := save.ReadString('PA', 'ServerPort', '');
           gs_orgnamecode_Pos_Paini := save.ReadString('PA', 'OragnizationCode', '');
           gs_Srcdatabase_Pos_PaIni := save.ReadString('PA','DatabaseSource', '');
           gs_Srcdbserver_pos_PaIni := save.ReadString('PA', 'ServerIP', '');

           pb_CheckFileExits := True;
          if ((gs_Srcdbusername_orcl_ini = '') or (gs_Srcdbusername_pos_Umini = '') or (gs_Srcdbusername_pos_labini = '') or ( gs_Srcdbusername_pos_Paini='')) then
          begin
               Result := False;

          end
          else
          begin
               Result := True;
//              InitialPhase;
          end;
     end
     else
     begin
      Result := False;
     end;

end;



end.
