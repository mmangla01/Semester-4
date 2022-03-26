
open AST
val mem_size = 1000
val Memory = Array.array (mem_size,("",0)) : (string * int) array


fun add_in_mem(variable, value) = let val a =  find_in_list (variable) in case a of SOME (x,y) => Array.update(Memory, y, (variable, value)) | NONE => () end

fun val_in_mem(variable) = let val a = find_in_list(variable) in case a of SOME (x,y) => Array.sub(Memory, y) | NONE => 0 end
