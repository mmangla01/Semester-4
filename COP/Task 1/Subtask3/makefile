CFLAGS = -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl
MKL_PATH=$(realpath $(MKL_BLAS_PATH))
LIBRARY_PATH='$(LD_LIBRARY_PATH)'

MKL_COMMAND = -L $(MKL_PATH)/lib -I $(MKL_PATH)/include -Wl,-rpath,$(MKL_PATH)/lib $(CFLAGS)
all: library shared main
library: 
	g++ -c -Wall $(MKL_COMMAND) -fpic libaudio.cpp 
shared:
	g++ -shared -o libaudio.so libaudio.o $(MKL_COMMAND)
main:
	g++ -L $(LIBRARY_PATH) $(MKL_COMMAND) driver.cpp -o ./yourcode.out -laudio
clean:
	-rm *.out *.o *.so