unit form_find;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ButtonPanel,
  StdCtrls, IniFiles, file_proc;

type

  { TfmFind }

  TfmFind = class(TForm)
    bCount: TButton;
    bMarkAll: TButton;
    bFind: TButton;
    bCancel: TButton;
    bRep: TButton;
    bRepAll: TButton;
    chkInSel: TCheckBox;
    chkFromCaret: TCheckBox;
    chkConfirm: TCheckBox;
    chkRep: TCheckBox;
    chkRegex: TCheckBox;
    chkBack: TCheckBox;
    chkCase: TCheckBox;
    chkWords: TCheckBox;
    edFind: TComboBox;
    edRep: TEdit;
    Label1: TLabel;
    procedure bFindClick(Sender: TObject);
    procedure chkRegexChange(Sender: TObject);
    procedure chkRepChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure Update; reintroduce;
    { private declarations }
  public
    procedure LoadSearchText;
    procedure SaveSearchText;
    { public declarations }
  end;

var
  fmFind: TfmFind;
  SearchTextIniFilename: string = '';
  SearchTextSection: string = 'SearchText';

implementation

{$R *.lfm}

{ TfmFind }

procedure TfmFind.LoadSearchText;
var
  I: TIniFile;
  L: TStringList;
  X: Integer;
  V: String;
begin
  //ShowMessage(ChangeFileExt(_GetDllFilename, '.ini'));

  SearchTextIniFilename:= ChangeFileExt(_GetDllFilename, '.ini');
  I:= TIniFile.Create(SearchTextIniFilename);
  try
    L:= TStringList.Create;
    try
      edFind.Items.Clear;
      //edFind.ItemHeight:=32;
      I.ReadSection(SearchTextSection, L);
      for X:= 0 to L.Count-1 do begin
        V:= I.ReadString(SearchTextSection, L[X], '');
        if V <> '' then edFind.Items.Add(V);
      end;
    finally
      L.Free;
    end;
  finally
    I.Free;
  end;
end;

procedure TfmFind.SaveSearchText;
var
  I: TIniFile;
  H, X ,J: Integer;
  V: String;
begin

  I:= TIniFile.Create(SearchTextIniFilename);
  J:= 0;
  try
    if edFind.Text <> '' then
    begin
      I.WriteString(SearchTextSection, IntToStr(0), edFind.Text);
      if edFind.Items.Count < 9 then H:=edFind.Items.Count else H:=9;
      for X:= 0 to H - 1 do
      begin
        V:= edFind.Items[X];
        if V <> edFind.Text then
        begin
          I.WriteString(SearchTextSection, IntToStr(J + 1), V);
          J:= J + 1;
        end;
      end;
    end;
  finally
    I.Free;
  end;
end;

procedure TfmFind.chkRegexChange(Sender: TObject);
begin
  Update;
end;

procedure TfmFind.bFindClick(Sender: TObject);
begin
  SaveSearchText;
end;

procedure TfmFind.chkRepChange(Sender: TObject);
begin
  Update;
end;

procedure TfmFind.FormShow(Sender: TObject);
begin
  LoadSearchText;
  Update;
end;

procedure TfmFind.Update;
var
  rep: boolean;
begin
  rep:= chkRep.Checked;

  chkWords.Enabled:= not chkRegex.Checked;
  chkBack.Enabled:= not chkRegex.Checked;
  chkConfirm.Enabled:= rep;
  edRep.Enabled:= rep;
  bFind.Visible:= not rep;
  bRep.Visible:= rep;
  bRepAll.Visible:= rep;

  if rep then
    Caption:= '替换'
  else
    Caption:= '查找';

  if rep then
    bRep.Default:= true
  else
    bFind.Default:= true;
end;

end.

