(* Some functions taken from https://www.cse.iitd.ac.in/~sak/courses/ics/sml-programs/fileIO.sml with some suitable changes *)
(* ----------------------------------------------------------------------------------------------------------------------------- *)
fun readFile (filename:string) =
    let fun removeNewLineChar s = 
        let val charlist = List.rev (String.explode s)
            fun nibble [] = []
                | nibble (#"\n"::l) = l
                | nibble l = l
        in  String.implode (List.rev (nibble charlist))
        end
        val f = TextIO.openIn filename
        fun loop (accum: string list) =
            case (TextIO.inputLine f) of 
		        NONE => accum | (line) => loop (removeNewLineChar(Option.valOf(line))::accum)
        val lines =   List.rev(loop [])
    in TextIO.closeIn f; lines
    end
(* ----------------------------------------------------------------------------------------------------------------------------- *)

(* function with input as file name that is to be interpreted *)
fun interpret(filename) = 
let exception DivisionByZero (* declaration of exceptions used in code *)
    exception SyntaxError
    exception NegativeIndexError
    exception IndexOutOfRange
    exception NonBooleanValue
    exception NoHaltStatement

    (* declaration of some constants *)
    val maxMemSize = 64
    val mem = Array.array(maxMemSize,0)

    (* this function coverts the commands as string list to commands as quadruple list *) 
    fun quadFromString [] = []
        | quadFromString (x::xs) = 
            let fun is_char_comma c = (c = #"," orelse c = #"("  ) (* to detect ',' and '(' *)
                val y = ( List.mapPartial Int.fromString (String.tokens is_char_comma x))
            in if (List.length(y)<>4) then raise SyntaxError else 
                (*if the command creted contains integers more or less than 4 then syntax error*)
                (List.nth(y,0),List.nth(y,1),List.nth(y,2),List.nth(y,3))::quadFromString(xs) end 
    val code = Vector.fromList(quadFromString(readFile(filename))) (*creating the code vector*)

    (* function using tail recusion that interprets the code vector from ith index *)
    fun interpret_help(code,i:int):unit = 
    let fun helper(f,g) = let val a = f in  if (g >= Vector.length(code)) then raise NoHaltStatement 
        else interpret_help(code,g) end  (*just a helper function to reduce work*)
        (* the operation functions with suitable errors *)
        fun op0 ():unit = OS.Process.exit(OS.Process.success) (*halting the program*)
        fun op1 k= (*take input from console*)
        let fun removeNewLineChar s = 
                let val charlist = List.rev (String.explode s)
                    fun nibble [] = [] | nibble (#"\n"::l) = l | nibble l = l
                in  String.implode (List.rev (nibble charlist)) end
            val dummy = print("Input: ")
            val inp = removeNewLineChar(Option.valOf (TextIO.inputLine TextIO.stdIn))
        in  if(k<0) then raise NegativeIndexError else Array.update(mem,k,Option.valOf(Int.fromString(inp))) end 
        fun op2 (i,k) = if (k<0 orelse i<0) then raise NegativeIndexError else Array.update(mem,k,Array.sub(mem,i))
        fun op3 (i,k) = if (k<0 orelse i<0) then raise NegativeIndexError else if (Array.sub(mem,i) > 1 orelse Array.sub(mem,i)<0) 
                        then raise NonBooleanValue else if Array.sub(mem,i)=0 then Array.update(mem,k,1) else Array.update(mem,k,0)
        fun op4 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError else if 
                        (Array.sub(mem,i) > 1 orelse Array.sub(mem,i)<0 orelse Array.sub(mem,j) > 1 orelse Array.sub(mem,j)<0) 
                        then raise NonBooleanValue else Array.update(mem,k,Int.max(Array.sub(mem,i),Array.sub(mem,j)))
        fun op5 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else if (Array.sub(mem,i) > 1 orelse Array.sub(mem,i)<0 orelse Array.sub(mem,j) > 1 orelse Array.sub(mem,j)<0) 
                        then raise NonBooleanValue else Array.update(mem,k,Int.min(Array.sub(mem,i),Array.sub(mem,j)))
        fun op6 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError else Array.update(mem,k,(Array.sub(mem,i)+Array.sub(mem,j)))
        fun op7(i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else Array.update(mem,k,(Array.sub(mem,i)-Array.sub(mem,j)))
        fun op8 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else Array.update(mem,k,(Array.sub(mem,i)*Array.sub(mem,j)))
        fun op9 (i,j,k)= if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else if (Array.sub(mem,j)=0) then raise DivisionByZero 
                        else Array.update(mem,k,(Array.sub(mem,i) div Array.sub(mem,j)))
        fun op10 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else if (Array.sub(mem,j)=0) then raise DivisionByZero 
                        else Array.update(mem,k,(Array.sub(mem,i) mod Array.sub(mem,j)))
        fun op11 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else case (Array.sub(mem,i)=Array.sub(mem,j)) of
                        true => Array.update(mem,k,1) | false => Array.update(mem,k,0)
        fun op12 (i,j,k) = if(k<0 orelse i<0 orelse j<0) then raise NegativeIndexError 
                        else case (Array.sub(mem,i)>Array.sub(mem,j)) of
                        true => Array.update(mem,k,1) | false => Array.update(mem,k,0)
        fun op13 (i,c,code,t) = if(i<0 orelse c<0) then raise NegativeIndexError 
                            else if (c>=Vector.length(code)) then raise IndexOutOfRange else if 
                            (Array.sub(mem,i)>1 orelse Array.sub(mem,i)<0) then raise NonBooleanValue else if 
                            (Array.sub(mem,i)=1) then c else if (t+1 = Vector.length(code)) then raise NoHaltStatement else t
        fun op14 (c,code) = if(c<0) then raise NegativeIndexError 
                        else if (c>=Vector.length(code)) then raise IndexOutOfRange else c
        fun op15 i = if(i<0) then raise NegativeIndexError else print(Int.toString(Array.sub(mem,i))^"\n")
        fun op16 (x,k) = if(k<0) then raise NegativeIndexError else Array.update(mem,k,x)
        val (opc,opd1,opd2,tgt) = Vector.sub(code,i);
    in case (opc) of 
        0 => op0() | 1 => (helper ((op1 tgt), (i+1))) | 2 => (helper ((op2 (opd1 ,tgt)), (i+1)))
        | 3 => (helper ((op3 (opd1, tgt)), (i+1))) | 4 => (helper ((op4 (opd1,opd2,tgt)), (i+1)) )
        | 5 => (helper ((op5 (opd1,opd2,tgt)), (i+1)) )| 6 => (helper (op6 ((opd1,opd2,tgt)) ,(i+1)))
        | 7 => (helper ((op7 (opd1,opd2,tgt)), (i+1))) | 8 => (helper ((op8 (opd1,opd2,tgt)), (i+1)))
        | 9 => (helper ((op9 (opd1,opd2,tgt)) ,(i+1))) | 10 => (helper ((op10 (opd1,opd2,tgt)), (i+1)))
        | 11 => (helper ((op11 (opd1,opd2,tgt)), (i+1))) | 12 => (helper ((op12 (opd1,opd2,tgt)), (i+1)))
        | 13 => helper(fn x=>x,(op13(opd1,tgt,code,i+1))) | 14 => helper(fn x=>x,(op14(tgt,code))) 
        | 15 => (helper ((op15 opd1),(i+1))) | 16 => (helper ((op16 (opd1,tgt)),(i+1))) | _ => raise SyntaxError
    end 
in interpret_help(code,0) end ;