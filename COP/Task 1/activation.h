//different activation functions 
#include "header.h"
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
