object frmOption: TfrmOption
  Left = 367
  Top = 248
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #12458#12503#12471#12519#12531#35373#23450
  ClientHeight = 436
  ClientWidth = 665
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
    665
    436)
  PixelsPerInch = 96
  TextHeight = 18
  object btnOK: TButton
    Left = 404
    Top = 403
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 580
    Top = 403
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 649
    Height = 385
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #12473#12461#12531
      object imgSkin: TImage
        Left = 10
        Top = 12
        Width = 280
        Height = 280
      end
      object Label4: TLabel
        Left = 310
        Top = 15
        Width = 29
        Height = 18
        Caption = #21517#31216':'
      end
      object Label9: TLabel
        Left = 310
        Top = 57
        Width = 65
        Height = 18
        Caption = #12501#12457#12531#12488#21517':'
      end
      object Label10: TLabel
        Left = 310
        Top = 98
        Width = 41
        Height = 18
        Caption = #12469#12452#12474':'
      end
      object Label1: TLabel
        Left = 310
        Top = 144
        Width = 36
        Height = 18
        Caption = #22522#26412#33394
      end
      object Label7: TLabel
        Left = 496
        Top = 144
        Width = 72
        Height = 18
        Caption = #36942#21435#12398#26178#38291#24111
      end
      object Label3: TLabel
        Left = 495
        Top = 210
        Width = 48
        Height = 18
        Caption = #26368#20302#27671#28201
      end
      object Label2: TLabel
        Left = 310
        Top = 210
        Width = 48
        Height = 18
        Caption = #26368#39640#27671#28201
      end
      object Label5: TLabel
        Left = 310
        Top = 244
        Width = 60
        Height = 18
        Caption = #20170#26085#12398#22825#27671
      end
      object Label6: TLabel
        Left = 495
        Top = 244
        Width = 60
        Height = 18
        Caption = #26126#26085#12398#22825#27671
      end
      object Label11: TLabel
        Left = 496
        Top = 176
        Width = 24
        Height = 18
        Caption = #26085#20184
      end
      object Label12: TLabel
        Left = 310
        Top = 176
        Width = 24
        Height = 18
        Caption = #26178#38291
      end
      object imgFront: TImage
        Left = 10
        Top = 12
        Width = 280
        Height = 280
        PopupMenu = popImg
      end
      object shaToday: TShape
        Left = 10
        Top = 91
        Width = 120
        Height = 1
        Pen.Color = clFuchsia
      end
      object shaTomorrow: TShape
        Left = 130
        Top = 91
        Width = 80
        Height = 1
      end
      object Label17: TLabel
        Left = 308
        Top = 278
        Width = 126
        Height = 18
        Caption = #26126#24460#26085#12398#22825#27671'(tenki.jp)'
      end
      object shaAfterTomorrow: TShape
        Left = 210
        Top = 91
        Width = 80
        Height = 1
      end
      object cmbSkin: THideComboBox
        Left = 382
        Top = 12
        Width = 247
        Height = 26
        AutoComplete = False
        Style = csDropDownList
        DropDownCount = 20
        TabOrder = 0
        OnClick = cmbSkinClick
      end
      object cmbFontName: TSpTBXFontComboBox
        Left = 382
        Top = 54
        Width = 247
        Height = 26
        DropDownCount = 20
        ItemHeight = 18
        Sorted = True
        TabOrder = 1
        OnClick = cmbFontNameClick
        AutoItemHeight = True
        MaxMRUItems = 0
      end
      object edtFontSize: THideEditW
        Left = 382
        Top = 95
        Width = 50
        Height = 26
        NumbersOnly = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnChange = edtFontSizeChange
        UAlignment = taLeftJustify
      end
      object staFontColorBasic: TStaticText
        Left = 382
        Top = 140
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'A'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 3
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staInvalid: TStaticText
        Left = 579
        Top = 142
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'B'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 4
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staFontColorLow: TStaticText
        Left = 579
        Top = 206
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'F'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 5
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staFontColorHigh: TStaticText
        Left = 382
        Top = 206
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'E'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 6
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staToday: TStaticText
        Left = 382
        Top = 240
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'G'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 7
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staTomorrow: TStaticText
        Left = 579
        Top = 240
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'H'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 8
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staFontDate: TStaticText
        Left = 579
        Top = 172
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'D'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 9
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staFontTime: TStaticText
        Left = 382
        Top = 172
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'C'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 10
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object staAfterTomorrow: TStaticText
        Left = 449
        Top = 276
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'H'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 11
        Transparent = False
        OnClick = staFontColorBasicClick
      end
      object chkBorder: TCheckBox
        Left = 308
        Top = 315
        Width = 133
        Height = 17
        Caption = #12501#12457#12531#12488#12398#32257#21462#12426
        TabOrder = 12
        OnClick = chkBorderClick
      end
      object staBorder: TStaticText
        Left = 449
        Top = 311
        Width = 50
        Height = 22
        Cursor = crHandPoint
        Hint = 'H'
        AutoSize = False
        BorderStyle = sbsSingle
        TabOrder = 13
        Transparent = False
        OnClick = staFontColorBasicClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = #19968#33324
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label8: TLabel
        Left = 36
        Top = 22
        Width = 130
        Height = 18
        Caption = #21462#24471#12377#12427#26178#38291'('#27598#26178'n'#20998'):'
      end
      object Label16: TLabel
        Left = 36
        Top = 54
        Width = 115
        Height = 18
        Caption = #21322#36879#26126#12398#20516'(0'#65374'255):'
      end
      object Label19: TLabel
        Left = 36
        Top = 86
        Width = 113
        Height = 18
        Caption = #20351#29992#12377#12427#12502#12521#12454#12470#12540':'
      end
      object Label18: TLabel
        Left = 36
        Top = 119
        Width = 65
        Height = 18
        Caption = #12507#12483#12488#12461#12540':'
      end
      object edtGetTime: THideEditW
        Left = 180
        Top = 19
        Width = 217
        Height = 26
        Hint = #20837#21147#21487#33021':0123456789,'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = '0,20,40'
        UAlignment = taLeftJustify
        UEnableChar = '0123456789,'
      end
      object edtAlphaValue: THideEditW
        Left = 180
        Top = 51
        Width = 81
        Height = 26
        NumbersOnly = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = '255'
        OnChange = edtAlphaValueChange
        UAlignment = taLeftJustify
      end
      object edtBrowser: THideEditW
        Left = 180
        Top = 83
        Width = 451
        Height = 26
        Hint = #20837#21147#21487#33021':0123456789,'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'iexplore.exe'
        UAlignment = taLeftJustify
      end
      object chkGetFromYahoo: TCheckBox
        Left = 36
        Top = 154
        Width = 383
        Height = 17
        Caption = 'tenki.jp'#21033#29992#26178#12289#38450#28797#24773#22577#12434'Yahoo!'#22825#27671#12539#28797#23475#12363#12425#21462#24471#12377#12427#12290
        TabOrder = 4
      end
      object hotKey: THotKey
        Left = 180
        Top = 115
        Width = 121
        Height = 26
        HotKey = 0
        Modifiers = []
        TabOrder = 3
      end
      object chkIsShow: TCheckBox
        Left = 36
        Top = 185
        Width = 243
        Height = 17
        Caption = #26426#19978#20104#22577#12434#26368#23567#21270#12375#12390#36215#21205#12377#12427#12290
        TabOrder = 5
      end
      object chkSetWallpaper: TCheckBox
        Left = 36
        Top = 247
        Width = 197
        Height = 17
        Caption = #22721#32025#12434#32972#26223#30011#20687#12395#25351#23450#12377#12427#12290
        TabOrder = 7
      end
      object chkUseWinCursor: TCheckBox
        Left = 36
        Top = 216
        Width = 243
        Height = 17
        Caption = 'Windows'#12398#12459#12540#12477#12523#12434#20351#29992#12377#12427#12290
        TabOrder = 6
      end
    end
    object TabSheet4: TTabSheet
      Caption = #34920#31034#12377#12427#38917#30446
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object grpToday: TGroupBox
        Left = 290
        Top = 18
        Width = 250
        Height = 321
        Caption = #20170#26085#12392#26126#26085#12398#22825#27671
        TabOrder = 0
        object chkToday1: TCheckBox
          Left = 24
          Top = 40
          Width = 97
          Height = 17
          Caption = #27671#28201
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chkToday2: TCheckBox
          Left = 24
          Top = 72
          Width = 97
          Height = 17
          Caption = #28287#24230
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkToday3: TCheckBox
          Left = 24
          Top = 136
          Width = 97
          Height = 17
          Caption = #38477#27700#37327
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object chkToday4: TCheckBox
          Left = 24
          Top = 168
          Width = 97
          Height = 17
          Caption = #39080#21521#12365
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object chkToday5: TCheckBox
          Left = 24
          Top = 200
          Width = 97
          Height = 17
          Caption = #39080#12398#24375#12373
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
        object chkToday6: TCheckBox
          Left = 24
          Top = 106
          Width = 151
          Height = 17
          Caption = #38477#27700#30906#29575'(tenki.jp)'
          Checked = True
          State = cbChecked
          TabOrder = 5
        end
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 18
        Width = 250
        Height = 321
        Caption = #29694#22312#12398#22825#27671
        TabOrder = 1
        object chkNow1: TCheckBox
          Left = 26
          Top = 42
          Width = 97
          Height = 17
          Caption = #28287#24230
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chkNow2: TCheckBox
          Left = 26
          Top = 74
          Width = 97
          Height = 17
          Caption = #38477#27700#37327
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkNow3: TCheckBox
          Left = 26
          Top = 106
          Width = 97
          Height = 17
          Caption = #39080#21521#12365#12539#24375#12373
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #12456#12483#12472#12473#12463#12525#12540#12523
      ImageIndex = 4
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label15: TLabel
        Left = 275
        Top = 62
        Width = 171
        Height = 18
        Caption = #12511#12522#31186'(50'#65374'1000'#12289'1'#31186#12399'1000)'
      end
      object Label20: TLabel
        Left = 50
        Top = 106
        Width = 89
        Height = 18
        Caption = #38283#22987#12414#12391#12398#26178#38291':'
      end
      object Label21: TLabel
        Left = 275
        Top = 106
        Width = 93
        Height = 18
        Caption = #12511#12522#31186'(1'#65374'2000)'
      end
      object Label22: TLabel
        Left = 50
        Top = 62
        Width = 101
        Height = 18
        Caption = #12473#12463#12525#12540#12523#12398#36895#12373':'
      end
      object chkEdgeScroll: TCheckBox
        Left = 34
        Top = 22
        Width = 439
        Height = 17
        Caption = #20170#26085#12392#26126#26085#12398#22825#27671#27396#21450#12403#36913#38291#22825#27671#27396#12391#12456#12483#12472#12473#12463#12525#12540#12523#12434#20351#29992#12377#12427#12290
        TabOrder = 0
      end
      object edtScrollTime: THideEditW
        Left = 178
        Top = 59
        Width = 91
        Height = 26
        MaxLength = 4
        NumbersOnly = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        UAlignment = taLeftJustify
      end
      object edtWaitTime: THideEditW
        Left = 178
        Top = 103
        Width = 91
        Height = 26
        MaxLength = 4
        NumbersOnly = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        UAlignment = taLeftJustify
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Proxy'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label13: TLabel
        Left = 44
        Top = 58
        Width = 81
        Height = 18
        Caption = 'Proxy Server:'
      end
      object Label14: TLabel
        Left = 44
        Top = 98
        Width = 66
        Height = 18
        Caption = 'Proxy Port:'
      end
      object chkUseProxy: TCheckBox
        Left = 34
        Top = 22
        Width = 145
        Height = 17
        Caption = 'HTTP Proxy'#12434#20351#12358
        TabOrder = 0
      end
      object edtServer: TEdit
        Left = 146
        Top = 55
        Width = 219
        Height = 26
        TabOrder = 1
      end
      object edtPort: THideEditW
        Left = 146
        Top = 95
        Width = 67
        Height = 26
        NumbersOnly = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        UAlignment = taLeftJustify
      end
    end
  end
  object btnApply: TButton
    Left = 483
    Top = 403
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #36969#29992
    TabOrder = 2
    OnClick = btnApplyClick
  end
  object ColorDialog: TColorDialog
    Left = 28
    Top = 336
  end
  object png24: TPngImageList
    Height = 24
    Width = 24
    PngImages = <>
    Left = 80
    Top = 337
  end
  object png60: TPngImageList
    Height = 60
    Width = 60
    PngImages = <>
    Left = 130
    Top = 339
  end
  object png12: TPngImageList
    Height = 12
    Width = 12
    PngImages = <>
    Left = 176
    Top = 339
  end
  object popImg: TSpTBXPopupMenu
    Left = 70
    Top = 73
    object popImg_Save: TSpTBXItem
      Caption = #30011#20687#12434#20445#23384
      OnClick = popImg_SaveClick
    end
  end
end
