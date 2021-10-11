program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Search of files with usage of DLL';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
