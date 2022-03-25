signature STACK = 
sig 
	type 'a Stack
	exception EmptyStack
	exception Error of string
	val create: -> 'a Stack
	val push : 'a * 'a Stack -> 'a Stack
	val pop : 'a Stack -> 'a Stack
	val top : 'a Stack -> 'a
	val empty: 'a Stack -> bool
	val poptop : 'a stack -> ('a * 'a stack) option
	val nth : 'a stack * int -> 'a
	val drop : 'a stack * int -> 'a stack
	val depth : 'a stack -> int
	val app : ('a -> unit) -> 'a stack -> unit
	val map : ('a -> 'b) -> 'a stack -> 'b stack
	val mapPartial : ('a -> 'b option) -> 'a stack -> 'b stack
	val find : ('a -> bool) -> 'a stack -> 'a option
	val filter : ('a -> bool) -> 'a stack -> 'a stack
	val foldr : ('a * 'b -> 'b) -> 'b -> 'a stack -> 'b
	val foldl : ('a * 'b -> 'b) -> 'b -> 'a stack -> 'b
	val exists : ('a -> bool) -> 'a stack -> bool
	val all : ('a -> bool) -> 'a stack -> bool
	val list2stack : 'a list -> 'a stack  (* Convert a list into a stack *)
	val stack2list: 'a stack -> 'a list (* Convert a stack into a list *)
	val toString: ('a -> string) -> 'a stack -> string
end
structure FunStack: STACK = 

struct
	type 'a Stack = 'a list
	exception EmptyStack
	exception Error of string
	fun push (elem, stk) = (elem::stk)
	val create: 'a stack = []
	fun pop ([]:Stack) = raise EmptyStack
		| pop(elem::stk) = stk
	fun top ([]:Stack) = raise EmptyStack
		| top(elem::stk) = elem
	fun empty ([]:Stack) = true 
		| empty (_) = false
	fun poptop ([]:Stack) = NONE
		| poptop (elem::stk) = SOME (elem, stk)
	fun nth ([]:Stack, _) = raise EmptyStack
		| nth(elem::stk, n) = if(n=0) then elem else nth(stk, n-1)
	fun drop ([]:Stack, _) = raise EmptyStack
		| drop (elem::stk, n) = if(n=0) then stk else let val stk2 = drop(stk, n-1) in elem::stk2 end
	fun depth ([]:Stack) = 0
		| depth(elem::stk) = let val x = depth(stk) in x + 1 end
	fun app _ []:Stack = ()
		| app function (elem::stk) = let val x = function(elem) in app function stk end
	fun map _ []:Stack = []:Stack
		| map function (elem::stk) = let val stk2 = map function stk val x = function(elem) in x::stk2 end
	fun mapPartial _ []:Stack = []:Stack
		| mapPartial function (elem::stk) = let val stk2 = mapPartial function stk val x = function(elem) in case x of SOME a => a::stk2 | NONE => null::stk2 end 
	fun find _ []:Stack = NONE
		| find function (elem::stk) = if (function(elem)) then SOME elem else (find function stk)
	fun filter _ []:Stack = []
		| filter function (elem::stk) = let val stk2 = filter function stk in if (function(elem)) then elem::stk2 else stk2 end
	fun foldl _ b []:Stack = b
		| foldl function b (elem::stk) = let val b2 = function(elem, b) in foldr function b2 stk end 
	fun foldr _ b []:Stack = b
		| foldr function b [elem] = function(elem, b)
		| foldr function b (elem::stk) = let val b2 = function b stk in function(elem, b2) end 
	fun exists _ []:Stack = false
		| exists function (elem::stk) = if (function(elem)) then true else exists function stk 
	fun all _ []:Stack = true 
		| all function (elem::stk) = if(function(elem)) then all function stk else false
	fun list2stack (l:list):Stack = l
	fun stack2list (s:Stack):list = s
	fun toString _ [] = ""
		| toString function (elem::stk) = let val str1 = function(elem) val str2 = toString function stk in str1 ^ str2 end
end

(*
	val list2stack : 'a list -> 'a stack  (* Convert a list into a stack *)
	val stack2list: 'a stack -> 'a list (* Convert a stack into a list *)
	val toString: ('a -> string) -> 'a stack -> string 
	
	
	*)