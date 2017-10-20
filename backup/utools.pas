unit Utools;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, Ufigures;

type
  Ttools = class
    ToolName: string;
    procedure CreateObject(x,y:integer); virtual; abstract;
  end;

  TlineTool = class(Ttools)
  procedure CreateObject(x,y:integer); override;
  constructor Create;
  end;

  TrectangleTool = class(Ttools)
  procedure CreateObject(x,y:integer); override;
  constructor Create;
  end;

  TellipceTool = class(Ttools)
  procedure CreateObject(x,y:integer); override;
  constructor Create;
  end;

  TpolyLineTool = class(Ttools)
  procedure CreateObject(x,y:integer); override;
  constructor Create;
  end;

  var
    ToolNum:integer;
    ToolList: array of Ttools;

implementation
uses main;

procedure TlineTool.CreateObject(x,y:integer);
  begin
    SetLength(Figures, Length(Figures)+1);
    Figures[High(Figures)]:=Tline.Create;
    Figures[High(Figures)].Points[0]:=Point(x,y);
    Figures[High(Figures)].Points[1]:=Point(x,y);
  end;

procedure TrectangleTool.CreateObject(x,y:integer);
  begin
    SetLength(Figures, Length(Figures)+1);
    Figures[High(Figures)]:=Trectangle.Create;
    Figures[High(Figures)].Points[0]:=Point(x,y);
    Figures[High(Figures)].Points[1]:=Point(x,y);
  end;

procedure TellipceTool.CreateObject(x,y:integer);
  begin
    SetLength(Figures, Length(Figures)+1);
    Figures[High(Figures)]:=Tellipce.Create;
    Figures[High(Figures)].Points[0]:=Point(x,y);
    Figures[High(Figures)].Points[1]:=Point(x,y);
  end;

procedure TpolyLineTool.CreateObject(x,y:integer);
  begin
    SetLength(Figures, Length(Figures)+1);
    Figures[High(Figures)]:=TpolyLine.Create;
    Figures[High(Figures)].Points[0]:=Point(x,y);
  end;

constructor TlineTool.Create;
begin
  ToolName:='Прямая';
end;

constructor TrectangleTool.Create;
begin
  ToolName:='Прямоугольник';
end;

constructor TellipceTool.Create;
begin
  ToolName:='Эллипс';
end;

constructor TpolyLineTool.Create;
begin
  ToolName:='Карандаш';
end;

procedure RegisterTool(ATool:TTools);
begin
  setlength(ToolList,length(ToolList)+1);
  ToolList[High(ToolList)]:=ATool;
end;

initialization
  RegisterTool(TLineTool.Create);
  RegisterTool(TPolyLineTool.Create);
  RegisterTool(TRectangleTool.Create);
  RegisterTool(TellipceTool.Create);


end.

