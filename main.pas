unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, thickness, Ufigures, Utools;

type

  { TFgraphics }

  TFgraphics = class(TForm)
    CDpen: TColorDialog;
    CDfond: TColorDialog;
    CDfill: TColorDialog;
    Mannulment: TMenuItem;
    Medit: TMenuItem;
    Mcolor: TMenuItem;
    Mfillcolor: TMenuItem;
    Mfill: TMenuItem;
    Meraseall: TMenuItem;
    Mthickness: TMenuItem;
    Mfondcolor: TMenuItem;
    Mline: TMenuItem;
    Mshape: TMenuItem;
    Mreturn: TMenuItem;
    Mtrait: TMenuItem;
    Minformation: TMenuItem;
    Mreference: TMenuItem;
    Mexit: TMenuItem;
    Mfile: TMenuItem;
    Mmenu: TMainMenu;
    PNtool: TPanel;
    PBdraw: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure MannulmentClick(Sender: TObject);
    procedure McolorClick(Sender: TObject);
    procedure MeraseallClick(Sender: TObject);
    procedure MexitClick(Sender: TObject);
    procedure MfillcolorClick(Sender: TObject);
    procedure MfondcolorClick(Sender: TObject);
    procedure MinformationClick(Sender: TObject);
    procedure MreturnClick(Sender: TObject);
    procedure MthicknessClick(Sender: TObject);
    procedure PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawPaint(Sender: TObject);
    procedure ToolBtnClick(ASender: TObject);
    procedure ButtonCreate(Fstart, Ffinish: TPoint; num: integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Fgraphics: TFgraphics;
  Drawing: boolean;
  CurrentWidth: integer;
  CurrentPenColor, CurrentFontColor, CurrentFillColor: TColor;
  Figures, CtrlZFigures: array of Tfigure;

implementation

{$R *.lfm}

{ TFgraphics }

procedure TFgraphics.ToolBtnClick(ASender: TObject);
begin
  ToolNum := (ASender as TButton).Tag;
end;

procedure TFgraphics.ButtonCreate(Fstart, Ffinish: TPoint; num: integer);
var
  button: TButton;
begin
  button := TButton.Create(Fgraphics);
  button.Parent := PNtool;
  button.Left := Fstart.x;
  button.Top := Fstart.y;
  button.Width := Ffinish.x;
  button.Height := Ffinish.y;
  button.Tag := Num;
  button.OnClick := @ToolBtnClick;
  button.Caption := ToolList[Num].ToolName;
end;

procedure TFgraphics.FormCreate(Sender: TObject);
begin
  Drawing := False;
  CurrentPenColor := clBlack;
  CurrentFillColor := clWhite;
  CurrentFontColor := clWhite;
  CurrentWidth := 1;
  SetLength(Figures, 0);
  SetLength(CtrlZFigures, 0);
  ToolNum := 0;
  ButtonCreate(Point(10, 10), Point(90, 30), 0);
  ButtonCreate(Point(10, 50), Point(90, 30), 1);
  ButtonCreate(Point(10, 90), Point(90, 30), 2);
  ButtonCreate(Point(10, 130), Point(90, 30), 3);
end;

procedure TFgraphics.MexitClick(Sender: TObject);
begin
  Fgraphics.Close;
end;

procedure TFgraphics.MfillcolorClick(Sender: TObject);
begin
  if CDfill.Execute then
  begin
    CurrentFillColor := CDfill.Color;
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.MannulmentClick(Sender: TObject);
begin
  if Length(Figures) > 0 then
  begin
    SetLength(CtrlZFigures, Length(CtrlZFigures) + 1);
    CtrlZFigures[High(CtrlZFigures)] := Figures[High(Figures)];
    SetLength(Figures, High(Figures));
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MreturnClick(Sender: TObject);
begin
  if (Length(CtrlZFigures) > 0) and (Length(Figures) >= 0) then
  begin
    SetLength(Figures, Length(Figures) + 1);
    Figures[High(Figures)] := CtrlZFigures[High(CtrlZFigures)];
    SetLength(CtrlZFigures, High(CtrlZFigures));
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MeraseallClick(Sender: TObject);
begin
  FormCreate(Sender);
  PBdraw.Invalidate;
end;

procedure TFgraphics.McolorClick(Sender: TObject);
begin
  if CDpen.Execute then
  begin
    CurrentPenColor := CDpen.Color;
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.MthicknessClick(Sender: TObject);
begin
  Fthickness.ShowModal;
  CurrentWidth := ActualThicknes1;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MfondcolorClick(Sender: TObject);
begin
  if CDfond.Execute then
  begin
    CurrentFontColor := CDfond.Color;
    PBdraw.Invalidate;
  end;
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
    ToolList[ToolNum].CreateObject(x, y);
  end;
end;

procedure TFgraphics.PBdrawMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if (Drawing) then
  begin
    Figures[High(Figures)].MousMove(x, y);
    Figures[High(Figures)].PenColor := CurrentPenColor;
    Figures[High(Figures)].FillColor := CurrentFillColor;
    Figures[High(Figures)].Width := CurrentWidth;
    SetLength(CtrlZFigures, 0);
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
  begin
    Drawing := False;
  end;
end;

procedure TFgraphics.PBdrawPaint(Sender: TObject);
var
  i: integer;
begin
  with PBdraw.Canvas do
  begin
    Brush.Color := CurrentFontColor;
    FillRect(0, 0, PBdraw.Width, PBdraw.Height);
  end;
  for i := 0 to High(Figures) do
  begin
    Figures[i].Draw(PBdraw.Canvas);
  end;
end;

end.
