unset key
# set ranges 
set xrange [0:6]
set yrange [0:150]
# set labels of the axes
set xlabel "size of input matrix (scale 1:250)"
set ylabel "average running time (in 10 microsec)"
set key
# plot the graph
plot "time_pthread.dat" using 1:($2/100):($3/100000) title "Run time for pthread implementation" linetype 7 linecolor 6 with errorbars