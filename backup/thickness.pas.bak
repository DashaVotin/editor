unit thickness;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls;

type

  { TFthickness }

  TFthickness = class(TForm)
    BTok: TButton;
    SEthickness: TSpinEdit;
    procedure BTokClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Fthickness: TFthickness;
  ActualThicknes1: integer;

implementation

{$R *.lfm}

{ TFthickness }

procedure TFthickness.BTokClick(Sender: TObject);
begin
  ActualThicknes1:=StrToInt(SEthickness.Text);
  Fthickness.Close;
end;

end.

