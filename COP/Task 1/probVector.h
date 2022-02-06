// converting the float vector to probability vector using sigmoid/softmax functions
#include "header.h"
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
