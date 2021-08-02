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
  ViewSnimok in 'ViewSnimok.pas' {FmShowSnimok},
  ViewHelp in 'ViewHelp.pas' {FmHelp};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '������������ ����� ���� ����������� ����� ������� ��������';
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TFmSinhron, FmSinhron);
  Application.CreateForm(TFmConfig, FmConfig);
  Application.CreateForm(TFmDialogFulCopy, FmDialogFulCopy);
  Application.CreateForm(TFmViewLog, FmViewLog);
  Application.HintHidePause:=6000;

  if ParamCount>1 then
   begin
    FmSinhron.WindowState:=wsMinimized;
    if ParamStr(5)='hide' then  FmSinhron.RunParamStr(FmSinhron);
    FmSinhron.TimerCmdBoot.Enabled:=true;
   end;
  Application.Run;
end.
