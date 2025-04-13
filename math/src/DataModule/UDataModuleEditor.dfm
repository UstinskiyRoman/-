object DataModuleEditor: TDataModuleEditor
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 84
  Width = 272
  object ADOQuery1: TADOQuery
    Parameters = <>
    Left = 184
    Top = 24
  end
  object ADOQueryEditor: TADOQuery
    Connection = DataModuleBase.ADOConnectionBase
    Parameters = <>
    Left = 56
    Top = 24
  end
end
