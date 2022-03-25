
structure Tokens= Tokens
  
    type pos = int
    type svalue = Tokens.svalue
    type ('a,'b) token = ('a,'b) Tokens.token  
    type lexresult = (svalue, pos) token
    type lexarg = string
    type arg = lexarg

    val line_no = ref 1
    val char_no = ref 1
    val eof = fn fileName => Tokens.EOF(!line_no, !line_no)
 	val error = fn (token, char_no:int, line:int) => TextIO.output (TextIO.stdOut,"Unknown Token:" ^ (Int.toString line) ^ ":"^ (Int.toString char_no) ^ ":" ^ token ^ ", ")
  
%%
%full
%header (functor WhileLexFun(structure Tokens:While_TOKENS));
%arg (fileName:string);
character=[A-Za-z];
digit=[0-9];
chardigit = [0-9a-zA-Z];
white_space = [\ \t\r];

%%

\n      => (line_no := (!line_no) + 1; char_no := 1; continue());
{white_space} => (char_no := (!char_no) + 1; continue());
":"     => (char_no:=(!char_no)+1;Tokens.COLS(!line_no, !line_no));
"program"=> (char_no:=(!char_no)+7;Tokens.PROG(!line_no, !line_no));
"::"    => (char_no:=(!char_no)+2;Tokens.BLOCK(!line_no, !line_no));
"var"   => (char_no:=(!char_no)+3;Tokens.VARI(!line_no, !line_no));
"int"   => (char_no:=(!char_no)+3;Tokens.INT(!line_no, !line_no));
"bool"  => (char_no:=(!char_no)+4;Tokens.BOOL(!line_no, !line_no));
"{"     => (char_no:=(!char_no)+1;Tokens.LEFTBRACE(!line_no, !line_no));
"}"     => (char_no:=(!char_no)+1;Tokens.RIGHTBRACE(!line_no, !line_no));
","     => (char_no:=(!char_no)+1;Tokens.COMMA(!line_no, !line_no));
";"     => (char_no:=(!char_no)+1;Tokens.SEMIC(!line_no, !line_no));
":="    => (char_no:=(!char_no)+2;Tokens.ASSIGN(!line_no, !line_no));
"read"  => (char_no:=(!char_no)+4;Tokens.READ(!line_no, !line_no));
"write" => (char_no:=(!char_no)+5;Tokens.WRITE(!line_no, !line_no));
"if"    => (char_no:=(!char_no)+2;Tokens.IF(!line_no, !line_no));
"then"  => (char_no:=(!char_no)+4;Tokens.THEN(!line_no, !line_no));
"else"  => (char_no:=(!char_no)+4;Tokens.ELSE(!line_no, !line_no));
"endif" => (char_no:=(!char_no)+5;Tokens.ENDIF(!line_no, !line_no));
"while" => (char_no:=(!char_no)+5;Tokens.WH(!line_no, !line_no));
"do"    => (char_no:=(!char_no)+2;Tokens.DO(!line_no, !line_no));
"endwh" => (char_no:=(!char_no)+5;Tokens.EWH(!line_no, !line_no));
")"     => (char_no:=(!char_no)+1;Tokens.RIGHTPAREN(!line_no, !line_no));
"("     => (char_no:=(!char_no)+1;Tokens.LEFTPAREN(!line_no, !line_no));
"~"     => (char_no:=(!char_no)+1;Tokens.NEG(!line_no, !line_no));
"||"    => (char_no:=(!char_no)+2;Tokens.OR(!line_no, !line_no));
"&&"    => (char_no:=(!char_no)+2;Tokens.AND(!line_no, !line_no));
"tt"    => (char_no:=(!char_no)+2;Tokens.TT(!line_no, !line_no));
"ff"    => (char_no:=(!char_no)+2;Tokens.FF(!line_no, !line_no));
"!"     => (char_no:=(!char_no)+1;Tokens.NOT(!line_no, !line_no));
"<"     => (char_no:=(!char_no)+1;Tokens.LT(!line_no, !line_no));
">"     => (char_no:=(!char_no)+1;Tokens.GT(!line_no, !line_no));
"<="    => (char_no:=(!char_no)+2;Tokens.LEQ(!line_no, !line_no));
"="     => (char_no:=(!char_no)+1;Tokens.EQ(!line_no, !line_no));
">="    => (char_no:=(!char_no)+2;Tokens.GEQ(!line_no, !line_no));
"<>"    => (char_no:=(!char_no)+2;Tokens.NEQ(!line_no, !line_no));
"+"     => (char_no:=(!char_no)+1;Tokens.PLUS(!line_no, !line_no));
"-"     => (char_no:=(!char_no)+1;Tokens.MINUS(!line_no, !line_no));
"*"     => (char_no:=(!char_no)+1;Tokens.TIMES(!line_no, !line_no));
"/"     => (char_no:=(!char_no)+1;Tokens.DIV(!line_no, !line_no));
"%"     => (char_no:=(!char_no)+1;Tokens.MOD(!line_no, !line_no));
{character}{chardigit}* => (char_no := (!char_no) + String.size(yytext) ; Tokens.VAR(yytext, !line_no,!line_no));
{digit}+ => (char_no := (!char_no) + String.size(yytext) ; Tokens.NUM(List.foldl (fn (a,r) => ord(a) - ord(#"0") + 10*r) 0 (explode yytext), !line_no, !line_no));










