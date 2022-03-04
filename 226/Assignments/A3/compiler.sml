
structure While :
sig val compile : string -> AST.prog
end =
struct
exception WhileError;
fun compile (fileName) =
    let val inStream =  TextIO.openIn fileName;
        val grab : int -> string = fn
            n => if TextIO.endOfStream inStream
                then ""
                else TextIO.inputN (inStream,n);
        val printError : string * int * int -> unit = fn
            (msg,line_no,char_no) =>
            print (fileName^"["^Int.toString line_no^":"
                    ^Int.toString char_no^"] "^msg^"\n");
        val (tree,rem) = WhileParser.parse
         (15,
         (WhileParser.makeLexer grab fileName),
         printError,
         fileName)
    handle WhileParser.ParseError => raise WhileError;
val _ = TextIO.closeIn inStream;

in tree
end; 
end
