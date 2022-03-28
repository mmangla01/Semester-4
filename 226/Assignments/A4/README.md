# COL226 Assignment 3 
##### Mayank Mangla
##### 2020CS50430
> The submitted zip file contains `while_ast.lex`, `while_ast.yacc`, `while.cm`, `glue.sml`, `compiler.sml`, `run.sml`, `stack.sml`, `symboltable.sml` and `AST.sml` along with this readme file.



> Make the makefile to run the code


### Design Decisions
1. The Declaration Sequence and Command Sequence also produces emtpy production.
2. Some simplification has been done to reduce some terminals and make Datatypes more clear.
3. Grammer has been changed to check for the reduce reduce conflicts
4. Semantics are introduced and required functions are implemented
5. Memory is stored as global array
6. As the C stack and V stack will be empty after the program is executed, I have not printed the stacks. 
7. Memory is returned as a string in the output of the function rules/execute

### Acknowledgement
1. Reference was taken from the http://rogerprice.org/ug/ug.pdf.
2. `cmake`, `compiler` and `glue` has been looked in this pdf.
3. EBNF has been referred from HyperNotes.
4. Would like to Thank Prof S, Arun Kumar and the TAs for the course to prepare the Assignment pdf.
5. Also Thanks to my friends for healthy discussions