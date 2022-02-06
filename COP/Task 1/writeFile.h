// to write the matrix or vector in a file
#include "header.h"
// write the matrix to the given file
void writeMatrix(vector<vector<float> > matrix, char* filename){
    ofstream matrixwriter(filename);                    // file writer for the matrix
    matrixwriter << (matrix[0].size());    // writes the number of columns 
    matrixwriter << "\n";
    matrixwriter << (matrix.size());       // writes the number of rows
    matrixwriter << "\n";
    for(int i=0;i<matrix[0].size();i++){
        for(int j=0;j<matrix.size();j++){   
            matrixwriter << (matrix[j][i]);    // writes the elements in column major form
            matrixwriter << "\n";
        }
    }
}

void writeVector(vector<float>vector, char* filename){
    ofstream vectorwriter(filename);                    // file writer for the vector
    vectorwriter << (vector.size());       // writes the length of the vector
    vectorwriter << "\n";
    for(int j=0;j<vector.size();j++){   
        vectorwriter << (vector[j]);       // writes the elements of the vector one by one
        vectorwriter << "\n";
    }
}
