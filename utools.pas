unit Utools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, Ufigures, UdPoints, Uoptions;

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
    procedure MouseDown(x, y: integer); override;
    procedure MouseMove(x, y: integer); override;
    procedure MouseUp(x, y: integer; Left: boolean); override;
    constructor Create;
  end;


var
  ToolNum: integer;
  ToolList: array of Ttools;
  Figures: array of Tfigure;

implementation

procedure ThandTool.MouseMove(x, y: integer);
begin
  with Figures[High(Figures)] do
  begin
    Dpoints[1] := ScreenToWorld(Point(x, y));
    Offset.X := Offset.X + Dpoints[0].X - Dpoints[1].X;
    Offset.Y := Offset.Y + Dpoints[0].Y - Dpoints[1].Y;
  end;
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
var
  max, min: TdoublePoint;
  i: integer;
begin
  with Figures[High(Figures)] do
  begin
    max.X := Dpoints[0].X;
    max.Y := Dpoints[0].Y;
    min.X := Dpoints[0].X;
    min.y := Dpoints[0].Y;
    for i := 1 to High(Dpoints) do
    begin
      if Dpoints[i].X > max.X then
        max.X := Dpoints[i].X;
      if Dpoints[i].y > max.y then
        max.y := Dpoints[i].y;
      if Dpoints[i].X < min.X then
        min.X := Dpoints[i].X;
      if Dpoints[i].y < min.y then
        min.y := Dpoints[i].y;
    end;
  end;
  MaxMin(max.X, min.x, max.y, min.y);
end;

procedure ThandTool.MouseUp(x, y: integer; Left: boolean);
begin
  SetLength(Figures, High(Figures));
end;

procedure TloupeTool.MouseUp(x, y: integer; Left: boolean);
var
  xy: TdoublePoint;
begin
  xy.Y := y;
  xy.X := x;
  if figures[High(Figures)].Dpoints[0].X = Figures[High(Figures)].Dpoints[1].X then
  begin
    if left then
      Scale := Scale * 2
    else
      Scale := Scale / 2;
    ToPointScale(xy);
  end
  else
  begin
    if figures[High(Figures)].Dpoints[0].X < Figures[High(Figures)].Dpoints[1].X then
      RectScale(Figures[High(Figures)].Dpoints[0], Figures[High(Figures)].Dpoints[1])
    else
      RectScale(Figures[High(Figures)].Dpoints[1], Figures[High(Figures)].Dpoints[0]);
    SetLength(Figures, High(Figures));
  end;
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

procedure ThandTool.MouseDown(x, y: integer);
begin
  SetLength(Figures, Length(Figures) + 1);
  Figures[High(Figures)] := TpolyLine.Create;
  Figures[High(Figures)].Dpoints[0] := ScreenToWorld(Point(x, y));
end;

constructor TloupeTool.Create;
begin
  ToolName := 'Лупа';
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

end.
