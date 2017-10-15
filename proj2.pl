/*This is the code for Project Two for Declarative Programming (COMP300020)
 *The submission is made by STUDENT ID 828472
 *
 *The program aims to solve the given Math Puzzle presented
 *The programs returns the valid solution for the puzzle given the input of its unfinished state
 *The Math puzzle follows these rules:
 *Each Row header must be either the sum or product of all the elements in the row
 *Each Column header must be either the sum or product of all the elements in the column
 *All cells diagonally from the top left to bottom right of the puzzle must be the same
 *Values in each rows or columns have to be unique and between 1-9 inclusive
 */

%-------------------------------------------------------------------------------------------------

%Importation of the library clpfd
:- use_module(library(clpfd)).

%-------------------------------------------------------------------------------------------------
/*check_diagonal function to check if the diagonal values are all valid and the same
 *the function uses pattern matching and the unique function from the ***** library 
 */
 /*
check_diagonal([[_,_,_],[_,X,_],[_,_,X]]).
check_diagonal([[_,_,_,_],[_,Y,_,_],[_,_,Y,_],[_,_,_,Y]).
check_diagonal([[_,_,_,_,_],[_,Z,_,_,_],[_,_,Z,_,_],[_,_,_,Z,_],[_,_,_,_,Z]]).
check_diagonal([[_,_,_,_,_,_],[_,V,_,_,_,_],[_,_,V,_,_,_],[_,_,_,V,_,_],[_,_,_,_,V,_],[_,_,_,_,_,V]]).
*/

%-------------------------------------------------------------------------------------------------
/*sum_list function which takes a list and an Header Value
 *it checks if the sum of all values in the list equates to the value of the Header
 */
%base case
sum_list([], 0).
%recursive case
sum_list([X|Xs], Header):-
	sum_list(Xs, Tail),
	Header is X + Tail.

%-------------------------------------------------------------------------------------------------
/*product_list function which takes a list and a Header Value
 *it checks if the product of all values in the list equates to the value of the Header
 */
%base case
product_list([X], X).
%recursive case --- Xp represent the product sum 
product_list([X1,X2|Xs], Header):-
	Xp is X1*X2,
	product_list([Xp|Xs],Header).
	
%-------------------------------------------------------------------------------------------------
/*in_range function which takes the argument of a list of elements either row/column 
 *it checks if the values in the list are in between the range of 1-9 inclusive
 */
in_range([]).
in_range([X|Xs]):-
	between(1, 9, X),
	in_range(Xs).

%-------------------------------------------------------------------------------------------------
/*
solve_puzzle3([]).
solve_puzzle3([[A1,A2,A3],[B1,B2,B3],[C1,C2,C3]]):-
	check_diagonal([[A1,A2,A3],[B1,B2,B3],[C1,C2,C3]]),
	in_range([B2,B3]),
	in_range([C2,C3]),
	sum_list([B2,B3],B1); num_list([B2,B3],B1),
	sum_list([C2,C3],C1); num_list([C2,C3],C1),
	sum_list([B2,C2],A2); num_list([B2,C2],A2),
	sum_list([B3,C3],A3); num_list([B3,C3],A3).
*/

%-------------------------------------------------------------------------------------------------
/*solve_puzzle function to solve the puzzle as either rows or the transpose (columns)
 *maps the all_different function and the check_rows function onto each row/column
 */
solve_puzzle([]).
solve_puzzle([R|Rs]):-
	%map solve_puzzle and all_different to every row,
	maplist(all_different, Rs),
	maplist(check_rowsN, Rs).


%-------------------------------------------------------------------------------------------------
/*check_rows function which takes all the rows and recursively checks each and every one of them
 *calls the check_rowsN function to check all of them
 */
 /*
check_rows([]).
check_rows([R|Rs]):-
	check_rowsN(R),
	check_rows(Rs).

/*check_rowsN function to check whether each row is valid
 *calls the sum_list, product_list and in-range predicates
 */
check_rowsN([]).
check_rowsN([X|Xs]):-
	in_range(Xs),
	sum_list(Xs, X);
	product_list(Xs, X).


%-------------------------------------------------------------------------------------------------
/*same_elem function to check if all the elements of the list are the same
 *helper function to help check if all the diagonals in a function are the same 
 */
same_elem([]).
%if the last element remaining, it is true regardless of what it is
same_elem([_]).
%Otherwise always check if the first two elements are the same and recurse 
same_elem([X,X|Xs]):-
	same_elem([X|Xs]).

%-------------------------------------------------------------------------------------------------
%Functions to check that the diagonals of the puzzle are the same
/*check_diagonal1 function to make sure the first row is eliminated from the rest of the puzzle
 *gets the length of the puzzle and call the check_diagonal2 function to actually check each row
 *takes the list output of check_diagonal2 and validates all the elements using same_elem
 */
check_diagonal1([]).
check_diagonal1([R|Rs]):-
	%Finding the length of the solvable part of the puzzle
	length(R, L),
	Len is 	L - 1,
	%Check if all the diagonals are the same
	check_diagonal2(Rs,1,Len,Dlist),
	same_elem(Dlist).


/*check_diagonal2 function to check if all the diagonal elements are the same
 *iterates through the rows recursively to handle puzzles of any size
 *outputs a the diagonals of the puzzle as a list
 */
check_diagonal2([], _, _, _).
check_diagonal2([R|Rs], Iter, Len, Diag):-
	nth0(Iter,R,Elem),
	append([Elem], Diag, Diag1),
	Iter1 is Iter + 1,
	check_diagonal2(Rs, Iter1, Len, Diag1).

%-------------------------------------------------------------------------------------------------
/*puzzle_solution function that would be given the input of the puzzle as a list of lists
 *this function checks the validity of the puzzle with each condition
 *once all the conditions are satisfied the puzzle_solution would return the valid answer for the puzzle
 */
puzzle_solution([]).
puzzle_solution(Rows):-
	%check that the puzzle is a square
	%maplist(same_lengths(Rows), Rows),
	check_diagonal1(Rows),
	solve_puzzle(Rows),
	%Tranpose the puzzle matrix so that the columns becomes the rows
	transpose(Rows, Columns),
	%map solve_puzzle and all_different to every column
	solve_puzzle(Columns).


