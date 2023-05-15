unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Process;

type

  { TForm2 }

  TForm2 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    Timer2: TTimer;
  procedure PlotData;
  procedure FormCreate(Sender: TObject);
  procedure Timer1Timer(Sender: TObject);
  procedure Timer2Timer(Sender: TObject);

  private

  public

  end;

var

  Form2: TForm2;

implementation
uses
  Unit1;
{$R *.lfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
Position:=poMainFormCenter;

Timer1.Enabled := True; // habilita o timer
Timer2.Enabled := True; // habilita o timer
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
 Timer1.Enabled := False;
 PlotData;
 Form1.MostraImagem;
 Timer2.Enabled := False;
 Close;
end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin

  if Label1.Visible then
    Label1.Visible := False
  else
    Label1.Visible := True;
end;


procedure TForm2.PlotData;
var
Process: TProcess;
CurrentDir: string;
begin
// Executa o "gnuplot" e passa o script para ele
CurrentDir := GetCurrentDir;
Process := TProcess.Create(nil);
try

  Process.Executable := CurrentDir + '\gnuplot\gnuplot.exe';
  Process.Parameters.Add('script.gnu');
  Process.Options := [poNoConsole]; //evita exibir janela do terminal ao executar o programa externo
  Process.Execute;

finally
  Process.Free;
end;
end;



end.

