reset
set terminal png size 800,500 font "Arial,14";
set output 'grafico.png';

# plot data
#plot 'C:\FTIRplot\arquivo.dpt' with lines lw 1 linecolor rgb "blue" title "Dados"



set autoscale
set grid x
set grid y

set ylabel "I/O latency (us)"
set xlabel "I/O request number"
set term png

set title "EBS GP2 volume attachted to a t3a.small EC2 instance" 
plot 'C:\FTIRplot\arquivo.dpt' using 2
