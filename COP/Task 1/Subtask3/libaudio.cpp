#include <iostream>
#include <vector>
#include <fstream>
#include <cmath>
#include <string.h>
#include <sstream>
#include <algorithm>
#include "mkl.h"	// address to the openblas.h header in the machine  
#include "dnn_weights.h" // include the weights and bias matrices 
#include "libaudio.h"
using namespace std;
// a matrix class is defined
#include "Matrix.h" 
// This function checks if the string is an exact integer.
void check_integer(string s){
	if(s.substr(s.size()-1)=="\n"){
		s.pop_back();
	}
	int a = stoi(s);
	if(s!=to_string(a)){
		cerr << "Wrong type of input(required: integer)\n";
		exit(1);
	}
}

// fcmult or fully connected mult takes 3 inputs input_matrix, weight_matrix, bias_matrix.
// res is the result or output matrix.
Matrix fcmult(Matrix input_matrix, Matrix weight_matrix, Matrix bias_matrix){
	// checking he dimensions of the matrices if valid for the multiplication
    if(input_matrix.cols!=weight_matrix.rows){
        cerr << "Can't multiply matrices of given dimensions.\n";
        exit(1);
    }
    if(!(input_matrix.rows==bias_matrix.rows && weight_matrix.cols==bias_matrix.cols)){
        cerr << "Dimension of bias matrix and matrix after multiplication don't match.\n";
        exit(1);
    }
	// initializig the matrix to bias matrix
	Matrix res(bias_matrix.rows,bias_matrix.cols);
	for (int i = 0; i < res.number_elements; i++){
		res.data_row_major[i] = bias_matrix.data_row_major[i];
	}
	// applying the matrix multipliation function for floats in mkl library
	cblas_sgemm(CblasRowMajor,
				CblasNoTrans, 
				CblasNoTrans, 
				input_matrix.rows, 
				weight_matrix.cols, 
				input_matrix.cols, 
				1.0f, 
				input_matrix.data_row_major, 
				input_matrix.cols, 
				weight_matrix.data_row_major, 
				weight_matrix.cols, 
				1.0f, 
				res.data_row_major, 
				res.cols
			);
	return res;
}

// reluAct applies the relu function to each element of input matrix and stores it in result matrix.
Matrix reluAct(Matrix input_matrix){
	Matrix res(input_matrix.rows,input_matrix.cols); // define result matrix
	for(int i = 0; i < input_matrix.number_elements; i++){
		// applying relu function to each element of input matrix and assign it to res.
		res.data_row_major[i] = max(0.0f,input_matrix.data_row_major[i]); 
	}
	return res; // return res.
}

//softmax applies the softmax probability function to each element of input vector.
float* softmax(Matrix input_vector){
	// if the input matrix is not a column vector
	if(input_vector.rows!=1){
		cerr << "Not a single dimension output from fullyconnected layers.";
		exit(1);
	}
	float x=0.0f;									// define float that stores the sum of exponents
	for (int i = 0; i < input_vector.cols; i++){
		x+=exp(input_vector.data_row_major[i]);		//accumulate sum of exp applied over every element of input vector.
	}
	float *res = new float[input_vector.cols];  	// define result vector.
	for (int i = 0; i < input_vector.cols; i++){
		//apply softmax function to each element of input vector and assign it to res accordingly.
		res[i]=(exp(input_vector.data_row_major[i])/x);  
	}
	return res;// return res.
}

// function that checks whether the input file is a .txt file or not
void check_txt(const char* input){
	string s(input);
	if(s.substr(s.size() - 4)!=string(".txt")){
		cerr << "Wrong input format of file. Enter Filename as <filename.txt>\n" ;
		exit(1);
	}
}

// this function reads a matrix from a file in column major format.
Matrix read_matrix(const char* filename, int rows, int cols){
	check_txt(filename); //check if filename is of the format .txt
	string line;
	ifstream myfile(filename); // define input file stream
	if(myfile.is_open()){
		Matrix res(rows,cols); // create result matrix.
		int i = 0;
		// line that has the floats 
		getline(myfile,line);
		// getting the strings that are spaced by white space
		istringstream get_float(line);
		string value;
		while(get_float >> value && i < res.number_elements){ //run loop while next line is present.
			res.data_row_major[i] = stof(value);  // set corresponding element of res by converting string read to float.
			i++;
		}
		if(i!=res.number_elements){  			// if there are not enough inputs in the file then error and exit
			cerr << "Number of inputs in file incorrect.\n";
			exit(1);
		}
		myfile.close();  // close file.
		return res;  // return res
	}
  	else{		// if file wasn't able to open.
		cerr << "File does not exist or unable to open file.\n";
		exit(1);
	}
}

// helper function that checks if the number of arguments in the command are sufficient
void input_number_check(int a,int number_of_inputs){
	if(a!=number_of_inputs){
		cerr << "Insufficient number of arguments.\n";
		exit(1);
	}
}
pred_t* libaudioAPI(const char* audiofeatures, pred_t* pred){
    ios_base::sync_with_stdio(false);
	cin.tie(NULL); 
	// initializing the matrix 
    Matrix input=read_matrix(audiofeatures,1,250);
	// the float matrices used as weight and bias matrix
	float W1[] = IP1_WT;
	float W2[] = IP2_WT;
	float W3[] = IP3_WT;
	float W4[] = IP4_WT;

	float B1[] = IP1_BIAS;
	float B2[] = IP2_BIAS;
	float B3[] = IP3_BIAS;
	float B4[] = IP4_BIAS;
	// in each iteration we apply a fulyconnected and relu function 
	Matrix weight1(IP1_WT_DIMENSIONS,W1);
 	Matrix bias1(IP1_BIAS_DIMENSIONS,B1);
	input = fcmult(input, weight1, bias1);
	input = reluAct(input);

 	Matrix weight2(IP2_WT_DIMENSIONS,W2);
 	Matrix bias2(IP2_BIAS_DIMENSIONS,B2);
	input = fcmult(input, weight2, bias2);
	input = reluAct(input);

 	Matrix weight3(IP3_WT_DIMENSIONS,W3);
 	Matrix bias3(IP3_BIAS_DIMENSIONS,B3);
	input = fcmult(input, weight3, bias3);
	input = reluAct(input);
	// except in the last where only fullconnected is applied and then softmax
 	Matrix weight4(IP4_WT_DIMENSIONS,W4);
 	Matrix bias4(IP4_BIAS_DIMENSIONS,B4);
	input = fcmult(input, weight4, bias4);

	float* in_vector;
    in_vector = softmax(input);
	int j = sizeof(keywords)/sizeof(keywords[0]);
	vector<pair<float,int> > a;
	// making pair of the given keywords array 
	for (int i = 0 ;i < j ; i++) {
		a.push_back (make_pair (in_vector[i],i));
	}
	// reverse sorting the array 
	sort(a.rbegin(),a.rend());
	// getting the top "NUM_KEYWORD_TO_RECOGNISE" number of keywrds to answer array 
    for (int i = 0; i < NUM_KEYWORD_TO_RECOGNISE; i++){
        pred[i].prob = a[i].first;
        pred[i].label = a[i].second;
    }
    return pred;
}