//matrix multiplication of inputMatrix and weighMatrix, then biasing
#include "header.h"
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