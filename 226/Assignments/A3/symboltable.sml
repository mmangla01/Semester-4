structure SymbolTable=
struct
exception stError of string;
val TableSize = 500;
val HashFactor = 5;
val hash = fn s =>
	List.foldr (fn (c,v) => (v*HashFactor+(ord c)) mod TableSize) 0 (explode s);
val HashTable = Array.array (TableSize,[("","")]) : (string * string) list array;
fun add ([],_) = ()
  | add (head::tail,typ) =
  	let
  		val i = hash head
  		val j = Array.update(HashTable,i,(head,typ)::(Array.sub(HashTable,i)))
  	in
  		add (tail,typ)
  	end
fun find s =
	let
		val i = hash s
		fun findInList ((key,typ)::tail) = if key=s then SOME typ else findInList tail
		  | findInList ([]) = NONE
	in
		findInList(Array.sub(HashTable,i))
	end
end