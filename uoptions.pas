unit Uoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin;

type

  RfillStyles = record
    NameStyle: string;
    AStyle: TBrushStyle;
    AIndex: integer;
  end;

  RpenKind = record
    NameKind: string;
    Akind: TPenStyle;
    AIndex: integer;
  end;

  Toptions = class
    OptionName: string;
    procedure GetOption(ASender: TObject); virtual; abstract;
    function ToControls(AParent: TPanel): TControl; virtual; abstract;
    function ToLabels(Aparent: TPanel): TLabel;
    constructor Create; virtual; abstract;
  end;

  TpenColor = class(Toptions)
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Twidth = class(Toptions)
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TfillColor = class(Toptions)
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TfillStyle = class(Toptions)
    Styles: array[0..7] of RfillStyles;
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TpenKind = class(Toptions)
    Kinds: array[0..5] of RpenKind;
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Tround = class(Toptions)
    procedure GetOption(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

var
  gPenColor, gFillColor: TColor;
  gWidth, gRound: integer;
  gBstyle: RfillStyles;
  gPstyle: RpenKind;

implementation

procedure TpenColor.GetOption(ASender: TObject);
begin
  gPenColor := (ASender as TColorButton).ButtonColor;
end;

procedure Tround.GetOption(ASender: TObject);
begin
  try
    if StrToInt((ASender as TSpinEdit).Text) > 0 then
      gRound := StrToInt((ASender as TSpinEdit).Text)
    else
    begin
      gRound := 30;
      (ASender as TSpinEdit).Text := '30';
    end;
  except
    on  EConvertError do
    begin
      gRound := 30;
      (ASender as TSpinEdit).Text := '30';
    end;
  end;

end;

procedure TfillStyle.GetOption(ASender: TObject);
begin
  gBstyle.AStyle := Styles[(ASender as TComboBox).ItemIndex].AStyle;
  gBstyle.AIndex := (ASender as TComboBox).ItemIndex;
end;

procedure TpenKind.GetOption(ASender: TObject);
begin
  gPstyle.Akind := Kinds[(ASender as TComboBox).ItemIndex].Akind;
  gPstyle.AIndex := (ASender as TComboBox).ItemIndex;
end;

procedure TfillColor.GetOption(ASender: TObject);
begin
  gFillColor := (ASender as TColorButton).ButtonColor;
end;

procedure Twidth.GetOption(ASender: TObject);
begin
  try
    if StrToInt((ASender as TSpinEdit).Text) > 0 then
      gWidth := StrToInt((ASender as TSpinEdit).Text)
    else
    begin
      gWidth := 1;
      (ASender as TSpinEdit).Text := '1';
    end;
  except
    on  EConvertError do
    begin
      gWidth := 1;
      (ASender as TSpinEdit).Text := '1';
    end;
  end;
end;

constructor TfillStyle.Create;
begin
  OptionName := 'Стиль заливки';
  Styles[0].AStyle := bsSolid;
  Styles[0].NameStyle := 'Полная';
  Styles[1].AStyle := bsClear;
  Styles[1].NameStyle := 'Пустая';
  Styles[2].AStyle := bsHorizontal;
  Styles[2].NameStyle := 'Горизонтали';
  Styles[3].AStyle := bsVertical;
  Styles[3].NameStyle := 'Вертикали';
  Styles[4].AStyle := bsFDiagonal;
  Styles[4].NameStyle := 'Диагонали \';
  Styles[5].AStyle := bsBDiagonal;
  Styles[5].NameStyle := 'Диагонали /';
  Styles[6].AStyle := bsCross;
  Styles[6].NameStyle := 'Клетка';
  Styles[7].AStyle := bsDiagCross;
  Styles[7].NameStyle := 'Ромбы';
end;

constructor TpenKind.Create;
begin
  OptionName := 'Стиль линии';
  Kinds[0].AKind := psSolid;
  Kinds[0].NameKind := 'Обычная';
  Kinds[1].AKind := psClear;
  Kinds[1].NameKind := 'Без линии';
  Kinds[2].AKind := psDash;
  Kinds[2].NameKind := 'Пунктир';
  Kinds[3].AKind := psDashDot;
  Kinds[3].NameKind := 'Пунктир+точка';
  Kinds[4].AKind := psDashDotDot;
  Kinds[4].NameKind := 'Пунктир+2точки';
  Kinds[5].AKind := psDot;
  Kinds[5].NameKind := 'Точки';
end;

constructor TpenColor.Create;
begin
  OptionName := 'Цвет карандаша';
end;

constructor TfillColor.Create;
begin
  OptionName := 'Цвет заливки';
end;

constructor Twidth.Create;
begin
  OptionName := 'Толщина линии';
end;

constructor Tround.Create;
begin
  gRound := 30;
  OptionName := 'Сила закругления';
end;

function Toptions.ToLabels(Aparent: TPanel): TLabel;
begin
  Result := TLabel.Create(Aparent);
  Result.Parent := Aparent;
  Result.Caption := OptionName;
end;

function TfillStyle.ToControls(AParent: Tpanel): TControl;
var
  i: integer;
begin
  Result := TComboBox.Create(AParent);
  with Result as TComboBox do
  begin
    Parent := AParent;
    for i := 0 to 7 do
      Items.Add(Styles[i].NameStyle);
    ItemIndex := gBstyle.AIndex;
    OnChange := @GetOption;
    ReadOnly := True;
  end;
end;

function TpenKind.ToControls(AParent: Tpanel): TControl;
var
  i: integer;
begin
  Result := TComboBox.Create(AParent);
  with Result as TComboBox do
  begin
    Parent := AParent;
    for i := 0 to 5 do
      Items.Add(Kinds[i].NameKind);
    ItemIndex := gPstyle.AIndex;
    OnChange := @GetOption;
    ReadOnly := True;
  end;
end;

function TpenColor.ToControls(AParent: Tpanel): TControl;
begin
  Result := TColorButton.Create(AParent);
  with Result as TColorButton do
  begin
    Parent := AParent;
    ButtonColor := gPenColor;
    OnColorChanged := @GetOption;
  end;
end;

function TfillColor.ToControls(AParent: Tpanel): TControl;
begin
  Result := TColorButton.Create(AParent);
  with Result as TColorButton do
  begin
    Parent := AParent;
    ButtonColor := gFillColor;
    onColorChanged := @GetOption;
  end;
end;

function Twidth.ToControls(AParent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(AParent);
  with Result as TSpinEdit do
  begin
    Parent := AParent;
    Text := IntToStr(gWidth);
    OnChange := @GetOption;
  end;
end;

function Tround.ToControls(AParent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(AParent);
  with Result as TSpinEdit do
  begin
    Parent := AParent;
    Text := IntToStr(gRound);
    OnChange := @GetOption;
  end;
end;

end.
