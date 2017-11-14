unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin, Ufigures, Utools, UdPoints, Uoptions;

type

  { TFgraphics }

  TFgraphics = class(TForm)
    Mannulment: TMenuItem;
    Medit: TMenuItem;
    Meraseall: TMenuItem;
    Mreturn: TMenuItem;
    Mtrait: TMenuItem;
    Minformation: TMenuItem;
    Mreference: TMenuItem;
    Mexit: TMenuItem;
    Mfile: TMenuItem;
    Mmenu: TMainMenu;
    PNzoom: TPanel;
    PNfigures: TPanel;
    PNtool: TPanel;
    PBdraw: TPaintBox;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    SEscale: TSpinEdit;
    PanelOptions: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MannulmentClick(Sender: TObject);
    procedure MeraseallClick(Sender: TObject);
    procedure MexitClick(Sender: TObject);
    procedure MinformationClick(Sender: TObject);
    procedure MreturnClick(Sender: TObject);
    procedure PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawPaint(Sender: TObject);
    procedure SEscaleChange(Sender: TObject);
    procedure ToolBtnClick(ASender: TObject);
    procedure ButtonCreate(Fstart, Ffinish: TPoint; Num: integer; Aparent: TPanel);
    procedure CreatePanel;
  private

  public

  end;

var
  Fgraphics: TFgraphics;
  Drawing: boolean;
  RedoFigures: array of Tfigure;

implementation

{$R *.lfm}

procedure TFgraphics.ToolBtnClick(ASender: TObject);
var i: Toptions;
  o: array of Toptions;
  x: TControl;
begin
  ToolNum := (ASender as TButton).Tag;
  PanelOptions.DestroyComponents;
 // FreeAndNil(PanelOptions);
 // CreatePanel;
  //ToolList[ToolNum].Create;
  o := ToolList[ToolNum].Options;
  for i in o do
    begin
    x := i.ToControls(PanelOptions);
    x.Align := alTop;
    end;
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
 // PanelOptions.Color := clRed;

end;

procedure TFgraphics.ButtonCreate(Fstart, Ffinish: TPoint; Num: integer;
  Aparent: TPanel);
var
  button: TButton;
begin
  button := TButton.Create(Fgraphics);
  button.Parent := Aparent;
  button.Left := Fstart.x;
  button.Top := Fstart.y;
  button.Width := Ffinish.x;
  button.Height := Ffinish.y;
  button.Tag := Num;
  button.OnClick := @ToolBtnClick;
  button.Caption := ToolList[Num].ToolName;
end;

procedure TFgraphics.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Drawing := False;
  SetLength(Figures, 1);
  Brush.Color := clWhite;
  Figures[0] := Trectangle.Create;
  Figures[0].Dpoints[0] := ScreenToWorld(Point(0, 0));
  Figures[0].Dpoints[1] := ScreenToWorld(Point(PBdraw.Width, PBdraw.Height));
  SetLength(RedoFigures, 0);
  ToolNum := 0;
  for i := 0 to 4 do
    ButtonCreate(Point(10, i * 40 + 10), Point(100, 30), i, PNfigures);
  for i := 5 to 6 do
    ButtonCreate(Point(10, (i - 5) * 40 + 40), Point(95, 30), i, PNzoom);
 // PanelOptions.Free;
  Uoptions.Round := 10;
  CreatePanel;
  //ToolList[ToolNum].Create;
  Offset.X := 0;
  Offset.Y := 0;
  Scale := 1;
  RectScaleWight := PBdraw.Width;
  RectScaleHeight := PBdraw.Height;
end;

procedure TFgraphics.FormResize(Sender: TObject);
begin
  RectScaleWight := PBdraw.Width;
  RectScaleHeight := PBdraw.Height;
  PanelOptions.Height := Fgraphics.PNtool.Height -
    (Fgraphics.PNzoom.Height + Fgraphics.PNfigures.Height);
end;

procedure TFgraphics.MexitClick(Sender: TObject);
begin
  Fgraphics.Close;
end;

procedure TFgraphics.MannulmentClick(Sender: TObject);
begin
  if Length(Figures) > 1 then
  begin
    SetLength(RedoFigures, Length(RedoFigures) + 1);
    RedoFigures[High(RedoFigures)] := Figures[High(Figures)];
    SetLength(Figures, High(Figures));
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MreturnClick(Sender: TObject);
begin
  if (Length(RedoFigures) > 0) and (Length(Figures) >= 1) then
  begin
    SetLength(Figures, Length(Figures) + 1);
    Figures[High(Figures)] := RedoFigures[High(RedoFigures)];
    SetLength(RedoFigures, High(RedoFigures));
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MeraseallClick(Sender: TObject);
begin
  SetLength(Figures, 1);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MinformationClick(Sender: TObject);
begin
  ShowMessage('Графический редактор. Сделала это нечто - Вотинцева Даша. В 2017 году)');
end;

procedure TFgraphics.PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
  begin
    Drawing := True;
    ToolList[ToolNum].MouseDown(x, y);
    Figures[High(Figures)].PenColor := Uoptions.PenColor;
    Figures[High(Figures)].Width := Uoptions.Width;
    Figures[High(Figures)].FillColor := Uoptions.FillColor;
    Figures[High(Figures)].Bstyle := Uoptions.Bstyle;
    Figures[High(Figures)].Round := Uoptions.Round;
  end;
end;

procedure TFgraphics.PBdrawMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if (Drawing) then
  begin
    ToolList[ToolNum].MouseMove(x, y);
    SetLength(RedoFigures, 0);
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
    ToolList[ToolNum].MouseUp(x, y, True);
  if Button = mbRight then
    ToolList[ToolNum].MouseUp(x, y, False);
  Drawing := False;
  PBdraw.Invalidate;
end;

procedure TFgraphics.PBdrawPaint(Sender: TObject);
var
  i: integer;
begin
  with PBdraw.Canvas do
  begin
    SEscale.Text := FloatToStr(Scale * 100);
  end;
  for i := 0 to High(Figures) do
    Figures[i].Draw(PBdraw.Canvas);
end;

procedure TFgraphics.SEscaleChange(Sender: TObject);
var
  Ascale: double;
begin
  try
    Ascale := StrToFloat(SEscale.Text) / 100;
    if Ascale > 0 then
      Scale := Ascale
    else
      Scale := 1;
  except
    on  EConvertError do
      Scale := 1;
  end;
  PBdraw.Invalidate;
end;

end.
