// matrix multiplication implemenation using the mkl library
#include <iostream>
#include "Matrix.h"					// Matrix class
#include "/usr/include/mkl/mkl.h"	// address to the mkl.h header in the machine
using namespace std;

Matrix fcmult_mkl(Matrix input_matrix, Matrix weight_matrix, Matrix bias_matrix){
	// checking he dimensions of the matrices if valid for the multiplication
    if(input_matrix.cols!=weight_matrix.rows){
        cerr << "Cant multiply matrices of given dimensions.\n";
        exit(1);
    }
    if(!(input_matrix.rows==bias_matrix.rows && weight_matrix.cols==bias_matrix.cols)){
        cerr << "Dimension of bias matrix and matrix after multiplication dont match.\n";
        exit(1);
    }
	// initializig the matrix to bias matrix
	Matrix res(bias_matrix.rows,bias_matrix.cols);
	for (int i = 0; i < res.number_elements; i++){
		res.data_column_major[i] = bias_matrix.data_column_major[i];
	}
	// applying the matrix multipliation function for floats in mkl library
	cblas_sgemm(CblasColMajor,
				CblasNoTrans, 
				CblasNoTrans, 
				input_matrix.rows, 
				weight_matrix.cols, 
				input_matrix.cols, 
				1.0f, 
				input_matrix.data_column_major, 
				input_matrix.rows, 
				weight_matrix.data_column_major, 
				weight_matrix.rows, 
				1.0f, 
				res.data_column_major, 
				res.rows
			);
	return res;
}