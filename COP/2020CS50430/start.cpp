#include <iostream>
#include <vector>
#include <math.h>
#include <utility>
#include <fstream>
#include <sstream>
#include <stdexcept>
using namespace std;

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

//matrix multiplication of inputMatrix and weighMatrix, then biasing
vector<vector<float> > fullyconnected(vector<vector<float> > inputMatrix,vector<vector<float> > weighMatrix,vector<vector<float> > biasMatrix){
    if(inputMatrix[0].size()!=weighMatrix.size()||inputMatrix.size()!=biasMatrix.size()||weighMatrix[0].size()!=biasMatrix[0].size()){
        cerr << "ERROR: Invalid dimensions of the matrix\n"; exit(1); // if the dimesions of the matrices are not supporting the ineer product or addition
    }
    vector<vector<float> > outputMatrix;                // our output matrix
    for(int i =0;i<inputMatrix.size();i++){             
        vector<float> temp;                             // a temparory vector
        for(int j =0;j<weighMatrix[0].size();j++){
            float tempVal=0.0f;                         // a temparory float value initialised as 0 that will store a value in matrix
            for(int k =0;k<inputMatrix[0].size();k++){  
                float alpha = inputMatrix[i][k];        
                float beta = weighMatrix[k][j];
                tempVal+= alpha*beta;                   // multiply the two corresponding terms and add it to the tempVal
            } 
            temp.push_back(tempVal);                    // after we have added all the corresponding terms in tempVal then we can push it in the temp vector
        }
        outputMatrix.push_back(temp);                   // after getting the vector, we push it in the output matrix 
    }
    for(int i=0;i<inputMatrix.size();i++){
        for(int j=0;j<weighMatrix[0].size();j++){
            outputMatrix[i][j] += biasMatrix[i][j];     // adding the bias matrix to the matrix obtained by multiplying the two matrices
        }
    }
    return outputMatrix;                                // returning the matrix after all the operations on the matrix
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// different activation functions 
// relu function activation
vector<vector<float> > nlaRelu(vector<vector<float> > matrix){
    int a = matrix.size();              // rows in the matrix
    int b = matrix[0].size();           // columns in the matrix
    vector<vector<float> > outputMatrix( a , vector<float> (b,0.0f));   // the matrix that will be returned as output
    for(int i=0;i<a;i++){
        for(int j=0;j<b;j++){
            float value = matrix[i][j];           // value of the element stored as a float 
            outputMatrix[i][j] = max(0.0f,value); // relu function
        }
    }
    return outputMatrix;                      // return the formed matrix
}
// synthetic tanh function that computes the value of tanh of a float using exponent of that
float tanH(float x){
    float a = exp(x);
    float b = exp(-x);
    x = (a-b)/(a+b);
    return x;
}
// tanh activation
vector<vector<float> > nlaTanh(vector<vector<float> > matrix){
    int a = matrix.size();              // rows in the matrix
    int b = matrix[0].size();           // columns in the matrix
    vector<vector<float> > outputMatrix( a , vector<float> (b,0.0f));   // the matrix that will be returned as output
    for(int i=0;i<a;i++){
        for(int j=0;j<b;j++){
            float value = matrix[i][j];
            outputMatrix[i][j] = tanH(value);   // tanh function
        }
    }
    return outputMatrix;                      // return the formed matrix
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// subsampling of the matrix using max and average pooling techniques
// getting the max and average of the matrix element
// helper function that takes input the stride and returns the average and max of the elements 
vector<float> pooling(vector<vector<float> > matrix ){
    vector<float> arr;                          // a vector that will stroe the max and average
    arr.push_back(0.0f);                        // initialize sum as zero
    arr.push_back(matrix[0][0]);                // initialize max as the first element 
    int size = matrix.size()*matrix[0].size();  // getting the size of matrix
    for(int i=0;i<matrix.size();i++){
        for(int j=0;j<matrix[i].size();j++){
            arr[0] += matrix[i][j];             // adding the element for the sum
            if(matrix[i][j]>arr[1]){    
                arr[1] = matrix[i][j];          // upateing the maximum value if the element is greater than the previously stored maximum
            }
        }
    }
    arr[0] /= size;                             // converts the sum to averge by dividing it by the size of the matrix
    return arr;
}
// the final function that do subsampling
vector<vector<float> > subsampling(vector<vector<float> > matrix, int mode, int stride){
    int N = matrix.size();              // side of the square matrix
    if(N != matrix[0].size()){cerr << "ERROR: not a square matrix\n"; exit(1);} // check if the entered matrix is a square matrix
    if(N % stride != 0){cerr << "ERROR: stride not a factor of side\n"; exit(1);} // check if the stride is a factor of side
    int n = N/stride;                   // side of the output matrix 
    vector<vector<float> > newMatrix(n, vector<float> (n,0.0f));                // initialize output matrix
    vector<vector<float> > poolingMatrix(stride, vector<float> (stride,0.0f));  // initialize the pooling matrix
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            for(int k1=0;k1<stride;k1++){                                       // forming the poling matrix
                for(int k2=0;k2<stride;k2++){
                    poolingMatrix[k1][k2]=matrix[i*stride+k1][j*stride+k2];     // forming the pooling matrix
                }
            }
            newMatrix[i][j] = pooling(poolingMatrix)[mode];                     // store the element in the new matrix after pooling
        }
    }
    return newMatrix;                   // return matrix
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// converting the float vector to probability vector using sigmoid/softmax functions
// softmax function
vector<float> softmax(vector<float> floatVector){
    vector<float> probVector;               // creating the probability vector
    float sum=0.0f;
    for(int i=0;i<floatVector.size();i++){  //finding the sum of all the elements in the vector
        sum += exp(floatVector[i]);
    }
    for(int i=0;i<floatVector.size();i++){  // finding the sigmoid value of the given function
        float value = exp(floatVector[i])/sum;
        probVector.push_back(value);
    }
    return probVector;                      // returning the probability vector
}
// sigmoid function
vector<float> sigmoid(vector<float> floatVector){
    vector<float> probVector;               // creating the probability vector
    for(int i=0;i<floatVector.size();i++){  
        float x = floatVector[i];           // finding the sigmoid value of the given function
        float value = 1/(1+exp(-x));        
        probVector.push_back(value);        // pushing the value obtained in the probVector
    }
    return probVector;                      // returning the probability vector
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// this function reads the txt files and returns the corresponding matrix/vector
// reading matrix from a file
vector<vector<float> > readMatrix(char* filename){
    string name(filename);
    if(name.substr(name.size()-4)!=".txt"){cerr << "ERROR: Invalid filename extension (.txt not found)"; exit(1);}
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

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

// to write the matrix or vector in a file
// write the matrix to the given file
void writeMatrix(vector<vector<float> > matrix, char* filename){
    ofstream matrixwriter(filename);                    // file writer for the matrix
    matrixwriter << (matrix[0].size()) << "\n";    // writes the number of columns 
    matrixwriter << (matrix.size()) << "\n";       // writes the number of rows
    for(int i=0;i<matrix[0].size();i++){
        for(int j=0;j<matrix.size();j++){   
            matrixwriter << (matrix[j][i]) << "\n";    // writes the elements in column major form
        }
    }
}
//write vector to the given file
void writeVector(vector<float>vector, char* filename){
    ofstream vectorwriter(filename);                    // file writer for the vector
    vectorwriter << (vector.size())<<"\n";       // writes the length of the vector
    for(int j=0;j<vector.size();j++){   
        vectorwriter << (vector[j]) << "\n";       // writes the elements of the vector one by one
    }
}

// --------------------------------------------------------------------------------------------------------------------------------------------------------------

int main (int argc,char* argv[]){
    if(argc == 6){ // some instruction (fullyconneced or pooling)
        if(argv[1]== string("fullyconnected")){ // if fulltconnected
            // we create the three files containing the different matrices
            char* input = argv[2]; 
            char* weight=argv[3]; 
            char* bias=argv[4]; 
            char* output=argv[5]; // the output file
            // reading the three matrices and calculating the output matrix
            vector<vector<float> > outputMatrix = fullyconnected(readMatrix(input),readMatrix(weight),readMatrix(bias)); 
            // writing the output matrix in the output file
            writeMatrix(outputMatrix,output);
        }
        else if(argv[1] == string("pooling")){ // if pooling
            string mode(argv[2]); //first is the mode of pooling (max or average)
            char* input=argv[3]; // second is the file name of the input matrix
            string stride(argv[4]); // stride value 
            char* output=argv[5]; // the output file
            int strideValue = stoi(stride); // converting the string to int to get the value of stride 
            if(to_string(strideValue)!=stride){cerr<< "ERROR: Invalid Input Type: expected int found string";exit(1);} // if the stride is not integer
            int modeValue; // getting the mode value from mode string (0 if average, 1 if max, else error)
            if(mode == "max"){modeValue = 1;}
            else if(mode == "average"){modeValue = 0;}
            else{cerr<< "ERROR: Invalid function requested"; exit(1);}
            vector<vector<float> > outputMatrix = subsampling(readMatrix(input),modeValue,strideValue); // subsampling the input matrix 
            writeMatrix(outputMatrix,output);   // writing the output matrix to the given file
        }
        else{ cerr << "ERROR: Invalid Command Line";exit(1);} // if nothing then error
    }
    else if(argc == 5){ // some instruction (activation or probability)
        if(argv[1]== string("activation")){
            // getting three strings from the command
            string func(argv[2]); 
            char* input=argv[3];
            char* output=argv[4]; 
            // declaring the outputMatrix and assigning the value according to the input function
            vector<vector<float> > outputMatrix;        
            if(func == "relu"){outputMatrix = nlaRelu(readMatrix(input));}
            else if(func == "tanh"){outputMatrix = nlaTanh(readMatrix(input));}
            else{cerr << "ERROR: Invalid function requested";exit(1);}
            writeMatrix(outputMatrix,output); // writing to the file given
        }
        else if(argv[1] == string("probability")){
            // getting three strings from the command
            string func(argv[2]); 
            char* input=argv[3];
            char* output=argv[4]; 
            // declaring the outputVector and assigning the value according to the input function
            vector<float> outputVector;
            if(func == "softmax"){outputVector = softmax(readVector(input));}
            else if(func == "sigmoid"){outputVector = sigmoid(readVector(input));}
            else{cerr << "ERROR: Invalid function requested";exit(1);}
            writeVector(outputVector,output);   // writing to the file given
        }
        else{ cerr << "ERROR: Invalid Command Line";exit(1);} // if nothing then error
    }
    else{ cerr << "ERROR: Invalid Command Line";exit(1);} // if nothing then error
    return 0;
}