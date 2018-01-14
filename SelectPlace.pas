unit SelectPlace;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.StrUtils, IniFilesDX, System.IOUtils, System.Types,
  Vcl.Filectrl, Vcl.ComCtrls, HideTreeView, Vcl.StdCtrls, HideComboBox, shellapi;

type
  TTreeNodeEx = class(TTreeNode)
  private
    sUrl : String;
  end;

  TfrmSelectPlace = class(TForm)
    btnCancel: TButton;
    lblInfo: TLabel;
    pagRegion: TPageControl;
    tabYahoo: TTabSheet;
    tabTenkiJp: TTabSheet;
    tvwList: THideTreeView;
    tvwTenki: THideTreeView;
    rad3h: TRadioButton;
    rad1h: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure tvwListCreateNodeClass(Sender: TCustomTreeView;
      var NodeClass: TTreeNodeClass);
    procedure tvwListDblClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tvwListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tvwListCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure tvwTenkiDblClick(Sender: TObject);
    procedure tvwTenkiMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private 宣言 }
    procedure _LoadSettings;
    procedure _SaveSettings;
    procedure _Create1stLevelNode;
    procedure _Create2ndLevelNode;
    procedure _Create3rdLevelNode;
    procedure _Create1stLevelNodeTenki;
    procedure _Create2ndLevelNodeTenki;
  public
    { Public 宣言 }
  end;

var
  frmSelectPlace: TfrmSelectPlace;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp,
  Main;

procedure TfrmSelectPlace.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSelectPlace.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _SaveSettings;
  Release;
  frmSelectPlace := nil;   //フォーム名に変更する
end;

procedure TfrmSelectPlace.FormCreate(Sender: TObject);
begin
  if IsDebugMode then
     Self.Caption := 'Debug Mode - ' + Self.Caption;
  DisableVclStyles(Self, '');
  _LoadSettings;
end;

procedure TfrmSelectPlace._Create1stLevelNode;
var
  nParent, nNew : TTreeNodeEx;
  sl : TStringList;
  sSource, sDev, sUrl, sName : String;
  iPos : Integer;
begin
  nParent := TTreeNodeEx(tvwList.Selected);
  if nParent.HasChildren then
    Exit;

  sl := TStringList.Create;
  try
    DownloadHttpToStringList('https://weather.yahoo.co.jp/weather/', sl, TEncoding.UTF8);
    sSource := CopyStr(sl.Text, '<li class="odd">', '<!-- /#dailyForecast -->');
    iPos := PosText('<li>', sSource);
    repeat
      sDev := CopyStrEx(sSource, '<li>', '</li>', iPos);
      sUrl := 'https:' + RemoveRight(RemoveLeft(CopyStr(sDev, '<a', '>'), 9), 1);
      sName := RemoveHTMLTags(sDev);
      nNew := TTreeNodeEx(tvwList.Items.AddChild(nParent, sName));
      nNew.sUrl := sUrl;
      iPos := PosTextEx('<li>', sSource, iPos+1);
    until iPos = 0;
    //沖縄
    nNew := TTreeNodeEx(tvwList.Items.AddChild(nParent, '沖縄'));
    nNew.sUrl := 'https://weather.yahoo.co.jp/weather/jp/47/';
    nParent.Expanded := True;
  finally
    sl.Free;
  end;
end;

procedure TfrmSelectPlace._Create1stLevelNodeTenki;
var
  nParent, nNew : TTreeNodeEx;
  sl : TStringList;
  sSource, sDev, sUrl, sName : String;
  iPos : Integer;
begin
  nParent := TTreeNodeEx(tvwTenki.Selected);
  if nParent.HasChildren then
    Exit;

  sl := TStringList.Create;
  try
    DownloadHttpToStringList('https://tenki.jp/', sl, TEncoding.UTF8);
    sSource := CopyStr(sl.Text, '<!-- 都道府県一覧 -->', '<!-- /都道府県一覧 -->');
    iPos := PosText('<li', sSource);
    repeat
      sDev := CopyStrEx(sSource, '<li', '</a>', iPos);
      sUrl := 'https://tenki.jp' + RemoveLeft(CopyStr(sDev, '<a', '" class'), 9);
      sName := RemoveHTMLTags(sDev);
      nNew := TTreeNodeEx(tvwTenki.Items.AddChild(nParent, sName));
      nNew.sUrl := sUrl;
      iPos := PosTextEx('<li', sSource, iPos+1);
    until iPos = 0;
    nParent.Expanded := True;
  finally
    sl.Free;
  end;
end;

procedure TfrmSelectPlace._Create2ndLevelNode;
var
  nParent, nNew : TTreeNodeEx;
  sl : TStringList;
  sSource, sDev, sUrl, sName : String;
  iPos : Integer;
begin
  nParent := TTreeNodeEx(tvwList.Selected);
  if nParent.HasChildren then
    Exit;

  sl := TStringList.Create;
  try
    DownloadHttpToStringList(nParent.sUrl, sl, TEncoding.UTF8);
    sSource := CopyStr(sl.Text, '<!-- /.btnBack -->', '<!-- mapping -->');
    iPos := PosText('<a href', sSource);
    repeat
      sDev := CopyStrEx(sSource, '<a href', '</dt>', iPos);
      sUrl := RemoveLeft(CopyStr(sDev, '<a', '.html'), 9) + '.html';
      sName := RemoveHTMLTags(CopyStr(sDev, '<dt class="name">', '</dt>'));
      nNew := TTreeNodeEx(tvwList.Items.AddChild(nParent, sName));
      nNew.sUrl := sUrl;
      iPos := PosTextEx('<a href', sSource, iPos+1);
    until iPos = 0;
    nParent.Expanded := True;
  finally
    sl.Free;
  end;
end;

procedure TfrmSelectPlace._Create2ndLevelNodeTenki;
const
  sSeirei : String = '札幌市;仙台市;さいたま市;千葉市;川崎市;横浜市;相模原市;新潟市;静岡市;浜松市;名古屋市;京都市;大阪市;堺市;神戸市;岡山市;広島市;北九州市;福岡市;熊本市;';
var
  nParent, nMain, nNew : TTreeNodeEx;
  sl : TStringList;
  sSource, sMain, sCity, sDev, sUrl, sName : String;
  iPos, iPosCity : Integer;
begin
  nParent := TTreeNodeEx(tvwTenki.Selected);
  if nParent.HasChildren then
    Exit;

  sl := TStringList.Create;
  try
    DownloadHttpToStringList(nParent.sUrl, sl, TEncoding.UTF8);
    sSource := CopyStr(sl.Text, '<!-- 市区町村一覧 -->', '<!-- /市区町村一覧 -->');
    //主要地方名
    sMain := CopyStr(sSource, '<h4', '</section>');
    iPos := PosText('<h4', sSource);
    repeat
      sDev := CopyStrEx(sSource, '<h4', '</ul>', iPos);
      sName := RemoveHTMLTags(CopyStr(sDev, '<h4', '</h4>'));
      nMain := TTreeNodeEx(tvwTenki.Items.AddChild(nParent, sName));
      //市区町村名
      iPosCity := PosText('<li>', sDev);
      repeat
        sCity := CopyStrEx(sDev, '<li>', '</a>', iPosCity);
        sName := RemoveHTMLTags(sCity);
        sUrl := RemoveLeft(CopyStrEx(sDev, '<a href=', '">', iPosCity), 9);
        if Not ContainsText(sSeirei, sName+';') then
        begin
          nNew := TTreeNodeEx(tvwTenki.Items.AddChild(nMain, sName));
          nNew.sUrl := 'https://tenki.jp' + sUrl;
        end;
        iPosCity := PosTextEx('<li>', sDev, iPosCity+1);
      until iPosCity = 0;
      iPos := PosTextEx('<h4', sSource, iPos+1);
    until iPos = 0;
    nParent.Expanded := True;
  finally
    sl.Free;
  end;
end;

procedure TfrmSelectPlace._Create3rdLevelNode;
var
  nParent, nNew : TTreeNodeEx;
  sl : TStringList;
  sSource, sDev, sUrl, sName : String;
  iPos : Integer;
begin
  nParent := TTreeNodeEx(tvwList.Selected);
  if nParent.HasChildren then
    Exit;

  sl := TStringList.Create;
  try
    DownloadHttpToStringList(nParent.sUrl, sl, TEncoding.UTF8);
    sSource := CopyStr(sl.Text, '<h2 class="yjMt">ピンポイント天気', '</ul>');
    iPos := PosText('<li>', sSource);
    repeat
      sDev := CopyStrEx(sSource, '<a href', '</a>', iPos);
      sUrl := RemoveLeft(CopyStr(sDev, '<a', '.html'), 9) + '.html';
      sName := RemoveHTMLTags(CopyStr(sDev, '<a href', '</a>'));
      nNew := TTreeNodeEx(tvwList.Items.AddChild(nParent, sName));
      nNew.sUrl := sUrl;
      iPos := PosTextEx('<li>', sSource, iPos+1);
    until iPos = 0;
    nParent.Expanded := True;
  finally
    sl.Free;
  end;
end;

procedure TfrmSelectPlace._LoadSettings;
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

procedure TfrmSelectPlace._SaveSettings;
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

procedure TfrmSelectPlace.FormKeyPress(Sender: TObject; var Key: Char);
begin
  case key of
    char(VK_ESCAPE) :
      begin
        Key := char(0);
        Close;
      end;
  end;
end;

procedure TfrmSelectPlace.tvwListCreateNodeClass(Sender: TCustomTreeView;
  var NodeClass: TTreeNodeClass);
begin
  NodeClass := TTreeNodeEx;
end;

procedure TfrmSelectPlace.tvwListCustomDrawItem(Sender: TCustomTreeView;
  Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  tvwList.SetHoverColor(State, DefaultDraw);
end;

procedure TfrmSelectPlace.tvwListDblClick(Sender: TObject);
var
  sl, sm : TStringList;
  ini : TMemIniFile;
  idx : Integer;
  sFile : String;
begin
  idx := tvwList.GetSelectedNodeLevel;
  Case idx of
    0 : _Create1stLevelNode;
    1 : _Create2ndLevelNode;
    2 : _Create3rdLevelNode;
    3 : begin
          ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
          try
            av.sSiteName := 'yahoo.co.jp';
            av.sUrl := TTreeNodeEx(tvwList.Selected).sUrl;
            av.sUrlRain := ReplaceText(TTreeNodeEx(tvwList.Selected.Parent.Parent).sUrl, '/jp/', '/raincloud/') + '?c=g2';
            ini.WriteString('frmMain', 'Site', 'yahoo.co.jp');
            ini.WriteString('frmMain', 'Url', av.sUrl);
            ini.WriteString('frmMain', 'UrlRain', av.sUrlRain);
          finally
            ini.UpdateFile;
            ini.Free;
          end;
          //履歴に追加する
          sl := TStringList.Create;
          sm := TStringList.Create;
          try
            sFile := GetApplicationPath + 'Data\History.txt';
            if FileExists(sFile) then
              sl.LoadFromFile(sFile, TEncoding.UTF8);
            sm.Add(tvwList.Selected.Text);
            sm.Add(av.sUrl);
            sm.Add(av.sSiteName);
            sl.Insert(0, sm.CommaText);
            SetStringListLength(sl, 20);
            sl.SaveToFile(sFile, TEncoding.UTF8);
          finally
            sl.Free;
            sm.Free;
          end;
          frmMain._LoadAllData(False);
    	  end;
  end;
end;

procedure TfrmSelectPlace.tvwListMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  n : TTreeNode;
begin
  lblInfo.Caption := '';
  n := tvwList.GetNodeAt(X, Y);
  if n <> nil then
  begin
    Case tvwList.GetNodeLevel(n) of
      0 : lblInfo.Caption := 'ダブルクリックで都道府県を表示';
      1 : lblInfo.Caption := 'ダブルクリックで主要地域を表示';
      2 : lblInfo.Caption := 'ダブルクリックで市区町村を表示';
      3 : lblInfo.Caption := 'ダブルクリックで地域を決定';
    end;
  end;
end;

procedure TfrmSelectPlace.tvwTenkiDblClick(Sender: TObject);
var
  sl, sm : TStringList;
  ini : TMemIniFile;
  idx : Integer;
  sFile : String;
begin
  idx := tvwTenki.GetSelectedNodeLevel;
  Case idx of
    0 : _Create1stLevelNodeTenki;
    1 : _Create2ndLevelNodeTenki;
    3 : begin
          ini := TMemIniFile.Create(GetIniFileName, TEncoding.Unicode);
          try
            if rad3h.Checked then
              av.sSiteName := 'tenki.jp-3h'
            else
              av.sSiteName := 'tenki.jp-1h';
            av.sUrl := TTreeNodeEx(tvwTenki.Selected).sUrl;
            av.sUrlRain := ReplaceText(TTreeNodeEx(tvwTenki.Selected.Parent.Parent).sUrl, '/jp/', '/raincloud/') + '?c=g2';
            ini.WriteString('frmMain', 'Site', av.sSiteName);
            ini.WriteString('frmMain', 'Url', av.sUrl);
            ini.WriteString('frmMain', 'UrlRain', av.sUrlRain);
          finally
            ini.UpdateFile;
            ini.Free;
          end;
          //履歴に追加する
          sl := TStringList.Create;
          sm := TStringList.Create;
          try
            sFile := GetApplicationPath + 'Data\History.txt';
            if FileExists(sFile) then
              sl.LoadFromFile(sFile, TEncoding.UTF8);
            sm.Add(tvwTenki.Selected.Text);
            sm.Add(av.sUrl);
            sm.Add(av.sSiteName);
            sl.Insert(0, sm.CommaText);
            SetStringListLength(sl, 20);
            sl.SaveToFile(sFile, TEncoding.UTF8);
          finally
            sl.Free;
            sm.Free;
          end;
          frmMain._LoadAllData(False);
    	  end;
  end;
end;

procedure TfrmSelectPlace.tvwTenkiMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  n : TTreeNode;
begin
  lblInfo.Caption := '';
  n := tvwTenki.GetNodeAt(X, Y);
  if n <> nil then
  begin
    Case tvwTenki.GetNodeLevel(n) of
      0 : lblInfo.Caption := 'ダブルクリックで都道府県を表示';
      1 : lblInfo.Caption := 'ダブルクリックで主要地域を表示';
      2 : lblInfo.Caption := 'ダブルクリックで市区町村を表示';
      3 : lblInfo.Caption := 'ダブルクリックで地域を決定';
    end;
  end;
end;

end.

