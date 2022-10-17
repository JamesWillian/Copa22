object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 189
  Width = 300
  object Connection: TFDConnection
    Params.Strings = (
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'Server=localhost'
      'DriverID=FB')
    LoginPrompt = False
    Left = 136
    Top = 56
  end
end
