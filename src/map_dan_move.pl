/* :- include(struktur). */

/*==================== mendapatkan posisi sumbu ==========*/
sumbuX(P,X) :- posisi(P,X,_).
sumbuY(P,Y) :- posisi(P,_, Y).

/* Read File */
read_from_file(NameFile):-
		/*open file */
		open(NameFile, read, Stream),
		/*get char*/
		get_char(Stream, Char),
		/* output all char*/
		prosess_output(Char, Stream,0,0),!.

prosess_output(end_of_file,_,_,_) :- !.

prosess_output(Char1, Stream,X,Y) :-
		X =:= 16,
		X1 is 0, Y1 is Y+1,
		write_output(Char1,X,Y),
		get_char(Stream, Char2),
		prosess_output(Char2,Stream,X1,Y1).

prosess_output(Char1, Stream,X,Y) :-
		write_output(Char1,X,Y),
		get_char(Stream, Char2),
		X1 is X+1, Y1 is Y,
		prosess_output(Char2,Stream,X1,Y1).

write_output(Char4,X,Y) :-   
		posisi(pagar,X,Y),
		write('#');

		posisi(p,X,Y),
		write('P');

		posisi(s,X,Y),
		write('S');

		posisi(q,X,Y),
		write('Q');

		posisi(d,X,Y),
		write('D');

		write(Char4).

/*==================Menampilkan Maps====================*/

map:- game_running(false),fail,!.

map :- game_running(true),
	read_from_file('../file/map.txt').

/*================= move ==============================*/ 

notPagar(NX,NY) :- 
	\+ (posisi(pagar,NX,NY)),
	NX =\= 0,
	NY =\= 0,
	NX =\= 15,
	NY =\= 18.

/*================= w ==============================*/ 
w :- game_running(false),fail,!.

w :- game_running(true),isModeBertarung(0),
	enter_shop(true),
	in_shop(true),
	write('You are in the Shop'),nl,
	write('type exitShop. to ExIT'),fail,nl,
	meetEnemies,fightBoss,!.

w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	NY is Y-1 ,
	notPagar(X,NY),
	retract(posisi(p,X,Y)),
	asserta(posisi(p,X,NY)),
	posisi(s,X,NY),
	retract(enter_shop(false)),
	asserta(enter_shop(true)),
	write('Move up.'),nl,
	write('You are in the shop area'),nl,
	write('Type shop. to enter!'),nl,
	meetEnemies,fightBoss, !.


w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	\+ notPagar(X,Y-1),
	write('diatas Anda adalah pagar.'), nl,!, 
	map,nl,
	retract(enter_shop(true)),
	asserta(enter_shop(false)),nl,
	meetEnemies,fightBoss.

w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	posisi(q,X,Y),
	retract(enter_quest(false)),
	asserta(enter_quest(true)),
	write('Move up.'),nl,
	write('You are in the Quest area'),nl,
	write('Type start_quest.'),nl,
	write('To acc the challenge!'),nl,
	meetEnemies,fightBoss, !.

w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	notPagar(X,Y),
	retract(enter_quest(true)),
	asserta(enter_quest(false)),
	write('Move up.'),nl,
	meetEnemies,fightBoss,!.

w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	\+ notPagar(X,Y-1),
	write('diatas Anda adalah pagar.'), nl,
	map,nl,meetEnemies,fightBoss,!.

w :- game_running(true),isModeBertarung(0),
	in_shop(false),
	posisi(p,X,Y),
	notPagar(X,Y),
	write('Move up.'),nl,
	meetEnemies,fightBoss,!.

/*================= s ==============================*/ 
s :- game_running(false),fail,!.

s :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	NY is Y+1 ,
	notPagar(X,NY),
	retract(posisi(p,X,Y)),
	asserta(posisi(p,X,NY)),
	posisi(s,X,NY),
	retract(enter_shop(false)),
	asserta(enter_shop(true)),
	write('Move down.'),nl,
	write('You are in the shop area'),nl,
	write('Type shop. to enter!'),nl,
	meetEnemies,fightBoss, !.

s :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	\+ notPagar(X,Y+1),
	write('dibawah Anda adalah pagar.'), nl,!,
	map,nl,meetEnemies,fightBoss.

s :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	posisi(q,X,Y),
	retract(enter_quest(false)),
	asserta(enter_quest(true)),
	write('Move down.'),nl,
	write('You are in the Quest area'),nl,
	write('Type start_quest.'),nl,
	write('To acc the challenge!'),nl,
	meetEnemies,fightBoss, !.

s :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	retract(enter_shop(true)),
	asserta(enter_shop(false)),
	retract(enter_quest(true)),
	asserta(enter_quest(false)),
	write('Move down.'),nl,
	meetEnemies,fightBoss,!.

s :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	write('Move down.'),nl,
	meetEnemies,fightBoss,!.

/*================= a ==============================*/ 
a :- game_running(false),fail,!.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	NX is X-1 ,
	notPagar(NX,Y),
	retract(posisi(p,X,Y)),
	asserta(posisi(p,NX,Y)),
	posisi(s,NX,Y),
	retract(enter_shop(false)),
	asserta(enter_shop(true)),
	write('Move left.'),nl,
	write('You are in the shop area'),nl,
	write('Type shop. to enter!'),nl,
	meetEnemies,fightBoss, !.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	\+ notPagar(X-1,Y),
	retract(enter_shop(true)),
	asserta(enter_shop(false)),nl,
	write('dikiri Anda adalah pagar.'), nl,!, 
	map,nl,meetEnemies,fightBoss.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	posisi(q,X,Y),
	retract(enter_quest(false)),
	asserta(enter_quest(true)),
	write('Move left.'),nl,
	write('You are in the Quest area'),nl,
	write('Type start_quest.'),nl,
	write('To acc the challenge!'),nl,
	meetEnemies,fightBoss, !.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	retract(enter_quest(true)),
	asserta(enter_quest(false)),
	write('Move left.'),nl,
	meetEnemies,fightBoss,!.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	\+ notPagar(X-1,Y),
	write('dikiri Anda adalah pagar.'), nl,!, 
	map,nl,meetEnemies,fightBoss.

a :- game_running(true),isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	write('Move left.'),nl,
	meetEnemies,fightBoss,!.

/*================= d ==============================*/ 
d :- game_running(false),fail,!.

d :- game_running(true), isModeBertarung(0),
	posisi(p,X,Y),
	NX is X+1 ,
	notPagar(NX,Y),
	retract(posisi(p,X,Y)),
	asserta(posisi(p,NX,Y)),
	posisi(s,NX,Y),
	retract(enter_shop(false)),
	asserta(enter_shop(true)),
	write('Move right.'),nl,
	write('You are in the shop area'),nl,
	write('Type shop. to enter!'),nl,
	meetEnemies,fightBoss, !.

d :- game_running(true), isModeBertarung(0),
	posisi(p,X,Y),
	\+ notPagar(X+1,Y),
	write('dikanan Anda adalah pagar.'), nl,!,
	map,nl, meetEnemies,fightBoss.

d :- game_running(true), isModeBertarung(0),
	posisi(p,X,Y),
	posisi(q,X,Y),
	retract(enter_quest(false)),
	asserta(enter_quest(true)),
	write('Move right.'),nl,
	write('You are in the Quest area'),nl,
	write('Type start_quest.'),nl,
	write('To acc the challenge!'),nl,
	meetEnemies,fightBoss, !.

d :- game_running(true), isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	retract(enter_shop(true)),
	asserta(enter_shop(false)),
	retract(enter_quest(true)),
	asserta(enter_quest(false)),
	write('Move right.'),nl,
	meetEnemies,fightBoss,!.

d :- game_running(true), isModeBertarung(0),
	posisi(p,X,Y),
	notPagar(X,Y),
	write('Move right.'),nl,
	meetEnemies,fightBoss,!.


