unit untVersion;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.StdCtrls, Winapi.Shellapi;

type
  TfrmVersion = class(TForm)
    Label1: TLabel;
    lblInfo: TLabel;
    memInfo: TMemo;
    btnOk: TButton;
    lblCopyright: TLabel;
    lblSiteName: TLabel;
    lblUrl: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure lblUrlClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadVersionInfo;
    procedure _LoadThanks;
  public
    { Public 宣言 }
  end;

var
  frmVersion: TfrmVersion;

implementation

{$R *.dfm}

uses
  HideUtils,
  version,
  Main,
  dp;

procedure TfrmVersion.btnOkClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmVersion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmVersion := nil;   //フォーム名に変更する
end;

procedure TfrmVersion.FormCreate(Sender: TObject);
begin
  DisableVclStyles(Self);
  _LoadSettings;
  _LoadVersionInfo;
  _LoadThanks;
end;

procedure TfrmVersion.lblUrlClick(Sender: TObject);
begin
  ShellExecute(Self.Handle, 'open', PWideChar(av.sBrowser), PWideChar(lblUrl.Caption), nil, SW_NORMAL);
end;

procedure TfrmVersion._LoadSettings;
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

procedure TfrmVersion._LoadThanks;
begin
  memInfo.Lines.LoadFromFile(GetApplicationPath + 'Thanks.txt', TEncoding.UTF8);
end;

procedure TfrmVersion._LoadVersionInfo;
begin
  lblInfo.Caption       := 'Ver.' + VersionData.FileVersion;
  lblCopyright.Caption  := 'Copyright: ' + VersionData.LegalCopyright;
  lblSiteName.Caption   := 'HIDE and Seek!';
  lblUrl.Caption        := 'http://hide-inoki.com';
end;

procedure TfrmVersion._SaveSettings;
var
  ini : TMemIniFile;
begin
  ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
  try
    ini.WriteWindowPosition(Self.Name, Self);
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end;

end.
