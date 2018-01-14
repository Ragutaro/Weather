unit EditFavorite;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.ComCtrls, HideListView, Vcl.StdCtrls;

type
  TListItemEx = class(TListItem)
  private
    sSite, sUrl : String;
  end;
  TfrmEditFavorite = class(TForm)
    lvwList: THideListView;
    btnDelete: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    btnUp: TButton;
    btnDown: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lvwListCreateItemClass(Sender: TCustomListView;
      var ItemClass: TListItemClass);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _LoadFavorite;
    procedure _SaveFavorite;
    { Public 宣言 }
  end;

var
  frmEditFavorite: TfrmEditFavorite;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp;

procedure TfrmEditFavorite.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditFavorite.btnDeleteClick(Sender: TObject);
var
  item : TListItemEx;
begin
  item := TListItemEx(lvwList.Selected);
  if item <> nil then
    item.Delete;
end;

procedure TfrmEditFavorite.btnDownClick(Sender: TObject);
var
  tmpItem : TListItemEx;
  idx : Integer;
begin
  idx := lvwList.Selected.Index;
  if idx < lvwList.Items.Count-1 then
  begin
    tmpItem := TListItemEx.Create(lvwList.Items);
    try
      tmpItem.Assign(TListItemEx(lvwList.Items[idx+1]));
      tmpItem.sUrl := TListItemEx(lvwList.Items[idx+1]).sUrl;
      tmpItem.sSite:= TListItemEx(lvwList.Items[idx+1]).sSite;
      TListItemEx(lvwList.Items[idx+1]).Assign(TListItemEx(lvwList.Items[idx]));
      TListItemEx(lvwList.Items[idx+1]).sUrl := TListItemEx(lvwList.Items[idx]).sUrl;
      TListItemEx(lvwList.Items[idx+1]).sSite:= TListItemEx(lvwList.Items[idx]).sSite;
      TListItemEx(lvwList.Items[idx]).Assign(tmpItem);
      TListItemEx(lvwList.Items[idx]).sUrl := tmpItem.sUrl;
      TListItemEx(lvwList.Items[idx]).sSite:= tmpItem.sSite;
      lvwList.Items[idx].Selected := False;
      lvwList.Items[idx+1].Selected := True;
      lvwList.Items[idx+1].Focused := True;
    finally
      tmpItem.Free;
    end;
  end;
end;

procedure TfrmEditFavorite.btnOKClick(Sender: TObject);
begin
  _SaveFavorite;
  Close;
end;

procedure TfrmEditFavorite.btnUpClick(Sender: TObject);
var
  tmpItem : TListItemEx;
  idx : Integer;
begin
  idx := lvwList.Selected.Index;
  if idx > 0 then
  begin
    tmpItem := TListItemEx.Create(lvwList.Items);
    try
      tmpItem.Assign(TListItemEx(lvwList.Items[idx-1]));
      tmpItem.sUrl := TListItemEx(lvwList.Items[idx-1]).sUrl;
      tmpItem.sSite:= TListItemEx(lvwList.Items[idx-1]).sSite;
      TListItemEx(lvwList.Items[idx-1]).Assign(TListItemEx(lvwList.Items[idx]));
      TListItemEx(lvwList.Items[idx-1]).sUrl := TListItemEx(lvwList.Items[idx]).sUrl;
      TListItemEx(lvwList.Items[idx-1]).sSite:= TListItemEx(lvwList.Items[idx]).sSite;
      TListItemEx(lvwList.Items[idx]).Assign(tmpItem);
      TListItemEx(lvwList.Items[idx]).sUrl := tmpItem.sUrl;
      TListItemEx(lvwList.Items[idx]).sSite:= tmpItem.sSite;
      lvwList.Items[idx].Selected := False;
      lvwList.Items[idx-1].Selected := True;
      lvwList.Items[idx-1].Focused := True;
    finally
      tmpItem.Free;
    end;
  end;
end;

procedure TfrmEditFavorite.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmEditFavorite := nil;   //フォーム名に変更する
end;

procedure TfrmEditFavorite.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
  _LoadFavorite;
end;

procedure TfrmEditFavorite._LoadFavorite;
var
  item : TListItemEx;
  ini : TMemIniFile;
  sl : TStringList;
  i : Integer;
  sName, sUrl, sSite : String;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\Favorite.ini', TEncoding.UTF8);
  sl := TStringList.Create;
  try
    ini.ReadSections(sl);
    for i := 0 to sl.Count-1 do
    begin
      sName := ini.ReadString('Favorite' + IntToStr(i), 'Name', '');
      sUrl  := ini.ReadString('Favorite' + IntToStr(i), 'Url', '');
      sSite := ini.ReadString('Favorite' + IntToStr(i), 'Site', 'yahoo.co.jp');
      item := TListItemEx(lvwList.Items.Add);
      item.Caption := Format('%s(%s)', [sName, sSite]);
      item.sUrl := sUrl;
      item.sSite := sSite;
    end;
  finally
    ini.Free;
    sl.Free;
  end;
end;

procedure TfrmEditFavorite._LoadSettings;
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

procedure TfrmEditFavorite._SaveFavorite;
var
  item : TListItemEx;
  ini : TMemIniFile;
  i : Integer;
begin
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\Favorite.ini', TEncoding.UTF8);
  try
    ini.Clear;
    for i := 0 to lvwList.Items.Count-1 do
    begin
      item := TListItemEx(lvwList.Items[i]);
      ini.WriteString('Favorite' + IntToStr(i), 'Name', RemoveRight(CopyStrToStr(item.Caption, '('), 1));
      ini.WriteString('Favorite' + IntToStr(i), 'Url', item.sUrl);
      ini.WriteString('Favorite' + IntToStr(i), 'Site', item.sSite);
    end;
  finally
    ini.UpdateFile;
    ini.Free;
  end;
end;

procedure TfrmEditFavorite._SaveSettings;
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

procedure TfrmEditFavorite.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmEditFavorite.lvwListCreateItemClass(Sender: TCustomListView;
  var ItemClass: TListItemClass);
begin
  ItemClass := TListItemEx;
end;

end.
