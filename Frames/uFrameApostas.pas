unit uFrameApostas;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.Controls.Presentation, FMX.Objects;

type
  TFrameApostas = class(TFrame)
    Layout1: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Layout5: TLayout;
    LayoutPlacar: TLayout;
    LabelGolA: TLabel;
    LabelPlacar: TLabel;
    LabelGolB: TLabel;
    LayoutSelecaoA: TLayout;
    ImageSelecaoA: TImage;
    LabelSelecaoA: TLabel;
    LayoutSelecaoB: TLayout;
    ImageSelecaoB: TImage;
    LabelSelecaoB: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RectButtonAberto: TRectangle;
    LabelButton: TLabel;
    Rectangle1: TRectangle;
    Line1: TLine;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
