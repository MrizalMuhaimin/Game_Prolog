/* :- include(struktur). */

/*========================== help =========================== */
help:-
game_running(true),
read_file('../file/help.txt'),!.

/*========================== status player =========================== */
status:- game_running(false),fail,!.

status :- statusPlyr(A), game_running(true),
		write('Your status: '), nl,
		showStatus(A).

showStatus([]).
showStatus([Item, Amount|T]):-
	(Item = level, write('Level   :'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = job, write('Job     :'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = health,write('Health  :'), write(Amount)), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = max,write('/'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = attack,write('Attack  :'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = defense,write('Defense :'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = exp, write('Exp     :'), write(Amount)), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = maxexp, write('/'), write(Amount), nl), !,
    showStatus(T).
showStatus([Item, Amount|T]):-
	(Item = gold, write('Gold    :'), write(Amount), nl), !,
    showStatus(T).


/*============================ level up Archer================ */
level_A('Archer') :- statusPlyr(S),
nth0(Index, S, level),
A is Index+1,
nth0(A, S, Level),
Newlevel is Level+1,
replacebykey(level, Newlevel, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

health_A('Archer') :- statusPlyr(S),
nth0(Index, S, health),
A is Index+1,
nth0(A, S, Health),
Newhealth is Health+55,
replacebykey(health, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxhealth_A('Archer') :- statusPlyr(S),
nth0(Index, S, max),
A is Index+1,
nth0(A, S, Maxhealth),
Newhealth is Maxhealth+55,
replacebykey(max, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

attack_A('Archer') :- statusPlyr(S),
nth0(Index, S, attack),
A is Index+1,
nth0(A, S, Attack),
Newattack is Attack+40,
replacebykey(attack, Newattack, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

defense_A('Archer') :- statusPlyr(S),
nth0(Index, S, defense),
A is Index+1,
nth0(A, S, Defense),
Newdefense is Defense+35,
replacebykey(defense, Newdefense, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxexperience_A('Archer') :- statusPlyr(S),
nth0(Index, S, maxexp),
A is Index+1,
nth0(A, S, Maxexp),
Newexp is Maxexp+300,
replacebykey(maxexp, Newexp, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

/* level up Sorcerer */
level_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, level),
A is Index+1,
nth0(A, S, Level),
Newlevel is Level+1,
replacebykey(level, Newlevel, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

health_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, health),
A is Index+1,
nth0(A, S, Health),
Newhealth is Health+55,
replacebykey(health, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxhealth_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, max),
A is Index+1,
nth0(A, S, Maxhealth),
Newhealth is Maxhealth+55,
replacebykey(max, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

attack_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, attack),
A is Index+1,
nth0(A, S, Attack),
Newattack is Attack+50,
replacebykey(attack, Newattack, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

defense_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, defense),
A is Index+1,
nth0(A, S, Defense),
Newdefense is Defense+35,
replacebykey(defense, Newdefense, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxexperience_S('Sorcerer') :- statusPlyr(S),
nth0(Index, S, maxexp),
A is Index+1,
nth0(A, S, Maxexp),
Newexp is Maxexp+300,
replacebykey(maxexp, Newexp, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.


/* level up Swordsman */
level_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, level),
A is Index+1,
nth0(A, S, Level),
Newlevel is Level+1,
replacebykey(level, Newlevel, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

health_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, health),
A is Index+1,
nth0(A, S, Health),
Newhealth is Health+50,
replacebykey(health, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxhealth_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, max),
A is Index+1,
nth0(A, S, Maxhealth),
Newhealth is Maxhealth+50,
replacebykey(max, Newhealth, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

attack_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, attack),
A is Index+1,
nth0(A, S, Attack),
Newattack is Attack+40,
replacebykey(attack, Newattack, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

defense_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, defense),
A is Index+1,
nth0(A, S, Defense),
Newdefense is Defense+30,
replacebykey(defense, Newdefense, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

maxexperience_Sw('Swordsman') :- statusPlyr(S),
nth0(Index, S, maxexp),
A is Index+1,
nth0(A, S, Maxexp),
Newexp is Maxexp+300,
replacebykey(maxexp, Newexp, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!.

level_up :-
statusPlyr(S),
nth0(Index, S, job),
A is Index+1,
nth0(A, S, Job),
Job == 'Swordsman' -> level_Sw(Job),health_Sw(Job),maxhealth_Sw(Job),attack_Sw(Job),defense_Sw(Job),maxexperience_Sw(Job),!.

level_up :-
statusPlyr(S),
nth0(Index, S, job),
A is Index+1,
nth0(A, S, Job),
Job == 'Archer' -> level_A(Job),health_A(Job),maxhealth_A(Job),attack_A(Job),defense_A(Job),maxexperience_A(Job),!.

level_up :-
statusPlyr(S),
nth0(Index, S, job),
A is Index+1,
nth0(A, S, Job),
Job == 'Sorcerer' -> level_S(Job),health_S(Job),maxhealth_S(Job),attack_S(Job),defense_S(Job),maxexperience_S(Job),!.

not_max_level :- statusPlyr(S),
nth0(Index, S, level),
A is Index+1,
nth0(A, S, Level),
Level < 3.

add_Exp(Val) :- statusPlyr(S),
nth0(Index, S, exp),
A is Index+1,
nth0(A, S, Exp),
New is Exp + Val,
replacebykey(exp, New, S, Result),
retract(statusPlyr(_)),
assertz(statusPlyr(Result)),!,
S = [_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,X,_,_],
((New >= X, 
level_up); !).
