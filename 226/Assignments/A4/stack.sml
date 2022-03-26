signature STACK = 
sig 
	type 'a Stack
	exception EmptyStack
	exception Error of string
	val create: 'a Stack
	val push : 'a * 'a Stack -> 'a Stack
	val pop : 'a Stack -> 'a Stack
	val top : 'a Stack -> 'a
	val empty: 'a Stack -> bool
	val poptop : 'a Stack -> ('a * 'a Stack) option
	val nth : 'a Stack * int -> 'a
	val drop : 'a Stack * int -> 'a Stack
	val depth : 'a Stack -> int
	val app : ('a -> unit) -> 'a Stack -> unit
	val map : ('a -> 'b) -> 'a Stack -> 'b Stack
	(* val mapPartial : ('a -> 'b option) -> 'a Stack -> 'b Stack *)
	val find : ('a -> bool) -> 'a Stack -> 'a option
	val filter : ('a -> bool) -> 'a Stack -> 'a Stack
	val foldr : ('a * 'b -> 'b) -> 'b -> 'a Stack -> 'b
	val foldl : ('a * 'b -> 'b) -> 'b -> 'a Stack -> 'b
	val exists : ('a -> bool) -> 'a Stack -> bool
	val all : ('a -> bool) -> 'a Stack -> bool
	val list2stack : 'a list -> 'a Stack 
	val stack2list: 'a Stack -> 'a list 
	val toString: ('a -> string) -> 'a Stack -> string
end
structure FunStack: STACK = 

struct
	type 'a Stack = 'a list
	exception EmptyStack
	exception Error of string
	fun push (elem, stk) = (elem::stk)
	val create: 'a Stack = []
	fun pop ([]) = raise EmptyStack
		| pop(elem::stk) = stk
	fun top ([]) = raise EmptyStack
		| top(elem::stk) = elem
	fun empty ([]) = true 
		| empty (_) = false
	fun poptop ([]) = NONE
		| poptop (elem::stk) = SOME (elem, stk)
	fun nth ([], _) = raise EmptyStack
		| nth(elem::stk, n) = if(n=0) then elem else nth(stk, n-1)
	fun drop ([], _) = raise EmptyStack
		| drop (elem::stk, n) = if(n=0) then stk else let val stk2 = drop(stk, n-1) in elem::stk2 end
	fun depth ([]) = 0
		| depth(elem::stk) = let val x = depth(stk) in x + 1 end
	fun app _ [] = ()
		| app function (elem::stk) = let val x = function(elem) in app function stk end
	fun map _ [] = []
		| map function (elem::stk) = let val stk2 = map function stk val x = function(elem) in x::stk2 end
	fun mapPartial _ [] = []
		| mapPartial function (elem::stk) = let val stk2 = mapPartial function stk val x = function(elem) in case x of SOME a => push(a,stk2) | NONE => stk2 end 
	fun find _ [] = NONE
		| find function (elem::stk) = if (function(elem)) then SOME elem else (find function stk)
	fun filter _ [] = []
		| filter function (elem::stk) = let val stk2 = filter function stk in if (function(elem)) then elem::stk2 else stk2 end
	fun foldl _ b [] = b
		| foldl function b (elem::stk) = let val b2 = function(elem, b) in foldr function b2 stk end 
	fun foldr _ b [] = b
		| foldr function b [elem] = function(elem, b)
		| foldr function b (elem::stk) = let val b2 = foldr function b stk in function(elem, b2) end 
	fun exists _ [] = false
		| exists function (elem::stk) = if (function(elem)) then true else exists function stk 
	fun all _ [] = true 
		| all function (elem::stk) = if(function(elem)) then all function stk else false
	fun list2stack (l) = l
	fun stack2list (s) = s
	fun toString _ [] = ""
		| toString function (elem::stk) = let val str1 = function(elem) val str2 = toString function stk in str1 ^ str2 end
end
