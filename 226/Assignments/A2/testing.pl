ibt(empty).
ibt(node(N,L,R)):- integer(N),ibt(L),ibt(R).

isBST(empty).
isBST(BT):- ibt(BT), BT = node(X,L,R),(L = empty -> integer(X);L = node(Lv,_,_),X>Lv),(R = empty ->integer(X);R = node(Rv,_,_), Rv > X),isBST(L),isBST(R).

lookup(_,empty):-1=0.
% lookup(N,node(V,empty,empty)):- N is V.
% lookup(N,node(V,_,_)):- N is V.
% lookup(N,node(V,empty,R)):-N is V; lookup(N,R).
% lookup(N,node(V,L,empty)):-N is V; lookup(N,L).
lookup(N,BST):-isBST(BST), BST= node(V,L,R),( N is V; lookup(N,L); lookup(N,R)).