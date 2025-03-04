unit Unit_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Comp.Client, DBAccess, Uni, PostgreSQLUniProvider,
  UniProvider, OracleUniProvider;

type
  TDM = class(TDataModule)
    Connection_Source: TUniConnection;
    Connection_UM: TUniConnection;
    OracleUniProvider1: TOracleUniProvider;
    PostgreSQLUniProvider1: TPostgreSQLUniProvider;
    Connection_PA: TUniConnection;
    Connection_Lab: TUniConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
