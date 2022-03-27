

structure VMC =
struct
val mem_size = 1000
val Memory = Array.array (mem_size,("",0)) : (string * int) array
val C_stack :AST FunStack.Stack ref = ref FunStack.create;
val V_stack :AST FunStack.Stack ref = ref FunStack.create;


fun add_in_mem(variable, value) = let val a =  find_in_list (variable) in case a of SOME (x,y) => Array.update(Memory, y, (variable, value)) | NONE => () end

fun val_in_mem(variable) = let val a = find_in_list(variable) in case a of SOME (x,y) => Array.sub(Memory, y) | NONE => 0 end

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
	| postfix (SET(a,b)) = postfix(b)@[SET_part_2(a)]
	| postfix (READ(a)) = [READ_part_2(a)]
	| postfix (WRITE(a)) = [WRITE_part_2(a)]
	| postfix (ITE(a,b,c)) = postfix(a)@postfix(b)@postfix(c)@[ITE_part_2]
	| postfix (WH(a,b)) = postfix(a)@postfix(b)@[WH_part_2]
	| postfix (IDEN(a)) = [IDEN_part_2(a)]
	| postfix (BOOL(a)) = [BOOL_part_2(a)]
	| postfix (INT(a)) = [INT_part_2(a)]
	| postfix (SEQ(a)) = let val b = postfix(SEQtoAST(a)) in [SEQ_part_2(b)] end
	| postfix (PROG(s,(a,b))) = postfix(b)@[PROG_part_2(s)]
	| postfix (SEQtoAST([])) = []
	| postfix (SEQtoAST(x::xs)) = postfix(x)@postfix(SEQtoAST(xs))
	| postfix (_) = []

fun rules(LT_part_2) = 
    	let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a < b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end 
    | rules(LEQ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a <= b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(EQ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a = b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(GT_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a > b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(GEQ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a >= b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(NEQ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a <> b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(PLUS_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a + b) in (V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) end
    | rules(MINUS_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a - b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(NEGATIVE_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val ItoAST(a) = top(!V_stack) 
			val ans = ItoAST(- a) 
		in 
			(V_stack:= FunStack.push(ans, stk1); C_stack:= cstk) 
		end
    | rules(TIMES_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a * b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(DIV_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a / b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(MOD_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a mod b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
		    | rules(NEGATIVE_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a mod b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(OR_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a = 1 orelse b = 1) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(NOT_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val ItoAST(a) = top(!V_stack) val temp = if(a = 1) then 0 else 1 
			val ans = ItoAST(temp) in (V_stack:= FunStack.push(ans, stk1); C_stack:= cstk) end
    | rules(AND_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val temp = if(a = 1 andalso b = 1) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(SEQ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = BtoAST(a < b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end 
    | rules(INT_part_2(x)) = 
		let 
			val cstk = pop(!C_stack)  
			val ans = x
		in 
			(V_stack:= FunStack.push(ans, !V_stack); C_stack:= cstk) 
		end 
    | rules(BOOL_part_2(x)) = 
		let 
			val cstk = pop(!C_stack)  
			val ans = if(x) then 1 else 0
		in 
			(V_stack:= FunStack.push(ans, !V_stack); C_stack:= cstk) 
		end
    | rules(IDEN_part_2(a)) = 
		let 
			val cstk = pop(!C_stack)  
			val ans = val_in_mem(a)
		in 
			(V_stack:= FunStack.push(ans, !V_stack); C_stack:= cstk) 
		end
    | rules(SET_part_2(a)) = 
		let 
			val cstk = pop(!C_stack)
			val stk1 = pop(!V_stack) 
			val b = top(!V_stack) 
		in 
			(V_stack:= stk1; C_stack:= cstk; add_in_mem(a, b)) 
		end
    | rules(READ_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = BtoAST(a < b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(WRITE_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = BtoAST(a < b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end
    | rules(ITE_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val stk3 = pop(stk2)
			val ItoAST(a) = top(!V_stack) 
			val SEQ(b) = top(stk1) 
			val SEQ(c) = top(stk2)
			val ans = if(a=1) then implement_seq(b) else implement_seq(c)
		in 
			(V_stack:= stk3; C_stack:= cstk) 
		end
    | rules(WH_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = BtoAST(a < b) 
		in 
			(V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) 
		end

and implement_seq(SEQ([])) = ()
	| implement_seq(SEQ(x::xs)) = (rules(x); implement_seq(xs))
	| implement_seq(_) = ()



fun execute(file) = 
    let 
        val ast = While.compile(file)
        val x = postfix(ast)
        val c = list2stack(x)
    in 
        postfix(ast)
    end
end 