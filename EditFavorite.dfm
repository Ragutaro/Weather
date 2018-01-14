object frmEditFavorite: TfrmEditFavorite
  Left = 324
  Top = 457
  BorderIcons = [biSystemMenu]
  Caption = #12362#27671#12395#20837#12426#12398#32232#38598
  ClientHeight = 200
  ClientWidth = 310
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
  DesignSize = (
    310
    200)
  PixelsPerInch = 96
  TextHeight = 18
  object lvwList: THideListView
    Left = 0
    Top = 0
    Width = 219
    Height = 200
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #22320#22495#21517
        Width = 200
      end>
    ColumnClick = False
    TabOrder = 0
    ViewStyle = vsReport
    OnCreateItemClass = lvwListCreateItemClass
    SortOrder = soAscending
    WrapAround = False
    DefaultSortOrder = soAscending
  end
  object btnDelete: TButton
    Left = 225
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #21066#38500
    TabOrder = 1
    OnClick = btnDeleteClick
  end
  object btnCancel: TButton
    Left = 225
    Top = 167
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 225
    Top = 136
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnUp: TButton
    Left = 225
    Top = 46
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #9650
    TabOrder = 2
    OnClick = btnUpClick
  end
  object btnDown: TButton
    Left = 225
    Top = 77
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #9660
    TabOrder = 3
    OnClick = btnDownClick
  end
end
