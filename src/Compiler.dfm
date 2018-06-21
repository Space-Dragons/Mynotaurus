object Form3: TForm3
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Form3'
  ClientHeight = 135
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 19
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 83
    Height = 19
    Caption = 'Compiling: '
  end
  object Label2: TLabel
    Left = 8
    Top = 40
    Width = 226
    Height = 19
    Caption = 'Expecting lines to be compiled: '
  end
  object Label3: TLabel
    Left = 8
    Top = 73
    Width = 94
    Height = 19
    Caption = 'Current line: '
  end
  object NameLabel: TLabel
    Left = 104
    Top = 8
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Expecting: TLabel
    Left = 240
    Top = 40
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object CurrentLine: TLabel
    Left = 108
    Top = 73
    Width = 5
    Height = 19
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 136
    Top = 102
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
  end
end
