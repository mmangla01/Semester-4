open AST
open FunStack
val C_stack :AST FunStack.Stack ref = ref FunStack.create;
val V_stack :AST FunStack.Stack ref = ref FunStack.create;
fun postfix (LT(a,b)) = (C_stack:= FunStack.push(LT_part_2, !C_stack); postfix(b); postfix(a))
	| postfix (LEQ(a,b)) = (C_stack:= FunStack.push(LEQ_part_2, !C_stack); postfix(b); postfix(a))
	| postfix (EQ(a,b)) = (C_stack:= FunStack.push(EQ_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (GT(a,b)) = (C_stack:= FunStack.push(GT_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (NEQ(a,b)) = (C_stack:= FunStack.push(NEQ_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (GEQ(a,b)) = (C_stack:= FunStack.push(GEQ_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (PLUS(a,b)) = (C_stack:= FunStack.push(PLUS_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (MINUS(a,b)) = (C_stack:= FunStack.push(MINUS_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (NEGATIVE(a)) = (C_stack:= FunStack.push(NEGATIVE_part_2); postfix(a))
	| postfix (TIMES(a,b)) = (C_stack:= FunStack.push(TIMES_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (DIV(a,b)) = (C_stack:= FunStack.push(DIV_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (MOD(a,b)) = (C_stack:= FunStack.push(MOD_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (OR(a,b)) = (C_stack:= FunStack.push(OR_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (NOT(a)) = (C_stack:= FunStack.push(NOT_part_2); postfix(a))
	| postfix (AND(a,b)) = (C_stack:= FunStack.push(AND_part_2, !C_stack); postfix(b); postfix(a)) 
	| postfix (SET(a,b)) = (C_stack:= FunStack.push(SET_part_2, !C_stack); postfix(b); postfix(a))
	| postfix (READ(a)) = (C_stack:= FunStack.push(READ_part_2); postfix(a))
	| postfix (WRITE(a)) = (C_stack:= FunStack.push(WRITE_part_2); postfix(a))
	| postfix (ITE(a,b,c)) = (C_stack:= FunStack.push(ITE_part_2, !C_stack); postfix(a); postfix(b); postfix(c)) 
	| postfix (WH(a,b)) = (C_stack:= FunStack.push(WH_part_2, !C_stack); postfix(b); postfix(a))
	| postfix (IDEN(a)) = (C_stack:= FunStack.push(IDEN_part_2(a));) 
	| postfix (BOOL(a)) = (C_stack:= FunStack.push(BOOL_part_2(a), !C_stack);)
	| postfix (INT(a)) = (C_stack:= FunStack.push(INT_part_2(a), !C_stack);)
	| postfix (SEQ(a)) = (C_stack:= FunStack.push(SEQ_part_2(a), !C_stack)) let val y = SEQtoAST(a) val stk1 =  in C_stack:= FunStack.push(y, stk1) end 
	| postfix (_) = ()

