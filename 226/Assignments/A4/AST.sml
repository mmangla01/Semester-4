
structure AST_structure = 
struct 
datatype AST = AST of AST 
    | LT  of AST * AST
    | LEQ of AST * AST
    | EQ  of AST * AST
    | GT  of AST * AST
    | GEQ of AST * AST
    | NEQ of AST * AST
    | PLUS of AST * AST
    | MINUS of AST * AST
    | NEGATIVE of AST
    | TIMES of AST * AST
    | DIV of AST * AST
    | MOD of AST * AST
    | OR of AST * AST
    | NOT of AST
    | AND of AST * AST
    | SET of string * AST
    | READ of string
    | WRITE of AST
    | ITE of AST * AST * AST 
    | WH of AST * AST 
    | PROG of string * ((string list * string) list * AST)
    | IDEN of string
    | BOOL of bool
    | INT of int 
	| SEQ of AST list
(* ------------------------------------------------------------------------------------ *)
    | AST_part_2 
    | LT_part_2 
    | LEQ_part_2 
    | EQ_part_2 
    | GT_part_2 
    | GEQ_part_2 
    | NEQ_part_2 
    | PLUS_part_2 
    | MINUS_part_2 
    | NEGATIVE_part_2 
    | TIMES_part_2 
    | DIV_part_2 
    | MOD_part_2 
    | OR_part_2 
    | NOT_part_2 
    | AND_part_2 
    | SET_part_2 of string
    | READ_part_2 of string
    | WRITE_part_2
    | ITE_part_2 
    | WH_part_2 
	| SEQ_part_2 of AST list
	| INT_part_2 of int 
	| BOOL_part_2 of bool
	| IDEN_part_2 of string
	| StoAST of string
	| ItoAST of int
	| BtoAST of bool
	| SEQtoAST of AST list
	| PROG_part_2 of string
(* val TableSize = 500;
val HashFactor = 5;
val HashFunction = fn s =>
        List.foldr (fn (c,v) => (v*HashFactor+(ord c)) mod TableSize) 0 (explode s);
val HashTable = Array.array (TableSize,[("","")]) : (string * string) list array; *)
val symboltable:(string * string * int) list ref = ref [];
fun add_in_list ([],_) = ()
	| add_in_list (head::tail, typ) = 
		let 
			val n = List.length(!symboltable)
		in 
			(symboltable := (head, typ, n+1)::(!symboltable);
			add_in_list (tail, typ))
		end 
fun find_in_list s = 
	let 
		val b = !symboltable
		fun findInList ((key,typ,a)::tail) = if key=s then SOME (typ, a) else findInList tail
		  | findInList ([]) = NONE
	in 
		findInList(b)
	end
fun check_in_list ([]) = NONE
	| check_in_list (x::xs) =
		let 
			val f = find_in_list(x)
		in 
			case f of SOME t => SOME x 
			| NONE => check_in_list xs
		end
		
fun error(msg) = 
	let
		val _ = print(msg)
		val _ = print("\n")
	in 
		OS.Process.exit(OS.Process.success)
	end 
end

(* fun add_in_ht ([],_) = ()
  | add_in_ht (head::tail,typ) =
  	let
  		val i = HashFunction head
  		val j = Array.update(HashTable,i,(head,typ)::(Array.sub(HashTable,i)))
  	in
  		add_in_ht (tail,typ)
  	end
fun find_in_ht s =
	let
		val i = HashFunction s
		fun findInList ((key,typ)::tail) = if key=s then SOME typ else findInList tail
		  | findInList ([]) = NONE
	in
		findInList(Array.sub(HashTable,i))
	end
fun checklist ([]) = NONE
    |checklist (x::xs) = 
	let 
		val f = find_in_ht (x) 
	in 
		case f of SOME t => SOME x | NONE => checklist (xs)
	end  *)