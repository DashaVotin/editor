unit Uoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus, Graph,
  ExtCtrls, StdCtrls, Spin;

type

  Toptions = class
    procedure AClick(ASender: TObject); virtual; abstract;
    constructor Create(Parent: TPanel); virtual; abstract;
  end;

  TpenColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    constructor Create(Parent: TPanel); override;
  end;

  Twidth = class(Toptions)
    procedure AClick(ASender: TObject); override;
    constructor Create(Parent: TPanel); override;
  end;

  TfillColor = class(Toptions)
    procedure AClick(ASender: TObject); override;
    constructor Create(Parent: TPanel); override;
  end;

  TbrushStyle = class(Toptions)
    procedure AClick(ASender: TObject); override;
    constructor Create(Parent: TPanel); override;
  end;

  Tround = class(Toptions)
    procedure AClick(ASender: TObject); override;
    constructor Create(Parent: TPanel); override;
  end;

var
  PenColor, FillColor: TColor;
  Width, Round: integer;
  Bstyle: boolean;

implementation

uses main;

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

constructor TbrushStyle.Create(Parent: TPanel);
var
  checkbox: TCheckBox;
begin
  checkbox := TCheckBox.Create(Fgraphics);
  checkbox.Parent := Parent;
  checkbox.Left := 50;
  checkbox.Top := 50;
  checkbox.Width := 24;
  checkbox.Height := 50;
  checkbox.Checked := Bstyle;
  checkbox.Caption := 'Заливка';
  checkbox.OnClick := @AClick;
end;

constructor TpenColor.Create(Parent: TPanel);
var
  button: TColorButton;
begin
  button := TColorButton.Create(Fgraphics);
  button.Parent := Parent;
  button.Left := 10;
  button.Top := 10;
  button.Width := 30;
  button.Height := 30;
  button.ButtonColor := Figures[High(Figures)].PenColor;
  button.OnColorChanged := @AClick;
end;

constructor TfillColor.Create(Parent: TPanel);
var
  button: TColorButton;
begin
  button := TColorButton.Create(Fgraphics);
  button.Parent := Parent;
  button.Left := 10;
  button.Top := 50;
  button.Width := 30;
  button.Height := 30;
  button.ButtonColor := Figures[High(Figures)].FillColor;
  button.OnColorChanged := @AClick;
end;

constructor Twidth.Create(Parent: TPanel);
var
  edit: TSpinEdit;
begin
  edit := TSpinEdit.Create(Fgraphics);
  edit.Parent := Parent;
  edit.Left := 50;
  edit.Top := 10;
  edit.Width := 50;
  edit.Height := 28;
  edit.Text := IntToStr(Figures[High(Figures)].Width);
  edit.OnChange := @AClick;
end;

constructor Tround.Create(Parent: TPanel);
var
  edit: TSpinEdit;
  roundlabel: TLabel;
begin
  edit := TSpinEdit.Create(Fgraphics);
  roundlabel := TLabel.Create(Fgraphics);
  edit.Parent := Parent;
  edit.Left := 10;
  edit.Top := 115;
  edit.Width := 50;
  edit.Height := 28;
  roundlabel.Parent := Parent;
  roundlabel.Left := 10;
  roundlabel.Top := 90;
  roundlabel.Width := 50;
  roundlabel.Height := 20;
  roundlabel.Caption := 'Сила закругления';
  edit.Text := IntToStr(Figures[High(Figures)].Round);
  edit.OnChange := @AClick;
end;

end.
