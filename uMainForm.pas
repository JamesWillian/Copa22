unit uMainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Layouts, FMX.Objects, FMX.ListView, FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.TabControl, uDM, System.ImageList, FMX.ImgList,
  uCombobox, System.StrUtils;

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
    procedure FormCreate(Sender: TObject);
    procedure LabelFiltroGruposClick(Sender: TObject);
    procedure LabelFiltroSelecaoClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }

    comboFase: TCustomCombo;
    comboSelecao: TCustomCombo;

    procedure DeleteVScrollBoxItems(VSBox: TVertScrollBox; index: Integer = -1);
    procedure ItemFaseClick(Sender: TObject; const Point: TPointF);
    procedure ItemSelecaoClick(Sender: TObject; const Point: TPointF);
  public
    { Public declarations }

    procedure ListarTabelasGrupos;
    procedure AddTabGrupo(grupo: String);

    procedure ListarPartidas;
    procedure AddPartida(idPartida: Integer; idSelecaoA, nomeSelecaoA, golsSelecaoA,
  idSelecaoB, nomeSelecaoB, golsSelecaoB, fase, dataHora: String);

    procedure ListarApostas;
    procedure AddAposta(idAposta, idPartida: Integer;
        idSelecaoA, nomeSelecaoA, golsApostaA, golsPartidaA,
        idSelecaoB, nomeSelecaoB, golsApostaB, golsPartidaB,
        grupoFase, dataPartida, horaPartida, pontos: String);

    procedure ListarRanking;
    procedure AddRanking(posicao, nome, pontos: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  uFramePartidas, uFrameApostas, uFrameGrupos;

procedure TMainForm.AddAposta(idAposta, idPartida: Integer;
        idSelecaoA, nomeSelecaoA, golsApostaA, golsPartidaA,
        idSelecaoB, nomeSelecaoB, golsApostaB, golsPartidaB,
        grupoFase, dataPartida, horaPartida, pontos: String);
var
  frameAposta: TFrameApostas;
begin
  frameAposta := TFrameApostas.Create(nil);

  with frameAposta do begin
    Align := TAlignLayout.Top;
    Position.Y := 1000;

    ImageSelecaoA.Bitmap := ImagesBandeiras.MultiResBitmap.Items[idSelecaoA.ToInteger -1].Bitmap;
    ImageSelecaoB.Bitmap := ImagesBandeiras.MultiResBitmap.Items[idSelecaoB.ToInteger -1].Bitmap;

    Tag := idAposta;
    LabelSelecaoA.TagString := idSelecaoA;
    LabelSelecaoA.Text := nomeSelecaoA;
    LabelGolA.Text := golsApostaA;

    LabelResultPartida.Text := IfThen(golsPartidaA='','','Resultado: ' + golsPartidaA + ' x ' + golsPartidaB);

    LabelSelecaoB.TagString := idSelecaoB;
    LabelSelecaoB.Text := nomeSelecaoB;
    LabelGolB.Text := golsApostaB;

    LabelFase.Text := grupoFase;
    LabelData.Text := dataPartida;
    LabelHora.Text := horaPartida;
    LabelPontosPartida.Text := IfThen(pontos='','','+'+pontos+' Ponto'+IfThen(pontos='3','s',''));

    case StrToInt(pontos) of
      0,1: begin
        LabelPontosPartida.TextSettings.FontColor := TAlphaColorRec.Midnightblue;
        RectCor.Fill.Color := TAlphaColorRec.Red;
      end;
      3: begin
        LabelPontosPartida.TextSettings.FontColor := TAlphaColorRec.Goldenrod;
        RectCor.Fill.Color := TAlphaColorRec.Limegreen;
      end;
    end;

    RectButtonAberto.Visible := (LabelResultPartida.Text = '');
    LabelPontosPartida.Visible := (StrToInt(pontos)>0);

    if RectButtonAberto.Visible then
      RectCor.Fill.Color := TAlphaColorRec.Darkgray;

  end;

  ListApostas.AddObject(frameAposta);

end;

procedure TMainForm.AddPartida(idPartida: Integer; idSelecaoA, nomeSelecaoA, golsSelecaoA,
  idSelecaoB, nomeSelecaoB, golsSelecaoB, fase, dataHora: String);
var
  framePartida: TFramePartidas;
begin
  framePartida := TFramePartidas.Create(nil);

  with framePartida do begin
    Align := TAlignLayout.Top;
    Position.Y := 1000;

    ImageSelecaoA.Bitmap := ImagesBandeiras.MultiResBitmap.Items[idSelecaoA.ToInteger -1].Bitmap;
    ImageSelecaoB.Bitmap := ImagesBandeiras.MultiResBitmap.Items[idSelecaoB.ToInteger -1].Bitmap;

    Tag := idPartida;
    LabelSelecaoA.TagString := idSelecaoA;
    LabelSelecaoA.Text := nomeSelecaoA;
    LabelGolA.Text := golsSelecaoA;
    LabelSelecaoB.TagString := idSelecaoB;
    LabelSelecaoB.Text := nomeSelecaoB;
    LabelGolB.Text := golsSelecaoB;
    LabelFase.Text := fase;
    LabelDataHora.Text := dataHora;

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

procedure TMainForm.DeleteVScrollBoxItems(VSBox: TVertScrollBox; index: Integer = -1);
begin
  try
    VSBox.BeginUpdate;

    if index >= 0 then
      TFrame(VSBox.Content.Children[index]).DisposeOf
    else
      for index := VSBox.Content.ChildrenCount -1 downto 0 do
        TFrame(VSBox.Content.Children[index]).DisposeOf;

  finally
    VSBox.EndUpdate;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  comboFase := TCustomCombo.Create(Self);
  comboSelecao := TCustomCombo.Create(Self);

  //GRUPOS
  comboFase.TitleMenuText := 'Selecione o Grupo ou Fase que deseja filtrar';
  comboFase.BackgroundColor := $FFF2F2F8;
  comboFase.OnClick := ItemFaseClick;

  comboFase.AddItem('0', 'Todos Grupos');
  comboFase.AddItem('A', 'Grupo A');
  comboFase.AddItem('B', 'Grupo B');
  comboFase.AddItem('C', 'Grupo C');
  comboFase.AddItem('D', 'Grupo D');
  comboFase.AddItem('E', 'Grupo E');
  comboFase.AddItem('F', 'Grupo F');
  comboFase.AddItem('G', 'Grupo G');
  comboFase.AddItem('H', 'Grupo H');

  //SELEÇÕES
  comboSelecao.TitleMenuText := 'Selecione a Seleção que deseja filtrar';
  comboSelecao.BackgroundColor := $FFF2F2F8;
  comboSelecao.OnClick := ItemSelecaoClick;

  comboSelecao.AddItem('0', 'Todas Seleções');
  comboSelecao.AddItem('1', 'Catar');
  comboSelecao.AddItem('2', 'Equador');
  comboSelecao.AddItem('3', 'Senegal');
  comboSelecao.AddItem('4', 'Holanda');
  comboSelecao.AddItem('5', 'Inglaterra');
  comboSelecao.AddItem('6', 'Irã');
  comboSelecao.AddItem('7', 'Estados Unidos');
  comboSelecao.AddItem('8', 'País de Gales');
  comboSelecao.AddItem('9', 'Argentina');
  comboSelecao.AddItem('10', 'Arábia Saudita');
  comboSelecao.AddItem('11', 'México');
  comboSelecao.AddItem('12', 'Polônia');
  comboSelecao.AddItem('13', 'França');
  comboSelecao.AddItem('14', 'Austrália');
  comboSelecao.AddItem('15', 'Dinamarca');
  comboSelecao.AddItem('16', 'Tunísia');
  comboSelecao.AddItem('17', 'Espanha');
  comboSelecao.AddItem('18', 'Costa Rica');
  comboSelecao.AddItem('19', 'Alemanha');
  comboSelecao.AddItem('20', 'Japão');
  comboSelecao.AddItem('21', 'Bélgica');
  comboSelecao.AddItem('22', 'Canadá');
  comboSelecao.AddItem('23', 'Marrocos');
  comboSelecao.AddItem('24', 'Croácia');
  comboSelecao.AddItem('25', 'Brasil');
  comboSelecao.AddItem('26', 'Sérvia');
  comboSelecao.AddItem('27', 'Suíça');
  comboSelecao.AddItem('28', 'Camarões');
  comboSelecao.AddItem('29', 'Portugal');
  comboSelecao.AddItem('30', 'Gana');
  comboSelecao.AddItem('31', 'Uruguai');
  comboSelecao.AddItem('32', 'Coreia do Sul');

  LabelFiltroGrupos.TagString := '0';
  LabelFiltroSelecao.TagString := '0';

end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  comboFase.DisposeOf;
  comboSelecao.DisposeOf;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  LabelPontos.Text := IntToStr(DM.requestPontosUser)+' Pontos';

  ListarTabelasGrupos;
end;

procedure TMainForm.Image5Click(Sender: TObject);
begin
  RectAposta.Visible := False;
end;

procedure TMainForm.ItemFaseClick(Sender: TObject; const Point: TPointF);
begin
  comboFase.HideMenu;

  LabelFiltroGrupos.TagString := comboFase.CodItem;
  LabelFiltroGrupos.Text := comboFase.DescrItem + ' ▼';
  ListarPartidas;
end;

procedure TMainForm.ItemSelecaoClick(Sender: TObject; const Point: TPointF);
begin
  comboSelecao.HideMenu;

  LabelFiltroSelecao.TagString := comboSelecao.CodItem;
  LabelFiltroSelecao.Text := comboSelecao.DescrItem + ' ▼';
  ListarPartidas;
end;

procedure TMainForm.LabelFiltroGruposClick(Sender: TObject);
begin
  comboFase.ShowMenu;
end;

procedure TMainForm.LabelFiltroSelecaoClick(Sender: TObject);
begin
  comboSelecao.ShowMenu;
end;

procedure TMainForm.ListarApostas;
var
  t: TThread;
begin
  DeleteVScrollBoxItems(ListApostas);

  t := TThread.CreateAnonymousThread(procedure
  begin
    DM.requestApostas;

    ListApostas.BeginUpdate;

    with DM.mtApostas do begin
      while not eof do begin
        AddAposta(FieldByName('ID_APOSTA').AsInteger,
                  FieldByName('ID_PARTIDA').AsInteger,
                  FieldByName('ID_SELECAO_A').AsString,
                  FieldByName('NOME_SELECAO_A').AsString,
                  FieldByName('GOLS_APOSTA_A').AsString,
                  FieldByName('GOLS_PARTIDA_A').AsString,
                  FieldByName('ID_SELECAO_B').AsString,
                  FieldByName('NOME_SELECAO_B').AsString,
                  FieldByName('GOLS_APOSTA_B').AsString,
                  FieldByName('GOLS_PARTIDA_B').AsString,
                  FieldByName('GRUPO_FASE').AsString,
                  FieldByName('DATA').AsString,
                  FieldByName('HORA').AsString,
                  FieldByName('PONTOS').AsString);
        Next;
      end;
    end;
    ListApostas.EndUpdate;
  end);

  t.Start;
end;

procedure TMainForm.ListarPartidas;
var
  t: TThread;
begin
  DeleteVScrollBoxItems(ListPartidas);

  t := TThread.CreateAnonymousThread(procedure
  begin
    DM.requestPartidas(LabelFiltroGrupos.TagString, LabelFiltroSelecao.TagString);

    ListPartidas.BeginUpdate;

    with DM.mtPartidas do begin
      if not IsEmpty then begin
        while not eof do begin
          AddPartida(FieldByName('ID_PARTIDA').AsInteger,
                     FieldByName('ID_SELECAO_A').AsString,
                     FieldByName('NOME_SELECAO_A').AsString,
                     FieldByName('GOLS_SELECAO_A').AsString,
                     FieldByName('ID_SELECAO_B').AsString,
                     FieldByName('NOME_SELECAO_B').AsString,
                     FieldByName('GOLS_SELECAO_B').AsString,
                     FieldByName('FASE').AsString,
                     FieldByName('DATA_HORA').AsString);
          Next;
        end;
      end;
    end;

    ListPartidas.EndUpdate;
  end);

  t.Start;
end;

procedure TMainForm.ListarRanking;
begin
  ListRanking.Items.Clear;

  AddRanking('1', 'James Willian', '20 Pontos');
  AddRanking('2', 'Uma Pessoa', '18 Pontos');
  AddRanking('3', 'Outra Pessoa', '14 Pontos');
  AddRanking('4', 'Pessoa Sem Nome', '10 Pontos');
  AddRanking('5', 'Alguém', '9 Pontos');
  AddRanking('6', 'Desconhecido', '8 Pontos');
end;

procedure TMainForm.ListarTabelasGrupos;
var
  t: TThread;
begin
  DeleteVScrollBoxItems(ListTabela);

  t := TThread.CreateAnonymousThread(procedure
  begin
    DM.requestTabela;

    ListTabela.BeginUpdate;
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
    ListTabela.EndUpdate;
  end);

  t.Start;

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
