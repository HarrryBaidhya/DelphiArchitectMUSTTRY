program Oracle2PG;

uses
  Vcl.Forms,
  Unit_Main in 'Unit_Main.pas' {Form_Main},
  fxn in 'fxn.pas',
  Unit_DM in 'Unit_DM.pas' {DM: TDataModule},
  Unit_CreateUser in 'Unit_CreateUser.pas' {Form_CreateUser};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm_Main, Form_Main);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm_CreateUser, Form_CreateUser);
  if checkIfFileExits then
     begin
          Startup;
          Pointer((@Application.MainForm)^) :=Form_Main;
     end
     else
     begin
          Pointer((@Application.MainForm)^) :=Form_CreateUser;
     end;

  Application.Run;
end.
