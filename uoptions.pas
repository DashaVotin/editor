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
    function ToControls(Parent: TPanel): TControl; virtual; abstract;
    constructor Create; virtual; abstract;
  end;

  TpenColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(Parent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Twidth = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(Parent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TfillColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(Parent: TPanel): TControl; override;
    constructor Create; override;
  end;

  TbrushStyle = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(Parent: TPanel): TControl; override;
    constructor Create; override;
  end;

  Tround = class(Toptions)
    procedure AClick(ASender: TObject); override;
    function ToControls(Parent: TPanel): TControl; override;
    constructor Create; override;
  end;

var
  PenColor, FillColor: TColor;
  Width, Round: integer;
  Bstyle: boolean;

implementation

procedure TpenColor.AClick(ASender: TObject);
begin
  PenColor := (ASender as TColorButton).ButtonColor;
end;

procedure Tround.AClick(ASender: TObject);
begin
  if StrToInt((ASender as TSpinEdit).Text) > 0 then
    Round := StrToInt((ASender as TSpinEdit).Text)
  else
    Round := 1;
end;

procedure TbrushStyle.AClick(ASender: TObject);
begin
  Bstyle := (ASender as TCheckBox).Checked;
end;

procedure TfillColor.AClick(ASender: TObject);
begin
  FillColor := (ASender as TColorButton).ButtonColor;
end;

procedure Twidth.AClick(ASender: TObject);
begin
  if StrToInt((ASender as TSpinEdit).Text) > 0 then
    Width := StrToInt((ASender as TSpinEdit).Text)
  else
    Width := 1;
end;

function TbrushStyle.ToControls(Parent: Tpanel): TControl;
begin
  Result := TCheckBox.Create(Parent);
  with Result as TCheckBox do
  begin
    Parent := Parent;
  {Left := 50;
  Top := 50;
  Width := 24;
  Height := 50; }
    //Result.Checked := Bstyle;
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
  OptionName := 'Tround';
end;

function TpenColor.ToControls(Parent: Tpanel): TControl;
begin
  Result := TColorButton.Create(Parent);
  with Result as TColorButton do
  begin
    Parent := Parent;
  {Left := 10;
  Top := 10;
  Width := 30;
  Height := 30;   }
    // Result.ButtonColor := Figures[High(Figures)].PenColor;
    OnColorChanged := @AClick;
    Visible := True;
  end;
end;

function TfillColor.ToControls(Parent: Tpanel): TControl;
begin
  Result := TColorButton.Create(Parent);
  with Result as TColorButton do
  begin
    Parent := Parent;
  {Left := 10;
  Top := 50;
  Width := 30;
  Height := 30;  }
    // button.ButtonColor := Figures[High(Figures)].FillColor;
    onColorChanged := @AClick;
  end;
end;

function Twidth.ToControls(Parent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(Parent);
  with Result as TSpinEdit do
  begin
    Parent := Parent;
 { Left := 50;
  Top := 10;
  Width := 50;
  Height := 28;   }
    // edit.Text := IntToStr(Figures[High(Figures)].Width);
    OnChange := @AClick;
  end;
end;

function Tround.ToControls(Parent: Tpanel): TControl;
begin
  Result := TSpinEdit.Create(Parent);
  // roundlabel := TLabel.Create(Parent);
  with Result as TSpinEdit do
  begin
    Parent := Parent;
{  Left := 10;
  Top := 115;
  Width := 50;
  Height := 28;    }
    // roundlabel.Parent := Parent;
    //  roundlabel.Left := 10;
    //  roundlabel.Top := 90;
    //  roundlabel.Width := 50;
    //  roundlabel.Height := 20;
    //  roundlabel.Caption := 'Сила закругления';
    //  edit.Text := IntToStr(Figures[High(Figures)].Round);
    OnChange := @AClick;
  end;
end;

end.
