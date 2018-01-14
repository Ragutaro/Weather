unit Rain;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Gifimg, Vcl.ExtCtrls, Vcl.Imaging.jpeg, Vcl.StdCtrls,
  Vcl.ComCtrls;

type
  TfrmRain = class(TForm)
    Timer: TTimer;
    imgRain: TImage;
    lblInfo: TLabel;
    lblRegion: TLabel;
    lblJapan: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimerTimer(Sender: TObject);
    procedure lblRegionClick(Sender: TObject);
    procedure lblJapanClick(Sender: TObject);
    procedure lblRegionMouseEnter(Sender: TObject);
    procedure lblRegionMouseLeave(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _DownloadImageFromYahoo;
    procedure _DownloadImageFromTenkiJP;
    procedure _DownloadJapanFromYahoo;
    procedure _DownloadJapanFromTenki;
    procedure _Init;
  public
    { Public 宣言 }
    procedure _AnimateImage;
  end;

  type
    TPrivateValues = record
      iImageIndex : Integer;
    end;

var
  frmRain: TfrmRain;
  pv : TPrivateValues;

implementation

{$R *.dfm}

uses
  HideUtils,
  Main,
  dp;

const
  rtYahooRegion = 0;
  rtYahooJapan  = 1;
  rtTenkiRegion = 2;
  rtTenkiJapan  = 3;

procedure TfrmRain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmRain := nil;   //フォーム名に変更する
end;

procedure TfrmRain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  sl : TStringList;
  i : Integer;
begin
  sl := TStringList.Create;
  try
    //Yahoo
    GetFiles(GetApplicationPath + 'Data', '*.bmp', sl, False);
    for i := 0 to sl.Count-1 do
      DeleteFileW(PWideChar(sl[i]));
    //Tenki
    GetFiles(GetApplicationPath + 'Data', '*.jpg', sl, False);
    for i := 0 to sl.Count-1 do
      DeleteFileW(PWideChar(sl[i]));
  finally
    sl.Free;
  end;
end;

procedure TfrmRain.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
end;

procedure TfrmRain._Init;
begin
  Timer.Enabled   := False;
  lblInfo.Visible := True;
  imgRain.Picture := nil;
  Application.ProcessMessages;
end;

procedure TfrmRain._AnimateImage;
var
  s : String;
begin
  lblInfo.Visible := False;
  if pv.iImageIndex = 7 then
    pv.iImageIndex := 1;

  Case Self.Tag of
    rtYahooRegion : s := Format('%sData\rgn_%d.bmp', [GetApplicationPath, pv.iImageIndex]);
    rtYahooJapan  : s := Format('%sData\jpn_%d.bmp', [GetApplicationPath, pv.iImageIndex]);
    rtTenkiRegion : s := Format('%sData\rgn_%d.jpg', [GetApplicationPath, pv.iImageIndex]);
    rtTenkiJapan  : s := Format('%sData\jpn_%d.jpg', [GetApplicationPath, pv.iImageIndex]);
  end;

  if FileExists(s) then
  begin
    imgRain.Picture := nil;
  	imgRain.Picture.LoadFromFile(s);
    pv.iImageIndex := pv.iImageIndex + 1;
  end;
end;

procedure TfrmRain._DownloadImageFromTenkiJP;
var
  sl : TStringList;
  src, sTmp : String;
  iPos, iCnt : Integer;
begin
  //ダウンロード済みの場合は処理しない
  if FileExists(GetApplicationPath + 'Data\rgn_1.jpg') then
    Exit;

  iCnt := 1;
  sl := TStringList.Create;
  try
    DownloadHttpToStringList(av.sUrlRain, sl, TEncoding.UTF8);
    src := CopyStr(sl.Text, '<!--/radar-top-tab-box-->', '$(function()');
    iPos := PosText('https:', src);
    repeat
      sTmp := CopyStrEx(src, 'https:', '''', iPos);
      DownloadFileAsNewName(sTmp, GetApplicationPath + 'Data\', 'rgn_' + IntToStr(iCnt)+'.jpg');
      iCnt := iCnt+1;
      iPos := PosTextEx('https:', src, iPos+1);
    until iPos = 0;
  finally
    sl.Free;
  end;
end;

procedure TfrmRain._DownloadImageFromYahoo;
var
  ms : TMemoryStream;
  gif : TGIFImage;
  sl : TStringList;
  sTmp : String;
  i : Integer;
begin
  //ダウンロード済みの場合は処理しない
  if FileExists(GetApplicationPath + 'Data\rgn_1.bmp') then
    Exit;

  sl := TStringList.Create;
  ms := TMemoryStream.Create;
  try
    DownloadHttpToStringList(av.sUrlRain, sl, TEncoding.UTF8);
    sTmp := CopyStr(sl.Text, '<td class="mainImg">', 'width=530');
    sTmp := CopyStr(sTmp, 'https', '?');
    DownloadHttp(sTmp, ms);
    gif := TGIFImage.Create;
    try
      gif.LoadFromStream(ms);
      for i := 0 to gif.Images.Count-1 do
        gif.Images[i].Bitmap.SaveToFile(Format('%sData\rgn_%d.bmp', [GetApplicationPath, i+1]));
    finally
      gif.Free;
    end;
  finally
    ms.Free;
    sl.Free;
  end;
end;

procedure TfrmRain._DownloadJapanFromTenki;
var
  sl : TStringList;
  src, sTmp : String;
  iPos, iCnt : Integer;
begin
  //ダウンロード済みの場合は処理しない
  if FileExists(GetApplicationPath + 'Data\jpn_1.jpg') then
    Exit;

  iCnt := 1;
  sl := TStringList.Create;
  try
    DownloadHttpToStringList('https://tenki.jp/radar/rainmesh.html', sl, TEncoding.UTF8);
    src := CopyStr(sl.Text, '<script type="text/javascript">', '};');
    iPos := PosText('https:', src);
    repeat
      sTmp := CopyStrEx(src, 'https:', '''', iPos);
      DownloadFileAsNewName(sTmp, GetApplicationPath + 'Data\', 'jpn_' + IntToStr(iCnt)+'.jpg');
      iCnt := iCnt+1;
      iPos := PosTextEx('https:', src, iPos+1);
    until iPos = 0;
  finally
    sl.Free;
  end;
end;

procedure TfrmRain._DownloadJapanFromYahoo;
var
  ms : TMemoryStream;
  gif : TGIFImage;
  sl : TStringList;
  sTmp : String;
  i : Integer;
begin
  //ダウンロード済みの場合は処理しない
  if FileExists(GetApplicationPath + 'Data\jpn_1.bmp') then
    Exit;

  sl := TStringList.Create;
  ms := TMemoryStream.Create;
  try
    DownloadHttpToStringList('https://weather.yahoo.co.jp/weather/raincloud/?c=g2', sl, TEncoding.UTF8);
    sTmp := CopyStr(sl.Text, '<td class="mainImg">', 'width=530');
    sTmp := CopyStr(sTmp, 'https', '?');
    DownloadHttp(sTmp, ms);
    gif := TGIFImage.Create;
    try
      gif.LoadFromStream(ms);
      for i := 0 to gif.Images.Count-1 do
        gif.Images[i].Bitmap.SaveToFile(Format('%sData\jpn_%d.bmp', [GetApplicationPath, i+1]));
    finally
      gif.Free;
    end;
  finally
    sl.Free;
    ms.Free;
  end;
end;

procedure TfrmRain._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindow(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmRain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindow(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmRain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmRain.FormShow(Sender: TObject);
begin
  _Init;
  if frmMain._IsYahoo then
  begin
    Self.Tag := rtYahooRegion;
    _DownloadImageFromYahoo;
    pv.iImageIndex := 1;
    Timer.Enabled := True;
  end else
  begin
    Self.Tag := rtTenkiRegion;
  	_DownloadImageFromTenkiJP;
    pv.iImageIndex := 1;
    Timer.Enabled := True;
  end;
end;

procedure TfrmRain.lblJapanClick(Sender: TObject);
begin
  _Init;
  if frmMain._IsYahoo then
  begin
    Self.Tag := rtYahooJapan;
    _DownloadJapanFromYahoo;
  end else
  begin
    Self.Tag := rtTenkiJapan;
    _DownloadJapanFromTenki;
  end;
  pv.iImageIndex := 1;
  Timer.Enabled := True;
end;

procedure TfrmRain.lblRegionClick(Sender: TObject);
begin
  FormShow(Self);
end;

procedure TfrmRain.lblRegionMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clRed;
  TLabel(Sender).Font.Style := [fsUnderline];
end;

procedure TfrmRain.lblRegionMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color := clWhite;
  TLabel(Sender).Font.Style := [];
end;

procedure TfrmRain.TimerTimer(Sender: TObject);
begin
  _AnimateImage;
end;

end.
