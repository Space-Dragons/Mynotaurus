object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 305
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = Menu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Menu: TMainMenu
    Left = 384
    Top = 16
    object Field1: TMenuItem
      Caption = 'Field'
      object Hidenonblocking1: TMenuItem
        Caption = 'Hide non blocking'
        OnClick = Hidenonblocking1Click
      end
      object Shownonblocking1: TMenuItem
        Caption = 'Show non blocking'
        OnClick = Shownonblocking1Click
      end
      object Savetofielddumpbin1: TMenuItem
        Caption = 'Save to "field_dump.bin"'
        OnClick = Savetofielddumpbin1Click
      end
      object Loadfromfielddumpbin1: TMenuItem
        Caption = 'Load from "field_dump.bin"'
        OnClick = Loadfromfielddumpbin1Click
      end
      object Createnewfield1: TMenuItem
        Caption = 'Create new field (8x8)'
        OnClick = Createnewfield1Click
      end
      object Createnewcustomfield1: TMenuItem
        Caption = 'Create new custom field...'
        OnClick = Createnewcustomfield1Click
      end
    end
    object oCode1: TMenuItem
      Caption = 'To Code'
      object oCodeC1: TMenuItem
        Caption = 'To Code (C#)'
        OnClick = oCodeC1Click
      end
    end
  end
end
