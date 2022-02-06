fib(1,0).
fib(2,1).
fib(X,Y):- X>0,Xminus1 is X-1,Xminus2 is X-2,fib(Xminus1,M),fib(Xminus2,N),Y is M+N.