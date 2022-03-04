
open AST
%%
%name While

%term
    COLS | PROG | BLOCK | INT | BOOL | LEFTBRACE | RIGHTBRACE | COMMA | SEMIC | ASSIGN | READ | WRITE | IF | THEN | ELSE | ENDIF | WH 
    | DO | EWH | RIGHTPAREN | LEFTPAREN | NEG | OR | AND | TT | FF | NOT | LT | GT | LEQ | EQ | GEQ | NEQ | PLUS | MINUS | TIMES | DIV 
    | MOD | NUM of int | VAR of string | EOF | VARI

%nonterm Program of AST.prog | Block of AST.blk | DeclarationSeq of AST.decseq | Declaration of AST.dec | VariableList of AST.vlist | CommandSeq of AST.cmdseq | Command of AST.cmd | Expression of AST.exp | IntExpression of AST.intex | IntTerm of AST.intex 
| IntFactor of AST.intex | BoolExpression of AST.boolex | BoolTerm of AST.boolex | BoolFactor of AST.boolex | Comparison of AST.comp | RelOp of AST.rel | Numeral of AST.num | Cmds of AST.cmdd | Identifier of AST.iden | Variable of AST.var

%pos int
%arg (fileName) : string
%eop EOF
%noshift EOF
%start Program 
%verbose 

%%
Program: PROG Identifier BLOCK Block (AST.PROG(Identifier, Block))

Block: DeclarationSeq CommandSeq (AST.BLK(DeclarationSeq, CommandSeq))

DeclarationSeq: Declaration DeclarationSeq  (AST.DECSEQ(Declaration, DeclarationSeq)) 
        | (AST.empty2)

Declaration: VARI VariableList COLS INT SEMIC  (AST.DECINT(VariableList))
        | VARI VariableList COLS BOOL SEMIC  (AST.DECBOOL(VariableList))

VariableList: Variable COMMA VariableList (AST.VARLIST(Variable, VariableList))
        | Variable (AST.VARONLY(Variable))

CommandSeq: LEFTBRACE Cmds RIGHTBRACE  (AST.CMDSEQ(Cmds)) 

Cmds: Command SEMIC Cmds (AST.CMD(Command, Cmds))
        | (AST.empty1)

Command: Variable ASSIGN Expression  (AST.SET(Variable, Expression))
        | READ Variable (AST.READ(Variable))
        | WRITE IntExpression (AST.WRITE(IntExpression))
        | IF BoolExpression THEN CommandSeq ELSE CommandSeq ENDIF (AST.ITE(BoolExpression, CommandSeq1, CommandSeq2))
        | WH BoolExpression DO CommandSeq EWH (AST.WH(BoolExpression, CommandSeq))

Expression: IntExpression  (AST.IEXP(IntExpression)) 
        | BoolExpression (AST.BEXP(BoolExpression))

IntExpression: IntExpression PLUS IntTerm (AST.PLUS(IntExpression, IntTerm)) 
        | IntExpression MINUS IntTerm (AST.MINUS(IntExpression, IntTerm)) 
        | IntTerm (IntTerm)

IntTerm: IntTerm TIMES IntFactor (AST.TIMES(IntTerm, IntFactor)) 
        | IntTerm DIV IntFactor (AST.DIV(IntTerm, IntFactor)) 
        | IntTerm MOD IntFactor (AST.MOD(IntTerm, IntFactor)) 
        | IntFactor (IntFactor)

IntFactor: Numeral (AST.NUMBER(Numeral)) 
        | Variable (AST.IVAR(Variable)) 
        | LEFTPAREN IntExpression RIGHTPAREN (IntExpression) 
        | NEG IntFactor (NEGATIVE(IntFactor))

BoolExpression: BoolExpression OR BoolTerm (AST.OR(BoolExpression, BoolTerm)) 
        | BoolTerm (BoolTerm)

BoolTerm: BoolTerm AND BoolFactor (AST.AND(BoolTerm, BoolFactor))  
        | BoolFactor (BoolFactor) 

BoolFactor: TT (AST.TT) 
        | FF (AST.FF) 
        | Variable (AST.BVAR(Variable)) 
        | Comparison (AST.COMP(Comparison)) 
        | LEFTPAREN BoolExpression RIGHTPAREN (BoolExpression) 
        | NOT BoolFactor (AST.NOT(BoolFactor))

Comparison: IntExpression RelOp IntExpression (AST.COMPEX(IntExpression1, RelOp, IntExpression2))

RelOp: LT (AST.LT) 
        | LEQ (AST.LEQ) 
        | EQ (AST.EQ) 
        | GT (AST.GT) 
        | GEQ (AST.GEQ) 
        | NEQ (AST.NEQ)

Numeral: PLUS NUM (AST.POSNUM(NUM)) 
        | NUM (AST.NUME(NUM)) 

Identifier: VAR (AST.IDEN(VAR))

Variable: Identifier (AST.VARIDEN(Identifier))


