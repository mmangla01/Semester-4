// basic libraries that are required for the project
#include <iostream>
#include "libaudio.h"
#include <fstream>
using namespace std;

// helper function that checks if the number of arguments in the command are sufficient
void input_number_check(int a,int number_of_inputs){ 
	if(a!=number_of_inputs){
		cerr << "Insufficient number of arguments.\n";
		exit(1);
	}
}

// main function
int main(int argc, char* argv[]){
	input_number_check(argc, 3);	// check the number of arguments are 3 or not 
    pred_t* pred = new pred_t[NUM_KEYWORD_TO_RECOGNISE];	// defining new array 
	// getting the result from the function
    pred = libaudioAPI(argv[1],pred);
	// appending the data to the file 
	fstream output;
	output.open(argv[2],fstream::app);
	output <<  argv[1] << " "; 
	for (int i = 0; i < NUM_KEYWORD_TO_RECOGNISE; i++){
		output << keywords[pred[i].label] << " ";
	}
	for (int i = 0; i < NUM_KEYWORD_TO_RECOGNISE; i++){
		output << pred[i].prob << " ";
	}
	output << "\n";
	output.close();
	return 0;
}