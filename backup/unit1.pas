unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Process, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LazUTF8, IntfGraphics, ExtDlgs, Spin, ActnList, EditBtn,
  ButtonPanel, ColorBox, BGRABitmap;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBoxGridX: TCheckBox;
    CheckBoxGridY: TCheckBox;
    CheckBoxComprimir: TCheckBox;
    ColorBox1: TColorBox;
    ComboBoxTicsY: TComboBox;
    ComboBoxYmin: TComboBox;
    ComboBoxYmax: TComboBox;
    ComboBoxFont: TComboBox;
    ComboBoxFontSize: TComboBox;
    ComboBoxResolucaoX: TComboBox;
    ComboBoxResolucaoY: TComboBox;
    ComboBoxTicFontSize: TComboBox;
    ComboBoxTicsX: TComboBox;
    Image1: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    NomeEixoX: TEdit;
    NomeEixoY: TEdit;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    SavePictureDialog1: TSavePictureDialog;
    Titulo: TEdit;
    Xa: TEdit;
    Xb: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBoxGridXChange(Sender: TObject);
    procedure CheckBoxComprimirChange(Sender: TObject);
    procedure CheckBoxGridYChange(Sender: TObject);
    procedure ColorBox1Click(Sender: TObject);
    procedure ComboBoxFontChange(Sender: TObject);
    procedure ComboBoxFontSizeChange(Sender: TObject);
    procedure ComboBoxResolucaoXChange(Sender: TObject);
    procedure ComboBoxResolucaoYChange(Sender: TObject);
    procedure ComboBoxTicFontSizeChange(Sender: TObject);
    procedure ComboBoxTicsXChange(Sender: TObject);
    procedure ComboBoxTicsYChange(Sender: TObject);
    procedure ComboBoxYminChange(Sender: TObject);
    procedure FontSizeTicsChange(Sender: TObject);
    procedure NomeEixoXChange(Sender: TObject);
    procedure NomeEixoYChange(Sender: TObject);
    procedure ResolucaoXChange(Sender: TObject);
    procedure ResolucaoXEditingDone(Sender: TObject);
    procedure ResolucaoYChange(Sender: TObject);
    procedure ResolucaoYEditingDone(Sender: TObject);
    procedure TicsChange(Sender: TObject);
    procedure TituloChange(Sender: TObject);
    procedure XaChange(Sender: TObject);
    procedure XbChange(Sender: TObject);
    //procedure Edit1SizeConstraintsChange(Sender: TObject);
//    procedure PlotData(const FileName: string);
    procedure FormCreate(Sender: TObject);
    procedure AtualizaScript(const FileName: string);

  private

  public
  FileNameDados: string;
  XaAnterior: string;
  XbAnterior: string;
  TituloAnterior: string;
  NomeEixoYAnterior: string;
  NomeEixoXAnterior: string;
  Coment:string;
  procedure MostraImagem;
  end;

var
  Form1: TForm1;
  Cor: string = 'black'; //Variavel para mudar a cor da linha plotada.
  ComentGridX:string = '#';
  ComentGridY:string = '#';
implementation
uses
  Unit2;
{$R *.lfm}

{ TForm1 }

//O Evento OnCreate está configurado para iniciar este procedimento ao iniciar.
procedure TForm1.FormCreate(Sender: TObject);
begin
  XaAnterior := Xa.Text;
  XbAnterior := Xb.Text;
  TituloAnterior:=Titulo.Text;
  NomeEixoYAnterior:=NomeEixoY.Text;
  NomeEixoXAnterior:=NomeEixoX.Text;
  Panel2.Enabled:=false;

  ColorBox1.Items.AddObject('Preto', TObject(clBlack));
  ColorBox1.Items.AddObject('Azul', TObject(clBlue));
  ColorBox1.Items.AddObject('Vermelho', TObject(clRed));
  ColorBox1.Items.AddObject('Verde', TObject(clGreen));
  ColorBox1.Items.AddObject('Roxo', TObject(clPurple));
  ///ColorBox1.Items.AddObject('Branco', TObject(clWhite));
  ColorBox1.Items.AddObject('Cinza', TObject(clGray));
  //ColorBox1.Items.AddObject('Cinza claro', TObject(clLtGray));
  //ColorBox1.Items.AddObject('Prata', TObject(clSilver));
  ColorBox1.Items.AddObject('Amarelo', TObject(clYellow));
  //ColorBox1.Items.AddObject('Marrom', TObject(clMaroon));
  //ColorBox1.Items.AddObject('Verde claro', TObject(clLime));
  //ColorBox1.Items.AddObject('Verde e azul', TObject(clTeal));
  //ColorBox1.Items.AddObject('Azul marinho', TObject(clNavy));
  //ColorBox1.Items.AddObject('Azul claro', TObject(clAqua));
  //ColorBox1.Items.AddObject('Rosa', TObject(clFuchsia));

end;

procedure TForm1.AtualizaScript(const FileName: string);
var
StringList: TStringList;
GerarScriptGNUplot: string;
begin
 StringList := TStringList.Create;

 //----Verifica se é viável comprimir acima de 2000
  if (StrToInt(Xa.Text) <= 2900) or (StrToInt(Xb.Text) >= 1900) then
  begin
     CheckBoxComprimir.Visible:=false; // Esconde
     CheckBoxComprimir.Checked:=false;
  end else
  begin
     CheckBoxComprimir.Visible:=true; // Mostra
  end;
  //----


 try
   StringList.Add('set term png size %s,%s',[ComboBoxResolucaoX.Text, ComboBoxResolucaoY.Text]);
   StringList.Add('set output "image_temp.png"');
   StringList.Add('set ylabel "%s" font "%s,%s" offset 0.2,0',[NomeEixoY.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]);
   StringList.Add('set tics out nomirror');
   StringList.Add('set yrange [%s:%s]',[ComboBoxYmin.Text, ComboBoxYmax.Text]); //Eixo Y (intervalo de 0 a 1)
   StringList.Add('set mxtics %s ',[ComboBoxTicsX.Text]); //traços de divisoes no eixo X
   StringList.Add('set mytics %s ',[ComboBoxTicsY.Text]); //traços de divisoes no eixo Y
   StringList.Add('set tics font",%s"',[ComboBoxTicFontSize.Text]); //Label11 da fonte
   StringList.Add('set label 1 "%s" at screen 0.5, 0.94 center font "%s,%s"',[Titulo.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]); //Texto acima do Grafico
   StringList.Add('set label 2 "%s" at screen 0.5, 0.035 center font "%s,%s"',[NomeEixoX.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]); //Texto abaixo do Eixo X
   StringList.Add('set size 1, 0.90');
   StringList.Add('set origin 0.010, 0.04');
   StringList.Add('%sset grid x',[ComentGridX]);
   StringList.Add('%sset grid y',[ComentGridY]);
   StringList.Add('%sset grid mxtics',[ComentGridX]);
   StringList.Add('%sset grid mytics',[ComentGridY]);


 if CheckBoxComprimir.Checked = false then
 begin
   //StringList.Add('set title "%s" font "%s,%s" offset 0,-0.7',[Titulo.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]);
   //StringList.Add('set xlabel "%s" font "%s,%s" offset 0,-1',[NomeEixoX.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]); //deslocamento 20
   StringList.Add('set xrange [%s:%s]',[Xa.Text, Xb.Text]);
   StringList.Add('set bmargin 5');  //Largura da margem inferior
   StringList.Add('set tmargin 3');  //Largura da gargem superior
   StringList.Add('set rmargin 4');  //Largura da margem direita
   StringList.Add('set lmargin 11'); //Largura da margem esquerda

   StringList.Add('plot ''%s'' with lines lw 1 linecolor rgb "%s" title "Dados"',[FileName, Cor]);
   //ShowMessage('script.gnu gerado com sucesso!');
 end
 else
 begin
   //StringList.Add('set xlabel "%s" font "%s,%s" offset 38,-1',[NomeEixoX.Text, ComboBoxFont.Text, ComboBoxFontSize.Text]); //deslocamento 20
   StringList.Add('set multiplot layout 1,3');
   //StringList.Add('set tics font",%s"',[ComboBoxTicFontSize.Text]); //Label11 da fonte


   //Lado esquerdo do grafico
   StringList.Add('set xrange [%s:2000]',[Xa.Text]); //Eixo X1 (de 4000 a 2000)
   StringList.Add('set size 0.334,0.9'); //Label11 do primeiro grafico
   StringList.Add('set origin 0.010, 0.04');
   //StringList.Add('set xtics (4500,4000,3500,3000,2500,2000)'); //Define os Tics
   StringList.Add('set rmargin 0');  //Largura da borda/magem direita
   StringList.Add('set border 7'); //Conf. padrao da borda
   StringList.Add('set bmargin 5'); // Largura da margem inferior
   StringList.Add('set tmargin 3');  //Largura da margem superior
   StringList.Add('set lmargin 11'); //Largura da margem esquerda
   StringList.Add('set mxtics %s ',[ComboBoxTicsX.Text]); //traços de divisoes no eixo
   StringList.Add('plot ''%s'' with lines lw 1 linecolor rgb "%s" notitle',[FileName, Cor]);


   //Lado direito do grafico
   StringList.Add('set xrange [1999:%s]',[Xb.Text]);
   StringList.Add('set size 0.65,0.9');
   StringList.Add('set origin 0.3436, 0.04');
   StringList.Add('set lmargin 0'); //Conf. padrao (espaço entre os 2 graf.)
   StringList.Add('set rmargin 2'); //Largura do exixo x do segundo grafico
   StringList.Add('set bmargin 5'); //Largura da margem inferior
   StringList.Add('set tmargin 3');  //Largura da margem superior
   StringList.Add('set border 13'); //Conf. padrao da borda
   //StringList.Add('unset xlabel');
   StringList.Add('unset ylabel');
   StringList.Add('unset ytics');
   //StringList.Add('set grid y');
   StringList.Add('%sset ytics  scale 0.1  font",0"',[ComentGridY]);  //Nao inserir tics no eixo y do segundo grafico

   //StringList.Add('set ticscale 0.1');
   //StringList.Add('set border 0 linecolor "red"');
   //StringList.Add('unset xtics');
   StringList.Add('set xtics auto'); // Retorna os Tics automaticos
   StringList.Add('set mxtics %s ',[ComboBoxTicsX.Text]); //traços de divisÃµes no eixo
   StringList.Add('plot ''%s'' with lines lw 1 linecolor rgb "%s" title "Dados"',[FileName, Cor]);
   StringList.Add('reset');
 end;

 GerarScriptGNUplot := ExtractFilePath(ParamStr(0)) + 'script.gnu';
 StringList.SaveToFile(GerarScriptGNUplot);

 finally
  StringList.Free;

  Form2.ShowModal;
 end;
end;


procedure TForm1.MostraImagem;
var
CurrentDir : string;
i: Integer;
begin
  CurrentDir := GetCurrentDir;
  while not FileExists(CurrentDir+'\image_temp.png') do //Aguarda o arquivo ser criado.
   begin
   Sleep(10);
  end;


  for i := 1 to 10 do
  begin
    try
      Image1.Picture.LoadFromFile(CurrentDir + '\image_temp.png');
      // Se chegou até aqui, a imagem foi carregada com sucesso
      Break; // Sai do laço de repetição
    except
      // Caso haja uma exceção (por exemplo, o arquivo está sendo usado por outro programa),
      // espera um intervalo de tempo e tenta novamente
      Sleep(100);
    end;
  end;


  //Apaga a imagem temporaria do diretorio
  if FileExists(CurrentDir+'\image_temp.png') then DeleteFile(CurrentDir+'\image_temp.png');
end;


procedure TForm1.Button1Click(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    if OpenDialog.Execute then
    begin
      FileNameDados := OpenDialog.FileName;
      //PlotData(FileNameDados);  // Chama a função que plota os dados com o "gnuplot"
     // MostraImagem;
     AtualizaScript(FileNameDados);

      Panel2.Enabled:=true; //Habilita o Panel

    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  if Image1.Picture.Graphic <> nil then
  begin
    SaveDialog := TSaveDialog.Create(Self);
    try
      SaveDialog.Filter := 'PNG Image|*.png';
      SaveDialog.InitialDir := 'C:\';
      if SaveDialog.Execute then
      begin
        if FileExists(SaveDialog.FileName) then
        begin
          if MessageDlg('O arquivo já existe, deseja sobreescrever?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
          begin
            Image1.Picture.SaveToFile(SaveDialog.FileName);
            MessageDlg('Imagem salva com sucesso em:'+ slinebreak +SaveDialog.FileName, mtInformation, [mbOK], 0);
          end
          else
            //ShowMessage('Operação cancelada pelo usuário.');
        end
        else
        begin
          Image1.Picture.SaveToFile(SaveDialog.FileName);
          MessageDlg('Imagem salva com sucesso em:'+ slinebreak +SaveDialog.FileName, mtInformation, [mbOK], 0);
        end;
      end
      else
      begin
        //ShowMessage('Operação cancelada pelo usuário.');
      end;
    finally
      SaveDialog.Free;
    end;
  end
  else
  begin
    //ShowMessage('Não há imagem para salvar.');
  end;
end;

procedure TForm1.CheckBoxGridXChange(Sender: TObject);
begin
  if CheckBoxGridX.Checked = true then
   begin
    ComentGridX:='';
    //ShowMessage('ueba!' + Coment + 'zebra');
   end
   else
   begin
    ComentGridX:='#';
   end;
AtualizaScript(FileNameDados);
end;



procedure TForm1.CheckBoxComprimirChange(Sender: TObject);
begin
  if CheckBoxComprimir.Checked = true then
   begin
    Coment:='';
    //ShowMessage('ueba!' + Coment + 'zebra');
   end
   else
   begin
    Coment:='#';
   end;
AtualizaScript(FileNameDados);
end;

procedure TForm1.CheckBoxGridYChange(Sender: TObject);
begin
  if CheckBoxGridY.Checked = true then
   begin
    ComentGridY:='';
    //ShowMessage('ueba!' + Coment + 'zebra');
   end
   else
   begin
    ComentGridY:='#';
   end;
AtualizaScript(FileNameDados);
end;

procedure TForm1.ColorBox1Click(Sender: TObject);
var
  SelectedColor: TColor;
begin
  Cor := LowerCase(Copy(ColorToString(ColorBox1.Selected), 3, MaxInt));
  AtualizaScript(FileNameDados);


end;

procedure TForm1.ComboBoxFontChange(Sender: TObject);
begin
 AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxFontSizeChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxResolucaoXChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxResolucaoYChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxTicFontSizeChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxTicsXChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;

procedure TForm1.ComboBoxTicsYChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;


procedure TForm1.ComboBoxYminChange(Sender: TObject);
begin
  AtualizaScript(FileNameDados);
end;


procedure TForm1.FontSizeTicsChange(Sender: TObject);
begin

end;

procedure TForm1.NomeEixoXChange(Sender: TObject);
begin
  if NomeEixoX.Text <> NomeEixoXAnterior then
   begin
    NomeEixoXAnterior:=NomeEixoX.Text;
    AtualizaScript(FileNameDados);
   end;
end;

procedure TForm1.NomeEixoYChange(Sender: TObject);
begin
  if NomeEixoY.Text <> NomeEixoYAnterior then
   begin
    NomeEixoYAnterior:=NomeEixoY.Text;
    AtualizaScript(FileNameDados);
   end;
end;

procedure TForm1.ResolucaoXChange(Sender: TObject);
begin

end;

procedure TForm1.ResolucaoXEditingDone(Sender: TObject);
begin

end;

procedure TForm1.ResolucaoYChange(Sender: TObject);
begin

end;

procedure TForm1.ResolucaoYEditingDone(Sender: TObject);
begin

end;

procedure TForm1.TicsChange(Sender: TObject);
begin

end;


procedure TForm1.TituloChange(Sender: TObject);
begin
  if Titulo.Text <> TituloAnterior then
  begin
    TituloAnterior := Titulo.Text;
    AtualizaScript(FileNameDados);
  end;
end;


procedure TForm1.XaChange(Sender: TObject);
begin
  if Xa.Text <> XaAnterior then
  begin
    XaAnterior := Xa.Text;
    AtualizaScript(FileNameDados);
    //ShowMessage('EventoXa');
    //Button1.SetFocus;
  end;
end;

procedure TForm1.XbChange(Sender: TObject);

begin
  if Xb.Text <> XbAnterior then
  begin
    XbAnterior := Xb.Text;
    //ShowMessage('EventoXb');
    AtualizaScript(FileNameDados);
  end;
end;



end.

