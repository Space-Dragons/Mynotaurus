object WaiterForm: TWaiterForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'WaiterForm'
  ClientHeight = 67
  ClientWidth = 265
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object Identifier: TLabel
    Left = 8
    Top = 8
    Width = 78
    Height = 18
    Caption = 'Some text: '
  end
  object Counter: TLabel
    Left = 198
    Top = 8
    Width = 51
    Height = 18
    Alignment = taRightJustify
    Caption = 'Counter'
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 42
    Width = 241
    Height = 17
    TabOrder = 0
  end
end
