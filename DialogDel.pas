unit DialogDel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzButton, RzRadChk, Vcl.StdCtrls,
  RzLabel, Vcl.ExtCtrls, RzPanel, RzBorder;

type
  TFmDialogFulCopy = class(TForm)
    RzPanel1: TRzPanel;
    RzLabel1: TRzLabel;
    RzCheckBox1: TRzCheckBox;
    RzBitBtnOk: TRzBitBtn;
    RzBorder1: TRzBorder;
    RzCheckBoxAll: TRzCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzBitBtnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
   All:boolean;
  end;

var
  FmDialogFulCopy: TFmDialogFulCopy;


implementation

{$R *.dfm}

procedure TFmDialogFulCopy.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if RzCheckBox1.Checked then ModalResult:=mrOK else ModalResult:=mrNo;
end;

procedure TFmDialogFulCopy.RzBitBtnOkClick(Sender: TObject);
begin
 All:=RzCheckBoxAll.Checked;
 close
end;

end.
