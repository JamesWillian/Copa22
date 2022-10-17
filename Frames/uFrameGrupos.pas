unit uFrameGrupos;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TFrameGrupos = class(TFrame)
    LabelGrupo: TLabel;
    RectGruposFull: TRectangle;
    LayoutSelecaoA: TLayout;
    ImageA: TImage;
    LineA: TLine;
    LabelSelecaoA: TLabel;
    LabelPontosA: TLabel;
    LabelJogosA: TLabel;
    LayoutSelecaoB: TLayout;
    ImageB: TImage;
    LineB: TLine;
    LabelSelecaoB: TLabel;
    LabelPontosB: TLabel;
    LabelJogosB: TLabel;
    LayoutSelecaoC: TLayout;
    ImageC: TImage;
    LineC: TLine;
    LabelSelecaoC: TLabel;
    LabelPontosC: TLabel;
    LabelJogosC: TLabel;
    LayoutSelecaoD: TLayout;
    ImageD: TImage;
    LabelSelecaoD: TLabel;
    LabelPontosD: TLabel;
    LabelJogosD: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
