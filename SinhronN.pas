unit SinhronN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzBmpBtn, Vcl.StdCtrls, RzLstBox, DiskTools,
  RzEdit, Vcl.ExtCtrls, RzPanel, RzButton, RzRadChk, Vcl.Imaging.pngimage,SinhronConfig,
  RzBorder, RzLabel, Vcl.Buttons, Vcl.ComCtrls, RzPrgres, RzSpnEdt, RzStatus,Winapi.RichEdit,
  ShlObj,ComObj,System.Win.Registry,vcl.Themes,Vcl.Menus, RzShellDialogs;


type

  TTaskState = record
        name : string;
        value : byte;
     end;

  TFmSinhron = class(TForm)
    RzPanel2: TRzPanel;
    RzListBoxProfile: TRzListBox;
    RzBtnSinhronWorkHome: TRzBitBtn;
    rzpnlLeft: TRzPanel;
    RzLabel1: TRzLabel;
    RzBitBtnAddProfil: TRzBitBtn;
    RzBitBtnDelProfil: TRzBitBtn;
    RzBitBtnEditConfig: TRzBitBtn;
    RzBorder2: TRzBorder;
    RzPanel4: TRzPanel;
    RzPanelProgress: TRzPanel;
    RzLabelNameFile: TRzLabel;
    RzLabelNameFolder: TRzLabel;
    ProgressBarFile: TProgressBar;
    ProgressBarFolder: TProgressBar;
    Timer1: TTimer;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    RzBtnSinhronHomeWork: TRzBitBtn;
    RzLabel4: TRzLabel;
    RzVersionInfo1: TRzVersionInfo;
    RzLblVersion: TRzLabel;
    RzBtnStopCopy: TRzRapidFireButton;
    RzLabel5: TRzLabel;
    image1_orang: TImage;
    image2_orang: TImage;
    PopupMenuTools: TPopupMenu;
    RzRichEditEchoCom: TRzRichEdit;
    PopupMenuLogView: TPopupMenu;
    N1ViewLog: TMenuItem;
    RzBorder1: TRzBorder;
    RzRadioButtonHome: TRzRadioButton;
    RzRadioButtonWork: TRzRadioButton;
    RzLabel6: TRzLabel;
    C1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    RzSelectFolderDialog1: TRzSelectFolderDialog;
    SaveDialogFlsSnimok: TSaveDialog;
    OpenDialogSnimok: TOpenDialog;
    N4ViewSnimok: TMenuItem;
    OpenDialogConf: TOpenDialog;
    N4: TMenuItem;
    N5LoadPrifile: TMenuItem;
    N5: TMenuItem;
    cmdExampleLine: TMenuItem;
    TimerCmdBoot: TTimer;
    N6HelpProg: TMenuItem;
    N6: TMenuItem;
    N7CreateSnimokProfile: TMenuItem;
    Image2_blue: TImage;
    Image1_blue: TImage;
    crc321: TMenuItem;
    procedure RzBitBtnEditConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RzBitBtnAddProfilClick(Sender: TObject);
    procedure RzBitBtnDelProfilClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function  ExistenceData:Boolean;
    procedure FormActivate(Sender: TObject);
    procedure RzBtnSinhronWorkHomeClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CopyAllFilesofList(PathList:String;PathTarget:String;PathFolder:String);
    procedure RunWorkHome_Work(TaskData:TProfilLine);
    procedure RunWorkHome_Home(TaskData:TProfilLine);
    procedure RunHomeWork_Home(TaskData:TProfilLine);
    procedure RunHomeWork_Work(TaskData:TProfilLine);
    procedure TestState(TaskData:TProfilLine);
    function  CreateListOfFiles(var List:TFileList; PathFiles:String;PathShab:string):boolean;
    procedure RzBtnStopCopyClick(Sender: TObject);
    procedure RzRadioButtonWorkClick(Sender: TObject);
    procedure RzListBoxProfileClick(Sender: TObject);
    procedure RzRadioButtonHomeClick(Sender: TObject);
    procedure RzBtnSinhronHomeWorkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CreateListExcept(s:String);
    function  CreateListFiles(PathFolder:String;NameFiles:String):int64;
    function  ChekDiskSize(Disk:String;SizeFiles:int64):boolean;
    procedure CopyFileExProgress(const AFrom,ATo:String);
    procedure LoadStyle(Sender: TObject);
    procedure AddEchoText(Edit:TRzRichEdit;Str:String; Color: TColor;Log:boolean);
    procedure AddLogTmpToLogFile(Sender: TObject);
    procedure N1ViewLogClick(Sender: TObject);
    procedure PopupMenuLogViewPopup(Sender: TObject);
    procedure RunNoTransit(TaskData:TProfilLine;Napr:word);
    procedure CreateSnimok(crc:boolean);
    procedure CompareSnimok;
    function  CreateListFilesFolder(PathFolder:String;NameFiles:String;crc:boolean):int64;
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4ViewSnimokClick(Sender: TObject);
    procedure LoadProfile(PathProfil:string);
    procedure N5LoadPrifileClick(Sender: TObject);
    procedure RunParamStr(Sender:TObject);
    procedure cmdExampleLineClick(Sender: TObject);
    procedure TimerCmdBootTimer(Sender: TObject);
    procedure N6HelpProgClick(Sender: TObject);
    procedure N7CreateSnimokProfileClick(Sender: TObject);
    procedure SnimokOfProfile(Sender: TObject);
    procedure crc321Click(Sender: TObject);

  private
    FileCopier:IFileCopier;
    TaskBarList:ITaskBarList3;
    fProgress : integer;
    procedure setTaskProgress(newValue : integer);
    procedure setTaskStopViewProg;
  public
    StopCopy:boolean;
    Task:TProfilLine;
    PCIdent:String[25];
    ListExcept:TStringList;
    PathTask:string;
    RichEditLog:TRzRichEdit;
    FileNameConfig:string;
    property progress:integer read fProgress write setTaskProgress;
  end;

var
  FmSinhron: TFmSinhron;

implementation

{$R *.dfm}

uses FileCtrl, DialogFulCopy, ViewLog, ViewSnimok, ViewHelp;

procedure TFmSinhron.LoadStyle(Sender: TObject);
var i:Integer;
    s:string;
begin
 if Sender is TMenuItem then
  begin
   TStyleManager.TrySetStyle(TMenuItem(Sender).Caption,false);
   S:=TMenuItem(Sender).Caption;
    if (s='CopperDark') or (s='Golden Graphite') or (s='Ruby Graphite')
     or (s='Windows10 Dark') or (s='Auric') or (s='Metropolis UI Dark')
     or (s='TabletDark')  then
     begin
      RzRichEditEchoCom.StyleElements:=RzRichEditEchoCom.StyleElements+[seFont];
      Image2_blue.Hide;Image2_orang.Show;
      Image1_blue.Hide;Image1_orang.Show;
     end
      else
       begin
        RzRichEditEchoCom.StyleElements:=RzRichEditEchoCom.StyleElements-[seFont];
        Image2_blue.Show;Image2_orang.Hide;
        Image1_blue.Show;Image1_orang.Hide;
       end;
   for i:=0 to PopupMenuTools.Items.Items[0].Count-1 do
   if TStyleManager.ActiveStyle.Name=PopupMenuTools.Items.Items[0].Items[i].Caption then
    PopupMenuTools.Items.Items[0].Items[i].Checked:=True
   else  PopupMenuTools.Items.Items[0].Items[i].Checked:=false;
  end;
  RzRichEditEchoCom.Clear;
end;


procedure TFmSinhron.N1ViewLogClick(Sender: TObject);
begin
 if (FileExists(ProgramPath+'Task\'+FmSinhron.Task.Id+'\'+FmSinhron.Task.Id+'.log'))  then
  begin
   FmViewLog.NameFileLog:=ProgramPath+'Task\'+FmSinhron.Task.Id+'\'+FmSinhron.Task.Id+'.log';
   FmViewLog.Show;
  end
   else exit;
end;

procedure TFmSinhron.N2Click(Sender: TObject);
begin
 CreateSnimok(False);
end;

procedure TFmSinhron.crc321Click(Sender: TObject);
begin
 CreateSnimok(true);
end;


procedure TFmSinhron.N3Click(Sender: TObject);
begin
CompareSnimok;
end;

procedure TFmSinhron.N4ViewSnimokClick(Sender: TObject);
var rV,i:integer;
    S:TNameAtribFile;
    Shablon:string;
    f:file of TNameAtribFile;
    FmShowSnimok: TFmShowSnimok;

begin
// if not(Assigned(FmShowSnimok)) then
 FmShowSnimok:=TFmShowSnimok.Create(Application);
  if OpenDialogSnimok.Execute then
   begin
    assignfile(f,OpenDialogSnimok.FileName);
    Reset(f);
    if FileSize(f)<=1 then begin CloseFile(f);exit end;
    rV:=GetDeviceCaps(GetDC(GetDesktopWindow), VERTRES);
    FmShowSnimok.Height:=rV-140;
    FmShowSnimok.top:=FmShowSnimok.top-15;
    FmShowSnimok.Caption:='Список файлов снимка: '+
                                     ExtractFileName(OpenDialogSnimok.FileName);
    FmShowSnimok.Show;
    with FmShowSnimok do
     begin
      StringGrid1.RowCount:=FileSize(f);
      StringGrid1.Cells[0,0]:='№';
      StringGrid1.Cells[1,0]:='Имя файла';
      StringGrid1.Cells[2,0]:='Размер';
      StringGrid1.Cells[3,0]:='Дата';
      StringGrid1.Cells[4,0]:='Время';
      StringGrid1.Cells[5,0]:='crc32';
      if not(eof(f)) then read(f,s);
       RzLabelFolderName.Caption:=MinimizeName(s.FName,RzLabelFolderName.Canvas,
        RzLabelFolderName.Width);
        Shablon:=IncludeTrailingBackslash(s.FName);
        for i:=1 to FileSize(f)-1 do
         begin
           read(f,s);
           StringGrid1.Cells[0,i]:=IntToStr(i);
           Delete(s.FName,1,Length(Shablon));
           StringGrid1.Cells[1,i]:=s.FName;
           StringGrid1.Cells[2,i]:=IntToStr(s.SizeFile);
           StringGrid1.Cells[3,i]:=DateToStr(s.FDataTime);
           StringGrid1.Cells[4,i]:=TimeToStr(s.FDataTime);
           StringGrid1.Cells[5,i]:=IntToStr(s.crc32);
         end;
     end;
     CloseFile(f);
  end;
end;

procedure TFmSinhron.N5LoadPrifileClick(Sender: TObject);
begin
  if OpenDialogConf.Execute then LoadProfile(OpenDialogConf.FileName);
end;

procedure TFmSinhron.FormActivate(Sender: TObject);
begin
 RzListBoxProfile.Focused;
 if Length(ProfilArray)>0 then RzListBoxProfile.ItemIndex:=FmConfig.NProf;
 if RzListBoxProfile.ItemIndex>=0 then Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 RzListBoxProfileClick(sender);
 TestState(Task);
end;

procedure TFmSinhron.FormClose(Sender: TObject; var Action: TCloseAction);
var RegData:TRegistry;
begin
 try
  RegData:=TRegistry.Create;
  RegData.RootKey:=HKEY_CURRENT_USER;
   if RegData.OpenKey('\SOFTWARE\UrlWest\Sinhron',true) then
    RegData.WriteString('SinhronStyle',TStyleManager.ActiveStyle.Name);
    RegData.WriteInteger('SinhronX',FmSinhron.Left);
    RegData.WriteInteger('SinhronY',FmSinhron.Top);
    finally
    RegData.Free;
 end;
  if ListExcept<>nil then ListExcept.Free;
end;

procedure TFmSinhron.FormCreate(Sender: TObject);
var i:Integer;
    S:String;
    m:TmenuItem;
    RegData:TRegistry;
    pn:TPoint;
    tbList:ITaskBarList;
    Sort:TStringList;
begin
 // Application.MainFormOnTaskBar := True;
 if (ParamCount>1) and (ParamCount<4) then halt(0);

 pn.x:=-1;StopCopy:=false;Screen.Cursor := crDefault;
 TbList:=CreateComObject(CLSID_TaskBarList) as ITaskBarList;
 TbList.QueryInterface(IID_ITaskBarList3,taskBarList);

 try
  RegData:=TRegistry.Create;
  RegData.RootKey:=HKEY_CURRENT_USER;
  RegData.Access:=KEY_READ;
  if RegData.OpenKey('\SOFTWARE\UrlWest\Sinhron',false) then
   begin
    S:=RegData.ReadString('SinhronStyle');
    if (s='CopperDark') or (s='Golden Graphite') or (s='Ruby Graphite')
     or (s='Windows10 Dark') or (s='Auric') or (s='Metropolis UI Dark')
     or (s='TabletDark')  then
     begin
      RzRichEditEchoCom.StyleElements:=RzRichEditEchoCom.StyleElements+[seFont];
      Image2_blue.Hide;Image2_orang.Show;
      Image1_blue.Hide;Image1_orang.Show;
     end
      else
       begin
        RzRichEditEchoCom.StyleElements:=RzRichEditEchoCom.StyleElements-[seFont];
        Image2_blue.Show;Image2_orang.Hide;
        Image1_blue.Show;Image1_orang.Hide;
       end;
    if S<>'' then TStyleManager.TrySetStyle(S,false);
     try
      pn.x:=RegData.ReadInteger('SinhronX');
      pn.Y:=RegData.ReadInteger('SinhronY');
      except
       pn.x:=-1;
     end;
    end;
    finally
    RegData.Free;
 end;

 if pn.x>0 then begin FmSinhron.Left:=pn.x;FmSinhron.Top:=pn.y; end;

 with FormatSettings do
  begin
    LongMonthNames[1]  := 'Января';
    LongMonthNames[2]  := 'Февраля';
    LongMonthNames[3]  := 'Марта';
    LongMonthNames[4]  := 'Апреля';
    LongMonthNames[5]  := 'Мая';
    LongMonthNames[6]  := 'Июня';
    LongMonthNames[7]  := 'Июля';
    LongMonthNames[8]  := 'Августа';
    LongMonthNames[9]  := 'Сентября';
    LongMonthNames[10]  := 'Октября';
    LongMonthNames[11]  := 'Ноября';
    LongMonthNames[12]  := 'Декабря';
  end;
 ListExcept:=TStringList.Create;ListExcept.Clear;
 FileCopier := TFileCopier.Create;
 FileCopier.ProgressBar:=ProgressBarFile;
 FileCopier.MemoResult:=RzRichEditEchoCom;

 AddEchoText(RzRichEditEchoCom,'Старт программы. Сейчас '+
 FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon,Task.SaveLog);
 RzLblVersion.Caption:='v.'+RzVersionInfo1.FileVersion;
 PCIdent:=GetHDSerNo; RichEditLog:=nil;

 if ParamCount=1 then
  begin
   ProgramPath:=IncludeTrailingBackslash(ParamStr(1));
   FileNameConfig:=IncludeTrailingBackslash(ParamStr(1))+'Sinhron.cfg';
  end
   else
    begin
     ProgramPath:=ExtractFilePath(ParamStr(0));
     FileNameConfig:=ProgramPath+'Sinhron.cfg';
    end;

 Sort:=TStringList.Create;Sort.Sorted:=True;
 for i:= 0 to Length(TStyleManager.StyleNames)-1 do
   Sort.Add(TStyleManager.StyleNames[i]);
 for i := 0 to Sort.Count-1 do
  begin
    m:=TmenuItem.Create(FmSinhron);
    m.Caption:=Sort[i];
    m.OnClick:=LoadStyle;
    if TStyleManager.ActiveStyle.Name=Sort[i] then m.Checked:=True;
    PopupMenuTools.Items.Items[0].Add(m);
  end;
  FreeAndNil(Sort);

 if (ParamCount<2) and (FileExists(FileNameConfig)) then LoadProfile(FileNameConfig);
end;


procedure TFmSinhron.SetTaskProgress(newValue: Integer);
begin
 if Assigned(TaskBarList) then
    TaskBarList.SetProgressValue(Application.handle,newValue,ProgressBarFolder.Max);
end;

procedure TFmSinhron.setTaskStopViewProg;
begin
 if Assigned(TaskBarList) then
   TaskBarList.SetProgressState(Application.handle,TBPF_NOPROGRESS);
end;


procedure TFmSinhron.CreateListExcept(s:String);
var tmp:string;
begin
 ListExcept.Clear;
 while Length(S)<>0 do
  begin
    if Pos(';',S)<>0 then
      begin
       tmp:=copy(s,1,Pos(';',S)-1);
       delete(s,1,Pos(';',S));
       if pos('*',tmp)<>0 then
        begin
         ListExcept.Add(copy(tmp,pos('*',tmp)-1,Length(tmp)-pos('*',tmp)+1));
        end
       else ListExcept.Add(tmp)
      end
    else
    begin ListExcept.Add(s);s:='';end;
  end;
end;


procedure TFmSinhron.FormShow(Sender: TObject);
begin
 TestState(Task);
end;


procedure TFmSinhron.LoadProfile(PathProfil:string);
var f:file of TProfilLine;
    i:Integer;
begin
  ProgramPath:=ExtractFilePath(PathProfil);
  SetLength(ProfilArray,0);
  try
   AssignFile(f,PathProfil);Reset(f);
   if FileSize(f)>0 then
    begin
     FileNameConfig:=PathProfil;
     SetLength(ProfilArray,FileSize(f));i:=0;
     RzListBoxProfile.Items.Clear;
     while not(Eof(f)) do
      begin
       read(f,ProfilArray[i]);
       RzListBoxProfile.Items.Add(ProfilArray[i].NameConf);
       inc(i)
      end;
     Task:=ProfilArray[0];
     FmSinhron.ExistenceData;
    end;
   finally
    CloseFile(f);
  end
end;


procedure TFmSinhron.PopupMenuLogViewPopup(Sender: TObject);
begin
 if (FileExists(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log')) then
  PopupMenuLogView.Items.Items[0].Enabled:=True
   else PopupMenuLogView.Items.Items[0].Enabled:=false
end;

procedure TFmSinhron.RzBitBtnAddProfilClick(Sender: TObject);
begin
 SetLength(ProfilArray,Length(ProfilArray)+1);
 FmConfig.profnew:=true;FmConfig.NProf:=Length(ProfilArray)-1;
 FmConfig.Show
end;

procedure TFmSinhron.RzBitBtnDelProfilClick(Sender: TObject);
var i:Integer;
    f:file of TProfilLine;
begin
 if RzListBoxProfile.ItemIndex<0 then exit;

 if DirectoryExists(ProgramPath+'\Task\'+ProfilArray[RzListBoxProfile.ItemIndex].Id) then
  begin
    if MessageBox(Handle, 'Удалить задание и все связанные с ним файлы?',
      'Предупреждение', MB_YESNO + MB_ICONWARNING)=mrNo then Exit
       else DelDir(ProgramPath+'\Task\'+ProfilArray[RzListBoxProfile.ItemIndex].Id,false,true)
  end;

 for i:=RzListBoxProfile.ItemIndex to Length(ProfilArray)-1 do
    ProfilArray[i]:=ProfilArray[i+1];
 SetLength(ProfilArray, Length(ProfilArray)-1);
 RzListBoxProfile.Items.Clear;

 AssignFile(f,FileNameConfig);Rewrite(f);
 for i:=0 to Length(ProfilArray)-1 do
  begin
   RzListBoxProfile.Items.Add(ProfilArray[i].NameConf);
   write(f,ProfilArray[i]);
  end;
 CloseFile(f);
 ExistenceData;
end;

procedure TFmSinhron.RzBitBtnEditConfigClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;
 FmConfig.NProf:=RzListBoxProfile.ItemIndex;
 FmConfig.Show;
end;

function TFmSinhron.CreateListFiles(PathFolder:String;NameFiles:String):int64;
var Spisok:TStringList;
    I,J:Integer;
    tmp:TNameAtribFile;
    f:file of TNameAtribFile;
    Filter,skip:boolean;
begin
 Result:=0;
 Spisok:=TStringList.Create;
 if Task.CompareContent then i:=1 else i:=0;
 // 0 все вложенные папки и файлы 1 все вложенные папки 2 файлы в указанной папке
 ScanDisk(PathFolder,'*.*',Spisok,0,i);

 AssignFile(f,NameFiles); Rewrite(f);
 with tmp do
  begin
   FName:=PathFolder;
   FNameTmp:='';
   Nature:=0;
   FDataTime:=Time;
   SizeFile:=0;
   crc32:=0;
  end;
 Write(f,tmp);

 if (ListExcept<>nil) then
  if (ListExcept.Count>0) then Filter:=true else Filter:=false;
 For i:=0 to Spisok.Count-1 do
  begin
   skip:=false;
   with tmp do
    begin
     if Filter then
     for j:=0 to ListExcept.Count-1 do
     if pos(copy(ListExcept[j],2,Length(ListExcept[j])-1),Spisok.Strings[i])<>0 then
      begin
       skip:=True;break
      end;
     if skip then continue;
     if Length(Spisok.Strings[i])>255 then
      begin
       AddEchoText(RzRichEditEchoCom,'Ошибка! Уменьшите длину пути\имени файла: '+Spisok.Strings[i],clRed,Task.SaveLog);
       Continue;
      end;
     FName:=Spisok.Strings[i];
     FNameTmp:=RandomNameFile('',12)+ExtractFileExt(Spisok.Strings[i]);
     Nature:=TAtrib(Spisok.Objects[i]).Nature;
     FDataTime:=TAtrib(Spisok.Objects[i]).FileDataTime;
     SizeFile:=TAtrib(Spisok.Objects[i]).SizeFile;
     crc32:=TAtrib(Spisok.Objects[i]).crc32;
     Result:=Result+SizeFile;
    end;
   Write(f,tmp);
  end;
  CloseFile(f);
  for i:=0 to  Spisok.Count-1 do
  if Spisok.Objects[i]<>nil then TAtrib(Spisok.Objects[i]).Free;
  Spisok.Free;
end;


function TFmSinhron.CreateListFilesFolder(PathFolder:String;NameFiles:String;crc:boolean):int64;
var Spisok:TStringList;
    I:Integer;
    tmp:TNameAtribFile;
    f:file of TNameAtribFile;
begin
 Result:=0;
 Spisok:=TStringList.Create;
 // 0 все вложенные папки и файлы 1 все вложенные папки 2 файлы в указанной папке
 if crc then i:=1 else i:=0;
 ScanDisk(PathFolder,'*.*',Spisok,0,i);
 AssignFile(f,NameFiles); Rewrite(f);
 with tmp do
  begin
   FName:=PathFolder;
   FNameTmp:='';
   Nature:=0;
   FDataTime:=Time;
   crc32:=0;
   SizeFile:=0;
  end;
 Write(f,tmp); //запись с именем корневой папки
 For i:=0 to Spisok.Count-1 do
  begin
   with tmp do
    begin
     if Length(Spisok.Strings[i])>255 then
      begin
       AddEchoText(RzRichEditEchoCom,'Ошибка! Уменьшите длину пути\имени файла: '+Spisok.Strings[i],clRed,Task.SaveLog);
       Continue;
      end;
     FName:=Spisok.Strings[i];
     FNameTmp:='';
//     Delete(FName,1,Length(PathFolder)+1);
     Nature:=TAtrib(Spisok.Objects[i]).Nature;
     FDataTime:=TAtrib(Spisok.Objects[i]).FileDataTime;
     SizeFile:=TAtrib(Spisok.Objects[i]).SizeFile;
     crc32:=TAtrib(Spisok.Objects[i]).crc32;
     Result:=Result+SizeFile;
    end;
   Write(f,tmp);
  end;
  CloseFile(f);
  for i:=0 to  Spisok.Count-1 do
  if Spisok.Objects[i]<>nil then TAtrib(Spisok.Objects[i]).Free;
  Spisok.Free;
end;


procedure TFmSinhron.CopyAllFilesOfList(PathList:String;PathTarget:String;PathFolder:String);
var f:file of TNameAtribFile;
    NameAtribFile:TNameAtribFile;
    FSource,FDest:string;
begin
  AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+PathFolder,clGreen,Task.SaveLog);
  RzLabelNameFolder.Caption:=MinimizeName(PathFolder,RzLabelNameFolder.Canvas,RzLabelNameFolder.Width);
  AssignFile(f,PathList);Reset(f);
  ProgressBarFolder.Max:=FileSize(f)-1;
  ProgressBarFolder.Position:=0;
  if not(Eof(f)) then read(f,NameAtribFile);//пропускаем первую запись
   while not(Eof(f)) do
    begin
     ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
     SetTaskProgress(ProgressBarFolder.Position);
     read(f,NameAtribFile);
     if NameAtribFile.Nature=1 then
      begin
       FSource:=NameAtribFile.FName;FDest:=NameAtribFile.FNameTmp;
       FDest:=PathTarget+FDest;
       if StopCopy=True then break;
       if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
       RzLabelNameFile.Caption:=MinimizeName(FSource,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
       CopyFileExProgress(FSource,FDest);
       ProgressBarFile.Position:=ProgressBarFile.Max;
      end
    end;
   CloseFile(f);
   AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+PathFolder+' завершено',clGreen,Task.SaveLog);
end;


function TFmSinhron.CreateListOfFiles(var List:TFileList;PathFiles:String;PathShab:string):boolean;
var f:file of TNameAtribFile;
    AtribFile:TAtrib;
    tmp:TNameAtribFile;
begin
  AssignFile(f,PathFiles);Reset(f);
  if not EOF(f) then read(f,tmp);//пропускаем первую запись
  if (PathShab<>'') and (Tmp.FName<>PathShab) then
   begin
    Result:=false;CloseFile(f);
    MessageDlg('Файл снимка не соответствует указанной папке в текущем профиле.'+#13+#10+
    'Снимок: '+PathFiles+#13+#10+'Папка: '+PathShab+#13+#10+
    'Рекомендация. В редакторе профилей выполните "Очистить файлы профиля" и выполните синхронизацию заново.',mtError, [mbOK], 0);
    exit
   end;
   while not EOF(f) do
    begin
      read(f,tmp); AtribFile:=TAtrib.Create;
      with tmp do
       begin
        AtribFile.FNameTmp:=FNameTmp;
        AtribFile.FileDataTime:=FDataTime;
        AtribFile.Nature:=Nature;
        AtribFile.Action:='';
        AtribFile.SizeFile:=SizeFile;
        AtribFile.crc32:=crc32;
        if PathShab<>'' then Delete(FName,1,Length(PathShab));
        List.AddObject(FName,AtribFile);
       end;
    end;
  CloseFile(f);Result:=true;
end;

function TFmSinhron.ChekDiskSize(Disk:String;SizeFiles:int64):boolean;
var i:integer;
begin
 if Disk=' ' then i:=0 else i:=Ord(Disk[1])-64;
 if SizeFiles<=DiskFree(i) then Result:=True  else Result:=False;
end;


procedure TFmSinhron.RunWorkHome_Home(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    HomeList,WorkList:TFileList;
    FSource,FDest:string;
    Res:Boolean;
    MRes:TModalResult;
    SizeFiles:int64;
begin
 //создание списка============================================================
 SizeFiles:=0;StopCopy:=false;
 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+
  ']  Начало операции: альфа==>бета. Тип операции: Компьютер бета',clBlue,Task.SaveLog);
 for i:=1 to 10 do
 with TaskData.FolderDual[i] do
  if PathHome<>'' then
    begin
      if DirectoryExists(PathHome) then
        begin
          Screen.Cursor:= crHourGlass;
          AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathHome,clTeal,Task.SaveLog);
          CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
          Screen.Cursor:= crDefault;
        end
      else
        begin
         ForceDirectories(PathHome);
         SizeFiles:=CreateListFiles(PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
        end
     end
  else
   begin
    if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat') then
    try
     DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
     except
    end;
     if TaskData.FolderDual[i].PathWork<>'' then
       begin
         with CreateMessageDialog(
          'В профиле, в группе папок N'+IntTostr(i)+' отсутствует путь к синхронной папке компьютера бета.'+#13+#10+
          'Папка: '+TaskData.FolderDual[i].PathHome+#13+#10+
          'Выберите "Путь" и добавьте в профиле недостающие данные и запустите повторно операцию по синхронизации.'+#13+#10+
          'Выберите "Удалить" и удалите эти файлы отменив синхронизацию этих папок.',mtWarning, [mbYes,mbNo]) do
         try
          Caption := 'Внимание';
          (FindComponent('Yes') as TButton).Caption := 'Путь';
          (FindComponent('No') as TButton).Caption := 'Удалить';
           MRes:=ShowModal;
          finally
           Free
          end;
         if MRes=mrYes then
          begin
            AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: альфа=>бета. Тип операции: '+
            'Компьютер бета.',clBlue,Task.SaveLog);
            exit;
          end;
       end;
   end;


  for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
    if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat'))) or
       (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat'))) then Continue;

    WorkList:=TFileList.Create;
    if not(CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
     begin WorkList.Free; exit end;

    HomeList:=TFileList.Create;
    if not(CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
     begin HomeList.Free; exit end;

    //сравнение списков рабочий-->домашний
    for j:=0 to WorkList.Count-1 do
     begin
      I_Poisk:=HomeList.IndexOf(WorkList[j]);
       if I_Poisk>=0 then
         if TAtrib(WorkList.Objects[j]).Nature=1 then
           begin
             if TAtrib(WorkList.Objects[j]).FileDataTime<=TAtrib(HomeList.Objects[I_Poisk]).FileDataTime then
              begin
               TAtrib(WorkList.Objects[j]).Action:='skip';
               TAtrib(HomeList.Objects[I_Poisk]).Free;
               HomeList.Delete(I_Poisk);
              end
             else
              begin
               TAtrib(WorkList.Objects[j]).Action:='copy';
               if task.LogExt then
               AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
               TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple,Task.SaveLog);
               TAtrib(HomeList.Objects[I_Poisk]).Free;
               HomeList.Delete(I_Poisk);
              end
           end
          else
           begin
            TAtrib(WorkList.Objects[j]).Action:='skip';
            TAtrib(HomeList.Objects[I_Poisk]).Free;
            HomeList.Delete(I_Poisk);
           end
       else
        begin
         if TAtrib(WorkList.Objects[j]).Nature=1 then TAtrib(WorkList.Objects[j]).action:='copy';
         if task.LogExt then
         AddEchoText(RzRichEditEchoCom,'Файл добавлен: '+TaskData.FolderDual[i].PathWork+WorkList[j],clGreen,Task.Savelog);
        end;
     end;

    if HomeList.Count>0 then
     for j:=0 to HomeList.Count-1 do
      begin
        if TaskData.OperacDell then TAtrib(HomeList.Objects[j]).action:='del'
          else TAtrib(HomeList.Objects[j]).action:='skip';
       WorkList.AddObject(HomeList[j],TAtrib(HomeList.Objects[j]));
       HomeList.Objects[j]:=nil;
      end;
     FreeAndNil(HomeList);

    //подсчет необходимого места
    SizeFiles:=0;
    for j:=0 to WorkList.Count-1 do
     begin
      if TAtrib(WorkList.Objects[j]).Action='copy' then
      SizeFiles:=SizeFiles+TAtrib(WorkList.Objects[j]).SizeFile
     end;

     if not(ChekDiskSize(Char(TaskData.FolderDual[i].PathWork[1]),SizeFiles)) then
      begin
       MessageDlg('На диске не достаточно свободного места для выполнения операций',
       mtError, [mbOK], 0);
       RzPanelProgress.Hide;
       FreeAndNil(WorkList);
       exit
      end;

     if SizeFiles>0 then
      begin
       RzPanelProgress.Show;
       AddEchoText(RzRichEditEchoCom,'Копирование файлов в '+TaskData.FolderDual[i].PathHome,clGreen,Task.SaveLog);
       ProgressBarFolder.Max:=WorkList.Count;
       ProgressBarFolder.Position:=0;
      end;

    if TaskData.DellСonfirmat then  MRes:=mrYes else MRes:=mrYesToAll;

    for j:=0 to WorkList.Count-1 do
     begin
      if StopCopy then
       begin
        FreeAndNil(HomeList);FreeAndNil(WorkList);
        break;
       end;
      ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
      SetTaskProgress(ProgressBarFolder.Position);
      FSource:=PathTask+'\WFiles\Folder_'+IntToStr(i)+'\'+TAtrib(WorkList.Objects[j]).FNameTmp;
      FDest:=TaskData.FolderDual[i].PathHome+WorkList[j];
      if TAtrib(WorkList.Objects[j]).Action='copy' then
       begin
        RzLabelNameFile.Caption:=MinimizeName(FDest,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
        if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
        if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
         else RzRichEditEchoCom.Lines.Add('Отсутствует файл: '+FSource);
       end;
      if TAtrib(WorkList.Objects[j]).Action='del' then
       begin
        RzLabelNameFile.Caption:=MinimizeName(FDest,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
        if (MRes=mrYes) or (MRes=mrNo) then
        with CreateMessageDialog('Удалить: '+FDest, mtWarning, [mbYes,mbYesToAll,mbNo,mbNoToAll]) do
          try
            Caption := 'Внимание';
            (FindComponent('Yes') as TButton).Caption := 'Да';
            (FindComponent('No') as TButton).Caption := 'Нет';
            (FindComponent('YesToAll') as TButton).Caption := 'Да для всех';
            (FindComponent('NoToAll') as TButton).Caption := 'Нет для всех';
             MRes:=ShowModal;
           finally
           Free
          end;
         if (MRes<>mrNo) and (MRes<>mrNoToAll) then
          begin
            if TAtrib(WorkList.Objects[j]).Nature=1 then
              begin
               if FileExists(FDest) then
                begin
                 AddEchoText(RzRichEditEchoCom,'Удаление файла: '+FDest,clRed,Task.SaveLog);
                 DelFiles(FDest,TaskData.DellBasket)
                end
              end
            else
              begin
               if pos('..',FDest)<>0 then delete(FDest,pos('..',FDest)-1,3);
               if  DirectoryExists(FDest) then
                begin
                 AddEchoText(RzRichEditEchoCom,'Удаление папки: '+FDest,clRed,Task.SaveLog);
                 DelDir(FDest,TaskData.DellBasket,True)
                end
              end
          end
       end;
     end;
     WorkList.Free;
     if SizeFiles>0 then AddEchoText(RzRichEditEchoCom,'Копирование файлов завершено',clGreen,Task.Savelog);
     RzLabelNameFile.Caption:='';
     ProgressBarFile.Position:=ProgressBarFile.Max;
     Screen.Cursor:= crHourGlass;
     AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathHome,clTeal,Task.SaveLog);
     CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
     Screen.Cursor:= crDefault;
   end;
 if (DirectoryExists(PathTask+'\WFiles')) then DelDir(PathTask+'\WFiles',false,true);
 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: альфа==>бета. Тип операции: Компьютер бета',clBlue,Task.SaveLog);
 Timer1.Enabled:=True;
end;


procedure TFmSinhron.RunWorkHome_Work(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    All:Boolean;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    FSource,FDest:string;
    ShCopy:TModalResult;
    SizeFiles:int64;
begin
 All:=False;SizeFiles:=0;

//проверка существования папок в профиле
 for i:=1 to 10 do
  if TaskData.FolderDual[i].PathWork<>'' then
   begin
     if not(DirectoryExists(TaskData.FolderDual[i].PathWork)) then
      begin
       MessageDlg('В профиле ошибочный путь:'+#10+#13+
       TaskData.FolderDual[i].PathWork,mtError,[mbOK],0);
       exit;
      end;
   end;

 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+
   ']  Начало операции: альфа==>бета. Тип операции: Компьютер альфа',clBlue,Task.SaveLog);
 if (DirectoryExists(PathTask+'\WFiles')) then
      if DelDir(PathTask+'\WFiles',false,true)=false then exit;
 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);

 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
    if PathWork<>'' then
      begin
       if DirectoryExists(PathWork) then
        begin
         //если запуск первый раз. инфы о домашнем нет
         if not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat')) then
          begin
           if All=false then
            begin
             FmDialogFulCopy.NameFolder:=PathWork;
             ShCopy:=FmDialogFulCopy.ShowModal;
             if ShCopy=mrAbort then exit;
             All:=FmDialogFulCopy.All;
            end;
             if ShCopy=mrOk then
              begin
               if not(DirectoryExists(PathTask+'\WFiles')) then
                  ForceDirectories(PathTask+'\WFiles');
               Screen.Cursor:= crHourGlass;
               AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
               SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
               Screen.Cursor:= crDefault;
                if not(ChekDiskSize(' ',SizeFiles)) then
                  begin
                    MessageDlg('На диске не достаточно свободного места для выполнения операций',
                     mtError, [mbOK], 0);RzPanelProgress.Hide;
                     exit
                  end;
               RzPanelProgress.Show;
               PathArhFlsTrgFld:=PathTask+'\WFiles\Folder_'+IntToStr(i)+'\';
               CopyAllFilesofList(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',PathArhFlsTrgFld,TaskData.FolderDual[i].PathWork);
               if StopCopy=True then
                begin
                 Timer1.Enabled:=true;
                 Exit;
                end;
              end
              else
              begin
               Screen.Cursor:= crHourGlass;
               AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
               SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,
                                       PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
               Screen.Cursor:= crDefault;
              end
          end
         else
           begin
            Screen.Cursor:= crHourGlass;
            AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
            SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,
                                       PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
            Screen.Cursor:= crDefault;
           end
        end
      end
    else
     if FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat') then
      try
       DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
        except
        end;
    if (PathHome='') and (FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat')) then
      try
       DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
      except
      end;
   end;
   //==========================================================================

 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
    if not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat')) then Continue;

    //создание списка рабочий
    WorkList:=TFileList.Create;
    if not(CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
     begin WorkList.Free; exit end;
    //создание списка домашний
    HomeList:=TFileList.Create;
    if not(CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
     begin HomeList.Free; exit end;
    //сравнение списков рабочий-->домашний
    for j:=0 to WorkList.Count-1 do
     begin
      I_Poisk:=HomeList.IndexOf(WorkList[j]);
       if I_Poisk>=0 then
         if TAtrib(WorkList.Objects[j]).Nature=1 then
           begin
             if TAtrib(WorkList.Objects[j]).FileDataTime<=TAtrib(HomeList.Objects[I_Poisk]).FileDataTime then
               begin
                 TAtrib(WorkList.Objects[j]).Action:='skip';
                 TAtrib(HomeList.Objects[I_Poisk]).Free;
                 HomeList.Delete(I_Poisk);
               end
             else
             begin
               if Task.CompareContent then
                 if (TAtrib(WorkList.Objects[j]).crc32<>TAtrib(HomeList.Objects[I_Poisk]).crc32) or
                  ((TAtrib(WorkList.Objects[j]).crc32=0) and (TAtrib(HomeList.Objects[I_Poisk]).crc32=0))
                    then
                   begin
                     TAtrib(WorkList.Objects[j]).Action:='copy';
                     if task.LogExt then
                     AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
                     TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple,Task.SaveLog);
                   end
                 else  TAtrib(WorkList.Objects[j]).Action:='skip'
               else
                begin
                 TAtrib(WorkList.Objects[j]).Action:='copy';
                 if task.LogExt then
                 AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
                 TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple,Task.SaveLog);
                end;
                 TAtrib(HomeList.Objects[I_Poisk]).Free;
                 HomeList.Delete(I_Poisk);
             end
           end
         else
           begin
            TAtrib(WorkList.Objects[j]).Action:='skip';
            TAtrib(HomeList.Objects[I_Poisk]).Free;
            HomeList.Delete(I_Poisk);
           end
       else
        begin
         if TAtrib(WorkList.Objects[j]).Nature=1 then TAtrib(WorkList.Objects[j]).action:='copy';
         if task.LogExt then
         AddEchoText(RzRichEditEchoCom,'Файл добавлен: '+TaskData.FolderDual[i].PathWork+WorkList[j],clGreen,Task.Savelog);
        end;
     end;

    //если на рабочем отсутсвуют
    if HomeList.Count>0 then
     begin
      if not(DirectoryExists(PathTask+'\WFiles')) then ForceDirectories(PathTask+'\WFiles');
      for j:=0 to HomeList.Count-1 do
        begin
         if TaskData.OperacDell then TAtrib(HomeList.Objects[j]).action:='del'
          else TAtrib(HomeList.Objects[j]).action:='skip';
         WorkList.AddObject(HomeList[j],TAtrib(HomeList.Objects[j]));
         HomeList.Objects[j]:=nil;
        end;
     end;
     FreeAndNil(HomeList);

     //подсчет необходимого места
     SizeFiles:=0;
     for j:=0 to WorkList.Count-1 do
      begin
       if TAtrib(WorkList.Objects[j]).Action='copy' then
       SizeFiles:=SizeFiles+TAtrib(WorkList.Objects[j]).SizeFile
      end;

     if not(ChekDiskSize(' ',SizeFiles)) then
      begin
       MessageDlg('На диске не достаточно свободного места для выполнения операций',
       mtError, [mbOK], 0);
       RzPanelProgress.Hide;
       FreeAndNil(WorkList);
       exit
       end;

    //копирование или удаление файлов по признаку Action
     PathArhFlsTrgFld:=PathTask+'\WFiles\Folder_'+IntToStr(i)+'\';
     if SizeFiles>0 then
      begin
       RzPanelProgress.Show;
       AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+TaskData.FolderDual[i].PathWork,0,Task.SaveLog);
       ProgressBarFolder.Max:=WorkList.Count;
       ProgressBarFolder.Position:=0;
      end;

      for j:=0 to WorkList.Count-1 do
       begin
        if StopCopy then
         begin
          FreeAndNil(HomeList);FreeAndNil(WorkList);
          break;
         end;
        ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
        SetTaskProgress(ProgressBarFolder.Position);
        FDest:=PathArhFlsTrgFld+TAtrib(WorkList.Objects[j]).FNameTmp;
        FSource:=TaskData.FolderDual[i].PathWork+WorkList[j];
        if TAtrib(WorkList.Objects[j]).Action='copy' then
         begin
          RzLabelNameFile.Caption:=MinimizeName(FSource,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
          if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
          if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
           else AddEchoText(RzRichEditEchoCom,'Отсутствует файл: '+FSource,clRed,Task.SaveLog);
         end;
       end;
       WorkList.free;
       if SizeFiles>0 then AddEchoText(RzRichEditEchoCom,'Копирование файлов завершено',clGreen,Task.Savelog);
       RzLabelNameFile.Caption:='';
       ProgressBarFile.Position:=ProgressBarFile.Max;
   end;
  AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: альфа==>бета. Тип операции: Компьютер альфа',clBlue,Task.SaveLog);
  Timer1.Enabled:=True;
end;


procedure TFmSinhron.RunHomeWork_Work(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    HomeList,WorkList:TFileList;
    PathFldFrom,FDest,FSource:string;
    MRes:TModalResult;
    SizeFiles:int64;

begin
  //создание списка============================================================
  SizeFiles:=0;
  AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Начало операции: бета=>альфа. Тип операции: Компьютер альфа',clBlue,Task.SaveLog);
   for i:=1 to 10 do
   with TaskData.FolderDual[i] do
    if PathWork<>'' then
      begin
       if DirectoryExists(PathWork) then
         begin
          Screen.Cursor:= crHourGlass;
          AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ папки: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
          SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
          Screen.Cursor:= crDefault;
         end
          else
          begin
           ForceDirectories(PathWork);
           SizeFiles:=CreateListFiles(PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
          end;
       end
    else
     begin
     if FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat') then
      try
       DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
       except
       end;
      if TaskData.FolderDual[i].PathHome<>'' then
       begin
         with CreateMessageDialog(
          'В профиле, в группе папок N'+IntTostr(i)+' отсутствует путь к синхронной папке компьютера альфа.'+#13+#10+
          'Папка: '+TaskData.FolderDual[i].PathHome+#13+#10+
          'Выберите "Путь" и добавьте в профиле недостающие данные и запустите повторно операцию по синхронизации.'+#13+#10+
          'Выберите "Удалить" и удалите эти файлы отменив синхронизацию этих папок.',mtWarning, [mbYes,mbNo]) do
         try
          Caption := 'Внимание';
          (FindComponent('Yes') as TButton).Caption := 'Путь';
          (FindComponent('No') as TButton).Caption := 'Удалить';
           MRes:=ShowModal;
          finally
           Free
          end;
         if MRes=mrYes then
          begin
            AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: бета=>альфа. Тип операции: '+
            'Компьютер альфа',clBlue,Task.SaveLog);
            exit;
          end;
       end;
     end;
  //==========================================================================

    for i:=1 to 10 do
    with TaskData.FolderDual[i] do
     begin
      if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat'))) or
         (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat'))) then Continue;

      WorkList:=TFileList.Create;
      if not(CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
       begin WorkList.Free; exit; end;

      HomeList:=TFileList.Create;
      if not(CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
       begin HomeList.Free; exit; end;

      //сравнение списков домашний -->рабочий
      for j:=0 to HomeList.Count-1 do
       begin
        I_Poisk:=WorkList.IndexOf(HomeList[j]);
         if I_Poisk>=0 then
           if TAtrib(HomeList.Objects[j]).Nature=1 then
              begin
                if TAtrib(HomeList.Objects[j]).FileDataTime<=TAtrib(WorkList.Objects[I_Poisk]).FileDataTime then
                  begin
                   TAtrib(HomeList.Objects[j]).Action:='skip';
                   TAtrib(WorkList.Objects[I_Poisk]).Free;
                   WorkList.Delete(I_Poisk);
                  end
                 else
                  begin
                   TAtrib(HomeList.Objects[j]).Action:='copy';
                   if Task.LogExt then
                   AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathHome+HomeList[j]+' <==> '+
                   TaskData.FolderDual[i].PathWork+WorkList[I_Poisk],clPurple,Task.SaveLog);
                   TAtrib(WorkList.Objects[I_Poisk]).Free;
                   WorkList.Delete(I_Poisk);
                  end
              end
            else
             begin
              TAtrib(HomeList.Objects[j]).Action:='skip';
              TAtrib(WorkList.Objects[I_Poisk]).Free;
              WorkList.Delete(I_Poisk);
             end
         else
          begin
           if TAtrib(HomeList.Objects[j]).Nature=1 then TAtrib(HomeList.Objects[j]).action:='copy';
           if Task.LogExt then
           AddEchoText(RzRichEditEchoCom,'Файл добавлен: '+TaskData.FolderDual[i].PathWork+HomeList[j],clGreen,Task.Savelog);
          end;
       end;

      if WorkList.Count>0 then
       for j:=0 to WorkList.Count-1 do
        begin
         if TaskData.OperacDell then TAtrib(WorkList.Objects[j]).action:='del'
          else TAtrib(WorkList.Objects[j]).action:='skip';
         HomeList.AddObject(WorkList[j],TAtrib(WorkList.Objects[j]));
         WorkList.Objects[j]:=nil;
        end;
      FreeAndNil(WorkList);

      //подсчет необходимого места
       SizeFiles:=0;
       for j:=0 to HomeList.Count-1 do
        begin
         if TAtrib(HomeList.Objects[j]).Action='copy' then
         SizeFiles:=SizeFiles+TAtrib(HomeList.Objects[j]).SizeFile
        end;

       if not(ChekDiskSize(Char(TaskData.FolderDual[i].PathWork[1]),SizeFiles)) then
        begin
         MessageDlg('На диске не достаточно свободного места для выполнения операций',
         mtError, [mbOK], 0);
         RzPanelProgress.Hide;
         FreeAndNil(HomeList);
         exit
        end;

       PathFldFrom:=PathTask+'\HFiles\Folder_'+IntToStr(i)+'\';

       if SizeFiles>0 then
        begin
         RzPanelProgress.Show;
         AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+ PathFldFrom,clGreen,Task.Savelog);
         ProgressBarFolder.Max:=HomeList.Count;
         ProgressBarFolder.Position:=0;
        end;

      if TaskData.DellСonfirmat then  MRes:=mrYes else MRes:=mrYesToAll;
      for j:=0 to HomeList.Count-1 do
       begin
          if StopCopy then
           begin
            FreeAndNil(HomeList);FreeAndNil(WorkList);
            break;
           end;
        ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
        SetTaskProgress(ProgressBarFolder.Position);
        FSource:=PathFldFrom+TAtrib(HomeList.Objects[j]).FNameTmp;
        FDest:=TaskData.FolderDual[i].PathWork+HomeList[j];
        if TAtrib(HomeList.Objects[j]).Action='copy' then
         begin
          RzLabelNameFile.Caption:=MinimizeName(FDest,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
          if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
          if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
           else AddEchoText(RzRichEditEchoCom,'Отсутствует файл: '+FSource,clRed,Task.SaveLog);
         end;
        if TAtrib(HomeList.Objects[j]).Action='del' then
         begin
          if (MRes=mrYes) or (MRes=mrNo) then
          with CreateMessageDialog('Удалить: '+FDest, mtWarning,
                                     [mbYes,mbYesToAll,mbNo,mbNoToAll]) do
            try
               Caption := 'Внимание';
              (FindComponent('Yes') as TButton).Caption := 'Да';
              (FindComponent('No') as TButton).Caption := 'Нет';
              (FindComponent('YesToAll') as TButton).Caption := 'Да для всех';
              (FindComponent('NoToAll') as TButton).Caption := 'Нет для всех';
               MRes:=ShowModal;
             finally
             Free
            end;
          if (MRes<>mrNo) and (MRes<>mrNoToAll) then
            begin
              if TAtrib(HomeList.Objects[j]).Nature=1 then
                begin
                 if FileExists(FDest) then
                  begin
                   AddEchoText(RzRichEditEchoCom,'Удаление файла: '+FDest,clRed,Task.SaveLog);
                   DelFiles(FDest,TaskData.DellBasket)
                  end
                end
              else
                begin
                 if pos('..',FDest)<>0 then delete(FDest,pos('..',FDest)-1,3);
                 if  DirectoryExists(FDest) then
                  begin
                   AddEchoText(RzRichEditEchoCom,'Удаление папки: '+FDest,clRed,Task.SaveLog);
                   DelDir(FDest,TaskData.DellBasket,True)
                  end
                end
            end
         end;
       end;
        HomeList.Free;
        if SizeFiles>0 then AddEchoText(RzRichEditEchoCom,'Копирование файлов завершено',clGreen,Task.Savelog);
        RzLabelNameFile.Caption:='';
        ProgressBarFile.Position:=ProgressBarFile.Max;
        Screen.Cursor:= crHourGlass;
        AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
        CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
        Screen.Cursor:= crDefault;
     end;
 if (DirectoryExists(PathTask+'\HFiles')) then DelDir(PathTask+'\HFiles',false,true);
 Timer1.Enabled:=True;
 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: бета=>альфа. Тип операции: Компьютер альфа',clBlue,Task.SaveLog);
end;


procedure TFmSinhron.RunHomeWork_Home(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    All:Boolean;
    ShCopy:TModalResult;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    AtribFile:TAtrib;
    FSource,FDest:string;
    SizeFiles:int64;
    f:file of TNameAtribFile;
begin
 All:=False;SizeFiles:=0;

 //проверка существования папок в профиле
 for i:=1 to 10 do
  if TaskData.FolderDual[i].PathHome<>'' then
    begin
     if not(DirectoryExists(TaskData.FolderDual[i].PathHome)) then
      begin
       MessageDlg('В профиле ошибочный путь:'+#10+#13+
       TaskData.FolderDual[i].PathHome,mtError,[mbOK],0);
       exit;
      end;
    end;

 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+
  ']  Начало операции: бета=>альфа. Тип операции: Компьютер бета',clBlue,Task.SaveLog);

 if (DirectoryExists(PathTask+'\HFiles')) then
   if DelDir(PathTask+'\HFiles',false,true)=false then exit;
 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);

 Screen.Cursor:= crHourGlass;
 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
     if PathHome<>'' then
       begin
        if DirectoryExists(PathHome) then
         begin
           AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathHome,clTeal,Task.SaveLog);
           if CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat')=0
            then
             begin
              AddEchoText(RzRichEditEchoCom,'Папка '+TaskData.FolderDual[i].PathHome+' пуста. Конец анализа',0,Task.SaveLog);
              continue
             end;
           if not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat')) then
            begin
             if All=false then
              begin
               FmDialogFulCopy.NameFolder:=PathHome;
               ShCopy:=FmDialogFulCopy.ShowModal;
               All:=FmDialogFulCopy.All;
              end;
             if ShCopy=mrOk then
              begin
               RzPanelProgress.Show;
               PathArhFlsTrgFld:=PathTask+'\HFiles\Folder_'+IntToStr(i)+'\';
               if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat') then
                begin
                 if not(DirectoryExists(PathArhFlsTrgFld)) then ForceDirectories(PathArhFlsTrgFld);
                 CopyAllFilesofList(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',PathArhFlsTrgFld,TaskData.FolderDual[i].PathHome);
                 if StopCopy=True then
                 begin
                  Timer1.Enabled:=true;
                  Exit;
                 end;
                end;
              end;
            end;
         end
       end
     else
       if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat') then
        try
         DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
         except
        end;
     if (PathWork='') and (FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat')) then
       try
        DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
       except
       end;
   end;

 //**********************************************************
   for i:=1 to 10 do
    with TaskData.FolderDual[i] do
     begin
      if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat'))) or
         (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat'))) then Continue;
      AssignFile(f,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');Reset(f);
      if Filesize(f)<2 then begin CloseFile(f);Continue end
       else  CloseFile(f);

      //создание списка рабочий
      WorkList:=TFileList.Create;
      if not(CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
       begin WorkList.Free; exit end;

      //создание списка домашний
      HomeList:=TFileList.Create;
      if not(CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
       begin HomeList.Free; exit end;

      //сравнение списков домашний-->рабочий
      for j:=0 to HomeList.Count-1 do
       begin
        I_Poisk:=WorkList.IndexOf(HomeList[j]);
         if I_Poisk>=0 then
           if TAtrib(HomeList.Objects[j]).Nature=1 then
             begin
               if TAtrib(HomeList.Objects[j]).FileDataTime<=TAtrib(WorkList.Objects[I_Poisk]).FileDataTime then
                  begin
                   TAtrib(HomeList.Objects[j]).Action:='skip';
                   TAtrib(WorkList.Objects[I_Poisk]).Free;
                   WorkList.Delete(I_Poisk);
                  end
               else
               if Task.CompareContent then
                 if (TAtrib(HomeList.Objects[j]).crc32<>TAtrib(WorkList.Objects[I_Poisk]).crc32) or
                  ((TAtrib(WorkList.Objects[j]).crc32=0) and (TAtrib(HomeList.Objects[I_Poisk]).crc32=0)) then
                   begin
                     TAtrib(HomeList.Objects[j]).Action:='copy';
                     if Task.LogExt then
                     AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathHome+HomeList[j]+' <==> '+
                     TaskData.FolderDual[i].PathWork+WorkList[I_Poisk],clPurple,Task.SaveLog);
                   end
                 else  TAtrib(HomeList.Objects[j]).Action:='skip'
               else
                begin
                 TAtrib(HomeList.Objects[j]).Action:='copy';
                 if Task.LogExt then
                 AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathHome+HomeList[j]+' <==> '+
                 TaskData.FolderDual[i].PathWork+WorkList[I_Poisk],clPurple,Task.SaveLog);
                 TAtrib(WorkList.Objects[I_Poisk]).Free;
                 WorkList.Delete(I_Poisk);
                end
             end
           else
            begin
              TAtrib(HomeList.Objects[j]).Action:='skip';
              TAtrib(WorkList.Objects[I_Poisk]).Free;
              WorkList.Delete(I_Poisk);
            end
         else
          begin
           if TAtrib(HomeList.Objects[j]).Nature=1 then TAtrib(HomeList.Objects[j]).action:='copy';
           if Task.LogExt then
           AddEchoText(RzRichEditEchoCom,'Файл добавлен: '+TaskData.FolderDual[i].PathWork+HomeList[j],clGreen,Task.Savelog);
          end;
       end;

      //если на рабочем отсутсвуют
      if WorkList.Count>0 then
       begin
        if not(DirectoryExists(PathTask+'\HFiles')) then ForceDirectories(PathTask+'\HFiles');
         for j:=0 to WorkList.Count-1 do
          begin
           if TaskData.OperacDell then TAtrib(WorkList.Objects[j]).action:='del'
            else TAtrib(WorkList.Objects[j]).action:='skip';
           HomeList.AddObject(WorkList[j],TAtrib(WorkList.Objects[j]));
           WorkList.Objects[j]:=nil;
          end;
       end;
       FreeAndNil(WorkList);

      //подсчет необходимого места
       SizeFiles:=0;
       for j:=0 to HomeList.Count-1 do
        begin
         if TAtrib(HomeList.Objects[j]).Action='copy' then
         SizeFiles:=SizeFiles+TAtrib(HomeList.Objects[j]).SizeFile
        end;

        PathArhFlsTrgFld:=PathTask+'\HFiles\Folder_'+IntToStr(i)+'\';

        if SizeFiles>0 then
        begin
         RzPanelProgress.Show;
         AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+TaskData.FolderDual[i].PathHome,clGreen,Task.Savelog);
         ProgressBarFolder.Max:=HomeList.Count;
         ProgressBarFolder.Position:=0;
        end;
        Screen.Cursor:= crDefault;
       if not(ChekDiskSize(' ',SizeFiles)) then
        begin
         MessageDlg('На диске не достаточно свободного места для выполнения операций',
         mtError, [mbOK], 0);
         RzPanelProgress.Hide;
         FreeAndNil(HomeList);
         exit
         end;

       //копирование или удаление файлов по признаку Action
        for j:=0 to HomeList.Count-1 do
         begin
          if StopCopy then
           begin
            FreeAndNil(HomeList);
            break;
           end;
          ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
          SetTaskProgress(ProgressBarFolder.Position);
          FDest:=PathArhFlsTrgFld+TAtrib(HomeList.Objects[j]).FNameTmp;
          FSource:=TaskData.FolderDual[i].PathHome+HomeList[j];
          if TAtrib(HomeList.Objects[j]).Action='copy' then
           begin
            RzLabelNameFile.Caption:=MinimizeName(FSource,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
            if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
            if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
             else AddEchoText(RzRichEditEchoCom,'Отсутствует файл: '+FSource,clRed,Task.SaveLog);
           end;
         end;
         HomeList.Free;
         RzLabelNameFile.Caption:='';
         ProgressBarFile.Position:=ProgressBarFile.Max;
     end;
 AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец операции: бета=>альфа. Тип операции: Компьютер бета',clBlue,Task.SaveLog);
 Timer1.Enabled:=True;
end;


procedure TFmSinhron.RzBtnSinhronHomeWorkClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;

  if Task.SaveLog then
  begin
    RichEditLog:=TRzRichEdit.Create(FmSinhron);
     with RichEditLog do
      begin
       Parent:=RzPanel2; WantReturns:=true;
       PlainText:=false; Visible:=false;
       Font.Size:=10;
      end;
   AddEchoText(RichEditLog,'Старт программы. Сейчас '+
   FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon,false);
  end;

 StopCopy:=false; Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 PathTask:=ProgramPath+'Task\'+Task.Id;
 if Task.LineExcept<>'' then CreateListExcept(Task.LineExcept);

 if Task.Notransit then
   RunNoTransit(Task,21)
  else
   begin
     if RzRadioButtonWork.Checked then
      begin
        RunHomeWork_Work(Task);
      end;
     if RzRadioButtonHome.Checked then
      begin
       RunHomeWork_Home(Task);
      end;
   end;
  TestState(Task);SetTaskProgress(0);setTaskStopViewProg;
//  RzPanelProgress.Hide;
  Screen.Cursor:= crDefault;
  if Task.SaveLog then
   begin AddLogTmpToLogFile(Sender);FreeAndNil(RichEditLog); end;
end;

procedure TFmSinhron.RzBtnSinhronWorkHomeClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;
 if Task.SaveLog then
  begin
    RichEditLog:=TRzRichEdit.Create(FmSinhron);
     with RichEditLog do
      begin
       Parent:=RzPanel2; WantReturns:=true;
       PlainText:=false; Visible:=false;
       Font.Size:=10;
      end;
   AddEchoText(RichEditLog,'Старт программы. Сейчас '+
   FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon,false);
  end;

 StopCopy:=false; Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 PathTask:=ProgramPath+'Task\'+Task.Id;
 if Task.LineExcept<>'' then CreateListExcept(Task.LineExcept);

 if Task.Notransit then
   RunNoTransit(Task,12)
  else
   begin
     if RzRadioButtonWork.Checked then
      begin
       RunWorkHome_Work(Task);
      end;

     if RzRadioButtonHome.Checked then
      begin
       RunWorkHome_Home(Task);
      end;
   end;
 ProgressBarFolder.Position:=0;ProgressBarFile.Position:=0;
 SetTaskProgress(0);setTaskStopViewProg;
 TestState(Task);Screen.Cursor:= crDefault;
// RzPanelProgress.Hide;
 if Task.SaveLog then
   begin AddLogTmpToLogFile(Sender);FreeAndNil(RichEditLog); end;
end;


procedure TFmSinhron.TestState(TaskData:TProfilLine);
var path:string;
begin

 Path:=ProgramPath+'Task\'+TaskData.Id;
  if Length(ProfilArray)=0 then
   begin
    RzBtnSinhronWorkHome.Enabled:=false;
    RzBtnSinhronHomeWork.Enabled:=false;
    exit;
   end;

  if Task.Notransit then
  begin
    RzRadioButtonWork.Enabled:=false;
    RzRadioButtonHome.Enabled:=false;
    RzBtnSinhronWorkHome.Enabled:=True;
    RzBtnSinhronHomeWork.Enabled:=True;
    exit;
  end
  else
  begin
    RzRadioButtonWork.Enabled:=true;
    RzRadioButtonHome.Enabled:=true;
  end;;

  if (not(DirectoryExists(Path+'\WFiles'))) and
    (not(DirectoryExists(Path+'\HFiles'))) then
       begin
         RzBtnSinhronWorkHome.Enabled:=RzRadioButtonWork.Checked;
         RzBtnSinhronHomeWork.Enabled:=RzRadioButtonHome.Checked;
         exit;
       end;
  if RzRadioButtonWork.Checked then
   begin
    RzBtnSinhronWorkHome.Enabled:=True;
    if DirectoryExists(Path+'\HFiles') then RzBtnSinhronHomeWork.Enabled:=True
    else RzBtnSinhronHomeWork.Enabled:=false;
   end
    else
    begin
     if DirectoryExists(Path+'\WFiles') then RzBtnSinhronWorkHome.Enabled:=True
      else RzBtnSinhronWorkHome.Enabled:=false;
     RzBtnSinhronHomeWork.Enabled:=True;
    end;


end;


procedure TFmSinhron.RzBtnStopCopyClick(Sender: TObject);
begin
 if Assigned(FileCopier) then FileCopier.CopyBreak:=True;
 StopCopy:=True;
end;

procedure TFmSinhron.RzListBoxProfileClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;
 Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 if PCIdent=Task.IdPC then
  begin
   if Task.PC='work' then RzRadioButtonWork.Checked:=true
      else RzRadioButtonHome.Checked:=true
   end
    else
     begin
       if Task.PC='work' then RzRadioButtonHome.Checked:=true
      else RzRadioButtonWork.Checked:=true
     end;
 TestState(Task)
end;

procedure TFmSinhron.RzRadioButtonHomeClick(Sender: TObject);
begin
TestState(Task);
end;

procedure TFmSinhron.RzRadioButtonWorkClick(Sender: TObject);
begin
 TestState(Task);
end;

procedure TFmSinhron.Timer1Timer(Sender: TObject);
begin
  RzPanelProgress.Hide;
  Timer1.Enabled:=False;
end;


function TFmSinhron.ExistenceData:Boolean;
begin
  if Length(ProfilArray)>0 then
    begin
     RzBitBtnEditConfig.Enabled:=True;
     RzBitBtnDelProfil.Enabled:=True;
     RzBtnSinhronWorkHome.Enabled:=True;
     RzBtnSinhronHomeWork.Enabled:=True;
     Result:=True;
    end
  else
   begin
     RzBitBtnEditConfig.Enabled:=False;
     RzBitBtnDelProfil.Enabled:=False;
     RzBtnSinhronWorkHome.Enabled:=False;
     RzBtnSinhronHomeWork.Enabled:=False;
     Result:=False;
   end;
end;


procedure TFmSinhron.CopyFileExProgress(const AFrom,ATo:String);
begin
 with FileCopier do
  begin
   Source:=AFrom;Dest:=ATo;CopyBreak:=false;Copy;
  end;
end;


procedure TFmSinhron.AddEchoText(Edit:TRzRichEdit;Str:String; Color: TColor;Log:boolean);
var  Pos1,Pos2: Integer;
     p: tpoint;

begin
  if color=clNone	Then Color:=clBlack;
  Pos1:=Edit.Perform(EM_LINEINDEX, Edit.Lines.Count, 0);
  Edit.Lines.Add(Str);
  Pos2:=Edit.Perform(EM_LINEINDEX, Edit.Lines.Count, 0);
  Edit.Perform(EM_SETSEL, Pos1, Pos2);
  Edit.SelAttributes.Color:=Color;
//  if color=clRed then Edit.SelAttributes.Style:=[fsBold]
//  else Edit.SelAttributes.Style:=[];
  Edit.SelStart:=Length(RzRichEditEchoCom.Text);
  if Log and  (RichEditLog<>nil) then AddEchoText(RichEditLog,str,color,false);

  with Edit do
   begin
    p := point(2, ClientHeight - 2);
    Pos1 := SendMessage(Handle,EM_EXLINEFROMCHAR, 0,
         SendMessage(Handle, EM_CHARFROMPOS, 0, Integer(@p)))-
         SendMessage(Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
     Pos2:=SendMessage(Handle, EM_GETFIRSTVISIBLELINE, 0, 0);
     SendMessage(Handle, EM_LINESCROLL, 0, (Lines.Count-Pos2)-Pos1);
   end;
end;


procedure TFmSinhron.AddLogTmpToLogFile(Sender:TObject);
var Poz,Size:Integer;
    f:TextFile;
    st:ansistring;
    MemStream,MemStream2:TMemoryStream;

 begin
  if DirectoryExists(ProgramPath+'Task\'+Task.Id) then
   if FileExists(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log') then
     try
       AssignFile(f,ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
       Reset(f);Size:=FileSize(f);CloseFile(f);
       if Size<102400 then
         begin
          MemStream:=TMemoryStream.Create;
          MemStream2:=TMemoryStream.Create;
           try
            MemStream.LoadFromFile(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
            MemStream.SetSize(MemStream.Size-4);
            RichEditLog.Lines.SaveToStream(MemStream2);
            MemStream2.Seek(0,soFromBeginning);
            SetLength(St,MemStream2.Size);
            MemStream2.Read(st[1],Length(st));
            Poz:=pos('\viewkind4\uc1\pard',St)+length('\viewkind4\uc1\pard')-1;
            MemStream2.Seek(Poz,soFromBeginning);
            MemStream.Seek(0,soEnd);//soFromBeginning
            MemStream.CopyFrom(MemStream2,MemStream2.Size-poz);
            MemStream.SaveToFile(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
           finally
            MemStream.Free;MemStream2.Free;
           end;
         end
       else
         RichEditLog.Lines.SaveToFile(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
       except
       end
    else RichEditLog.Lines.SaveToFile(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
 end;



procedure TFmSinhron.RunNoTransit(TaskData:TProfilLine;Napr:word);
var I_Poisk,j,i:integer;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    Fld1_Path,Fld2_Path:string;
    AtribFile:TAtrib;
    FSource,FDest:string;
    ShCopy:TModalResult;
    SizeFiles:int64;
    MRes:TModalResult;
begin
 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);
//проверка существования папок в профиле
 for i:=1 to 10 do
  begin
    if TaskData.FolderDual[i].PathWork<>'' then
     begin
       if not(DirectoryExists(TaskData.FolderDual[i].PathWork)) then
        begin
         MessageDlg('В профиле ошибочный путь:'+#10+#13+
         TaskData.FolderDual[i].PathWork,mtError,[mbOK],0);
         exit;
        end;
     end;
    if TaskData.FolderDual[i].PathHome<>'' then
     begin
       if not(DirectoryExists(TaskData.FolderDual[i].PathHome)) then
        begin
         MessageDlg('В профиле ошибочный путь:'+#10+#13+
         TaskData.FolderDual[i].PathHome,mtError,[mbOK],0);
         exit;
        end;
     end;
  end;

 if napr=12 then
  AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Начало синхронизации альфа с бета. Тип операции: без транзита файлов.',clBlue,Task.SaveLog)
  else
   AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Начало синхронизации бета с альфа. Тип операции: без транзита файлов.',clBlue,Task.SaveLog);


 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
     if (DirectoryExists(PathWork)) and (DirectoryExists(PathHome)) then
        begin
          Screen.Cursor:= crHourGlass;
          AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathWork,clTeal,Task.SaveLog);
          CreateListFiles(TaskData.FolderDual[i].PathWork,
          PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
          AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+'] Анализ: '+TaskData.FolderDual[i].PathHome,clTeal,Task.SaveLog);
          CreateListFiles(TaskData.FolderDual[i].PathHome,
          PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
          Screen.Cursor:= crDefault;
        end
     else
      begin
        if FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat') then
         try
          DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.fdat');
           except
           end;

        if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat') then
         try
          DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
           except
           end;
           Continue
      end;
      if napr=12 then
       begin
        WorkList:=TFileList.Create;
        if not(CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
         begin WorkList.Free; exit end;
         HomeList:=TFileList.Create;
        if not(CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
         begin HomeList.Free; exit end;
       end
        else
        begin
         HomeList:=TFileList.Create;
         if not(CreateListOfFiles(HomeList,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathWork)) then
          begin HomeList.Free; exit end;
         WorkList:=TFileList.Create;
         if not(CreateListOfFiles(WorkList,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat',TaskData.FolderDual[i].PathHome)) then
          begin WorkList.Free; exit end;
        end;

      //сравнение списков рабочий-->домашний
      for j:=0 to WorkList.Count-1 do
       begin
        I_Poisk:=HomeList.IndexOf(WorkList[j]);
         if I_Poisk>=0 then
           if TAtrib(WorkList.Objects[j]).Nature=1 then
              begin
                if TAtrib(WorkList.Objects[j]).FileDataTime<=TAtrib(HomeList.Objects[I_Poisk]).FileDataTime then
                  begin
                   TAtrib(WorkList.Objects[j]).Action:='skip';
                   TAtrib(HomeList.Objects[I_Poisk]).Free;
                   HomeList.Delete(I_Poisk);
                  end
                 else
                  begin
                   TAtrib(WorkList.Objects[j]).Action:='copy';
                   AddEchoText(RzRichEditEchoCom,'Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
                   TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple,Task.SaveLog);
                   TAtrib(HomeList.Objects[I_Poisk]).Free;
                   HomeList.Delete(I_Poisk);
                  end
              end
            else
             begin
              TAtrib(WorkList.Objects[j]).Action:='skip';
              TAtrib(HomeList.Objects[I_Poisk]).Free;
              HomeList.Delete(I_Poisk);
             end
         else
          begin
           if TAtrib(WorkList.Objects[j]).Nature=1 then TAtrib(WorkList.Objects[j]).action:='copy';
           if Task.LogExt then
           AddEchoText(RzRichEditEchoCom,'Файл добавлен: '+TaskData.FolderDual[i].PathWork+WorkList[j],clGreen,Task.Savelog);
          end;
       end;

      //если на рабочем отсутсвуют
      if HomeList.Count>0 then
        for j:=0 to HomeList.Count-1 do
          begin
           if TaskData.OperacDell then TAtrib(HomeList.Objects[j]).action:='del'
            else TAtrib(HomeList.Objects[j]).action:='skip';
           WorkList.AddObject(HomeList[j],TAtrib(HomeList.Objects[j]));
           HomeList.Objects[j]:=nil;
          end;

       FreeAndNil(HomeList);

       //подсчет необходимого места
       SizeFiles:=0;
       for j:=0 to WorkList.Count-1 do
        begin
         if TAtrib(WorkList.Objects[j]).Action='copy' then
         SizeFiles:=SizeFiles+TAtrib(WorkList.Objects[j]).SizeFile
        end;

       if not(ChekDiskSize(ExtractFileDrive(TaskData.FolderDual[i].PathHome) ,SizeFiles)) then
        begin
         MessageDlg('На диске не достаточно свободного места для выполнения операций',
         mtError, [mbOK], 0);
         RzPanelProgress.Hide;
         FreeAndNil(WorkList);
         exit
        end;

     if napr=12 then
       begin
        Fld1_Path:=TaskData.FolderDual[i].PathWork;
        Fld2_Path:=TaskData.FolderDual[i].PathHome;
       end
     else
       begin
        Fld2_Path:=TaskData.FolderDual[i].PathWork;
        Fld1_Path:=TaskData.FolderDual[i].PathHome;
       end;

      //копирование или удаление файлов по признаку Action
      if SizeFiles>0 then
        begin
         RzPanelProgress.Show;
         AddEchoText(RzRichEditEchoCom,'Копирование файлов из '+Fld1_Path+'  в  '+Fld2_Path,clGreen,Task.Savelog);
         ProgressBarFolder.Max:=WorkList.Count;
         ProgressBarFolder.Position:=0;
        end;

    if TaskData.DellСonfirmat then  MRes:=mrYes else MRes:=mrYesToAll;

    for j:=0 to WorkList.Count-1 do
     begin
      if StopCopy then
       begin
        FreeAndNil(HomeList);FreeAndNil(WorkList);
        break;
       end;
      ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
      SetTaskProgress(ProgressBarFolder.Position);
      FDest:=Fld2_Path+WorkList[j];
      FSource:=Fld1_Path+WorkList[j];
      if TAtrib(WorkList.Objects[j]).Action='copy' then
       begin
        RzLabelNameFile.Caption:=MinimizeName(FSource,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
        if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
        if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
         else AddEchoText(RzRichEditEchoCom,'Отсутствует файл: '+FSource,clRed,Task.SaveLog);
       end;
      if TAtrib(WorkList.Objects[j]).Action='del' then
       begin
        RzLabelNameFile.Caption:=MinimizeName(FDest,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
        if (MRes=mrYes) or (MRes=mrNo) then
        with CreateMessageDialog('Удалить: '+FDest, mtWarning, [mbYes,mbYesToAll,mbNo,mbNoToAll]) do
          try
            Caption := 'Внимание';
            (FindComponent('Yes') as TButton).Caption := 'Да';
            (FindComponent('No') as TButton).Caption := 'Нет';
            (FindComponent('YesToAll') as TButton).Caption := 'Да для всех';
            (FindComponent('NoToAll') as TButton).Caption := 'Нет для всех';
             MRes:=ShowModal;
           finally
           Free
          end;
         if (MRes<>mrNo) and (MRes<>mrNoToAll) then
          begin
            if TAtrib(WorkList.Objects[j]).Nature=1 then
              begin
               if FileExists(FDest) then
                begin
                 AddEchoText(RzRichEditEchoCom,'Удаление файла: '+FDest,clRed,Task.SaveLog);
                 DelFiles(FDest,TaskData.DellBasket)
                end
              end
            else
              begin
               if pos('..',FDest)<>0 then delete(FDest,pos('..',FDest)-1,3);
               if  DirectoryExists(FDest) then
                begin
                 AddEchoText(RzRichEditEchoCom,'Удаление папки: '+FDest,clRed,Task.SaveLog);
                 DelDir(FDest,TaskData.DellBasket,True)
                end
              end
          end
       end;
     end;
     WorkList.free;
     if SizeFiles>0 then AddEchoText(RzRichEditEchoCom,'Копирование файлов завершено',clGreen,Task.Savelog);
     RzLabelNameFile.Caption:='';
     ProgressBarFile.Position:=ProgressBarFile.Max;
   end;
    if napr=12 then
    AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец синхронизации альфа с бета. Тип операции: без транзита файлов.',clBlue,Task.SaveLog)
   else
     AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Конец синхронизации бета с альфа. Тип операции: без транзита файлов.',clBlue,Task.SaveLog);
   Timer1.Enabled:=True;setTaskStopViewProg;
end;

procedure TFmSinhron.CreateSnimok(crc:boolean);
label opros;
var Path,NameSnimok:String;
    MRes:TModalResult;
begin
 RzSelectFolderDialog1.SelectedPathName:=ExtractFileDrive(ParamStr(0));

 if RzSelectFolderDialog1.Execute then
  begin
   SaveDialogFlsSnimok.FileName:=ExtractFileName(RzSelectFolderDialog1.SelectedPathName);
   opros:
     if SaveDialogFlsSnimok.Execute then
     begin
      if FileExists(SaveDialogFlsSnimok.FileName) then
       begin
        with CreateMessageDialog('Файл: '+ExtractFileName(SaveDialogFlsSnimok.FileName)+' существует. Перезаписать?',
         mtWarning, [mbYes,mbNo]) do
           try
            Caption := 'Внимание';
            (FindComponent('Yes') as TButton).Caption := 'Да';
            (FindComponent('No') as TButton).Caption := 'Нет';
             MRes:=ShowModal;
            finally
             Free
            end;
           if MRes=mrNo then goto opros;
       end;
       Path:=RzSelectFolderDialog1.SelectedPathName;
       NameSnimok:=SaveDialogFlsSnimok.FileName;
       Screen.Cursor:= crHourGlass;
       AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Создание снимка папки: '+Path,clBlue,Task.SaveLog);
       CreateListFilesFolder(Path,NameSnimok,crc);
       Screen.Cursor:= crDefault;
       AddEchoText(RzRichEditEchoCom,'['+TimeToStr(Time)+']  Cнимок папки: '+Path+' создан. Имя файла: '+NameSnimok,clBlue,Task.SaveLog);
     end;
  end;
end;

procedure TFmSinhron.CompareSnimok;
var mError,I_Poisk,j:integer;
    Path1,Path2,FileSnimok1,FileSnimok2:String;
    List1,List2:TFileList;
    AtribFile:TAtrib;
    tmp:TNameAtribFile;
    f:file of TNameAtribFile;
    comp:boolean;
begin
 comp:=true;mError:=0;
  if OpenDialogSnimok.Execute then
   begin
    FileSnimok1:=OpenDialogSnimok.Filename;
    if OpenDialogSnimok.Execute then
     begin
      FileSnimok2:=OpenDialogSnimok.Filename;
     end
     else exit;

   FmViewLog.NameFileLog:='';
   FmViewLog.MainMenu1.Items.Items[0].Items[0].Visible:=False;
   FmViewLog.Show;
   Path1:='';Path2:='';
   AddEchoText(FmViewLog.RzRichEdit1,'['+TimeToStr(Time)+']  Cравнение снимков: '+
                      FileSnimok1+' и '+FileSnimok2,clBlue,false);
    try
      Assignfile(f,FileSnimok1);
      try
       reset(f);read(f,tmp);Path1:=tmp.FName;
      except
       Closefile(f);exit;
      end;
    finally
     Closefile(f)
    end;
    try
      Assignfile(f,FileSnimok2);
      try
       reset(f);read(f,tmp);Path2:=tmp.FName;
      except
       Closefile(f);exit;
      end;
    finally
     Closefile(f)
    end;
    AddEchoText(FmViewLog.RzRichEdit1,'Снимок '+FileSnimok1+' папка '+Path1,clBlue,false);
    AddEchoText(FmViewLog.RzRichEdit1,'Снимок '+FileSnimok2+' папка '+Path2,clBlue,false);
    Path1:=IncludeTrailingBackslash(Path1);
    Path2:=IncludeTrailingBackslash(Path2);

    List1:=TFileList.Create;CreateListOfFiles(List1,FileSnimok1,'');
    List2:=TFileList.Create;CreateListOfFiles(List2,FileSnimok2,'');
    for j:=0 to List1.Count-1 do
     begin
      I_Poisk:=List2.IndexOf(List1[j]);
       if I_Poisk>=0 then
         if TAtrib(List1.Objects[j]).Nature=1 then
            begin
              if (TAtrib(List1.Objects[j]).FileDataTime=TAtrib(List2.Objects[I_Poisk]).FileDataTime) and
               (TAtrib(List1.Objects[j]).crc32=TAtrib(List2.Objects[I_Poisk]).crc32) then
                begin
                 TAtrib(List2.Objects[I_Poisk]).Free;
                 List2.Delete(I_Poisk);
                end
               else
                begin
                 AddEchoText(FmViewLog.RzRichEdit1,'Файлы отличаются: '+
                  List1[j]+' <==> '+List2[I_Poisk],clPurple,false);
                 TAtrib(List2.Objects[I_Poisk]).Free;
                 List2.Delete(I_Poisk);
                 comp:=false;
                end
            end
          else
           begin
            TAtrib(List2.Objects[I_Poisk]).Free;
            List2.Delete(I_Poisk);
           end
       else
        begin
         AddEchoText(FmViewLog.RzRichEdit1,'В папке '+Path2+' нет файла: '+
                   List1[j],clGreen,false);comp:=false;inc(mError);
        end;
       if mError>100 then
         with CreateMessageDialog(
         'Количество отсутствующих файлов в одной из папок превышает 100.'+#13+#10+
         '    Возможно папки совершенно разные. Прервать операцию?', mtWarning, [mbYes,mbNo]) do
            try
              Caption := 'Внимание';
              (FindComponent('Yes') as TButton).Caption := 'Да';
              (FindComponent('No') as TButton).Caption := 'Нет';
               if ShowModal=mrYes then break else mError:=0;
             finally
             Free
            end;
     end;
      if (List2.Count>0) and (mError<100) then
        for j:=0 to List2.Count-1 do
          begin
           AddEchoText(FmViewLog.RzRichEdit1,'В папке '+Path1+
                      ' нет файла: '+List2[j],clMaroon,false);
           List1.AddObject(List2[j],TAtrib(List2.Objects[j]));
           comp:=false;inc(mError);
           List2.Objects[j]:=nil;
          end;
       List2.Free;List1.Free;
  end;
  if not(comp) then AddEchoText(FmViewLog.RzRichEdit1,'В снимках есть отличия.',
                  clRed,false)
   else AddEchoText(FmViewLog.RzRichEdit1,'Снимки идентичны',clGreen,false);

end;

procedure TFmSinhron.RunParamStr(Sender:TObject);
var f:file of TProfilLine;
    nom,i,j:Integer;
    Tip:Char;
    TipOperac,S:string;
begin
  Task.NameConf:='';Tip:='0';
  for i:=1 to ParamCount do
   case i of
    1: begin
         S:=IncludeTrailingBackslash(ParamStr(i));
         if FileExists(S+'Sinhron.cfg') then
           begin
            FileNameConfig:=S+'Sinhron.cfg';
            ProgramPath:=S
           end
         else Halt(0);
       end;
    2: Nom:=StrToInt(ParamStr(i))-1;
    3: Tip:=ParamStr(i)[1];
    4: TipOperac:=ParamStr(i);
   end;
   if nom<0 then Halt(0);
   try
     AssignFile(f,FileNameConfig);Reset(f);
     SetLength(ProfilArray,0);
     if FileSize(f)>0 then
      begin
       SetLength(ProfilArray,FileSize(f));j:=0;
       while not(Eof(f)) do
        begin
         read(f,ProfilArray[j]);
         inc(j)
        end;
      end;
     CloseFile(f);
     except
     CloseFile(f);Halt(0)
   end;
   Task:=ProfilArray[nom];
   if nom>Length(ProfilArray)-1 then Halt(0);
   if ((Task.NameConf='') or (Tip='0')) or
              ((TipOperac<>'AB') and (TipOperac<>'BA')) then Halt(0);
   if Task.LineExcept<>'' then CreateListExcept(Task.LineExcept);
   PathTask:=ProgramPath+'Task\'+Task.Id;
   if Task.SaveLog then
    begin
      RichEditLog:=TRzRichEdit.Create(FmSinhron);
       with RichEditLog do
        begin
         Parent:=RzPanel2; WantReturns:=true;
         PlainText:=false; Visible:=false;
         Font.Size:=10;
        end;
     AddEchoText(RichEditLog,'Старт программы. Сейчас '+
     FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon,false);
    end;
   if (TipOperac='AB') then
    begin
     if Task.Notransit then
       RunNoTransit(Task,12)
     else
      begin
       if Tip='A' then RunWorkHome_Work(Task);
       if Tip='B' then RunWorkHome_Home(Task);
      end;
    end;
   if (TipOperac='BA') then
    begin
      if Task.Notransit then
       RunNoTransit(Task,21)
      else
       begin
        if Tip='A' then RunHomeWork_Work(Task);
        if Tip='B' then RunHomeWork_Home(Task);
       end;
    end;
    ProgressBarFolder.Position:=0;ProgressBarFile.Position:=0;
    SetTaskProgress(0);setTaskStopViewProg;
    TestState(Task);Screen.Cursor:= crDefault;
    if Task.SaveLog then
      begin
       AddLogTmpToLogFile(Sender);
       FreeAndNil(RichEditLog);
      end;
  Halt(0);
end;

procedure TFmSinhron.cmdExampleLineClick(Sender: TObject);
var s:string;
begin
  AddEchoText(RzRichEditEchoCom,#13+#10+
     'Sinhron.exe E:\Sin\ 1 A AB hide',clRed,false);
  S:='1 параметр: "E:\Sin\" путь к конфигурационному файлу и он определяет рабочую папку'+#13+#10+
     '2 параметр: "1" номер профиля в списке'+#13+#10+
     '3 параметр: текущий компьютер: "A" - альфа "B" бета'+#13+#10+
     '4 параметр: направление синхронизации "AB"-альфа с бета, "BA"-бета с альфа'+#13+#10+
     '5 параметр: "hide" (необязательный) позволяет выполнять все операции скрытно. Для отключения всех '+#13+#10+
     '                     сообщений уберите галочку в профиле подтверждения на удаление.'+#13+#10+
     'Можно подставить только первый параметр для выбора Sinhron.cfg и рабочей папки.'+#13+#10+
     'Eсли параметров больше одного то обязательно нужно вводить все параметры, кроме пятого (необязательного).'+#13+#10+
     'При использовании четырех (пяти) параметров программа запустится в свернутом состоянии, отработает и закроется.'+#13+#10+
     'Шрифт латиница. ';
 AddEchoText(RzRichEditEchoCom,s,clTeal,false);
end;

procedure TFmSinhron.N6HelpProgClick(Sender: TObject);
begin
 if Assigned(FmHelp) then FmHelp.Show
 else begin FmHelp:=TFmHelp.Create(Application); FmHelp.Show;end
end;


procedure TFmSinhron.SnimokOfProfile(Sender: TObject);
var i:integer;
    WPath,tmp:string;
begin

 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);
 if (DirectoryExists(PathTask+'\WFiles')) then
      if DelDir(PathTask+'\WFiles',false,true)=false then exit;
 if (DirectoryExists(PathTask+'\HFiles')) then
      if DelDir(PathTask+'\HFiles',false,true)=false then exit;

//проверка существования папок в профиле
 for i:=1 to 10 do
  begin
   if RzRadioButtonWork.Checked then WPath:=Task.FolderDual[i].PathWork
    else WPath:=Task.FolderDual[i].PathHome;
   if WPath<>'' then
    begin
    if not(DirectoryExists(WPath)) then
     begin
      MessageDlg('В профиле ошибочный путь:'+#10+#13+WPath,mtError,[mbOK],0);
      exit;
     end
    end
   else
    begin
     if RzRadioButtonWork.Checked then tmp:=Task.FolderDual[i].PathHome
     else tmp:=Task.FolderDual[i].PathWork;
     if tmp<>'' then
      begin
       MessageDlg('В профиле ошибочный путь:'+#10+#13+WPath,mtError,[mbOK],0);
       exit;
      end
    end;
  end;
 for i:=1 to 10 do
  with Task.FolderDual[i] do
   begin
    if RzRadioButtonWork.Checked then WPath:=Task.FolderDual[i].PathWork
     else WPath:=Task.FolderDual[i].PathHome;

    if WPath<>'' then
      begin
        Screen.Cursor:= crHourGlass;
        AddEchoText(RzRichEditEchoCom,'Создание снимка: '+WPath,clTeal,Task.SaveLog);
        if RzRadioButtonWork.Checked then
         CreateListFiles(WPath,PathTask+'\WTabFile_'+IntToStr(i)+'.fdat')
          else CreateListFiles(WPath,PathTask+'\HTabFile_'+IntToStr(i)+'.fdat');
        Screen.Cursor:= crDefault;
        AddEchoText(RzRichEditEchoCom,'Конец операции создания.',clTeal,Task.SaveLog);
      end;
   end;
end;


procedure TFmSinhron.N7CreateSnimokProfileClick(Sender: TObject);
begin
 PathTask:=ProgramPath+'Task\'+Task.Id;
 SnimokOfProfile(Sender);
end;


procedure TFmSinhron.TimerCmdBootTimer(Sender: TObject);
begin
 TimerCmdBoot.Enabled:=false;
 if (ParamCount<>0) then  FmSinhron.RunParamStr(FmSinhron);
end;


End.


//        CopyFileWithProgress(St,Sc,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);
//        CopyFileStreamProgress(St,Sc,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);

