unit SinhronN;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RzBmpBtn, Vcl.StdCtrls, RzLstBox, DiskTools,
  RzEdit, Vcl.ExtCtrls, RzPanel, RzButton, RzRadChk, Vcl.Imaging.pngimage,SinhronConfig,
  RzBorder, RzLabel, Vcl.Buttons, Vcl.ComCtrls, RzPrgres, RzSpnEdt, RzStatus,Winapi.RichEdit,
  ShlObj,ComObj,System.Win.Registry,vcl.Themes,Vcl.Menus;


type

  TTaskState = record
        name : string;
        value : byte;
     end;

  TFmSinhron = class(TForm)
    RzPanel2: TRzPanel;
    RzListBoxProfile: TRzListBox;
    RzRadioButtonWork: TRzRadioButton;
    RzRadioButtonHome: TRzRadioButton;
    RzBorder1: TRzBorder;
    RzBtnSinhronWorkHome: TRzBitBtn;
    RzPanel1: TRzPanel;
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
    RzLabel6: TRzLabel;
    RzPanel3: TRzPanel;
    img1: TImage;
    img2: TImage;
    PopupMenuStyleThemes: TPopupMenu;
    RzRichEditEchoCom: TRzRichEdit;
    PopupMenuLogView: TPopupMenu;
    N1ViewLog: TMenuItem;
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
    procedure CreateListOfFiles(var List:TFileList; PathFiles:String;PathShab:string);
    procedure RzBtnStopCopyClick(Sender: TObject);
    procedure RzRadioButtonWorkClick(Sender: TObject);
    procedure RzListBoxProfileClick(Sender: TObject);
    procedure RzRadioButtonHomeClick(Sender: TObject);
    procedure RzBtnSinhronHomeWorkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  CreateListExcept(s:String):TStringList;
    function  CreateListFiles(PathFolder:String;NameFiles:String):int64;
    function  ChekDiskSize(Disk:char;SizeFiles:int64):boolean;
    procedure CopyFileExProgress(const AFrom,ATo:String);
    procedure PopupMenuStyleThemesChange(Sender: TObject; Source: TMenuItem;
      Rebuild: Boolean);
    procedure LoadStyle(Sender: TObject);
    procedure AddEchoText(Str:String; Color: TColor);
    procedure AddLogText(Str:String; Color: TColor);
    procedure AddLogTmpToLogFile(Sender: TObject);
    procedure N1ViewLogClick(Sender: TObject);
    procedure PopupMenuLogViewPopup(Sender: TObject);
  private
    FileCopier:IFileCopier;
    TaskBarList:ITaskBarList3;
    fState : integer;
    fProgress : integer;
    procedure setTaskProgress(newValue : integer);
    procedure setTaskStopViewProg;
  public
    StopCopy:boolean;
    Task:TProfilLine;
    PCIdent:String[25];
    ListExcept:TStringList;
    PathTask:string;
    RichEditLog:TRichEdit;
    property progress:integer read fProgress write setTaskProgress;
  end;

var
  FmSinhron: TFmSinhron;

implementation

{$R *.dfm}

uses FileCtrl, DialogFulCopy, ViewLog;

procedure TFmSinhron.LoadStyle(Sender: TObject);
begin
 if Sender is TMenuItem then
 TStyleManager.TrySetStyle(TMenuItem(Sender).Caption,false);
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

procedure TFmSinhron.FormActivate(Sender: TObject);
begin
 RzListBoxProfile.Focused;
 if Length(ProfilArray)>0 then RzListBoxProfile.ItemIndex:=FmConfig.NProf;
 if RzListBoxProfile.ItemIndex>=0 then Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 RzListBoxProfileClick(sender);
 TestState(Task);
end;

procedure TFmSinhron.FormClose(Sender: TObject; var Action: TCloseAction);
var Poz,Size,i:Integer;
    f:TextFile;
    RegData:TRegistry;
    st:ansistring;
    MemStream,MemStream2:TMemoryStream;
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
var f:file of TProfilLine;
    Lin:TProfilLine;
    i:Integer;
    ss,S,Tmp:String;
    m: TmenuItem;
    RegData:TRegistry;
    pn:TPoint;
    tbList : ITaskBarList;
    hr : HRESULT;
    state : TTaskState;
begin
// Application.MainFormOnTaskBar := True;
  TbList:=CreateComObject(CLSID_TaskBarList) as ITaskBarList;
  hr := tbList.QueryInterface(IID_ITaskBarList3,taskBarList);
  pn.x:=-1;
 try
  RegData:=TRegistry.Create;
  RegData.RootKey:=HKEY_CURRENT_USER;
  RegData.Access:=KEY_READ;
   if RegData.OpenKey('\SOFTWARE\UrlWest\Sinhron',false) then
    begin
       S:=RegData.ReadString('SinhronStyle');
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
 if pn.x>0 then
  begin
   FmSinhron.Left:=pn.x;FmSinhron.Top:=pn.y;
  end;
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
  Screen.Cursor := crDefault;
  AddEchoText('Старт программы. Сейчас '+
  FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon);

 ProgramPath:=ExtractFilePath(ParamStr(0));
 PCIdent:=GetHDSerNo; RichEditLog:=nil;
 if  FileExists(ProgramPath+'Sinhron.cfg') then
  begin
     AssignFile(f,ProgramPath+'Sinhron.cfg');Reset(f);
     if FileSize(f)>0 then
      begin
       SetLength(ProfilArray,FileSize(f));i:=0;
       while not(Eof(f)) do
        begin
         read(f,ProfilArray[i]);
         RzListBoxProfile.Items.Add(ProfilArray[i].NameConf);
         inc(i)
        end;
       Task:=ProfilArray[0];
      end;
    CloseFile(f);
  end;
 if Task.LineExcept<>'' then ListExcept:=CreateListExcept(Task.LineExcept);

  FmSinhron.ExistenceData;
  RzLblVersion.Caption:='v.'+RzVersionInfo1.FileVersion;

  FileCopier := TFileCopier.Create;
  FileCopier.ProgressBar:=ProgressBarFile;
  FileCopier.MemoResult:=RzRichEditEchoCom;

  for i := 0 to Length(TStyleManager.StyleNames)-1 do
    begin
      m:=TmenuItem.Create(FmSinhron);
      m.Caption:=TStyleManager.StyleNames[i];
      m.OnClick:=LoadStyle;
      PopupMenuStyleThemes.Items.Add(m);
    end;
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


function TFmSinhron.CreateListExcept(s:String):TStringList;
var tmp:string;
begin
 Result:=TStringList.Create;
 while Length(S)<>0 do
  begin
    if Pos(';',S)<>0 then
      begin
       tmp:=copy(s,1,Pos(';',S)-1);
       delete(s,1,Pos(';',S));
       if pos('*',tmp)<>0 then
        begin
         Result.Add(copy(tmp,pos('*',tmp)-1,Length(tmp)-pos('*',tmp)+1));
        end
       else Result.Add(tmp)
      end
    else
    begin Result.Add(s);s:='';end;
  end;
end;


procedure TFmSinhron.FormShow(Sender: TObject);
begin
 TestState(Task);
end;

procedure TFmSinhron.PopupMenuLogViewPopup(Sender: TObject);
begin
 if (FileExists(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log')) then
  PopupMenuLogView.Items.Items[0].Enabled:=True
   else PopupMenuLogView.Items.Items[0].Enabled:=false
end;

procedure TFmSinhron.PopupMenuStyleThemesChange(Sender: TObject; Source: TMenuItem;
  Rebuild: Boolean);
var m:TMenuItem;
begin

end;

procedure TFmSinhron.RzBitBtnAddProfilClick(Sender: TObject);
var f:file of TProfilLine;
begin
 SetLength(ProfilArray,Length(ProfilArray)+1);
 FmConfig.profnew:=true;
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

   for I:=RzListBoxProfile.ItemIndex to Length(ProfilArray)-1 do
   ProfilArray[i]:=ProfilArray[i+1];
   SetLength(ProfilArray, Length(ProfilArray)-1);
   RzListBoxProfile.Items.Clear;

   AssignFile(f,ProgramPath+'Sinhron.cfg');Rewrite(f);
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
 // 0 все вложенные папки и файлы 1 все вложенные папки 2 файлы в указанной папке
 ScanDisk(PathFolder,'*.*',Spisok,0);
 AssignFile(f,NameFiles); Rewrite(f);
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
       AddEchoText('Ошибка! Уменьшите длину пути\имени файла: '+Spisok.Strings[i],clRed);
       Continue;
      end;
     FName:=Spisok.Strings[i];
     FNameTmp:=RandomNameFile('',12)+ExtractFileExt(Spisok.Strings[i]);
     Nature:=TAtrib(Spisok.Objects[i]).Nature;
     FDataTime:=TAtrib(Spisok.Objects[i]).FileDataTime;
     SizeFile:=TAtrib(Spisok.Objects[i]).SizeFile;
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
  AddEchoText('Копирование файлов из '+PathFolder,clGreen);
  RzLabelNameFolder.Caption:=MinimizeName(PathFolder,RzLabelNameFolder.Canvas,RzLabelNameFolder.Width);
  AssignFile(f,PathList);Reset(f);
  ProgressBarFolder.Max:=FileSize(f);
  ProgressBarFolder.Position:=0;

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
//       CopyFileStreamProgress(Sc,St,NameAtribFile.FDataTime,ProgressBarFile);
//       CopyFileWithProgress(Sc,St,NameAtribFile.FDataTime,ProgressBarFile);
       CopyFileExProgress(FSource,FDest);
       ProgressBarFile.Position:=ProgressBarFile.Max;
      end
    end;
   CloseFile(f);
   AddEchoText('Копирование файлов из '+PathFolder+' завершено',clGreen);
end;


procedure TFmSinhron.CreateListOfFiles(var List:TFileList; PathFiles:String;PathShab:string);
var f:file of TNameAtribFile;
    AtribFile:TAtrib;
    tmp:TNameAtribFile;
 begin
  AssignFile(f,PathFiles);Reset(f);
   while (not EOF(f)) do
    begin
      read(f,tmp); AtribFile:=TAtrib.Create;
        with tmp do
         begin
         AtribFile.FNameTmp:=FNameTmp;
         AtribFile.FileDataTime:=FDataTime;
         AtribFile.Nature:=Nature;
         AtribFile.Action:='';
         AtribFile.SizeFile:=SizeFile;
         Delete(FName,1,Length(PathShab));
         List.AddObject(FName,AtribFile);
        end;
      end;
      CloseFile(f);
 end;


function TFmSinhron.ChekDiskSize(Disk:char;SizeFiles:int64):boolean;
var i:integer;
begin
 if Disk=' ' then i:=0 else i:=Ord(Disk)-64;
 if SizeFiles<=DiskFree(i) then Result:=True  else Result:=False;
end;

procedure TFmSinhron.RunWorkHome_Home(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    AtribFile:TAtrib;
    FSource,FDest:string;
    Res:Boolean;
    MRes:TModalResult;
    SizeFiles:int64;
begin
 //создание списка============================================================
 SizeFiles:=0;StopCopy:=false;
 AddEchoText('['+TimeToStr(Time)+']  Начало операции: рабочий=>домашний. Тип: Домашний компьютер',clBlue);
 for i:=1 to 10 do
 with TaskData.FolderDual[i] do
  if PathHome<>'' then
    begin
     if DirectoryExists(PathHome) then
       begin
        Screen.Cursor:= crHourGlass;
        AddEchoText('Анализ: '+TaskData.FolderDual[i].PathHome,clTeal);
        CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
        Screen.Cursor:= crDefault;
       end
        else
        begin
         ForceDirectories(PathHome);
         SizeFiles:=CreateListFiles(PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
        end
     end
  else
   if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat') then
    try
     DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
     except
    end;


  for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
    if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat'))) or
       (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat'))) then Continue;

    WorkList:=TFileList.Create;
    CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathWork);

    HomeList:=TFileList.Create;
    CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathHome);

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
               AddEchoText('Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
               TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple);
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
         AddEchoText('Файл добавлен: '+TaskData.FolderDual[i].PathWork+WorkList[j],clGreen);
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
       AddEchoText('Копирование файлов в '+TaskData.FolderDual[i].PathHome,clGreen);
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
//        CopyFileWithProgress(St,Sc,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);
//        CopyFileStreamProgress(St,Sc,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);
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
               if FileExists(FDest) then DelFiles(FDest,TaskData.DellBasket)
              end
            else
              begin
               if pos('..',FDest)<>0 then delete(FDest,pos('..',FDest)-1,3);
               if  DirectoryExists(FDest) then DelDir(FDest,TaskData.DellBasket,True)
              end;
          end
       end;
     end;

     WorkList.Free;
     if SizeFiles>0 then AddEchoText('Копирование файлов завершено',clGreen);
     RzLabelNameFile.Caption:='';
     ProgressBarFile.Position:=ProgressBarFile.Max;
     Screen.Cursor:= crHourGlass;
     AddEchoText('Анализ: '+TaskData.FolderDual[i].PathHome,clTeal);
     CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
     Screen.Cursor:= crDefault;
   end;
    if (DirectoryExists(PathTask+'\WFiles')) then DelDir(PathTask+'\WFiles',false,true);
    AddEchoText('['+TimeToStr(Time)+']  Конец операции: рабочий=>домашний. Тип: Домашний компьютер',clBlue);
    Timer1.Enabled:=True;
end;


procedure TFmSinhron.RunWorkHome_Work(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    All:Boolean;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    AtribFile:TAtrib;
    FSource,FDest:string;
    ShCopy:TModalResult;
    SizeFiles:int64;
begin
 All:=False;SizeFiles:=0;
 AddEchoText('['+TimeToStr(Time)+']  Начало операции: рабочий=>домашний. Тип: Рабочий компьютер',clBlue);
 if (DirectoryExists(PathTask+'\WFiles')) then
      if DelDir(PathTask+'\WFiles',false,true)=false then exit;
 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);

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

 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
    if PathWork<>'' then
      begin
       if DirectoryExists(PathWork) then
        begin
         //если запуск первый раз. инфы о домашнем нет
         if not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat')) then
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
               AddEchoText('Анализ: '+TaskData.FolderDual[i].PathWork,clTeal);
               SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
               Screen.Cursor:= crDefault;
                if not(ChekDiskSize(' ',SizeFiles)) then
                  begin
                    MessageDlg('На диске не достаточно свободного места для выполнения операций',
                     mtError, [mbOK], 0);RzPanelProgress.Hide;
                     exit
                  end;
               RzPanelProgress.Show;
               PathArhFlsTrgFld:=PathTask+'\WFiles\Folder_'+IntToStr(i)+'\';
               CopyAllFilesofList(PathTask+'\WTabFile_'+IntToStr(i)+'.dat',PathArhFlsTrgFld,TaskData.FolderDual[i].PathWork);
               if StopCopy=True then
                begin
                 Timer1.Enabled:=true;
                 Exit;
                end;
              end
              else
              begin
               Screen.Cursor:= crHourGlass;
               AddEchoText('Анализ: '+TaskData.FolderDual[i].PathWork,clTeal);
               SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,
                                       PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
               Screen.Cursor:= crDefault;
              end
          end
          else
           begin
            Screen.Cursor:= crHourGlass;
            AddEchoText('Анализ: '+TaskData.FolderDual[i].PathWork,clTeal);
            SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,
                                       PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
            Screen.Cursor:= crDefault;
           end
        end
      end
    else
     if FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat') then
      try
       DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
        except
        end;
    if (PathHome='') and (FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat')) then
      try
       DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
      except
      end;
   end;
   //==========================================================================

   for i:=1 to 10 do
    with TaskData.FolderDual[i] do
     begin
      if not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat')) then Continue;

      //создание списка рабочий
      WorkList:=TFileList.Create;
      CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathWork);

      //создание списка домашний
      HomeList:=TFileList.Create;
      CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathHome);

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
                   AddEchoText('Файлы отличаются: '+TaskData.FolderDual[i].PathWork+WorkList[j]+' <==> '+
                   TaskData.FolderDual[i].PathHome+HomeList[I_Poisk],clPurple);
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
           AddEchoText('Файл добавлен: '+TaskData.FolderDual[i].PathWork+WorkList[j],0);
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
         AddEchoText('Копирование файлов из '+TaskData.FolderDual[i].PathWork,0);
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
//            CopyFileWithProgress(Sc,St,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);
//            CopyFileStreamProgress(Sc,St,TAtrib(WorkList.Objects[j]).FileDataTime,ProgressBarFile);
            if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
             else AddEchoText('Отсутствует файл: '+FSource,clRed);
           end;
         end;
         WorkList.free;
         if SizeFiles>0 then AddEchoText('Копирование файлов завершено',clGreen);
         RzLabelNameFile.Caption:='';
         ProgressBarFile.Position:=ProgressBarFile.Max;
     end;
      AddEchoText('['+TimeToStr(Time)+']  Конец операции: рабочий=>домашний. Тип: Рабочий компьютер',clBlue);
      Timer1.Enabled:=True;
end;


procedure TFmSinhron.RunHomeWork_Work(TaskData:TProfilLine);
var I_Poisk,j,i:integer;
    PathArhFlsTrgFld:String;
    HomeList,WorkList:TFileList;
    AtribFile:TAtrib;
    PathFldFrom,FDest,FSource:string;
    MRes:TModalResult;
    Res:Boolean;
    SizeFiles:int64;

begin
  //создание списка============================================================
  SizeFiles:=0;
  AddEchoText('['+TimeToStr(Time)+']  Начало операции: домашний=>рабочий. Тип: Рабочий компьютер',clBlue);
   for i:=1 to 10 do
   with TaskData.FolderDual[i] do
    if PathWork<>'' then
      begin
       if DirectoryExists(PathWork) then
         begin
          Screen.Cursor:= crHourGlass;
          AddEchoText('Анализ папки: '+TaskData.FolderDual[i].PathWork,clTeal);
          SizeFiles:=CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
          Screen.Cursor:= crDefault;
         end
          else
          begin
           ForceDirectories(PathWork);
           SizeFiles:=CreateListFiles(PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
          end;
       end
    else
     if FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat') then
      try
       DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
       except
       end;
  //==========================================================================

    for i:=1 to 10 do
    with TaskData.FolderDual[i] do
     begin
      if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat'))) or
         (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat'))) then Continue;

      WorkList:=TFileList.Create;
      CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathWork);

      HomeList:=TFileList.Create;
      CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathHome);

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
                   AddEchoText('Файлы отличаются: '+TaskData.FolderDual[i].PathHome+HomeList[j]+' <==> '+
                   TaskData.FolderDual[i].PathWork+WorkList[I_Poisk],clPurple);
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
           AddEchoText('Файл добавлен: '+TaskData.FolderDual[i].PathWork+HomeList[j],clGreen);
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
         AddEchoText('Копирование файлов из '+ PathFldFrom,clGreen);
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
//          CopyFileWithProgress(St,Sc,TAtrib(HomeList.Objects[j]).FileDataTime,ProgressBarFile);
//          CopyFileStreamProgress(St,Sc,TAtrib(HomeList.Objects[j]).FileDataTime,ProgressBarFile);
          if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
           else AddEchoText('Отсутствует файл: '+FSource,clRed);
         end;
        if TAtrib(HomeList.Objects[j]).Action='del' then
         begin
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
              if TAtrib(HomeList.Objects[j]).Nature=1 then
                begin
                 if FileExists(FDest) then
                  DelFiles(FDest,TaskData.DellBasket)
                end
              else
                begin
                 if pos('..',FDest)<>0 then delete(FDest,pos('..',FDest)-1,3);
                 if  DirectoryExists(FDest) then DelDir(FDest,TaskData.DellBasket,true)
                end;
           end
         end;
       end;
        HomeList.Free;
        if SizeFiles>0 then AddEchoText('Копирование файлов завершено',clGreen);
        RzLabelNameFile.Caption:='';
        ProgressBarFile.Position:=ProgressBarFile.Max;
        Screen.Cursor:= crHourGlass;
        AddEchoText('Анализ: '+TaskData.FolderDual[i].PathWork,clTeal);
        CreateListFiles(TaskData.FolderDual[i].PathWork,PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
        Screen.Cursor:= crDefault;
        AddEchoText('['+TimeToStr(Time)+']  Конец операции: домашний=>рабочий. Тип: Рабочий компьютер',clBlue);
     end;
      if (DirectoryExists(PathTask+'\HFiles')) then DelDir(PathTask+'\HFiles',false,true);
      Timer1.Enabled:=True;
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
 AddEchoText('['+TimeToStr(Time)+']  Начало операции: домашний=>рабочий. Тип: Домашний компьютер',clBlue);
 if (DirectoryExists(PathTask+'\HFiles')) then
   if DelDir(PathTask+'\HFiles',false,true)=false then exit;
 if not(DirectoryExists(PathTask)) then ForceDirectories(PathTask);

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
 Screen.Cursor:= crHourGlass;
 for i:=1 to 10 do
  with TaskData.FolderDual[i] do
   begin
     if PathHome<>'' then
       begin
        if DirectoryExists(PathHome) then
         begin
           AddEchoText('Анализ: '+TaskData.FolderDual[i].PathHome,clTeal);
           if CreateListFiles(TaskData.FolderDual[i].PathHome,PathTask+'\HTabFile_'+IntToStr(i)+'.dat')=0
            then
             begin
              AddEchoText('Папка '+TaskData.FolderDual[i].PathHome+' пуста. Конец анализа',0);
              continue
             end;
           if not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat')) then
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
               if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat') then
                begin
                 if not(DirectoryExists(PathArhFlsTrgFld)) then ForceDirectories(PathArhFlsTrgFld);
                 CopyAllFilesofList(PathTask+'\HTabFile_'+IntToStr(i)+'.dat',PathArhFlsTrgFld,TaskData.FolderDual[i].PathHome);
                 if StopCopy=True then
                 begin
                  Timer1.Enabled:=true;
                  Exit;
                 end;

                end;
                Timer1.Enabled:=True;
              end;
           end;
         end
       end
     else
       if FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat') then
        try
         DeleteFile(PathTask+'\HTabFile_'+IntToStr(i)+'.dat');
         except
        end;
     if (PathWork='') and (FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat')) then
       try
        DeleteFile(PathTask+'\WTabFile_'+IntToStr(i)+'.dat');
       except
       end;
   end;

 //**********************************************************
   for i:=1 to 10 do
    with TaskData.FolderDual[i] do
     begin
      if (not(FileExists(PathTask+'\WTabFile_'+IntToStr(i)+'.dat'))) or
         (not(FileExists(PathTask+'\HTabFile_'+IntToStr(i)+'.dat'))) then Continue;
      AssignFile(f,PathTask+'\HTabFile_'+IntToStr(i)+'.dat');Reset(f);
      if Filesize(f)<2 then begin CloseFile(f);Continue end
       else  CloseFile(f);

      //создание списка рабочий
      WorkList:=TFileList.Create;
      CreateListOfFiles(WorkList,PathTask+'\WTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathWork);

      //создание списка домашний
      HomeList:=TFileList.Create;
      CreateListOfFiles(HomeList,PathTask+'\HTabFile_'+IntToStr(i)+'.dat',TaskData.FolderDual[i].PathHome);

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
                begin
                 TAtrib(HomeList.Objects[j]).Action:='copy';
                 AddEchoText('Файлы отличаются: '+TaskData.FolderDual[i].PathHome+HomeList[j]+' <==> '+
                 TaskData.FolderDual[i].PathWork+WorkList[I_Poisk],clPurple);
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
           AddEchoText('Файл добавлен: '+TaskData.FolderDual[i].PathWork+HomeList[j],clGreen);
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
         AddEchoText('Копирование файлов из '+TaskData.FolderDual[i].PathHome,clGreen);
         ProgressBarFolder.Max:=HomeList.Count;
         ProgressBarFolder.Position:=0;
        end;

       if not(ChekDiskSize(' ',SizeFiles)) then
        begin
         MessageDlg('На диске не достаточно свободного места для выполнения операций',
         mtError, [mbOK], 0);
         RzPanelProgress.Hide;
         FreeAndNil(HomeList);
         exit
         end;
        Screen.Cursor:= crDefault;
       //копирование или удаление файлов по признаку Action
        for j:=0 to HomeList.Count-1 do
         begin
          if StopCopy then
           begin
            FreeAndNil(HomeList);
            break;
           end;
          ProgressBarFolder.Position:=ProgressBarFolder.Position+1;
          FDest:=PathArhFlsTrgFld+TAtrib(HomeList.Objects[j]).FNameTmp;
          FSource:=TaskData.FolderDual[i].PathHome+HomeList[j];
          if TAtrib(HomeList.Objects[j]).Action='copy' then
           begin
            RzLabelNameFile.Caption:=MinimizeName(FSource,RzLabelNameFile.Canvas,RzLabelNameFile.Width);
            if not(DirectoryExists(ExtractFileDir(FDest))) then  ForceDirectories(ExtractFileDir(FDest));
//            CopyFileWithProgress(Sc,St,TAtrib(HomeList.Objects[j]).FileDataTime,ProgressBarFile);
//            CopyFileStreamProgress(Sc,St,TAtrib(HomeList.Objects[j]).FileDataTime,ProgressBarFile);
            if FileExists(FSource) then CopyFileExProgress(FSource,FDest)
             else AddEchoText('Отсутствует файл: '+FSource,clRed);
           end;
         end;
         HomeList.Free;
         RzLabelNameFile.Caption:='';
         ProgressBarFile.Position:=ProgressBarFile.Max;
     end;
      AddEchoText('['+TimeToStr(Time)+']  Конец операции: домашний=>рабочий. Тип: Домашний компьютер',clBlue);
      Timer1.Enabled:=True;
end;


procedure TFmSinhron.RzBtnSinhronHomeWorkClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;

  if Task.SaveLog then
  begin
    RichEditLog:=TRichEdit.Create(FmSinhron);
     with RichEditLog do
      begin
       Parent:=RzPanel2; WantReturns:=true;
       PlainText:=false; Visible:=false;
       Font.Size:=10;
      end;
   AddLogText('Старт программы. Сейчас '+
   FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon);
  end;

 StopCopy:=false; Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 PathTask:=ProgramPath+'Task\'+Task.Id;
 if RzRadioButtonWork.Checked then
  begin
    RunHomeWork_Work(Task);
  end;
 if RzRadioButtonHome.Checked then
  begin
   RunHomeWork_Home(Task);
  end;
  TestState(Task);SetTaskProgress(0);setTaskStopViewProg;
  RzPanelProgress.Hide;
  if Task.SaveLog then
   begin AddLogTmpToLogFile(Sender);FreeAndNil(RichEditLog); end;
end;

procedure TFmSinhron.RzBtnSinhronWorkHomeClick(Sender: TObject);
begin
 if RzListBoxProfile.ItemIndex<0 then exit;
 if Task.SaveLog then
  begin
    RichEditLog:=TRichEdit.Create(FmSinhron);
     with RichEditLog do
      begin
       Parent:=RzPanel2; WantReturns:=true;
       PlainText:=false; Visible:=false;
       Font.Size:=10;
      end;
   AddLogText('Старт программы. Сейчас '+
   FormatDateTime('d mmmm yyyy "г - " dddd',Now)+'. Время: '+TimeToStr(Time)+'.',clMaroon);
  end;

 StopCopy:=false; Task:=ProfilArray[RzListBoxProfile.ItemIndex];
 PathTask:=ProgramPath+'Task\'+Task.Id;

 if RzRadioButtonWork.Checked then
  begin
   RunWorkHome_Work(Task);
  end;

 if RzRadioButtonHome.Checked then
  begin
   RunWorkHome_Home(Task);
  end;

 ProgressBarFolder.Position:=0;ProgressBarFile.Position:=0;
 SetTaskProgress(0);setTaskStopViewProg;
 TestState(Task);
 RzPanelProgress.Hide;
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
   if Task.PC='work' then RzRadioButtonWork.Checked:=true
      else RzRadioButtonHome.Checked:=true;
  if Task.LineExcept<>'' then
   begin
    if ListExcept<>nil then ListExcept.Clear;
    ListExcept:=CreateListExcept(Task.LineExcept);
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


procedure TFmSinhron.AddLogText(Str:String; Color: TColor);
var  Pos1,Pos2: Integer;
begin
 if RichEditLog<>nil then
  begin
    if color=clNone	Then Color:=clBlack;
    Pos1:=RichEditLog.Perform(EM_LINEINDEX, RichEditLog.Lines.Count, 0);
    RichEditLog.Lines.Add(Str);
    Pos2:= RichEditLog.Perform(EM_LINEINDEX, RichEditLog.Lines.Count, 0);
    RichEditLog.Perform(EM_SETSEL, Pos1, Pos2);
    RichEditLog.SelAttributes.Color := Color;
    if color=clRed then RichEditLog.SelAttributes.Style:=[fsBold]
    else RichEditLog.SelAttributes.Style:=[];
    RichEditLog.SelStart:=Length(RzRichEditEchoCom.Text);
  end;
end;


procedure TFmSinhron.AddEchoText(Str:String; Color: TColor);
var  Pos1,Pos2: Integer;
     p: tpoint;
     ns,NomV:integer;
begin
  if color=clNone	Then Color:=clBlack;
  Pos1:=RzRichEditEchoCom.Perform(EM_LINEINDEX, RzRichEditEchoCom.Lines.Count, 0);
  RzRichEditEchoCom.Lines.Add(Str);
  Pos2:= RzRichEditEchoCom.Perform(EM_LINEINDEX, RzRichEditEchoCom.Lines.Count, 0);
  RzRichEditEchoCom.Perform(EM_SETSEL, Pos1, Pos2);
  RzRichEditEchoCom.SelAttributes.Color := Color;
  if color=clRed then RzRichEditEchoCom.SelAttributes.Style:=[fsBold]
  else RzRichEditEchoCom.SelAttributes.Style:=[];
  RzRichEditEchoCom.SelStart:=Length(RzRichEditEchoCom.Text);
  if Task.SaveLog then AddLogText(Str,Color);
  with RzRichEditEchoCom do
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
var Poz,Size,i:Integer;
    f:TextFile;
    RegData:TRegistry;
    st:ansistring;
    MemStream,MemStream2:TMemoryStream;

 begin
  if DirectoryExists(ProgramPath+'Task\'+Task.Id) then
   if FileExists(ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log') then
     try
       AssignFile(f,ProgramPath+'Task\'+Task.Id+'\'+Task.Id+'.log');
       Reset(f);Size:=FileSize(f);CloseFile(f);
       if Size<1024000 then
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
End.



