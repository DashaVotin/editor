unit Ufigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, Math, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, UdPoints;

type

 {     Tanchors = record
    x,y:Double;
    ind: integer;
  end;    }

  Tfigure = class
    PenColor: TColor;
    Width: integer;
    Pstyle: TPenStyle;
    Dpoints: array of TdoublePoint;
    FigureName: string;
    procedure Draw(Acanvas: Tcanvas); virtual; abstract;
    function OnePointSelect(x, y: integer): boolean; virtual;
  end;

  Tline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    function OnePointSelect(x, y: integer): boolean; override;
    constructor Create;
  end;

  Trectangle = class(Tfigure)
    FillColor: TColor;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    function OnePointSelect(x, y: integer): boolean; override;
    constructor Create;
  end;

  Tellipce = class(Tfigure)
    FillColor: TColor;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    function OnePointSelect(x, y: integer): boolean; override;
    constructor Create;
  end;

  Tpolyline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    function OnePointSelect(x, y: integer): boolean; override;
    constructor Create;
  end;

  Tloupe = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tselect = class(Tfigure)
    i: integer;
    Anchors: array[0..2] of TdoublePoint;
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  TroundRect = class(Tfigure)
    FillColor: TColor;
    Round: integer;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    function OnePointSelect(x, y: integer): boolean; override;
    constructor Create;
  end;

const
  INDENT = 5;

implementation

procedure Tline.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Pen.Style := Pstyle;
  Acanvas.Pen.Width := Width;
  Acanvas.Brush.Style := bsClear;
  Acanvas.Line(WorldToScreen(Dpoints[0]), WorldToScreen(Dpoints[1]));
end;

procedure Trectangle.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Brush.Color := FillColor;
  Acanvas.Pen.Style := Pstyle;
  Acanvas.Pen.Width := Width;
  Acanvas.Brush.Style := Bstyle;
  Acanvas.Rectangle(WorldToScreen(Dpoints[0]).X, WorldToScreen(Dpoints[0]).Y,
    WorldToScreen(Dpoints[1]).X, WorldToScreen(Dpoints[1]).Y);
end;

procedure TroundRect.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Brush.Color := FillColor;
  Acanvas.Pen.Style := Pstyle;
  Acanvas.Pen.Width := Width;
  Acanvas.Brush.Style := Bstyle;
  Acanvas.RoundRect(WorldToScreen(Dpoints[0]).X, WorldToScreen(Dpoints[0]).Y,
    WorldToScreen(Dpoints[1]).X, WorldToScreen(Dpoints[1]).Y, Round, Round);
end;

procedure Tloupe.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := clBlack;
  Acanvas.Pen.Style := psSolid;
  Acanvas.Brush.Style := bsClear;
  Acanvas.Pen.Width := 1;
  Acanvas.Rectangle(WorldToScreen(Dpoints[0]).X, WorldToScreen(Dpoints[0]).Y,
    WorldToScreen(Dpoints[1]).X, WorldToScreen(Dpoints[1]).Y);
end;

procedure Tselect.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := clRed;
  if i = 1 then
    Acanvas.Pen.Style := psDash;
  if i = 2 then
    Acanvas.Pen.Style := psDashDot;
  if i = 3 then
    Acanvas.Pen.Style := psDashDotDot;
  Acanvas.Brush.Style := bsClear;
  Acanvas.Pen.Width := 1;
  Acanvas.Rectangle(WorldToScreen(Dpoints[0]).X, WorldToScreen(Dpoints[0]).Y,
    WorldToScreen(Dpoints[1]).X, WorldToScreen(Dpoints[1]).Y);
end;

procedure Tellipce.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Brush.Color := FillColor;
  Acanvas.Pen.Style := Pstyle;
  Acanvas.Pen.Width := Width;
  Acanvas.Brush.Style := Bstyle;
  Acanvas.Ellipse(WorldToScreen(Dpoints[0]).X, WorldToScreen(Dpoints[0]).Y,
    WorldToScreen(Dpoints[1]).X, WorldToScreen(Dpoints[1]).Y);
end;

procedure Tpolyline.Draw(Acanvas: Tcanvas);
var
  i: integer;
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Pen.Width := Width;
  Acanvas.Pen.Style := Pstyle;
  Acanvas.Brush.Style := bsClear;
  for i := 1 to High(Dpoints) - 1 do
    ACanvas.Line(WorldToScreen(Dpoints[i]), WorldToScreen(Dpoints[i + 1]));
end;

function Tfigure.OnePointSelect(x, y: integer): boolean;
begin
  Result := False;
end;

function Tline.OnePointSelect(x, y: integer): boolean;
var
  x1, x2, y1, y2, w, c: double;
  i: integer;
begin
  x1 := Min(Dpoints[0].X, Dpoints[1].X);
  x2 := Max(Dpoints[0].X, Dpoints[1].X);
  y1 := Min(Dpoints[0].Y, Dpoints[1].Y);
  y2 := Max(Dpoints[0].Y, Dpoints[1].Y);
  w := INDENT + Width;
  if (x1 = x2) then
  begin
    if (y >= y1) and (y <= y2) and (x <= x1 + w) and (x >= x1 - w) then
      Result := True
    else
      Result := False;
  end
  else
    for i := 1 to 2 do
      if (sqr(x - x1) + sqr(y - y1) <= sqr(w / 2 + 2)) or
        (sqr(x - x2) + sqr(y - y2) <= sqr(w / 2 + 2)) or
        ((y >= (y2 - y1) / (x2 - x1) * x + y2 - (y2 - y1) / (x2 - x1) * x2 - w) and
        (y <= (y2 - y1) / (x2 - x1) * x + y2 - (y2 - y1) / (x2 - x1) * x2 + w) and
        (x >= x1) and (x <= x2)) then
      begin
        Result := True;
        break;
      end
      else
      begin
        c := y2;
        y2 := y1;
        y1 := c;
        Result := False;
      end;
end;

function Tpolyline.OnePointSelect(x, y: integer): boolean;
var
  x1, x2, y1, y2, w, c: double;
  i, j: integer;
begin
  for i := 0 to High(Dpoints) do
  begin
    x1 := Min(Dpoints[i].X, Dpoints[i - 1].X);
    x2 := Max(Dpoints[i].X, Dpoints[i - 1].X);
    y1 := Min(Dpoints[i].Y, Dpoints[i - 1].Y);
    y2 := Max(Dpoints[i].Y, Dpoints[i - 1].Y);
    w := INDENT + Width;
    if (x1 = x2) then
    begin
      if (y >= y1) and (y <= y2) and (x <= x1 + w) and (x >= x1 - w) then
      begin
      Result := True;
      exit;
      end
    else
      Result := False;
    end
    else
      for j := 1 to 2 do
        if (sqr(x - x1) + sqr(y - y1) <= sqr(w / 2 + 2)) or
          (sqr(x - x2) + sqr(y - y2) <= sqr(w / 2 + 2)) or
          ((y >= (y2 - y1) / (x2 - x1) * x + y2 - (y2 - y1) / (x2 - x1) * x2 - w) and
          (y <= (y2 - y1) / (x2 - x1) * x + y2 - (y2 - y1) / (x2 - x1) * x2 + w) and
          (x >= x1) and (x <= x2)) then
        begin
          Result := True;
          exit;
        end
        else
        begin
          c := y2;
          y2 := y1;
          y1 := c;
          Result := False;
        end;
  end;
end;

function Tellipce.OnePointSelect(x, y: integer): boolean;
var
  x1, x2, y1, y2: double;
begin
  x1 := Min(Dpoints[0].X, Dpoints[1].X) - Width;
  x2 := Max(Dpoints[0].X, Dpoints[1].X) + Width;
  y1 := Min(Dpoints[0].Y, Dpoints[1].Y) - Width;
  y2 := Max(Dpoints[0].Y, Dpoints[1].Y) + Width;
  if (sqr(x - (x1 + x2) / 2) / sqr((x2 - x1) / 2) + sqr(y - (y1 + y2) / 2) /
    sqr((y2 - y1) / 2) <= 1) then
    Result := True
  else
    Result := False;
end;

function Trectangle.OnePointSelect(x, y: integer): boolean;
var
  x1, x2, y1, y2: double;
begin
  x1 := Min(Dpoints[0].X, Dpoints[1].X) - Width;
  x2 := Max(Dpoints[0].X, Dpoints[1].X) + Width;
  y1 := Min(Dpoints[0].Y, Dpoints[1].Y) - Width;
  y2 := Max(Dpoints[0].Y, Dpoints[1].Y) + Width;
  if (x >= x1) and (x <= x2) and (y >= y1) and (y <= y2) then
    Result := True
  else
    Result := False;
end;

function TroundRect.OnePointSelect(x, y: integer): boolean;
var
  x1, x2, y1, y2: double;
begin
  x1 := Min(Dpoints[0].X, Dpoints[1].X) - Width;
  x2 := Max(Dpoints[0].X, Dpoints[1].X) + Width;
  y1 := Min(Dpoints[0].Y, Dpoints[1].Y) - Width;
  y2 := Max(Dpoints[0].Y, Dpoints[1].Y) + Width;
  if ((x >= x1) and (x <= x2) and (y >= y1 + Round) and (y <= y2 - Round)) or
    ((x >= x1 + Round) and (x <= x2 - Round) and (y >= y1) and (y <= y2)) or
    (sqr(x - x1 - Round) + sqr(y - y1 - Round) <= sqr(Round)) or
    (sqr(x - x2 + Round) + sqr(y - y1 - Round) <= sqr(Round)) or
    (sqr(x - x1 - Round) + sqr(y - y2 + Round) <= sqr(Round)) or
    (sqr(x - x2 + Round) + sqr(y - y2 + Round) <= sqr(Round)) then
    Result := True
  else
    Result := False;
end;

constructor Tline.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'Tline';
end;

constructor Trectangle.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'Trectangle';
end;

constructor TroundRect.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'TroundRect';
end;

constructor Tellipce.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'Tellipce';
end;

constructor Tpolyline.Create;
begin
  SetLength(Dpoints, Length(Dpoints) + 1);
  FigureName := 'Tpolyline';
end;

constructor Tloupe.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'Tloupe';
end;

constructor Tselect.Create;
begin
  SetLength(Dpoints, 2);
  FigureName := 'Tselect';
end;

end.
