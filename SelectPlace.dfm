object frmSelectPlace: TfrmSelectPlace
  Left = 333
  Top = 292
  BorderIcons = [biSystemMenu]
  Caption = #22320#22495#12398#36984#25246
  ClientHeight = 358
  ClientWidth = 269
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
    269
    358)
  PixelsPerInch = 96
  TextHeight = 18
  object lblInfo: TLabel
    Left = 12
    Top = 322
    Width = 162
    Height = 18
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    ExplicitTop = 218
  end
  object btnCancel: TButton
    Left = 186
    Top = 320
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #38281#12376#12427
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object pagRegion: TPageControl
    Left = 0
    Top = 0
    Width = 269
    Height = 311
    ActivePage = tabYahoo
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    ExplicitHeight = 207
    object tabYahoo: TTabSheet
      Caption = 'Yahoo!'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object tvwList: THideTreeView
        Left = 0
        Top = 0
        Width = 261
        Height = 278
        Cursor = crHandPoint
        Align = alClient
        HotTrack = True
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnCreateNodeClass = tvwListCreateNodeClass
        OnCustomDrawItem = tvwListCustomDrawItem
        OnDblClick = tvwListDblClick
        OnMouseMove = tvwListMouseMove
        Items.NodeData = {
          0301000000220000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          000000000001026851FD56}
        ExplicitTop = -31
        ExplicitHeight = 205
      end
    end
    object tabTenkiJp: TTabSheet
      Caption = 'tenki.jp'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      DesignSize = (
        261
        278)
      object tvwTenki: THideTreeView
        Left = 0
        Top = 0
        Width = 261
        Height = 249
        Cursor = crHandPoint
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        HotTrack = True
        Indent = 19
        ReadOnly = True
        TabOrder = 0
        OnCreateNodeClass = tvwListCreateNodeClass
        OnCustomDrawItem = tvwListCustomDrawItem
        OnDblClick = tvwTenkiDblClick
        OnMouseMove = tvwTenkiMouseMove
        Items.NodeData = {
          0301000000220000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          000000000001026851FD56}
      end
      object rad3h: TRadioButton
        Left = 8
        Top = 256
        Width = 101
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = '3'#26178#38291#20104#22577
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rad1h: TRadioButton
        Left = 112
        Top = 256
        Width = 113
        Height = 17
        Anchors = [akLeft, akBottom]
        Caption = '1'#26178#38291#20104#22577
        TabOrder = 2
      end
    end
  end
end
