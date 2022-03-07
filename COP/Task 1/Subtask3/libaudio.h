#ifndef libaudio_h__
using namespace std;
#define libaudio_h__
typedef struct{
    int label;
    float prob;
}pred_t;
extern pred_t* libaudioAPI(const char* audiofeatures, pred_t* pred);
// the keywrods array having all the keywords in the given order 
string keywords[] = {"silence", "unknown", "yes", "no", "up", "down", "left", "right", "on", "off", "stop", "go"};
// number of keywords that are asked (in this subtask, top 3 probable keywords are asked)
const int NUM_KEYWORD_TO_RECOGNISE = 3;
// define the dimesions of the weight matrices
#define IP1_WT_DIMENSIONS 250,144
#define IP2_WT_DIMENSIONS 144,144
#define IP3_WT_DIMENSIONS 144,144
#define IP4_WT_DIMENSIONS 144,12
// define the dimesions of the bias matrices
#define IP1_BIAS_DIMENSIONS 1,144
#define IP2_BIAS_DIMENSIONS 1,144
#define IP3_BIAS_DIMENSIONS 1,144
#define IP4_BIAS_DIMENSIONS 1,12

#endif