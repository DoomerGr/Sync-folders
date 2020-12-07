program Sinhron;

uses
  Forms,
  DiskTools in 'DiskTools.pas',
  SinhronConfig in 'SinhronConfig.pas' {FmConfig},
  Vcl.Themes,
  Vcl.Styles,
  SinhronN in 'SinhronN.pas' {FmSinhron},
  DialogFulCopy in 'DialogFulCopy.pas' {FmDialogFulCopy},
  ViewLog in 'ViewLog.pas' {FmViewLog},
  ViewSnimok in 'ViewSnimok.pas' {FmShowSnimok};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Синронизация папок двух компьютеров через внешний носитель';
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TFmSinhron, FmSinhron);
  Application.CreateForm(TFmConfig, FmConfig);
  Application.CreateForm(TFmDialogFulCopy, FmDialogFulCopy);
  Application.CreateForm(TFmViewLog, FmViewLog);
  Application.CreateForm(TFmShowSnimok, FmShowSnimok);
  Application.Run;
end.
