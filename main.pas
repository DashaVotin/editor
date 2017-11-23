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
    MenuItem1: TMenuItem;
    Mbackground: TMenuItem;
    MselectAll: TMenuItem;
    MselectUndone: TMenuItem;
    MselectDelete: TMenuItem;
    MselectGround: TMenuItem;
    Mforeground: TMenuItem;
    MenuItem7: TMenuItem;
    Mhome: TMenuItem;
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
    ScrolHoriz: TScrollBar;
    ScrolVert: TScrollBar;
    SEscale: TSpinEdit;
    PanelOptions: TPanel;
    TpenStyleSelect: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure MannulmentClick(Sender: TObject);
    procedure MbackgroundClick(Sender: TObject);
    procedure MeraseallClick(Sender: TObject);
    procedure MexitClick(Sender: TObject);
    procedure MforegroundClick(Sender: TObject);
    procedure MhomeClick(Sender: TObject);
    procedure MinformationClick(Sender: TObject);
    procedure MreturnClick(Sender: TObject);
    procedure MselectAllClick(Sender: TObject);
    procedure MselectDeleteClick(Sender: TObject);
    procedure MselectUndoneClick(Sender: TObject);
    procedure PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: integer);
    procedure PBdrawMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure PBdrawPaint(Sender: TObject);
    procedure SEscaleChange(Sender: TObject);
    procedure ToolBtnClick(ASender: TObject);
    function ButtonCreate(Fstart, Ffinish: TPoint; Num: integer;
      Aparent: TPanel): TButton;
    procedure CreatePanel;
    procedure ChangeScrols;
    procedure TpenStyleSelectTimer(Sender: TObject);
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
var
  i: integer;
begin
  ToolNum := (ASender as TButton).Tag;
  PanelOptions.Free;
  CreatePanel;
  for i := High(ToolList[ToolNum].Options) downto Low(ToolList[ToolNum].Options) do
  begin
    ToolList[ToolNum].Options[i].ToControls(PanelOptions).Align := alTop;
    ToolList[ToolNum].Options[i].ToLabels(PanelOptions).Align := alTop;
  end;
end;

procedure TFgraphics.ChangeScrols;
begin
  ScrolHoriz.Min := round(MinPoint.X);
  ScrolHoriz.Max := round(MaxPoint.X);
  ScrolVert.Min := round(MinPoint.Y);
  ScrolVert.Max := round(MaxPoint.Y);
  //////////////////
end;

procedure TFgraphics.TpenStyleSelectTimer(Sender: TObject);
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
      if (SelectFig[High(SelectFig)] as Tselect).i < 4 then
        (SelectFig[High(SelectFig)] as Tselect).i += 1
      else
        (SelectFig[High(SelectFig)] as Tselect).i := 1;
  PBdraw.Invalidate;
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
end;

function TFgraphics.ButtonCreate(Fstart, Ffinish: TPoint; Num: integer;
  Aparent: TPanel): TButton;
begin
  Result := TButton.Create(Fgraphics);
  with Result do
  begin
    Parent := Aparent;
    Left := Fstart.x;
    Top := Fstart.y;
    Width := Ffinish.x;
    Height := Ffinish.y;
    Tag := Num;
    OnClick := @ToolBtnClick;
    Caption := ToolList[Num].ToolName;
  end;
end;

procedure TFgraphics.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Drawing := False;
  SetLength(Figures, 1);
  SetLength(SelectFig, 0);
  Brush.Color := clWhite;
  Figures[0] := Trectangle.Create;
  Figures[0].Dpoints[0] := ScreenToWorld(Point(0, 0));
  Figures[0].Dpoints[1] := ScreenToWorld(Point(PBdraw.Width, PBdraw.Height));
  SetLength(RedoFigures, 0);
  ToolNum := 0;
  CreatePanel;
  ButtonCreate(Point(10, 10), Point(100, 30), 0, PNfigures).Click;
  for i := 1 to 4 do
    ButtonCreate(Point(10, i * 40 + 10), Point(100, 30), i, PNfigures).Align := alNone;
  for i := 5 to 7 do
    ButtonCreate(Point(10, (i - 5) * 40 + 40), Point(95, 30), i, PNzoom).Align := alNone;
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

procedure TFgraphics.MforegroundClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(Figures, Length(Figures) + High(SelectFig));
      for i := Length(Figures) - High(SelectFig) to High(Figures) do
        Figures[i] := SelectFig[i - Length(Figures) + High(SelectFig)];
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MhomeClick(Sender: TObject);
begin
  ChangeMaxMinPoint;
  MinPoint.x -= 10;
  MinPoint.y -= 10;
  MaxPoint.x += 10;
  MaxPoint.y += 10;
  RectScale(MinPoint, MaxPoint);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MannulmentClick(Sender: TObject);
begin
  if Length(Figures) > 1 then
  begin
    SetLength(RedoFigures, Length(RedoFigures) + 1);
    RedoFigures[High(RedoFigures)] := Figures[High(Figures)];
    SetLength(Figures, High(Figures));
    ChangeMaxMinPoint;
  end;
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
      SetLength(SelectFig, 0);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MbackgroundClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(Figures, Length(Figures) + High(SelectFig));
      for i := High(Figures) - High(SelectFig) downto 1 do
        Figures[i + High(SelectFig)] := Figures[i];
      for i := 1 to High(SelectFig) do
        Figures[i] := SelectFig[i - 1];
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MreturnClick(Sender: TObject);
begin
  if (Length(RedoFigures) > 0) and (Length(Figures) >= 1) then
  begin
    SetLength(Figures, Length(Figures) + 1);
    Figures[High(Figures)] := RedoFigures[High(RedoFigures)];
    SetLength(RedoFigures, High(RedoFigures));
    ChangeMaxMinPoint;
  end;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MselectAllClick(Sender: TObject);
var
  i: integer;
begin
  SetLength(SelectFig, 0);
  SetLength(SelectFig, High(Figures));
  for i := 1 to High(Figures) do
    SelectFig[i - 1] := Figures[i];
  CreateHighSelectFig;
  PBdraw.Invalidate;
end;

procedure TFgraphics.MselectDeleteClick(Sender: TObject);
var
  i, j, l: integer;
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
    begin
      for i := 0 to High(SelectFig) - 1 do
        for j := 1 to High(Figures) do
          if Figures[j] = SelectFig[i] then
          begin
            for l := j to High(Figures) - 1 do
              Figures[l] := Figures[l + 1];
            SetLength(Figures, High(Figures));
            break;
          end;
      SetLength(SelectFig, 0);
      PBdraw.Invalidate;
    end;
end;

procedure TFgraphics.MselectUndoneClick(Sender: TObject);
begin
  SetLength(SelectFig, 0);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MeraseallClick(Sender: TObject);
begin
  SetLength(Figures, 1);
  SetLength(SelectFig, 0);
  PBdraw.Invalidate;
end;

procedure TFgraphics.MinformationClick(Sender: TObject);
begin
  ShowMessage('Графический редактор. Сделала это нечто - Вотинцева Даша. В 2017 году)');
end;

procedure TFgraphics.PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if Length(SelectFig) > 0 then
    if SelectFig[High(SelectFig)].ClassType = Tselect then
      SetLength(SelectFig, 0);
  if button = mbLeft then
  begin
    Drawing := True;
    ToolList[ToolNum].MouseDown(x, y);
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
    SEscale.Text := FloatToStr(round(Scale * 100));
  end;
  for i := 0 to High(Figures) do
    Figures[i].Draw(PBdraw.Canvas);
  if Length(SelectFig) > 0 then
    SelectFig[High(SelectFig)].Draw(PBdraw.Canvas);   //анимация
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
