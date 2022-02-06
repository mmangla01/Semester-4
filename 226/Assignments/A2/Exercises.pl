female(mary).
female(sandra).
female(juliet).
female(lisa).
male(peter).
male(paul).
male(dick).
male(bob).
male(harry).
parent(bob, lisa).
parent(bob, paul).
parent(bob, mary).
parent(juliet, lisa).
parent(juliet, paul).
parent(juliet, mary).
parent(peter, harry).
parent(lisa, harry).
parent(mary, dick).
parent(mary, sandra).

father(X,Y):- parent(X,Y),male(X).
sister(X,Y):- female(X), parent(Z,Y),parent(Z,X),X\=Y.
grandmother(X,Y):- female(X),parent(X,T),parent(T,Y),male(T).
cousin(X,Y):- parent(X1,X),parent(M,X1),parent(X2,Y),parent(M,X2),X=\=Y,X1=\=X2.