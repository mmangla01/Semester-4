structure AST = 
struct 

datatype rel =  LT | LEQ | EQ | GT | GEQ | NEQ
and num = POSNUM of int
        | NUME of int
and exp = IEXP of intex
        | BEXP of boolex
and intex = PLUS of intex * intex
        | MINUS of intex * intex
        | NUMBER of num
        | IVAR of var
        | NEGATIVE of intex
        | TIMES of intex * intex
        | DIV of intex * intex
        | MOD of intex * intex
and boolex = OR of boolex * boolex 
        | BTERM of boolex
        | TT | FF
        | COMP of comp
        | NOT of boolex
        | BVAR of var
        | AND of boolex * boolex
and comp = COMPEX of intex * rel * intex
and cmd = SET of var * exp
        | READ of var
        | WRITE of intex
        | ITE of boolex * cmdseq * cmdseq
        | WH of boolex * cmdseq
and cmdd = CMD of cmd * cmdd
        | empty1
and cmdseq = CMDSEQ of cmdd
and vlist = VARONLY of var
        | VARLIST of var * vlist
and dec = DECINT of vlist
        | DECBOOL of vlist
and decseq = DECSEQ of dec * decseq
        | empty2
and blk = BLK of decseq * cmdseq
and prog =  PROG of iden * blk
and iden = IDEN of string
and var = VARIDEN of iden
end;
