
open AST
use memory.sml
use postorder.sml


fun q(LT_part_2) = 
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
    | q(LEQ_part_2) = 
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
    | q(EQ_part_2) = 
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
    | q(GT_part_2) = 
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
    | q(GEQ_part_2) = 
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
    | q(NEQ_part_2) = 
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
    | q(PLUS_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val ItoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = ItoAST(a + b) in (V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) end
    | q(MINUS_part_2) = 
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
    | q(NEGATIVE_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val ItoAST(a) = top(!V_stack) 
			val ans = ItoAST(- a) 
		in 
			(V_stack:= FunStack.push(ans, stk1); C_stack:= cstk) 
		end
    | q(TIMES_part_2) = 
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
    | q(DIV_part_2) = 
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
    | q(MOD_part_2) = 
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
    | q(OR_part_2) = 
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
    | q(NOT_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val ItoAST(a) = top(!V_stack) val temp = if(a = 1) then 0 else 1 
			val ans = ItoAST(temp) in (V_stack:= FunStack.push(ans, stk1); C_stack:= cstk) end
    | q(AND_part_2) = 
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
    | q(SET_part_2) = 
		let 
			val cstk = pop(!C_stack) 
			val stk1 = pop(!V_stack) 
			val stk2 = pop(stk1) 
			val StoAST(a) = top(!V_stack) 
			val ItoAST(b) = top(stk1) 
			val ans = add_in_mem(a, b) 
		in 
			(V_stack:= stk2; C_stack:= cstk) 
		end
    | q(READ_part_2) = 
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
    | q(WRITE_part_2) = 
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
    | q(ITE_part_2) = 
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
    | q(WH_part_2) = 
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
    | q(SEQ_part_2) = 
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
    | q(INT_part_2) = 
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
    | q(BOOL_part_2) = 
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
    | q(IDEN_part_2) = 
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

    | q(LEQ_part_2) = let val cstk = pop(!C_stack) val stk1 = pop(!V_stack) val stk2 = pop(stk1) val ItoAST(a) = top(!V_stack) val ItoAST(b) = top(stk1) val ans = BtoAST(a < b) in (V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) end
    | q(LEQ_part_2) = let val cstk = pop(!C_stack) val stk1 = pop(!V_stack) val stk2 = pop(stk1) val ItoAST(a) = top(!V_stack) val ItoAST(b) = top(stk1) val ans = BtoAST(a < b) in (V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) end
    | q(LEQ_part_2) = let val cstk = pop(!C_stack) val stk1 = pop(!V_stack) val stk2 = pop(stk1) val ItoAST(a) = top(!V_stack) val ItoAST(b) = top(stk1) val ans = BtoAST(a < b) in (V_stack:= FunStack.push(ans, stk2); C_stack:= cstk) end
