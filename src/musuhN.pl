/*:- include(struktur).*/
:- dynamic(enemy/2).

/* Status Enemy */
enemy(slime, [
    level, 1, 
    health, 100,
    attack, 56,
    defense, 20,
    getexp, 30
]).

enemy(goblin, [
    level, 1, 
    health, 100,
    attack, 60,
    defense, 30,
    getexp, 35
]).

enemy(wolf, [
    level, 1, 
    health, 100,
    attack, 70,
    defense, 40,
    getexp, 50
]).

enemy(boss, [
    level, 1,
    health, 10000,
    attack, 2500,
    defense, 2000,
    getexp, 999999999999999999
]).

/* Mode Bertarung */
:- dynamic(isModeBertarung/1).
isModeBertarung(0).
/* List All Enemies Meet Player in Mode Bertarung */
:- dynamic(meetEnemies/1).
meetEnemies([]).
/* List turn Musuh setelah melakukan specialAttack */
:- dynamic(turnEnemies/1).
turnEnemies([]).
/* Turn Player setelah specialAttack */
:- dynamic(turnPlayer/1).
turnPlayer(4).

enemyList([slime, goblin, wolf]).

/*============================= Fight Boss ===========================*/
fightBoss :-
    posisi(p, PX, PY),
    posisi(d, BX, BY),
    (CX is PX - BX,
    CY is PY - BY,
    ((CX is 1), !; (CX is -1)),
    ((CY is 1), !; (CY is -1)),
    meetBoss(boss)), !.

fightBoss :- !.

meetBoss(Enemy) :-
    enemy(X, Y),
    X = Enemy, !,
    write('You fight the Boss'),
    write(X), nl,
    meetEnemies(StatusEnemies),
    concatList(StatusEnemies, [X, Y], StatusEnemiesConcat),
    retractall(meetEnemies(_)),
    assertz(meetEnemies(StatusEnemiesConcat)),
    showEnemy(Y),
    retractall(isModeBertarung(_)),
    assertz(isModeBertarung(1)).

/*=================================== Meet Enemy============================= */
meet(Enemy) :-
    enemy(X, Y),
    X = Enemy, !,
    write('You found a '),
    write(X), nl,
    meetEnemies(StatusEnemies),
    concatList(StatusEnemies, [X, Y], StatusEnemiesConcat),
    retractall(meetEnemies(_)),
    assertz(meetEnemies(StatusEnemiesConcat)),
    showEnemy(Y),
    retractall(isModeBertarung(_)),
    assertz(isModeBertarung(1)).

meetEnemies :-
    random(1, 10, NR),
    isMeet(NR).
    
isMeet(NR) :-
    NR is 1,
    random(1, 4, NEnemies), /* NEnemies = banyaknya musuh */
    setMeetEnemies(NEnemies),
    meetEnemies(StatusEnemies),
    setTurnEnemies(StatusEnemies, ListTurnEnemies),
    retractall(turnEnemies(_)),
    asserta(turnEnemies(ListTurnEnemies)), 
    retractall(turnPlayer(_)),
    asserta(turnPlayer(4)), 
    write('What will you do?'), nl,
    !.

isMeet(NR) :- NR \= 1.

setMeetEnemies(0).
setMeetEnemies(NEnemies) :-
    NEnemiesNew is NEnemies-1,
    random(0, 3, N),
    enemyList(LE),
    chooseMeetEnemy(LE, N, Enemy),
    meet(Enemy),
    setMeetEnemies(NEnemiesNew).

chooseMeetEnemy([], _, _).
chooseMeetEnemy([H|T], 0, H) :- !,
    chooseMeetEnemy(T, 0, H).
chooseMeetEnemy([_|T], N, Enemy) :- 
    NNew is N-1,
    chooseMeetEnemy(T, NNew, Enemy).

/*======================= Showing Enemy ============================ */
showEnemy([]).
showEnemy([A, B|T]) :-
    A = level, write('Level: '), write(B), nl, !,
    showEnemy(T).
showEnemy([A, B|T]) :-
    A = health, write('Health: '), write(B), nl, !,
    showEnemy(T).
showEnemy([A, B|T]) :-
    A = attack, write('Attack: '), write(B), nl, !,
    showEnemy(T).
showEnemy([A, B|T]) :-
    A = defense, write('Defense: '), write(B), nl, !,
    showEnemy(T).
showEnemy([A, _|T]) :-
    A \= level, A \= health, A \= attack, A \= defense,
    showEnemy(T).

/*====================== Attack ==============================*/
attack :- 
    isModeBertarung(1),
    statusPlyr(StatusPlayer1),
    /* Attack For Not Sorcerer */
    searchStatus(StatusPlayer1, job, Job),
    Job = 'Sorcerer',
    /* Set Turn Player */
    turnPlayer(TurnP),
    setTurnPlayer(TurnP, TurnPNew),
    showTurnPlayer(TurnP),
    retractall(turnPlayer(_)),
    asserta(turnPlayer(TurnPNew)),
    /* Searching for Health and Defense Enemies */
    meetEnemies(StatusEnemies1),
    searchStatus(StatusPlayer1, attack, NAttackP),
    searchStatusEnemies(StatusEnemies1, health, HealthListEnemies),
    searchStatusEnemies(StatusEnemies1, defense, DefenseListEnemies),
    /* Attack to Enemies Defense */
    healthList(DefenseListEnemies, DefenseListEnemies2, -NAttackP),
    /* Mencari Musuh yang Berdarah */
    searchNegativeList(DefenseListEnemies2, ReduceHealthEnemies),
    add2List(HealthListEnemies, ReduceHealthEnemies, HealthListEnemies2),
    updateEnemies(StatusEnemies1, StatusEnemies2, health, HealthListEnemies2),
    /* Enemies Attack */
    enemiesAttackPlayer(StatusEnemies2), !.

attack :-
    isModeBertarung(1),
    statusPlyr(StatusPlayer1),
    /* Attack For Not Sorcerer */
    searchStatus(StatusPlayer1, job, Job),
    Job \= 'Sorcerer',
    /* Set Turn Player */
    turnPlayer(TurnP),
    setTurnPlayer(TurnP, TurnPNew),
    showTurnPlayer(TurnP),
    retractall(turnPlayer(_)),
    asserta(turnPlayer(TurnPNew)),
    /* Searching for Health and Defense Enemies */
    meetEnemies(StatusEnemies1), 
    searchStatus(StatusPlayer1, attack, NAttackP),
    searchStatusEnemies(StatusEnemies1, health, HealthListEnemies),
    HealthListEnemies = [HealthEnemy|THealthEnemies],
    searchStatusEnemies(StatusEnemies1, defense, DefenseListEnemies),
    DefenseListEnemies = [DefenseEnemy|_],
    /* Attack to Enemies Defense */
    healthList([DefenseEnemy], DefenseEnemy2, -NAttackP),
    /* Mencari Musuh yang Berdarah */
    searchNegativeList(DefenseEnemy2, ReduceHealthEnemies),
    add2List([HealthEnemy], ReduceHealthEnemies, HealthEnemy2),
    concatList(HealthEnemy2, THealthEnemies, HealthListEnemies2),
    updateEnemies(StatusEnemies1, StatusEnemies2, health, HealthListEnemies2),
    /* Enemies Attack */
    enemiesAttackPlayer(StatusEnemies2), !.
    
specialAttack :- 
    isModeBertarung(1),
    statusPlyr(StatusPlayer1),
    /* Attack For Sorcerer */
    searchStatus(StatusPlayer1, job, Job),
    Job = 'Sorcerer',
    /* Set Turn Player */
    turnPlayer(TurnP),
    TurnP is 1,
    TurnPNew is 4,
    retractall(turnPlayer(_)),
    asserta(turnPlayer(TurnPNew)),
    /* Set Attack to Special Attack */
    searchStatus(StatusPlayer1, attack, NAttackP),
    NSpecialAttackP is NAttackP*2,
    /* Searching for Health and Defense Enemies */
    meetEnemies(StatusEnemies1),
    searchStatusEnemies(StatusEnemies1, health, HealthListEnemies),
    searchStatusEnemies(StatusEnemies1, defense, DefenseListEnemies),
    /* Attack to Enemies Defense */
    healthList(DefenseListEnemies, DefenseListEnemies2, -NSpecialAttackP),
    /* Mencari Musuh yang Berdarah */
    searchNegativeList(DefenseListEnemies2, ReduceHealthEnemies),
    add2List(HealthListEnemies, ReduceHealthEnemies, HealthListEnemies2),
    updateEnemies(StatusEnemies1, StatusEnemies2, health, HealthListEnemies2),
    /* Enemies Attack */
    enemiesAttackPlayer(StatusEnemies2), !.


specialAttack :-
    isModeBertarung(1),
    statusPlyr(StatusPlayer1),
    searchStatus(StatusPlayer1, job, Job),
    /* Attack For Not Sorcerer */
    Job \= 'Sorcerer',
    searchStatus(StatusPlayer1, attack, NAttackP),
    /* Set Turn Player */
    turnPlayer(TurnP),
    TurnP is 1,
    TurnPNew is 4,
    retractall(turnPlayer(_)),
    asserta(turnPlayer(TurnPNew)),
    /* Set Attack to Special Attack */
    NSpecialAttackP is NAttackP*2,
    /* Searching for Health and Defense Enemies */
    meetEnemies(StatusEnemies1), 
    searchStatusEnemies(StatusEnemies1, health, HealthListEnemies),
    HealthListEnemies = [HealthEnemy|THealthEnemies],
    searchStatusEnemies(StatusEnemies1, defense, DefenseListEnemies),
    DefenseListEnemies = [DefenseEnemy|_],
    /* Attack to Enemies Defense */
    healthList([DefenseEnemy], DefenseEnemy2, -NSpecialAttackP),
    /* Mencari Musuh yang Berdarah */ 
    searchNegativeList(DefenseEnemy2, ReduceHealthEnemies),
    add2List([HealthEnemy], ReduceHealthEnemies, HealthEnemy2),
    concatList(HealthEnemy2, THealthEnemies, HealthListEnemies2),
    updateEnemies(StatusEnemies1, StatusEnemies2, health, HealthListEnemies2),
    /* Enemies Attack */
    enemiesAttackPlayer(StatusEnemies2), !.

/* Enemies Attack */
enemiesAttackPlayer(StatusEnemies2):-
    /* To Detect All Dead Enemies */
    turnEnemies(ListTurnEnemies), 
    deadEnemies(StatusEnemies2, StatusEnemies3, _, ListTurnEnemies, ListTurnEnemies2), !,
    retractall(meetEnemies(_)),
    assertz(meetEnemies(StatusEnemies3)),
    /* Enemy Attack Player */
    searchStatusEnemies(StatusEnemies3, attack, AttackListEnemies),
    /* Enemy May use Special Attack */
    setEnemiesToUseSpecialAtk(ListTurnEnemies2, ListTurnEnemies3),
    retractall(turnEnemies(_)),
    asserta(turnEnemies(ListTurnEnemies3)),
    /* Set Attack to Special Attack (Enemies) */
    setAtkToSpecialAtk(ListTurnEnemies3, AttackListEnemies, AttackListEnemies2),
    /* Searching for Health and Defense Player */
    statusPlyr(StatusPlayer2),
    searchStatus(StatusPlayer2, health, HealthP),
    searchStatus(StatusPlayer2, defense, DefensePlayer),
    negList(AttackListEnemies2, AttackListEnemies3),
    /* Attack to Player Defense */
    healthList(AttackListEnemies3, DefensePlayerList, DefensePlayer),
    /* Mencari Musuh yang berhasil melewati Defense Player */
    searchNegativeList(DefensePlayerList, ReduceHealthPlayer),
    /* To show that Enemy is attacking Player */
    attackingPlayer(ReduceHealthPlayer, StatusEnemies3),
    sumList(ReduceHealthPlayer, SumReduceHealthPlayer),
    HealthP2 is HealthP + SumReduceHealthPlayer,
    /* Update Status Player */
    updateStatus(StatusPlayer2, StatusPlayer3, health, HealthP2),
    retractall(statusPlyr(_)),
    asserta(statusPlyr(StatusPlayer3)),
    /* To Detect Player is Dead */
    statusPlyr(Player),
    searchStatus(Player, health, HealthPlayer),
    isdead(HealthPlayer),
    /* To Detect All Enemies are Dead */
    meetEnemies(Enemies),
    isdeadEnemies(Enemies).

/*====================== Run============================================ */
run :-
    isModeBertarung(1),
    random(1, 12, Number),
    ((Number < 12, meetEnemies(StatusEnemies), runFailed,
    enemiesAttackPlayer(StatusEnemies), !);
    (Number >= 12, runSuccesful)).

runSuccesful :-
    write('Run Successful!'), nl,
    retractall(meetEnemies(_)),
    asserta(meetEnemies([])),
    retractall(turnPlayer(_)),
    asserta(turnPlayer(4)),
    retractall(turnEnemies(_)),
    asserta(turnEnemies([])),
    retractall(isModeBertarung(_)),
    asserta(isModeBertarung(0)).

runFailed :-
    write('Run Failed!'), nl.

/*=================== Player is Dead or Game Over ======================*/
isdead(HealthPlayer) :- HealthPlayer > 0.
isdead(HealthPlayer) :-
    HealthPlayer =< 0,
    write('Game Over'), nl, nl,
    retractall(statusPlyr(_)),
    asserta(statusPlyr([
    level, 1,
    job, 'Peasant',
    health, 50,
    attack, 0, 
    defense, 0,
    exp, 0,
    gold, 0])),
    retractall(game_running(_)),
    asserta(game_running(false)),
    retractall(game_opening(_)),
    asserta(game_opening(false)),
    retractall(posisi(p,_,_)),
    asserta(posisi(p,2,3)),
    retractall(quest(_)),
    asserta(quest([[0, 0, 0]])),
    start.

/* Enemies are dead */
isdeadEnemies(Enemies) :- 
    Enemies = [],
    retractall(meetEnemies(_)),
    asserta(meetEnemies([])),
    retractall(turnPlayer(_)),
    asserta(turnPlayer(4)),
    retractall(turnEnemies(_)),
    asserta(turnEnemies([])),
    retractall(isModeBertarung(_)),
    asserta(isModeBertarung(0)), !.

isdeadEnemies(Enemies) :- 
    Enemies \= [], !.

/* Search Status Enemies in Mode Bertarung */
searchStatusEnemies([], _, []).
searchStatusEnemies([_, L|T], X, [Value|Y]) :-
    searchStatus(L, X, Value),
    searchStatusEnemies(T, X, Y).


/* Update Enemies in Mode Bertarung */
updateEnemies([], [], _, []).
updateEnemies([Enemy, L|T], [Enemy, LUpdate|X], Status, [Value|Y]) :-
    updateStatusEnemy(Enemy, L, LUpdate, Status, Value),
    updateEnemies(T, X, Status, Y).

/* Update Status Enemies */
updateStatusEnemy(Enemy, [A, B|T], [A, B|X], Status, Value) :-
    A \= Status, !,
    updateStatusEnemy(Enemy, T, X, Status, Value).

updateStatusEnemy(Enemy, [A, B|T], [A, Value|X], Status, Value) :-
    A = Status,
    ((B is Value); (B \= Value, C is B - Value, write('You deal '), write(C), write(' damage to '), write(Enemy), nl)),
    copyList(T, X).


/* Set Turn Player */
setTurnPlayer(Turn, TurnNew) :-
    Turn is 1,
    TurnNew is 1.
setTurnPlayer(Turn, TurnNew) :-
    Turn \= 1,
    TurnNew is Turn-1.

/* Showing Turn Player */
showTurnPlayer(Turn) :-
    Turn is 1,
    write('You can use Special Attack'), nl.

showTurnPlayer(Turn) :-
    Turn is 2,
    write('In the next turn, you can use Special Attack'), nl.

showTurnPlayer(Turn) :-
    Turn \= 1, Turn \= 2, 
    T is Turn-1,
    write('Your turn to use special attack is '), write(T), nl.

/* Set All turn Enemies to 3 in Mode Bertarung */
setTurnEnemies([], []).
setTurnEnemies([Enemy, _|T], [Enemy, 3, 0|X]) :-
    setTurnEnemies(T, X).

/* Set if Enemy Use Special Attack */
setEnemiesToUseSpecialAtk([], []).
setEnemiesToUseSpecialAtk([Enemy, Turn, _|T], [Enemy, TurnNew, NotSpecialAttack|X]) :-
    Turn \= 0,
    TurnNew is Turn-1,
    NotSpecialAttack is 0,
    setEnemiesToUseSpecialAtk(T, X).

setEnemiesToUseSpecialAtk([Enemy, Turn, _|T], [Enemy, TurnNew, IsUseSpecialAttack|X]) :-
    Turn is 0,
    random(1,3, IsUse),  /* chance 33,33 % to use specialAttack */
    useSpecialAtkEnemy(Enemy, IsUse, IsUseSpecialAttack, TurnNew),
    setEnemiesToUseSpecialAtk(T, X).

useSpecialAtkEnemy(Enemy, IsUse, Use, TurnNew) :-
    IsUse is 1, Use is 1, TurnNew is 3,
    write(Enemy), write(' use Special Attack'), nl.
useSpecialAtkEnemy(_, IsUse, Use, TurnNew) :-
    IsUse is 2, Use is 0, TurnNew is 0.
useSpecialAtkEnemy(_, IsUse, Use, TurnNew) :-
    IsUse is 3, Use is 0, TurnNew is 0.

/* Set Attack to Special Attack for Enemies */
setAtkToSpecialAtk([], [], []).
setAtkToSpecialAtk([_, _, UseSpecialAttack|T], [AttackEnemy|A], [Atk|B]) :-
    UseSpecialAttack is 1,
    Atk is AttackEnemy*2,
    setAtkToSpecialAtk(T, A, B).

setAtkToSpecialAtk([_, _, UseSpecialAttack|T], [AttackEnemy|A], [AttackEnemy|B]) :-
    UseSpecialAttack is 0,
    setAtkToSpecialAtk(T, A, B).

/* Health Enemies List in Mode Bertarung */
healthList([], [], _).
healthList([H|T], [N|X], I) :-
    N is H + I,
    healthList(T, X, I).

/* Delete All Dead Enemies in Mode Bertarung */
deadEnemies([], [], _, [], []).
deadEnemies([Enemies, L|T], StatusEnemies2, health, [Enemies, LTurnEnemy, SpclAtk|LT], ListTurnEnemies2) :-
    deadEnemies2(L, health, IsDead),
    ((IsDead is 0, StatusEnemies2 = [Enemies, L|X], ListTurnEnemies2 = [Enemies, LTurnEnemy, SpclAtk|LT2]), !;
    (IsDead is 1, X = StatusEnemies2, LT2 = ListTurnEnemies2, write(Enemies), write(' is'), write(' dead'), nl,
    searchStatus(L, getexp, GetExp), add_Exp(GetExp), write('You got '), write(GetExp), write(' Exp.'), nl
		, have_quest(S), S == 0);
	(IsDead is 1, X = StatusEnemies2, LT2 = ListTurnEnemies2, have_quest(S), S == 1, remaining_quest(Enemies))),
	deadEnemies(T, X, health, LT, LT2).

/* To know the enemy is dead */
deadEnemies2([], _, _).
deadEnemies2([A, B|T], health, IsDead) :-
    ((A \= health), !; (A = health, ((B =< 0, IsDead is 1), !; (B > 0, IsDead is 0)))), !,
    deadEnemies2(T, health, IsDead).

/* Player Has Been Attacked */
attackingPlayer([], []).
attackingPlayer([H|T], [Enemy, _|TE]) :-
    NAttackE is -H,
    write(Enemy), write(' deal '), write(NAttackE), write(' damage'), nl,
    attackingPlayer(T, TE).

/* Add List by a List */
add2List([],[],[]).
add2List([H|T], [R|TR], [HR|THR]) :-
    HR is H + R,
    add2List(T, TR, THR).

/* Search Negative Value in List and Set all nonNegative Value to zero */
searchNegativeList([], []).
searchNegativeList([H|T], [H|X]) :-
    H < 0, !,
    searchNegativeList(T, X).
searchNegativeList([H|T], [HR|X]) :-
    HR is 0,
    H >= 0,
    searchNegativeList(T, X).


/* Concat List */
concatList([], L, L).
concatList([H|T], L, [H|X]) :-
    concatList(T, L, X).

/* Sum List */
sumList([], 0).
sumList([H|T], N2) :-
    sumList(T, N1),
    N2 is N1+H.

/* Negative List */
negList([], []).
negList([H|T], [-H|X]) :-
    negList(T, X).