unit uFramePartidas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TFramePartidas = class(TFrame)
    RectFull: TRectangle;
    LayoutSelecaoA: TLayout;
    LayoutSelecaoB: TLayout;
    ImageSelecaoA: TImage;
    LabelSelecaoA: TLabel;
    ImageSelecaoB: TImage;
    LabelSelecaoB: TLabel;
    LayoutPlacar: TLayout;
    LabelGolA: TLabel;
    LabelPlacar: TLabel;
    LabelGolB: TLabel;
    LayoutTop: TLayout;
    LabelFase: TLabel;
    LabelDataHora: TLabel;
    Layout1: TLayout;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
