reset
set terminal png size 800,500 font "Arial,14";
set output 'grafico.png';
#set sample 50
#set table 'C:\FTIRplot\arquivo.dpt'
#plot [0:10] 0.5+rand(0)
#unset table

#set yrange [0:2]
#unset key
plot 'C:\FTIRplot\arquivo.dpt' u 1:2
min_y = GPVAL_DATA_Y_MIN
max_y = GPVAL_DATA_Y_MAX

plot 'C:\FTIRplot\arquivo.dpt' u ($2 == min_y ? $1 : 1/0):1
min_pos_x = GPVAL_DATA_X_MIN
plot 'C:\FTIRplot\arquivo.dpt' u ($2 == max_y ? $1 : 1/0):1
max_pos_x = GPVAL_DATA_X_MAX

# Automatically adding an arrow at a position that depends on the min/max
set arrow 1 from min_pos_x, min_y-0.1 to min_pos_x, min_y lw 0.5
set arrow 2 from max_pos_x, max_y+0.1 to max_pos_x, max_y lw 0.5
set label 1 'Minimum' at min_pos_x, min_y-0.15 centre
set label 2 'Maximum' at max_pos_x, max_y+0.15 centre
plot 'C:\FTIRplot\arquivo.dpt' with lines lw 1 linecolor rgb "blue" title "Dados", \
    min_y title sprintf("Minimo Y: %.2f", min_y) at graph 0.95,0.95 left, \
    max_y title sprintf("Máximo Y: %.2f", max_y) at graph 0.95,0.90 left
