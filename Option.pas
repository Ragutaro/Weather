unit Option;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.ComCtrls, Vcl.StdCtrls, HideComboBox, FontTypeSize,
  SpTBXEditors, SpTBXExtEditors, HideEdit, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, PngImageList, System.Math, PngImage, Hkhotkey, Vcl.Menus,
  System.Win.Registry, Vcl.Imaging.jpeg, TB2Item, SpTBXItem;

type
  TfrmOption = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ColorDialog: TColorDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    imgSkin: TImage;
    Label4: TLabel;
    cmbSkin: THideComboBox;
    Label9: TLabel;
    cmbFontName: TSpTBXFontComboBox;
    Label10: TLabel;
    edtFontSize: THideEditW;
    Label1: TLabel;
    staFontColorBasic: TStaticText;
    Label7: TLabel;
    staInvalid: TStaticText;
    staFontColorLow: TStaticText;
    Label3: TLabel;
    staFontColorHigh: TStaticText;
    Label2: TLabel;
    Label5: TLabel;
    staToday: TStaticText;
    Label6: TLabel;
    staTomorrow: TStaticText;
    Label8: TLabel;
    edtGetTime: THideEditW;
    staFontDate: TStaticText;
    Label11: TLabel;
    staFontTime: TStaticText;
    Label12: TLabel;
    png24: TPngImageList;
    png60: TPngImageList;
    png12: TPngImageList;
    imgFront: TImage;
    shaToday: TShape;
    shaTomorrow: TShape;
    TabSheet3: TTabSheet;
    chkUseProxy: TCheckBox;
    Label13: TLabel;
    edtServer: TEdit;
    Label14: TLabel;
    edtPort: THideEditW;
    TabSheet4: TTabSheet;
    grpToday: TGroupBox;
    chkToday1: TCheckBox;
    chkToday2: TCheckBox;
    chkToday3: TCheckBox;
    chkToday4: TCheckBox;
    chkToday5: TCheckBox;
    Label16: TLabel;
    edtAlphaValue: THideEditW;
    GroupBox1: TGroupBox;
    chkNow1: TCheckBox;
    chkNow2: TCheckBox;
    chkNow3: TCheckBox;
    btnApply: TButton;
    chkToday6: TCheckBox;
    Label17: TLabel;
    staAfterTomorrow: TStaticText;
    Label19: TLabel;
    edtBrowser: THideEditW;
    chkGetFromYahoo: TCheckBox;
    TabSheet5: TTabSheet;
    chkEdgeScroll: TCheckBox;
    edtScrollTime: THideEditW;
    Label15: TLabel;
    Label20: TLabel;
    edtWaitTime: THideEditW;
    Label21: TLabel;
    Label22: TLabel;
    shaAfterTomorrow: TShape;
    hotKey: THotKey;
    Label18: TLabel;
    chkIsShow: TCheckBox;
    chkSetWallpaper: TCheckBox;
    chkUseWinCursor: TCheckBox;
    popImg: TSpTBXPopupMenu;
    popImg_Save: TSpTBXItem;
    chkBorder: TCheckBox;
    staBorder: TStaticText;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure staFontColorBasicClick(Sender: TObject);
    procedure cmbSkinClick(Sender: TObject);
    procedure cmbFontNameClick(Sender: TObject);
    procedure edtFontSizeChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure edtAlphaValueChange(Sender: TObject);
    procedure popImg_SaveClick(Sender: TObject);
    procedure chkBorderClick(Sender: TObject);
  private
    { Private 宣言 }
    FRunFirst : Boolean;
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadSkins;
    procedure _LoadSkinSettings;
    procedure _SaveSkinSettings;
    procedure _DrawData;
    procedure _LoadImages;
    procedure _DrawFontBorder(sText: String; cFontColor: TColor; iLeft, iTop: Integer; bIsDraw: Boolean);
  public
    { Public 宣言 }
  end;

var
  frmOption: TfrmOption;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp,
  Main,
  Colors,
  PngUtils;

procedure TfrmOption.btnApplyClick(Sender: TObject);
begin
  _SaveSettings;
  cmbSkinClick(nil);
end;

procedure TfrmOption.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmOption.btnOKClick(Sender: TObject);
begin
  _SaveSettings;
  Close;
end;

procedure TfrmOption.chkBorderClick(Sender: TObject);
begin
  if Not FRunFirst then
  begin
  	_DrawData;
  end;
  FRunFirst := False;
end;

procedure TfrmOption.cmbFontNameClick(Sender: TObject);
begin
  _DrawData;
end;

procedure TfrmOption.cmbSkinClick(Sender: TObject);
begin
  _LoadImages;
  _LoadSkinSettings;
  _DrawData;
end;

procedure TfrmOption.edtAlphaValueChange(Sender: TObject);
begin
  if StrToIntDefEx(edtAlphaValue.Text, 255) > 255 then
    edtAlphaValue.Text := '255';
end;

procedure TfrmOption.edtFontSizeChange(Sender: TObject);
begin
  _DrawData;
end;

procedure TfrmOption.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
  frmOption := nil;   //フォーム名に変更する
end;

procedure TfrmOption.FormCreate(Sender: TObject);
begin
  FRunFirst := True;
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSkins;
  _LoadSettings;
  cmbSkin.OnClick(Self);
end;

procedure TfrmOption._DrawData;
var
  r : TRect;
  i, iLeft, iFontSize : Integer;
  s : String;
begin
  imgFront.Picture.Assign(imgSkin.Picture);
  with imgFront.Canvas do
  begin
    Font.Name := cmbFontName.Text;
    Brush.Style := bsClear;
    //場所データ
    Font.Size := 7;
    Font.Color := staFontColorBasic.Color;
    _DrawFontBorder('表示する地域', Font.Color, 4, 4, chkBorder.Checked);
//    TextOut(4, 4, '表示する地域');
    Font.Size := 8;
    _DrawFontBorder(FormatDateTime('M月D日 HH時', Now), Font.Color, 4, 22-(TextHeight('あ') div 2), chkBorder.Checked);
//    TextOut(4, 22-(TextHeight('あ') div 2), FormatDateTime('M月D日 HH時', Now));
    //今の天気
    r.Left := 110;  r.Top := 10;  r.Width := 60;  r.Height := 60;
    png60.PngImages[0].PngImage.Draw(imgFront.Canvas, r);
    //気象データ
    Font.Size := 20;
    Font.Color := staFontColorBasic.Color;
    _DrawFontBorder('32℃', Font.Color, 270-(TextWidth('32℃')), 0, chkBorder.Checked);
//    TextOut(270 - (TextWidth('32℃')), 0, '32℃');
    Font.Size := 7;
    //湿度
    r.Top := 40;  r.Left := 216; r.Width := 12;  r.Height := 12;
    png12.PngImages[0].PngImage.Draw(imgFront.Canvas, r);
    _DrawFontBorder('40%', Font.Color, 230, 40, chkBorder.Checked);
//    TextOut(230, 40, '40%');
    //降水量
    r.Top := 52;  r.Left := 216;  r.Width := 12;  r.Height := 12;
    png12.PngImages[1].PngImage.Draw(imgFront.Canvas, r);
    _DrawFontBorder('4mm', Font.Color, 230, 52, chkBorder.Checked);
//    TextOut(230, 52, '4mm');
    //風
    r.Top := 64;  r.Left := 216;  r.Width := 12;  r.Height := 12;
    png12.PngImages[2].PngImage.Draw(imgFront.Canvas, r);
    _DrawFontBorder('南南西3m', Font.Color, 230, 64, chkBorder.Checked);
//    TextOut(230, 64, '南南西3m');

    //今日と明日の天気
    Randomize;
    iLeft := 20;
    for i := 0 to 6 do
    begin
      iFontSize := StrToIntDefEx(edtFontSize.Text, 9);
      r.Left := iLeft-12;  r.Top := 100; r.Width := 24;  r.Height := 24;
      png24.PngImages[i].PngImage.Draw(imgFront.Canvas, r);
      if i <= 2 then
        Font.Color := staInvalid.Color
      else
        Font.Color := staFontTime.Color;
      //時間
      Font.Size := iFontSize;
      _DrawFontBorder('時間', Font.Color, iLeft - (TextWidth('時間') div 2), 90 - (TextHeight('あ') div 2), chkBorder.Checked);
//      TextOut(iLeft - (TextWidth('時間') div 2), 90 - (TextHeight('あ') div 2), '時間');
      if i <= 2 then
        Font.Color := staInvalid.Color
      else
        Font.Color := staFontColorBasic.Color;
      //気温
      if frmMain._IsYahoo then
        Font.Size := iFontSize
      else
        Font.Size := iFontSize-1;
      s := IntToStr(RandomRange(25,36)) + '℃';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 125, chkBorder.Checked);
//      TextOut(iLeft - (TextWidth(s) div 2), 125, s);
      //湿度
      Font.Size := iFontSize;
      s := IntToStr(RandomRange(0,60)) + '%';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 137, chkBorder.Checked);
//      TextOut(iLeft - (TextWidth(s) div 2), 137, s);
      //降水量
      Font.Size := iFontSize;
      s := IntToStr(RandomRange(0,10)) + 'mm';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 149, chkBorder.Checked);
//      TextOut(iLeft - (TextWidth(s) div 2), 149, s);
      //風
      Font.Size := 7;
      _DrawFontBorder('北北西', Font.Color, iLeft-(TextWidth('北北西') div 2), 162, chkBorder.Checked);
//      TextOut(iLeft - (TextWidth('北北西') div 2), 162, '北北西');
      Font.Size := iFontSize;
      s := IntToStr(RandomRange(0,6)) + 'm';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 173, chkBorder.Checked);
//      TextOut(iLeft - (TextWidth(s) div 2), 173, s);
      iLeft := iLeft + 40;
    end;

    //週間天気
    iLeft := 24;
    Font.Size := StrToIntDefEx(edtFontSize.Text, 9);
    for i := 2 to 7 do
    begin
      r.Left := iLeft-12;  r.Top := 210; r.Width := 24;  r.Height := 24;
      png24.PngImages[i].PngImage.Draw(imgFront.Canvas, r);
      Font.Color := staFontDate.Color;
      _DrawFontBorder('日付', Font.Color, iLeft-(TextWidth('日付') div 2), 198-(TextHeight('あ') div 2), chkBorder.Checked);
//      TextOut(iLeft-(TextWidth('日付') div 2), 198-(TextHeight('あ') div 2), '日付');
      //最高
      Font.Color := staFontColorHigh.Color;
      s := IntToStr(RandomRange(25,35)) + '℃';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 235, chkBorder.Checked);
//      TextOut(iLeft-(TextWidth(s) div 2), 235, s);
      //最低
      Font.Color := staFontColorLow.Color;
      s := IntToStr(RandomRange(10,23)) + '℃';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 248, chkBorder.Checked);
//      TextOut(iLeft-(TextWidth(s) div 2), 248, s);
      //降水確率
      Font.Color := staFontColorBasic.Color;
      s := IntToStr(RandomRange(0,100)) + '%';
      _DrawFontBorder(s, Font.Color, iLeft-(TextWidth(s) div 2), 260, chkBorder.Checked);
//      TextOut(iLeft-(TextWidth(s) div 2), 260, s);
      iLeft := iLeft + 47;
    end;
  end;
  shaToday.Pen.Color := staToday.Color;
  shaTomorrow.Pen.Color := staTomorrow.Color;
  shaAfterTomorrow.Pen.Color := staAfterTomorrow.Color;
end;

procedure TfrmOption._DrawFontBorder(sText: String; cFontColor: TColor; iLeft,
  iTop: Integer; bIsDraw: Boolean);
begin
  if bIsDraw then
  begin
    with imgFront.Canvas do
    begin
      Font.Color := staBorder.Color;
      TextOut(iLeft-1, iTop-1, sText);
      TextOut(iLeft+1, iTop-1, sText);
      TextOut(iLeft-1, iTop+1, sText);
      TextOut(iLeft+1, iTop+1, sText);
    end;
  end;

  with imgFront.Canvas do
  begin
    Font.Color := cFontColor;
    TextOut(iLeft, iTop, sText);
  end;
end;

procedure TfrmOption._LoadImages;
var
  png : TPngImage;
  i : Integer;
  sFile : String;
begin
  png60.PngImages.BeginUpdate;
  png60.PngImages.Clear;
  png24.PngImages.BeginUpdate;
  png24.PngImages.Clear;
  png12.PngImages.BeginUpdate;
  png12.PngImages.Clear;
  try
    for i := 0 to 7 do
    begin
      //大アイコン
      sFile := Format('%simages\%s\%d.png', [GetApplicationPath, cmbSkin.Text, i]);
      if FileExists(sFile) then
        png60.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
        png60.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s\%d.png', [GetApplicationPath, 'Default', i]));

      //中アイコン(有効)
      sFile := Format('%simages\%s\s%d.png', [GetApplicationPath, cmbSkin.Text, i]);
      if FileExists(sFile) then
        png24.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
      begin
      	png := TPngImage.Create;
        try
          png.Assign(png60.PngImages[i].PngImage);
          pngSmoothResize(png, 24, 24);
          //大アイコンから作成する
          png24.PngImages.Add.PngImage.Assign(png);
        finally
          png.Free;
        end;
      end;
    end;

    //過去アイコンの作成
    for i := 0 to 2 do
    begin
      png:= TPngImage.Create;
      try
        png.Assign(png24.PngImages[i].PngImage);
        pngSetOpacity(png, 150);
        png24.PngImages[i].PngImage.Assign(png);
      finally
        png.Free;
      end;
    end;

    //小アイコン
    for i := 0to 2 do
    begin
      sFile := Format('%simages\%s\ss%d.png', [GetApplicationPath, cmbSkin.Text, i]);
      if FileExists(sFile) then
        png12.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
        png12.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s\ss%d.png', [GetApplicationPath, 'Default', i]));
    end;
  finally
    png60.PngImages.EndUpdate;
    png24.PngImages.EndUpdate;
    png12.PngImages.EndUpdate;
  end;
end;

procedure TfrmOption._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindow(Self.Name, Self);
    Self.Font.Name           := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size           := ini.ReadInteger('General', 'FontSize', 10);
    //一般
    chkEdgeScroll.Checked    := ini.ReadBool('frmMain', 'EdgeScroll', False);
    edtScrollTime.Text       := ini.ReadString('frmMain', 'ScrollTime', '200');
    edtWaitTime.Text         := ini.ReadString('frmMain', 'ScrollWaitTime', '500');
    edtGetTime.Text          := ini.ReadString('frmMain', 'TimeList', '0,20,40');
    edtAlphaValue.Text       := ini.ReadString('frmMain', 'AlphaValue', '255');
    cmbSkin.ItemIndex        := cmbSkin.Items.IndexOf(ini.ReadString('frmMain', 'SkinDir', 'Default'));
    chkUseProxy.Checked      := ini.ReadBool('frmMain', 'UseProxy', False);
    edtServer.Text           := ini.ReadString('frmMain', 'ProxyServer', '');
    edtPort.Text             := ini.ReadString('frmMain', 'ProxyPort', '');
    edtBrowser.Text          := ini.ReadString('frmMain', 'Browser', 'iexplore.exe');
    chkGetFromYahoo.Checked  := ini.ReadBool('frmMain', 'GetFromYahoo', False);
    hotKey.HotKey            := TextToShortCut(ini.ReadString('frmMain', 'HotKey', ''));
    chkIsShow.Checked        := ini.ReadBool('frmMain', 'RunMinimized', False);
    chkSetWallpaper.Checked  := ini.ReadBool('frmMain', 'SetWallpaper', False);
    chkUseWinCursor.Checked  := ini.ReadBool('frmMain', 'UseWinCursor', False);
    //表示する項目
    chkNow1.Checked   := ini.ReadBool('frmMain', 'DrawNowShitsudo', True);
    chkNow2.Checked   := ini.ReadBool('frmMain', 'DrawNowRain', True);
    chkNow3.Checked   := ini.ReadBool('frmMain', 'DrawNowWind', True);
    chkToday1.Checked := ini.ReadBool('frmMain', 'DrawKion', True);
    chkToday2.Checked := ini.ReadBool('frmMain', 'DrawShitsudo', True);
    chkToday3.Checked := ini.ReadBool('frmMain', 'DrawRain', True);
    chkToday4.Checked := ini.ReadBool('frmMain', 'DrawWindDirec', True);
    chkToday5.Checked := ini.ReadBool('frmMain', 'DrawWindStrong', True);
    if frmMain._IsYahoo then
    begin
    	chkToday6.Checked := False;
      chkToday6.Enabled := False;
    end else
      chkToday6.Checked := ini.ReadBool('frmMain', 'RainPercent', False);
  finally
    ini.Free;
  end;
end;

procedure TfrmOption._LoadSkins;
var
  sl : TStringList;
  i : Integer;
begin
  sl := TStringList.Create;
  try
    GetFolders(GetApplicationPath + 'images', '*', sl, False);
    for i := 0 to sl.Count-1 do
      cmbSkin.Items.Add(ExtractFileBody(sl[i]));
  finally
    sl.Free;
  end;
end;

procedure TfrmOption._LoadSkinSettings;
var
  ini : TMemIniFile;
  r : TRegIniFile;
  bmpSrc : TBitmap;
  jpg : TJPEGImage;
  png : TPngImage;
  sWall, sFile : String;
begin
  imgSkin.Picture.Bitmap := nil;
  if Not av.bSetWallpaper then
  begin
  	sFile := FindFile(Format('%simages\%s\Background.*', [GetApplicationPath, cmbSkin.Text]));
//  	sFile := Format('%simages\%s\Background.bmp', [GetApplicationPath, cmbSkin.Text]);
    imgSkin.Picture.LoadFromFile(sFile);
  end else
  begin
    r := TRegIniFile.Create('Control Panel');
    try
      sWall := r.ReadString('Desktop', 'Wallpaper', '');
    finally
      r.Free;
    end;

    if ContainsText('.bmp', ExtractFileExt(sWall)) then
    begin
      bmpSrc := TBitmap.Create;
      try
        bmpSrc.LoadFromFile(sWall);
        BitBlt(imgSkin.Canvas.Handle, 0, 0, 280, 280,
               bmpSrc.Canvas.Handle, frmMain.Left, frmMain.Top, SRCCOPY);
      finally
        bmpSrc.Free;
      end;
    end
    else if ContainsText('.jpg.jpeg', ExtractFileExt(sWall)) then
    begin
      jpg := TJPEGImage.Create;
      try
        jpg.LoadFromFile(sWall);
        BitBlt(imgSkin.Canvas.Handle, 0, 0, 280, 280,
               jpg.Canvas.Handle, frmMain.Left, frmMain.Top, SRCCOPY);
      finally
        jpg.Free;
      end;
    end
    else if ContainsText('.png', ExtractFileExt(sWall)) then
    begin
      png := TPngImage.Create;
      try
        png.LoadFromFile(sWall);
        BitBlt(imgSkin.Canvas.Handle, 0, 0, 280, 280,
               png.Canvas.Handle, frmMain.Left, frmMain.Top, SRCCOPY);
      finally
        png.Free;
      end;
    end;
  end;

  sFile := Format('%simages\%s\Settings.ini', [GetApplicationPath, cmbSkin.Text]);
  ini := TMemIniFile.Create(sFile, TEncoding.UTF8);
  try
    cmbFontName.Text          := ini.ReadString('Font', 'Name', 'メイリオ');
    edtFontSize.Text          := ini.ReadString('Font', 'Size', '8');
    chkBorder.Checked         := ini.ReadBool('Font', 'FontBorder', False);
    staFontColorBasic.Color   := RGBStringToColor(ini.ReadString('FontColor', 'Basic', '228,228,228'));
    staInvalid.Color          := RGBStringToColor(ini.ReadString('FontColor', 'Past', '149,149,149'));
    staFontTime.Color         := RGBStringToColor(ini.ReadString('FontColor', 'Time', ColorToRGBString(staFontColorBasic.Color)));
    staFontDate.Color         := RGBStringToColor(ini.ReadString('FontColor', 'Date', ColorToRGBString(staFontColorBasic.Color)));
    staFontColorHigh.Color    := RGBStringToColor(ini.ReadString('FontColor', 'TempHigh', '250,64,64'));
    staFontColorLow.Color     := RGBStringToColor(ini.ReadString('FontColor', 'TempLow', '72,191,249'));
    staToday.Color            := RGBStringToColor(ini.ReadString('FontColor', 'Today', '24,190,6'));
    staTomorrow.Color         := RGBStringToColor(ini.ReadString('FontColor', 'Tomorrow', '17,134,4'));
    staAfterTomorrow.Color    := RGBStringToColor(ini.ReadString('FontColor', 'AfterTomorrow', '17,134,4'));
    staBorder.Color           := RGBStringToColor(ini.ReadString('FontColor', 'Border', '0,0,0'));
  finally
    ini.Free;
  end;
end;

procedure TfrmOption._SaveSettings;
var
  sl : TStringList;
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindow(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
    //一般
    ini.WriteString('frmMain', 'TimeList', Trim(edtGetTime.Text));
    ini.WriteString('frmMain', 'AlphaValue', Trim(edtAlphaValue.Text));
    ini.WriteString('frmMain', 'SkinDir', cmbSkin.Text);
    ini.WriteString('frmMain', 'Browser', Trim(edtBrowser.Text));
    ini.WriteBool('frmMain', 'GetFromYahoo', chkGetFromYahoo.Checked);
    ini.WriteString('frmMain', 'HotKey', ShortCutToText(hotKey.HotKey));
    ini.WriteBool('frmMain', 'RunMinimized', chkIsShow.Checked);
    ini.WriteBool('frmMain', 'SetWallpaper', chkSetWallpaper.Checked);
    ini.WriteBool('frmMain', 'UseWinCursor', chkUseWinCursor.Checked);
    //Proxy
    ini.WriteBool('frmMain', 'UseProxy', chkUseProxy.Checked);
    ini.WriteString('frmMain', 'ProxyServer', Trim(edtServer.Text));
    ini.WriteString('frmMain', 'ProxyPort', edtPort.Text);
    //表示する項目
    ini.WriteBool('frmMain', 'DrawNowShitsudo', chkNow1.Checked);
    ini.WriteBool('frmMain', 'DrawNowRain', chkNow2.Checked);
    ini.WriteBool('frmMain', 'DrawNowWind', chkNow3.Checked);
    ini.WriteBool('frmMain', 'DrawKion', chkToday1.Checked);
    ini.WriteBool('frmMain', 'DrawShitsudo', chkToday2.Checked);
    ini.WriteBool('frmMain', 'DrawRain', chkToday3.Checked);
    ini.WriteBool('frmMain', 'DrawWindDirec', chkToday4.Checked);
    ini.WriteBool('frmMain', 'DrawWindStrong', chkToday5.Checked);
    //エッジスクロール
    ini.WriteBool('frmMain', 'EdgeScroll', chkEdgeScroll.Checked);
    ini.WriteInteger('frmMain', 'ScrollTime', CheckInteger(edtScrollTime.Text, 50, 1000));
    ini.WriteInteger('frmMain', 'ScrollWaitTime', CheckInteger(edtWaitTime.Text, 1, 2000));
    if Not frmMain._IsYahoo then
      ini.WriteBool('frmMain', 'RainPercent', chkToday6.Checked);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
  //変更を反映する
  skin.sFontName      := cmbFontName.Text;
  skin.iFontSize      := StrToIntDef(edtFontSize.Text, 8);
  skin.cFontColor     := staFontColorBasic.Color;
  skin.cFontColorHigh := staFontColorHigh.Color;
  skin.cFontColorLow  := staFontColorLow.Color;
  skin.cToday         := staToday.Color;
  skin.cNextDay       := staTomorrow.Color;
  skin.cAftTom        := staAfterTomorrow.Color;
  skin.cBorder        := staBorder.Color;
  skin.bIsBorder      := chkBorder.Checked;
  av.sSkinDir       := cmbSkin.Text;
  av.bEdgeScroll    := chkEdgeScroll.Checked;
  av.bUseProxy      := chkUseProxy.Checked;
  av.sProxyServer   := Trim(edtServer.Text);
  av.sProxyPort     := edtPort.Text;
  av.iScrollTime    := StrToIntDefEx(edtScrollTime.Text, 200);
  av.iScrollWaitTime:= StrToIntDefEx(edtWaitTime.Text, 500);
  av.sBrowser       := Trim(edtBrowser.Text);
  av.bGetFromYahoo  := chkGetFromYahoo.Checked;
  av.bSetWallpaper  := chkSetWallpaper.Checked;
  av.bUseWinCursor  := chkUseWinCursor.Checked;
  idd.bNowShitsudo  := chkNow1.Checked;
  idd.bNowRain      := chkNow2.Checked;
  idd.bNowWind      := chkNow3.Checked;
  idd.bKion         := chkToday1.Checked;
  idd.bShitsudo     := chkToday2.Checked;
  idd.bRain         := chkToday3.Checked;
  idd.bWindDirec    := chkToday4.Checked;
  idd.bWindStrong   := chkToday5.Checked;
  idd.bRainPercent  := chkToday6.Checked;

  frmMain.timDailyScroll.Interval := av.iScrollTime;
  frmMain.timDailyWait.Interval := av.iScrollWaitTime;
  frmMain.timWeeklyScroll.Interval := av.iScrollTime;
  frmMain.timWeeklyWait.Interval := av.iScrollWaitTime;
  frmMain.AlphaBlendValue := StrToIntDefEx(edtAlphaValue.Text, 255);
  frmMain.HookHotKey.Change(0, hotKey.HotKey);

  sl := TStringList.Create;
  try
    sl.CommaText := Trim(edtGetTime.Text);
    TimeList := [];
    for i := 0 to sl.Count - 1 do
      System.Include(TimeList, StrToIntDefEx(sl[i], 0));
  finally
    sl.Free;
  end;
  _SaveSkinSettings;
  frmMain._CreateImegeList;
  frmMain._LoadSkin;
  frmMain._LoadAllData(True);
end;

procedure TfrmOption._SaveSkinSettings;
var
  ini : TMemIniFile;
  sFile : String;
begin
  sFile := Format('%simages\%s\Settings.ini', [GetApplicationPath, cmbSkin.Text]);
  ini := TMemIniFile.Create(sFile, TEncoding.UTF8);
  try
    ini.WriteString('Font', 'Name', cmbFontName.Text);
    ini.WriteString('Font', 'Size', edtFontSize.Text);
    ini.WriteBool('Font', 'FontBorder', chkBorder.Checked);
    ini.WriteString('FontColor', 'Basic', ColorToRGBString(staFontColorBasic.Color));
    ini.WriteString('FontColor', 'Past', ColorToRGBString(staInvalid.Color));
    ini.WriteString('FontColor', 'Time', ColorToRGBString(staFontTime.Color));
    ini.WriteString('FontColor', 'Date', ColorToRGBString(staFontDate.Color));
    ini.WriteString('FontColor', 'TempHigh', ColorToRGBString(staFontColorHigh.Color));
    ini.WriteString('FontColor', 'TempLow', ColorToRGBString(staFontColorLow.Color));
    ini.WriteString('FontColor', 'Today', ColorToRGBString(staToday.Color));
    ini.WriteString('FontColor', 'Tomorrow', ColorToRGBString(staTomorrow.Color));
    ini.WriteString('FontColor', 'AfterTomorrow', ColorToRGBString(staAfterTomorrow.Color));
    ini.WriteString('FontColor', 'Border', ColorToRGBString(staBorder.Color));
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmOption.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmOption.popImg_SaveClick(Sender: TObject);
var
  bmp : TBitmap;
  png : TPngImage;
begin
  bmp := TBitmap.Create;
  png := TPngImage.Create;
  try
    bmp.SetSize(280, 280);
    //背景画像をコピー
    BitBlt(bmp.Canvas.Handle, 0, 0, 280, 280,
           imgSkin.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
    //フォント等をコピー
    BitBlt(bmp.Canvas.Handle, 0, 0, 280, 280,
           imgFront.Picture.Bitmap.Canvas.Handle, 0, 0, SRCCOPY);
    //デスクトップに保存する
    png.Assign(bmp);
    png.SaveToFile(GetSpecialFolderPath + '\' + TPath.GetRandomFileName + '.png');
  finally
    bmp.Free;
    png.Free;
  end;
end;

procedure TfrmOption.staFontColorBasicClick(Sender: TObject);
begin
//  s :=  RemoveLeft(ColorToString(TStaticText(Sender).Color), 1);
//  ColorDialog.CustomColors.Add(Format('Color%s=%d', [TStaticText(Sender).Hint, StringToColor(s)]));
  if ColorDialog.Execute then
  begin
  	TStaticText(Sender).Color := ColorDialog.Color;
    _DrawData;
  end;
end;

end.
