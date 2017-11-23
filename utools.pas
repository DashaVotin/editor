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
    procedure MouseUp(x, y: integer; Left: boolean); virtual;
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
    procedure MouseUp(x, y: integer; Left: boolean); override;
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
    procedure MouseUp(x, y: integer; Left: boolean); override;
    constructor Create;
  end;

procedure ChangeMaxMinPoint;
procedure CreateHighSelectFig;

var
  ToolNum: integer;
  ToolList: array of Ttools;
  Figures, SelectFig: array of Tfigure;
  MaxPoint, MinPoint: TdoublePoint;

implementation

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
  Maxs := SelectFig[0].Dpoints[0];
  Mins := SelectFig[0].Dpoints[0];
  for i := 0 to High(SelectFig) do
    with SelectFig[i] do
      for j := 0 to High(Dpoints) do
      begin
        if Maxs.X < Dpoints[j].X then
          Maxs.X := Dpoints[j].X;
        if Maxs.Y < Dpoints[j].Y then
          Maxs.Y := Dpoints[j].Y;
        if Mins.X > Dpoints[j].X then
          Mins.X := Dpoints[j].X;
        if Mins.Y > Dpoints[j].Y then
          Mins.Y := Dpoints[j].Y;
      end;
  Maxs.X += 5;
  Maxs.Y += 5;
  Mins.X -= 5;
  Mins.Y -= 5;
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

procedure Ttools.MouseUp(x, y: integer; Left: boolean);
begin
  ChangeMaxMinPoint;
end;

procedure TselectTool.MouseUp(x, y: integer; Left: boolean);
var
  i: integer;
  highFmin, highFmax: TdoublePoint;
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
        SelectFig[High(SelectFig)] := Figures[i];///////////
        break;
      end;
  end
  else
  begin
    for i := 1 to High(Figures) - 1 do
      if (highFmin.X <= Figures[i].Dpoints[0].X) and
        (highFmin.Y <= Figures[i].Dpoints[0].Y) and (highFmax.X >= Figures[i].Dpoints[1].X) and
        (highFmax.Y >= Figures[i].Dpoints[1].Y) then
      begin
        SetLength(SelectFig, Length(SelectFig) + 1);
        SelectFig[High(SelectFig)] := Figures[i];
      end;
  end;
  SetLength(Figures, High(Figures));
  if Length(SelectFig) > 0 then
    CreateHighSelectFig;
end;


procedure TloupeTool.MouseUp(x, y: integer; Left: boolean);
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
