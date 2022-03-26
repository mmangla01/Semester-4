
open AST
%%
%name While

%term
    COLS | PROG | BLOCK | INT | BOOL | LEFTBRACE | RIGHTBRACE | COMMA | SEMIC | ASSIGN | READ | WRITE | IF | THEN | ELSE 
    | ENDIF | WH | DO | EWH | RIGHTPAREN | LEFTPAREN | NEG | OR | AND | TT | FF | NOT | LT | GT
    | LEQ | EQ | GEQ | NEQ | PLUS | MINUS | TIMES | DIV | MOD | NUM of int 
    | VAR of string | EOF | VARI

%nonterm Program of AST | Block of (string list * string) list * AST | DeclarationSeq of (string list * string) list 
        | Declaration of string list * string | VariableList of string list | CommandSeq of AST | Command of AST 
        | Expression of AST * string | Term of AST * string | Factor of AST * string | Comparison of AST * string | RelOp | Numeral of int | Cmds of AST list 
        | Identifier of string | Variable of string | Exp of AST * string | Tm of AST * string | Fact of AST * string

%pos int
%arg (fileName) : string
%eop EOF
%noshift EOF
%start Program 
%verbose 

%%
Program: PROG Identifier BLOCK Block (PROG(Identifier, Block))

Block: DeclarationSeq CommandSeq (DeclarationSeq, CommandSeq)

DeclarationSeq: Declaration DeclarationSeq  (Declaration::DeclarationSeq)
        | ([])

Declaration: VARI VariableList COLS INT SEMIC  (case check_in_list(VariableList) of SOME alpha => error("\nERROR: '" ^ alpha ^ "' already declared\n") | NONE => add_in_list(VariableList,"int"); (VariableList, "int"))
        | VARI VariableList COLS BOOL SEMIC  (case check_in_list(VariableList) of SOME alpha => error("\nERROR: '" ^ alpha ^ "' already declared\n") | NONE => add_in_list(VariableList,"bool"); (VariableList, "bool"))

VariableList: Variable COMMA VariableList (Variable::VariableList)
        | Variable (Variable::[])

CommandSeq: LEFTBRACE Cmds RIGHTBRACE  (SEQ(Cmds))

Cmds: Command SEMIC Cmds (Command::Cmds)
        | ([])

Command: Variable ASSIGN Expression  (case find_in_list(Variable) of SOME alpha => (if ((#2 Expression) = (#1 alpha)) then (SET(Variable, (#1 Expression))) else error("\nERROR: variable and expression type does not match\n")) | NONE => error("\nERROR: variable not declared\n"))
        | READ Variable (READ(Variable))
        | WRITE Expression (WRITE(#1 Expression))
        | IF Expression THEN CommandSeq ELSE CommandSeq ENDIF (if((#2 Expression) = "bool") then ITE((#1 Expression), CommandSeq1, CommandSeq2) else error("\nERROR: bool expected in IF clause\n"))
        | WH Expression DO CommandSeq EWH (if((#2 Expression) = "bool") then WH((#1 Expression), CommandSeq) else error("\nERROR: bool expected in WHILE clause\n"))

Expression: Expression OR Term (if(((#2 Term) = "bool") andalso ((#2 Expression) = "bool")) then (OR((#1 Expression),(#1 Term)),"bool") else error("\nERROR: operand type does not match\n"))
        | Term (Term)

Exp: Exp PLUS Tm (if(((#2 Tm) = "int") andalso ((#2 Exp) = "int")) then (PLUS((#1 Exp), (#1 Tm)),"int") else error("\nERROR: operand type does not match\n"))
        | Exp MINUS Tm (if(((#2 Tm) = "int") andalso ((#2 Exp) = "int")) then (MINUS((#1 Exp), (#1 Tm)),"int") else error("\nERROR: operand type does not match\n"))
        | Tm (Tm)

Term: Term AND Factor (if(((#2 Term) = "bool") andalso ((#2 Factor) = "bool")) then (AND((#1 Term), (#1 Factor)),"bool") else error("\nERROR: operand type does not match\n"))
        | Factor (Factor)

Tm: Tm DIV Fact (if(((#2 Tm) = "int") andalso ((#2 Fact) = "int")) then (DIV((#1 Tm), (#1 Fact)),"int") else error("\nERROR: operand type does not match\n"))
        | Tm TIMES Fact (if(((#2 Tm) = "int") andalso ((#2 Fact) = "int")) then (TIMES((#1 Tm), (#1 Fact)),"int") else error("\nERROR: operand type does not match\n"))
        | Tm MOD Fact (if(((#2 Tm) = "int") andalso ((#2 Fact) = "int")) then (MOD((#1 Tm), (#1 Fact)),"int") else error("\nERROR: operand type does not match\n"))
        | Fact (Fact)

Factor: Comparison (Comparison)
        | NOT Factor (if((#2 Factor) = "bool") then (NOT((#1 Factor)),"bool") else error("\nERROR: operand type does not match\n"))

Fact: LEFTPAREN Expression RIGHTPAREN (Expression)
        | NEG Fact (if((#2 Fact)="int") then (NEGATIVE((#1 Fact)),"int") else error("\nERROR: operand type does not match\n"))
        | TT ((BOOL(true),"bool"))
        | FF ((BOOL(false),"bool"))
        | Numeral ((INT(Numeral),"int"))
        | Variable (case find_in_list(Variable) of SOME alpha => (IDEN(Variable),(#1 alpha)) | NONE => error("\nERROR: variable not declared\n"))

Comparison: Exp LT Exp (if((#2 Exp1) = (#2 Exp2)) then (LT((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp LEQ Exp (if((#2 Exp1) = (#2 Exp2)) then (LEQ((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp EQ Exp (if((#2 Exp1) = (#2 Exp2)) then (EQ((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp GT Exp (if((#2 Exp1) = (#2 Exp2)) then (GT((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp GEQ Exp (if((#2 Exp1) = (#2 Exp2)) then (GEQ((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp NEQ Exp (if((#2 Exp1) = (#2 Exp2)) then (NEQ((#1 Exp1), (#1 Exp2)), "bool") else error ("\nERROR: type mismatch of operands\n"))
        | Exp (Exp)

Numeral: PLUS NUM (NUM) 
        | NUM (NUM) 

Identifier: VAR (VAR)

Variable: Identifier (Identifier)
