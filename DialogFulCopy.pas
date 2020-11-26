unit DialogFulCopy;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, RzRadChk, Vcl.StdCtrls,
  RzLabel, Vcl.ExtCtrls, RzPanel, RzBorder,Vcl.FileCtrl, Vcl.Imaging.pngimage;

type
  TFmDialogFulCopy = class(TForm)
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzCheckBoxCopyAll: TRzCheckBox;
    RzBitBtnOk: TRzBitBtn;
    RzCheckBoxAll: TRzCheckBox;
    RzBitBtnClose: TRzBitBtn;
    RzLabelNameFolder: TRzLabel;
    RzLabel2: TRzLabel;
    procedure RzBitBtnOkClick(Sender: TObject);
    procedure RzBitBtnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
   All:boolean;
   MR:TModalResult;
   NameFolder:string;
  end;

var
  FmDialogFulCopy: TFmDialogFulCopy;



implementation

{$R *.dfm}

procedure TFmDialogFulCopy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 ModalResult:=MR;
end;

procedure TFmDialogFulCopy.FormShow(Sender: TObject);
begin
 RzLabelNameFolder.Caption:=MinimizeName(NameFolder,RzLabelNameFolder.Canvas,RzLabelNameFolder.Width);
 MR:=mrAbort;
end;

procedure TFmDialogFulCopy.RzBitBtnCloseClick(Sender: TObject);
begin
 MR:=mrAbort;
 close
end;

procedure TFmDialogFulCopy.RzBitBtnOkClick(Sender: TObject);
begin
 All:=RzCheckBoxAll.Checked;
 if RzCheckBoxCopyAll.Checked then MR:=mrOK else MR:=mrNo;
 close
end;

end.
