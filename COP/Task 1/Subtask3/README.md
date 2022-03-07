# COP290 Task1
We intend to build an **audio-processing library** using **C++** as language.
## Authors
> **Name:**  Reedam Dhake, Mayank Mangla
> **Entry Number:**  2020CS10372, 2020CS50430
# Subtask 3
Implement a deep neural network (DNN) inference for classifying across 12 audio keywords (silence, unknown, yes, no, up, down, left, right, on, off, stop, go). [1x250] input features for each 1 second audio sample will be provided. Your DNN should comprise of FC1 [250x144] -> RELU -> FC2 [144x144] -> RELU -> FC3 [144X144] -> RELU -> FC4 [144x12] -> softmax. The output will be 12 floats representing probabilities for the 12 keywords, adding upto 1, the highest value giving the most probable keyword. Given feature vector of a 1 second audio clip, the API should return the top 3 keywords with highest softmax probabilities. 

## Functions Implemented in libaudio

 - `libaudioAPI` :  This is the main api function of the c++ library code which returns NUM_KEYWORD_SUGESTION no. of structs containing index of top keywords and their probabilities.
 - `reluAct()`  :  This function takes input a matrix and applies the relu function on each element of the matrix to output a matrix.
 - `softmax()`  :  This function takes input a matrix and applies the softmax function on each element of the matrix to output a matrix of probabilities.
 - `check_text()`  :  This function checks if the input argument has a .txt file to read.
 - `read_matrix()`  :  This function reads a matrix in column major form from an input text file whose name is passed as an argument to it.
 - `write_matrix()`  :  This function writes a matrix given as an argument to a text file whose name is also given as an argument in a column major form.
 - `input_number_check()`  :  This checks if the number of command-line arguments obtained are sufficient or not.
 - `fcmult_mkl()`  :  Function implementing matrix multiplication using mkl library.


## Errors Handled
----

 - Error regarding incorrect command-line input or insufficient commandline arguments.
 - Error regarding incorrect type of input in text file like integer not provided in case of number of rows or columns.
 - Error regarding sizes of matrices in case of FC layer calculations.
 - Error regarding existence of file.
 - Error regarding stride being factor or size of input matrix.

## Directory Structure
----

```bash
2020CS10372_2020CS50430
├── driver.cpp
├── makefile
├── Matrix.h
├── libaudio.cpp
├── libaudio.h
├── dnn_weights.h
└── README.md
```
## Libraries Used
----
```
#include  <iostream>
#include  <vector>
#include  <fstream>
#include  <cmath>
#include  <string.h>
#include  <pthread.h>
#include <sstream>
#include "mkl.h" 
#include <algorithm>
#include  "Matrix.h"    ## Matrix.h has a matrix class to implement custom data structure for matrix
```
## Commands and Requirements
---- 
- Make sure that g++ and mkl are installed on the system.
- Set the environment variable of MKL_BLAS_PATH as the directory containing mkl.h which is found by setting the second path obtained by running `whereis mkl` command on linux terminal.
- Also set the environment variable of LD_LIBRARY_PATH as the path to the current directory.
- Now just run `make` to create the shared library.
- You can import the library as `#include "libaudio.h"` inside any cpp file provided the LD_LIBRARY_PATH is properly set.

## Design Decisions
----

- Implemented a matrix class used to store data of the matrix in an organised form.
- Used float* in softmax to increase the speed of program.
- Made the library such that only changing the constants and keywords in the libaudio.h is enough to run the library smoothly i.e. the library is more generalised now.
- Also the word keyword is reserved for the library and can't be used in the driver programs.
- the executable yourcode.out is created using makefile and can be run using the command `./yourcode.out <audiofeatures.txt> output.txt`.
- Here `<audiofeatures.txt>` can be replaced by path to any input file.
