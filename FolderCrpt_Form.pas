unit FolderCrpt_Form;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, RzBorder, Vcl.ComCtrls, Vcl.Buttons, RzSpnEdt, Vcl.StdCtrls, RzLabel,
  Vcl.ExtCtrls, RzPanel, RzShellDialogs;

type
  TForm1 = class(TForm)
    RzPanelProgress: TRzPanel;
    RzLabelNameFile: TRzLabel;
    RzLabelNameFolder: TRzLabel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzBtnStopCopy: TRzRapidFireButton;
    ProgressBarFile: TProgressBar;
    ProgressBarFolder: TProgressBar;
    RzBorder2: TRzBorder;
    RzBitBtnAddProfil: TRzBitBtn;
    RzBtnSinhronWorkHome: TRzBitBtn;
    RzBtnSinhronHomeWork: TRzBitBtn;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
