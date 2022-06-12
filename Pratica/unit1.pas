unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Menus, Windows, math, Unit2;

type

  { TmainFrame }

  TmainFrame = class(TForm)
    Button1: TButton;
    ButtonOperacao: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    EditRed: TEdit;
    EditGreen: TEdit;
    EditBlue: TEdit;
    EditEntrada: TEdit;
    LabelB: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label2: TLabel;
    LabelR: TLabel;
    LabelEntrada: TLabel;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItemConversor: TMenuItem;
    MenuItemMediana: TMenuItem;
    MenuItemSobel: TMenuItem;
    MenuItemLimiarizacao: TMenuItem;
    MenuItemLaplaciano: TMenuItem;
    MenuItemBinarizacao: TMenuItem;
    MenuItemRealce: TMenuItem;
    MenuItemFiltro: TMenuItem;
    MenuItemMedia: TMenuItem;
    MenuItemSaltPepper: TMenuItem;
    MenuItemEqualizacao: TMenuItem;
    MenuItemSepararCanais: TMenuItem;
    MenuItemInverteColorida: TMenuItem;
    MenuItemInverteCinza: TMenuItem;
    MenuItemArquivo: TMenuItem;
    MenuOperacoes: TMenuItem;
    MenuItemParaCinza: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemSalvar: TMenuItem;
    MenuItemSair: TMenuItem;
    OpenDialog1: TOpenDialog;
    LabelG: TLabel;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure ButtonOperacaoClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MenuItemConversorClick(Sender: TObject);
    procedure MenuItemMedianaClick(Sender: TObject);
    procedure MenuItemSobelClick(Sender: TObject);
    procedure MenuItemBinarizacaoClick(Sender: TObject);
    procedure MenuItemLaplacianoClick(Sender: TObject);
    procedure MenuItemLimiarizacaoClick(Sender: TObject);
    procedure MenuItemMediaClick(Sender: TObject);
    procedure MenuItemRealceClick(Sender: TObject);
    procedure MenuItemSaltPepperClick(Sender: TObject);
    procedure MenuItemEqualizacaoClick(Sender: TObject);
    procedure MenuItemSepararCanaisClick(Sender: TObject);
    procedure MenuItemInverteColoridaClick(Sender: TObject);
    procedure MenuItemInverteCinzaClick(Sender: TObject);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemParaCinzaClick(Sender: TObject);
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);
  private

  public

  end;

var
  mainFrame: TmainFrame;
  imE, imS: Array[0..319, 0..239] of byte;//Imagem Cinza
  r, g, b, c : byte;
  cor : TColor;
  i, j : Integer;
  operacao: integer;
implementation

{$R *.lfm}

procedure ShellSort(var a: array of Byte; const n: integer);
var i, j, h, v : integer;
begin
  h := 1;
  repeat
   h := 3*h + 1
  until h > n;
  repeat
   h := h div 3;
   for i := h + 1 to n do
    begin
     v := a[i];
     j := i;
     while (j > h) AND (a[j-h] > v) do
      begin
        a[j] := a[j-h];
        j := j - h;
      end;
     a[j] := v;
    end
   until h = 1;
end;

{ TmainFrame }

procedure TmainFrame.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Edit1.Text:=IntToStr(X);
  Edit2.Text:=IntToStr(Y);
  cor := Image1.Canvas.Pixels[X,Y];
  for i:=0 to Image5.Width-1 do
    for j:=0 to Image5.Height-1 do
    begin
         Image5.Canvas.Pixels[i,j]:= cor;
    end;
  EditRed.Text := IntToStr(Red(cor));
  EditGreen.Text := IntToStr(Green(cor));
  EditBlue.Text := IntToStr(Blue(cor));
end;

procedure TmainFrame.MenuItemConversorClick(Sender: TObject);
begin
     Form1.ShowModal;
end;

procedure TmainFrame.MenuItemMedianaClick(Sender: TObject);
var
  h, w, aux1, aux2, valorMediana: Integer;
  arrayBytes: Array[0..8] of Byte;
begin
  h:= Image1.Height-1;
  w:= Image1.Width-1;
  for j := 1 to h-1 do
  for i:= 1 to w-1 do
  begin
    valorMediana:= 0;
    for aux1:=0 to 2 do
    for aux2:=0 to 2 do
    begin
      arrayBytes[aux1*3+aux2] := imE[i+aux1-1,j+aux2-1];
    end;
    ShellSort(arrayBytes, 9);
    valorMediana := arrayBytes[4];
    ImS[i,j]:= valorMediana;
    Image2.Canvas.Pixels[i,j]:= RGB(valorMediana, valorMediana, valorMediana);
  end;
end;

procedure TmainFrame.MenuItemSobelClick(Sender: TObject);
var
  sobelHorizontal, sobelVertical: Array[0..319, 0..239] of byte;
  h, w, aux1, aux2, valorMedio, max, min: Integer;
begin
  h:= Image1.Height-1;
  w:= Image1.Width-1;
  //Sobel vertical
  for j := 1 to h-1 do
  for i:= 1 to w-1 do
  begin
    valorMedio:= 0;
    for aux1:=-1 to 1 do
    for aux2:=-1 to 1 do
    begin
    //termos negativos do Sobel
      if aux1 = -1 then
      begin
        if aux2 = 0 then
        begin
          valorMedio := valorMedio-2*imE[i+aux1, j+aux2];
        end
        else begin
          valorMedio := valorMedio-imE[i+aux1, j+aux2];
        end;
      end;
      //termos positivos do Sobel
      if aux1 = 1 then
      begin
        if aux2 = 0 then
        begin
          valorMedio := valorMedio+2*imE[i+aux1, j+aux2];
        end
        else begin
          valorMedio := valorMedio+imE[i+aux1, j+aux2];
        end;
      end;
      if valorMedio < 0 then
        valorMedio := 0;
      sobelHorizontal[i,j]:= round(valorMedio/sqrt(2));
    end;
  end;
  //Sobel horizontal
  for j := 1 to h-1 do
  for i:= 1 to w-1 do
  begin
    valorMedio:= 0;
    for aux1:=-1 to 1 do
    for aux2:=-1 to 1 do
    begin
      //termos negativos do Sobel
      if aux2 = -1 then
      begin
        if aux1 = 0 then
        begin
          valorMedio := valorMedio-2*imE[i+aux1, j+aux2];
        end
        else begin
          valorMedio := valorMedio-imE[i+aux1, j+aux2];
        end;
      end;
      //termos positivos do Sobel
      if aux2 = 1 then
      begin
        if aux1 = 0 then
        begin
          valorMedio := valorMedio+2*imE[i+aux1, j+aux2];
        end
        else begin
          valorMedio := valorMedio+imE[i+aux1, j+aux2];
        end;
      end;
      if valorMedio < 0 then
        valorMedio := 0;
      sobelVertical[i,j]:= round(valorMedio/sqrt(2));
      end;
    end;
    for j := 1 to h-1 do
    for i:= 1 to w-1 do
    begin
      valorMedio := round(sqrt(power(sobelVertical[i,j], 2)+power(sobelHorizontal[i,j], 2))/sqrt(2));
      if valorMedio > 255 then
        valorMedio := 255;
      ImS[i,j] := valorMedio;
    end;
    //Normalizacao
    max := ImS[0,0];
    min := max;
    for j := 0 to h-1 do
    for i := 0 to w-1 do
    begin
      if(ImS[i, j] < min) then
        min:=ImS[i, j];
      if(ImS[i, j] > max) then
        max:= ImS[i,j];
    end;
    for j := 0 to h-1 do
    for i := 0 to w-1 do
    begin
      ImS[i,j] := round(255*(ImS[i,j]-min)/(max-min));
      Image2.Canvas.Pixels[i,j] := RGB(ImS[i,j], ImS[i,j], ImS[i,j]);
    end;
end;

procedure TmainFrame.MenuItemBinarizacaoClick(Sender: TObject);
begin
  ButtonOperacao.Caption := 'Binarização';
  ButtonOperacao.Enabled := true;
  EditEntrada.Enabled := true;
  operacao := 2;
end;

procedure TmainFrame.MenuItemLaplacianoClick(Sender: TObject);
var
  h, w, aux1, aux2, valorMedio: Integer;
begin
    h:= Image1.Height-1;
    w:= Image1.Width-1;
    for j := 1 to h-1 do
      for i:= 1 to w-1 do
      begin
          valorMedio:= 0;
          for aux1:=-1 to 1 do
          for aux2:=-1 to 1 do
          begin
            //se (aux1 + aux2 = -1, entao aux1 = 0 e aux2 =-1 ou aux1 = -1 e aux2 = 0, idem para segunda condicao
            if (aux1 + aux2 = -1) or (aux1 + aux2 = 1) then
              valorMedio := valorMedio-imE[i+aux1, j+aux2];
            if (aux1 = 0) and (aux2 = 0) then
              valorMedio := valorMedio + 4*imE[i+aux1,j+aux2];
          end;
          if valorMedio > 255 then
            valorMedio := 255;
          if valorMedio < 0 then
            valorMedio := 0;
          ImS[i][j]:= valorMedio;
          Image2.Canvas.Pixels[i,j]:= RGB(valorMedio, valorMedio, valorMedio);
      end;
end;

procedure TmainFrame.MenuItemLimiarizacaoClick(Sender: TObject);
begin
  ButtonOperacao.Caption := 'Limiarização';
  ButtonOperacao.Enabled := true;
  EditEntrada.Enabled := true;
  operacao := 3;
end;

procedure TmainFrame.MenuItemMediaClick(Sender: TObject);
var
  h, w, aux1, aux2, valorMedio: Integer;
begin
    h:= Image1.Height-1;
    w:= Image1.Width-1;
    for j := 1 to h-1 do
      for i:= 1 to w-1 do
      begin
          valorMedio:= 0;
          for aux1:=-1 to 1 do
          for aux2:=-1 to 1 do
          begin
               valorMedio := valorMedio + imE[i+aux1,j+aux2];
          end;
          valorMedio := valorMedio div 9;
          ImS[i][j]:= valorMedio;
          Image2.Canvas.Pixels[i,j]:= RGB(valorMedio, valorMedio, valorMedio);
      end;
end;

procedure TmainFrame.MenuItemRealceClick(Sender: TObject);
begin
  ButtonOperacao.Caption := 'Realce';
  ButtonOperacao.Enabled := true;
  EditEntrada.Enabled := true;
  operacao := 1;
end;

procedure TmainFrame.MenuItemSaltPepperClick(Sender: TObject);
var
  h, w, taxa, x, y: Integer;
begin
    Randomize; //randomiza a seed
    Image2.Picture := Image1.Picture;
    h:= Image1.Height-1;
    w:= Image1.Width-1;
    taxa:= h*w div 10; //coloca a taxa de ruido para 10%
    for i := 0 to taxa do
    begin
         x := Random(w);
         y := Random(h);
         If Random>0.5 then //se o valor aleatorio gerado for maior do que 0.5, ruido branco
         begin
              Image2.Canvas.Pixels[x,y]:= RGB(255,255,255);
         end
         else//senao ruido preto
         begin
             Image2.Canvas.Pixels[x,y]:= RGB(0,0,0);
         end;
    end;
end;

procedure TmainFrame.MenuItemEqualizacaoClick(Sender: TObject);
var
  tcinza: byte;
  fa, his, val_eq: Array[0..255] of Integer;
  h, w: Integer;
begin
  h:= Image1.Height-1;
  w:= Image1.Width-1;
  for i:= 0 to 255 do
  begin
       fa[i]:=0;
       his[i]:=0;
  end;
  for i:= 0 to w do
    for j:= 0 to h do
    begin
        cor := Image1.Canvas.Pixels[i,j];
        tcinza := GetRValue(cor);
        his[tcinza] := his[tcinza] + 1;
    end;
  fa[0]:=his[0];
  for i:= 1 to 255 do
  begin
      fa[i] := fa[i-1] + his[i];
      val_eq[i] := ((255*fa[i]) div (w*h)-1);
  end;
  for i:= 0 to w do
    for j:= 0 to h do
    begin
        cor := Image1.Canvas.Pixels[i,j];
        tcinza := GetRValue(cor);
        Image2.Canvas.Pixels[i,j]:= RGB(val_eq[tcinza],val_eq[tcinza],val_eq[tcinza]);
    end;
end;

procedure TmainFrame.MenuItemSepararCanaisClick(Sender: TObject);
begin
   for i:= 0 to Image1.Width - 1 do
      for j:= 0 to Image1.Height - 1 do
      begin
          cor := Image1.Canvas.Pixels[i,j];
          r:= GetRValue(cor);
          g:= GetGValue(cor);
          b:= GetBValue(cor);
          Image2.Canvas.Pixels[i,j]:=RGB(r,0,0);
          Image3.Canvas.Pixels[i,j]:=RGB(0,g,0);
          Image4.Canvas.Pixels[i,j]:=RGB(0,0,b);

      end;
end;

procedure TmainFrame.MenuItemInverteColoridaClick(Sender: TObject);
begin
     for i:= 0 to Image1.Width - 1 do
      for j:= 0 to Image1.Height - 1 do
      begin
          cor := Image1.Canvas.Pixels[i,j];
          r:= Red(cor);
          g:= Green(cor);
          b:= Blue(cor);
          Image2.Canvas.Pixels[i,j] := RGB(255-r, 255-g, 255-b);
      end;
end;

procedure TmainFrame.MenuItemInverteCinzaClick(Sender: TObject);
begin
  for i:= 0 to Image1.Width - 1 do
      for j:= 0 to Image1.Height - 1 do
      begin
          Ims[i, j] := 255 - Ime[i,j];
          Image2.Canvas.Pixels[i,j] := RGB(Ims[i,j], Ims[i,j], Ims[i,j]);
      end;
end;

procedure TmainFrame.MenuItemAbrirClick(Sender: TObject);
begin
  if(OpenDialog1.Execute) then
  begin
      Image1.Enabled := true;
      Image1.Picture.LoadFromFile(OpenDialog1.FileName);
      for i:= 0 to Image1.Width - 1 do
      for j:= 0 to Image1.Height - 1 do
      begin
          cor := Image1.Canvas.Pixels[i,j];
          r:= Red(cor);
          g:= Green(cor);
          b:= Blue(cor);
          c:= round(r*0.299 + g*0.587 + b*0.114);
          Image2.Canvas.Pixels[i,j] := RGB(c,c,c);
          ImS[i, j] := c;
      end;
      Image2.AdjustSize;
      ImE := ImS;
  end;
end;

procedure TmainFrame.MenuItemParaCinzaClick(Sender: TObject);
begin
  for i:= 0 to Image1.Width - 1 do
      for j:= 0 to Image1.Height - 1 do
      begin
          cor := Image1.Canvas.Pixels[i,j];
          r:= Red(cor);
          g:= Green(cor);
          b:= Blue(cor);
          c:= round(r*0.299 + g*0.587 + b*0.114);
          Image2.Canvas.Pixels[i,j] := RGB(c,c,c);
          ImS[i, j] := c;
      end;
end;

procedure TmainFrame.MenuItemSairClick(Sender: TObject);
begin
  Close();
end;

procedure TmainFrame.MenuItemSalvarClick(Sender: TObject);
begin
  if(SaveDialog1.Execute)
  then
      Image2.Picture.SaveToFile(SaveDialog1.FileName);
end;

procedure TmainFrame.Button1Click(Sender: TObject);
begin
  Image1.Picture := Image2.Picture;
  ImE := ImS;
end;

procedure TmainFrame.ButtonOperacaoClick(Sender: TObject);
var
  gamma, aux : Real;
  limiar: integer;
begin
  case operacao of
        1://operacao do realce de potencia
          begin
            ImS := ImE;
            gamma := StrToFloat(EditEntrada.Text);
            for i:= 0 to Image1.Width - 1 do
              for j:= 0 to Image1.Height - 1 do
                begin
                  aux := ImE[i,j]/255;
                  aux := power(aux, gamma);
                  aux := aux*255;
                  ImS[i,j] := round(aux);
                  Image2.Canvas.Pixels[i,j]:= RGB(ImS[i,j],ImS[i,j],ImS[i,j]);
                end;
          end;

        2://operacao da binarizacao
          begin
            ImS := ImE;
            limiar := StrToInt(EditEntrada.Text);
            for i:= 0 to Image1.Width - 1 do
              for j:= 0 to Image1.Height - 1 do
              begin
                if ImE[i,j] >= limiar then begin
                  ImS[i,j] := 255;
                end
                else begin
                  ImS[i,j] := 0;
                end;
                Image2.Canvas.Pixels[i,j] := RGB(ImS[i,j],ImS[i,j],ImS[i,j]);
              end;
          end;

        3://operacao da limiarizacao
          begin
            ImS := ImE;
            limiar := StrToInt(EditEntrada.Text);
            for i:= 0 to Image1.Width - 1 do
              for j:= 0 to Image1.Height - 1 do
              begin
                if ImE[i,j] < limiar then begin
                  ImS[i,j] := 0;
                end;
                Image2.Canvas.Pixels[i,j] := RGB(ImS[i,j],ImS[i,j],ImS[i,j]);
              end;
          end;
  end;
end;

end.

