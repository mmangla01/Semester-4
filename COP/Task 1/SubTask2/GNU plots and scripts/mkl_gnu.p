unset key
# setting the ranges
set xrange [0:6]            
set yrange [0:100]
# labelling the axes
set xlabel "size of input matrix (scale 1:250)"
set ylabel "average running time (in millisec)"
set key
# calling for the plot
plot "time_mkl.dat" using 1:2:($3/10) title "Run time for mkl" linetype 7 linecolor 6 with errorbars
