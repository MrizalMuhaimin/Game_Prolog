/* :- include(struktur). */

/*================== List Random Items Gacha ==================== */
gachaswordsman(['Iron Armor', 'Heavy Sword', 'Paladins Boots']).
gachaarcher(['Fire Bow', 'Medieval Armour', 'Medieval Boots']).
gachamage(['Magic Wand', 'Dark Crystal', 'Fire Orb']).

/*=================== Replace dengan key ==========================*/
/* ada di file struktur */


/*================= Start ======================================= */
start:-
game_opening(false),
game_running(false),
read_file('../file/awal.txt'),
retract(game_opening(false)),
asserta(game_opening(true)),!.

start:-
game_opening(true),
game_running(false),
retractall(statusPlyr(_)),
retractall(inventoryPlyr(_)),
write('Welcome to the game. Choose your job\n'),
write('1. Swordsman\n'),
write('2. Archer\n'),
write('3.Sorcerer\n'),
read_number(X),
write('You choose '),

( X == 1 -> write('swordsman'), asserta(statusPlyr([
    level, 1,
    job, 'Swordsman', 
    health, 1000,
    max, 1000,
    attack, 60,
    defense, 45,
    exp, 0,
    maxexp, 300,
    gold,1000
])),
asserta(inventoryPlyr([woodensword, 1, healthpotion, 5]))

; X == 2 -> write('archer'), asserta(statusPlyr([
    level, 1,
    job,'Archer',
    health, 1100,
    max, 1100,
    attack, 70,
    defense, 35,
    exp, 0,
    maxexp, 275,
    gold, 1000
])),
asserta(inventoryPlyr([woodenbow, 1, healthpotion, 5]))

; X == 3 -> write('sorcerer'), asserta(statusPlyr([
    level, 1,
    job, 'Sorcerer',
    health, 800,
    max, 800,
    attack, 55,
    defense, 30,
    exp, 0,
    maxexp, 285,
    gold, 1000
])),
asserta(inventoryPlyr([magicbook, 1, healthpotion, 5]))

; fail), 
write(', lets explore the world!!!'),
retract(game_running(false)),
asserta(game_running(true)),!.


/*============================= Shop ============================== */
shop :- game_running(false),fail,!.

shop:-
game_running(true),
enter_shop(true),
isModeBertarung(0),
retract(in_shop(false)),
asserta(in_shop(true)),
write('What do you want to buy?\n'),
write('1. Gacha - 1000 Gold\n'),
write('2. Health Potion - 100 Gold\n'),
write('Command= 1: gacha., 2: buypotion.'),!.

shop:- 
game_running(true),
enter_shop(true),
isModeBertarung(1),
write('You have to FIGHT!'),!.

shop:- 
game_running(true),
enter_shop(false),
write('You have to go to the shop'),!.

/*============================= buypotion ============================== */

buypotion:- game_running(false),fail,!.

buypotion:- enter_shop(false), game_running(true),
    write('You have to go to the shop.'),fail,!.

buypotion:-
game_running(true),
enter_shop(true),
statusPlyr(S),
nth0(Index, S, gold),
A is Index+1,
nth0(A, S, Gold),
(Gold >= 100 -> Newgold is (Gold-100)
	,replacebykey(gold, Newgold, S, Result)
	,retract(statusPlyr(_))
	,assertz(statusPlyr(Result))
	,inventoryPlyr(X)
	,nth0(I, X, healthpotion)
	,C is I+1
	,nth0(C, X, Hpotion)
	,Newhpotion is Hpotion+1
	,replacebykey(healthpotion, Newhpotion, X, Inventoryresult)
	,retract(inventoryPlyr(_))
	,assertz(inventoryPlyr(Inventoryresult))
	,write('You bought Health Potion.')
; write('You dont have enough gold!')),!.

/*============================= gacha ============================== */
gacha:- game_running(false),fail,!.

gacha:- game_running(true),
    enter_shop(false),
    write('You have to go to the shop.'),fail,!.

gacha:-
game_running(true),
enter_shop(true),
statusPlyr(S),
random(1, 4, Number),
nth0(3, S, Job),
(Job = 'Swordsman' -> gachaswordsman(A), nth1(Number, A, Items)
; Job = 'Archer' -> gachaarcher(B), nth1(Number, B, Items)
; Job = 'Sorcerer' -> gachamage(C), nth1(Number, C, Items)
; fail),
nth0(Index, S, gold),
Newindex is (Index+1),
nth0(Newindex, S, Gold),
(Gold >= 1000 -> Newgold is (Gold-1000)
	,replacebykey(gold, Newgold, S, Result)
	,retract(statusPlyr(_))
	,assertz(statusPlyr(Result))
	,inventoryPlyr(X)
	,append(X, [Items, 1], List)
	,retract(inventoryPlyr(_))
	,assertz(inventoryPlyr(List))
	,write('You get ')
	,write(Items)
; write('You dont have enough gold!')).


exitShop:-
game_running(true),
enter_shop(true),
in_shop(true),
retract(in_shop(true)),
asserta(in_shop(false)),
write('Thanks for coming *-*').