// subsampling of the matrix using max and average pooling techniques
#include "header.h"
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
    if(N % stride != 0){cerr << "ERROR: stride not a factor of side\n"; exit(1);}
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
