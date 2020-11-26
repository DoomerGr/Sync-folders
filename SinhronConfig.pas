unit SinhronConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, VCLTee.TeCanvas, DiskTools,
  Vcl.ExtCtrls, RzPanel, RzButton, Vcl.ImgList, RzGroupBar, RzCmboBx, RzLabel,
  Vcl.ComCtrls,RzRadChk, RzShellDialogs, Vcl.Mask, RzEdit, RzSpnEdt, RzTrkBar;

type

  TFmConfig = class(TForm)
    RzPanel1: TRzPanel;
    ImageList1: TImageList;
    RzBitBtnSaveConfig: TRzBitBtn;
    RzBitBtnCloseConfig: TRzBitBtn;
    RzGroupBar1: TRzGroupBar;
    RzGroup1: TRzGroup;
    RzGroup2: TRzGroup;
    RzGroup3: TRzGroup;
    RzGroup4: TRzGroup;
    RzCheckBoxDelConfirm: TRzCheckBox;
    EditFileExcept: TEdit;
    RzLabel2: TRzLabel;
    ButtonPathWork: TButton;
    ButtonPathHome: TButton;
    EditPathHome: TEdit;
    EditPathWork: TEdit;
    RzLabel1: TRzLabel;
    EditProfName: TEdit;
    RzCheckBoxSaveLog: TRzCheckBox;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    EditIdProf: TEdit;
    RzLabel3: TRzLabel;
    RzTrackBarNomFolder: TRzTrackBar;
    RzLabelNomer: TRzLabel;
    ButtonClearFilesProf: TButton;
    RzCheckBoxOperacDel: TRzCheckBox;
    RzLabel4: TRzLabel;
    RadioButtonPCWork: TRadioButton;
    RadioButtonPCHome: TRadioButton;
    ButtonViewLog: TButton;
    RzCheckBoxDellBasket: TRzCheckBox;
    procedure RzBitBtnCloseConfigClick(Sender: TObject);
    procedure RzBitBtnSaveConfigClick(Sender: TObject);
    procedure ButtonPathWorkClick(Sender: TObject);
    procedure ButtonPathHomeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RzTrackBarNomFolderChange(Sender: TObject);
    procedure ButtonClearFilesProfClick(Sender: TObject);
    procedure RzTrackBarNomFolderChanging(Sender: TObject; NewPos: Integer;
      var AllowChange: Boolean);
    procedure ButtonViewLogClick(Sender: TObject);
    procedure RzCheckBoxOperacDelClick(Sender: TObject);
  private
    { Private declarations }
  public
   ProfNew:Boolean;
   NProf:Integer;
    { Public declarations }
  end;

var
  FmConfig: TFmConfig;
  ProgramPath:string;
  ProfilLine:TProfilLine;
  ProfilArray: array of TProfilLine;

implementation

{$R *.dfm}

uses SinhronN, ViewLog;

procedure TFmConfig.ButtonClearFilesProfClick(Sender: TObject);
 var s:string;
begin
 S:=ProgramPath+'Task\'+ProfilLine.Id;
 if DirectoryExists(s) then DelDir(S,false,true);
end;

procedure TFmConfig.ButtonPathHomeClick(Sender: TObject);
begin
 RzSelectFolderDialog1.SelectedPathName:=ExtractFilePath(ParamStr(0));
  if RzSelectFolderDialog1.Execute then
    EditPathHome.Text:=RzSelectFolderDialog1.SelectedPathName;
end;

procedure TFmConfig.ButtonPathWorkClick(Sender: TObject);
begin
 RzSelectFolderDialog1.SelectedPathName:=ExtractFilePath(ParamStr(0));
  if RzSelectFolderDialog1.Execute then
    EditPathWork.Text:=RzSelectFolderDialog1.SelectedPathName;
end;


procedure TFmConfig.ButtonViewLogClick(Sender: TObject);

begin
 if (FileExists(ProgramPath+'Task\'+FmSinhron.Task.Id+'\'+FmSinhron.Task.Id+'.log'))  then
  begin
   FmViewLog.NameFileLog:=ProgramPath+'Task\'+FmSinhron.Task.Id+'\'+FmSinhron.Task.Id+'.log';
   FmViewLog.Show;
  end
   else exit;
end;

procedure TFmConfig.RzBitBtnCloseConfigClick(Sender: TObject);
begin
 Close
end;

procedure TFmConfig.RzBitBtnSaveConfigClick(Sender: TObject);
var f:file of TProfilLine;
    i:Integer;
    ProvName,ProvPath:Boolean;

begin
 ProvPath:=False;
 ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathWork:=EditPathWork.Text;
 ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathHome:=EditPathHome.Text;
 for i:=1 to 10 do
  begin
   if (ProfilLine.FolderDual[i].PathWork<>'') or
     (ProfilLine.FolderDual[i].PathHome<>'') then
      begin ProvPath:=true;Break end
  end;
  if EditProfName.Text<>'' then ProvName:=True else ProvName:=False;

 if not(ProvName and ProvPath) then
  begin
   Application.MessageBox('ÕÂ ‚ÒÂ Ô‡‡ÏÂÚ˚ ‚‚Â‰ÂÌ˚', 'Œ¯Ë·Í‡', MB_OK +
   MB_ICONSTOP);
   exit
  end;

  for i:=1 to 10 do
  begin
   if (ProfilLine.FolderDual[i].PathWork<>'') then
    ProfilLine.FolderDual[i].PathWork:=IncludeTrailingBackslash(ProfilLine.FolderDual[i].PathWork);
   if (ProfilLine.FolderDual[i].PathHome<>'') then
    ProfilLine.FolderDual[i].PathHome:=IncludeTrailingBackslash(ProfilLine.FolderDual[i].PathHome);
  end;


 AssignFile(f,ProgramPath+'Sinhron.cfg');
 if  not(FileExists(ProgramPath+'Sinhron.cfg')) then Rewrite(f)
  else Reset(f);

 with ProfilLine do
  begin
   NameConf:=EditProfName.Text;
   Dell—onfirmat:=RzCheckBoxDelConfirm.Checked;
   SaveLog:=RzCheckBoxSaveLog.Checked;
   DellBasket:=RzCheckBoxDellBasket.Checked;
   ID:=EditIdProf.Text;
   IdPC:=FmSinhron.PCIdent;
   if RadioButtonPCWork.Checked then PC:='work'
    else PC:='home';
   OperacDell:=RzCheckBoxOperacDel.Checked;
   LineExcept:=EditFileExcept.Text;
  end;

 if profnew then ProfilArray[Length(ProfilArray)-1]:=ProfilLine
  else  ProfilArray[NProf]:=ProfilLine;
 Rewrite(f);
 for i:=0 to Length(ProfilArray)-1 do write(f,ProfilArray[i]);
 CloseFile(f);
 FmSinhron.TestState(ProfilLine);
 FmSinhron.CreateListExcept(ProfilLine.LineExcept);
 FmSinhron.RzListBoxProfile.Items.Clear;
 for i:=0 to Length(ProfilArray)-1 do
 FmSinhron.RzListBoxProfile.Items.Add(ProfilArray[i].NameConf);
 ProfNew:=false;FmSinhron.ExistenceData;
 Close
end;

procedure TFmConfig.RzCheckBoxOperacDelClick(Sender: TObject);
begin
 if RzCheckBoxOperacDel.Checked then
  begin
     RzCheckBoxDellBasket.Enabled:=True;
     RzCheckBoxDelConfirm.Enabled:=True;
  end
   else
   begin
     RzCheckBoxDellBasket.Enabled:=False;
     RzCheckBoxDelConfirm.Enabled:=False;
   end;
end;

procedure TFmConfig.RzTrackBarNomFolderChange(Sender: TObject);
begin
 EditPathWork.Text:= ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathWork;
 EditPathHome.Text:=ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathHome;
 RzLabelNomer.Caption:=IntToStr(RzTrackBarNomFolder.Position);
end;

procedure TFmConfig.RzTrackBarNomFolderChanging(Sender: TObject;
  NewPos: Integer; var AllowChange: Boolean);
begin
 ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathWork:=EditPathWork.Text;
 ProfilLine.FolderDual[RzTrackBarNomFolder.Position].PathHome:=EditPathHome.Text;
end;

procedure TFmConfig.FormCreate(Sender: TObject);
begin
 profnew:=False;
end;

procedure TFmConfig.FormShow(Sender: TObject);
var i:Integer;
begin
 if not(profnew) then
  begin
    if Length(ProfilArray)>0 then
     begin
       ProfilLine:=FmSinhron.Task;//       ProfilArray[NProf];
       with ProfilLine do
        begin
         EditProfName.text:=NameConf;
         RzCheckBoxDelConfirm.Checked:=Dell—onfirmat;
         EditPathWork.Text:=FolderDual[1].PathWork;
         EditPathHome.Text:=FolderDual[1].Pathhome;
         RzCheckBoxSaveLog.Checked:=SaveLog;
         RzCheckBoxDellBasket.Checked:=DellBasket;
         EditIdProf.Text:=Id;
         EditFileExcept.Text:=LineExcept;
         if IdPC=FmSinhron.PCIdent then
          if PC='work' then RadioButtonPCWork.Checked:=true
           else RadioButtonPCHome.Checked:=true;
         RzCheckBoxOperacDel.Checked:=OperacDell;
        end;
     end
  end
   else
    begin
     if Length(ProfilArray)=0 then NProf:=0;// else NProf:=Length(ProfilArray)-1;
     EditProfName.text:='';
     RzCheckBoxDelConfirm.Checked:=True;
     EditPathWork.Text:='';
     EditPathHome.Text:='';
     EditIdProf.Text:=RandomId(8);
     RzCheckBoxSaveLog.Checked:=False;
     EditFileExcept.Text:='';
     RzCheckBoxDellBasket.Checked:=False;
     RadioButtonPCWork.Checked:=true;
     RzCheckBoxOperacDel.Checked:=false;
     for i:=1 to 10 do
      begin
       ProfilLine.FolderDual[i].PathWork:='';
       ProfilLine.FolderDual[i].PathHome:='';
      end;
    end;
    RzCheckBoxOperacDelClick(Sender);
    RzTrackBarNomFolder.Position:=1;
    RzTrackBarNomFolderChange(sender);
end;


 procedure TFmConfig.Button1Click(Sender: TObject);
begin
// EditProfName.Text:=RandomWord(33, 54, Random(12), 2);
 EditProfName.Text:=RandomId(8);
 end;

end.
