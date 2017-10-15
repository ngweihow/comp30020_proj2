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
/*add_list function which takes a list and an Header Value
 *it checks if the sum of all values in the list equates to the value of the Header
 */
%base case
add_list([], 0).
%recursive case
add_list([X|Xs], Header):-
	add_list(Xs, Tail),
	Header #= X + Tail.
%-------------------------------------------------------------------------------------------------
/*product_list function which takes a list and a Header Value
 *it checks if the product of all values in the list equates to the value of the Header
 */
%base case
product_list([],1).
%recursive case --- Xp represent the product sum 
product_list([X|Xs], Header):-
	product_list(Xs,Product),
	Header #= Product*X.
	
%-------------------------------------------------------------------------------------------------
/*Distinct number check and range 1-9 inclusive check functions
 *-----------------------------------------------------------------
 */

%range_check predicate to remove the first row of headers which need not be checked
range_check([_|Ws]):-
	maplist(in_range0,Ws).
%in_range0 predicate to remove the first element header which need not be checked 
in_range0([_|Ys]):- 
	in_range(Ys).
/*in_range function which takes the argument of a list of elements either row/column 
 *it checks if the values in the list are in between the range of 1-9 inclusive
 */
in_range([]).
in_range(Row):-
	all_distinct(Row),
	Row ins 1..9.

%-------------------------------------------------------------------------------------------------
/*solve_puzzle function to solve the puzzle as either rows or the transpose (columns)
 *maps the all_different function and the check_rows function onto each row/column, skipping the header
 */
solve_puzzle([_|Rs]):-
	maplist(check_rowsN, Rs).

%-------------------------------------------------------------------------------------------------
/*check_rowsN function to check whether each row is valid
 *calls the sum_list, product_list and in-range predicates
 */
%check_rowsN([]).
check_rowsN([X|Xs]):-
	add_list(Xs, X);
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
/*Same Diagonal checking functions
 *---------------------------------
 */

/*check_diagonal1 function to make sure the first row is eliminated from the rest of the puzzle
 *gets the length of the puzzle and call the check_diagonal2 function to actually check each row
 *takes the list output of check_diagonal2 and validates all the elements using same_elem
 */
check_diagonal1([]).
check_diagonal1([_|Rs]):-
	%Check if all the diagonals are the same and pass in the iterator of 1 to skip first element
	check_diagonal2(Rs,1,[]).


/*check_diagonal2 function to check if all the diagonal elements are the same
 *iterates through the rows recursively to handle puzzles of any size
 *outputs a the diagonals of the puzzle as a list
 */
check_diagonal2([], _, _).
check_diagonal2([R|Rs], Iter, Diag):-
	%get the element at the index of the iterator
	nth0(Iter,R,Elem),
	%add the element into the diag list to be checked later
	append([Elem], Diag, Diag1),
	Iter1 #= Iter + 1,
	%recursively call itself till the diag list is fully constructed and then check if its the same
	check_diagonal2(Rs, Iter1, Diag1),
	same_elem(Diag1).

%-------------------------------------------------------------------------------------------------
%			Puzzle Solution
%------------------------------------------------
/*puzzle_solution function that would be given the input of the puzzle as a list of lists
 *this function checks the validity of the puzzle with each condition
 *once all the conditions are satisfied the puzzle_solution would return the valid answer for the puzzle
 */
puzzle_solution(Rows):-
	%check for the diagonals 
	check_diagonal1(Rows),

	%check and solve for the restraints for rows
	range_check(Rows),
	solve_puzzle(Rows),

	%Tranpose the puzzle matrix so that the columns becomes the rows
	transpose(Rows, Columns),

	%check and solve for the restraints for columns
	range_check(Columns),
	solve_puzzle(Columns),

	%use contrivance label to flatten the array
	append(Rows,Solution),
	label(Solution). 