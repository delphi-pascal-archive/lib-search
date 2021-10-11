library Project2;
uses
  SysUtils,
  Classes,
  Windows;

var
    SLdir,SLhdd,SLcoi:TStringList;

{$R *.res}

function RuLowerCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if ((Ch >= 'A') and (Ch <= 'Z')) or ((Ch >= 'À') and (Ch <= 'ß')) then Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function SLCrtDes(CnD:boolean):boolean;
begin
if CnD = true then
  begin
    SLdir:=TStringList.Create;
    SLcoi:=TStringList.Create;
    SLdir.Clear;
    SLcoi.Clear;
  end else begin
    SLdir.Destroy;
    SLcoi.Destroy;
  end;
end;

function DirOrNot(iItem: String):boolean;
var i: integer;
begin
DirOrNot:=true;
  for i:=1 to Length(iItem) do
    begin
      if iItem[i] = '.' then DirOrNot:=false;
    end;
end;

function HDDListCrt:boolean;
var
    x: int64;
    bit,i: byte;
begin
SLhdd:=TStringList.Create;
SLhdd.Clear;
x:=GetLogicalDrives();
if x<>0 then
  begin
    for i:=1 to 64 do
      begin
        bit:=x and 1;
        if bit=1 then SLhdd.Add(chr(64+i));
        x:= x shr 1;
      end;
  end;
end;

function FDSearch(inDir,dName:String; iStart:Integer):boolean;
var
  F: TSearchRec;
  Path: string;
begin
repeat
if iStart>-1 then inDir:=SLdir.Strings[iStart];
  Path := inDir + '\*.*';
  FindFirst(Path, faAnyFile, F);
  if F.name <> '' then
  begin
        if DirOrNot(F.name) = true then SLdir.Add(inDir+'\'+F.name)
        else if (F.Name<>'.') and  (F.Name<>'..') then
                begin
                  if RuLowerCase(dName)=RuLowerCase(F.Name) then
                    begin
                      SLcoi.Add(inDir+'\'+F.Name);
                    end;
                end;
    while FindNext(F) = 0 do
      begin
    if DirOrNot(F.name) = true then SLdir.Add(inDir+'\'+F.name)
        else if (F.Name<>'.') and  (F.Name<>'..') then
                begin
                  if RuLowerCase(dName)=RuLowerCase(F.Name) then
                    begin
                      SLcoi.Add(inDir+'\'+F.Name);
                    end;
                end;
      end;
  end;
  SysUtils.FindClose(F);
  iStart:=iStart+1;
  until iStart > SLdir.Count-1;
end;

function Search(dDir,dName:String; LstItem:Integer):ShortString export; stdcall;
var i:integer;
begin
SLCrtDes(true);
if RuLowerCase(dDir) = RuLowerCase('*') then
  begin
    HDDListCrt;
    for i:=0 to SLHdd.Count-1 do SLdir.Add(SLhdd.Strings[i]+':');
    FDSearch(dDir,dName,0);
    Slhdd.Destroy;
  end else FDSearch(dDir,dName,-1);
if LstItem<SLcoi.Count then Search:=SLcoi.Strings[LstItem]
  else begin
    Search:='?';
    SLCrtDes(false);
  end;
end;

function HDDlist(LstItem:Integer):ShortString export; stdcall;
begin
HDDListCrt;
    if LstItem<SLhdd.Count then HDDList:=SLhdd.Strings[LstItem];
    if LstItem>=SLhdd.Count then HDDList:='?';
SLhdd.Destroy;
end;

exports Search name 'Search';
exports HDDlist name 'HDDlist';

begin
end.
