unit figures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, thickness;

type
  Tfigure = class
    procedure Draw(Acanvas: Tcanvas); virtual;
    Fcolor: Tcolor;
    procedure MouseMove(X, Y: integer);
  end;

  TfigureClass = class of Tfigure;

  Tline = class(Tfigure)
    Fstart, Ffinish: TPoint;
    procedure Draw(Acanvas: Tcanvas);
  end;

  Trectangle = class(Tfigure)
    Fstart, Ffinish: TPoint;
    procedure Draw(Acanvas: Tcanvas);
  end;

  Tellipce = class(Tfigure)
    Fstart, Ffinish: TPoint;
    procedure Draw(Acanvas: Tcanvas);
  end;

  TlineFormat = record
    Line: array of TPoint;
    Color: TColor;
    Width: integer;
  end;

  Tpolyline = class(Tfigure)
    Fpic: array of TlineFormat;
    procedure Draw(Acanvas: Tcanvas);
  end;

implementation

procedure Tline.Draw(Acanvas);
begin
  Acanvas.Line(Fstart, Ffinish);
  Acanvas.Pen.Color := Fcolor;
  override;
end;

procedure Tline.MouseMove(X, Y);
begin
  Ffinish := Point(X, Y);
end;

end.
