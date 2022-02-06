(* tty IO -- simulating Pascal's readln and writeln *)
signature STDIO = 
  sig
    val readln : unit -> string
    val writeln : string -> unit
    val write : string -> unit
  end

structure Stdio : STDIO =

struct
fun chomp1 s =  (* to remove newline character on reading *)
    let val charlist = rev (explode s)
        fun nibble [] = []
          | nibble (#"\n"::l) = l
          | nibble l = l
    in  implode (rev (nibble charlist))
    end

(*
fun readln () =
    (case TextIO.inputLine(TextIO.stdIn) of
	 SOME s => chomp1(s)
       | NONE =>  ""
    )
*)

fun readln () = chomp1 (TextIO.inputLine TextIO.stdIn)

fun writeln (s) = print (s^"\n")

val write = print

end (* struct Stdio *)