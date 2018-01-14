unit untTenki;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, System.StrUtils, IniFilesDX, System.Types;

  type TTenkJP = class
  private
    procedure _CreateCautionInformationFromYahoo(sl: TStringList);
    function _CreateYahooCrisisUrl(const sUrl: String): String;
    procedure _CreateCrisisDataFromYahoo(sl: TStringList);
    function  _GetWeatherIndex(const sWeather, sTime: String): Integer;
    procedure _CreateRainUrl(const sUrl: String);
    procedure _CreatePlaceData(sl: tstringlist);
    procedure _CreateDailyWeather(sl: TStringList);
    procedure _CreateWeeklyWeather(sl: TStringList);
    procedure _CreateCautionInformation(sl: TStringList);
  public
    procedure _CreateWeatherData(const sUrl: String; bIsCache: Boolean);
  end;

var
  TenkiJP : TTenkJP;

implementation

uses
  HideUtils,
  dp,
  Main;

var
  ini : TMemIniFile;

procedure TTenkJP._CreateCautionInformationFromYahoo(sl: TStringList);
var
  sSource, sTmp : String;
begin
  sSource := CopyStr(sl.Text, '<!-- 警報・注意報 -->', '<!-- /警報・注意報 -->');
  //特別警報
  sTmp := CopyStr(sSource, '<span class="icoEmgWarning">', '</dl>');
  sTmp := RemoveHTMLTags(CopyStrToEnd(sTmp, '<dd>'));
  sTmp := ReplaceText(sTmp, '、', ',');
  ini.WriteString('Cautions', 'EmgWarning', sTmp);
  //特別警報予備軍
  sTmp := CopyStr(sSource, '<span class="icoWarnToEmg">', '</dl>');
  sTmp := RemoveHTMLTags(CopyStr(sTmp, '<dd>', '<span'));
  sTmp := ReplaceText(sTmp, '、', ',');
  ini.WriteString('Cautions', 'WarnToEmg', sTmp);
  //警報
  sTmp := CopyStr(sSource, '<span class="icoWarning">', '</dl>');
  sTmp := RemoveHTMLTags(CopyStrToEnd(sTmp, '<dd>'));
  sTmp := ReplaceText(sTmp, '、', ',');
  ini.WriteString('Cautions', 'Warning', sTmp);
  //警報予備軍
  sTmp := CopyStr(sSource, '<span class="icoAdvToWarn">', '</dl>');
  sTmp := RemoveHTMLTags(CopyStr(sTmp, '<dd>', '<span'));
  sTmp := ReplaceText(sTmp, '、', ',');
  ini.WriteString('Cautions', 'AdvToWarn', sTmp);
  //注意報
  sTmp := CopyStr(sSource, '<span class="icoAdvisory">', '</dl>');
  sTmp := RemoveHTMLTags(CopyStr(sTmp, '<dd>', '<span'));
  sTmp := ReplaceText(sTmp, '、', ',');
  ini.WriteString('Cautions', 'Advisory', sTmp);
end;

function TTenkJP._CreateYahooCrisisUrl(const sUrl: String): String;
var
  sl : TStringList;
  s : String;
begin
  sl := TStringList.Create;
  try
    SplitByString(sUrl, '/', sl);
    if sl[5] = '1' then
      s := '1a'
    else if sl[5] = '2' then
      s := '1b'
    else if sl[5] = '3' then
      s := '1c'
    else if sl[5] = '4' then
      s := '1d'
    else
      s := IntToStr(StrToInt(sl[5])-3);
    Result := Format('https://weather.yahoo.co.jp/weather/jp/%s/%s/%s.html',
                     [s, sl[6], sl[7]]);
    ini.WriteString('Crisis', 'Url', Result);
  finally
    sl.Free;
  end;
end;

procedure TTenkJP._CreateCrisisDataFromYahoo(sl: TStringList);
var
  sSource : String;
begin
  //避難情報
  sSource := CopyStr(sl.Text, '<!-- 大雨災害モジュール -->', '<!-- /大雨災害モジュール -->');

  if ContainsText(sSource, '警戒区域') then
    ini.WriteString('Crisis', 'HinanType', '警戒区域')
  else if ContainsText(sSource, '避難指示') then
    ini.WriteString('Crisis', 'HinanType', '避難指示')
  else if ContainsText(sSource, '避難勧告') then
    ini.WriteString('Crisis', 'HinanType', '避難勧告')
  else if ContainsText(sSource, '避難準備') then
    ini.WriteString('Crisis', 'HinanType', '避難準備');

  //土砂災害警戒情報
  if ContainsText(sSource, '<span>土砂災害警戒情報') then
    ini.WriteString('Crisis', 'DoshyaType', '土砂災害警戒');

  //河川情報
  if ContainsText(sSource, '<span>氾濫発生情報') then
    ini.WriteString('Crisis', 'RiverType', '氾濫発生情報')
  else if ContainsText(sSource, '<span>氾濫危険情報') then
    ini.WriteString('Crisis', 'RiverType', '氾濫危険情報')
  else if ContainsText(sSource, '<span>氾濫警戒情報') then
    ini.WriteString('Crisis', 'RiverType', '氾濫警戒情報')
  else if ContainsText(sSource, '<span>氾濫注意情報') then
    ini.WriteString('Crisis', 'RiverType', '氾濫注意情報');
end;

function TTenkJP._GetWeatherIndex(const sWeather, sTime: String): Integer;
var
  idx, iTime : Integer;
begin
//  if ContainsText(sWeather, '晴') then
//  begin
//    iTime := StrToIntDefEx(sTime, 0);
//    if iTime in [6..17] then
//      idx := 0
//    else
//      idx := 1;
//  end
//  else if ContainsText(sWeather, '曇') then
//    idx := 2
//  else if ContainsText(sWeather, '小雨') then
//    idx := 3
//  else if ContainsText(sWeather, '弱雨') then
//    idx := 3
//  else if ContainsText(sWeather, '強雨') then
//    idx := 4
//  else if ContainsText(sWeather, '雨') then
//    idx := 4
//  else if ContainsText(sWeather, '雪') then
//    idx := 5
//  else if ContainsText(sWeather, '雷') then
//    idx := 6
//  else
//    idx := 7;
//  Result := idx;
  if ContainsText('晴れ', sWeather) then
  begin
    iTime := StrToIntDefEx(sTime, 0);
    if iTime in [6..17] then
      idx := 0
    else
      idx := 1;
  end
  else if ContainsText('曇り', sWeather) then
    idx := 2
  else if ContainsText('小雨,弱雨,雨', sWeather) then
    idx := 3
  else if ContainsText('強雨', sWeather) then
    idx := 4
  else if ContainsText('雪,乾雪,湿雪,みぞれ,暴風雪', sWeather) then
    idx := 5
  else if ContainsText('暴風雨,豪雨', sWeather) then
    idx := 6
  else
    idx := 7;
  Result := idx;
end;

procedure TTenkJP._CreateRainUrl(const sUrl: String);
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    SplitByString(sUrl, '/', sl);
    ini.WriteString('General', 'RainUrl', Format('https://tenki.jp/radar/%s/%s/rainmesh.html', [sl[4], sl[5]]));
  finally
    sl.Free;
  end;
end;

procedure TTenkJP._CreatePlaceData(sl: tstringlist);
var
  sTmp : String;
begin
  sTmp := CopyStr(sl.Text, '<title>', 'の今日明日の天気');
  sTmp := RemoveHTMLTags(sTmp);
  ini.WriteString('General', 'Site', 'tenki.jp-1h');
  ini.WriteString('General', 'Place', sTmp);
end;

procedure TTenkJP._CreateDailyWeather(sl: TStringList);
var
  sWeather : array of String;

  procedure in_Create(src: String; iStartIndex, iToday: Integer);
  var
    sDiv, sTmp : String;
    iPos, iCnt : Integer;
  begin
    //時間
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="hour">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<td>', '</span>', iPos);
      ini.WriteInteger('Day' + IntToStr(iCnt), 'Day', iToday);
      ini.WriteBool('Day' + IntToStr(iCnt), 'IsPassed', ContainsText(sTmp, '"past"'));
      ini.WriteString('Day' + IntToStr(iCnt), 'Time', RemoveHTMLTags(sTmp)+'時');
      sWeather[iCnt] := RemoveHTMLTags(sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //天気
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="weather">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</p>', iPos));
      ini.WriteString('Day'+IntToStr(iCnt), 'Weather', sTmp);
      ini.WriteInteger('Day'+IntToStr(iCnt), 'ImageIndex', _GetWeatherIndex(sTmp, sWeather[iCnt]));
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //気温
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="temperature">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</span>', iPos));
      ini.WriteString('Day'+IntToStr(iCnt), 'Kion', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //降水確率
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="prob-precip">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</span>', iPos));
      ini.WriteString('Day'+IntToStr(iCnt), 'RainPercent', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //降水量
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="precip-graph">', '</tr>');
    iPos := PosText('alt=', sDiv);
    repeat
      sTmp := ExtractNumber(CopyStrEx(sDiv, 'alt=', '" width', iPos), False, False);
      ini.WriteString('Day'+IntToStr(iCnt), 'Rain', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('alt=', sDiv, iPos+1);
    until iPos = 0;
    //湿度
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="humidity">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := ExtractNumber(CopyStrEx(sDiv, '<td>', '</td>', iPos), False, False);
      ini.WriteString('Day'+IntToStr(iCnt), 'Shitsudo', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //風向き
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="wind-', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</p>', iPos));
      ini.WriteString('Day'+IntToStr(iCnt), 'WindDirection', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
    //風速
    iCnt := iStartIndex;
    sDiv := CopyStr(src, '<tr class="wind-speed">', '</tr>');
    iPos := PosText('<td>', sDiv);
    repeat
      sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</span>', iPos));
      ini.WriteString('Day'+IntToStr(iCnt), 'WindStrong', sTmp);
      iCnt := iCnt+1;
      iPos := PosTextEx('<td>', sDiv, iPos+1);
    until iPos = 0;
  end;

begin
  ini.WriteInteger('Day1', 'Day', 0);
  ini.WriteBool('Day1', 'IsPassed', True);
  ini.WriteString('Day1', 'Time', '24時');
  ini.WriteString('Day1', 'Weather', '不明');
  ini.WriteInteger('Day1', 'ImageIndex', 7);
  ini.WriteString('Day1', 'Kion', '-');
  ini.WriteString('Day1', 'RainPercent', '-');
  ini.WriteString('Day1', 'Rain', '-');
  ini.WriteString('Day1', 'Shitsudo', '-');
  ini.WriteString('Day1', 'WindDirection', '-');
  ini.WriteString('Day1', 'WindStrong', '-');
  if av.sSiteName = 'tenki.jp-1h' then
  begin
  	SetLength(sWeather, 74);
    //今日
    in_Create(CopyStr(sl.Text, '<!-- today -->', '<!-- /today -->'), 2, 0);
    //明日
    in_Create(CopyStr(sl.Text, '<!-- tomorrow -->', '<!-- /tomorrow -->'), 26, 1);
    //明後日
    in_Create(CopyStr(sl.Text, '<!-- dayaftertomorrow -->', '<!-- /dayaftertomorrow -->'), 50, 2);
  end else
  begin
  	SetLength(sWeather, 26);
    //今日
    in_Create(CopyStr(sl.Text, '<!-- today -->', '<!-- /today -->'), 2, 0);
    //明日
    in_Create(CopyStr(sl.Text, '<!-- tomorrow -->', '<!-- /tomorrow -->'), 10, 1);
    //明後日
    in_Create(CopyStr(sl.Text, '<!-- dayaftertomorrow -->', '<!-- /dayaftertomorrow -->'), 18, 2);
  end;
end;

procedure TTenkJP._CreateWeeklyWeather(sl: TStringList);
var
  sSource, sDiv, sTmp : String;
  iPos, iCnt : Integer;
begin
  SetLength(wwd, 10);
  //週間天気欄に表示する明日の天気を取得する
  sSource := CopyStr(sl.Text, '<!-- 明日の天気 -->', '<!-- /明日の天気 -->');
  //日付
  sDiv := RemoveLeft(CopyStr(sSource, '月', '<span class="roku-you">'), 1);
  sDiv := ReplaceText(RemoveHTMLTags(sDiv), '日(', '(');
  ini.WriteString('Weekly1', 'Date', sDiv);
  //天気
  sDiv := RemoveHTMLTags(CopyStr(sSource, '<p class="weather-telop">', '</p>'));
  ini.WriteString('Weekly1', 'Weather', sDiv);
  //最高気温
  sDiv := RemoveHTMLTags(CopyStr(sSource, '<dd class="high-temp temp">', '</span>'));
  ini.WriteString('Weekly1', 'TempHigh', sDiv);
  //最低気温
  sDiv := RemoveHTMLTags(CopyStr(sSource, '<dd class="low-temp temp">', '</span>'));
  ini.WriteString('Weekly1', 'TempLow', sDiv);
  //降水確率
  sDiv := CopyStr(sSource, '<th>降水確率</th>', '</tr>');
  iPos := PosText('<td>', sDiv);
  iCnt := 0;
  repeat
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '<span', iPos));
    if StrToIntDefEx(sTmp, 0) > iCnt then
      iCnt := StrToIntDefEx(sTmp, 0);
    iPos := PosTextEx('<td>', sDiv, iPos+1);
  until iPos = 0;
  ini.WriteInteger('Weekly1', 'Rain', iCnt);

  //明後日以降の週間天気を取得する
  sSource := CopyStr(sl.Text, '<h3 class="bottom-style date-set">', '<!-- /.forecast-point-week -->');
  //日付
  iCnt := 2;
  sDiv := CopyStr(sSource, '<th class="citydate">', '</tr>');
  iPos := PosText('<td', sDiv);
  repeat
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td', '</td>', iPos));
    sTmp := EraseSpace(RemoveLeft(CopyStrToEnd(sTmp, '月'), 1));
    sTmp := ReplaceTextEx(sTmp, [#$D#$A, '日('], ['', '(']);
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Date', sTmp);
    iPos := PosTextEx('<td', sDiv, iPos+1);
    iCnt := iCnt+1;
  until iPos = 0;
  //天気
  iCnt := 2;
  sDiv := CopyStr(sSource, '<td class="weather-icon">', '</tr>');
  iPos := PosText('<td', sDiv);
  repeat
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td', '</p>', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Weather', sTmp);
    iPos := PosTextEx('<td', sDiv, iPos+1);
    iCnt := iCnt+1;
  until iPos = 0;
  //気温
  iCnt := 2;
  sDiv := CopyStr(sSource, '<th class="ships-info">気温', '</tr>');
  iPos := PosText('<td>', sDiv);
  repeat
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td>', '</p>', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'TempHigh', sTmp);
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<p class="low-temp">', '</p>', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'TempLow', sTmp);
    iPos := PosTextEx('<td>', sDiv, iPos+1);
    iCnt := iCnt+1;
  until iPos = 0;
  //降水確率
  iCnt := 2;
  sDiv := CopyStr(sSource, '<th class="ships-info">降水', '</tr>');
  iPos := PosText('<td', sDiv);
  repeat
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<td', '%', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Rain', sTmp);
    iPos := PosTextEx('<td', sDiv, iPos+1);
    iCnt := iCnt+1;
  until iPos = 0;
end;

procedure TTenkJP._CreateCautionInformation(sl: TStringList);
var
  sm : TStringList;
  sSource, sTmp, sData : String;
  iPos : Integer;
begin
  //防災情報のURL
  sSource := RemoveLeft(CopyStr(sl.Text, '<a href="https://tenki.jp/bousai', '">'), 9);
  if sSource = '' then
  begin
    sm := TStringList.Create;
    try
      SplitByString(av.sUrl, '/', sm);
      sSource := Format('https://tenki.jp/bousai/warn/%s/%s/', [sm[4], sm[5]]);
    finally
      sm.Free;
    end;
  end;
  ini.WriteString('Crisis', 'Url', sSource);

//  //特別警報
//  sTmp := CopyStr(sSource, '<span class="icoEmgWarning">', '</dl>');
//  sTmp := RemoveHTMLTags(CopyStrToEnd(sTmp, '<dd>'));
//  sTmp := ReplaceText(sTmp, '、', ',');
//  ini.WriteString('Cautions', 'EmgWarning', sTmp);

  //警報
  sData := '';
  sSource := CopyStr(sl.Text, '<dl class="common-warn-entries', '</dl>');
  iPos := PosText('<dd class="warn-entry">', sSource);
  while iPos > 0 do
  begin
    sTmp := RemoveHTMLTags(CopyStrEx(sSource, '<dd class="warn-entry">', '</dd>', iPos));
    sData := sData + sTmp + ',';
    iPos := PosTextEx('<dd class="warn-entry">', sSource, iPos+1);
  end;
  ini.WriteString('Cautions', 'Warning', RemoveRight(sData,1));

  //注意報
  sData := '';
  sSource := CopyStr(sl.Text, '<dl class="common-warn-entries', '</dl>');
  iPos := PosText('<dd class="alert-entry">', sSource);
  while iPos > 0 do
  begin
    sTmp := RemoveHTMLTags(CopyStrEx(sSource, '<dd class="alert-entry">', '</dd>', iPos));
    sData := sData + sTmp + ',';
    iPos := PosTextEx('<dd class="alert-entry">', sSource, iPos+1);
  end;
  ini.WriteString('Cautions', 'Advisory', RemoveRight(sData,1));
end;

procedure TTenkJP._CreateWeatherData(const sUrl: String; bIsCache: Boolean);
var
  sl : TStringList;
begin
  av.bConnect := True;
  ini := TMemIniFile.Create(GetApplicationPath + 'Data\WeatherData.ini', TEncoding.UTF8);
  sl := TStringList.Create;
  try
    if not bIsCache then
    begin
      ini.Clear;
      if av.bUseProxy then
        av.bConnect := DownloadHttpToStringListProxy(sUrl, av.sProxyServer, av.sProxyPort, sl, TEncoding.UTF8)
      else
        av.bConnect := DownloadHttpToStringList(sUrl, sl, TEncoding.UTF8);
      CreateFolder(GetApplicationPath + 'Data');
      if sl.Text <> '' then
        sl.SaveToFile(GetApplicationPath + 'Data\WeatherData.html', TEncoding.UTF8);
    end
    else
      sl.LoadFromFile(GetApplicationPath + 'Data\WeatherData.html', TEncoding.UTF8);

    if av.bConnect then
    begin
      _CreateRainUrl(sUrl);
      _CreatePlaceData(sl);
      _CreateWeeklyWeather(sl);

      if av.sSiteName = 'tenki.jp-3h' then
        DownloadHttpToStringList(sUrl + '3hours.html', sl, TEncoding.UTF8)
      else
        DownloadHttpToStringList(sUrl + '1hour.html', sl, TEncoding.UTF8);

      _CreateDailyWeather(sl);
      if av.bGetFromYahoo then
      begin
        DownloadHttpToStringList(_CreateYahooCrisisUrl(sUrl), sl, TEncoding.UTF8);
        _CreateCautionInformationFromYahoo(sl);
      	_CreateCrisisDataFromYahoo(sl);
      end
      else
        _CreateCautionInformation(sl);
    end;
  finally
    ini.UpdateFile;
    ini.Free;
    sl.Free;
  end;
end;


{ TTest }

end.
