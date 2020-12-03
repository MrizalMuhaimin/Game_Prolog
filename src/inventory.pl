/* :- include(struktur). */

/*=================== Menghitung Jumlah Item di Inventory ================*/
countInventory(X) :- 
    inventoryPlyr(A),
    countFull(A, 0, X).

countFull([], I, I).
countFull([_, Amount|T], I, X) :-
    Inew is I+Amount,
    countFull(T, Inew, X).

/*============================ Menampilkan Inventory====================== */
inventory:- game_running(false),fail,!.

inventory :- game_running(true),
    write('Your inventory:'), nl, 
    inventoryPlyr(X),
    showInventory(X).

showInventory([]).
showInventory([_, Amount|T]) :- 
    Amount is 0, !,
    showInventory(T).
showInventory([Item, Amount|T]) :- 
    (Item = woodensword, write(Amount), write(' Wooden sword (Swordsman)'), nl), !,
    showInventory(T).
showInventory([Item, Amount|T]) :- 
    (Item = woodenbow, write(Amount), write(' Wooden bow (Archer)'), nl), !,
    showInventory(T).
showInventory([Item, Amount|T]) :- 
    (Item = magicbook, write(Amount), write(' Magic Book (Sorcerer)'), nl), !,
    showInventory(T).
showInventory([Item, Amount|T]) :- 
    (Item = healthpotion, write(Amount), write(' Health potion'), nl), !,
    showInventory(T).
showInventory([Item, Amount|T]) :-
    (Item \= woodensword, Item \= woodenbow, Item \= magicbook, Item \= healthpotion),
    write(Amount), write(' '), write(Item),
    showInventory(T).


/*============================ usePotion====================== */
usePotion:- game_running(false),fail,!.

usePotion :- game_running(true),
    inventoryPlyr(Inv),
    searchStatus(Inv, healthpotion, NumPotion),
    NumPotion \= 0,
    NumPotionNew is NumPotion-1,
    updateStatus(Inv, InvNew, healthpotion, NumPotionNew),
    retractall(inventoryPlyr(_)),
    asserta(inventoryPlyr(InvNew)),
    statusPlyr(StatusPlayer),
    searchStatus(StatusPlayer, health, HealthPlayer),
    searchStatus(StatusPlayer, max, MaxHealth),
    HealthPlayer2 is HealthPlayer + MaxHealth/10,
    ((HealthPlayer2 > MaxHealth, HealthPlayer3 is MaxHealth); (HealthPlayer2 =< MaxHealth, HealthPlayer3 is HealthPlayer2)),
    updateStatus(StatusPlayer, StatusPlayer2, health, HealthPlayer3),
    retractall(statusPlyr(_)),
    asserta(statusPlyr(StatusPlayer2)), !.

usePotion :- game_running(true),
    inventoryPlyr(Inv),
    searchStatus(Inv, healthpotion, 0),
    write('Not Enough Health Potion').
 