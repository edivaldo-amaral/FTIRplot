set term png size 1200,900
set output "image_temp.png"
set ylabel "Transmitância (%)" font "Arial,20" offset 0.2,0
set tics out nomirror
set yrange [0:1]
set mxtics 5 
set mytics 2 
set tics font",12"
set label 1 "Espectro de FTIR" at screen 0.5, 0.94 center font "Arial,20"
set label 2 "Número de onda (cm^-1)" at screen 0.5, 0.035 center font "Arial,20"
set size 1, 0.90
set origin 0.010, 0.04
#set grid x
#set grid y
#set grid mxtics
#set grid mytics
set xrange [4000:400]
set bmargin 5
set tmargin 3
set rmargin 4
set lmargin 11
plot 'C:\FTIRplot\arquivo.dpt' with lines lw 1 linecolor rgb "black" title "Dados"
