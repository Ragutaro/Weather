program Weather;

{$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
{$WEAKLINKRTTI ON}

{$R *.dres}

uses
  Windows,
  System.SysUtils,
  Winapi.Messages,
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  SelectPlace in 'SelectPlace.pas' {frmSelectPlace},
  untVersion in 'untVersion.pas' {frmVersion},
  Option in 'Option.pas' {frmOption},
  Rain in 'Rain.pas' {frmRain},
  EditFavorite in 'EditFavorite.pas' {frmEditFavorite},
  untYahoo in 'untYahoo.pas',
  VerUp in 'VerUp.pas' {frmVerUp},
  untTenki in 'untTenki.pas',
  PngUtils in '..\_Component\PngUtils.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True; //これを追加

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := '机上予報';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
