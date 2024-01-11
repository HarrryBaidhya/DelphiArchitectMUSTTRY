unit fxn;

interface
uses
   Unit_DM,Messages,Dialogs,System.SysUtils,Uni;
var
gs_Srcdatabase,gs_Srcdbusername, gs_Srcdbpassword,
gs_Srcdbserver,gs_Srcdbport:string;

gs_Desdatabase,gs_Desdbusername, gs_Desdbpassword,
gs_Desdbserver,gs_Desdbport:string;

gs_SrcConnection, gs_Connection_UM, gs_Connection_PA, gs_Connection_Lab: TUniConnection;

gs_orgnamecode:string;

procedure Startup;

implementation

procedure startup;
var
ls_connectionString:string;
begin
     gs_orgnamecode := 'HEARTTOHEART';
     gs_Srcdbusername := 'HEARTTOHEART_USER';
     gs_Srcdbpassword := 'PWD_HEARTTOHEART';
     gs_Srcdbserver := '127.0.0.1';
     gs_Srcdbport := '1521';
     gs_Srcdatabase := 'orcl';
     DM := TDM.Create(nil);
     with DM.Connection_Source do
     begin
          Connected := False;
          ProviderName := 'Oracle';
          Server := gs_Srcdbserver;
          Port := StrToInt(gs_Srcdbport); // Assuming gs_Srcdbport is a string representation of the port
          Database := gs_Srcdatabase;
          Username := gs_Srcdbusername;
          Password := gs_Srcdbpassword;
          SpecificOptions.Values['Oracle.Direct'] := 'True'; // Set to 'False' if not using Direct mode
          Connected := True;
     end;


     gs_desdbusername := 'postgres';
     gs_desdbpassword := 'password';
     gs_desdbserver := '192.168.130.119';
     gs_Desdbport := '5432';
     gs_desdatabase := 'user_management';

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

     gs_desdbusername := 'postgres';
     gs_desdbpassword := 'password';
     gs_desdbserver := '192.168.130.119';
     gs_Desdbport := '5434';
     gs_desdatabase := 'pa';

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

     gs_desdbusername := 'postgres';
     gs_desdbpassword := 'password';
     gs_desdbserver := '192.168.130.119';
     gs_Desdbport := '5433';
     gs_desdatabase := 'lab';

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


end.