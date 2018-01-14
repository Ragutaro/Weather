object frmMain: TfrmMain
  Left = 321
  Top = 283
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #26426#19978#20104#22577#12398#12496#12540#12472#12519#12531#21462#24471
  ClientHeight = 262
  ClientWidth = 294
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 18
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 29
    Height = 18
    Caption = '64bit'
  end
  object Label2: TLabel
    Left = 16
    Top = 60
    Width = 29
    Height = 18
    Caption = '32bit'
  end
  object lblInfo: TLabel
    Left = 14
    Top = 236
    Width = 265
    Height = 18
    AutoSize = False
  end
  object edt64: TEdit
    Left = 60
    Top = 21
    Width = 201
    Height = 26
    TabOrder = 0
  end
  object edt32: TEdit
    Left = 60
    Top = 57
    Width = 201
    Height = 26
    TabOrder = 1
  end
  object btnGet: TButton
    Left = 102
    Top = 205
    Width = 75
    Height = 25
    Caption = #21462#24471
    TabOrder = 3
    OnClick = btnGetClick
  end
  object memVerup: TMemo
    Left = 14
    Top = 96
    Width = 267
    Height = 103
    TabOrder = 2
  end
end
