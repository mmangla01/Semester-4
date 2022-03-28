Control.Print.printLength := 1000; (* set printing parameters so that *)
Control.Print.printDepth := 1000; (* we’ll see all details *)
Control.Print.stringDepth := 1000; (* and strings *)
CM.make "while.cm";

use "stack.sml";
open AST_structure;
structure Vmc =
struct
val mem_size = 100
val M: ((string * int) array) ref = ref (Array.array(mem_size,("",0)) )
fun toString(M) = let fun inttostr ((c,a),b) =  b ^ Int.toString((a)) ^ ", "  val ans = Array.foldl inttostr "" M in ("{ "^ans^"}") end
fun postfix (AST_structure.LT(a,b)) = postfix(a)@postfix(b)@[AST_structure.LT_part_2]
	| postfix (AST_structure.LEQ(a,b)) = postfix(a)@postfix(b)@[AST_structure.LEQ_part_2]
	| postfix (AST_structure.EQ(a,b)) = postfix(a)@postfix(b)@[AST_structure.EQ_part_2]
	| postfix (AST_structure.GT(a,b)) = postfix(a)@postfix(b)@[AST_structure.GT_part_2]
	| postfix (AST_structure.NEQ(a,b)) = postfix(a)@postfix(b)@[AST_structure.NEQ_part_2]
	| postfix (AST_structure.GEQ(a,b)) = postfix(a)@postfix(b)@[AST_structure.GEQ_part_2]
	| postfix (AST_structure.PLUS(a,b)) = postfix(a)@postfix(b)@[AST_structure.PLUS_part_2]
	| postfix (AST_structure.MINUS(a,b)) = postfix(a)@postfix(b)@[AST_structure.MINUS_part_2]
	| postfix (AST_structure.NEGATIVE(a)) = postfix(a)@[AST_structure.NEGATIVE_part_2]
	| postfix (AST_structure.TIMES(a,b)) = postfix(a)@postfix(b)@[AST_structure.TIMES_part_2]
	| postfix (AST_structure.DIV(a,b)) = postfix(a)@postfix(b)@[AST_structure.DIV_part_2]
	| postfix (AST_structure.MOD(a,b)) = postfix(a)@postfix(b)@[AST_structure.MOD_part_2]
	| postfix (AST_structure.OR(a,b)) = postfix(a)@postfix(b)@[AST_structure.OR_part_2]
	| postfix (AST_structure.NOT(a)) = postfix(a)@[AST_structure.NOT_part_2]
	| postfix (AST_structure.AND(a,b)) = postfix(a)@postfix(b)@[AST_structure.AND_part_2]
	| postfix (AST_structure.SET(a,b)) = [AST_structure.StoAST(a)]@postfix(b)@[AST_structure.SET_part_2]
	| postfix (AST_structure.READ(a)) = [AST_structure.StoAST(a)]@[AST_structure.READ_part_2]
	| postfix (AST_structure.WRITE(a)) = postfix(a)@[AST_structure.WRITE_part_2]
	| postfix (AST_structure.ITE(a,b,c)) = [AST_structure.ENDIF_part_2]@postfix(c)@postfix(b)@postfix(a)@[AST_structure.ITE_part_2]
	| postfix (AST_structure.WH(a,b)) = let val [AST_structure.SEQ_part_2(c)] = postfix(b) in [ENDIF_part_2]@[AST_structure.SEQ_part_2([])]@[AST_structure.SEQ_part_2(c@[WH(a,b)])]@postfix(a)@[AST_structure.ITE_part_2] end
	| postfix (AST_structure.IDEN(a)) = [AST_structure.IDEN_part_2(a)]
	| postfix (AST_structure.BOOL(a)) = [AST_structure.BtoAST(a)]
	| postfix (AST_structure.INT(a)) = [AST_structure.ItoAST(a)]
	| postfix (AST_structure.SEQ(a)) = let val b = postfix(AST_structure.SEQtoAST(a)) in [AST_structure.SEQ_part_2(b)] end
	| postfix (AST_structure.PROG(s,(a,b))) = postfix(b)
	| postfix (AST_structure.SEQtoAST([])) = []
	| postfix (AST_structure.SEQtoAST(x::xs)) = postfix(x)@postfix(AST_structure.SEQtoAST(xs))
	| postfix (_) = []
(* fun implement_seq(V,C,[]) = ()
	| implement_seq(V,C,(x::xs)) = (executor([],x,FunStack.top(x)); implement_seq(V,C,xs)) *)

fun executor(V,C,AST_structure.LT_part_2) = 
    	let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(b < a) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
            (FunStack.push(ans, stk2),  cstk)
		end 
    | executor(V,C,AST_structure.LEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(b <= a) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.EQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(a = b) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.GT_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(b > a) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.GEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(b >= a) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.NEQ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(a <> b) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.PLUS_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(a + b) 
        in 
            (FunStack.push(ans, stk2),  cstk)
        end
    | executor(V,C,AST_structure.MINUS_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(b - a) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.NEGATIVE(g)) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
            val b = (0-a)
			val ans = AST_structure.ItoAST(b) 
		in 
			(FunStack.push(ans, stk1),  cstk)
		end
    | executor(V,C,AST_structure.TIMES_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(a * b) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.DIV_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(b div a) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.MOD_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(b mod a) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
	| executor(V,C,AST_structure.NEGATIVE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.ItoAST(0 - a) 
		in 
			(FunStack.push(ans, stk1),  cstk)
		end
    | executor(V,C,AST_structure.OR_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(a = 1 orelse b = 1) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.NOT_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0val temp = if(a = 1) then 0 else 1 
			val ans = AST_structure.ItoAST(temp) 
        in 
            (FunStack.push(ans, stk1),  cstk)
        end
    | executor(V,C,AST_structure.AND_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val temp = if(a = 1 andalso b = 1) then 1 else 0 
			val ans = AST_structure.ItoAST(temp) 
		in 
			(FunStack.push(ans, stk2),  cstk)
		end
    | executor(V,C,AST_structure.SEQ_part_2([])) = (V,FunStack.pop(C))
    | executor(V,C,AST_structure.SEQ_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C) 
            val dummy = FunStack.list2stack(a)
            (* val (al,bl) = executor([],dummy,FunStack.top(dummy))
            val temp = rules(al,bl) *)
            val temp = rules([], dummy)
		in 
            (V,cstk)
		end 
    | executor(V,C,AST_structure.ItoAST(a)) = 
		let 
			val cstk = FunStack.pop(C)
			val ans = AST_structure.ItoAST(a)
		in 
			(FunStack.push(ans, V),  cstk) 
		end 
    | executor(V,C,AST_structure.BtoAST(x)) = 
		let 
			val cstk = FunStack.pop(C)  
			val ans = if(x) then 1 else 0
		in 
            (FunStack.push(AST_structure.ItoAST(ans), V),  cstk)
		end
    | executor(V,C,AST_structure.IDEN_part_2(a)) = 
		let 
			val cstk = FunStack.pop(C)  
            fun val_in_mem(variable, c:(string * int) array) = let val b = AST_structure.find_in_list(variable) in case b of SOME (x,y:int) => Array.sub(c, y) | NONE => ("",0) end
			val ans = val_in_mem(a, !M)
		in 
			(FunStack.push(AST_structure.ItoAST(#2 ans), V),  cstk)
		end
    | executor(V,C,AST_structure.SET_part_2) = 
		let 
			val cstk = FunStack.pop(C)
			val stk1 = FunStack.pop(V)
            val stk2 = FunStack.pop(stk1)
            val a = case FunStack.top(stk1) of StoAST(x) => x | _ => ""
            val b = case FunStack.top(V) of ItoAST(x) => x | _ => 0
            fun add_in_mem(variable, value) = let val a = AST_structure.find_in_list (variable) in case a of SOME (x,y) => Array.update(!M, y, (variable, value)) | NONE => () end
            val _ = add_in_mem(a, b)
		in 
            (* add(a,b) *)
            (stk2,  cstk)
		end
    | executor(V,C,AST_structure.READ_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
            val stk1 = FunStack.pop(V)
            val a = case FunStack.top(V) of AST_structure.StoAST(x) => x | _ => "" 
			val ans = valOf(Int.fromString(valOf(TextIO.inputLine(TextIO.stdIn))))
            fun add_in_mem(variable, value) = let val a =  AST_structure.find_in_list (variable) in case a of SOME (x,y) => Array.update(!M, y, (variable, value)) | NONE => () end
            val _ = add_in_mem(a, ans)
		in 
			(V,  cstk)
		end
    | executor(V,C,AST_structure.WRITE_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val _ = print(Int.toString(a)^"\n")
		in 
			(stk1,cstk)
		end
    | executor(V,C,AST_structure.ITE_part_2) = 
		let 
			val bool = FunStack.top(V);
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val cstk = FunStack.pop(C)
			val stk1 = FunStack.pop(V)
			val stk2 = FunStack.pop(stk1)
			val stk3 = FunStack.pop(stk2)
            val b = case FunStack.top(stk1) of SEQ_part_2(x) => FunStack.list2stack(x) | _ => []
            val c = case FunStack.top(stk2) of SEQ_part_2(x) => FunStack.list2stack(x) | _ => []
            (* val _ = print(Int.toString(FunStack.depth(V)))
            val _ = print(Int.toString(FunStack.depth(C))) *)
			val ans = if(a=1) then FunStack.top(stk1) else FunStack.top(stk2)
            val cstk1 = FunStack.push(ans,cstk)
			(* val s = rules(ans); *)
            (* val _ = print(s); *)
		in 
			(stk3, cstk1)
		end
    (* | executor(V,M:(string * int) array,C,AST_structure.WH_part_2) = 
		let 
			val cstk = FunStack.pop(C) 
			val stk1 = FunStack.pop(V) 
			val stk2 = FunStack.pop(stk1) 
            
			val a = case FunStack.top(V) of AST_structure.ItoAST(x) => x | _ => 0
			val b = case FunStack.top(stk1) of AST_structure.ItoAST(x) => x | _ => 0
			val ans = AST_structure.BtoAST(a < b) 
		in 
			(FunStack.push(ans, stk2), M, cstk)
		end *)
    | executor (V,C,AST_structure.StoAST(a)) = (FunStack.push(StoAST(a), V), FunStack.pop(C)) 
	| executor (V,C,AST_structure.ENDIF_part_2) = 
		let
			val a = FunStack.pop(C)
			val b = FunStack.pop(a)
			val c = FunStack.pop(b)
			val d = FunStack.push(FunStack.top(a), V)
			val e = FunStack.push(FunStack.top(b), d)
		in
			(e, c)
		end
        
	| executor (V,C,AST_structure.WH(a,b)) = let val c = postfix(AST_structure.WH(a,b)) in executor(V,c@FunStack.pop(C), FunStack.top(c@FunStack.pop(C))) end
	(* | executor (V,C,AST_structure.WH(a,b)) = let val c = postfix(AST.structure.WH(a,b)) in executor(V,FunStack.list2stack(c),FunStack.top(FunStack.list2stack(c))) end *)
    | executor (V,C,_) = ((V,C))


and rules(V,C) = if (FunStack.depth(C)=0) then (toString(!M))
    else let val a = FunStack.top(C) val (v,c) = executor(V,C,a) in rules(v,c) end


fun execute(file) = 
    let 
        val VV = FunStack.create
        val AST_structure.PROG(a,(b,c)) = While.compile(file)
        val x = postfix(c)
        val CC = FunStack.list2stack(x)
    in 
        rules(VV,CC)
    end


end 
(* val a = While.compile("testcase.txt");
val b = Vmc.postfix(a);
val memory = Vmc.rules([],b); *)
val memory = Vmc.execute("testcase.txt");
val exit : unit = OS.Process.exit(OS.Process.success);