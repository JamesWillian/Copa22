object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 236
  Width = 510
  object mtTabelaGrupos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 96
    Top = 64
  end
  object mtPartidas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 64
    object mtPartidasID_PARTIDA: TIntegerField
      FieldName = 'ID_PARTIDA'
    end
    object mtPartidasID_SELECAO_A: TIntegerField
      FieldName = 'ID_SELECAO_A'
    end
    object mtPartidasNOME_SELECAO_A: TStringField
      FieldName = 'NOME_SELECAO_A'
    end
    object mtPartidasGOLS_SELECAO_A: TStringField
      FieldName = 'GOLS_SELECAO_A'
      Size = 2
    end
    object mtPartidasID_SELECAO_B: TIntegerField
      FieldName = 'ID_SELECAO_B'
    end
    object mtPartidasNOME_SELECAO_B: TStringField
      FieldName = 'NOME_SELECAO_B'
    end
    object mtPartidasGOLS_SELECAO_B: TStringField
      FieldName = 'GOLS_SELECAO_B'
      Size = 2
    end
    object mtPartidasFASE: TStringField
      FieldName = 'FASE'
      Size = 10
    end
    object mtPartidasDATA_HORA: TStringField
      FieldName = 'DATA_HORA'
      Size = 10
    end
    object mtPartidasPARTIDA_REALIZADA: TBooleanField
      FieldName = 'PARTIDA_REALIZADA'
    end
  end
  object mtApostas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 240
    Top = 64
  end
  object mtRanking: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 296
    Top = 64
  end
  object mtPartidas_Apostas: TFDMemTable
    IndexFieldNames = 'ID_PARTIDA'
    MasterSource = dtsPartidas
    MasterFields = 'ID_PARTIDA'
    DetailFields = 'ID_PARTIDA'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 152
    object mtPartidas_ApostasID_APOSTA: TIntegerField
      FieldName = 'ID_APOSTA'
    end
    object mtPartidas_ApostasID_USUARIO: TIntegerField
      FieldName = 'ID_USUARIO'
    end
    object mtPartidas_ApostasID_PARTIDA: TIntegerField
      FieldName = 'ID_PARTIDA'
    end
    object mtPartidas_ApostasGOLS_APOSTA_A: TIntegerField
      FieldName = 'GOLS_APOSTA_A'
    end
    object mtPartidas_ApostasGOLS_APOSTA_B: TIntegerField
      FieldName = 'GOLS_APOSTA_B'
    end
  end
  object dtsPartidas: TDataSource
    DataSet = mtPartidas
    Left = 176
    Top = 96
  end
end
