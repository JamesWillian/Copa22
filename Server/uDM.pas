unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  DataSet.Serialize, System.JSON, FireDAC.DApt;

type
  TDM = class(TDataModule)
    Connection: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    function SQLToJSONArray(pSQL: String): TJSONArray;
    function SQLToJSONObject(pSQL: String): TJSONObject;
  public
    { Public declarations }
    function ListarTabelaGrupos: TJSONArray;
    function ListarPartidas(faseGrupo, idSelecao: String): TJSONArray;
    function ListarApostas(idUsuario: Integer): TJSONArray;
    function ListarRanking: TJSONArray;
    function PontosUsuario(idUsuario: Integer): TJSONObject;
    function InserirAposta(idPartida, golsApostaA, golsApostaB, idUsuario: Integer): TJSONObject;
    function AlterarAposta(idAposta, golsApostaA, golsApostaB: Integer): Boolean;
    function DeletarAposta(idAposta: Integer): Boolean;
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Connection.DriverName := 'FB';
  Connection.Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\COPA.FDB';

  Connection.Connected := true;
end;

function TDM.AlterarAposta(idAposta, golsApostaA,
  golsApostaB: Integer): Boolean;
begin

  Result := False;

  Connection.ExecSQL(
    'update APOSTAS '+
    'set GOLS_1 = '+golsApostaA.ToString+
    ',   GOLS_2 = '+golsApostaB.ToString+
    ' where (ID_APOSTA = '+idAposta.ToString+'); ');

  Result := True;

end;

function TDM.DeletarAposta(idAposta: Integer): Boolean;
begin

  Result := False;

  Connection.ExecSQL(
    'delete from APOSTAS '+
    ' where (ID_APOSTA = '+idAposta.ToString+'); ');

  Result := True;

end;

function TDM.ListarRanking: TJSONArray;
begin
  Result := SQLToJSONArray(
    'with PTS as (select U.USUARIO, sum( PONTOS_APOSTA(A.ID_APOSTA)) as PONTOS, count(A.ID_APOSTA) as N_APOSTAS '+
    '             from APOSTAS A '+
    '             inner join USUARIOS U on U.ID_USUARIO=A.ID_USUARIO '+
    '             group by U.USUARIO) '+
    'select '+
    ' rank() over(order by PTS.PONTOS desc, PTS.N_APOSTAS ) as POSICAO, '+
    ' PTS.USUARIO, '+
    ' PTS.PONTOS '+
    'from PTS; ');
end;

function TDM.InserirAposta(idPartida, golsApostaA, golsApostaB,
  idUsuario: Integer): TJSONObject;
begin
  if idPartida=0 then
    raise Exception.Create('Partida Inválida!');

  if idUsuario=0 then
    raise Exception.Create('Usuário Inválido!');

  Result := SQLToJSONObject(
    'insert into APOSTAS (ID_USUARIO, ID_PARTIDA, GOLS_1, GOLS_2) '+
    'values ('+idUsuario.ToString+', '+idPartida.ToString+', '+golsApostaA.ToString+', '+golsApostaB.ToString+') '+
    'returning ID_APOSTA ');
end;

function TDM.ListarApostas(idUsuario: Integer): TJSONArray;
begin
  Result := SQLToJSONArray(
    'select '+
    ' A.ID_APOSTA, '+
    ' A.ID_PARTIDA, '+
    ' P.ID_SELECAO_1 as ID_SELECAO_A, '+
    ' S1.SELECAO as NOME_SELECAO_A, '+
    ' A.GOLS_1 as GOLS_APOSTA_A, '+
    ' P.GOLS_1 as GOLS_PARTIDA_A, '+
    ' S2.ID_SELECAO as ID_SELECAO_B, '+
    ' S2.SELECAO as NOME_SELECAO_B, '+
    ' A.GOLS_2 as GOLS_APOSTA_B, '+
    ' P.GOLS_2 as GOLS_PARTIDA_B, '+
    ' P.FASE as GRUPO_FASE, '+
    ' (lpad(extract(day from P.DATA),2,''0'')||''-''||extract(month from P.DATA)) as DATA, '+
    ' extract(hour from P.HORA)||''h'' as HORA, '+
    ' PONTOS_APOSTA(A.ID_APOSTA) as PONTOS '+
    'from APOSTAS A '+
    'inner join PARTIDAS P on P.ID_PARTIDA=A.ID_PARTIDA '+
    'inner join SELECOES S1 on S1.ID_SELECAO=P.ID_SELECAO_1 '+
    'inner join SELECOES S2 on S2.ID_SELECAO=P.ID_SELECAO_2 '+
    'where A.ID_USUARIO='+idUsuario.ToString);
end;

function TDM.ListarPartidas(faseGrupo, idSelecao: String): TJSONArray;
begin
  var vSQL :=
    'select P.ID_PARTIDA, '+
    ' S1.ID_SELECAO as ID_SELECAO_A, S1.SELECAO as NOME_SELECAO_A, coalesce(P.GOLS_1, ''--'') as GOLS_SELECAO_A, '+
    ' S2.ID_SELECAO as ID_SELECAO_B, S2.SELECAO as NOME_SELECAO_B, coalesce(P.GOLS_2, ''--'') as GOLS_SELECAO_B, '+
    ' P.FASE, (lpad(extract(day from P.DATA),2,''0'')||''-''||extract(month from P.DATA)||'' ''|| extract(hour from P.HORA)||''h'') as DATA_HORA '+
    'from PARTIDAS P '+
    'inner join SELECOES S1 on S1.ID_SELECAO=P.ID_SELECAO_1 '+
    'inner join SELECOES S2 on S2.ID_SELECAO=P.ID_SELECAO_2 '+
    'where ((p.ID_SELECAO_1 = '+idSelecao+' or P.ID_SELECAO_2 = '+idSelecao+') or (0='+idSelecao+')) ';

    if faseGrupo<>'' then    
    case StrToInt(faseGrupo[1]) of
      0: vSQL := vSQL+' and (P.FASE starting with ''Grupo''); ';
      1: vSQL := vSQL+' and not(P.FASE starting with ''Grupo''); ';
      else vSQL := vSQL+' and (P.FASE = '+faseGrupo.QuotedString+'); ';
    end;

  Result := SQLToJSONArray(vSQL);
end;

function TDM.ListarTabelaGrupos: TJSONArray;
begin
  Result := SQLToJSONArray(
    'select TG.GRUPO, TG.ID_SELECAO, TG.SELECAO as NOME_SELECAO, TG.JOGOS, TG.PONTOS '+
    'from TABELA_GRUPOS TG '+
    'order by TG.GRUPO, TG.PONTOS desc, TG.JOGOS;');
end;

function TDM.PontosUsuario(idUsuario: Integer): TJSONObject;
begin
  Result := SQLToJSONObject(
    'select sum( PONTOS_APOSTA(A.ID_APOSTA)) as PONTOS '+
    'from APOSTAS A '+
    'inner join USUARIOS U on U.ID_USUARIO=A.ID_USUARIO '+
    'where U.ID_USUARIO='+idUsuario.ToString);
end;

function TDM.SQLToJSONArray(pSQL: String): TJSONArray;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Connection;

    with qry do begin
      Close;
      SQL.Clear;
      SQL.Text := pSQL;
      Open;
    end;

    Result := qry.ToJSONArray;
  finally
    qry.Free;
  end;

end;

function TDM.SQLToJSONObject(pSQL: String): TJSONObject;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Connection;

    with qry do begin
      Close;
      SQL.Clear;
      SQL.Text := pSQL;
      Open;
    end;

    Result := qry.ToJSONObject;
  finally
    qry.Free;
  end;
end;

end.
