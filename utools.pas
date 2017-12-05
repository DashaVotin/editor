unit Utools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, Math, Ufigures, UdPoints, Uoptions;

type

  Ttools = class
    ToolName: string;
    Options: array of Toptions;
    procedure MouseDown(x, y: integer); virtual; abstract;
    procedure MouseUp(x, y: integer; Left: boolean; Apanel: TPanel); virtual;
    procedure MouseMove(x, y: integer); virtual;
  end;

  TlineTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    constructor Create;
  end;

  TrectangleTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    constructor Create;
  end;

  TroundRectTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    constructor Create;
  end;

  TellipceTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    constructor Create;
  end;

  TpolyLineTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    procedure MouseMove(x, y: integer); override;
    constructor Create;
  end;

  TloupeTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    procedure MouseUp(x, y: integer; Left: boolean; Apanel: TPanel); override;
    constructor Create;
  end;

  ThandTool = class(Ttools)
    StartOffset, StartPoint: TdoublePoint;
    procedure MouseDown(x, y: integer); override;
    procedure MouseMove(x, y: integer); override;
    constructor Create;
  end;

  TselectTool = class(Ttools)
    procedure MouseDown(x, y: integer); override;
    procedure MouseUp(x, y: integer; Left: boolean; Apanel: TPanel); override;
    constructor Create;
  end;

procedure ChangeMaxMinPoint;
procedure CreateHighSelectFig;
function MinToolNum(sel: array of Tfigure): integer;

var
  ToolNum: integer;
  ToolList: array of Ttools;
  Figures, SelectFig: array of Tfigure;
  MaxPoint, MinPoint: TdoublePoint;

implementation

function MinToolNum(sel: array of Tfigure): integer;
var i: integer;
begin
  for i := 0 to High(sel) do
  begin
    if (sel[i].FigureName = 'Tline') or (sel[i].FigureName = 'Tpolyline') then
    begin
      Result := 0;
      exit;
    end;
    if (sel[i].FigureName = 'Trectangle') or (sel[i].FigureName = 'Tellipce') then
    begin
      Result := 2;
      continue;
    end
    else
      Result := 3;
  end;
end;


procedure ChangeMaxMinPoint;
var
  i, j: integer;
begin
  MaxPoint := Figures[1].Dpoints[0];
  MinPoint := Figures[1].Dpoints[0];
  for i := 1 to High(Figures) do
    with Figures[i] do
      for j := 0 to High(Dpoints) do
      begin
        if MaxPoint.X < Dpoints[j].X then
          MaxPoint.X := Dpoints[j].X;
        if MaxPoint.Y < Dpoints[j].Y then
          MaxPoint.Y := Dpoints[j].Y;
        if MinPoint.X > Dpoints[j].X then
          MinPoint.X := Dpoints[j].X;
        if MinPoint.Y > Dpoints[j].Y then
          MinPoint.Y := Dpoints[j].Y;
      end;
end;

procedure CreateHighSelectFig;
var
  maxs, mins: TdoublePoint;
  i, j: integer;
begin
  Maxs.X := SelectFig[0].Dpoints[0].X + SelectFig[0].Width / 2;
  Maxs.Y := SelectFig[0].Dpoints[0].Y + SelectFig[0].Width / 2;
  Mins.X := SelectFig[0].Dpoints[0].X - SelectFig[0].Width / 2;
  Mins.Y := SelectFig[0].Dpoints[0].Y - SelectFig[0].Width / 2;
  for i := 0 to High(SelectFig) do
    with SelectFig[i] do
      for j := 0 to High(Dpoints) do
      begin
        if Maxs.X < Dpoints[j].X + Width / 2 then
          Maxs.X := Dpoints[j].X + Width / 2;
        if Maxs.Y < Dpoints[j].Y + Width / 2 then
          Maxs.Y := Dpoints[j].Y + Width / 2;
        if Mins.X > Dpoints[j].X - Width / 2 then
          Mins.X := Dpoints[j].X - Width / 2;
        if Mins.Y > Dpoints[j].Y - Width / 2 then
          Mins.Y := Dpoints[j].Y - Width / 2;
      end;
  Maxs.X += INDENT;
  Maxs.Y += INDENT;
  Mins.X -= INDENT;
  Mins.Y -= INDENT;
  SetLength(SelectFig, Length(SelectFig) + 1);
  SelectFig[High(SelectFig)] := Tselect.Create;
  SelectFig[High(SelectFig)].Dpoints[0] := mins;
  SelectFig[High(SelectFig)].Dpoints[1] := maxs;
end;

procedure ThandTool.MouseMove(x, y: integer);
begin
  Offset.X := StartOffset.X + StartPoint.X - x;
  Offset.Y := StartOffset.Y + StartPoint.Y - y;
end;

procedure Ttools.MouseMove(x, y: integer);
begin
  SetLength(Figures[High(Figures)].Dpoints, 2);
  Figures[High(Figures)].Dpoints[1] := ScreenToWorld(Point(x, y));
end;

procedure TpolylineTool.MouseMove(x, y: integer);
begin
  SetLength(Figures[High(Figures)].Dpoints, Length(Figures[High(Figures)].Dpoints) + 1);
  Figures[High(Figures)].Dpoints[High(Figures[High(Figures)].Dpoints)] :=
    ScreenToWorld(Point(x, y));
end;

procedure Ttools.MouseUp(x, y: integer; Left: boolean; Apanel: TPanel);
begin
  ChangeMaxMinPoint;
end;

procedure TselectTool.MouseUp(x, y: integer; Left: boolean; Apanel: TPanel);
var
  i, j, Num: integer;
  highFmin, highFmax, highDmin, highDmax: TdoublePoint;
begin
  highFmin.X := Min(Figures[High(Figures)].Dpoints[0].X,
    Figures[High(Figures)].Dpoints[1].X);
  highFmax.X := Max(Figures[High(Figures)].Dpoints[0].X,
    Figures[High(Figures)].Dpoints[1].X);
  highFmin.Y := Min(Figures[High(Figures)].Dpoints[0].Y,
    Figures[High(Figures)].Dpoints[1].Y);
  highFmax.Y := Max(Figures[High(Figures)].Dpoints[0].Y,
    Figures[High(Figures)].Dpoints[1].Y);
  if (highFmin.X = highFmax.X) then
  begin
    for i := High(Figures) - 1 downto 1 do
      if Figures[i].OnePointSelect(x, y) then
      begin
        SetLength(SelectFig, Length(SelectFig) + 1);
        SelectFig[High(SelectFig)] := Figures[i];
        break;
      end;
  end
  else
  begin
    for i := 1 to High(Figures) - 1 do
    begin
      highDmax := Figures[i].Dpoints[0];
      highDmin := Figures[i].Dpoints[0];
      for j := 0 to High(Figures[i].Dpoints) do
        with Figures[i] do
        begin
          if highDmax.X < Dpoints[j].X then
            highDmax.X := Dpoints[j].X;
          if highDmax.Y < Dpoints[j].Y then
            highDmax.Y := Dpoints[j].Y;
          if highDmin.X > Dpoints[j].X then
            highDmin.X := Dpoints[j].X;
          if highDmin.Y > Dpoints[j].Y then
            highDmin.Y := Dpoints[j].Y;
        end;
      if (highFmin.X <= highDmin.X) and (highFmin.Y <= highDmin.Y) and
        (highFmax.X >= highDmax.X) and (highFmax.Y >= highDmax.Y) then
      begin
        SetLength(SelectFig, Length(SelectFig) + 1);
        SelectFig[High(SelectFig)] := Figures[i];
      end;
    end;
  end;
  SetLength(Figures, High(Figures));
  Apanel.DestroyComponents;
  if Length(SelectFig) > 0 then
  begin
    Apanel.Visible := False;
    Num := MinToolNum(SelectFig);
    for i := High(ToolList[Num].Options) downto Low(ToolList[Num].Options) do
    begin
      ToolList[Num].Options[i].ToControls(Apanel).Align := alTop;
      ToolList[Num].Options[i].ToLabels(Apanel).Align := alTop;
    end;
    Apanel.Visible := True;
    CreateHighSelectFig;
  end;
end;


procedure TloupeTool.MouseUp(x, y: integer; Left: boolean; Apanel: TPanel);
var
  xy: TdoublePoint;
begin
  xy.Y := y;
  xy.X := x;
  with Figures[High(Figures)] do
  begin
    if Dpoints[0].X = Dpoints[1].X then
    begin
      if left then
        Scale := Scale * 2
      else
        Scale := Scale / 2;
      ToPointScale(xy);
    end
    else
    if Dpoints[0].X < Dpoints[1].X then
      RectScale(Dpoints[0], Dpoints[1])
    else
      RectScale(Dpoints[1], Dpoints[0]);
  end;
  SetLength(Figures, High(Figures));
end;

procedure TlineTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := Tline.Create;
  with Figures[High(Figures)] do
  begin
    Dpoints[0] := ScreenToWorld(Point(x, y));
    Dpoints[1] := ScreenToWorld(Point(x, y));
    PenColor := gPenColor;
    Width := gWidth;
    Pstyle := gPstyle.Akind;
  end;
end;

procedure TrectangleTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := Trectangle.Create;
  with Figures[High(Figures)] do
  begin
    Dpoints[0] := ScreenToWorld(Point(x, y));
    Dpoints[1] := ScreenToWorld(Point(x, y));
    PenColor := gPenColor;
    Width := gWidth;
    Pstyle := gPstyle.Akind;
  end;
  (Figures[High(Figures)] as Trectangle).FillColor := gFillColor;
  (Figures[High(Figures)] as Trectangle).Bstyle := gBstyle.AStyle;
end;

procedure TroundRectTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TroundRect.Create;
  with Figures[High(Figures)] do
  begin
    Dpoints[0] := ScreenToWorld(Point(x, y));
    Dpoints[1] := ScreenToWorld(Point(x, y));
    PenColor := gPenColor;
    Width := gWidth;
    Pstyle := gPstyle.Akind;
  end;
  (Figures[High(Figures)] as TroundRect).FillColor := gFillColor;
  (Figures[High(Figures)] as TroundRect).Bstyle := gBstyle.AStyle;
  (Figures[High(Figures)] as TroundRect).Round := gRound;
end;

procedure TellipceTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := Tellipce.Create;
  with Figures[High(Figures)] do
  begin
    Dpoints[0] := ScreenToWorld(Point(x, y));
    Dpoints[1] := ScreenToWorld(Point(x, y));
    PenColor := gPenColor;
    Width := gWidth;
    Pstyle := gPstyle.Akind;
  end;
  (Figures[High(Figures)] as Tellipce).FillColor := gFillColor;
  (Figures[High(Figures)] as Tellipce).Bstyle := gBstyle.AStyle;
end;

procedure TpolyLineTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TpolyLine.Create;
  with Figures[High(Figures)] do
  begin
    Dpoints[0] := ScreenToWorld(Point(x, y));
    PenColor := gPenColor;
    Width := gWidth;
    Pstyle := gPstyle.Akind;
  end;
end;

procedure TloupeTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := Tloupe.Create;
  Figures[High(Figures)].Dpoints[0] := ScreenToWorld(Point(x, y));
  Figures[High(Figures)].Dpoints[1] := ScreenToWorld(Point(x, y));
end;

procedure TselectTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := Tselect.Create;
  Figures[High(Figures)].Dpoints[0] := ScreenToWorld(Point(x, y));
  Figures[High(Figures)].Dpoints[1] := ScreenToWorld(Point(x, y));
  (Figures[High(Figures)] as Tselect).i := 1;
end;

procedure ThandTool.MouseDown(x, y: integer);
begin
  StartPoint.X := x;
  StartPoint.Y := y;
  StartOffset.X := Offset.X;
  StartOffset.Y := Offset.Y;
end;

constructor TloupeTool.Create;
begin
  ToolName := 'Лупа';
end;

constructor TselectTool.Create;
begin
  ToolName := 'Выделить';
end;

constructor ThandTool.Create;
begin
  ToolName := 'Рука';
end;

constructor TlineTool.Create;
begin
  ToolName := 'Прямая';
  SetLength(Options, 3);
  Options[0] := TpenColor.Create;
  Options[1] := TpenKind.Create;
  Options[2] := Twidth.Create;
end;

constructor TrectangleTool.Create;
begin
  ToolName := 'Прямоугольник';
  SetLength(Options, 5);
  Options[0] := TpenColor.Create;
  Options[1] := TpenKind.Create;
  Options[2] := Twidth.Create;
  Options[3] := TfillColor.Create;
  Options[4] := TfillStyle.Create;
end;

constructor TroundRectTool.Create;
begin
  ToolName := 'Круглый квадрат';
  SetLength(Options, 6);
  Options[0] := TpenColor.Create;
  Options[1] := TpenKind.Create;
  Options[2] := Twidth.Create;
  Options[3] := TfillColor.Create;
  Options[4] := TfillStyle.Create;
  Options[5] := Tround.Create;
end;

constructor TellipceTool.Create;
begin
  ToolName := 'Эллипс';
  SetLength(Options, 5);
  Options[0] := TpenColor.Create;
  Options[1] := TpenKind.Create;
  Options[2] := Twidth.Create;
  Options[3] := TfillColor.Create;
  Options[4] := TfillStyle.Create;
end;

constructor TpolyLineTool.Create;
begin
  ToolName := 'Карандаш';
  SetLength(Options, 3);
  Options[0] := TpenColor.Create;
  Options[1] := TpenKind.Create;
  Options[2] := Twidth.Create;
end;

procedure RegisterTool(ATool: TTools);
begin
  setlength(ToolList, length(ToolList) + 1);
  ToolList[High(ToolList)] := ATool;
end;

initialization
  RegisterTool(TPolyLineTool.Create);
  RegisterTool(TLineTool.Create);
  RegisterTool(TRectangleTool.Create);
  RegisterTool(TRoundRectTool.Create);
  RegisterTool(TellipceTool.Create);
  RegisterTool(TloupeTool.Create);
  RegisterTool(ThandTool.Create);
  RegisterTool(TselectTool.Create);

end.
