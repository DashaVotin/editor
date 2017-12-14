unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin, Ufigures, Utools, UdPoints, Uoptions, Fpjson, jsonparser;

type

  { TFgraphics }

  TFgraphics = class(TForm)
    Mannulment: TMenuItem;
    Medit: TMenuItem;
    MenuItem1: TMenuItem;
    Mbackground: TMenuItem;
    Mopen: TMenuItem;
    Msave: TMenuItem;
    Mtot: TMenuItem;
    MselectAll: TMenuItem;
    MselectUndone: TMenuItem;
    MselectDelete: TMenuItem;
    MselectGround: TMenuItem;
    Mforeground: TMenuItem;
    MenuItem7: TMenuItem;
    Mhome: TMenuItem;
    Meraseall: TMenuItem;
    Mreturn: TMenuItem;
    Minformation: TMenuItem;
    Mreference: TMenuItem;
    Mexit: TMenuItem;
    Mfile: TMenuItem;
    Mmenu: TMainMenu;
    Dopen: TOpenDialog;
    PNzoom: TPanel;
    PNfigures: TPanel;
    PNtool: TPanel;
    PBdraw: TPaintBox;
    Dsave: TSaveDialog;
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
    procedure MopenClick(Sender: TObject);
    procedure MreturnClick(Sender: TObject);
    procedure MsaveClick(Sender: TObject);
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
  PanelOptions.Visible := False;
  for i := High(ToolList[ToolNum].Options) downto Low(ToolList[ToolNum].Options) do
  begin
    ToolList[ToolNum].Options[i].ToControls(PanelOptions).Align := alTop;
    ToolList[ToolNum].Options[i].ToLabels(PanelOptions).Align := alTop;
  end;
  PanelOptions.Visible := True;
  if ToolNum <> 8 then
    SetLength(SelectFig, 0);
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
var
  j: integer;
begin
  if Length(SelectFig) > 0 then
  begin
    if SelectFig[High(SelectFig)].ClassType = Tselect then
      if (SelectFig[High(SelectFig)] as Tselect).i < 4 then
        (SelectFig[High(SelectFig)] as Tselect).i += 1
      else
        (SelectFig[High(SelectFig)] as Tselect).i := 1;
    if changeOp then
    begin
      for j := 0 to High(SelectFig) - 1 do
      begin
        SelectFig[j].PenColor := gOptions.gPenColor;
        SelectFig[j].Pstyle := gOptions.gPstyle.Akind;
        SelectFig[j].Width := gOptions.gWidth;
        if PanelOptions.ComponentCount > 6 then
        begin
          if SelectFig[j].ClassType = Tellipce then
          begin
            (SelectFig[j] as Tellipce).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as Tellipce).FillColor := gOptions.gFillColor;
          end
          else
          if SelectFig[j].ClassType = Trectangle then
          begin
            (SelectFig[j] as Trectangle).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as Trectangle).FillColor := gOptions.gFillColor;
          end
          else
          if SelectFig[j].ClassType = TroundRect then
          begin
            (SelectFig[j] as TroundRect).Bstyle := gOptions.gBstyle.AStyle;
            (SelectFig[j] as TroundRect).FillColor := gOptions.gFillColor;
            (SelectFig[j] as TroundRect).Round := gOptions.gRound;
          end;
        end;
      end;
      SetLength(SelectFig, High(SelectFig));
      CreateHighSelectFig;
      changeOp := False;
    end;
  end;
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
  for i := 5 to 8 do
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

procedure TFgraphics.MsaveClick(Sender: TObject);
var
  fSave: Text;
  i, j: integer;
begin
  //сохранение:
  if Dsave.Execute then
  begin
    AssignFile(fSave, Dsave.FileName);
    Rewrite(fSave);
    Write(fSave, '{"Num": ', High(Figures), ', "Figures":[');
    for i := 1 to High(Figures) do
      with Figures[i] do
      begin
        Write(fSave, '{ "Type": "', FigureName, '",');
        Write(fSave, '"PenColor": "', ColorToString(PenColor), '", ');
        Write(fSave, '"Width": ', Width, ', ');
        Write(fSave, '"PenStyle": "', Pstyle, '", ');
        Write(fSave, SaveOption());
        Write(fSave, '"NumPoint": ', High(Dpoints), ', "Points":[ ');
        for j := 0 to High(Dpoints) do
        begin
          Write(fSave, WorldToScreen(Dpoints[j]).x, ', ');
          if (i = High(Figures)) and (j = High(Dpoints)) then
            Write(fSave, WorldToScreen(Dpoints[High(Dpoints)]).y, ']}')
          else
          if j = High(Dpoints) then
            Write(fSave, WorldToScreen(Dpoints[High(Dpoints)]).y, ']}, ')
          else
            Write(fSave, WorldToScreen(Dpoints[j]).y, ', ');
        end;
      end;
    Write(fSave, ']}');
    CloseFile(fSave);
  end;
end;

procedure TFgraphics.MopenClick(Sender: TObject);
var
  jData: TJSONData;
  s: string;
  fOpen: Text;
  Apoint: TPoint;
  i, j: integer;
begin
  if Dopen.Execute then
  begin
    AssignFile(fOpen, Dopen.FileName);
    Reset(fOpen);
    Read(fOpen, s);
    CloseFile(fOpen);
    try
      jData := GetJSON(s);
    except
      ShowMessage('файл поврежден, возможно вами, возможно намеренно...');
      exit;
    end;
    SetLength(Figures, 1);
    for i := 1 to jData.FindPath('Num').AsInteger do
    begin
      SetLength(Figures, Length(Figures) + 1);
      s := 'Figures[' + IntToStr(i - 1) + '].Type';
      case jData.FindPath(s).AsString of
        'Tline':
          Figures[i] := Tline.Create;
        'Trectangle':
        begin
          Figures[i] := Trectangle.Create;
          s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
          (Figures[i] as Trectangle).FillColor := StringToColor(jData.FindPath(s).AsString);
          s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
          (Figures[i] as Trectangle).Bstyle := StringToBrushStyle(jData.FindPath(s).AsString);
        end;
        'TroundRect':
        begin
          Figures[i] := TroundRect.Create;
          s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
          (Figures[i] as TroundRect).FillColor := StringToColor(jData.FindPath(s).AsString);
          s := 'Figures[' + IntToStr(i - 1) + '].Round';
          (Figures[i] as TroundRect).Round := jData.FindPath(s).AsInteger;
          s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
          (Figures[i] as TroundRect).Bstyle := StringToBrushStyle(jData.FindPath(s).AsString);
        end;
        'Tellipce':
        begin
          Figures[i] := Tellipce.Create;
          s := 'Figures[' + IntToStr(i - 1) + '].BrushColor';
          (Figures[i] as Tellipce).FillColor := StringToColor(jData.FindPath(s).AsString);
          s := 'Figures[' + IntToStr(i - 1) + '].BrushStyle';
          (Figures[i] as Tellipce).Bstyle := StringToBrushStyle(jData.FindPath(s).AsString);
        end;
        'Tpolyline':
          Figures[i] := Tpolyline.Create;
      end;
      with Figures[i] do
      begin
        SetLength(Dpoints, 0);
        s := 'Figures[' + IntToStr(i - 1) + '].NumPoint';
        for j := 0 to jData.FindPath(s).AsInteger do
        begin
          SetLength(Dpoints, Length(Dpoints) + 1);
          s := 'Figures[' + IntToStr(i - 1) + '].Points[' + IntToStr(j * 2) + ']';
          Apoint.x := jData.FindPath(s).AsInteger;
          s := 'Figures[' + IntToStr(i - 1) + '].Points[' + IntToStr(j * 2 + 1) + ']';
          Apoint.y := jData.FindPath(s).AsInteger;
          Dpoints[j] := ScreenToWorld(Apoint);
        end;
        s := 'Figures[' + IntToStr(i - 1) + '].PenColor';
        PenColor := StringToColor(jData.FindPath(s).AsString);
        s := 'Figures[' + IntToStr(i - 1) + '].Width';
        Width := jData.FindPath(s).AsInteger;
        s := 'Figures[' + IntToStr(i - 1) + '].PenStyle';
        Pstyle := StringToPenStyle(jData.FindPath(s).AsString);
      end;
    end;
    jData.Free;
    PBdraw.Invalidate;
  end;
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
  ShowMessage('Графический редактор. Сделала - Вотинцева Даша. В 2017 году)');
end;

procedure TFgraphics.PBdrawMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbLeft then
  begin
    Drawing := True;
    ToolList[ToolNum].MouseDown(x, y);
  end;
  if (Length(SelectFig) > 0) and (ToolNum <> 8) then
    SetLength(SelectFig, 0);
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
    ToolList[ToolNum].MouseUp(x, y, True, PanelOptions);
  if Button = mbRight then
    ToolList[ToolNum].MouseUp(x, y, False, PanelOptions);
  changeOp := False;
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
  begin
    SelectFig[High(SelectFig)].Draw(PBdraw.Canvas);
    DrawAnchors(PBdraw.Canvas);
  end;
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
