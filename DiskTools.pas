unit DiskTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, RzTreeVw, RzPanel, RzSplit,
  RzButton, ImgList, RzShellDialogs, RzEdit, RzLstBox,Math;

procedure ScanFile(StartDir: string; Mask:string; List:TStrings);
procedure ScanDisk(StartDir: string; Mask:string; List:TStrings;Fst:word);
procedure CopyFileWithProgress(const AFrom, ATo: String;Attr:Longint; var AProgress: TProgressBar);
procedure CopyFileStreamProgress(const AFrom,ATo:String;Attr:Longint; var AProgress: TProgressBar);
function RandomID(PLen: Integer): string;
function RandomNameFile(St:String;PLen: Integer): string;
function RandomWord(dictSize, lngStepSize, wordLen, minWordLen: Integer): string;
function DelDir(dir: string;ToRecycle:boolean;Progress:boolean): Boolean;
function DelFiles(const FileName: string;ToRecycle:boolean): Boolean;
function GetFileSize(FileName: String): Int64;
function GetHDSerNo: string; export;


type
 TAtrib=class
  public
   FNameTmp:string[25];
   Nature:byte;
   FileDataTime:Double;
   SizeFile:Int64;
   Action:string[5];
end;

TNameAtribFile = record
   Nature:byte;
   FName:shortstring;
   FDataTime:Double;
   SizeFile:Int64;
   FNameTmp:string[25];
end;

TFolderDual = record
  PathWork:shortstring;
  PathHome:shortstring;
end;

TFileList = class(TStringList)
constructor Create;
destructor destroy;override;
end;

TProfilLine = record
   NameConf:shortstring;
   Id:string[8];
   IdPC:string[25];
   FolderDual: array [1..10] of TFolderDual;
   LineExcept:shortstring;
   PC:string[4];
   OperacDell:boolean;
   DellBasket:boolean;
   DellСonfirmat:Boolean;
   SaveLog:Boolean;
   LogExt:Boolean;
   Notransit:Boolean;
end;

TProfile = record
   NameConf:string;
   Id:string;
   IdPC:string;
   FolderDual: array [1..10] of TFolderDual;
   LineExcept:string;
   PC:string;
   OperacDell:boolean;
   DellBasket:boolean;
   DellСonfirmat:Boolean;
   SaveLog:Boolean;
end;


 IFileCopier = interface
   ['{9ACEC816-5A3F-4BA4-95A2-B3C8CE08B82D}']
   procedure Copy;
   procedure SetProgressBar (const AProgressBar: TProgressBar);
   procedure SetCopyBreak (const ACopyBreak: boolean);
   procedure SetSource (Source: string);
   procedure SetDest (Dest: string);
   property ProgressBar: TProgressBar write SetProgressBar;
   procedure WriteMemoResult (const AMemoResult: TRzRichEdit);
   property MemoResult: TRzRichEdit write WriteMemoResult;
   property CopyBreak: boolean write SetCopyBreak;
   property Source: string write SetSource;
   property Dest: string write SetDest;

 end;

 TFileCopier = class (TInterfacedObject, IFileCopier)
 private
   FSource,FDest: string;
   FProgressBar:TProgressBar;
   FCopyBreak:boolean;
   Flag:DWORD;
   FMemoResult:TRzRichEdit;
   procedure SetPosition (APos:Int64);
 public
   constructor Create;
   procedure Copy;
   procedure SetProgressBar (const AProgressBar: TProgressBar);
   procedure WriteMemoResult (const AMemoResult: TRzRichEdit);
   procedure SetCopyBreak (const ACopyBreak: boolean);
   procedure SetSource (ASource: string);
   procedure SetDest (ADest: string);

 end;

implementation

uses ShellApi, SinhronN;

var AtribFile:TAtrib;

function RandomWord(dictSize, lngStepSize, wordLen, minWordLen: Integer): string;
 begin
   Result := '';
   if (wordLen < minWordLen) and (minWordLen > 0) then
     wordLen := minWordLen
   else if (wordLen < 1) and (minWordLen < 1) then wordLen := 1;
   repeat
     Result := Result + Chr(Random(dictSize) + lngStepSize);
   until (Length(Result) = wordLen);
 end;

function RandomNameFile(St:String;PLen: Integer): string;
 var
   str: string;
 begin
   Randomize;
 //str:= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   str:='A1BCDEF2GHI3JK45LM6NO7PQR8ST9U0VWXYZ';
   Result:=St;
   repeat
     Result:= Result + str[Random(Length(str)) + 1];
   until (Length(Result) = PLen)
 end;

function RandomID(PLen: Integer): string;
 var
   str: string;
 begin
   Randomize;
 //str:= 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
   str:='1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   Result := '';
   repeat
     Result:= Result + str[Random(Length(str)) + 1];
   until (Length(Result) = PLen)
 end;


constructor TFileList.Create;
begin
  inherited
end;


destructor TFileList.destroy;
var j:integer;
begin
  if Count>0 then
   for j:=0 to Count-1 do
    begin
     if Objects[j]<>nil then TAtrib(Objects[j]).Free;
     Objects[j]:=nil;
    end;
  inherited
end;


//====описание класса FileCopier===============================================

constructor TFileCopier.Create;
begin
 FSource:='';FDest:='';FCopyBreak:=false;FMemoResult:=nil;
end;


function CopyCallBack (TotalFileSize,TotalBytesTransferred,StreamSize,
 StreamBytesTransferred: Int64; StreamNumber, CallBackReasom: DWORD; SrcFile,
 DestFile: THandle; FileCopier: TFileCopier): DWORD; stdcall;
begin
 FileCopier.SetPosition(TotalBytesTransferred);
 Application.ProcessMessages;
end;

{ TFileCopier }

procedure TFileCopier.Copy;
 function FileSize (const AFileName: string): Int64;
 var
   sr: TSearchRec;
 begin
    try
     if FindFirst(AFileName, faAnyFile, sr)=0 then Result:=sr.Size
     else
      begin
       FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Файл не найден: '+
                  AFileName,clRed,FmSinhron.Task.SaveLog);
       Result:=-1;
      end;
     except
     FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка доступа к файлу: '+
                AFileName,clRed,FmSinhron.Task.SaveLog);
    end;
   FindClose(sr);
 end;

var w:longbool;
    Size:Integer;
begin
 if FCopyBreak then exit;w:=false;
 if Assigned(FProgressBar) then
 begin
   FProgressBar.Position:=0;
   FProgressBar.Min:=0;
   Size:=FileSize(FSource);
   if Size<0 then exit;
   FProgressBar.Max:=Size;
 end;
 if trunc(FProgressBar.Max/1048576)>200 then flag:=COPY_FILE_NO_BUFFERING else flag:=0;
 try
  w:=CopyFileEx(PChar(FSource),PChar(FDest),@CopyCallback,Self,@FCopyBreak,flag);
   except
   end;
  if (w=false) and (FMemoResult<>nil) then
   if (GetLastError and PROGRESS_CANCEL)<>0 then
     FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Файл не скопирован: '+
                          FSource,clRed,FmSinhron.Task.SaveLog)
   else
    if (GetLastError and ERROR_ACCESS_DENIED)<>0 then
      FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка доступа к файлу: '+
                          FSource,clRed,FmSinhron.Task.SaveLog)
       else FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка копирования файла: '+
                         FSource,clRed,FmSinhron.Task.SaveLog);
 end;

procedure TFileCopier.SetPosition(APos: Int64);
begin
 if Assigned (FProgressBar) then
   FProgressBar.Position := APos
end;

procedure TFileCopier.SetProgressBar(const AProgressBar: TProgressBar);
begin
 FProgressBar := AProgressBar;
 if Assigned (FProgressBar) then
   FProgressBar.Position := 0;
end;

procedure TFileCopier.WriteMemoResult(const AMemoResult: TRzRichEdit);
begin
 if AMemoResult<>nil then FMemoResult:=AMemoResult;
end;

procedure TFileCopier.SetCopyBreak (const ACopyBreak: boolean);
begin
 FCopyBreak:=ACopyBreak;
end;

procedure TFileCopier.SetSource(ASource: string);
begin
 FSource:=ASource;
end;

procedure TFileCopier.SetDest(ADest: string);
begin
 FDest:=ADest;
end;

//====конец описание класса FileCopier=========================================


Function GetHDSerNo: string; export;
var VolumeName, FileSystemName : array [0..MAX_PATH-1] of Char;
    VolumeSerialNo : Cardinal;
    MaxComponentLength, FileSystemFlags : DWORD;
Begin
 Result:='None';
 try
  GetVolumeInformation('C:\',VolumeName,MAX_PATH,@VolumeSerialNo, MaxComponentLength,FileSystemFlags, FileSystemName,MAX_PATH);
  Result:=IntToHex(HiWord(VolumeSerialNo),4)+ '-'+IntToHex(LoWord(VolumeSerialNo),4);
  except on EAbort do;
 end;
end;



function GetFileSize(FileName: String): Int64;
var
 FS: TFileStream;
begin
 FS:=nil;
  try
   FS:=TFileStream.Create(Filename, fmOpenRead);
   Result:=FS.Size;
   except
    FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Не могу открыть файл: '+
    Filename,clRed,FmSinhron.Task.SaveLog);
    Result:=-1;
  end;
   FS.Free;
end;


procedure CopyFileStreamProgress(const AFrom,ATo:String;Attr:Longint; var AProgress: TProgressBar);
const
  BlockSize = 16*1024;
var
  SStream,DStream:TFileStream;
 _Size,SizeCopied:Int64;
Begin
 if not(FileExists(AFrom)) then Exit;
 SizeCopied:=0;
  try
    SStream:=TFileStream.Create(AFrom,fmOpenRead);
    try
     DStream:=TFileStream.Create(ATo,fmCreate);
     if Assigned(AProgress) then AProgress.Max:=SStream.Size;
      Repeat
       if FmSinhron.StopCopy then break;
       _Size:=DStream.CopyFrom(SStream,Min(BlockSize,SStream.Size-SStream.Position));
       SizeCopied:=SizeCopied+_Size;
       if Assigned(AProgress) then
        begin
         AProgress.Position := SizeCopied;
         Application.ProcessMessages;
        end;
        Application.ProcessMessages;
      Until SStream.Position>=SStream.Size;
     finally
      DStream.Free;
      FileSetDate(ATo,Attr);
    end;
   finally
   SStream.Free;
  end;
end;


procedure CopyFileWithProgress(const AFrom,ATo:String;Attr:Longint; var AProgress: TProgressBar);
const
  buflen = 1024*64;
var
  FromF, ToF: File;
  NumRead, NumWritten, DataSize: Integer;
  Buffer: array[0..buflen] of Char;
begin
  try
    DataSize := SizeOf(Buffer);
    AssignFile(FromF, AFrom);FileMode:= fmOpenRead;
    Reset(FromF,1);
    if Assigned(AProgress) then
       AProgress.Max:=FileSize(FromF);
    AssignFile(ToF, ATo);Rewrite(ToF,1);
    repeat
     BlockRead(FromF, Buffer[0], DataSize, NumRead);
     BlockWrite(ToF, Buffer[0], NumRead, NumWritten);
      if Assigned(AProgress) then
      begin
        AProgress.Position := AProgress.Position + DataSize;
        Application.ProcessMessages;
      end;
    until (NumRead = 0) or (NumWritten <> NumRead);
   finally
    CloseFile(FromF);
    CloseFile(ToF);
    FileSetDate(ATo,Attr);
  end;
end;


//создание списка файлов в список List
procedure ScanFile(StartDir: string; Mask:string; List:TStrings);
var SearchRec : TSearchRec;
    FHandle: Integer;
begin
 if FindFirst(StartDir+Mask,faAnyFile,SearchRec)=0 then
  begin
    repeat
      Application.ProcessMessages;
      if ((SearchRec.Attr and faDirectory) <> faDirectory) and
        ((SearchRec.Name <> '..') and (SearchRec.Name <> '.')) then
       begin
        AtribFile:=TAtrib.Create;
        AtribFile.FileDataTime:=SearchRec.TimeStamp;
//        FileAge(StartDir + SearchRec.Name);
//        AtribFile.SizeFile:=GetFileSize(StartDir + SearchRec.Name);
        AtribFile.SizeFile:=SearchRec.Size;
        AtribFile.Nature:=1;
        AtribFile.Action:='';
        List.AddObject(StartDir + SearchRec.Name,AtribFile);
       end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;


//создание списка каталогов, файлов или каталогов + файлы в список List
procedure ScanDisk(StartDir: string; Mask:string; List:TStrings;Fst:word);
var SearchRec : TSearchRec;

begin
// Fst 0 все вложенные папки и файлы;
// Fst 1 все вложенные папки
// Fst 2 файлы в указанной папке

 if Fst<5 then
  begin
   if Mask='' then Mask:= '*.*';
   if StartDir[Length(StartDir)] <> '\' then StartDir:= StartDir + '\';
  end;
 if Fst=2 then begin ScanFile(StartDir,Mask,List);exit; end;
 if Fst=0 then ScanFile(StartDir,Mask,List);
 Fst:=Fst+5;
 if FindFirst(StartDir+'*.*', faDirectory+faHidden+faSysFile, SearchRec) = 0 then
  begin
    repeat
     if (SearchRec.Attr and faDirectory) = faDirectory then
      if (SearchRec.Name <> '..') and (SearchRec.Name <> '.') then
       begin
        if Fst<>6 then ScanFile(StartDir + SearchRec.Name + '\',Mask,List);
        ScanDisk(StartDir + SearchRec.Name + '\',Mask,List,Fst);
       end
      else
       if (SearchRec.Name = '..') then
        begin
          AtribFile:=TAtrib.Create;
//          AtribFile.FileDataTime:=FileAge(StartDir + SearchRec.Name);
          AtribFile.FileDataTime:=SearchRec.TimeStamp;
          AtribFile.Nature:=0;
          AtribFile.action:='';
          List.AddObject(StartDir + SearchRec.Name,AtribFile);
        end;
      Application.ProcessMessages;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
end;

function DelDir(dir: string;ToRecycle:boolean;Progress:boolean): Boolean;
var
  fos: TSHFileOpStruct;
begin
 FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Удаление папки: '+
                  dir,clGreen,FmSinhron.Task.SaveLog);Result:=false;
  try
   ZeroMemory(@fos, SizeOf(fos));
   with fos do
    begin
     wFunc:=FO_DELETE;
     fFlags:=FOF_NOCONFIRMATION;
     if Progress then fFlags:=fFlags or FOF_SIMPLEPROGRESS
      else fFlags:=fFlags or FOF_SILENT;
     if ToRecycle then  fFlags :=fFlags or FOF_ALLOWUNDO;
     pFrom  := PChar(dir + #0);
    end;
    Application.ProcessMessages;
    Result:=(0 = ShFileOperation(fos));
    except
   on Exception do
      FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка удаления папки: '+
                           dir,clRed,FmSinhron.Task.SaveLog);
  end;
end;

function DelFiles(const FileName: string;ToRecycle:boolean): Boolean;
var
  fos: TSHFileOpStruct;
begin
  try
   ZeroMemory(@fos, SizeOf(fos));
   with fos do
    begin
     wFunc:=FO_DELETE;
     pFrom:=PChar(FileName+#0);
     fFlags:=FOF_NOERRORUI or FOF_SILENT or FOF_NOCONFIRMATION;
     if ToRecycle then fFlags:=fFlags or FOF_ALLOWUNDO;
    end;
    Application.ProcessMessages;
    Result := (SHFileOperation(fos) = 0) and (not fos.fAnyOperationsAborted);
    except
   on Exception do
     FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка удаления файла: '+
                                FileName,clRed,FmSinhron.Task.SaveLog);
  end;
end;

end.
 function FileSize (const AFileName: string): Int64;
 var
   FS: TFileStream;
   sr: TSearchRec;
 begin
  try
   if FindFirst(AFileName, faAnyFile, sr)=0 then Result:=sr.Size
   else
    begin
     FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Файл не найден: '+AFileName,clRed);
     Result:=-1;
    end;
   except
   FmSinhron.AddEchoText(FmSinhron.RzRichEditEchoCom,'Ошибка доступа к файлу: '+AFileName,clRed);
  end
   FindClose(sr);
 end;
