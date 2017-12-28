unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin, Ufigures, Utools, UdPoints, Uoptions,
  Fpjson, jsonparser, Clipbrd;

type

  { TFgraphics }

  TFgraphics = class(TForm)
    Mcut: TMenuItem;
    Mcopy: TMenuItem;
    Mput: TMenuItem;
    MenuItem5: TMenuItem;
    Mundo: TMenuItem;
    Medit: TMenuItem;
    MenuItem1: TMenuItem;
    Mbackground: TMenuItem;
    MsaveAs: TMenuItem;
    Mopen: TMenuItem;
    Msave: TMenuItem;
    Mtot: TMenuItem;
    MselectAll: TMenuItem;
    MselectUndone: TMenuItem;
    MselectDelete: TMenuItem;
    MselectGround: TMenuItem;
    Mforeground: TMenuItem;
    MenuItem7: TMenuItem;
    Mhome: TMenuItem;
    Meraseall: TMenuItem;
    Mredo: TMenuItem;
    Minformation: TMenuItem;
    Mreference: TMenuItem;
    Mexit: TMenuItem;
    Mfile: TMenuItem;
    Mmenu: TMainMenu;
    Dopen: TOpenDialog;
    PNzoom: TPanel;
    PNfigures: TPanel;
    PNtool: TPanel;
    PBdraw: TPaintBox;
    Dsave: TSaveDialog;
    ScrolHoriz: TScrollBar;
    ScrolVert: TScrollBar;
    PanelOptions: TPanel;
    TpenStyleSelect: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure McopyClick(Sender: TObject);
    procedure McutClick(Sender: TObject);
    procedure MputClick(Sender: TObject);
    procedure MundoClick(Sender: TObject);
    procedure MbackgroundClick(Sender: TObject);
    procedure MeraseallClick(Sender: TObject);
    procedure MexitClick(Sender: TObject);
    procedure MforegroundClick(Sender: TObject);
    procedure MhomeClick(Sender: TObject);
    procedure MinformationClick(Sender: TObject);
    procedure MopenClick(Sender: TObject);
    procedure MredoClick(Sender: TObject);
    procedure MsaveAsClick(Sender: TObject);
    procedure MsaveClick(Sender: TObject);
    procedure MselectAllClick(Sender: TObject);
    procedure MselectDeleteClick(Sender: TObject);
    procedure MselectUndoneClick(Sender: TObject);
    procedure PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawPaint(Sender: TObject);
    procedure ToolBtnClick(ASender: TObject);
    function ButtonCreate(Fstart, Ffinish: TPoint; Num: integer;
      Aparent: TPanel): TButton;
    procedure CreatePanel;
    procedure ChangeScrols;
    procedure TpenStyleSelectTimer(Sender: TObject);
  private

  public

  end;

function SavePic(Ar: array of Tfigure; ind: byte): string;
procedure OpenPic(str: string);
procedure PushS(val: string);

var
  Fgraphics: TFgraphics;
  Drawing: boolean;
  StekStr: array[0..500] of string;
  head, tail, reserv: qword;

implementation

{$R *.lfm}

procedure TFgraphics.ToolBtnClick(ASender: TObject);
var
  i: integer;
begin
  ToolNum := (ASender as TButton).Tag;
  PanelOptions.Free;
  CreatePanel;
  PanelOptions.Visible := False;
  for i := High(ToolList[ToolNum].Options) downto Low(ToolList[ToolNum].Options) do
  begin
    ToolList[ToolNum].Options[i].ToControls(PanelOptions).Align := alTop;
    ToolList[ToolNum].Options[i].ToLabels(PanelOptions).Align := alTop;
  end;
  PanelOptions.Visible := True;
  if ToolNum <> 8 then
    SetLength(SelectFig, 0);
end;

procedure PushS(val: string);
begin
  if StekStr[head] <> val then
  begin
    if head = high(StekStr) then
    begin
      head := 0;
      tail += 1;
    end
    else
      head += 1;
    if head = tail then
      if tail = high(StekStr) then
        tail := 0
      else
        tail += 1;
    reserv := 0;
    StekStr[head] := val;
  end;
end;

procedure TFgraphics.ChangeScrols;
begin
  ScrolHoriz.Min := round(MinPoint.X);
  ScrolHoriz.Max := round(MaxPoint.X);
  ScrolVert.Min := round(MinPoint.Y);
  ScrolVert.Max := round(MaxPoint.Y);
  //////////////////
end;

procedure TFgraphics.TpenStyleSelectTimer(Sender: TObject);
var
  j: integer;
begin
  if Length(SelectFig) > 0 then
  begin
    if SelectFig[High(SelectFig)].ClassType = Tselect then
      if (SelectFig[High(SelectFig)] as Tselect).i < 4 then
        (SelectFig[High(SelectFig)] as Tselect).i += 1
      else
        (SelectFig[High(SelectFig)] as Tselect).i := 1;
    if changeOp then
    begin
      for j := 0 to High(SelectFig) - 1 do
      begin
        SelectFig[j].PenColor := gOptions.gPenColor;
        SelectFig[j].Pstyle := gOptions.gPstyle.Akind;
        SelectFig[j].Width := gOptions.gWidth;
        if PanelOptions.ComponentCount > 6 then
        begin
          if SelectFig[j].ClassType = Tellipce then
          begin
            (SelectFig[j] as Tellipce).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as Tellipce).FillColor := gOptions.gFillColor;
          end
          else
          if SelectFig[j].ClassType = Trectangle then
          begin
            (SelectFig[j] as Trectangle).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as Trectangle).FillColor := gOptions.gFillColor;
          end
          else
          if SelectFig[j].ClassType = TroundRect then
          begin
            (SelectFig[j] as TroundRect).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as TroundRect).FillColor := gOptions.gFillColor;
            (SelectFig[j] as TroundRect).Round := gOptions.gRound;
          end;
        end;
      end;
      SetLength(SelectFig, High(SelectFig));
      CreateHighSelectFig;
      changeOp := False;
      PushS(SavePic(Figures, 0));
    end;
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.CreatePanel;
begin
  PanelOptions := TPanel.Create(Fgraphics);
  PanelOptions.Parent := Fgraphics.PNtool;
  PanelOptions.Width := Fgraphics.PNtool.Width;
  PanelOptions.Left := 0;
  PanelOptions.Top := Fgraphics.PNfigures.Height;
  PanelOptions.Height := Fgraphics.PNtool.Height -
    (Fgraphics.PNzoom.Height + Fgraphics.PNfigures.Height);
end;

function TFgraphics.ButtonCreate(Fstart, Ffinish: TPoint; Num: integer;
  Aparent: TPanel): TButton;
begin
  Result := TButton.Create(Fgraphics);
  with Result do
  begin
    Parent := Aparent;
    Left := Fstart.x;
    Top := Fstart.y;
    Width := Ffinish.x;
    Height := Ffinish.y;
    Tag := Num;
    OnClick := @ToolBtnClick;
    Caption := ToolList[Num].ToolName;
  end;
end;

procedure TFgraphics.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Drawing := False;
  SetLength(Figures, 1);
  SetLength(SelectFig, 0);
  head := 0;
  tail := 0;
  reserv := 0;
  Brush.Color := clWhite;
  Figures[0] := Trectangle.Create;
  Figures[0].Dpoints[0] := ScreenToWorld(Point(0, 0));
  Figures[0].Dpoints[1] := ScreenToWorld(Point(PBdraw.Width, PBdraw.Height));
  PushS(SavePic(Figures, 0));
  ToolNum := 0;
  CreatePanel;
  ButtonCreate(Point(10, 10), Point(100, 30), 0, PNfigures).Click;
  for i := 1 to 4 do
    ButtonCreate(Point(10, i * 40 + 10), Point(100, 30), i, PNfigures).Align := alNone;
  for i := 5 to 8 do
    ButtonCreate(Point(10, (i - 5) * 40 + 10), Point(95, 30), i, PNzoom).Align := alNone;
  Offset.X := 0;
  Offset.Y := 0;
  Scale := 1;
  RectScaleWight := PBdraw.Width;
  RectScaleHeight := PBdraw.Height;
end;

procedure TFgraphics.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  case MessageDlg('Сохранить файл?', mtConfirmation, mbYesNoCancel, 0) of
    6:
      MsaveClick(Sender);
    2:
      exit;
  end;
end;

procedure TFgraphics.FormResize(Sender: TObject);
begin
  RectScaleWight := PBdraw.Width;
  RectScaleHeight := PBdraw.Height;
  PanelOptions.Height := Fgraphics.PNtool.Height -
    (Fgraphics.PNzoom.Height + Fgraphics.PNfigures.Height);
end;

procedure TFgraphics.McopyClick(Sender: TObject);
begin
  Clipboard.AsText := SavePic(SelectFig, 1);
end;

procedure TFgraphics.McutClick(Sender: TObject);
begin
  McopyClick(Sender);
  MselectDeleteClick(Sender);
end;

procedure TFgraphics.MputClick(Sender: TObject);
var
  s: string;
begin
  s := Clipboard.AsText;
  OpenPic(s);
  PushS(SavePic(Figures, 0));
end;

procedure TFgraphics.MexitClick(Sender: TObject);
begin
  Fgraphics.Close;
end;

procedure TFgraphics.MforegroundClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(Figures, Length(Figures) + High(SelectFig));
      for i := Length(Figures) - High(SelectFig) to High(Figures) do
        Figures[i] := SelectFig[i - Length(Figures) + High(SelectFig)];
      PushS(SavePic(Figures, 0));
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MhomeClick(Sender: TObject);
begin
  ChangeMaxMinPoint;
  MinPoint.x -= 10;
  MinPoint.y -= 10;
  MaxPoint.x += 10;
  MaxPoint.y += 10;
  RectScale(MinPoint, MaxPoint);
  PushS(SavePic(Figures, 0));
  PBdraw.Invalidate;
end;

procedure TFgraphics.MundoClick(Sender: TObject);
begin
  if ((head = 0) and (tail = 0)) or (head - 1 <> tail) then
  begin
    if head = 0 then
      head := high(StekStr)
    else
      head -= 1;
    reserv += 1;
    Scale := 1;
    SetLength(SelectFig, 0);
    SetLength(Figures, 1);
    OpenPic(StekStr[head]);
  end;
end;

procedure TFgraphics.MbackgroundClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(Figures, Length(Figures) + High(SelectFig));
      for i := High(Figures) - High(SelectFig) downto 1 do
        Figures[i + High(SelectFig)] := Figures[i];
      for i := 1 to High(SelectFig) do
        Figures[i] := SelectFig[i - 1];
      PushS(SavePic(Figures, 0));
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MredoClick(Sender: TObject);
begin
  if (reserv <> 0) and (head + 1 <> tail) then
  begin
    if head = high(StekStr) then
      head := 0
    else
      head += 1;
    reserv -= 1;
    Scale := 1;
    SetLength(SelectFig, 0);
    SetLength(Figures, 1);
    OpenPic(StekStr[head]);
  end;
end;


function SavePic(Ar: array of Tfigure; ind: byte): string;
var
  i, j: integer;
  s: string;
begin
  s := '{"Num": ' + High(Ar).ToString + ', "Figures":[';
  for i := 1 to High(Ar) do
    with Ar[i - ind] do
    begin
      s += '{ "Type": "' + FigureName + '",';
      s += '"PenColor": "' + ColorToString(PenColor) + '", ';
      s += '"Width": ' + Width.ToString + ', ';
      s += '"PenStyle": "' + PsToStr(Pstyle) + '", ';
      s += SaveOption();
      s += '"NumPoint": ' + High(Dpoints).ToString + ', "Points":[ ';
      for j := 0 to High(Dpoints) do
      begin
        s += WorldToScreen(Dpoints[j]).x.ToString + ', ';
        if (((ind = 0) and (i = High(Ar))) or ((ind = 1) and (i > High(Ar) - ind))) and
          (j = High(Dpoints)) then
          s += WorldToScreen(Dpoints[High(Dpoints)]).y.ToString + ']}'
        else
        if j = High(Dpoints) then
          s += WorldToScreen(Dpoints[High(Dpoints)]).y.ToString + ']}, '
        else
          s += WorldToScreen(Dpoints[j]).y.ToString + ', ';
      end;
    end;
  s += ']}';
  Result := s;
end;

procedure TFgraphics.MsaveAsClick(Sender: TObject);
var
  fSave: Text;
begin
  if Dsave.Execute then
  begin
    AssignFile(fSave, Dsave.FileName);
    Rewrite(fSave);
    Write(fSave, SavePic(Figures, 0));
    CloseFile(fSave);
    Fgraphics.Caption := Dsave.FileName;
  end;
end;

procedure TFgraphics.MsaveClick(Sender: TObject);
var
  fSave: Text;
begin
  if Fgraphics.Caption <> 'Графический редактор' then
  begin
    AssignFile(fSave, Fgraphics.Caption);
    Rewrite(fSave);
    Write(fSave, SavePic(Figures, 0));
    CloseFile(fSave);
  end
  else
    MsaveAsClick(Sender);
end;

procedure OpenPic(str: string);
var
  jData: TJSONData;
  s: string;
  Apoint: TPoint;
  i, j: integer;
begin
  try
    jData := GetJSON(str);
  except
    ShowMessage('файл поврежден, возможно вами, возможно намеренно...');
    exit;
  end;
  for i := 1 to jData.FindPath('Num').AsInteger do
  begin
    SetLength(Figures, Length(Figures) + 1);
    s := 'Figures[' + IntToStr(i - 1) + '].Type';
    case jData.FindPath(s).AsString of
      'Tline':
        Figures[High(Figures)] := Tline.Create;
      'Trectangle':
      begin
        Figures[High(Figures)] := Trectangle.Create;
        s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
        (Figures[High(Figures)] as Trectangle).FillColor :=
          StringToColor(jData.FindPath(s).AsString);
        s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
        (Figures[High(Figures)] as Trectangle).Bstyle :=
          StringToBrushStyle(jData.FindPath(s).AsString);
      end;
      'TroundRect':
      begin
        Figures[High(Figures)] := TroundRect.Create;
        s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
        (Figures[High(Figures)] as TroundRect).FillColor :=
          StringToColor(jData.FindPath(s).AsString);
        s := 'Figures[' + IntToStr(i - 1) + '].Round';
        (Figures[High(Figures)] as TroundRect).Round := jData.FindPath(s).AsInteger;
        s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
        (Figures[High(Figures)] as TroundRect).Bstyle :=
          StringToBrushStyle(jData.FindPath(s).AsString);
      end;
      'Tellipce':
      begin
        Figures[High(Figures)] := Tellipce.Create;
        s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
        (Figures[High(Figures)] as Tellipce).FillColor :=
          StringToColor(jData.FindPath(s).AsString);
        s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
        (Figures[High(Figures)] as Tellipce).Bstyle :=
          StringToBrushStyle(jData.FindPath(s).AsString);
      end;
      'Tpolyline':
        Figures[High(Figures)] := Tpolyline.Create;
    end;
    with Figures[High(Figures)] do
    begin
      SetLength(Dpoints, 0);
      s := 'Figures[' + IntToStr(i - 1) + '].NumPoint';
      for j := 0 to jData.FindPath(s).AsInteger do
      begin
        SetLength(Dpoints, Length(Dpoints) + 1);
        s := 'Figures[' + IntToStr(i - 1) + '].Points[' + IntToStr(j * 2) + ']';
        Apoint.x := jData.FindPath(s).AsInteger;
        s := 'Figures[' + IntToStr(i - 1) + '].Points[' + IntToStr(j * 2 + 1) + ']';
        Apoint.y := jData.FindPath(s).AsInteger;
        Dpoints[j] := ScreenToWorld(Apoint);
      end;
      s := 'Figures[' + IntToStr(i - 1) + '].PenColor';
      PenColor := StringToColor(jData.FindPath(s).AsString);
      s := 'Figures[' + IntToStr(i - 1) + '].Width';
      Width := jData.FindPath(s).AsInteger;
      s := 'Figures[' + IntToStr(i - 1) + '].PenStyle';
      Pstyle := StringToPenStyle(jData.FindPath(s).AsString);
    end;
  end;
  //  Fgraphics.Caption := Dopen.FileName;
  jData.Free;
  Fgraphics.PBdraw.Invalidate;
end;

procedure TFgraphics.MopenClick(Sender: TObject);
var
  fOpen: Text;
  s: string;
begin
  if Dopen.Execute then
  begin
    AssignFile(fOpen, Dopen.FileName);
    Reset(fOpen);
    Read(fOpen, s);
    CloseFile(fOpen);
    Scale := 1;
    SetLength(SelectFig, 0);
    SetLength(Figures, 1);
    OpenPic(s);
  end;
end;

procedure TFgraphics.MselectAllClick(Sender: TObject);
var
  i: integer;
begin
  SetLength(SelectFig, 0);
  SetLength(SelectFig, High(Figures));
  for i := 1 to High(Figures) do
    SelectFig[i - 1] := Figures[i];
  CreateHighSelectFig;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MselectDeleteClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(SelectFig, 0);
      PushS(SavePic(Figures, 0));
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MselectUndoneClick(Sender: TObject);
begin
  SetLength(SelectFig, 0);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MeraseallClick(Sender: TObject);
begin
  SetLength(Figures, 1);
  SetLength(SelectFig, 0);
  PushS(SavePic(Figures, 0));
  PBdraw.Invalidate;
end;

procedure TFgraphics.MinformationClick(Sender: TObject);
begin
  ShowMessage('Графический редактор. Сделала - Вотинцева Даша. В 2017 году)');
end;

procedure TFgraphics.PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if (button = mbLeft) or (Button = mbRight) then
  begin
    Drawing := True;
    ToolList[ToolNum].MouseDown(x, y);
  end;
  if (Length(SelectFig) > 0) and (ToolNum <> 8) then
    SetLength(SelectFig, 0);
end;

procedure TFgraphics.PBdrawMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if (Drawing) then
  begin
    ToolList[ToolNum].MouseMove(x, y);
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
    ToolList[ToolNum].MouseUp(x, y, True, PanelOptions);
  if Button = mbRight then
    ToolList[ToolNum].MouseUp(x, y, False, PanelOptions);
  changeOp := False;
  Drawing := False;
  if Length(SelectFig) = 0 then
    PushS(SavePic(Figures, 0));
  PBdraw.Invalidate;
end;

procedure TFgraphics.PBdrawPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to High(Figures) do
    Figures[i].Draw(PBdraw.Canvas);
  if Length(SelectFig) > 0 then
  begin
    SelectFig[High(SelectFig)].Draw(PBdraw.Canvas);
    DrawAnchors(PBdraw.Canvas);
  end;
end;

end.
