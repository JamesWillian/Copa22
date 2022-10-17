program Copa22;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uFrameGrupos in 'Frames\uFrameGrupos.pas' {FrameGrupos: TFrame},
  uFramePartidas in 'Frames\uFramePartidas.pas' {FramePartidas: TFrame},
  uFrameApostas in 'Frames\uFrameApostas.pas' {FrameApostas: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
