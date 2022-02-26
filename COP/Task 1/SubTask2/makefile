CC=g++
CFLAGS=-o

MKLROOT=/usr/include/mkl
MKLLIB= /usr/include/mkl/intel64

MKLFLAGS=-lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl -fopenmp

MKLEXTRA=-Wl,--no-as-needed
# MKLEXTRA=-Wl,-rpath $(MKLLIB)

OPENBLASROOT=/usr/include/x86_64-linux-gnu/openblas-pthread/
OPENBLASLIB=/usr/include/x86_64-linux-gnu/

OPENBLASFLAGS=-lopenblas -lgfortran

all:
	$(CC) -I $(MKLROOT) -L $(MKLLIB) $(MKLEXTRA) -I $(OPENBLASROOT) -L $(OPENBLASLIB) $(MKLFLAGS) $(OPENBLASFLAGS) *.cpp $(CFLAGS) yourcode.out

clean:
	-rm *.out