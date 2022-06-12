unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Windows, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonConverterHSL: TButton;
    ButtonConverterRGB: TButton;
    ButtonRetornar: TButton;
    EditR: TEdit;
    EditG: TEdit;
    EditB: TEdit;
    EditH: TEdit;
    EditS: TEdit;
    EditL: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure ButtonConverterHSLClick(Sender: TObject);
    procedure ButtonConverterRGBClick(Sender: TObject);
    procedure ButtonRetornarClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation
uses
  Unit1;
{$R *.lfm}

{ TForm1 }

procedure MinMax(r, g, b: Real; var min, max:Real);
begin
  if (r > g) then begin
    if (r > b) then begin
      max := r;
      if (g < b) then begin
        min := g;
      end
      else begin
        min := b;
      end;
    end
    else begin
      max := b;
      min := g;
    end;
  end
  else begin
    if (g > b) then begin
      max:=g;
      if b < r then begin
        min:= b;
      end
      else begin
        min := r;
      end;
    end
    else begin
      max:= b;
      min:= r;
    end;
  end;
end;

procedure RGBToHSL(r, g, b: Real; out h, s, l:Real);
var
  V, C: Real;
  min, max: Real;
begin
  MinMax(r, g, b, min, max);
  V := max;
  C := max - min;
  l:= V-C/2;
  if ((l = 0) or (l = 1)) then begin
    s := 0;
    h := 0;
    exit;
  end;
  if (r = V) then begin
    h := (g-b)/C;
  end
  else begin
    if (g = max) then begin
      h := 2 + (b-r)/C;
    end
    else begin
      h := 4 + (r-g)/C;
    end;
  end;
  h := h*40;
  if (h < 0) then
     h := h + 240;
  s := C/(1 - Abs(2*V-C-1))
end;

procedure HSLToRGB(h, s, l: Real; out r, g, b: Real);
var
  i: Integer;
  c, x, m, temp: Real;
begin
  if (s = 0) then begin
    r := l;
    g := l;
    b := l;
    exit;
  end;
  h := h/40;
  i := Floor(h);
  temp := h - i;
  c := (1-abs(2*l-1))*s;
  x := c*(1-(abs((i div 2) + temp - 1)));
  case i of
       0: begin
         r := c; g := x; b := 0;
       end;
       1: begin
         r := x; g := c; b := 0;
       end;
       2: begin
         r := 0; g := c; b := x;
       end;
       3: begin
         r := 0; g := x; b := c;
       end;
       4: begin
         r := x; g := 0; b := c;
       end;
       else begin
         r := c; g := 0; b := x;
       end;
  end;
  m := l - c/2;
  r:= r + m;
  g:= g + m;
  b:= b + m;
end;

procedure TForm1.ButtonConverterHSLClick(Sender: TObject);
var
  r, g, b: Real;
  h, s, l: Real;
  i, j: Integer;
begin
  Image1.Enabled := true;
  r:= StrToFloat(EditR.Text)/255;
  g:= StrToFloat(EditG.Text)/255;
  b:= StrToFloat(EditB.Text)/255;
  RGBToHSL(r, g, b, h, s, l);
  EditH.Text := IntToStr(round(h));
  EditS.Text := IntToStr(round(240*s));
  EditL.Text := IntToStr(round(240*l));
  for i := 0 to Image1.Height-1 do
  for j := 0 to Image1.Width-1 do
  begin
    Image1.Canvas.Pixels[j,i] := RGB(StrToInt(EditR.Text), StrToInt(EditG.Text), StrToInt(EditB.Text));
  end;
end;

procedure TForm1.ButtonConverterRGBClick(Sender: TObject);
var
  r, g, b: Real;
  h, s, l: Real;
  i, j: Integer;
begin
  Image1.Enabled := true;
  h:= StrToFloat(EditH.Text);
  s:= StrToFloat(EditS.Text)/240;
  l:= StrToFloat(EditL.Text)/240;
  HSLToRGB(h, s, l, r, g, b);
  r:= round(r*255);
  g:= round(g*255);
  b:= round(b*255);
  EditR.Text := IntToStr(round(r));
  EditG.Text := IntToStr(round(g));
  EditB.Text := IntToStr(round(b));
  for i := 0 to Image1.Height-1 do
  for j := 0 to Image1.Width-1 do
  begin
      Image1.Canvas.Pixels[j,i] := RGB(round(r), round(g), round(b));
  end;
end;

procedure TForm1.ButtonRetornarClick(Sender: TObject);
begin
  Close;
end;

end.

