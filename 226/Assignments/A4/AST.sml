(* 
signature AST = 
sig 
type AST
val add_in_ht: string list * string -> unit
val find_in_ht: string -> string option
val checklist: string list -> string option
val error: string -> unit
end 
*)

structure AST= 
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
    | ITE of AST * AST list * AST list
    | WH of AST * AST list
    | PROG of string * ((string list * string) list * AST list)
    | IDEN of string
    | BOOL of bool
    | INT of int 
val TableSize = 500;
val HashFactor = 5;
val HashFunction = fn s =>
        List.foldr (fn (c,v) => (v*HashFactor+(ord c)) mod TableSize) 0 (explode s);
val HashTable = Array.array (TableSize,[("","")]) : (string * string) list array;
fun add_in_ht ([],_) = ()
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
	end 
fun error(msg) = 
	let
		val _ = print(msg)
		val _ = print("\n")
	in 
		OS.Process.exit(OS.Process.success)
	end 
end

