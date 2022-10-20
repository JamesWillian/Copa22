unit Controller;

interface

uses
  Horse,
  Horse.Jhonson,
  uDM,
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.StrUtils,
  System.Variants;

  procedure Registry;
  procedure GetTabela(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure GetPartidas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure GetApostas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure GetRanking(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure GetPontosUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

  procedure PostAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure PutAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
  procedure DeleteAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Registry;
begin
  THorse.Get('/tabela', GetTabela);
  THorse.Get('/partidas', GetPartidas);
  THorse.Get('/apostas/:idUsuario', GetApostas);
  THorse.Get('/ranking', GetRanking);
  THorse.Get('/pontos/:idUsuario', GetPontosUsuario);

  THorse.Post('/aposta', PostAposta);

  THorse.Put('/aposta', PutAposta);

  THorse.Delete('/aposta/:idAposta', DeleteAposta);
end;

procedure GetTabela(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try

      Res.Send<TJSONArray>(dataModule.ListarTabelaGrupos).Status(200);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure GetPartidas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var grupoFase := Req.Query['grupoFase'];
      var idSelecao := Req.Query['idSelecao'];

//      idSelecao := ifThen(idSelecao='','0',idSelecao);

      Res.Send<TJSONArray>(dataModule.ListarPartidas(grupoFase, idSelecao)).Status(200);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure GetApostas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var idUsuario := Req.Params['idUsuario'].ToInteger;

      Res.Send<TJSONArray>(dataModule.ListarApostas(idUsuario)).Status(200);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure GetRanking(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try

      Res.Send<TJSONArray>(dataModule.ListarRanking).Status(200);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure GetPontosUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var idUsuario := Req.Params['idUsuario'].ToInteger;

      Res.Send<TJSONObject>(dataModule.PontosUsuario(idUsuario)).Status(200);
    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure PostAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var body := Req.Body<TJSONObject>;
      var idPartida := body.GetValue<Integer>('idPartida', 0);
      var golsApostaA := body.GetValue<Integer>('golsApostaA', 0);
      var golsApostaB := body.GetValue<Integer>('golsApostaB', 0);
      var idUsuario := body.GetValue<Integer>('idUsuario', 0);

      Res.Send<TJSONObject>(dataModule.InserirAposta(idPartida, golsApostaA, golsApostaB, idUsuario)).Status(201);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure PutAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var body := Req.Body<TJSONObject>;
      var idAposta := body.GetValue<Integer>('idAposta', 0);
      var golsApostaA := body.GetValue<Integer>('golsApostaA', 0);
      var golsApostaB := body.GetValue<Integer>('golsApostaB', 0);

      if dataModule.AlterarAposta(idAposta, golsApostaA, golsApostaB) then
        Res.Send('Alterado!').Status(201);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

procedure DeleteAposta(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  dataModule: TDM;
begin
  dataModule := TDM.Create(nil);
  try
    try
      var idAposta := Req.Params['idAposta'].ToInteger;

      if dataModule.DeletarAposta(idAposta) then
        Res.Send('Deletado!').Status(200);

    except on E:Exception do

      Res.Send(E.Message).Status(500);

    end;
  finally
    FreeAndNil(dataModule);
  end;
end;

end.

