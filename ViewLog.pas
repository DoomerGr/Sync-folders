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

procedure TFmViewLog.FormShow(Sender: TObject);
var MemStream:TMemoryStream;
begin
 RzRichEdit1.Lines.Clear;

 if NameFileLog<>'' then
  begin
   if FileExists(NameFileLog) then
    RzRichEdit1.Lines.LoadFromFile(NameFileLog);
  end
    else
     begin
      try
       MemStream:=TMemoryStream.Create;
        try
         FmSinhron.RzRichEditEchoCom.Lines.SaveToStream(MemStream);
         MemStream.Seek(0,soFromBeginning);
         RzRichEdit1.Lines.LoadFromStream(MemStream);
          finally
            MemStream.Free;
          end;
       except
        FmViewLog.NameFileLog:='';
       end;
     end
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
