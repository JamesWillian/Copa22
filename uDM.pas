unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, System.JSON, FMX.Dialogs;

type
  TDM = class(TDataModule)
    mtTabelaGrupos: TFDMemTable;
    mtPartidas: TFDMemTable;
    mtApostas: TFDMemTable;
    mtRanking: TFDMemTable;
    mtPartidas_Apostas: TFDMemTable;
    mtPartidas_ApostasID_APOSTA: TIntegerField;
    mtPartidas_ApostasID_USUARIO: TIntegerField;
    mtPartidas_ApostasID_PARTIDA: TIntegerField;
    mtPartidas_ApostasGOLS_APOSTA_A: TIntegerField;
    mtPartidas_ApostasGOLS_APOSTA_B: TIntegerField;
    dtsPartidas: TDataSource;
    mtPartidasID_PARTIDA: TIntegerField;
    mtPartidasID_SELECAO_A: TIntegerField;
    mtPartidasID_SELECAO_B: TIntegerField;
    mtPartidasDATA_HORA: TStringField;
    mtPartidasFASE: TStringField;
    mtPartidasNOME_SELECAO_A: TStringField;
    mtPartidasNOME_SELECAO_B: TStringField;
    mtPartidasGOLS_SELECAO_A: TStringField;
    mtPartidasGOLS_SELECAO_B: TStringField;
    mtPartidasPARTIDA_REALIZADA: TBooleanField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    const BASE_URL = 'http://10.0.0.115:9000';

  public
    { Public declarations }
    var idUsuario: Integer;

    procedure requestTabela;
    procedure requestPartidas(grupoFase, idSelecao: String);
    procedure requestApostas;
    procedure requestRanking;
    function requestPontosUser: Integer;
    procedure postAposta(idPartida, golsA, golsB: Integer);
    procedure putAposta(idAposta, golsA, golsB: Integer);
    procedure deleteAposta(idAposta: String);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  idUsuario := 1;
end;

procedure TDM.deleteAposta(idAposta: String);
var
  Resp: IResponse;
begin

  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('aposta')
            .ResourceSuffix(idAposta)
            .Accept('application/json')
            .Delete;

end;

procedure TDM.postAposta(idPartida, golsA, golsB: Integer);
var
  Resp: IResponse;
  body: TJSONObject;
begin
  body := TJSONObject.Create;
  body.AddPair('idPartida', TJSONNumber.Create(idPartida));
  body.AddPair('golsApostaA', TJSONNumber.Create(golsA));
  body.AddPair('golsApostaB', TJSONNumber.Create(golsB));
  body.AddPair('idUsuario', TJSONNumber.Create(idUsuario));

  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('aposta')
            .AddBody(body)
            .Accept('application/json')
            .Post;
end;

procedure TDM.putAposta(idAposta, golsA, golsB: Integer);
var
  Resp: IResponse;
  body: TJSONObject;
begin
  body := TJSONObject.Create;
  body.AddPair('idAposta', TJSONNumber.Create(idAposta));
  body.AddPair('golsApostaA', TJSONNumber.Create(golsA));
  body.AddPair('golsApostaB', TJSONNumber.Create(golsB));

  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('aposta')
            .AddBody(body)
            .Accept('application/json')
            .Put;
end;

procedure TDM.requestApostas;
var
  Resp: IResponse;
begin
  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('/apostas')
            .ResourceSuffix(idUsuario.ToString)
            .DataSetAdapter(mtApostas)
            .Accept('application/json')
            .Get;

  if Resp.StatusCode <> 200 then
    raise Exception.Create(Resp.Content);

end;

procedure TDM.requestPartidas(grupoFase, idSelecao: String);
var
  Resp: IResponse;
begin
  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('/partidas')
            .AddParam('grupoFase',grupoFase)
            .AddParam('idSelecao',idSelecao)
            .DataSetAdapter(mtPartidas)
            .Accept('application/json')
            .Get;

  if Resp.StatusCode <> 200 then
    raise Exception.Create(Resp.Content);

end;

function TDM.requestPontosUser: Integer;
var
  Resp: IResponse;
begin
  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('/pontos')
            .ResourceSuffix(idUsuario.ToString)
            .Accept('application/json')
            .Get;

  if Resp.StatusCode <> 200 then
    raise Exception.Create(Resp.Content);

  Result := Resp.JSONValue.GetValue<Integer>('pontos');

end;

procedure TDM.requestRanking;
var
  Resp: IResponse;
begin
  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('/ranking')
            .DataSetAdapter(mtRanking)
            .Accept('application/json')
            .Get;

  if Resp.StatusCode <> 200 then
    raise Exception.Create(Resp.Content);

end;

procedure TDM.requestTabela;
var
  Resp: IResponse;
begin
  Resp := TRequest.New.BaseURL(BASE_URL)
            .Resource('/tabela')
            .DataSetAdapter(mtTabelaGrupos)
            .Accept('application/json')
            .Get;

  if Resp.StatusCode <> 200 then
    raise Exception.Create(Resp.Content);

end;

end.
