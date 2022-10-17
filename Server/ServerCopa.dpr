program ServerCopa;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  System.SysUtils,
  uDM in 'uDM.pas' {DM: TDataModule},
  Controller in 'Controller.pas';

begin
  ReportMemoryLeaksOnShutdown := True;

  THorse.Use(Jhonson());

  THorse.Host := '127.0.0.1';
  THorse.Port := 9000;

  Registry;

  THorse.Listen(THorse.Port, procedure(Horse: THorse)
  begin
    Writeln(Format('Servidor está rodando em %s:%d', [Horse.Host, Horse.Port]));
    Readln;
  end);
end.
