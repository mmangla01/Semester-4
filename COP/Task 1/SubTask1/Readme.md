Mayank Mangla
2020CS50430

this program is based on some operations on matrices and vectors

the file "start.cpp" is the main source file which is compiled in order to generate the executable file
this reads the arguments when the command line "./yourcode.out ..." is run 
and reacts accordingly 
1. fullyconnected:  "./yourcode.out fullyconnected inputmatrix.txt weightmatrix.txt biasmatrix.txt outputmatrix.txt"
                    this command reads the three matrices in inputmatrix.txt, weightmatrix.txt and biasmatrix.txt and forms
                    three matrices - inputmatrix, weightmatrix and biasmatrix and writes the output matrix, obtained by
                    doing inner product on inputmatrix and weightmatrix and adding biasmatrix to it, to outputmatrix.txt.
                    errors  => if any of the first three files does not exists
                            => if the dimensions of the matrices does not support the operations

2. activation:      "./yourcode.out activation relu inputmatrix.txt outputmatrix.txt"
                    "./yourcode.out activation tanh inputmatrix.txt outputmatrix.txt"
                    this command reads the matrix in inputmatrix.txt and apply the function (relu/tanh) to each element
                    of the inputmatrix. the resulting matrix is written in the outputmatrix.txt
                    errors  => if the inputmatrix.txt does not exists

3. pooling:         "./yourcode.out pooling max inputmatrix.txt stride outputmatrix.txt"
                    "./yourcode.out pooling tanh inputmatrix.txt stride outputmatrix.txt"
                    this command reads the matrix in inputmatrix.txt and an integer stride from the command line. then according
                    to max/average, the matrix is operated by maxpooling/average pooling and the resulting matrix is written in 
                    outputmatrix.txt
                    errors  => if the inputmatrix.txt does not exists
                            => stride is not a factor of side of input matrix

4. probability:     "./yourcode.out probability softmax inputvector.txt outputvector.txt"
                    "./yourcode.out probability sigmoid inputvector.txt outputvector.txt"
                    this command is used to convert a vector of floats to a vector of probabilities. the vector is read from the 
                    inputvector.txt and the function softmax/sigmoid is applied (according to the command given) and the resulting vector of probabilities is written in outputvector.txt
                    errors  => if the inputvector.txt does not exists

if the command line does not matches, then the error is given