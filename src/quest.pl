/*:- include(struktur).*/
/*=================== Replace dengan key ==========================*/
/* ada di file struktur */
/*======================== start_quest ========================= */

start_quest:- game_running(false),fail,!.

start_quest:-
game_running(true),
enter_quest(true),
random(1, 8, Slime),
random(1, 5, Goblin),
random(1, 3, Wolf),
Inventoryresult = [[Slime, Goblin, Wolf]],
retract(quest(_)),
assertz(quest(Inventoryresult)),
retract(have_quest(_)),
assertz(have_quest(1)),
write('You acc the challenge!'),nl,
write('Slime :'), write(Slime), nl,
write('Goblin:'), write(Goblin), nl,
write('Wolf  :'), write(Wolf), nl,!.

start_quest:- 
game_running(true),
enter_quest(false),
write('You have to go to the Quest'),!.

current_quest:-
quest([[Slime, Goblin, Wolf]]),
write('Current Quest: '), nl,
write('Slime :'), write(Slime), nl,
write('Goblin:'), write(Goblin), nl,
write('Wolf  :'), write(Wolf), nl.


prize_quest:-
random(150,800, AddGold),
random(50,100, AddExp),
/*Status*/
statusPlyr(Status),
nth0(Index1, Status, gold),
nth0(Index2, Status, exp),
A is Index1+1,
B is Index2+1,
nth0(A, Status, Gold),
nth0(B, Status, Exp),
Newgold is ( Gold + AddGold ),
Newexp is (Exp + AddExp),
replacebykey(gold, Newgold, Status, Result),
replacebykey(exp, Newexp, Result, FinalResult),
retract(statusPlyr(_)),
assertz(statusPlyr(FinalResult)),
enemy(slime, A),
enemy(goblin, B),
enemy(wolf, C),
searchStatus(A, level, L1),
searchStatus(A, health, H1),
searchStatus(A, attack, At1),
searchStatus(A, defense, D1),
searchStatus(A, getexp, G1),
L1p is L1+1,
H1p is H1 + 50,
At1p is At1 + 10,
D1p is D1 + 20,
G1p is G1 + 50,
updateStatus(A, A1, level, L1p),
updateStatus(A1, A2, health, H1p),
updateStatus(A2, A3, attack, At1p),
updateStatus(A3, A4, defense, D1p),
updateStatus(A4, A5, getexp, G1p),

searchStatus(C, level, L3),
searchStatus(C, health, H3),
searchStatus(C, attack, At3),
searchStatus(C, defense, D3),
searchStatus(C, getexp, G3),
L3p is L3+1,
H3p is H3 + 50,
At3p is At3 + 10,
D3p is D3 + 20,
G3p is G3 + 50,

updateStatus(C, C1, level, L3p),
updateStatus(C1, C2, health, H3p),
updateStatus(C2, C3, attack, At3p),
updateStatus(C3, C4, defense, D3p),
updateStatus(C4, C5, getexp, G3p),

searchStatus(B, level, L2),
searchStatus(B, health, H2),
searchStatus(B, attack, At2),
searchStatus(B, defense, D2),
searchStatus(B, getexp, G2),
L2p is L2+1,
H2p is H2 + 50,
At2p is At2 + 10,
D2p is D2 + 20,
G2p is G2 + 50,
updateStatus(B, B1, level, L2p),
updateStatus(B1, B2, health, H2p),
updateStatus(B2, B3, attack, At2p),
updateStatus(B3, B4, defense, D2p),
updateStatus(B4, B5, getexp, G2p),
retract(enemy(slime, _)),
asserta(enemy(slime, A5)),
retract(enemy(goblin, _)),
asserta(enemy(goblin, B5)),
retract(enemy(wolf, _)),
asserta(enemy(wolf, C5)).


substract(X, Y, Z) :- Z is (X - Y).
substract_lists(L1, L2, R) :- maplist(maplist(substract), L1, L2, R).

remaining_quest(X):-
enemy_quest(List),
nth0(Index, List, X),
( Index == 0, replace_quest(1, 0, 0)
; Index == 1, replace_quest(0, 1, 0)
; Index == 2, replace_quest(0, 0, 1)
; fail).

replace_quest(X,Y,Z):-
quest(Before),
Substractor = [[X,Y,Z]],
substract_lists(Before, Substractor, After),
After = [H|_],
( member(-1, H) -> write('You have finished this task!'), nl
; (After = [[0,0,0]] -> write('Congrats, you finished all of your quests!'), nl, prize_quest, retract(quest(_)), assertz(quest(After)), start_quest
	; retract(quest(_)), assertz(quest(After)))).
