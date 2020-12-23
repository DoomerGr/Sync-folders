unit ViewSnimok;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  WinProcs,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  RzLabel, Vcl.ExtCtrls, RzPanel, Vcl.Menus;

type
  TFmShowSnimok = class(TForm)
    StringGrid1: TStringGrid;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabelFolderName: TRzLabel;
    PopupMenu1: TPopupMenu;
    N1_Find: TMenuItem;
    FindDialog1: TFindDialog;
    procedure RzPanel1Resize(Sender: TObject);
    procedure N1_FindClick(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FindDialog1Show(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Poisk:Integer;
  end;

var
  FmShowSnimok: TFmShowSnimok;

implementation

{$R *.dfm}

procedure TFmShowSnimok.FindDialog1Find(Sender: TObject);
var i:Integer;
    Find_S,Stmp:string;
begin
 if not(frMatchCase in FindDialog1.Options) then
            Find_S:=UpperCase(FindDialog1.FindText);

 if Poisk>1 then
  if frDown  in FindDialog1.Options then
    begin
     if Poisk<StringGrid1.cols[1].Count-2 then Poisk:=Poisk+1
    end
  else  if Poisk>2 then Poisk:=Poisk-1;


 if frDown  in FindDialog1.Options then
  for i:=Poisk to StringGrid1.cols[1].Count-1 do
   begin
     if not(frMatchCase in FindDialog1.Options) then
      Stmp:=UpperCase(StringGrid1.cols[1][i])
     else Stmp:=StringGrid1.cols[1][i];

     if frWholeWord  in FindDialog1.Options then
       begin
        if Find_S=Stmp then
         begin
          StringGrid1.Row:=i;Poisk:=i;
          break
         end
       end
     else
      begin
       if Pos(Find_S,Stmp)>0 then
        begin
         StringGrid1.Row:=i;
         Poisk:=i;
         break
        end;
      end;
   end
  else
    for i:=Poisk downto 1 do
     begin
       if not(frMatchCase in FindDialog1.Options) then
        Stmp:=UpperCase(StringGrid1.cols[1][i])
       else Stmp:=StringGrid1.cols[1][i];
       if frWholeWord  in FindDialog1.Options then
         begin
          if Find_S=Stmp then
           begin
            StringGrid1.Row:=i;Poisk:=i;
            break
           end
         end
       else
        begin
         if Pos(Find_S,Stmp)>0 then
          begin
           StringGrid1.Row:=i;Poisk:=i;
           break
          end;
        end;
     end
end;


procedure TFmShowSnimok.FindDialog1Show(Sender: TObject);
begin
 Poisk:=1;
end;

procedure TFmShowSnimok.N1_FindClick(Sender: TObject);

begin
 if StringGrid1.RowCount=0 then exit
 else  FindDialog1.Execute;
end;

procedure TFmShowSnimok.RzPanel1Resize(Sender: TObject);
begin
 RzLabelFolderName.Width:=RzPanel1.Width-106
end;

procedure TFmShowSnimok.StringGrid1Click(Sender: TObject);
begin
 Poisk:=StringGrid1.Row;
end;

procedure TFmShowSnimok.StringGrid1DblClick(Sender: TObject);
begin
 if goRowSelect in StringGrid1.Options then
  StringGrid1.Options:=StringGrid1.Options-[goRowSelect]
   else StringGrid1.Options:=StringGrid1.Options+[goRowSelect]
end;

end.

//======================================================================

procedure TFmShowSnimok.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var  Format: Word;
     C:array[0..255] of Char;
begin
exit;
//if ARow=0 then exit;
if ACol = 0 then Format:=DT_CENTER
   else if ACol = 1 then Format := DT_LEFT
   else   Format := DT_RIGHT;
   if ARow = 0 then  Format := DT_CENTER;
 StringGrid1.Brush.Style:=bsSolid;
 StringGrid1.Canvas.FillRect(Rect); // перерисовка ¤чейки
 StrPCopy(C, StringGrid1.Cells[ACol, ARow]); // преобразование строки в формат PChar

 WinProcs.DrawText(StringGrid1.Canvas.Handle, C, StrLen(C), Rect, Format);

{ with Sender as TStringGrid, Canvas do
 begin
//    canvas.Brush.Color:=clWhite;
    fillrect(rect);
    SetTextAlign(Handle, TA_CENTER);
   TextOut(round((Rect.right+Rect.left)/2), Rect.Top+2, Cells[aCol, aRow]);
  end;}

end;


//установка выравнивани¤, например  DataAlignMent:=taCenter
//саму процедуру надо подключить на OnDrawCell

procedure TMainForm.Grid1DrawCell(Sender: TObject;
ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

var s: string;
begin
with Sender as TStringGrid do begin
s:=cells[acol,arow]; //сохран¤ем текст из ¤чейки
canvas.FillRect (rect);
//перерисовываем ¤чейку, здесь же можно изменить цвет
rect.right:=rect.Right-2;
//смещение текста внутри ¤чейки, можно не делать
If DataAlignMent=taRightJustify then
//печатаем текст содержащийс¤ в ¤чейке с любыми параметрами
DrawText(canvas.handle,pchar(s),-1,Rect,
DT_SINGLELINE OR DT_VCENTER OR DT_RIGHT)
//например ¬≈–“» јЋ№Ќќ_ѕќ_÷≈Ќ“–” + √ќ–»«ќЌ“јЋ№Ќќ_¬ѕ–ј¬ќ
else
DrawText(canvas.handle,pchar(s),-1,Rect,
DT_SINGLELINE OR DT_VCENTER OR DT_CENTER);
//например ¬≈–“» јЋ№Ќќ_ѕќ_÷≈Ќ“–” + √ќ–»«ќЌ“јЋ№Ќќ_ѕќ_÷≈Ќ“–”
end ...
//все возможные значени¤ есть в ’элпе


procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  strHello : string = 'Hello, World!';
begin
  if ACol = 4 then
    DrawText(StringGrid1.Canvas.Handle, PChar(strHello), Length(strHello), Rect, DT_CENTER);
end;