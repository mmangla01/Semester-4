// this file reads the txt files and returns the corresponding matrix/vector

#include "header.h"
// reading matrix from a file
vector<vector<float> > readMatrix(char* filename){
    string name(filename);
    if(name.substr(name.size()-4,name.size())!=".txt"){throw invalid_argument("ERROR: Invalid filename extension (.txt not found)");}
    string line;                                    // string that stores the line read from the txt file
    ifstream matrixFile(filename);                  // file reader 
    vector<vector<float> > temp;                    // a null matrix that is returned in case the program shows any error
    if(matrixFile.is_open()){                       // if the file is opened
        getline(matrixFile,line);                   // read the line
        int A = stoi(line);                         // first line contains the number of columns
        getline(matrixFile,line);                   // reads the second line
        int B = stoi(line);                         // second line contains the number of rows
        vector<vector<float> > Matrix(B,vector<float> (A,0.0f));    // matrix to be returned
        for(int i=0;i<A;i++){                       
            for(int j=0;j<B;j++){
                if(getline(matrixFile,line)){       // if the reader is able to read a line then
                    Matrix[j][i] = stof(line);      // it is stored as a float in the respective place in matrix
                }
                // if the number of lines does not matches the size given
                else{ cerr << "ERROR: number of lines does not match the given size of Matrix\n"; exit(1); }
            }
        }
        matrixFile.close();
        return Matrix;                              // return the answer Matrix
    }
    // else the error is raised
    else{ cerr << "Error: File not found\n"; exit(1); }
    return temp ;
}
// reading vector from a file
vector<float> readVector(char* filename){
    string line;                                    // string that stores the line read from the txt file
    ifstream vectorFile(filename);                  // file reader 
    vector<float> Vector;                           // Vector that is to be returned
    if(vectorFile.is_open()){                       // if the file is opened
        getline(vectorFile,line);                   // read the line
        int vlen = stoi(line);                      // first line stores the length of the vector
        int countLines=0;                           // this is the counter for the nuber of lines in the file except the first one
        while(getline(vectorFile,line)){
            countLines++;
            Vector.push_back(stof(line));
        }
        // if the number of lines does not matches the size given
        if(countLines!=vlen){cerr << "ERROR: number of lines does not match the given size of Matrix\n"; exit(1); }
        vectorFile.close();
    }
    // else the error is raised
    else{ cerr << "Error: File not found\n"; exit(1); }
    return Vector;
}
