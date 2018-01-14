unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, TB2Item,
  SpTBXItem, Vcl.Menus, System.ImageList, Vcl.ImgList, PngImageList, DateUtils, Winapi.ShellAPI,
  Hkhotkey, System.Win.Registry, Vcl.imaging.jpeg;

type
  TfrmMain = class(TForm)
    imgBack: TImage;
    popMain: TSpTBXPopupMenu;
    popExit: TSpTBXItem;
    pngWeather: TPngImageList;
    popRefresh: TSpTBXItem;
    TrayIcon: TTrayIcon;
    Timer: TTimer;
    popSelctPlace: TSpTBXItem;
    SpTBXSeparatorItem1: TSpTBXSeparatorItem;
    pngSImages: TPngImageList;
    pngSSImages: TPngImageList;
    popVersion: TSpTBXItem;
    popOption: TSpTBXItem;
    popGetRain: TSpTBXItem;
    pngSDisabled: TPngImageList;
    popShowEvacuation: TSpTBXItem;
    SpTBXSeparatorItem2: TSpTBXSeparatorItem;
    SpTBXSeparatorItem3: TSpTBXSeparatorItem;
    popFavorite: TSpTBXSubmenuItem;
    popTray: TSpTBXPopupMenu;
    SpTBXItem1: TSpTBXItem;
    SpTBXSeparatorItem4: TSpTBXSeparatorItem;
    SpTBXItem2: TSpTBXItem;
    SpTBXItem3: TSpTBXItem;
    SpTBXSeparatorItem5: TSpTBXSeparatorItem;
    SpTBXSubmenuItem1: TSpTBXSubmenuItem;
    SpTBXItem4: TSpTBXItem;
    SpTBXItem5: TSpTBXItem;
    SpTBXItem6: TSpTBXItem;
    SpTBXSeparatorItem6: TSpTBXSeparatorItem;
    SpTBXItem7: TSpTBXItem;
    popFixed: TSpTBXItem;
    popTrayFixed: TSpTBXItem;
    popIsVersionup: TSpTBXItem;
    popVisitSite: TSpTBXItem;
    popTrayVisitSite: TSpTBXItem;
    SpTBXItem8: TSpTBXItem;
    timDailyWait: TTimer;
    timDailyScroll: TTimer;
    timWeeklyWait: TTimer;
    timWeeklyScroll: TTimer;
    HookHotKey: THookHotKey;
    pngList: TPngImageCollection;
    panDrop: TPanel;
    popMinimize: TSpTBXItem;
    popTrayMinize: TSpTBXItem;
    popHistory: TSpTBXSubmenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure popExitClick(Sender: TObject);
    procedure imgBackMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popRefreshClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure popSelctPlaceClick(Sender: TObject);
    procedure imgBackMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure popVersionClick(Sender: TObject);
    procedure popOptionClick(Sender: TObject);
    procedure popGetRainClick(Sender: TObject);
    procedure popShowEvacuationClick(Sender: TObject);
    procedure popMainPopup(Sender: TObject);
    procedure imgBackMouseLeave(Sender: TObject);
    procedure TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popTrayPopup(Sender: TObject);
    procedure _CreateImegeList;
    procedure _LoadAllData(bIsCache: Boolean);
    procedure _LoadSkin;
    procedure popFixedClick(Sender: TObject);
    procedure popTrayFixedClick(Sender: TObject);
    procedure popIsVersionupClick(Sender: TObject);
    function _IsYahoo: Boolean;
    procedure popVisitSiteClick(Sender: TObject);
    procedure timDailyWaitTimer(Sender: TObject);
    procedure timDailyScrollTimer(Sender: TObject);
    procedure timWeeklyWaitTimer(Sender: TObject);
    procedure timWeeklyScrollTimer(Sender: TObject);
    procedure HookHotKeyHotKey(Sender: TObject; Index: Integer);
    procedure popMinimizeClick(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure imgBackClick(Sender: TObject);
    procedure popMainClosePopup(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _DrawDailyData(ScrollType: Integer);
    procedure _DrawWeeklyData(iStartIndex: Integer);
    function _GetWeatherIndex(const sWeather, sTime: String): Integer;
    procedure _DrawCaution;
    procedure _DrawEscapeInformation;
    procedure _LoadFavortie(Sender: TSpTBXItem);
    procedure _ExecuteFavorite(Sender: TObject);
    procedure _EditFavorite(Sender: TObject);
    procedure _AddFavorite(Sender: TObject);
    procedure _LoadWeatherData;
    procedure _SetDailyItemHeight;
    procedure _SetDailyCurrentIndex;
    procedure _DrawNowData(bIsCache: Boolean);
    procedure _LoadBackgroundImage;
    procedure ReceiveDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure WM_WallpaperChange(var Message:TWMSettingChange); message WM_SETTINGCHANGE;
    procedure _LoadWeatherHistory(Sender: TSpTBXItem);
    procedure _ExecuteWeatherHistory(Sender: TObject);
    procedure _DrawFontBorder(sText: String; cFontColor: TColor; iLeft, iTop: Integer; bIsDraw: Boolean);
    procedure WMMousewheel(var Msg: TMessage); message WM_MOUSEWHEEL;
    procedure _ConvertImages;
  public
    { Public 宣言 }
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TApplicationValues = record
    sSiteName, sPlace, sUrl, sSkinDir, sUrlRain, sProxyServer, sProxyPort, sBrowser : String;
    iCurLastIndex, iCurFirstIndex, iCurIndex, iWeeklyCurIndex : Integer;
    bEdgeScroll, bFixedWindow, bConnect, bUseProxy, bGetFromYahoo, bSetWallpaper, bUseWinCursor : Boolean;
    iScrollTime, iScrollWaitTime : Cardinal;
    iXX, iYY: Integer;
    bFlg : Boolean;
  end;

  TSkin = record
    sFontName : String;
    cFontColor, cFontColorHigh, cFontColorLow, cFontColorInvalid : TColor;
    cToday, cNextDay, cAftTom, cTime, cDate, cBorder : TColor;
    iFontSize : Integer;
    bIsBorder : Boolean;
  end;

  TDailyWeatherData = record
    bPast : Boolean;
    sTime, sWeather, sKion, sShitsudo, sRainPercent, sRain, sWindDirec, sWindStrong : String;
    iDay, iIconIndex : Integer;
  end;

  TWeeklyWeatherData = record
    sDay, sWeather, sHigh, sLow, sRain : String;
  end;

  TCautionsData = record
    sEmgWarning, sWarnToEmg, sWarning, sAdvToWarn, sAdvisory : String;
    iEmgWarning, iWarnToEmg, iWarning, iAdvToWarn, iAdvisory : Integer;
  end;

  TCrisisData = record
    sHinanString, sDoshyaString, sRiverString, sUrl : String;
    iHinanIndex, iDoshyaIndex, iRiverIndex : Integer;
  end;

  TIsDrawData = record
    bKion, bShitsudo, bRainPercent, bRain, bWindDirec, bWindStrong : Boolean;
    bNowShitsudo, bNowRain, bNowWind : Boolean;
    iDailyHeight : Integer;
  end;

var
  av : TApplicationValues;
  skin : TSkin;
  idd : TIsDrawData;
  dwd : array of TDailyWeatherData;
  wwd : array of TWeeklyWeatherData;
  cad : TCautionsData;
  crd : TCrisisData;
  TimeList : set of 0..59;
  bmpCache : TBitmap;
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp,
  ComObj,
  ShlObj,
  SelectPlace,
  untVersion,
  Option,
  Rain,
  EditFavorite,
  untYahoo,
  untTenki,
  Colors,
  VerUp,
  PngUtils;

const
  crBackAll = 1;
  crBack    = 2;
  crReload  = 3;
  crNext    = 4;
  crNextAll = 5;

procedure DelTaskBarBtn(hnd: THandle);
var
  TaskbarList: ITaskbarList;
begin
  TaskbarList := CreateComObject(CLSID_TaskbarList) as ITaskbarList;
  TaskbarList.HrInit;
  TaskbarList.DeleteTab(hnd);
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent := Application.Handle;
  Params.Style := WS_POPUP;
  Params.ExStyle := Params.ExStyle and WS_EX_TOOLWINDOW;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DragAcceptFiles(Self.Handle, False);
  bmpCache.Free;
  _SaveSettings;
  Release;
  frmMain := nil;   //フォーム名に変更する
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DelTaskBarBtn(Screen.Forms[0].Handle);
  DisableVclStyles(Self, '');
  bmpCache := TBitmap.Create;
  _LoadSettings;
  _LoadSkin;
  DragAcceptFiles(Self.Handle, True);
  _CreateImegeList;
  _LoadAllData(IsDebugMode);
end;

procedure TfrmMain._AddFavorite(Sender: TObject);
var
  ini : TMemIniFile;
  sl : TStringList;
  i : Integer;
  sTmp, sSite : String;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\Favorite.ini', TEncoding.UTF8);
  sl := TStringList.Create;
  try
    ini.ReadSections(sl);
    for i := 0 to sl.Count-1 do
    begin
      sTmp := ini.ReadString('Favorite'+IntToStr(i), 'Name', '');
      sSite := ini.ReadString('Favorite'+IntToStr(i), 'Site', 'yahoo.co.jp');
      if (sTmp = av.sPlace) and (sSite = av.sSiteName) then
      begin
        ShowMessage('すでに登録されています。');
        Exit;
      end;
    end;
    ini.WriteString('Favorite' + IntToStr(sl.Count), 'Name', av.sPlace);
    ini.WriteString('Favorite' + IntToStr(sl.Count), 'Url', av.sUrl);
    ini.WriteString('Favorite' + IntToStr(sl.Count), 'Site', av.sSiteName);
  finally
    ini.UpdateFile;
    ini.Free;
    sl.Free;
  end;
end;

procedure TfrmMain._ConvertImages;
var
  sDir : String;
begin
  sDir := GetApplicationPath + 'images\' + av.sSkinDir + '\';
  if Not FileExists(sDir + '15.png') then
  begin
    CopyFile(sDir+'7.png', sDir+'15.png');
    CopyFile(sDir+'5.png', sDir+'14.png');
    CopyFile(sDir+'5.png', sDir+'13.png');
    CopyFile(sDir+'5.png', sDir+'12.png');
    CopyFile(sDir+'5.png', sDir+'11.png');
    CopyFile(sDir+'5.png', sDir+'10.png');
    CopyFile(sDir+'6.png', sDir+'9.png');
    CopyFile(sDir+'6.png', sDir+'8.png');
    CopyFile(sDir+'6.png', sDir+'7.png');
    CopyFile(sDir+'4.png', sDir+'6.png');
    CopyFile(sDir+'3.png', sDir+'5.png');
    CopyFile(sDir+'3.png', sDir+'4.png');
  end;
  if Not FileExists(sDir + 's15.png') then
  begin
    CopyFile(sDir+'s7.png', sDir+'s15.png');
    CopyFile(sDir+'s5.png', sDir+'s14.png');
    CopyFile(sDir+'s5.png', sDir+'s13.png');
    CopyFile(sDir+'s5.png', sDir+'s12.png');
    CopyFile(sDir+'s5.png', sDir+'s11.png');
    CopyFile(sDir+'s5.png', sDir+'s10.png');
    CopyFile(sDir+'s6.png', sDir+'s9.png');
    CopyFile(sDir+'s6.png', sDir+'s8.png');
    CopyFile(sDir+'s6.png', sDir+'s7.png');
    CopyFile(sDir+'s4.png', sDir+'s6.png');
    CopyFile(sDir+'s3.png', sDir+'s5.png');
    CopyFile(sDir+'s3.png', sDir+'s4.png');
  end;
end;

procedure TfrmMain._CreateImegeList;
var
  png : TPngImage;
  i : Integer;
  sFile : String;
begin
  pngWeather.PngImages.BeginUpdate;
  pngSImages.PngImages.BeginUpdate;
  pngSDisabled.PngImages.BeginUpdate;
  pngSSImages.PngImages.BeginUpdate;
  pngWeather.PngImages.Clear;
  pngSImages.PngImages.Clear;
  pngSDisabled.PngImages.Clear;
  pngSSImages.PngImages.Clear;
  try
    for i := 0 to 7 do
    begin
      //存在しないときは Default 画像を読み込む
      //大アイコン
      sFile := Format('%simages\%s\%d.png', [GetApplicationPath, av.sSkinDir, i]);
      if FileExists(sFile) then
        pngWeather.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
        pngWeather.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s\%d.png', [GetApplicationPath, 'Default', i]));

      //中アイコン(現在以降)
      sFile := Format('%simages\%s\s%d.png', [GetApplicationPath, av.sSkinDir, i]);
      if FileExists(sFile) then
        pngSImages.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
      begin
        png := TPngImage.Create;
        try
          png.Assign(pngWeather.PngImages[i].PngImage);
          pngSmoothResize(png, 24, 24);
          //大アイコンから作成する
          pngSImages.PngImages.Add.PngImage.Assign(png);
        finally
          png.Free;
        end;
      end;

      //中アイコン(過去)
      sFile := Format('%simages\%s\sd%d.png', [GetApplicationPath, av.sSkinDir, i]);
      if FileExists(sFile) then
        pngSDisabled.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
      begin
        //中アイコンから半透明にして作成する
        png := TPngImage.Create;
        try
          png.Assign(pngSImages.PngImages[i].PngImage);
          pngSetOpacity(png, 150);
          pngSDisabled.PngImages.Add.PngImage.Assign(png);
        finally
          png.Free;
        end;
      end;
    end;

    for i := 0 to 2 do
    begin
      //小アイコン
      sFile := Format('%simages\%s\ss%d.png', [GetApplicationPath, av.sSkinDir, i]);
      if FileExists(sFile) then
        pngSSImages.PngImages.Add.PngImage.LoadFromFile(sFile)
      else
        pngSSImages.PngImages.Add.PngImage.LoadFromFile(Format('%simages\%s\ss%d.png', [GetApplicationPath, 'Default', i]));
    end;
  finally
    pngWeather.PngImages.EndUpdate;
    pngSImages.PngImages.EndUpdate;
    pngSDisabled.PngImages.EndUpdate;
    pngSSImages.PngImages.EndUpdate;
    TrayIcon.Icons := pngSImages;
  end;
end;

procedure TfrmMain._DrawCaution;
var
  r : TRect;
  iTop, iLeft, iWidth : Integer;
  bDraw : Boolean;
begin
  with imgBack.Canvas do
  begin
    Brush.Style := bsClear;
    Font.Name := 'Yu Gothic';
    Font.Size := skin.iFontSize;
    //特別警報
    bDraw := False;
    iTop := 30;
    iLeft := 4;
    if cad.sEmgWarning <> '' then
    begin
      iWidth := TextWidth(cad.sEmgWarning) + 5;
      r.Top := iTop;  r.Left := iLeft;  r.Width := iWidth;  r.Height := 16;
      pngList.Items[cad.iEmgWarning].PngImage.Draw(imgBack.Canvas, r);
      Font.Color := clWhite;
      TextOut(iLeft+2, (iTop+7)-TextHeight('あ') div 2, cad.sEmgWarning);
      Pen.Color := $007A2E41;
      Rectangle(iLeft, iTop, iLeft + r.Width, iTop + 16);
      iLeft := iLeft + iWidth + 2;
      bDraw := True;
    end;
    //特別警報予備軍
    if cad.sWarnToEmg <> '' then
    begin
      iWidth := TextWidth(cad.sWarnToEmg) + 21;
      r.Top := iTop;  r.Left := iLeft;  r.Width := iWidth;  r.Height := 16;
      pngList.Items[6].PngImage.Draw(imgBack.Canvas, r);
      Brush.Style := bsClear;
      Font.Color := clWhite;
      TextOut(iLeft+2, (iTop+7)-TextHeight('あ') div 2, cad.sWarnToEmg);
      Pen.Color := $007A2E41;
      Rectangle(iLeft, iTop, iLeft + r.Width, iTop + 16);
      pngList.Items[11].PngImage.Draw(imgBack.Canvas, Rect(iLeft+r.Width-18, iTop, iLeft+r.Width-2, iTop+16));
      bDraw := True;
    end;

    //警報
    if bDraw  then
    	iTop := 47;
    iLeft := 4;
    bDraw := False;
    if cad.sWarning <> '' then
    begin
      iWidth := TextWidth(cad.sWarning) + 5;
      r.Top := iTop;  r.Left := iLeft;  r.Width := iWidth;  r.Height := 16;
      pngList.Items[6].PngImage.Draw(imgBack.Canvas, r);
      Font.Color := clWhite;
      TextOut(iLeft+2, (iTop+7)-TextHeight('あ') div 2, cad.sWarning);
      Pen.Color := $000C0092;
      Rectangle(iLeft, iTop, iLeft + r.Width, iTop + 16);
      iLeft := iLeft + iWidth + 2;
      bDraw := True;
    end;
    //警報予備軍
    if cad.sAdvToWarn <> '' then
    begin
      iWidth := TextWidth(cad.sAdvToWarn) + 21;
      r.Top := iTop;  r.Left := iLeft;  r.Width := iWidth;  r.Height := 16;
      pngList.Items[5].PngImage.Draw(imgBack.Canvas, r);
      Brush.Style := bsClear;
      Font.Color := clBlack;
      TextOut(iLeft+2, (iTop+7)-TextHeight('あ') div 2, cad.sAdvToWarn);
      Pen.Color := $000C0092;
      Rectangle(iLeft, iTop, iLeft + r.Width, iTop + 16);
      pngList.Items[10].PngImage.Draw(imgBack.Canvas, Rect(iLeft+r.Width-18, iTop, iLeft+r.Width-2, iTop+16));
      bDraw := True;
    end;

    //注意報
    if bDraw  then
    	iTop := iTop + 17;
    iLeft := 4;
    if cad.sAdvisory <> '' then
    begin
      iWidth := TextWidth(cad.sAdvisory) + 5;
      r.Top := iTop;  r.Left := iLeft;  r.Width := iWidth;  r.Height := 16;
      pngList.Items[cad.iAdvisory].PngImage.Draw(imgBack.Canvas, r);
      Font.Color := clBlack;
      TextOut(iLeft+2, (iTop+7)-TextHeight('あ') div 2, cad.sAdvisory);
      Pen.Color := $000087A2;
      Rectangle(iLeft, iTop, iLeft + r.Width, iTop + 16);
    end;
  end;//with
end;

procedure TfrmMain._DrawDailyData(ScrollType: Integer);
var
  r : TRect;
  i, iStart, iEnd, iLeft, iTop : Integer;
  sTmp : String;
  bDisabled : Boolean;
begin
  //他のタイマーを止める
  timDailyWait.Enabled := False;
  timWeeklyWait.Enabled := False;
  timWeeklyScroll.Enabled := False;

  BitBlt(imgBack.Canvas.Handle, 0, 79, 280, 108,
         bmpCache.Canvas.Handle, 0, 79, SRCCOPY);
  with imgBack.Canvas do
  begin
    iStart := 1;
    iEnd := High(dwd)-1;
    Case ScrollType of
      0 : //Back
        begin
          iStart := av.iCurFirstIndex - 1;
          iEnd := av.iCurLastIndex - 1;
        end;
      1 : //Current
        begin
          iStart := av.iCurIndex;
          iEnd := av.iCurIndex + 6;
        end;
      2 : //Next
        begin
          iStart := av.iCurFirstIndex + 1;
          iEnd := av.iCurLastIndex +1;
        end;
    end;

    //今日
    Pen.Color := skin.cToday;
    Rectangle(0, 79, 280, 80);
    Font.Color := skin.cFontColor;
    Font.Name := skin.sFontName;
    iLeft := 20;
    Brush.Style := bsClear;
    for i := iStart to iEnd do
    begin
      if i < (av.iCurIndex-1) then
      begin
        Font.Color := skin.cFontColorInvalid;
        bDisabled := True;
      end else
      begin
        Font.Color := skin.cFontColor;
        bDisabled := False;
      end;
      //アイコンの描画
      r.Left := iLeft - 12;
      r.Top := 100;
      r.Width := 24;
      r.Height := 24;
      if Not bDisabled then
        pngSImages.PngImages[dwd[i].iIconIndex].PngImage.Draw(imgBack.Canvas, r)
      else
        pngSDisabled.PngImages[dwd[i].iIconIndex].PngImage.Draw(imgBack.Canvas, r);

      Font.Size := skin.iFontSize;
      //時間
      if bDisabled then
        Font.Color := skin.cFontColorInvalid
      else
        Font.Color := skin.cTime;
      sTmp := dwd[i].sTime;
      _DrawFontBorder(sTmp, font.Color, iLeft - (TextWidth(sTmp) div 2), 90 - (TextHeight('あ') div 2), skin.bIsBorder);
//      TextOut(iLeft - (TextWidth(sTmp) div 2), 90 - (TextHeight('あ') div 2), sTmp);
      Case dwd[i].iDay of
        1 : Pen.Color := skin.cNextDay;
        2 : Pen.Color := skin.cAftTom;
      end;
      Rectangle(iLeft-20, 79, iLeft+20, 80);
      iTop := 125;
      //気温
      if idd.bKion then
      begin
        if bDisabled then
          Font.Color := skin.cFontColorInvalid
        else
          Font.Color := skin.cFontColor;
        //フォントサイズ
        if _IsYahoo then
          Font.Size := skin.iFontSize
        else
          Font.Size := skin.iFontSize-1;
        sTmp := dwd[i].sKion + '℃';
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop, sTmp);
        iTop := iTop + idd.iDailyHeight;
      end;
      //湿度
      if idd.bShitsudo then
      begin
        Font.Size := skin.iFontSize;
        sTmp := dwd[i].sShitsudo + '%';
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop, sTmp);
        iTop := iTop + idd.iDailyHeight;
      end;
      //降水確率(tenki.jpのみ)
      if Not _IsYahoo and idd.bRainPercent then
      begin
        Font.Size := skin.iFontSize;
        sTmp := dwd[i].sRainPercent + '%';
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop, sTmp);
        iTop := iTop + idd.iDailyHeight;
      end;
      //降水量
      if idd.bRain then
      begin
        Font.Size := skin.iFontSize;
        sTmp := dwd[i].sRain + 'mm';
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop, sTmp);
        iTop := iTop + idd.iDailyHeight;
      end;
      //風
      if idd.bWindDirec then
      begin
        Font.Size := 7;
        sTmp := dwd[i].sWindDirec;
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop+2, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop+2, sTmp);
        iTop := iTop + idd.iDailyHeight;
      end;
      if idd.bWindStrong then
      begin
        Font.Size := skin.iFontSize;
        sTmp := dwd[i].sWindStrong + 'm';
        _DrawFontBorder(sTmp, Font.Color, iLeft - (TextWidth(sTmp) div 2), iTop, skin.bIsBorder);
//        TextOut(iLeft - (TextWidth(sTmp) div 2), iTop, sTmp);
      end;
      iLeft := iLeft + 40;
    end;
    Case ScrollType of
      0 :
        begin
          av.iCurFirstIndex := av.iCurFirstIndex - 1;
          av.iCurLastIndex := av.iCurLastIndex - 1;
        end;
      1 :
        begin
          av.iCurFirstIndex := av.iCurIndex;
          av.iCurLastIndex := av.iCurIndex + 6;
        end;
      2 :
        begin
          av.iCurFirstIndex := av.iCurFirstIndex + 1;
          av.iCurLastIndex := av.iCurLastIndex + 1;
        end;
    end;
  end;
end;

procedure TfrmMain._DrawEscapeInformation;
var
  r : TRect;
  sCaution : String;
  iTop, idx, iHeight : Integer;
  bDraw : Boolean;
begin
  with imgBack.Canvas do
  begin
    //避難情報
    bDraw := False;
    iTop := 4;
    idx := 0;
    Brush.Style := bsSolid;
    Font.Size := 9;
    iHeight := TextHeight('あ');
    //防災情報のURLを作成する
    popShowEvacuation.Hint := crd.sUrl;

    if crd.sHinanString = '警戒区域' then
    begin
      Brush.Color := $00C04866;
    	Font.Color := clWhite;
      sCaution := '警戒区域';
      idx := 4;
      bDraw := True;
    end
    else if crd.sHinanString = '避難指示' then
    begin
      Brush.Color := $001300E6;
    	Font.Color := clWhite;
      sCaution := '避難指示';
      idx := 3;
      bDraw := True;
    end
    else if crd.sHinanString = '避難勧告' then
    begin
      Brush.Color := $000095FF;
    	Font.Color := clBlack;
      sCaution := '避難勧告';
      idx := 2;
      bDraw := True;
    end
    else if crd.sHinanString = '避難準備' then
    begin
      Brush.Color := $0000D4FF;
    	Font.Color := clBlack;
      sCaution := '避難準備';
      idx := 1;
      bDraw := True;
    end;
    if bDraw then
    begin
      r.Top := iTop;  r.Left := 100; r.Width := 80; r.Height := 20;
      pngList.Items[idx].PngImage.Draw(imgBack.Canvas, r);
      Brush.Style := bsClear;
      TextOut(139-(TextWidth(sCaution) div 2), (iTop+10)-(iHeight div 2), sCaution);
      iTop := iTop + 22;
    end;

    //土砂災害警戒情報
    bDraw := False;
    if crd.sDoshyaString = '土砂災害警戒' then
    begin
      Brush.Style := bsSolid;
      Brush.Color := $001300E6;
    	Font.Color := clWhite;
      sCaution := '土砂災害警戒';
      idx := 3;
      bDraw := True;
    end;
    if bDraw then
    begin
      r.Top := iTop;  r.Left := 100; r.Width := 80; r.Height := 20;
      pngList.Items[idx].PngImage.Draw(imgBack.Canvas, r);
      Brush.Style := bsClear;
      TextOut(139-(TextWidth(sCaution) div 2), (iTop+10)-(iHeight div 2), sCaution);
      iTop := iTop + 22;
    end;

    //河川情報
    bDraw := False;
    if crd.sRiverString = '氾濫発生情報' then
    begin
      Brush.Style := bsSolid;
      Brush.Color := $00C04866;
    	Font.Color := clWhite;
      sCaution := '氾濫発生情報';
      idx := 4;
      bDraw := True;
    end
    else if crd.sRiverString = '氾濫危険情報' then
    begin
      Brush.Style := bsSolid;
      Brush.Color := $001300E6;
    	Font.Color := clWhite;
      sCaution := '氾濫危険情報';
      idx := 3;
      bDraw := True;
    end
    else if crd.sRiverString = '氾濫警戒情報' then
    begin
      Brush.Style := bsSolid;
      Brush.Color := $000095FF;
    	Font.Color := clBlack;
      sCaution := '氾濫警戒情報';
      idx := 2;
      bDraw := True;
    end
    else if crd.sRiverString = '氾濫注意情報' then
    begin
      Brush.Style := bsSolid;
      Brush.Color := $0000D4FF;
    	Font.Color := clBlack;
      sCaution := '氾濫注意情報';
      idx := 1;
      bDraw := True;
    end;
    if bDraw then
    begin
      r.Top := iTop;  r.Left := 100; r.Width := 80; r.Height := 20;
      pngList.Items[idx].PngImage.Draw(imgBack.Canvas, r);
      Brush.Style := bsClear;
      TextOut(139-(TextWidth(sCaution) div 2), (iTop+10)-(iHeight div 2), sCaution);
    end;
  end;//with
end;

procedure TfrmMain._DrawFontBorder(sText: String; cFontColor: TColor; iLeft, iTop: Integer; bIsDraw: Boolean);
begin
  if bIsDraw then
  begin
    with imgBack.Canvas do
    begin
      Font.Color := skin.cBorder;
      TextOut(iLeft-1, iTop-1, sText);
      TextOut(iLeft+1, iTop-1, sText);
      TextOut(iLeft-1, iTop+1, sText);
      TextOut(iLeft+1, iTop+1, sText);
    end;
  end;

  with imgBack.Canvas do
  begin
    Font.Color := cFontColor;
    TextOut(iLeft, iTop, sText);
  end;
end;

procedure TfrmMain._DrawNowData(bIsCache: Boolean);
var
  iStart, iTop : Integer;
  sTmp : String;
begin
  //現在の時間帯
  with imgBack.Canvas do
  begin
    iStart := av.iCurIndex-1;
    Brush.Style := bsClear;
    Font.Name := skin.sFontName;
    //場所データ
    Font.Size := 7;
    Font.Color := skin.cFontColor;
    _DrawFontBorder(av.sPlace, skin.cFontColor, 4, 4, skin.bIsBorder);
//    TextOut(4, 4, av.sPlace);
    if IsDebugMode then
      _DrawFontBorder('Debug Mode ', skin.cFontColor, 4, 64, skin.bIsBorder)
//      TextOut(4, 64, 'Debug Mode ')
    else
      _DrawFontBorder(FormatDateTime('更新:D日 HH:NN:SS ', Now), skin.cFontColor, 4, 64, skin.bIsBorder);
//      TextOut(4, 64, FormatDateTime('更新:D日 HH:NN:SS ', Now));
    Font.Size := 8;
    _DrawFontBorder(FormatDateTime('M月D日 ', Now) + dwd[iStart].sTime, skin.cFontColor, 4, 22-(TextHeight('あ') div 2), skin.bIsBorder);
//    TextOut(4, 22-(TextHeight('あ') div 2), FormatDateTime('M月D日 ', Now) + dwd[iStart].sTime);
    //気象データ
    Font.Size := 20;
    Font.Color := skin.cFontColor;
    sTmp := dwd[iStart].sKion + '℃';
    _DrawFontBorder(sTmp, skin.cFontColor, 270 - (TextWidth(sTmp)), 0, skin.bIsBorder);
//    TextOut(270 - (TextWidth(sTmp)), 0, sTmp);

    iTop := 40;
    Font.Size := 7;
    //湿度
    if idd.bNowShitsudo then
    begin
      pngSSImages.PngImages[0].PngImage.Draw(imgBack.Canvas, Rect(216, iTop, 228, iTop+12));
      _DrawFontBorder(dwd[iStart].sShitsudo + '%', skin.cFontColor, 230, iTop, skin.bIsBorder);
//      TextOut(230, iTop, dwd[iStart].sShitsudo + '%');
      iTop := iTop + 12;
    end;
    //降水量
    if idd.bNowRain then
    begin
      pngSSImages.PngImages[1].PngImage.Draw(imgBack.Canvas, Rect(216, iTop, 228, iTop+12));
      _DrawFontBorder(dwd[iStart].sRain + 'mm', skin.cFontColor, 230, iTop, skin.bIsBorder);
//      TextOut(230, iTop, dwd[iStart].sRain + 'mm');
      iTop := iTop + 12;
    end;
    //風
    if idd.bNowWind then
    begin
      pngSSImages.PngImages[2].PngImage.Draw(imgBack.Canvas, Rect(216, iTop, 228, iTop+12));
      _DrawFontBorder(dwd[iStart].sWindDirec + dwd[iStart].sWindStrong + 'm', skin.cFontColor, 230, iTop, skin.bIsBorder);
//      TextOut(230, iTop, dwd[iStart].sWindDirec + dwd[iStart].sWindStrong + 'm');
    end;

    //トレイアイコンのHintを設定
    if _IsYahoo then
    begin
      TrayIcon.Hint := '天候:' + dwd[iStart].sWeather + #13#10 +
                       '気温:' + dwd[iStart].sKion + '℃' + #13#10 +
                       '湿度:' + dwd[iStart].sShitsudo + '%' + #13#10 +
                       '降水量:' + dwd[iStart].sRain + 'mm' + #13#10 +
                       '風:' + dwd[iStart].sWindDirec + dwd[iStart].sWindStrong + 'm';
    end
    else
    begin
      TrayIcon.Hint := '天候:' + dwd[iStart].sWeather + #13#10 +
                       '気温:' + dwd[iStart].sKion + '℃' + #13#10 +
                       '湿度:' + dwd[iStart].sShitsudo + '%' + #13#10 +
                       '降水確率:' + dwd[iStart].sRainPercent + '%' + #13#10 +
                       '降水量:' + dwd[iStart].sRain + 'mm' + #13#10 +
                       '風:' + dwd[iStart].sWindDirec + dwd[iStart].sWindStrong + 'm';
    end;
    pngWeather.PngImages[dwd[iStart].iIconIndex].PngImage.Draw(imgBack.Canvas, Rect(110, 10, 170, 70));
    TrayIcon.Icons := nil;
    TrayIcon.Icons := pngSImages;
    TrayIcon.IconIndex := dwd[iStart].iIconIndex;
  end;
end;

procedure TfrmMain._DrawWeeklyData(iStartIndex: Integer);
  procedure _DrawWeatherWeekly(const sWeather: String; iPosX: Integer);
  var
    s1, s2 : String;
    idx : Integer;
  begin
    //A時々B のような形
    if ContainsText(sWeather, '時々') then
    begin
      SplitStringsToAandB(sWeather, '時々', s1, s2);
      //Bを先に描画
      idx := _GetWeatherIndex(s2, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX+6, 210, iPosX+30, 234));
      //Aを描画
      idx := _GetWeatherIndex(s1, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX-6, 210, iPosX+18, 234));
    end
    else if ContainsText(sWeather, '一時') then
    begin
      splitStringsToAandB(sWeather, '一時', s1, s2);
      //Aを描画
      idx := _GetWeatherIndex(s1, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX, 210,iPosX+24, 234));
      //Bを描画
      idx := _GetWeatherIndex(s2, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX+18, 220, iPosX+30, 234));
      //区切り線
      pngList.Items[9].PngImage.Draw(imgBack.Canvas, Rect(iPosX+6, 218, iPosX+18, 234));
    end
    else if ContainsText(sWeather, 'のち') then
    begin
      SplitStringsToAandB(sWeather, 'のち', s1, s2);
      //Aを先に描画
      idx := _GetWeatherIndex(s1, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX-6, 210, iPosX+18, 234));
      //Bを描画
      idx := _GetWeatherIndex(s2, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX+6, 210, iPosX+30, 234));
      //矢印
      pngList.Items[8].PngImage.Draw(imgBack.Canvas, Rect(iPosX+6, 218, iPosX+18, 234));
    end else
    begin
      idx := _GetWeatherIndex(sWeather, '12時');
      pngSImages.PngImages[idx].PngImage.Draw(imgBack.Canvas, Rect(iPosX, 210, iPosX+24, 234));
    end;
  end;

var
  sTmp : String;
  x1, x2, i : Integer;
begin
  //他のタイマーを止める
  timDailyWait.Enabled := False;
  timDailyScroll.Enabled := False;
  timWeeklyWait.Enabled := False;

  BitBlt(imgBack.Canvas.Handle, 0, 188, 279, 92,
         bmpCache.Canvas.Handle, 0, 188, SRCCOPY);
  with imgBack.Canvas do
  begin
    Font.Name := skin.sFontName;
    Font.Size := skin.iFontSize;
    Font.Color := skin.cFontColor;
    Brush.Style := bsClear;
    x1 := 12;
    x2 := 23;

    for i := iStartIndex to (iStartIndex+5) do
    begin
      _DrawWeatherWeekly(wwd[i].sWeather, x1);
      Font.Color := skin.cDate;
      sTmp := wwd[i].sDay;
      _DrawFontBorder(sTmp, Font.Color, x2 - (TextWidth(sTmp) div 2), 198 - (TextHeight('あ') div 2), skin.bIsBorder);
//      TextOut(x2 - (TextWidth(sTmp) div 2), 198 - (TextHeight('あ') div 2), sTmp);
      Font.Color := skin.cFontColor;
      sTmp := wwd[i].sHigh + '℃';
      Font.Color := skin.cFontColorHigh;
      _DrawFontBorder(sTmp, Font.Color, x2 - (TextWidth(sTmp) div 2), 235, skin.bIsBorder);
//      TextOut(x2 - (TextWidth(sTmp) div 2), 235, sTmp);
      sTmp := wwd[i].sLow + '℃';
      Font.Color := skin.cFontColorLow;
      _DrawFontBorder(sTmp, Font.Color, x2 - (TextWidth(sTmp) div 2), 248, skin.bIsBorder);
//      TextOut(x2 - (TextWidth(sTmp) div 2), 248, sTmp);
      sTmp := wwd[i].sRain + '%';
      Font.Color := skin.cFontColor;
      _DrawFontBorder(sTmp, Font.Color, x2 - (TextWidth(sTmp) div 2), 260, skin.bIsBorder);
//      TextOut(x2 - (TextWidth(sTmp) div 2), 260, sTmp);
      x1 := x1 + 47;
      x2 := x2 + 47;
    end;
  end;
end;

procedure TfrmMain._EditFavorite(Sender: TObject);
begin
  Application.CreateForm(TfrmEditFavorite, frmEditFavorite);
  frmEditFavorite.Show;
end;

procedure TfrmMain._ExecuteFavorite(Sender: TObject);
var
  sl : TStringList;
  ini : TMemIniFile;
begin
  sl := TStringList.Create;
  try
    sl.CommaText := TSpTBXItem(Sender).Hint;
    av.sUrl := sl[1];
    av.sSiteName := sl[2];
  finally
    sl.Free;
  end;
  _LoadAllData(False);
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteString('frmMain', 'Site', av.sSiteName);
    ini.WriteString('frmMain', 'Url', av.sUrl);
    ini.WriteString('frmMain', 'UrlRain', av.sUrlRain);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._ExecuteWeatherHistory(Sender: TObject);
var
  sl : TStringList;
  sFile, sHint : String;
  idx : Integer;
begin
  sHint := TSpTBXItem(Sender).Hint;
  sl := TStringList.Create;
  try
    sl.CommaText := sHint;
    av.sUrl := sl[1];
    av.sSiteName := sl[2];
  finally
    sl.Free;
  end;
  _LoadAllData(False);

  //履歴ファイルの変更
  sl := TStringList.Create;
  try
    sFile := GetApplicationPath + 'Data\History.txt';
    sl.LoadFromFile(sFile, TEncoding.UTF8);
    idx := sl.IndexOf(sHint);
    sl.Delete(idx);
    sl.Insert(0, sHint);
    sl.SaveToFile(sFile, TEncoding.UTF8);
  finally
    sl.Free;
  end;
end;

function TfrmMain._GetWeatherIndex(const sWeather, sTime: String): Integer;
var
  idx : Integer;
begin
  if ContainsText(sWeather, '晴') then
    if ContainsText('18時21時0時3時', sTime) then
      idx := 1
    else
      idx := 0
  else if ContainsText(sWeather, '曇') then
    idx := 2
  else if ContainsText(sWeather, '弱雨') then
    idx := 3
  else if ContainsText(sWeather, '強雨') then
    idx := 4
  else if ContainsText(sWeather, '雨') then
    idx := 4
  else if ContainsText(sWeather, '雪') then
    idx := 5
  else if ContainsText(sWeather, '暴風雨') then
    idx := 6
  else
    idx := 7;
  Result := idx;
end;

function TfrmMain._IsYahoo: Boolean;
begin
  if av.sSiteName = 'yahoo.co.jp' then
    Result := True
  else
    Result := False;
end;

procedure TfrmMain._LoadAllData(bIsCache: Boolean);
var
  r : TRect;
begin
  if _IsYahoo then
    Yahoo._CreateWeatherData(av.sUrl, bIsCache)
  else
    TenkiJP._CreateWeatherData(av.sUrl, bIsCache);

  if av.bConnect then
  begin
    av.iWeeklyCurIndex := 1;
    _LoadBackgroundImage;
    _LoadWeatherData;
    _SetDailyItemHeight;
    _SetDailyCurrentIndex;
    _DrawNowData(bIsCache);
    _DrawDailyData(1);
    _DrawWeeklyData(av.iWeeklyCurIndex);
    _DrawCaution;
    _DrawEscapeInformation;
  end
  else
  begin
    with imgBack.Canvas do
    begin
      r.Left := 110;  r.Top := 10;  r.Width := 60; r.Height := 60;
      pngList.Items[0].PngImage.Draw(imgBack.Canvas, r);
      imgBack.Repaint;
      Application.ProcessMessages;
    end;
  end;
end;

procedure TfrmMain._LoadBackgroundImage;
var
  sFile : String;
  r : TRegIniFile;
  bmp : TBitmap;
  jpg : TJPEGImage;
  png : TPngImage;
  sWall : String;
begin
  imgBack.Picture.Bitmap := nil;
  sFile := FindFile(Format('%simages\%s\Background.*', [GetApplicationPath, av.sSkinDir]));
//  sFile := Format('%simages\%s\Background.bmp', [GetApplicationPath, av.sSkinDir]);
  if Not av.bSetWallpaper then
    imgBack.Picture.LoadFromFile(sFile)
  else
  begin
    r := TRegIniFile.Create('Control Panel');
    try
      sWall := r.ReadString('Desktop', 'Wallpaper', '');
    finally
      r.Free;
    end;

    if ContainsText('.bmp', ExtractFileExt(sWall)) then
    begin
      bmp := TBitmap.Create;
      try
        bmp.LoadFromFile(sWall);
        BitBlt(imgBack.Canvas.Handle, 0, 0, 280, 280,
               bmp.Canvas.Handle, Self.Left, Self.Top, SRCCOPY);
      finally
        bmp.Free;
      end;
    end
    else if ContainsText('.jpg.jpeg', ExtractFileExt(sWall)) then
    begin
      jpg := TJPEGImage.Create;
      try
        jpg.LoadFromFile(sWall);
        BitBlt(imgBack.Canvas.Handle, 0, 0, 280, 280,
               jpg.Canvas.Handle, Self.Left, Self.Top, SRCCOPY);
      finally
        jpg.Free;
      end;
    end
    else if ContainsText('.png', ExtractFileExt(sWall)) then
    begin
      png := TPngImage.Create;
      try
        png.LoadFromFile(sWall);
        BitBlt(imgBack.Canvas.Handle, 0, 0, 280, 280,
               png.Canvas.Handle, Self.Left, Self.Top, SRCCOPY);
      finally
        png.Free;
      end;
    end;
  end;
  bmpCache.Assign(imgBack.Picture.Bitmap);
end;

procedure TfrmMain._LoadFavortie(Sender: TSpTBXItem);
var
  item : TSpTBXItem;
  Sep : TSpTBXSeparatorItem;
  ini : TMemIniFile;
  sl, sm : TStringList;
  i : Integer;
  sName, sUrl, sSite : String;
begin
  //初期化
  Sender.Clear;
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\Favorite.ini', TEncoding.UTF8);
  sl := TStringList.Create;
  sm := TStringList.Create;
  try
    ini.ReadSections(sl);
    for i := 0 to sl.Count-1 do
    begin
      sName := ini.ReadString('Favorite' + IntToStr(i), 'Name', '');
      sUrl :=  ini.ReadString('Favorite' + IntToStr(i), 'Url', '');
      sSite :=  ini.ReadString('Favorite' + IntToStr(i), 'Site', 'yahoo.co.jp');
      sm.Clear;
      sm.Add(sName);
      sm.Add(sUrl);
      sm.Add(sSite);
      item := TSpTBXItem.Create(Self);
      item.Caption := Format('%s(%s)', [sName, sSite]);
      item.Hint := sm.CommaText;// sUrl + '%' + sSite;
      item.OnClick := _ExecuteFavorite;
      if item.Caption = Format('%s(%s)', [av.sPlace, av.sSiteName]) then
        item.Checked := True;
      Sender.Add(item);
    end;
  finally
    ini.Free;
    sl.Free;
    sm.Free;
  end;
  //お気に入りの編集機能
  sep := TSpTBXSeparatorItem.Create(Self);
  Sender.Add(sep);
  item := TSpTBXItem.Create(Self);
  item.Caption := 'この地域をお気に入りに追加';
  item.OnClick := _AddFavorite;
  Sender.Add(item);
  item := TSpTBXItem.Create(Self);
  item.Caption := 'お気に入りの編集...';
  item.OnClick := _EditFavorite;
  Sender.Add(item);
end;

procedure TfrmMain._LoadSettings;
var
  ini : TMemIniFile;
  sl : TStringList;
  i : Integer;
  sHotKey : String;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  sl := TStringList.Create;
  try
    Self.AutoSize := True;
    ini.ReadWindow(Self.Name, Self);
    av.sSiteName      := ini.ReadString(Self.Name, 'Site', 'yahoo.co.jp');
    av.sUrl           := ini.ReadString(Self.Name, 'URL', 'https://weather.yahoo.co.jp/weather/jp/13/4410/13101.html');
    av.sUrlRain       := ini.ReadString(Self.Name, 'URLRain', 'https://weather.yahoo.co.jp/weather/raincloud/13/?c=g2');
    av.sSkinDir       := ini.ReadString(Self.Name, 'SkinDir', 'Default');
    av.bEdgeScroll    := ini.ReadBool(Self.Name, 'EdgeScroll', False);
    av.bFixedWindow   := ini.ReadBool(Self.Name, 'FixedWindow', False);
    av.bUseProxy      := ini.ReadBool(Self.Name, 'UseProxy', False);
    av.sProxyServer   := ini.ReadString(Self.Name, 'ProxyServer', '');
    av.sProxyPort     := ini.ReadString(Self.Name, 'ProxyPort', '');
    av.iScrollTime    := ini.ReadInteger(Self.Name, 'ScrollTime', 200);
    av.sBrowser       := ini.ReadString(Self.Name, 'Browser', 'iexplore.exe');
    av.bGetFromYahoo  := ini.ReadBool(Self.Name, 'GetFromYahoo', False);
    av.iScrollWaitTime:= ini.ReadInteger(Self.Name, 'ScrollWaitTime', 500);
    av.bSetWallpaper  := ini.ReadBool(Self.Name, 'SetWallpaper', False);
    av.bUseWinCursor  := ini.ReadBool(Self.Name, 'UseWinCursor', False);
    skin.bIsBorder      := ini.ReadBool(Self.Name, 'FontBorder', False);
    idd.bKion         := ini.ReadBool(Self.Name, 'DrawKion', True);
    idd.bShitsudo     := ini.ReadBool(Self.Name, 'DrawShitsudo', True);
    idd.bRainPercent  := ini.ReadBool(Self.Name, 'RainPercent', False);
    idd.bRain         := ini.ReadBool(Self.Name, 'DrawRain', True);
    idd.bWindDirec    := ini.ReadBool(Self.Name, 'DrawWindDirec', True);
    idd.bWindStrong   := ini.ReadBool(Self.Name, 'DrawWindStrong', True);
    idd.bNowShitsudo  := ini.ReadBool(Self.Name, 'DrawNowShitsudo', True);
    idd.bNowRain      := ini.ReadBool(Self.Name, 'DrawNowRain', True);
    idd.bNowWind      := ini.ReadBool(Self.Name, 'DrawNowWind', True);
    Self.AlphaBlendValue := ini.ReadInteger(Self.Name, 'AlphaValue', 255);
    sHotKey           := ini.ReadString(Self.Name, 'HotKey', '');
    HookHotKey.Add(0, TextToShortCut(sHotKey));
    //取得時間
    sl.CommaText    := ini.ReadString(Self.Name, 'TimeList', '0,20,40');
    for i := 0 to sl.Count-1 do
      System.Include(TimeList, StrToIntDefEx(sl[i], 0));

    popFixed.Checked := av.bFixedWindow;
    popTrayFixed.Checked := av.bFixedWindow;
    timDailyScroll.Interval := av.iScrollTime;
    timDailyWait.Interval := av.iScrollWaitTime;
    timWeeklyScroll.Interval := av.iScrollTime;
    timWeeklyWait.Interval := av.iScrollWaitTime;

    if ini.ReadBool(Self.Name, 'RunMinimized', False) then
      Self.WindowState := wsMinimized;

    //カーソルの読み込み
    Screen.Cursors[crBackAll] := LoadCursor(HInstance, 'BACKALL');
    Screen.Cursors[crBack]    := LoadCursor(HInstance, 'BACK');
    Screen.Cursors[crReload]  := LoadCursor(HInstance, 'RELOAD');
    Screen.Cursors[crNext]    := LoadCursor(HInstance, 'NEXT');
    Screen.Cursors[crNextAll] := LoadCursor(HInstance, 'NEXTALL');

  finally
    ini.Free;
    sl.Free;
  end;
end;

procedure TfrmMain._LoadSkin;
var
  ini : TMemIniFile;
  sSkin : String;
begin
  sSkin := Format('%simages\%s\Settings.ini', [GetApplicationPath, av.sSkinDir]);
  ini := TMemIniFile.Create(sSkin, TEncoding.UTF8);
  try
    skin.sFontName          := ini.ReadString('Font', 'Name', 'メイリオ');
    skin.iFontSize          := ini.ReadInteger('Font', 'Size', 8);
    skin.bIsBorder          := ini.ReadBool('Font', 'FontBorder', False);
    skin.cFontColor         := RGBStringToColor(ini.ReadString('FontColor', 'Basic', '228,228,228'));
    skin.cFontColorInvalid  := RGBStringToColor(ini.ReadString('FontColor', 'Past', '149,149,149'));
    skin.cTime              := RGBStringToColor(ini.ReadString('FontColor', 'Time', '228,228,228'));
    skin.cDate              := RGBStringToColor(ini.ReadString('FontColor', 'Date', '228,228,228'));
    skin.cFontColorHigh     := RGBStringToColor(ini.ReadString('FontColor', 'TempHigh', '250,64,64'));
    skin.cFontColorLow      := RGBStringToColor(ini.ReadString('FontColor', 'TempLow', '72,191,249'));
    skin.cToday             := RGBStringToColor(ini.ReadString('FontColor', 'Today', '24,190,6'));
    skin.cNextDay           := RGBStringToColor(ini.ReadString('FontColor', 'Tomorrow', '17,134,4'));
    skin.cAftTom            := RGBStringToColor(ini.ReadString('FontColor', 'AfterTomorrow', '17,134,4'));
    skin.cBorder            := RGBStringToColor(ini.ReadString('FontColor', 'Border', '0,0,0'));
  finally
    ini.Free;
  end;
//  _ConvertImages;
end;

procedure TfrmMain._LoadWeatherData;
var
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\WeatherData.ini', TEncoding.UTF8);
  try
    av.sPlace  := ini.ReadString('General', 'Place', '');
    av.sUrlRain:= ini.ReadString('General', 'RainUrl', '');

    if av.sSiteName = 'yahoo.co.jp' then
       SetLength(dwd, 17)
    else if av.sSiteName = 'tenki.jp-3h' then
      SetLength(dwd, 26)
    else
      SetLength(dwd, 74); //1時間予報

    for i := 1 to High(dwd) do
    begin
      dwd[i].iDay         := ini.ReadInteger('Day'+IntToStr(i), 'Day', 0);
      dwd[i].bPast        := ini.ReadBool('Day'+IntToStr(i), 'IsPassed', True);
      dwd[i].sTime        := ini.ReadString('Day'+IntToStr(i), 'Time', '');
      dwd[i].sWeather     := ini.ReadString('Day'+IntToStr(i), 'Weather', '');
      dwd[i].sKion        := ini.ReadString('Day'+IntToStr(i), 'Kion', '');
      dwd[i].sShitsudo    := ini.ReadString('Day'+IntToStr(i), 'Shitsudo', '');
      dwd[i].sRainPercent := ini.ReadString('Day'+IntToStr(i), 'RainPercent', '');
      dwd[i].sRain        := ini.ReadString('Day'+IntToStr(i), 'Rain', '');
      dwd[i].sWindDirec   := ini.ReadString('Day'+IntToStr(i), 'WindDirection', '');
      dwd[i].sWindStrong  := ini.ReadString('Day'+IntToStr(i), 'WindStrong', '');
      dwd[i].iIconIndex   := ini.ReadInteger('Day'+IntToStr(i), 'ImageIndex', -1);
    end;
    for i := 1 to High(wwd) do
    begin
    	wwd[i].sDay     := ini.ReadString('Weekly'+IntToStr(i), 'Date', '');
    	wwd[i].sWeather := ini.ReadString('Weekly'+IntToStr(i), 'Weather', '');
    	wwd[i].sHigh    := ini.ReadString('Weekly'+IntToStr(i), 'TempHigh', '');
    	wwd[i].sLow     := ini.ReadString('Weekly'+IntToStr(i), 'TempLow', '');
    	wwd[i].sRain    := ini.ReadString('Weekly'+IntToStr(i), 'Rain', '');
    end;
    cad.sEmgWarning   := ini.ReadString('Cautions', 'EmgWarning', '');
    cad.iEmgWarning   := 7;
    cad.sWarnToEmg    := ini.ReadString('Cautions', 'WarnToEmg', '');
    cad.iWarnToEmg    := 6;
    cad.sWarning      := ini.ReadString('Cautions', 'Warning', '');
    cad.iWarning      := 6;
    cad.sAdvToWarn    := ini.ReadString('Cautions', 'AdvToWarn', '');
    cad.iAdvToWarn    := 5;
    cad.sAdvisory     := ini.ReadString('Cautions', 'Advisory', '');
    cad.iAdvisory     := 5;
    crd.sUrl          := ini.ReadString('Crisis', 'Url', '');
    crd.sHinanString  := ini.ReadString('Crisis', 'HinanType', '');
    crd.sDoshyaString := ini.ReadString('Crisis', 'DoshyaType', '');
    crd.sRiverString  := ini.ReadString('Crisis', 'RiverType', '');
  finally
    ini.Free;
  end;
end;

procedure TfrmMain._LoadWeatherHistory(Sender: TSpTBXItem);
var
  item : TSpTBXItem;
  sl, sm : TStringList;
  sFile : String;
  i : Integer;
begin
  sl := TStringList.Create;
  sm := TStringList.Create;
  try
    sFile := GetApplicationPath + 'Data\History.txt';
    if FileExists(sFile) then
    begin
    	sl.LoadFromFile(sFile, TEncoding.UTF8);
      for i := 0 to sl.Count-1 do
      begin
        sm.CommaText := sl[i];
        item := TSpTBXItem.Create(Self);
        item.Caption := Format('%s(%s)', [sm[0], sm[2]]);
        item.Hint := sl[i];//sm[1] + '%' + sm[2];
        item.OnClick := _ExecuteWeatherHistory;
        popHistory.Add(item);
      end;
    end;
  finally
    sl.Free;
    sm.Free;
  end;
end;

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindow(Self.Name, Self);
    ini.WriteString(Self.Name, 'Site', av.sSiteName);
    ini.WriteString(Self.Name, 'URL', av.sUrl);
    ini.WriteString(Self.Name, 'URLRain', av.sUrlRain);
    ini.WriteString(Self.Name, 'SkinDir', av.sSkinDir);
    //一般
    ini.WriteBool(Self.Name, 'EdgeScroll', av.bEdgeScroll);
    ini.WriteInteger(Self.Name, 'ScrollTime', av.iScrollTime);
    ini.WriteString(Self.Name, 'Browser', av.sBrowser);
    ini.WriteBool(Self.Name, 'GetFromYahoo', av.bGetFromYahoo);
    ini.WriteBool(Self.Name, 'FixedWindow', av.bFixedWindow);
    ini.WriteBool(Self.Name, 'SetWallpaper', av.bSetWallpaper);
    //Proxy
    ini.WriteBool(Self.Name, 'UseProxy', av.bUseProxy);
    ini.WriteString(Self.Name, 'ProxyServer', av.sProxyServer);
    ini.WriteString(Self.Name, 'ProxyPort', av.sProxyPort);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain._SetDailyCurrentIndex;
var
  i : Integer;
begin
  //描画を開始する時間帯を決定する
  for i := 1 to High(dwd) do
  begin
    if Not dwd[i].bPast then
    begin
      av.iCurIndex := i+1;
      av.iCurFirstIndex := i+1;
      av.iCurLastIndex := i+7;
      Break;
    end;
  end;
end;

procedure TfrmMain._SetDailyItemHeight;
var
  iCnt : Integer;
begin
  iCnt := 0;
  if idd.bKion then iCnt := iCnt + 1;
  if idd.bShitsudo then iCnt := iCnt + 1;
  if idd.bRainPercent and (Not _IsYahoo) then iCnt := iCnt + 1;
  if idd.bRain then iCnt := iCnt + 1;
  if idd.bWindDirec then iCnt := iCnt + 1;
  if idd.bWindStrong then iCnt := iCnt + 1;
  Case iCnt of
    0..3 : idd.iDailyHeight := 16;
       4 : idd.iDailyHeight := 14;
       5 : idd.iDailyHeight := 12;
       6 : idd.iDailyHeight := 10;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  case key of
//    char(VK_ESCAPE) :
//      begin
//        Key := char(0);
//        Close;
//      end;
//  end;
end;

procedure TfrmMain.HookHotKeyHotKey(Sender: TObject; Index: Integer);
begin
  Application.BringToFront;
end;

procedure TfrmMain.imgBackClick(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  if ContainsInteger(pt.Y, 0, 79) then
    //nothing
  else if ContainsInteger(pt.Y, 80, 187) then
  begin
    //今日明日の天気欄
    if ContainsInteger(pt.X, 0, 119) then
    begin
      if av.iCurFirstIndex > 1 then
        _DrawDailyData(0);
    end
    else if ContainsInteger(pt.X, 120, 159) then
      _DrawDailyData(1)
    else if ContainsInteger(pt.X, 160, 279) then
    begin
      if av.iCurLastIndex < High(dwd) then
        _DrawDailyData(2);
    end;
  end
  else if ContainsInteger(pt.Y, 188, 279) then
  begin
    //週間天気欄
    if ContainsInteger(pt.X, 0, 94) then
    begin
      if av.iWeeklyCurIndex > 1 then
      begin
        av.iWeeklyCurIndex := av.iWeeklyCurIndex-1;
        _DrawWeeklyData(av.iWeeklyCurIndex);
      end;
    end
    else if ContainsInteger(pt.X, 95, 190) then
    begin
    	av.iWeeklyCurIndex := 1;
      _DrawWeeklyData(av.iWeeklyCurIndex);
    end
    else if ContainsInteger(pt.X, 191, 279) then
    begin
      if (av.iWeeklyCurIndex+5) < High(wwd) then
      begin
        av.iWeeklyCurIndex := av.iWeeklyCurIndex+1;
        _DrawWeeklyData(av.iWeeklyCurIndex);
      end;
    end;
  end;
end;

procedure TfrmMain.imgBackMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (not av.bFixedWindow) and (Button = mbLeft) then
  begin
    av.iXX := X;
    av.iYY := Y;
    av.bFlg := True;
  end;
end;

procedure TfrmMain.imgBackMouseLeave(Sender: TObject);
begin
  timDailyWait.Enabled := False;
  timDailyScroll.Enabled := False;
  timWeeklyWait.Enabled := False;
  timWeeklyScroll.Enabled := False;
end;

procedure TfrmMain.imgBackMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  ini : TMemIniFile;
begin
  //フォームをドラッグして移動する
  if (ssLeft in Shift) and ((av.iXX <> X) or (av.iYY <> Y)) and av.bFlg then
  begin
    ReleaseCapture;
    SendMessage(Handle, WM_SYSCOMMAND, SC_MOVE or 2, MakeLong(X, Y));
    av.bFlg := False;
    _LoadAllData(True);
    //位置を保存する
    ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
    try
      ini.WriteWindow(Self.Name, Self);
    finally
      ini.UpdateFile;
      ini.Free;
    end;
  end;

  imgBack.Cursor := crDefault;
  if Not av.bUseWinCursor then
  begin
    //カーソルの変更
    if ContainsInteger(Y, 80, 187) then
    begin
      //今日明日の天気欄
      if ContainsInteger(X, 0, 39) then
      begin
        if av.bEdgeScroll then
          imgBack.Cursor := crBackAll
        else
          imgBack.Cursor := crBack;
      end
      else if ContainsInteger(X, 40, 119) then
        imgBack.Cursor := crBack
      else if ContainsInteger(X, 120, 159) then
        imgBack.Cursor := crReload
      else if ContainsInteger(X, 160, 239) then
        imgBack.Cursor := crNext
      else if ContainsInteger(X, 240, 279) then
      begin
        if av.bEdgeScroll then
          imgBack.Cursor := crNextAll
        else
          imgBack.Cursor := crNext;
      end;
    end
    else if ContainsInteger(Y, 188, 279) then
    begin
      //週間天気欄
      if ContainsInteger(X, 0, 47) then
      begin
        if av.bEdgeScroll then
          imgBack.Cursor := crBackAll
        else
          imgBack.Cursor := crBack;
      end
      else if ContainsInteger(X, 48, 94) then
        imgBack.Cursor := crBack
      else if ContainsInteger(X, 95, 190) then
        imgBack.Cursor := crReload
      else if ContainsInteger(X, 191, 235) then
        imgBack.Cursor := crNext
      else if ContainsInteger(X, 236, 279) then
      begin
        if av.bEdgeScroll then
          imgBack.Cursor := crNextAll
        else
          imgBack.Cursor := crNext;
      end;
    end;
  end;

  if av.bEdgeScroll then
  begin
    if Not ContainsInteger(X, 41, 239) then
    begin
      if ContainsInteger(Y, 0, 79) then
      begin
        //現在の天気欄
        timDailyWait.Enabled    := False;
        timDailyScroll.Enabled  := False;
        timWeeklyWait.Enabled   := False;
        timWeeklyScroll.Enabled := False;
      end else
      if ContainsInteger(Y, 80, 187) then
      begin
        //今日明日の天気欄
        timDailyWait.Enabled    := True;
        timWeeklyWait.Enabled   := False;
        timWeeklyScroll.Enabled := False;
      end else
      if ContainsInteger(Y, 188, 280) then
      begin
        //週間天気欄
        timWeeklyWait.Enabled   := True;
        timDailyWait.Enabled    := False;
        timDailyScroll.Enabled  := False;
      end;
    end else
    begin
      timDailyWait.Enabled    := False;
      timDailyScroll.Enabled  := False;
      timWeeklyWait.Enabled   := False;
      timWeeklyScroll.Enabled := False;
    end;
  end;
end;

procedure TfrmMain.popExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.popFixedClick(Sender: TObject);
begin
  popFixed.Checked := Not popFixed.Checked;
  popTrayFixed.Checked := popFixed.Checked;
  av.bFixedWindow := popFixed.Checked;
end;

procedure TfrmMain.popGetRainClick(Sender: TObject);
begin
	Application.CreateForm(TfrmRain, frmRain);
  frmRain.Show
end;

procedure TfrmMain.popIsVersionupClick(Sender: TObject);
begin
  Application.CreateForm(TfrmVerUp, frmVerUp);
  frmVerUp.Show;
end;

procedure TfrmMain.popMainClosePopup(Sender: TObject);
var
  i : Integer;
begin
  for i := popHistory.Count-1 downto 0 do
    popHistory.Delete(i);
end;

procedure TfrmMain.popMainPopup(Sender: TObject);
begin
  if _IsYahoo then
    popVisitSite.Caption := 'この地域のYahoo!天気・災害を表示する...'
  else
    popVisitSite.Caption := 'この地域のtenki.jpを表示する...';
  _LoadFavortie(popFavorite);
  _LoadWeatherHistory(popHistory);
  popTrayMinize.Checked := Self.Visible;
end;

procedure TfrmMain.popMinimizeClick(Sender: TObject);
begin
	//最小化している時
  if Not Self.Visible then
  begin
    Self.WindowState := wsNormal;
    Self.Visible := True;
    Application.RestoreTopMosts;
  end
  else
  begin
  //表示されている時
  	Self.Visible := False;
  end;
  popTrayMinize.Checked := Not popTrayMinize.Checked;
end;

procedure TfrmMain.popOptionClick(Sender: TObject);
begin
  Application.CreateForm(TfrmOption, frmOption);
  frmOption.Show;
end;

procedure TfrmMain.popSelctPlaceClick(Sender: TObject);
begin
  Application.CreateForm(TfrmSelectPlace, frmSelectPlace);
  frmSelectPlace.Show;
end;

procedure TfrmMain.popShowEvacuationClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PWideChar(av.sBrowser), PWideChar(popShowEvacuation.Hint), nil, SW_NORMAL);
end;

procedure TfrmMain.popTrayFixedClick(Sender: TObject);
begin
  popTrayFixed.Checked := Not popTrayFixed.Checked;
  popFixed.Checked := popTrayFixed.Checked;
  av.bFixedWindow := popTrayFixed.Checked;
end;

procedure TfrmMain.popTrayPopup(Sender: TObject);
begin
  if _IsYahoo then
    popTrayVisitSite.Caption := 'この地域のYahoo!天気・災害を表示する...'
  else
    popTrayVisitSite.Caption := 'この地域のtenki.jpを表示する...';
  _LoadFavortie(SpTBXSubmenuItem1);
  popTrayMinize.Checked := Not Self.Visible;
end;

procedure TfrmMain.popRefreshClick(Sender: TObject);
begin
  _LoadAllData(False);
end;

procedure TfrmMain.popVersionClick(Sender: TObject);
begin
  Application.CreateForm(TfrmVersion,frmVersion);
  frmVersion.Show;
end;

procedure TfrmMain.popVisitSiteClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PWideChar(av.sBrowser), PWideChar(av.sUrl), nil, SW_NORMAL);
end;

procedure TfrmMain.ReceiveDropFiles(var Msg: TWMDropFiles);
const
  NameMax = 1024;
var
  sl : TStringList;
  iFiles, i, j: Integer;
  FileName: array[0..(NameMax+10)] of WideChar;
  sSkin, sPath, sName : String;
begin
  panDrop.Visible := True;
  Application.ProcessMessages;
  iFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0); //ドロップされたファイル数の取得
  try
    for i := 0 to iFiles-1 do
    begin
      sl := TStringList.Create;
      try
        DragQueryFile(Msg.Drop, i, FileName, NameMax); //ファイル名を取得
        GetFiles(FileName, '*.*', sl, True);
        for j := 0 to sl.Count-1 do
        begin
          sSkin := ExtractFileName(ExtractFileDir(sl[j]));
          sName := ExtractFileName(sl[j]);
          sPath := Format('%simages\%s\', [GetApplicationPath, sSkin]);
          CreateFolder(sPath);
          if FileExists(sPath + sName) then
          begin
          	panDrop.Caption := Format('スキップ:%s\%s', [sSkin, sName]);
            Application.ProcessMessages;
          end else
          begin
          	panDrop.Caption := Format('コピー中:%s\%s', [sSkin, sName]);
            Application.ProcessMessages;
            FileCopy(sl[j], sPath+sName, True);
          end;
        end;
        FolderDelete(FileName, True);
      finally
        sl.Free;
      end;
    end;
  finally
    DragFinish(Msg.Drop);
    panDrop.Visible := False;
  end;
end;

procedure TfrmMain.timDailyScrollTimer(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  Case pt.X of
    0..40 : //左にスクロール
      begin
        if av.iCurFirstIndex > 1 then
          _DrawDailyData(0)
        else
        begin
          timDailyWait.Enabled := False;
          timDailyScroll.Enabled := False;
        end;
      end;
  240..280: //右にスクロール
      begin
        if av.iCurLastIndex < High(dwd) then
          _DrawDailyData(2)
        else
        begin
          timDailyWait.Enabled := False;
          timDailyScroll.Enabled := False;
        end;
      end;
  end;
end;

procedure TfrmMain.timDailyWaitTimer(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  if (pt.X < 40) or (pt.X > 240) then
    timDailyScroll.Enabled := True;
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin
  if MinuteOf(Now) in TimeList then
  begin
    _LoadAllData(False);
  end;
end;

procedure TfrmMain.timWeeklyScrollTimer(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  Case pt.X of
    0..40 : //左にスクロール
      begin
        if av.iWeeklyCurIndex > 1 then
        begin
          av.iWeeklyCurIndex := av.iWeeklyCurIndex-1;
          _DrawWeeklyData(av.iWeeklyCurIndex);
        end
        else
        begin
          timWeeklyWait.Enabled := False;
          timWeeklyScroll.Enabled := False;
        end;
      end;
  240..280: //右にスクロール
      begin
        if (av.iWeeklyCurIndex+5) < High(wwd) then
        begin
          av.iWeeklyCurIndex := av.iWeeklyCurIndex+1;
        	_DrawWeeklyData(av.iWeeklyCurIndex);
        end
        else
        begin
          timWeeklyWait.Enabled := False;
          timWeeklyScroll.Enabled := False;
        end;
      end;
  end;
end;

procedure TfrmMain.timWeeklyWaitTimer(Sender: TObject);
var
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  if (pt.X < 40) or (pt.X > 240) then
    timWeeklyScroll.Enabled := True;
end;

procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
  Self.WindowState := wsNormal;
  Self.Visible := True;
  Application.RestoreTopMosts;
end;

procedure TfrmMain.TrayIconMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Case Button of
    mbLeft  : Application.BringToFront;
  end;
end;


procedure TfrmMain.WMMousewheel(var Msg: TMessage);
var
  iDirec: ShortInt;
  pt : TPoint;
begin
  GetCursorPos(pt);
  pt := imgBack.ScreenToClient(pt);
  iDirec := HiWord(Msg.WParam);
  if ContainsInteger(pt.Y, 80, 187) then
  begin
    //今日明日の天気欄
    if iDirec > 0 then
    begin
    	//上方向
      if av.iCurFirstIndex > 1 then
        _DrawDailyData(0);
    end else
    begin
    	//下方向
      if av.iCurLastIndex < High(dwd) then
        _DrawDailyData(2);
    end;
  end
  else if ContainsInteger(pt.Y, 188, 279) then
  begin
    //週間天気欄
    if iDirec > 0 then
    begin
      if av.iWeeklyCurIndex > 1 then
      begin
        av.iWeeklyCurIndex := av.iWeeklyCurIndex-1;
        _DrawWeeklyData(av.iWeeklyCurIndex);
      end;
    end
    else
    begin
      if (av.iWeeklyCurIndex+5) < High(wwd) then
      begin
        av.iWeeklyCurIndex := av.iWeeklyCurIndex+1;
        _DrawWeeklyData(av.iWeeklyCurIndex);
      end;
    end;
  end;
end;

procedure TfrmMain.WM_WallpaperChange(var Message: TWMSettingChange);
begin
  if (Message.Flag = SPI_SETDESKWALLPAPER) then
    _LoadAllData(True);
end;

end.
