# COL226 Assignment 3 
##### _Mayank Mangla_
##### _2020CS50430_
The submitted zip file contains `while_ast.lex`, `while_ast.yacc`, `while.cm`, `glue.sml`, `compiler.sml`, `run.sml` and `AST.sml` along with this readme file.
### Run the code
1. Run the `run.sml` file in sml environment.
2. Then run `While.compile <filename>`.

### Context-Free Grammar
The grammer used can be expressed by following Semantic Rules
##### _PROG_ is the start symbol
##### _Set of Terminals_ : 
{`COLS, PROG, BLOCK, INT, BOOL, LEFTBRACE, RIGHTBRACE, COMMA, SEMIC, ASSIGN, READ, WRITE, IF, THEN, ELSE, ENDIF, WH, DO, EWH, RIGHTPAREN, LEFTPAREN, NEG, OR, AND, TT, FF, NOT, LT, GT, LEQ, EQ, GEQ, NEQ, PLUS, MINUS, TIMES, DIV, MOD, NUM, VAR, EOF, VARI`}
##### _Set of Non Terminals_ :
{`Program, Identifier, Block, DeclarationSeq, CommandSeq, Declaration, VariableList, Variable, Cmds, Command, Expression, IntExpression, BoolExpression, IntTerm, IntFactor, Numeral, BoolTerm, BoolFactor, Comparison, RelOp`}
##### _Production Rule_ : 
```
- Program: PROG Identifier BLOCK Block 
- Block: DeclarationSeq CommandSeq
- DeclarationSeq: Declaration DeclarationSeq 
                | epsilon
- Declaration: VARI VariableList COLS INT SEMIC  
            | VARI VariableList COLS BOOL SEMIC  
- VariableList: Variable COMMA VariableList 
                | Variable 
- CommandSeq: LEFTBRACE Cmds RIGHTBRACE  
- Cmds: Command SEMIC Cmds 
        | epsilon
- Command: Variable ASSIGN Expression 
        | READ Variable 
        | WRITE IntExpression 
        | IF BoolExpression THEN CommandSeq ELSE CommandSeq ENDIF 
        | WH BoolExpression DO CommandSeq EWH 
- Expression: IntExpression 
            | BoolExpression 
- IntExpression: IntExpression PLUS IntTerm 
                | IntExpression MINUS IntTerm 
                | IntTerm
- IntTerm: IntTerm TIMES IntFactor 
            | IntTerm DIV IntFactor 
            | IntTerm MOD IntFactor 
            | IntFactor 
- IntFactor: Numeral
        | Variable 
        | LEFTPAREN IntExpression RIGHTPAREN 
        | NEG IntFactor 
- BoolExpression: BoolExpression OR BoolTerm 
                | BoolTerm 
- BoolTerm: BoolTerm AND BoolFactor 
            | BoolFactor
- BoolFactor: TT | FF 
            | Variable 
            | Comparison 
            | LEFTPAREN BoolExpression RIGHTPAREN 
            | NOT BoolFactor
- Comparison: IntExpression RelOp IntExpression
- RelOp: LT | LEQ | EQ | GT | GEQ | NEQ
- Numeral: PLUS NUM | NUM 
- Identifier: VAR
- Variable: Identifier
```

### AST Datatype Definitions
```
structure AST = 
struct 
datatype rel =  LT | LEQ | EQ | GT | GEQ | NEQ
and exp = IEXP of intex
        | BEXP of boolex
and intex = PLUS of intex * intt
        | MINUS of intex * intt
        | ITERM of intt
and boolex = OR of boolex * boolt 
        | BTERM of boolt
and boolf = TT | FF
        | COMP of comp
        | BEX of boolex
        | NOT of boolf
        | BVAR of var
and boolt = AND of boolt * boolf
        | BFACT of boolf
and intt = TIMES of intt * intf
        | DIV of intt * intf
        | MOD of intt * intf
        | IFACT of intf
and cmd = SET of var * exp
        | READ of var
        | WRITE of intex
        | ITE of boolex * cmdseq * cmdseq
        | WH of boolex * cmdseq
and cmdd = CMD of cmd * cmdd
        | empty1
and cmdseq = CMDSEQ of cmdd
and dec = DECINT of vlist
        | DECBOOL of vlist
and decseq = DECSEQ of dec * decseq
        | empty2
and blk = BLK of decseq * cmdseq
and prog =  PROG of iden * blk
end;
```
### Auxilary Functions and Data
```
num = POSNUM of int
        | NUM of int
and intf = NUMBER of num
        | IVAR of var
        | IEX of intex
        | NEGATIVE of intf
and iden = IDEN of string
and var = VARIDEN of iden
and vlist = VARONLY of var
        | VARLIST of var * vlist
and comp = COMPEX of intex * rel * intex
```
### Syntax Directed Translation
```
- Program: PROG Identifier BLOCK Block  (AST.PROG(Identifier, Block))
            
- Block: DeclarationSeq CommandSeq (AST.BLK(DeclarationSeq, CommandSeq))
        
- DeclarationSeq: Declaration DeclarationSeq  
                (AST.DECSEQ(Declaration, DeclarationSeq)) 
- DeclarationSeq: empty (AST.empty2)
                
- Declaration: VARI VariableList COLS INT SEMIC  (AST.DECINT(VariableList)) 
- Declaration: VARI VariableList COLS BOOL SEMIC  (AST.DECBOOL(VariableList))
                
- VariableList: Variable COMMA VariableList 
                (AST.VARLIST(Variable, VariableList)) 
- VariableList: Variable (AST.VARONLY(Variable))
                
- CommandSeq: LEFTBRACE Cmds RIGHTBRACE  (AST.CMDSEQ(Cmds)) 

- Cmds: Command SEMIC Cmds (AST.CMD(Command, Cmds))
- Cmds: empty (AST.empty1)

- Command: Variable ASSIGN Expression  (AST.SET(Variable, Expression)) 
- Command: READ Variable (AST.READ(Variable)) 
- Command: WRITE IntExpression (AST.WRITE(IntExpression)) 
- Command: IF BoolExpression THEN CommandSeq ELSE CommandSeq ENDIF 
            (AST.ITE(BoolExpression, CommandSeq1, CommandSeq2)) 
- Command: WH BoolExpression DO CommandSeq EWH 
            (AST.WH(BoolExpression, CommandSeq))

- Expression: IntExpression  (AST.IEXP(IntExpression)) 
- Expression: BoolExpression (AST.BEXP(BoolExpression))

- IntExpression: IntExpression PLUS IntTerm 
                (AST.PLUS(IntExpression, IntTerm)) 
- IntExpression: IntExpression MINUS IntTerm 
                (AST.MINUS(IntExpression, IntTerm)) 
- IntExpression: IntTerm (AST.ITERM(IntTerm))

- IntTerm: IntTerm TIMES IntFactor (AST.TIMES(IntTerm, IntFactor)) 
- IntTerm: IntTerm DIV IntFactor (AST.DIV(IntTerm, IntFactor)) 
- IntTerm: IntTerm MOD IntFactor (AST.MOD(IntTerm, IntFactor)) 
- IntTerm: IntFactor (AST.IFACT(IntFactor))

- IntFactor: Numeral (AST.NUMBER(Numeral)) 
- IntFactor: Variable (AST.IVAR(Variable)) 
- IntFactor: LEFTPAREN IntExpression RIGHTPAREN (AST.IEX(IntExpression)) 
- IntFactor: NEG IntFactor (NEGATIVE(IntFactor))

- BoolExpression: BoolExpression OR BoolTerm (AST.OR(BoolExpression, BoolTerm)) 
- BoolExpression: BoolTerm (AST.BTERM(BoolTerm))

- BoolTerm: BoolTerm AND BoolFactor (AST.AND(BoolTerm, BoolFactor))  
- BoolTerm: BoolFactor (AST.BFACT(BoolFactor)) 

- BoolFactor: TT (AST.TT) 
- BoolFactor: FF (AST.FF) 
- BoolFactor: Variable (AST.BVAR(Variable)) 
- BoolFactor: Comparison (AST.COMP(Comparison)) 
- BoolFactor: LEFTPAREN BoolExpression RIGHTPAREN (AST.BEX(BoolExpression)) 
- BoolFactor: NOT BoolFactor (AST.NOT(BoolFactor))

- Comparison: IntExpression RelOp IntExpression 
            (AST.COMPEX(IntExpression1, RelOp, IntExpression2))

- RelOp: LT (AST.LT)
- RelOp: LEQ (AST.LEQ)
- RelOp: EQ (AST.EQ)
- RelOp: GT (AST.GT)
- RelOp: GEQ (AST.GEQ) 
- RelOp: NEQ (AST.NEQ)


- Numeral: PLUS NUM (AST.POSNUM(NUM)) 
- Numeral: NUM (AST.NUM(NUM)) 

- Identifier: VAR (AST.IDEN(VAR))

- Variable: Identifier (AST.VARIDEN(Identifier))
```
### Other Decisions
1. The Declaration Sequence and Command Sequence also produces emtpy production.
2. Some simplification has been done to reduce some terminals and make Datatypes more clear.

### Acknowledgement
1. Reference was taken from the http://rogerprice.org/ug/ug.pdf.
2. `cmake`, `compiler` and `glue` has been looked in this pdf.
3. EBNF has been referred from HyperNotes.