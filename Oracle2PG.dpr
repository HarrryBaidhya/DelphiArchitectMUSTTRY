program Oracle2PG;

uses
  Vcl.Forms,
  Unit_Main in 'Unit_Main.pas' {Form_Main},
  fxn in 'fxn.pas',
  Unit_DM in 'Unit_DM.pas' {DM: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Startup;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Main, Form_Main);
  Application.CreateForm(TDM, DM);
  Application.Run;
end.
