unit Uoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin;

type

  Toptions = class
    OptionName: string;
    procedure AClick(ASender: TObject); virtual; abstract;
    function ToControls(AParent: TPanel): TControl; virtual; abstract;
    constructor Create; virtual; abstract;
  end;

  TpenColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Twidth = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TfillColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TbrushStyle = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Tround = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(AParent: TPanel): TControl; override;
    constructor Create; override;
  end;

  var
    gPenColor, gFillColor: TColor;
    gWidth, gRound: integer;
    gBstyle: boolean;

implementation

procedure TpenColor.AClick(ASender: TObject);
begin
  gPenColor := (ASender as TColorButton).ButtonColor;
end;

procedure Tround.AClick(ASender: TObject);
begin
  if StrToInt((ASender as TSpinEdit).Text) > 0 then
    gRound := StrToInt((ASender as TSpinEdit).Text)
  else
    gRound := 1;
end;

procedure TbrushStyle.AClick(ASender: TObject);
begin
  gBstyle := (ASender as TCheckBox).Checked;
end;

procedure TfillColor.AClick(ASender: TObject);
begin
  gFillColor := (ASender as TColorButton).ButtonColor;
end;

procedure Twidth.AClick(ASender: TObject);
begin
  if StrToInt((ASender as TSpinEdit).Text) > 0 then
    gWidth := StrToInt((ASender as TSpinEdit).Text)
  else
    gWidth := 1;
end;

function TbrushStyle.ToControls(AParent: Tpanel): TControl;
begin
  Result := TCheckBox.Create(AParent);
  with Result as TCheckBox do
  begin
    Parent := AParent;
    Checked:=gBstyle;
    Caption := 'Заливка';
    OnClick := @AClick;
  end;
end;

constructor TbrushStyle.Create;
begin
  OptionName := 'TbrushStyle';
end;

constructor TpenColor.Create;
begin
  OptionName := 'TpenColor';
end;

constructor TfillColor.Create;
begin
  OptionName := 'TfillColor';
end;

constructor Twidth.Create;
begin
  OptionName := 'Twidth';
end;

constructor Tround.Create;
begin
  gRound := 10;
  OptionName := 'Tround';
end;

function TpenColor.ToControls(AParent: Tpanel): TControl;
begin
  Result := TColorButton.Create(AParent);
  with Result as TColorButton do
  begin
    Parent := AParent;
    ButtonColor:=gPenColor;
    OnColorChanged := @AClick;
    Visible := True;
  end;
end;

function TfillColor.ToControls(AParent: Tpanel): TControl;
begin
  Result := TColorButton.Create(AParent);
  with Result as TColorButton do
  begin
    Parent := AParent;
    ButtonColor:=gFillColor;
    onColorChanged := @AClick;
  end;
end;

function Twidth.ToControls(AParent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(AParent);
  with Result as TSpinEdit do
  begin
    Parent := AParent;
    Text:=IntToStr(gWidth);
    OnChange := @AClick;
  end;
end;

function Tround.ToControls(AParent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(AParent);
  // roundlabel := TLabel.Create(Parent);
  with Result as TSpinEdit do
  begin
    Parent := AParent;
    //  roundlabel.Parent := Parent;
    //  roundlabel.Left := 10;
    //  roundlabel.Top := 90;
    //  roundlabel.Width := 50;
    //  roundlabel.Height := 20;
    //  roundlabel.Caption := 'Сила закругления';
    Text:=IntToStr(gRound);
    OnChange := @AClick;
  end;
end;

end.
