unit UdPoints;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls;

type
  TdoublePoint = record
    X, Y: double;
  end;

function ScreenToWorld(Apoint: TPoint): TdoublePoint;
function WorldToScreen(AdoublePoint: TdoublePoint): TPoint;
procedure ToPointScale(AdPoint: TdoublePoint);
procedure RectScale(Amin, Amax: TdoublePoint);
procedure MaxMin(maxx, minx, maxy, miny: double);

var
  Offset, MaxPoint, MinPoint: TdoublePoint;
  Scale: double;
  RectScaleHeight, RectScaleWight: integer;

implementation

procedure MaxMin(maxx, minx, maxy, miny: double);
begin
  if maxx > MaxPoint.X then
    MaxPoint.x := maxx;
  if minx < MinPoint.x then
    MinPoint.x := minx;
  if maxy > MaxPoint.y then
    MaxPoint.y := maxy;
  if miny < MinPoint.y then
    MinPoint.y := miny;
end;

procedure RectScale(Amin, Amax: TdoublePoint);
begin
  if (Amax.X - Amin.X > 0) then
  begin
    if RectScaleWight / (Amax.X - Amin.X) > RectScaleHeight / (Amax.Y - Amin.Y) then
      Scale := RectScaleHeight / (Amax.Y - Amin.Y)
    else
      Scale := RectScaleWight / (Amax.X - Amin.X);
    Offset.X := Amin.X * Scale;
    Offset.Y := Amin.Y * Scale;
  end;
end;

procedure ToPointScale(AdPoint: TdoublePoint);
begin
  Offset.X := round(AdPoint.X * Scale - AdPoint.X);
  Offset.Y := round(AdPoint.Y * Scale - AdPoint.Y);
end;

function WorldToScreen(AdoublePoint: TdoublePoint): TPoint;
begin
  Result.x := round((AdoublePoint.x * Scale) - Offset.x);
  Result.y := round((AdoublePoint.y * Scale) - Offset.y);
end;

function ScreenToWorld(Apoint: TPoint): TdoublePoint;
begin
  if Scale <> 0 then
  begin
    Result.X := (Apoint.X + Offset.x) / Scale;
    Result.Y := (Apoint.Y + Offset.y) / Scale;
  end;
end;

end.
