unit VerUp;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls;

type
  TfrmVerUp = class(TForm)
    lblInfo: TLabel;
    btnGet: TButton;
    btnClose: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnCloseClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _GetVersinInfo;
  public
    { Public 宣言 }
  end;

var
  frmVerUp: TfrmVerUp;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp;

procedure TfrmVerUp.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVerUp.btnGetClick(Sender: TObject);
begin
  ShellExecuteSimple('http://hide-inoki.com/bbs/phpbb2/viewtopic.php?t=927');
  Close;
end;

procedure TfrmVerUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmVerUp := nil;   //フォーム名に変更する
end;

procedure TfrmVerUp.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
  _GetVersinInfo;
end;

procedure TfrmVerUp._GetVersinInfo;
var
  sl : TStringList;
  iVer : Integer;
  sVer, sTmp, s1, s2 : String;
begin
  iVer := SizeOf(NativeInt);
  sVer := GetFileVersion;
  sl := TStringList.Create;
  try
    DownloadHttpToStringList('http://hide-inoki.com/soft/weather/version.ini', sl, TEncoding.UTF8);
    if iVer = 4 then
      sTmp := sl[2]   //32bit
    else
      sTmp := sl[1];  //64bit
    SplitStringsToAandB(sTmp, '=', s1, s2);
    if s2 > sVer then
      lblInfo.Caption := Format('Ver.%s が公開されています。', [s2])
    else
    begin
      btnGet.Visible := False;
    	lblInfo.Caption := 'お使いのバージョンが最新版です。';
    end;
  finally
    sl.Free;
  end;
end;

procedure TfrmVerUp._LoadSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.ReadWindowPosition(Self.Name, Self);
    Self.Font.Name := ini.ReadString('General', 'FontName', 'メイリオ');
    Self.Font.Size := ini.ReadInteger('General', 'FontSize', 10);
  finally
    ini.Free;
  end;
end;

procedure TfrmVerUp._SaveSettings;
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

procedure TfrmVerUp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

end.
