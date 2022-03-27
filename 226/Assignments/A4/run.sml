Control.Print.printLength := 1000; (* set printing parameters so that *)
Control.Print.printDepth := 1000; (* we’ll see all details *)
Control.Print.stringDepth := 1000; (* and strings *)
CM.make "while.cm";

use "stack.sml";
use "AST.sml";
open AST_structure;
open FunStack;
structure Vmc =
struct
val mem_size = 1000

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
	| postfix (WRITE(a)) = postfix(a)@[WRITE_part_2]
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
fun implement_seq(V,M:(string * int) array,C,[]) = ()
	| implement_seq(V,M:(string * int) array,C,(x::xs)) = (executor(V,M,C,x); implement_seq(V,M,C,xs))
	| implement_seq(_,_,_,_) = ()

and executor(V,M:(string * int) array,C,LT_part_2) = 
    	let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a < b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
            (FunStack.push(ans, stk2), M, cstk)
		end 
    | executor(V,M:(string * int) array,C,LEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a <= b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,EQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a = b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,GT_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a > b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,GEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a >= b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,NEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a <> b) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,PLUS_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a + b) 
        in 
            (FunStack.push(ans, stk2), M, cstk)
        end
    | executor(V,M:(string * int) array,C,MINUS_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a - b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,NEGATIVE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val ItoAST(a) = FunStack.top(V) 
            val b = (0-a)
			val ans = ItoAST(b) 
		in 
			(FunStack.push(ans, stk1), M, cstk)
		end
    | executor(V,M:(string * int) array,C,TIMES_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a * b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,DIV_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a div b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,MOD_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a mod b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
	| executor(V,M:(string * int) array,C,NEGATIVE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = ItoAST(a mod b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,OR_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a = 1 orelse b = 1) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,NOT_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val ItoAST(a) = FunStack.top(V) val temp = if(a = 1) then 0 else 1 
			val ans = ItoAST(temp) 
        in 
            (FunStack.push(ans, stk1), M, cstk)
        end
    | executor(V,M:(string * int) array,C,AND_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val temp = if(a = 1 andalso b = 1) then 1 else 0 
			val ans = ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end
    | executor(V,M:(string * int) array,C,SEQ_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C) 
		in 
            executor(V,M,cstk,FunStack.top(cstk))
		end 
    | executor(V,M:(string * int) array,C,INT_part_2(x)) = 
		let 
			val cstk = FunStack.pop(C)  
			val ans = ItoAST(x)
		in 
			(FunStack.push(ans, V), M, cstk) 
		end 
    | executor(V,M:(string * int) array,C,BOOL_part_2(x)) = 
		let 
			val cstk = FunStack.pop(C)  
			val ans = if(x) then 1 else 0
		in 
            (FunStack.push(ItoAST(ans), V), M, cstk)
		end
    | executor(V,M,C,IDEN_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C)  
            fun val_in_mem(variable, c:(string * int) array) = let val b = AST_structure.find_in_list(variable) in case b of SOME (x,y:int) => Array.sub(c, y) | NONE => ("",0) end
			val ans = val_in_mem(a, M)
		in 
			(FunStack.push(ItoAST(#2 ans), V), M, cstk)
		end
    | executor(V,M:(string * int) array,C,SET_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C)
			val stk1 = FunStack.pop(V) 
			val b = FunStack.top(V) 
            fun add_in_mem(variable, value) = let val a =  AST_structure.find_in_list (variable) in case a of SOME (x,y) => Array.update(M, y, (variable, value)) | NONE => () end
		in 
            (* add(a,b) *)
            (stk1, M, cstk) 
		end
    | executor(V,M:(string * int) array,C,READ_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C)  
			val ans = valOf(Int.fromString(valOf(TextIO.inputLine(TextIO.stdIn))))
            fun add_in_mem(variable, value) = let val a =  AST_structure.find_in_list (variable) in case a of SOME (x,y) => Array.update(M, y, (variable, value)) | NONE => () end
            val _ = add_in_mem(a, ans)
		in 
			(V, M, cstk)
		end
    | executor(V,M:(string * int) array,C,WRITE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val ItoAST(a) = FunStack.top(V) 
			val ans = print(Int.toString(a)^"\n") 
		in 
			(stk1, M, cstk)
		end
    | executor(V,M:(string * int) array,C,ITE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val stk3 = FunStack.pop(stk2)
			val ItoAST(a) = FunStack.top(V) 
			val SEQ(b) = FunStack.top(stk1) 
			val SEQ(c) = FunStack.top(stk2)
			val ans = if(a=1) then implement_seq(V,M,C,b) else implement_seq(V,M,C,c)
		in 
			(stk3, M, cstk) 
		end
    | executor(V,M:(string * int) array,C,WH_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val ItoAST(a) = FunStack.top(V) 
			val ItoAST(b) = FunStack.top(stk1) 
			val ans = BtoAST(a < b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end


fun rules(V,M,C) = if (FunStack.depth(C)=0) then ()
    else let val a = FunStack.top(C) val (v,m,c) = executor(V,M,C,a) in rules(v,m,c) end


fun execute(file) = 
    let 
        val VV = FunStack.create
        val AST_structure.PROG(a,(b,c)) = While.compile(file)
        val x = postfix(c)
        val CC = list2stack(x)
        val MM = Array.array (mem_size,("",0))
    in 
        rules(VV,MM,CC)
    end

fun toString (M) = let fun inttostr (a,b) = b ^ Int.toString(a) ^ ", " val ans = Array.foldr inttostr "" M in print("{ "^ans^"}") end
end 

val a = Vmc.execute "testcase.txt";
val exit : unit = OS.Process.exit(OS.Process.success);
