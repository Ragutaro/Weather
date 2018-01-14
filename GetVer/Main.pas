unit Main;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, System.Zip;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    edt64: TEdit;
    edt32: TEdit;
    Label2: TLabel;
    btnGet: TButton;
    lblInfo: TLabel;
    memVerup: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnGetClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    function GetEXEDLLVersionInfo(FileName: string): String;
    procedure _CreateVersions;
    procedure _CopyFiles;
    procedure _CompressByZIP;
  public
    { Public 宣言 }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}


uses
  HideUtils,
  dp;

procedure TfrmMain.btnGetClick(Sender: TObject);
begin
  btnGet.Enabled := False;
  Application.ProcessMessages;
  _CreateVersions;
  _CopyFiles;
  Sleep(500);
  _CompressByZIP;
  btnGet.Enabled := True;
  lblInfo.Caption := '終了しました';
  Application.ProcessMessages;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmMain := nil;   //フォーム名に変更する
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
end;

procedure TfrmMain._CompressByZIP;
var
  zip : TZipFile;
begin
  lblInfo.Caption := 'ZIPで圧縮中...';
  Application.ProcessMessages;
  zip := TZipFile.Create;
  try
    zip.ZipDirectoryContents('C:\Users\ragu\Desktop\weather.zip', 'C:\Users\ragu\Desktop\weather');
    zip.Close;
  finally
    zip.Free;
  end;
  FileCopy('C:\Users\ragu\Desktop\weather.zip',
           'C:\!MyData\Html\soft\weather\archives\weather_'+ReplaceText(edt64.Text, '.', '_')+'.zip', True);
//  DeleteFolder('C:\Users\ragu\Desktop\weather');
end;

procedure TfrmMain._CopyFiles;
const
  dstDir = 'C:\Users\ragu\Desktop\weather\';
  src64 = 'C:\!MyData\MyBetaSoftware\Seattle\Weather\Win64\Release\';
  src32 = 'C:\!MyData\MyBetaSoftware\Seattle\Weather\Win32\Release\';
begin
  lblInfo.Caption := 'ファイルをコピー中...';
  Application.ProcessMessages;
  CopyFile(src64 + 'Weather.exe', dstDir + 'Weather64.exe');
  CopyFile(src32 + 'Weather.exe', dstDir + 'Weather32.exe');
  CopyFile(src64 + 'Thanks.txt', dstDir + 'Thanks.txt');
  CopyFile(src64 + 'Readme.txt', dstDir + 'Readme.txt');
  CopyFolder(src64 + 'images\Default', dstDir + 'images\Default');
end;

procedure TfrmMain._CreateVersions;
var
  sl : TStringList;
  ini : TMemIniFile;
  s : String;
  idx : Integer;
begin
  lblInfo.Caption := 'バージョン情報を取得中...';
  Application.ProcessMessages;
  edt64.Text := GetEXEDLLVersionInfo('C:\!MyData\MyBetaSoftware\Seattle\Weather\Win64\Release\Weather.exe');
  edt32.Text := GetEXEDLLVersionInfo('C:\!MyData\MyBetaSoftware\Seattle\Weather\Win32\Release\Weather.exe');
  Application.ProcessMessages;

  ini := TMemIniFile.Create('C:\!MyData\Html\soft\weather\version.ini', TEncoding.UTF8);
  try
    ini.WriteString('Version', '64bit', edt64.Text);
    ini.WriteString('Version', '32bit', edt32.Text);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
  sl := TStringList.Create;
  try
    sl.LoadFromFile('C:\!MyData\Html\main.htm', TEncoding.Default);
    if Pos(edt64.Text, sl.Text) = 0 then
    begin
      idx := sl.IndexOf('<blockquote>');
      s := Format('<img src="image/point.png"> <a href="http://hide-inoki.com/bbs/phpbb2/viewtopic.php?t=927">机上予報 64bit Ver.%s / 32bit Ver.%s </a>を公開(%s)。<BR>',
                  [edt64.Text, edt32.Text, FormatDateTime('yy/mm/dd', Now)]);
      sl.Insert(idx+1, s);
      sl.SaveToFile('C:\!MyData\Html\main.htm', TEncoding.Default);
    end;
  finally
    sl.Free;
  end;
  memVerup.Lines.Add(FormatDateTime('yyyy/mm/dd 更新', Now));
  memVerup.Lines.Add(Format('64bit Ver.%s', [edt64.Text]));
  memVerup.Lines.Add(Format('32bit Ver.%s', [edt32.Text]));
end;

procedure TfrmMain._LoadSettings;
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

procedure TfrmMain._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.WriteString('General', 'FontName', Self.Font.Name);
    ini.WriteInteger('General', 'FontSize', Self.Font.Size);
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

function TfrmMain.GetEXEDLLVersionInfo(FileName: string): String;
type
  TLangAndCodePage = record
    wLanguage : WORD;
    wCodePage : WORD;
  end;
  PLangAndCodePage = ^TLangAndCodePage;

var
  dwHandle    : Cardinal;
  pInfo       : Pointer;
  pLangCode   : PLangAndCodePage;
  SubBlock    : String;
  InfoSize    : DWORD;
  pFileInfo   : Pointer;
  strList     : TStringList;
begin
  InfoSize := GetFileVersionInfoSize(PChar(FileName), dwHandle);
  if InfoSize = 0 then exit;

  GetMem(pInfo, InfoSize);
  try
    GetFileVersionInfo(PChar(FileName), 0, InfoSize, pInfo);

    //ロケール識別子とコードページを取得
    VerQueryValue(pInfo, '\VarFileInfo\Translation', Pointer(pLangCode), InfoSize);

    //上で取得した値を元に，
    //各種情報取得用に，VerQueryValue関数の第2引数で使用する文字列を作成
    SubBlock := IntToHex(pLangCode.wLanguage, 4) + IntToHex(pLangCode.wCodePage, 4);
    SubBlock := '\StringFileInfo\' + SubBlock + PathDelim;


    strList := TStringList.Create;
    try
      //取得する項目の名前を文字列配列に格納
      strList.Add(SubBlock + 'CompanyName');
      strList.Add(SubBlock + 'FileDescription');
      strList.Add(SubBlock + 'FileVersion');
      strList.Add(SubBlock + 'InternalName');
      strList.Add(SubBlock + 'LegalCopyright');
      strList.Add(SubBlock + 'LegalTrademarks');
      strList.Add(SubBlock + 'OriginalFilename');
      strList.Add(SubBlock + 'ProductName');
      strList.Add(SubBlock + 'ProductVersion');
      strList.Add(SubBlock + 'Comments');
      strList.Add(SubBlock + 'SpecialBuild');
      strList.Add(SubBlock + 'PrivateBuild');
      strList.Add(SubBlock + 'Sample-Number');


      VerQueryValue(pInfo,
                    PChar(SubBlock + 'FileVersion'),
                    Pointer(pFileInfo),
                    InfoSize);
      Result := PChar(pFileInfo);
    finally
      strList.Free;
    end;
  finally
    FreeMem(pInfo, InfoSize);
  end;
end;

end.
