unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Layouts, FMX.Objects, FMX.ListView, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TabControl, uDM, System.ImageList, FMX.ImgList;

type
  TMainForm = class(TForm)
    MainLayout: TLayout;
    BottomLayout: TLayout;
    TopLayout: TLayout;
    TabControl: TTabControl;
    TabTabela: TTabItem;
    TabPartidas: TTabItem;
    TabApostas: TTabItem;
    TabRanking: TTabItem;
    ListTabela: TVertScrollBox;
    ListPartidas: TVertScrollBox;
    RectFiltroPartidas: TRectangle;
    LabelFiltroGrupos: TLabel;
    LabelFiltroSelecao: TLabel;
    ListApostas: TVertScrollBox;
    RectNovaAposta: TRectangle;
    LabelNovaAposta: TLabel;
    ListRanking: TListView;
    LayoutProfile: TLayout;
    ImageProfile: TImage;
    LayoutPontos: TLayout;
    LabelPontos: TLabel;
    ImageLogo: TImage;
    LayoutLogo: TLayout;
    GridLayout1: TGridLayout;
    RectTabela: TRectangle;
    RectPartidas: TRectangle;
    RectApostas: TRectangle;
    RectRanking: TRectangle;
    LabelTabela: TLabel;
    LabelPartidas: TLabel;
    LabelApostas: TLabel;
    LabelRanking: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    RectAposta: TRectangle;
    Layout1: TLayout;
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
    lblFase: TLabel;
    lblDataHora: TLabel;
    Image5: TImage;
    Image6: TImage;
    ImagesBandeiras: TImage;
    procedure RectTabelaTap(Sender: TObject; const Point: TPointF);
    procedure RectPartidasTap(Sender: TObject; const Point: TPointF);
    procedure RectApostasTap(Sender: TObject; const Point: TPointF);
    procedure RectRankingTap(Sender: TObject; const Point: TPointF);
    procedure FormShow(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure RectNovaApostaClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }

    procedure ListarTabelasGrupos;
    procedure AddTabGrupo(grupo: String);

    procedure ListarPartidas;
    procedure AddPartida;

    procedure ListarApostas;
    procedure AddAposta;

    procedure ListarRanking;
    procedure AddRanking(posicao, nome, pontos: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  uFramePartidas, uFrameApostas, uFrameGrupos;

procedure TMainForm.AddAposta;
var
  frameAposta: TFrameApostas;
begin
  frameAposta := TFrameApostas.Create(nil);

  with frameAposta do begin
    Align := TAlignLayout.Top;
    Position.Y := 1000;

    ImageSelecaoA.Bitmap := ImagesBandeiras.MultiResBitmap.Items[24].Bitmap;
    ImageSelecaoB.Bitmap := ImagesBandeiras.MultiResBitmap.Items[12].Bitmap;
  end;

  ListApostas.AddObject(frameAposta);

end;

procedure TMainForm.AddPartida;
var
  framePartida: TFramePartidas;
begin
  framePartida := TFramePartidas.Create(nil);

  with framePartida do begin
    Align := TAlignLayout.Top;
    Position.Y := 1000;

    ImageSelecaoA.Bitmap := ImagesBandeiras.MultiResBitmap.Items[24].Bitmap;
    ImageSelecaoB.Bitmap := ImagesBandeiras.MultiResBitmap.Items[8].Bitmap;
  end;

  ListPartidas.AddObject(framePartida);
end;

procedure TMainForm.AddRanking(posicao, nome, pontos: String);
var
  txt: TListItemText;
begin
  with ListRanking.Items.Add do begin
    Height := 30;

    txt := TListItemText(Objects.FindDrawable('txtPosicao'));
    txt.Text := posicao;

    txt := TListItemText(Objects.FindDrawable('txtNome'));
    txt.Text := nome;

    txt := TListItemText(Objects.FindDrawable('txtPontos'));
    txt.Text := pontos;
  end;
end;

procedure TMainForm.AddTabGrupo(grupo: String);
var
  frameGrupo: TFrameGrupos;
  Size: TSizeF;
begin
  frameGrupo := TFrameGrupos.Create(nil);
  Size := TSizeF.Create(32,32);

  with frameGrupo, DM.mtTabelaGrupos do begin

    //mtTabelaGrupos
    Filter := 'GRUPO = '+grupo.QuotedString;
    Filtered := True;

    //frameGrupo
    Align := TAlignLayout.Top;
    Position.Y := 1000;

    LabelGrupo.Text := 'Grupo '+grupo;

    //Seleção A
    LayoutSelecaoA.Tag := FieldByName('ID_SELECAO').AsInteger;
    LabelSelecaoA.Text := FieldByName('NOME_SELECAO').AsString;//'Brasil';
    LabelJogosA.Text   := DM.mtTabelaGrupos.FieldByName('JOGOS').AsString + ' Jogos';//'3 Jogos';
    LabelPontosA.Text  := DM.mtTabelaGrupos.FieldByName('PONTOS').AsString + ' Pontos';//'9 Pontos';
    ImageA.Bitmap      := ImagesBandeiras.MultiResBitmap.Items[FieldByName('ID_SELECAO').AsInteger -1].Bitmap;

    Next;

    //Seleção B
    LayoutSelecaoB.Tag := FieldByName('ID_SELECAO').AsInteger;
    LabelSelecaoB.Text := FieldByName('NOME_SELECAO').AsString;;//'Sérvia';
    LabelJogosB.Text   := DM.mtTabelaGrupos.FieldByName('JOGOS').AsString + ' Jogos';//'3 Jogos';
    LabelPontosB.Text  := DM.mtTabelaGrupos.FieldByName('PONTOS').AsString + ' Pontos';//'8 Pontos';
    ImageB.Bitmap      := ImagesBandeiras.MultiResBitmap.Items[FieldByName('ID_SELECAO').AsInteger -1].Bitmap;

    Next;

    //Seleção C
    LayoutSelecaoC.Tag := FieldByName('ID_SELECAO').AsInteger;
    LabelSelecaoC.Text := FieldByName('NOME_SELECAO').AsString;;//'Suíça';
    LabelJogosC.Text   := DM.mtTabelaGrupos.FieldByName('JOGOS').AsString + ' Jogos';//'3 Jogos';
    LabelPontosC.Text  := DM.mtTabelaGrupos.FieldByName('PONTOS').AsString + ' Pontos';//'5 Pontos';
    ImageC.Bitmap      := ImagesBandeiras.MultiResBitmap.Items[FieldByName('ID_SELECAO').AsInteger -1].Bitmap;

    Next;

    //Seleção D
    LayoutSelecaoD.Tag := FieldByName('ID_SELECAO').AsInteger;
    LabelSelecaoD.Text := FieldByName('NOME_SELECAO').AsString;;//'Camarões';
    LabelJogosD.Text   := DM.mtTabelaGrupos.FieldByName('JOGOS').AsString + ' Jogos';//'3 Jogos';
    LabelPontosD.Text  := DM.mtTabelaGrupos.FieldByName('PONTOS').AsString + ' Pontos';//'1 Pontos';
    ImageD.Bitmap      := ImagesBandeiras.MultiResBitmap.Items[FieldByName('ID_SELECAO').AsInteger -1].Bitmap;

  end;

  ListTabela.AddObject(frameGrupo);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ListarTabelasGrupos;
end;

procedure TMainForm.Image5Click(Sender: TObject);
begin
  RectAposta.Visible := False;
end;

procedure TMainForm.ListarApostas;
begin
//  while ListApostas.ChildrenCount > 0 do
//    ListApostas.RemoveObject(0);
  AddAposta;
  AddAposta;
  AddAposta;
  AddAposta;
end;

procedure TMainForm.ListarPartidas;
begin
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
  AddPartida;
end;

procedure TMainForm.ListarRanking;
begin
  AddRanking('1', 'James Willian', '20 Pontos');
  AddRanking('2', 'Uma Pessoa', '18 Pontos');
  AddRanking('3', 'Outra Pessoa', '14 Pontos');
  AddRanking('4', 'Pessoa Sem Nome', '10 Pontos');
  AddRanking('5', 'Alguém', '9 Pontos');
  AddRanking('6', 'Desconhecido', '8 Pontos');
end;

procedure TMainForm.ListarTabelasGrupos;
begin

  DM.requestTabela;

  for var I := 1 to 8 do begin
    case I of
      1: AddTabGrupo('A');
      2: AddTabGrupo('B');
      3: AddTabGrupo('C');
      4: AddTabGrupo('D');
      5: AddTabGrupo('E');
      6: AddTabGrupo('F');
      7: AddTabGrupo('G');
      8: AddTabGrupo('H');
    end;
  end;

end;

procedure TMainForm.RectApostasTap(Sender: TObject; const Point: TPointF);
begin
  //Apostas
  ListarApostas;
  TabControl.GotoVisibleTab(2);
end;

procedure TMainForm.RectNovaApostaClick(Sender: TObject);
begin
  RectAposta.Visible := True;
end;

procedure TMainForm.RectPartidasTap(Sender: TObject; const Point: TPointF);
begin
  //Partidas
  ListarPartidas;
  TabControl.GotoVisibleTab(1);
end;

procedure TMainForm.RectRankingTap(Sender: TObject; const Point: TPointF);
begin
  //Ranking
  ListarRanking;
  TabControl.GotoVisibleTab(3);
end;

procedure TMainForm.RectTabelaTap(Sender: TObject; const Point: TPointF);
begin
  //Tabela
  ListarTabelasGrupos;
  TabControl.GotoVisibleTab(0);

end;

end.
