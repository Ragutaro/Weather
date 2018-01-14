unit untYahoo;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, System.StrUtils, IniFilesDX, System.Types;

  type
    TYahoo = class
    private
      function  _GetWeatherIndex(const sWeather, sTime: String): Integer;
      procedure _CreateRainUrl(const sUrl: String);
      procedure _CreatelaceData(sl: tstringlist);
      procedure _CreateDailyWeather(sl: TStringList);
      procedure _CreateWeeklyWeather(sl: TStringList);
      procedure _CreateCautionInformation(sl: TStringList);
      procedure _CreateCrisisInformation(sl: TStringList);
    public
      procedure _CreateWeatherData(const sUrl: String; bIsCache: Boolean);
    end;

var
  Yahoo : TYahoo;

implementation

uses
  HideUtils,
  dp,
  Main;

var
  ini : TMemIniFile;

function TYahoo._GetWeatherIndex(const sWeather, sTime: String): Integer;
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
  else if ContainsText(sWeather, '雷') then
    idx := 6
  else
    idx := 7;
  Result := idx;
end;

procedure TYahoo._CreateRainUrl(const sUrl: String);
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    SplitByString(sUrl, '/', sl);
    ini.WriteString('General', 'RainUrl', Format('https://weather.yahoo.co.jp/weather/raincloud/%s/?c=g2', [sl[5]]));
  finally
    sl.Free;
  end;
end;

procedure TYahoo._CreatelaceData(sl: tstringlist);
var
  sTmp : String;
begin
  sTmp := CopyStr(sl.Text, '<title>', 'の天気');
  sTmp := RemoveHTMLTags(sTmp);
  ini.WriteString('General', 'Place', sTmp);
end;

procedure TYahoo._CreateDailyWeather(sl: TStringList);
  procedure in_CreateData(slSrc: TStringList; sDivStr: String; iIndex, iToday: Integer);
  var
    sWeather : array[1..16] of String;
    sSource, sDiv, sTmp : String;
    iPos, iCnt, idx : Integer;
    bPassed : Boolean;
  begin
    sSource := CopyStr(slSrc.Text, sDivStr, '</table>');
    iCnt := iIndex;
    //時間
    sDiv := CopyStr(sSource, '</small>', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
      if ContainsText(sTmp, '#999999') then
        bPassed := True
      else
        bPassed := False;
      sTmp := RemoveHTMLTags(sTmp);
      sWeather[iCnt] := sTmp;
      ini.WriteInteger('Day' + IntToStr(iCnt), 'Day', iToday);
      ini.WriteBool('Day' + IntToStr(iCnt), 'IsPassed', bPassed);
      ini.WriteString('Day' + IntToStr(iCnt), 'Time', sTmp);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
    //天気
    iCnt := iIndex;
    sDiv := CopyStr(sSource, '天気</small>', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      idx := _GetWeatherIndex(sTmp, sWeather[iCnt]);
      ini.WriteString('Day'+IntToStr(iCnt), 'Weather', sTmp);
      ini.WriteInteger('Day'+IntToStr(iCnt), 'ImageIndex', idx);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
    //気温
    iCnt := iIndex;
    sDiv := CopyStr(sSource, '気温（℃）</small>', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      ini.WriteString('Day'+IntToStr(iCnt), 'Kion', sTmp);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
    //湿度
    iCnt := iIndex;
    sDiv := CopyStr(sSource, '湿度（％）</small>', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      ini.WriteString('Day'+IntToStr(iCnt), 'Shitsudo', sTmp);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
    //降水量
    iCnt := iIndex;
    sDiv := CopyStr(sSource, '降水量（mm/h）', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      ini.WriteString('Day'+IntToStr(iCnt), 'Rain', sTmp);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
    //風
    iCnt := iIndex;
    sDiv := CopyStr(sSource, '風速（m/s）', '</tr>');
    iPos := PosText('<small>', sDiv);
    repeat
      sTmp := CopyStrEx(sDiv, '<small>', '<br>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      ini.WriteString('Day'+IntToStr(iCnt), 'WindDirection', sTmp);
      sTmp := CopyStrEx(sDiv, '<br>', '</small>', iPos);
      sTmp := RemoveHTMLTags(sTmp);
      ini.WriteString('Day'+IntToStr(iCnt), 'WindStrong', sTmp);
      iCnt := iCnt + 1;
      iPos := PosTextEx('<small>', sDiv, iPos+1);
    until iPos = 0;
  end;

begin
  in_CreateData(sl, '<h3>今日の天気', 1, 0);
  in_CreateData(sl, '<h3>明日の天気', 9, 1);
end;

procedure TYahoo._CreateWeeklyWeather(sl: TStringList);
var
  sSource, sDiv, sTmp : String;
  iPos, iCnt : Integer;
begin
  SetLength(wwd, 7);
  //今日の天気
  sSource := CopyStr(sl.Text, '<!---週間の天気--->', '</table>');
  //日付
  iCnt := 1;
  sDiv := CopyStr(sSource, '日付</small>', '</tr>');
  iPos := PosText('<small>', sDiv);
  repeat
    sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
    sTmp := RemoveHTMLTags(sTmp);
    sTmp := RemoveLeft(CopyStrToEnd(sTmp, '月'), 1);
    sTmp := ReplaceText(sTmp, '日(', '(');
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Date', sTmp);
    iCnt := iCnt + 1;
    iPos := PosTextEx('<small>', sDiv, iPos+1);
  until iPos = 0;
  //天気
  iCnt := 1;
  sDiv := CopyStr(sSource, '天気</small>', '</tr>');
  iPos := PosText('<small>', sDiv);
  repeat
    sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
    sTmp := RemoveHTMLTags(sTmp);
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Weather', sTmp);
    iCnt := iCnt + 1;
    iPos := PosTextEx('<small>', sDiv, iPos+1);
  until iPos = 0;
  //気温
  iCnt := 1;
  sDiv := CopyStr(sSource, '気温（℃）</small>', '</tr>');
  iPos := PosText('<small>', sDiv);
  repeat
    sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
    //最高気温
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<small>', '</font>', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'TempHigh', sTmp);
    //最低気温
    sTmp := RemoveHTMLTags(CopyStrEx(sDiv, '<br>', '</font>', iPos));
    ini.WriteString('Weekly'+IntToStr(iCnt), 'TempLow', sTmp);
    iCnt := iCnt + 1;
    iPos := PosTextEx('<small>', sDiv, iPos+1);
  until iPos = 0;
  //降水確率
  iCnt := 1;
  sDiv := CopyStr(sSource, '確率（％）</small>', '</tr>');
  iPos := PosText('<small>', sDiv);
  repeat
    sTmp := CopyStrEx(sDiv, '<small>', '</small>', iPos);
    sTmp := RemoveHTMLTags(sTmp);
    ini.WriteString('Weekly'+IntToStr(iCnt), 'Rain', sTmp);
    iCnt := iCnt + 1;
    iPos := PosTextEx('<small>', sDiv, iPos+1);
  until iPos = 0;
end;

procedure TYahoo._CreateCautionInformation(sl: TStringList);
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

procedure TYahoo._CreateCrisisInformation(sl: TStringList);
var
  sm : TStringList;
  sSource, sUrl, sTmp : String;
begin
  //避難情報
  sSource := CopyStr(sl.Text, '<!-- 大雨災害モジュール -->', '<!-- /大雨災害モジュール -->');
  //防災情報のURLを作成する
  sm := TStringList.Create;
  try
    sTmp := CopyStr(sSource, '<a href', '>');
    sm.CommaText := sTmp;
    if sm.Count <> 0 then
      sUrl := 'https:' + RemoveRight(RemoveLeft(sm[1], 6),1)
    else
      sUrl := av.sUrl;
  finally
    sm.Free;
  end;
  ini.WriteString('Crisis', 'Url', sUrl);

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

procedure TYahoo._CreateWeatherData(const sUrl: String; bIsCache: Boolean);
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
      _CreatelaceData(sl);
      _CreateRainUrl(sUrl);
      _CreateDailyWeather(sl);
      _CreateWeeklyWeather(sl);
      _CreateCautionInformation(sl);
      _CreateCrisisInformation(sl);
    end;
  finally
    ini.UpdateFile;
    ini.Free;
    sl.Free;
  end;
end;


end.
