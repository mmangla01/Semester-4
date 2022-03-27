open AST
(* open FunStack *)
val C_stack :AST FunStack.Stack ref = ref FunStack.create;
val V_stack :AST FunStack.Stack ref = ref FunStack.create;
fun postfix (LT(a,b)) = postfix(a)@postfix(b)@[LT_part_2]
	| postfix (LEQ(a,b)) = postfix(a)@postfix(b)@[LEQ_part_2]
	| postfix (EQ(a,b)) = postfix(a)@postfix(b)@[EQ_part_2]
	| postfix (GT(a,b)) = postfix(a)@postfix(b)@[GT_part_2]
	| postfix (NEQ(a,b)) = postfix(a)@postfix(b)@[NEQ_part_2]
	| postfix (GEQ(a,b)) = postfix(a)@postfix(b)@[GEQ_part_2]
	| postfix (PLUS(a,b)) = postfix(a)@postfix(b)@[PLUS_part_2]
	| postfix (MINUS(a,b)) = postfix(a)@postfix(b)@[MINUS_part_2]
	| postfix (NEGATIVE(a)) = postfix(a)@[NEGATIVE_part_2]
	| postfix (TIMES(a,b)) = postfix(a)@postfix(b)@[TIMES_part_2]
	| postfix (DIV(a,b)) = postfix(a)@postfix(b)@[DIV_part_2]
	| postfix (MOD(a,b)) = postfix(a)@postfix(b)@[MOD_part_2]
	| postfix (OR(a,b)) = postfix(a)@postfix(b)@[OR_part_2]
	| postfix (NOT(a)) = postfix(a)@[NOT_part_2]
	| postfix (AND(a,b)) = postfix(a)@postfix(b)@[AND_part_2]
	| postfix (SET(a,b)) = postfix(a)@postfix(b)@[SET_part_2]
	| postfix (READ(a)) = postfix(a)@[READ_part_2]
	| postfix (WRITE(a)) = postfix(a)@[WRITE_part_2]
	| postfix (ITE(a,b,C)) = postfix(a)@postfix(b)@postfix(c)@[ITE_part_2]
	| postfix (WH(a,b)) = postfix(a)@postfix(b)@[WH_part_2]
	| postfix (IDEN(a)) = [IDEN_part_2(a)]
	| postfix (BOOL(a)) = [BOOL_part_2(a)]
	| postfix (INT(a)) = [INT_part_2(a)]
	| postfix (SEQ(a)) = let val b = postfix(a) in [SEQ_part_2(b)] end
	| postfix (_) = ()

(* 
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
	| postfix (SET(a,b)) = (C_stack:= FunStack.push(SET_part_2(a), !C_stack); postfix(b))
	| postfix (READ(a)) = (C_stack:= FunStack.push(READ_part_2); postfix(a))
	| postfix (WRITE(a)) = (C_stack:= FunStack.push(WRITE_part_2); postfix(a))
	| postfix (ITE(a,b,c)) = (C_stack:= FunStack.push(ITE_part_2, !C_stack); postfix(a); postfix(b); postfix(c)) 
	| postfix (WH(a,b)) = (C_stack:= FunStack.push(WH_part_2, !C_stack); postfix(b); postfix(a))
	| postfix (IDEN(a)) = (C_stack:= FunStack.push(IDEN_part_2(a))) 
	| postfix (BOOL(a)) = (C_stack:= FunStack.push(BOOL_part_2(a), !C_stack))
	| postfix (INT(a)) = (C_stack:= FunStack.push(INT_part_2(a), !C_stack))
	| postfix (SEQ(a)) = let val b = postfix(a) in (C_stack:= FunStack.push(SEQ_part_2(), !C_stack))
	| postfix (_) = ()
 *)
