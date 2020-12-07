unit ViewSnimok;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  WinProcs,Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls,
  RzLabel, Vcl.ExtCtrls, RzPanel;

type
  TFmShowSnimok = class(TForm)
    StringGrid1: TStringGrid;
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabelFolderName: TRzLabel;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RzPanel1Resize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmShowSnimok: TFmShowSnimok;

implementation

{$R *.dfm}

procedure TFmShowSnimok.RzPanel1Resize(Sender: TObject);
begin
 RzLabelFolderName.Width:=RzPanel1.Width-106
end;

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
 StringGrid1.Canvas.FillRect(Rect); // ����������� ������
 StrPCopy(C, StringGrid1.Cells[ACol, ARow]); // �������������� ������ � ������ PChar

 WinProcs.DrawText(StringGrid1.Canvas.Handle, C, StrLen(C), Rect, Format);

{ with Sender as TStringGrid, Canvas do
 begin
//    canvas.Brush.Color:=clWhite;
    fillrect(rect);
    SetTextAlign(Handle, TA_CENTER);
   TextOut(round((Rect.right+Rect.left)/2), Rect.Top+2, Cells[aCol, aRow]);
  end;}

end;

end.


//��������� ������������, ��������  DataAlignMent:=taCenter
//���� ��������� ���� ���������� �� OnDrawCell

procedure TMainForm.Grid1DrawCell(Sender: TObject;
ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);

var s: string;
begin
with Sender as TStringGrid do begin
s:=cells[acol,arow]; //��������� ����� �� ������
canvas.FillRect (rect);
//�������������� ������, ����� �� ����� �������� ����
rect.right:=rect.Right-2;
//�������� ������ ������ ������, ����� �� ������
If DataAlignMent=taRightJustify then
//�������� ����� ������������ � ������ � ������ �����������
DrawText(canvas.handle,pchar(s),-1,Rect,
DT_SINGLELINE OR DT_VCENTER OR DT_RIGHT)
//�������� �����������_��_������ + �������������_������
else
DrawText(canvas.handle,pchar(s),-1,Rect,
DT_SINGLELINE OR DT_VCENTER OR DT_CENTER);
//�������� �����������_��_������ + �������������_��_������
end ...
//��� ��������� �������� ���� � �����


procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
const
  strHello : string = 'Hello, World!';
begin
  if ACol = 4 then
    DrawText(StringGrid1.Canvas.Handle, PChar(strHello), Length(strHello), Rect, DT_CENTER);
end;