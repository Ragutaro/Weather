object frmVerUp: TfrmVerUp
  Left = 321
  Top = 466
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #26356#26032#12398#30906#35469
  ClientHeight = 91
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  Scaled = False
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 18
  object lblInfo: TLabel
    Left = 16
    Top = 12
    Width = 36
    Height = 18
    Caption = 'lblInfo'
  end
  object btnGet: TButton
    Left = 225
    Top = 58
    Width = 75
    Height = 25
    Caption = #21462#24471#12377#12427
    TabOrder = 0
    OnClick = btnGetClick
  end
  object btnClose: TButton
    Left = 313
    Top = 58
    Width = 75
    Height = 25
    Caption = #38281#12376#12427
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
