// basic libraries that are required for the project
#include <iostream>
#include <vector>
#include <fstream>
#include <cmath>
#include <string.h>
#include <pthread.h>
using namespace std;
// a matrix class is defined
#include "Matrix.h" 
// number of threads are defined globally. can be changed according to the machine in which the program is being run
#define NUM_THREADS 2

// ------------------------ Here are the functions from the previous subtask -------------------------

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
	// assert that the multiplication of given matrices is possible by checking their sizes.
	if(input_matrix.cols!=weight_matrix.rows){
		cerr << "Cant multiply matrices of given dimensions.\n";
		exit(1);
	}
	if(!(input_matrix.rows==bias_matrix.rows && weight_matrix.cols==bias_matrix.cols)){
		cerr << "Dimension of bias matrix and matrix after multiplication don't match.\n";
		exit(1);
	}
	Matrix res(bias_matrix.rows,bias_matrix.cols);
	for(int i = 0; i < input_matrix.rows; ++i){ // Loop through the rows.
		for(int j = 0; j < weight_matrix.cols; ++j){
			res.set_element(i,j,bias_matrix.get_element(i,j)); // Initiate value of particular element of res to corresponding element in bias matrix.
			for(int k = 0; k < input_matrix.cols; ++k){
				res.set_element(i,j,(input_matrix.get_element(i,k)*weight_matrix.get_element(k,j)));  //perform multiplication and add to corresponding element of res.
			}
		}
	}
	return res; // finally return res.
}

// reluAct applies the relu function to each element of input matrix and stores it in result matrix.
Matrix reluAct(Matrix input_matrix){
	Matrix res(input_matrix.rows,input_matrix.cols); // define result matrix
	for(int i = 0; i < input_matrix.number_elements; i++){
		res.data_column_major[i] = max(0.0f,input_matrix.data_column_major[i]); // applying relu function to each element of input matrix and assign it to res.
	}
	return res; // return res.
}

// tanhAct applies the tanh(x) = (e^x - e^(-x))/(e^x + e^(-x)) function to each element of input matrix and stores it in result matrix.
Matrix tanhAct(Matrix input_matrix){
	Matrix res(input_matrix.rows,input_matrix.cols);  // define result matrix
	for(int i = 0; i < input_matrix.number_elements; i++)
		// applying tanh function to each element of input matrix and assign it to res
		res.data_column_major[i] = (exp(res.data_column_major[i])-exp(-res.data_column_major[i]))/(exp(res.data_column_major[i])+exp(-res.data_column_major[i]));
	return res; // return res.
}

//sigmoid applies the sigmoid probability function to each element of input vector.
vector<float> sigmoid(vector<float> input_vector){
	vector<float> res(input_vector.size(),0);   
	for (int i = 0; i < input_vector.size(); i++){
		res[i]=1/(1+exp(-input_vector[i]));  //apply sigmoid function to each element of input vector and assign it to res accordingly.
	}
	return res; // return res.
}

//sigmoid applies the softmax probability function to each element of input vector.
vector<float> softmax(vector<float> input_vector){
	float x=0.0f;									// define float to 
	for (int i = 0; i < input_vector.size(); i++){
		x+=exp(input_vector[i]);			//accumulate sum of exp applied over every element of input vector.
	}
	vector<float> res(input_vector.size(),0.0f);  // define result vector.
	for (int i = 0; i < input_vector.size(); i++){
		res[i]=(exp(input_vector[i])/x);  //apply softmax function to each element of input vector and assign it to res accordingly.
	}
	return res;// return res.
}

// maxpool takes 2 inputs an input matrix and stride.
Matrix maxpool(Matrix input_matrix,int stride){
	// assert that input matrix is square size and that stride divides it.
	if(input_matrix.rows!=input_matrix.cols){
		cerr << "Matrix obtained is not a square matrix.\n";
		exit(1);
	}
	if(input_matrix.rows%stride!=0){
		cerr << "Size of matrix not a multiple of stride.\n";
		exit(1);
	}
	Matrix res(input_matrix.rows/stride,input_matrix.cols/stride); // define result matrix.
	for (int i = 0; i < input_matrix.rows/stride; i++){  // outer 2 loops to decide topleft corner of filter matrix
		for (int j = 0; j < input_matrix.cols/stride; j++){
			float m = input_matrix.get_element(i*stride,j*stride);  // initialise m to the topleft corner value of filter matrix.
			for (int k = i*stride; k < (i+1)*stride; k++){  // these two loops will iterate through elements at max length of stride from topleft corner i.e the filter matrix.
				for (int l = j*stride; l < (j+1)*stride; l++){
					m = max(m,input_matrix.get_element(k,l));  // set m to max of all elements of the filter matrix.
				}
			}
			res.set_element(i,j,m);   //set corresponding value of res
		}	
	}
	return res;  // return res.
}

// averagepool takes 2 inputs an input matrix and stride.
Matrix averagepool(Matrix input_matrix,int stride){
	// assert that input matrix is square size and that stride divides it.
	if(input_matrix.rows!=input_matrix.cols){
		cerr << "Matrix obtained is not a square matrix.\n";
		exit(1);
	}
	if(input_matrix.rows%stride!=0){
		cerr << "Size of matrix not a multiple of stride.\n";
		exit(1);
	}
	Matrix res(input_matrix.rows/stride,input_matrix.cols/stride); // define result matrix.
	for (int i = 0; i < input_matrix.rows/stride; i++){    // outer 2 loops to decide topleft corner of filter matrix
		for (int j = 0; j < input_matrix.cols/stride; j++){
			float m = 0.0f;									// initialise m to 0 to accumulate sum of all elements of filter matrix.
			for (int k = i*stride; k < (i+1)*stride; k++){	// these two loops will iterate through elements at max length of stride from topleft corner i.e the filter matrix.
				for (int l = j*stride; l < (j+1)*stride; l++){
					m += input_matrix.get_element(k,l);				//accumulate sum of elements of filter matrix.
				}
			}
			m = m/(stride*stride);    //find average by dividing by size of filter matrix.
			res.set_element(i,j,m);	// set corresponding value of res
		}	
	}
	return res; // return res
}

void check_txt(char* input){
	string s(input);
	if(s.substr(s.size() - 4)!=string(".txt")){
		cerr << "Wrong input format of file. Enter Filename as <filename.txt>\n" ;
		exit(1);
	}
}
// this function reads a vector from the given file in column major format.
vector<float> read_vector(char* filename){
	check_txt(filename); // check if filename is of the format .txt
	string line;  // get line as string
	ifstream myfile (filename);   // define input stream
	if(myfile.is_open()){
		int number_of_elements;   // define number of elements
		if(getline(myfile,line)){	
			check_integer(line);
			number_of_elements = stoi(line);  // set number of elements.
		}
		else{
			cerr << "Missing number of elements in text file.";
			exit(1);
		}
		vector<float> res(number_of_elements, 0.0f); // create result vector.
		int i = 0;
		while(getline(myfile,line) && i<number_of_elements){  //run loop while next line is present.
			res[i]=stof(line);   // set corresponding element of res by converting string read to float.
			i++;
		}
		if(i!=number_of_elements){
			cerr << "Number of inputs in file incorrect.\n";  // check if sufficient number of elements were read.
			exit(1);
		}
		myfile.close();  // close file.
		return res; // return res
	}
  	else{    // if file wasn't able to open.
		vector<float> res(1,0.0f);
		cerr << "File does not exist or unable to open file.\n";
		exit(1);
	}
}
//function to write a vector in column major format to a file.
void write_vector(char* s, vector<float> output){
	ofstream myfile(s);				// output stream to write in file with name s.
	myfile << output.size() << "\n";	// output the number of elements.
	for (int i = 0; i < output.size(); i++){
		myfile << output[i] << "\n";   // output each elements in column major format.
	}
	myfile.close();   //close file.
}
// ----------------------------------------------------------------------------------------------------

// the two matrix multiplication functions are declared that uses two different libraries
Matrix fcmult_openblas(Matrix input_matrix, Matrix weight_matrix, Matrix bias_matrix);
Matrix fcmult_mkl(Matrix input_matrix, Matrix weight_matrix, Matrix bias_matrix);

// struct for storing the thread arguments
struct thread_args{
	int start;	// start index of range of columns 
	int end;	// end index of range of columns
	pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;	// mutex lock to prevent writing of multiple threads at same address
	Matrix* input_matrix;	// pointer to input matrix 
	Matrix* weight_matrix;	// pointer to weight matrix
	Matrix* bias_matrix;	// pointer to bias matrix
	Matrix* res;			// pointer to result matrix
};
// a function which performs partial matrix multiplications handled by a single thread in case of multi-threading.
// so that it could be independently assigned to different threads
void *partial_multiply(void* arg){
	struct thread_args * current_param = (struct thread_args *) arg;
	for(int i = 0; i < (*(current_param->input_matrix)).rows; i++) {
		for(int j = 0; j < (*(current_param->weight_matrix)).cols; j++) {
			float thread_private_tmp = 0.0f;
			for(int k = current_param->start; k < current_param->end; k++) {
				thread_private_tmp += ((*(current_param->input_matrix)).get_element(i,k))*((*(current_param->weight_matrix)).get_element(k,j));
			}
			pthread_mutex_lock(&(current_param->lock));
			(*(current_param->res)).set_element(i,j,thread_private_tmp);
			pthread_mutex_unlock(&(current_param->lock));
		}
	}
	return nullptr;
};

// matrix multiplication implementation using pthreads
Matrix fcmult_pthread(Matrix input_matrix, Matrix weight_matrix, Matrix bias_matrix){
	// checking the dimensions of the matrices if they are valid for fcmult
	if(input_matrix.cols!=weight_matrix.rows){
        cerr << "Cant multiply matrices of given dimensions.\n";
        exit(1);
    }
    if(!(input_matrix.rows==bias_matrix.rows && weight_matrix.cols==bias_matrix.cols)){
        cerr << "Dimension of bias matrix and matrix after multiplication don't match.\n";
        exit(1);
    }
	// initializing the output matrix with the elements of bias matrix
	Matrix res(bias_matrix.rows,bias_matrix.cols);
	for (int i = 0; i < res.number_elements; i++){
		res.data_column_major[i] = bias_matrix.data_column_major[i];
	}
	// creating an array of threads and some basic attributes required for the threads implementation
	pthread_t thread_array[NUM_THREADS];
	struct thread_args thread_params[NUM_THREADS];
	int current_start, range;
	current_start = 0;
	range = input_matrix.cols/NUM_THREADS;
	// dividing the work for threads
	for(int i = 0; i < NUM_THREADS; i++) {
		thread_params[i].start = current_start;
		thread_params[i].end = current_start + range;
		thread_params[i].input_matrix = &input_matrix;
		thread_params[i].weight_matrix = &weight_matrix;
		thread_params[i].bias_matrix = &bias_matrix;
		thread_params[i].res = &res;
		current_start += range;
	}
	// creating the threads and assigning the work 
	thread_params[NUM_THREADS-1].end = input_matrix.cols;
	for(int i = 0; i < NUM_THREADS; i++) {
		pthread_create(&thread_array[i], NULL, partial_multiply, &thread_params[i]);
	}
	// joining the threads
	for(int i = 0; i < NUM_THREADS; i++) {
		pthread_join(thread_array[i], NULL);
	}
	return res;
}

// this function reads a matrix from a file in column major format.
Matrix read_matrix(char* filename){
	check_txt(filename); //check if filename is of the format .txt
	string line;
	ifstream myfile (filename); // define input file stream
	if(myfile.is_open()){
		int number_of_columns;   // define number of columns
		if(getline(myfile,line)){	
			check_integer(line);
			number_of_columns = stoi(line);  // set number of columns
		}
		else{				// if the number of columns is not there in the text file then error
			cout << filename;
			cerr << "Missing number of columns in text file.";
			exit(1);
		}
		int number_of_rows;   // define number of columns
		if(getline(myfile,line)){
			check_integer(line);
			number_of_rows = stoi(line);  // set number of columns.
		}
		else{				// if the number of rows is not there in the text file then error
			cerr << "Missing number of rows in text file.";
			exit(1);
		}
		Matrix res(number_of_rows,number_of_columns); // create result matrix.
		int i = 0;
		while(getline(myfile,line) && i < res.number_elements){ //run loop while next line is present.
			res.data_column_major[i] = stof(line);  // set corresponding element of res by converting string read to float.
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

// function to write a matrix in column major format to a file.
void write_matrix(char* s, Matrix output){
	ofstream myfile(s);			// output stream to write in file with name s.
	myfile << output.cols << "\n";  // output the number of columns.
	myfile << output.rows << "\n";  // output the number of rows.
	for (int i = 0; i < output.number_elements; i++){
		myfile << output.data_column_major[i] << "\n";   // output each elements in column major format.
	}		
	myfile.close();   //close file.
}

// helper function that checks if the number of arguments in the command are sufficient
void input_number_check(int a,int number_of_inputs){
	if(a!=number_of_inputs){
		cerr << "Insufficient number of arguments.\n";
		exit(1);
	}
}

// main function
int main(int argc, char* argv[]){
	ios_base::sync_with_stdio(false);
	cin.tie(NULL); 
	if(argv[1] == string("fullyconnected")){  // check if argv[1] is fullyconnected
		input_number_check(argc,7); // check if sufficient number of inputs were provided.
		// next we get the three input matrices.
		Matrix input_matrix1 = read_matrix(argv[3]);
		Matrix input_matrix2 = read_matrix(argv[4]);
		Matrix input_matrix3 = read_matrix(argv[5]);
		// initializing the output matrix
		Matrix output_matrix(input_matrix3.rows,input_matrix3.cols);
		//get output matrix using fcmult.
		// checking the 3rd argument in the command that tell the type of implementation
		if(argv[2] == string("pthread")){
			output_matrix = fcmult_pthread(input_matrix1,input_matrix2,input_matrix3);
		}
		else if(argv[2] == string("mkl")){
			output_matrix = fcmult_mkl(input_matrix1,input_matrix2,input_matrix3);
		}
		else if(argv[2] == string("openblas")){
			output_matrix = fcmult_openblas(input_matrix1,input_matrix2,input_matrix3);
		}
		else{ // if the argument doesn't matches with the given implementations then give error.
			cerr << "Incorrect or missing argument at argv[2].\n";
			exit(1);
		}
		// write output to a file with name in argv[5]
		write_matrix(argv[6],output_matrix);

		// outputing the average and standard deviation into the file
		// input formats : "i*.txt", "w*.txt", "b*.txt" where * is the input number
		// the averages and standard deviation is stored in the file named "time_*.dat" 
		// * is "mkl", "openblas" or "pthread" depending on the implementation
		// fstream time;
		// string s1(argv[2]);
		// string s2(argv[3])
		// int mat_value = stoi(s2.substr(1,1));
		// string s= "time_" + s1 + ".dat";
		// double mean=0.0;
		// double sd=0.0;
		// for(int i=0;i<137;i++){
		// 	auto start = high_resolution_clock::now();
		// 	output_matrix = fcmult_mkl(input_matrix1,input_matrix2,input_matrix3);
		// 	auto stop = high_resolution_clock::now();
		// 	auto duration = duration_cast<milliseconds>(stop-start);
		// 	mean += duration.count();
		// 	sd += duration.count()*duration.count();
		// }
		// sd /=137.0;
		// mean /=137.0;
		// sd -= mean*mean;
		// time.open(s, fstream::app);
		// time << mat_value << "    "<<mean << "    " << sd<< "\n";
		// time.close();
	}
	// this is all same from the subtask 1
	else if(argv[1] == string("activation")){ // check if argv[1] is activation
		input_number_check(argc,5); // check if sufficient number of inputs were provided.
		Matrix input_matrix = read_matrix(argv[3]); //read matrix.
		Matrix output_matrix(input_matrix.rows,input_matrix.cols);
		if(argv[2]==string("relu")){  // check if argv[2] is relu
			output_matrix = reluAct(input_matrix);
		}
		else if(argv[2]==string("tanh")){ // check if argv[2] is tanh
			output_matrix = tanhAct(input_matrix);
		}
		else{ // give error.
			cerr << "Incorrect or missing argument at argv[2].\n";
			exit(1);
		}
		write_matrix(argv[4],output_matrix); // write matrix to text file with name in argv[4].
	}
	else if(argv[1] == string("pooling")){ // check if argv[1] is pooling
		input_number_check(argc,6); // check if sufficient number of inputs were provided.
		Matrix input_matrix = read_matrix(argv[3]);  // read matrix
		Matrix output_matrix;
		if(argv[2]==string("max")){  // check if we want maxpooling
			check_integer(string(argv[4]));
			output_matrix = maxpool(input_matrix,stoi(argv[4]));
		}
		else if(argv[2]==string("average")){ // check if we want average pooling.
			check_integer(string(argv[4]));
			output_matrix = averagepool(input_matrix,stoi(argv[4]));
		}
		else{  // give error.
			cerr << "Incorrect or missing argument at argv[2].\n";
			exit(1);
		}
		write_matrix(argv[5],output_matrix); // write matrix to text file with name in argv[5]. 
	}
	else if(argv[1] == string("probability")){ // check if argv[1] is probability
		input_number_check(argc,5); // check if sufficient number of inputs were provided.
		vector<float> input_vector = read_vector(argv[3]);  // read vector.
		vector<float> output_vector;  
		if(argv[2]==string("softmax")){  // check if we want softmax
			output_vector = softmax(input_vector);
		}
		else if(argv[2]==string("sigmoid")){ // check if we want sigmoid
			output_vector = sigmoid(input_vector);
		}
		else{  // else give error.
			cerr << "Incorrect or missing argument at argv[2].\n";
			exit(1);
		}
		write_vector(argv[4],output_vector); // write matrix to text file with name in argv[4].
	}
	else{  // else give error.
		cerr << "Incorrect or missing argument at argv[1].\n";
		exit(1);
	}
}