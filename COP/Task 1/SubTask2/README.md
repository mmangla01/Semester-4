# COP290 Task1
We intend to build an **audio-processing library** using **C++** as language.
## Authors
> **Name:**  Reedam Dhake, Mayank Mangla
> **Entry Number:**  2020CS10372, 2020CS50430
# Subtask 2
Accelerate matrix multiplication speed for FC in your previous implementation with
- linear algebra libraries mkl and openblas. Are these libraries faster than your own C++ matrix multiplication?
- pthreads. Check for correct computation of the matrix multiplication results and synchronization issues with multiple threads if any.

Measure mean and standard deviation of latencies of the three implementations (mkl, openblas and your pthread implementation) over different matrix sizes and plot a box plot with error bars using gnuplot. 

## Functions Implemented

 - `main()` :  This is the main function of the c++ code.
 - `check_integer()`  : Checks if the input string is a perfect integer.
 - `fcmult()`  :  Function regarding fully connected layer.
 - `reluAct()`  :  This function takes input a matrix and applies the relu function on each element of the matrix to output a matrix.
 - `tanhAct()`  :  This function takes input a matrix and applies the tanh function on each element of the matrix to output a matrix.
 - `sigmoid()`  :  This function takes input a matrix and applies the sigmoid function on each element of the matrix to output a matrix of probabilities.
 - `softmax()`  :  This function takes input a matrix and applies the softmax function on each element of the matrix to output a matrix of probabilities.
 - `maxpool()`  :  This function takes a matrix as input and an integer stride to calculate maxpool of the given matrix.
 - `averagepool()`  :  This function takes a matrix as input and an integer stride to calculate averagepool of the given matrix.
 - `check_text()`  :  This function checks if the input argument has a .txt file to read.
 - `read_matrix()`  :  This function reads a matrix in column major form from an input text file whose name is passed as an argument to it.
 - `read_vector()`  :  This function reads a vector from an input text file whose name is passed as an argument to it.
 - `write_matrix()`  :  This function writes a matrix given as an argument to a text file whose name is also given as an argument in a column major form.
 - `write_vector()`  :  This function writes a vector given as an argument to a text file whose name is also given as an argument in a column form.
 - `input_number_check()`  :  This checks if the number of command-line arguments obtained are sufficient or not.
 - `fcmult_openblas()`  :  Function implementing matrix multiplication using openblas library.
 - `fcmult_mkl()`  :  Function implementing matrix multiplication using mkl library.
 - `partial_multiply()`  :  Function which performs partial matrix multiplications handled by a single thread in case of multi-threading.
 - `fcmult_pthreads()`  :  Function implementing matrix multiplication using pthreads.

## Custom Structs and Data Structure Implemented
- `Matrix`  :  Matrix class used to store data of the matrix in an organised form.
- `thread_args`  : This is a struct to pass parameter to each thread to divide the work.

## Errors Handled

 - Error regarding incorrect command-line input or insufficient commandline arguments.
 - Error regarding incorrect type of input in text file like integer not provided in case of number of rows or columns.
 - Error regarding sizes of matrices in case of FC layer calculations.
 - Error regarding existence of file.
 - Error regarding stride being factor or size of input matrix.

## Directory Structure

```bash
2020CS10372_2020CS50430
├── GNU plots and scripts
│    ├── mkl_gnu.eps
│    ├── mkl_gnu.p
│    ├── mkl_gnu.png
│    ├── openblas_gnu.eps
│    ├── openblas_gnu.p
│    ├── openblas_gnu.png
│    ├── pthread_gnu.eps
│    ├── pthread_gnu.p
│    └── pthread_gnu.png
├── main.cpp
├── makefile
├── Matrix.h
├── mkl.cpp
├── openblas.cpp
└── README.md
```
## Libraries Used
```
#include  <iostream>
#include  <vector>
#include  <fstream>
#include  <cmath>
#include  <string.h>
#include  <pthread.h>
#include  "{MKLROOT}/mkl.h"
#include  "{OPENBLASROOT}/cblas.h"
#include  "Matrix.h"    ## Matrix.h has a matrix class to implement custom data structure for matrix
```
## Commands
** Change the path of {MKLROOT}, {MKLLIB}, {OPENBLASROOT} and {OPENBLASLIB} accordingly. **
** Also change the path of "mkl.h" and "cblas.h" in the mkl.cpp and openblas.cpp respectively. **
Now you are ready to run the following commands
For commands 3-10 replace any .txt file with the name .
 1. `make` : Run this command to create an executable file named yourcode.out.
 2. `./yourcode.out fullyconnected mkl input1.txt input2.txt input3.txt output.txt` : Use this to run the FC layer function using mkl library.
 3. `./yourcode.out fullyconnected openblas input1.txt input2.txt input3.txt output.txt` : Use this to run the FC layer function using openblas library.
 4. `./yourcode.out fullyconnected pthread input1.txt input2.txt input3.txt output.txt` : Use this to run the FC layer function that is implemented using multi-threading.
 5. `./yourcode.out activation relu input1.txt output.txt` : Use this to run relu activation function.
 6. `./yourcode.out activation tanh input1.txt output.txt`: Use this to run the tanh activation function.
 7. `./yourcode.out pooling max input1.txt 2 output.txt`: Use this to run max pooling function. You can input any stride in the command here it is 2.
 8. `./yourcode.out pooling average input1.txt 2 output.txt`: Use this to run average pooling function. You can input any stride in the command here it is 2.
 9. `./yourcode.out probability softmax input1.txt output.txt`: Use this to run the softmax probability function.
 10. `./yourcode.out probability sigmoid input1.txt output.txt`: Use this to run the sigmoid probability function.

