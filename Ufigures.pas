unit Ufigures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, UdPoints;

type

  Tfigure = class
    PenColor: TColor;
    Width: integer;
    Pstyle: TPenStyle;
    Dpoints: array of TdoublePoint;
    FigureName: string;
    procedure Draw(Acanvas: Tcanvas); virtual; abstract;
  end;

  Tline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Trectangle = class(Tfigure)
    FillColor: TColor;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tellipce = class(Tfigure)
    FillColor: TColor;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tpolyline = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tloupe = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  Tselect = class(Tfigure)
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

  TroundRect = class(Tfigure)
    FillColor: TColor;
    Round: integer;
    Bstyle: TBrushStyle;
    procedure Draw(Acanvas: Tcanvas); override;
    constructor Create;
  end;

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
  Acanvas.Pen.Color := clBlack;
  Acanvas.Pen.Style := psDashDot;
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
