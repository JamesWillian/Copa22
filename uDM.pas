unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  RESTRequest4D, FMX.Dialogs;

type
  TDM = class(TDataModule)
    mtTabelaGrupos: TFDMemTable;
    mtPartidas: TFDMemTable;
  private
    { Private declarations }
    const BASE_URL = 'http://10.0.0.115:9000';
  public
    { Public declarations }

    procedure requestTabela;
    procedure requestPartidas(grupoFase, idSelecao: String);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDM }

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
