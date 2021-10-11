unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    ListBox2: TListBox;
    GroupBox2: TGroupBox;
    ListBox1: TListBox;
    Button2: TButton;
    Label4: TLabel;
    Image1: TImage;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  function Search(dDir,dName:String; LstItem:Integer):ShortString stdcall; external 'Project2.dll' name 'Search';
  function HDDlist(LstItem:Integer):ShortString stdcall; external 'Project2.dll' name 'HDDlist';

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
begin
ListBox2.Clear;
Button1.Enabled:=false;
for i:=0 to MaxInt do
    if Search(Edit1.Text,Edit2.Text,i)='?' then
      begin Button1.Enabled:=true; exit; end
        else ListBox2.Items.Add(Search(Edit1.Text,Edit2.Text,i));
end;

procedure TForm1.Button2Click(Sender: TObject);
var i:byte;
begin
ListBox1.Clear;
for i:=0 to 255 do
    if HDDlist(i)='?' then exit else ListBox1.Items.Add(HDDlist(i));
end;

end.
