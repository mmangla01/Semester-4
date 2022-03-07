// Matrix class used to store data of the matrix in an organised form
#pragma once
class Matrix {
	public:
	int cols = 0;			// number of columns in the matrix
	int rows = 0;			// number of rows in the matrix
	int number_elements = 0;// number of elements in the matrix
	float *data_row_major;		// pointer to the initial float array in the row major format 

	Matrix() {};					// empty constructor
	Matrix(int r, int c) {			// constructor if the number of rows and columns are given
		cols = c;
		rows = r;
		number_elements = c*r;	
		data_row_major = new float[number_elements];
		for (int i = 0; i < number_elements; ++i) {	// every element is initialized to 0
			data_row_major[i] = 0.0f;          
		}
	}
	Matrix (int r, int c, float arr[]){
		cols = c;
		rows = r;
		number_elements = c*r;	
		data_row_major = new float[number_elements];
		for (int i = 0; i < number_elements; ++i) {	// every element is initialized to 0
			data_row_major[i] = arr[i];          
		}
	}
	float get_element(int a, int b){		// method to get any element in the Matrix
		return data_row_major[a*cols+b];
	}
	void set_element(int a, int b,float c){	// set the value of the element in the matrix
		data_row_major[a*cols+b] += c;
		return;
	}
	void reset_element(int a, int b){		// resets the value of the element to 0
		data_row_major[a*cols+b] = 0.0f;
		return;
	}

};