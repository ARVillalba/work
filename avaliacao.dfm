object FrmAVALIA: TFrmAVALIA
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ActionList1: TActionList
    Left = 504
    Top = 96
    object ActAddCliente: TAction
      Caption = 'ActAddCliente'
      OnExecute = ActAddClienteExecute
    end
    object ActAddVeiculo: TAction
      Caption = 'ActAddVeiculo'
      OnExecute = ActAddVeiculoExecute
    end
    object ActAddVendas: TAction
      Caption = 'ActAddVendas'
      OnExecute = ActAddVendasExecute
    end
    object ActExcluirVenda: TAction
      Caption = 'ActExcluirVenda'
      OnExecute = ActExcluirVendaExecute
    end
    object ActMareaQtd: TAction
      Caption = 'ActMareaQtd'
      OnExecute = ActMareaQtdExecute
    end
    object ActUnoQtd: TAction
      Caption = 'ActUnoQtd'
      OnExecute = ActUnoQtdExecute
    end
    object ActSemVenda: TAction
      Caption = 'ActSemVenda'
      OnExecute = ActSemVendaExecute
    end
    object ActSorteados: TAction
      Caption = 'ActSorteados'
      OnExecute = ActSorteadosExecute
    end
  end
end
