unset key
# set the ranges of axes
set xrange [0:6]
set yrange [0:100]
# set the labels of the axes
set xlabel "size of input matrix (scale 1:250)"
set ylabel "average running time (in millisec)"
set key
# plot the graph
plot "time_openblas.dat" using 1:2:($3/10) title "Run time for openblas" linetype 7 linecolor 6 with errorbars