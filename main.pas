unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, thickness;

type

  TlineFormat = record
    Line: array of TPoint;
    Color: TColor;
    Thicknes: integer;
  end;

  { TFgraphics }

  TFgraphics = class(TForm)
    CDpen: TColorDialog;
    CDfond: TColorDialog;
    Mannulment: TMenuItem;
    Medit: TMenuItem;
    Mcolor: TMenuItem;
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
    PBdraw: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure MannulmentClick(Sender: TObject);
    procedure McolorClick(Sender: TObject);
    procedure MeraseallClick(Sender: TObject);
    procedure MexitClick(Sender: TObject);
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
  private
    { private declarations }
  public
  end;

var
  Fgraphics: TFgraphics;
  Drawing: boolean;
  ActualThicknes: integer;
  ActualPenColor, ActualFontColor: TColor;
  Pic, ReturnPic: array of Tlineformat;

implementation

{$R *.lfm}

{ TFgraphics }

procedure TFgraphics.FormCreate(Sender: TObject);
begin
  SetLength(Pic, 0);
  SetLength(ReturnPic, 0);
  Drawing := False;
  ActualPenColor := clBlack;
  ActualFontColor := clWhite;
  ActualThicknes := 1;
end;

procedure TFgraphics.MexitClick(Sender: TObject);
begin
  Fgraphics.Close;
end;

procedure TFgraphics.MannulmentClick(Sender: TObject);
begin
  if Length(Pic) > 0 then
  begin
    SetLength(ReturnPic, Length(ReturnPic) + 1);
    ReturnPic[High(ReturnPic)] := Pic[High(Pic)];
    SetLength(Pic, High(Pic));
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MreturnClick(Sender: TObject);
begin
  if (Length(ReturnPic) > 0) and (Length(Pic) >= 0) then
  begin
    SetLength(Pic, Length(Pic) + 1);
    Pic[High(Pic)] := ReturnPic[High(ReturnPic)];
    SetLength(ReturnPic, High(ReturnPic));
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
    ActualPenColor := CDpen.Color;
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.MthicknessClick(Sender: TObject);
begin
  Fthickness.ShowModal;
  ActualThicknes := ActualThicknes1;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MfondcolorClick(Sender: TObject);
begin
  if CDfond.Execute then
  begin
    ActualFontColor := CDfond.Color;
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
    SetLength(Pic, Length(Pic) + 1);
  end;
end;

procedure TFgraphics.PBdrawMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin
  if (Drawing) then
    with pic[High(pic)] do
    begin
      SetLength(Line, Length(Line) + 1);
      Line[High(Line)] := Point(X, Y);
      Color := ActualPenColor;
      Thicknes := ActualThicknes;
      SetLength(ReturnPic, 0);
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
  begin
    Drawing := False;
    PBdraw.Invalidate;
  end;
end;

procedure TFgraphics.PBdrawPaint(Sender: TObject);
var
  i: integer;
begin
  with PBdraw.Canvas do
  begin
    Brush.Color := ActualFontColor;
    FillRect(0, 0, PBdraw.Width, PBdraw.Height);
    for i := 0 to High(Pic) do
    begin
      Pen.Color := Pic[i].Color;
      Pen.Width := Pic[i].Thicknes;
      Polyline(Pic[i].Line);
    end;
  end;
end;

end.
