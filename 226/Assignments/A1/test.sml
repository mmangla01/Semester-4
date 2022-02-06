(* Solving the N queens problem by backtracking on exceptions *)

(* Assume the columns are numbered 0..N-1,
** Each queen can take a position r (0 <= r < N) on a column c (0 <= c < N)
** positions gives the values of rows for each column starting from 0

** INVARIANT: N = length of positions + length of subintervals &
**            subinterval is the list of columns where no queen has been placed
**            x is the next column which needs to be tried
*)

(* use "showList.sml";*) (* Require this for displaying solutions *) 

fun interval (a, b) = if a > b then [] else a::(interval (a+1, b));

fun safe ((x, y), (x0, y0)::poslist) = 
         (* Not on the same column     *) (x <> x0) andalso 
         (* Not on the same row        *) (y <> y0) andalso
         (* Not on the same / diagonal *) (y-x <> y0-x0) andalso
         (* Not on the same \ diagonal *) (y+x <> y0+x0) andalso
         (* (x,y) is safe with respect to the positions in poslist *) 
                                          safe ((x,y), poslist)
  | safe _                           = true
exception Conflict;

fun solveQueens (N, positions, x, subinterval) = 
    let val i2s = Int.toString
	fun pi2s (x, y) = "("^(i2s x)^", "^(i2s y)^")" (* pairs of int *)
	local fun lpi2s' [] = ""
		| lpi2s' (h::t) = if (null t) then (pi2s h)
				  else (pi2s h)^", "^(lpi2s' t)
	in  fun lpi2s L = "["^(lpi2s' L)^"]"
	end

	fun showState positions = print ((lpi2s positions)^"\n")
    in  if x = N then positions
        else case subinterval of
	     []    => (* if there is no safe positions available for a certain
		       * then column then raise exception Conflict 
                       *)
	         (  print ("Cannot place Queen "^i2s(x)^":\t");
		    showState positions;
		    raise Conflict
	         )
	     | y::ys => 
	       if safe ((x, y), positions)
	       then (* add (x, y) to positions and go on to the next column *)
		    (
		      print ("Queen "^(i2s x)^" safe in column "^(i2s y)^"\n"); 
                      solveQueens (N, positions@[(x, y)], x+1, interval (0, N-1))
		    )
		    (* in case of conflict, backtrack to the previous column
                     * and find a fresh safe position and continue forward
                     * again.
		     *)
(*		    handle Conflict => solveQueens (N, positions, x, ys) 
*)
		    handle Conflict => 
			   if (null ys) andalso x = 0
			   then ( print ("Mission Impossible\n");[])
			   else solveQueens (N, positions, x, ys)

	      else  (* throw away y and try hd (ys) if it exists *)
		    solveQueens (N, positions, x, ys)
    end;

exception Impossible;

fun queens (N) = if N <= 0 then raise Impossible
		 else solveQueens (N, [], 0, interval (0, N-1));


fun totuple [x,y,z,v] = 
        (if(x>=0 orelse y>=0 orelse z>=0 orelse v>=0) then (x,y,z,v)   
        else raise SyntaxError)
    | totuple (_) = raise SyntaxError;

fun parsestring [] = [(0,0,0,0)]
 |parsestring (x::xs) = 
    let
      val s = totuple(List.mapPartial Int.fromString (String.tokens (fn c => c = #"," orelse c= #"(") x));
    in
      s::parsestring(xs)
end;