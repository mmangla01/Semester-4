// Matrix class used to store data of the matrix in an organised form
class Matrix {
	public:
	unsigned int cols = 0;			// number of columns in the matrix
	unsigned int rows = 0;			// number of rows in the matrix
	unsigned int number_elements = 0;// number of elements in the matrix
	float *data_column_major;		// pointer to the initial float array

	Matrix() {};					// empty constructor
	Matrix(int r, int c) {			// constructor if the number of rows and columns are given
		cols = c;
		rows = r;
		number_elements = c*r;	
		data_column_major = new float[number_elements];
		for (int i = 0; i < rows; ++i) {	// every element is initialized to 0
			data_column_major[i] = 0.0f;          
		}
	}
	float get_element(int a, int b){		// method to get any element in the Matrix
		return data_column_major[b*rows + a];
	}
	void set_element(int a, int b,float c){	// set the value of the element in the matrix
		data_column_major[b*rows + a] += c;
		return;
	}
	void reset_element(int a, int b){		// resets the value of the element to 0
		data_column_major[b*rows + a] = 0.0f;
		return;
	}
};