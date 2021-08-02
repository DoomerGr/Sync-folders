unit ViewLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, RzEdit,
  Vcl.ComCtrls;

type
  TFmViewLog = class(TForm)
    MainMenu1: TMainMenu;
    C1: TMenuItem;
    N3: TMenuItem;
    RzRichEdit1: TRzRichEdit;
    N1Save: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N1SaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
   NameFileLog:String;
    { Public declarations }
  end;

var
  FmViewLog: TFmViewLog;

implementation

{$R *.dfm}

uses SinhronN;

procedure TFmViewLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 MainMenu1.Items.Items[0].Items[0].Visible:=True;
end;

procedure TFmViewLog.FormShow(Sender: TObject);
begin
 RzRichEdit1.Lines.Clear;
 if NameFileLog<>'' then
  begin
   if FileExists(NameFileLog) then
    RzRichEdit1.Lines.LoadFromFile(NameFileLog);
  end;
end;

procedure TFmViewLog.N1SaveClick(Sender: TObject);
begin
 RzRichEdit1.Lines.SaveToFile(NameFileLog);
end;

procedure TFmViewLog.N3Click(Sender: TObject);
begin
 Close
end;

end.
