% definition of integer binary tree:- ibt(BT) true when BT is an integer binary tree
% definiton as given in assignment instructions
ibt(empty).
ibt(node(N,L,R)):- integer(N),ibt(L),ibt(R).

%------------------------------------------------------------------------------------------------------------

% base case is when the input tree is empty and the size is 0
size(empty,0).
% by using simple recursion size of a tree can be given as 1+size of left subtree + size of right subtree
size(BT,N):- ibt(BT), BT = node(_,L,R), size(L,A),size(R,B),N is A+B+1.

% if else is used in finding the height of the tree
% base case is when the input tree is empty and the height is 0
height(empty,0).
% by using simple recursion height of a tree can be given as 1+height of left subtree + height of right subtree
height(BT,N):- ibt(BT), BT = node(_,L,R), height(L,A),height(R,B),(A>B -> N is A+1;N is B+1).

%---------------------------------------------- tree travesals ----------------------------------------------

%append is the inbuilt feature of the prolog language that is true when the third argument is list that we get by appending the first two lists
%preorder of empty tree is empty list
preorder(empty,[]).
%preorder of a tree can be listed as the value in root node then peorder of left subtree and then the preorder of right subtree
preorder(BT,L):-ibt(BT), BT = node(X,Left,Right),L = [X|B],preorder(Left,B1),preorder(Right,B2),append(B1,B2,B).

%inorder of empty tree is empty list
inorder(empty,[]).
%inorder of a tree can be listed as the inorder of the left subtree then the value of the root and then inorder of the right subtree
inorder(BT,L):- ibt(BT), BT = node(X,Left,Right),inorder(Left,L1),inorder(Right,L2),append(L1,[X|L2],L).

%postorder of empty tree is empty list
postorder(empty,[]).
%postorder of the tree can be listed as the postorder of the left subtree then the value of the root an the postorder of the right subtree 
postorder(BT,L):-ibt(BT), BT = node(X,Left,Right), postorder(Left,B1),postorder(Right,B2),append(B1,B2,B),append(B,[X],L).

%-------------------------------------- tree travesals(tail-recursive) --------------------------------------

%these follows the general tail-recusive algorithm for getting tree-traversals using stacks

%helpIreorder helps in building the stack and the list which is required to get the final answer.
helpPreorder([],[]).
helpPreorder(Stack,Answer):- Stack = [Pop|Tail], (Pop = empty -> helpPreorder(Tail,Answer); Pop = node(Value,Left,Right), 
                             append([Left,Right],Tail,Stack2),helpPreorder(Stack2,Answer2),Answer = [Value|Answer2]). 
trPreorder(empty,[]).
trPreorder(BT,L):- ibt(BT), helpPreorder([BT],L).

%helpInorder helps in building the stack by traversing to the left most node from the root level.
helpInorder(empty,[]).
helpInorder(Current,Stack):-  Current = node(_,Left,_),helpInorder(Left,Stack2),append(Stack2,[Current],Stack).
%helpInorder2 helps in building the stack and the list which is required to get the final answer using the stack that we get above.
helpInorder2([],[]).
helpInorder2(Stack,Answer):- Stack = [Pop|Tail], Pop = node(Value,_,Right), helpInorder(Right,Stack2), 
                             append(Stack2,Tail,Stack3), Answer = [Value|Answer2],helpInorder2(Stack3,Answer2). 
trInorder(empty,[]).
trInorder(BT,L):- ibt(BT), helpInorder(BT,Stack),helpInorder2(Stack,L).

%helpPostorder helps in building the stack and the list which is required to get the final answer.
helpPostorder([],[]).
helpPostorder(Stack1,Stack2):- Stack1 = [Pop|Tail], (Pop = empty -> helpPostorder(Tail,Stack2); Pop = node(Value,Left,Right), 
                               append([Right,Left],Tail,Stack3),helpPostorder(Stack3,Stack4), append(Stack4,[Value],Stack2)).
trPostorder(empty,[]).
trPostorder(BT,L):- ibt(BT), helpPostorder([BT],L).

%--------------------------------------------- Euler Traversals ---------------------------------------------

%simple recursive algorithm for euler tour traversal:- euler tour of a tree is given by [value, euler traversal of left subtree, value, euler travesal of right subtree, value].
eulerTourHelp(empty,[],[]).
eulerTourHelp(BT,L,Answer):-ibt(BT), BT = node(X,Left,Right),L = [(X,1)|List],Answer = [X|Answer2],eulerTourHelp(Left,Let,Ans1),eulerTourHelp(Right,Ret,Ans2),append(Let,[(X,2)],L1),append(Ret,[(X,3)],L2),append(L1,L2,List),append(Ans1,[X],ANS1),append(Ans2,[X],ANS2),append(ANS1,ANS2,Answer2).
eulerTour(BT,L):- eulerTourHelp(BT,_,L).

%this is a helper function that extracts all the three travesals from euler tour of a Binary tree.
%it forms three list, each corresponding to the third, second and first occurence respectively
extractET([],[],[],[]).
extractET(L,PostL,InL,PreL):- L = [(Head,X)|Tail],extractET(Tail,PostL1,InL1,PreL1), (X is 1 -> append([Head],PreL1,PreL),PostL=PostL1,InL=InL1; X is 2 ->  append([Head],InL1,InL),PostL=PostL1,PreL=PreL1;
                              append([Head],PostL1,PostL),PreL=PreL1,InL=InL1).

%preorder can be written as the order of first occurence of values
preET(empty,[]).
preET(BT,L):- ibt(BT), eulerTourHelp(BT,Ans,_),extractET(Ans,_,_,L).

%inorder can be written as the order of second occurence of values
inET(empty,[]).
inET(BT,L):- ibt(BT), eulerTourHelp(BT,Ans,_),extractET(Ans,_,L,_).

%postorder can be written as the order of third occurence of values
postET(empty,[]).
postET(BT,L):- ibt(BT), eulerTourHelp(BT,Ans,_),extractET(Ans,L,_,_).

%-------------------------------------------------- Extras --------------------------------------------------

% recursion for writing the binary tree as a string
toString(empty,"()").
toString(BT,S):- ibt(BT), BT = node(N,LBT,RBT), toString(LBT,S1), toString(RBT,S2), atomics_to_string(["(", N, ", ", S1, ", ", S2, ")"], S).

% if the tree is balanced then the the difference in heights of subtree is 1, 0 or -1.
isBalanced(empty).
isBalanced(BT):- ibt(BT), BT = node(_,L,R), height(L,A),height(R,B),(A>B -> A is B+1;A<B -> A is B-1; A is B).

%--------------------------------------------------- BSTs ---------------------------------------------------

%checks whether the given binary tree is a BST or not by checking the left and right subtree for the same 
%and by comparing the root value and left and right values 
isBST(empty).
isBST(BT):- ibt(BT), BT = node(X,L,R),(L = empty -> integer(X);L = node(Lv,_,_),X>=Lv),(R = empty ->integer(X);R = node(Rv,_,_), Rv >= X),isBST(L),isBST(R).

%makes a BST by recursion on the list. In each step the list is divided in two almost equal parts and a value 
%and then the value form the root and the parts become left and right subtree
makeBSThelp([],empty).
makeBSThelp([X],node(X,empty,empty)).
makeBSThelp(L,BST):- length(L,Length), Leftlen is Length//2, Rightlen is Length-Leftlen-1, append(List1,Right,L),append(Left,[X],List1), 
                 length(Left,Leftlen),length(Right,Rightlen), makeBSThelp(Left,LEFT), makeBSThelp(Right,RIGHT), BST = node(X,LEFT,RIGHT).
makeBST(L,BST):- sort(L, SL), makeBSThelp(SL,BST).


%search for the value in a BST, if the tree is empty then no matter the number to be seached, it outputs false
%else it searches using the property that the values in left nodes < root < right nodes
lookup(_,empty):- 1 is 0.
lookup(N,BST):-isBST(BST), BST = node(X,Left,Right), (X<N -> lookup(N,Right); X>N -> lookup(N,Left);X is N).

%inserthelp function reaches to the bottom most point of the tree where the number N is to be inserted
inserthelp(empty,_,empty).
inserthelp(node(X,empty,empty),_,node(X,empty,empty)). 
inserthelp(node(_,empty,node(A,B,C)),N,Node):- inserthelp(node(A,B,C),N,Node).
inserthelp(node(_,node(A,B,C),empty),N,Node):-inserthelp(node(A,B,C),N,Node).
inserthelp(BST,N,Node):- BST = node(Value,Left,Right), (Value < N -> inserthelp(Right,N,Node); inserthelp(Left,N,Node)).
%inserthelp2 updates and creates a new BST and the value at the node is updates by the value "Update"
inserthelp2(empty,empty,_,_).
inserthelp2(BST1,BST2,Node,Update):- BST1 = node(Value, Left,Right),(BST1 = Node -> (Update<Value -> BST2 = node(Value,node(Update,empty,empty),empty); 
         BST2 = node(Value,empty,node(Update,empty,empty)) ) ; inserthelp2(Left,L,Node,Update), inserthelp2(Right,R,Node,Update), BST2 = node(Value,L,R)).
%insert is the main fucntion that which findes the correct node and then returns the new BSt.
insert(N,empty,node(N,empty,empty)).
insert(N,BST1,BST2):- isBST(BST1), inserthelp(BST1,N,Node), inserthelp2(BST1,BST2,Node,N).

%deletemin is deleting the minimum element of a BST, which can be achieved by deleting the left most element of it exists or else deleting the root node
deletemin(empty,_,_).
deletemin(node(Y,empty,R),Y,R).
deletemin(node(Y,Left,Right),Z,node(Y,L,Right)):- deletemin(Left,Z,L).
%delete forms some cases
%if the root node is to be deleted :- if any of the subtree is empty then the answer is the other subtree, 
%           if both are non-empty then we delete the node that is next in inorder which definetly has left subtree as empty 
%              and replaces the value in root with that node's value
%if the root is not to be deleted then we move down in tree and apply delete on the corresponding subtree
delete(_,empty,empty).
delete(N,BST1,BST2):-  BST1 = node(Value,Left,Right), (N = Value -> (Left = empty -> BST2 = Right; Right= empty -> BST2 = Left; 
                       deletemin(Right,Z,R), BST2 = node(Z, Left, R)); N<Value -> delete(N,Left,BST3), BST2 = node(Value,BST3,Right); 
                       delete(N,Right,BST3), BST2 = node(Value,Left,BST3)).

%--------------------------------------------------- over ---------------------------------------------------