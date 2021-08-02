unit ViewHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzLabel, RzBorder;

type
  TFmHelp = class(TForm)
    RzLabel1: TRzLabel;
    RzBorder1: TRzBorder;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmHelp: TFmHelp;

implementation

{$R *.dfm}

end.
