/*=========================== Status Player ============================*/
:- dynamic(statusPlyr/1).
statusPlyr([
    level, 1,
    job, 'Peasant',
    health, 50,
    max, 0,
    attack, 0, 
    defense, 0,
    exp, 0,
    maxexp, 0,
    gold, 0
]).

/*=========================== Inventory Player ==========================*/
:- dynamic(inventoryPlyr/1).
inventoryPlyr([ 
    woodensword, 1,
    woodenbow, 1,
    magicbook, 0,
    healthpotion, 24 
]).

/*============================ Sisa Quest =================================*/

:- dynamic(quest/1).	quest([[0, 0, 0]]).
:- dynamic(have_quest/1).	have_quest(0).
enemy_quest([slime,goblin,wolf]).

/* =========================fact posisi dalam peta=========================*/
/*player */
:- dynamic(posisi/3).   posisi(p,2,3). 

/*==========================shop============================================ */
posisi(s,2,2).


/*=========================quest ===========================================*/
posisi(q,7,3). 

/*==================================Dragon================================ */
posisi(d,14,17).

/*================================== pagar Tengah ==========================*/
posisi(pagar,8,6).
posisi(pagar,8,7).
posisi(pagar,9,7).
posisi(pagar,10,7).
posisi(pagar,11,7).
posisi(pagar,8,8).
posisi(pagar,12,11).
posisi(pagar,13,11).
posisi(pagar,14,11).
posisi(pagar,12,12).
posisi(pagar,7,14).
posisi(pagar,4,15).
posisi(pagar,5,15).
posisi(pagar,6,15).
posisi(pagar,7,15).

:- dynamic(enter_shop/1). enter_shop(false).
:- dynamic(enter_quest/1). enter_quest(false).
:- dynamic(game_running/1). game_running(false).
:- dynamic(game_opening/1). game_opening(false).
:- dynamic(in_shop/1). in_shop(false).




/*=================== Replace dengan key ==========================*/
pop(X,Result):- X=[_|T], Result=(T).
lenlist([],_,0).
lenlist(List, C, Result):-
    pop(List,Tail),
    N is (C+1),
    lenlist(Tail,N,Result1),
    Result is (Result1+1).

replace([_|T], 0, X, [X|T]).
replace([H|T], Index, X, [H|Result]):- Index >= 0, NewIndex is Index-1, replace(T, NewIndex, X, Result), !.
replace(L, _, _, L).

replacebykey(Key, Element, List, Result):-
nth0(Index,List,Key),
A is Index+1, 
replace(List, A, Element, Result).

/* ======================== ReadFile ======================== */


read_file(File) :-
    open(File, read, Stream),
    get_char(Stream, Chr1),
    proces_the_stream(Chr1, Stream),!.

proces_the_stream(end_of_file, _) :- !.

proces_the_stream(Chr,Stream) :-
    write(Chr),
    get_char(Stream,Chr2),
    proces_the_stream(Chr2, Stream).


   
/*============== Search Status Enemy or Player ======================*/
searchStatus([A, B|_], A, B) :- !.  /* Just One Time */
searchStatus([_, _|T], X, N) :-
    searchStatus(T, X, N).

/*==================== Update Status Player============================ */
updateStatus([A, B|T], [A, B|X], Status, Value) :-
    A \= Status, !,
    updateStatus(T, X, Status, Value).

updateStatus([A, _|T], [A, Value|X], Status, Value) :-
    A = Status,
    copyList(T, X).

/*======================== Copy List================== */
copyList([], []).
copyList([H|T], [H|X]) :-
    copyList(T, X).

