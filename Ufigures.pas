unit Ufigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls;

type
  Tfigure = class
    PenColor, FillColor: Tcolor;
    Width: integer;
    Points: array of TPoint;
    FigureName: string;
    procedure Draw(Acanvas: Tcanvas); virtual; abstract;
    procedure MousMove(x, y: integer);
  end;

  Tline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Trectangle = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tellipce = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tpolyline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

implementation

uses Utools;

procedure Tfigure.MousMove(x, y: integer);
begin
  if ToolNum = 1 then
  begin
    SetLength(Points, Length(Points) + 1);
    Points[High(Points)] := Point(x, y);
  end
  else
  begin
    SetLength(Points, 2);
    Points[1] := Point(x, y);
  end;
end;

procedure Tline.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Pen.Width := Width;
  Acanvas.Line(Points[0], Points[1]);
end;

procedure Trectangle.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Brush.Color := FillColor;
  Acanvas.Pen.Width := Width;
  Acanvas.Rectangle(Points[0].x, Points[0].y, Points[1].x, Points[1].y);
end;

procedure Tellipce.Draw(Acanvas: TCanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Brush.Color := FillColor;
  Acanvas.Pen.Width := Width;
  Acanvas.Ellipse(Points[0].x, Points[0].y, Points[1].x, Points[1].y);
end;

procedure Tpolyline.Draw(Acanvas: Tcanvas);
begin
  Acanvas.Pen.Color := PenColor;
  Acanvas.Pen.Width := Width;
  Acanvas.Polyline(Points);
end;

constructor Tline.Create;
begin
  SetLength(Points, 2);
  FigureName := 'Tline';
end;

constructor Trectangle.Create;
begin
  SetLength(Points, 2);
  FigureName := 'Trectangle';
end;

constructor Tellipce.Create;
begin
  SetLength(Points, 2);
  FigureName := 'Tellipce';
end;

constructor Tpolyline.Create;
begin
  SetLength(Points, Length(Points) + 1);
  FigureName := 'Tpolyline';
end;

end.
