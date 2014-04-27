% >=
% =<
% trace / notrace

contains(Item, [ Item | _Tail]).
contains(Item, [_Head | Tail]) :-
	contains(Item, Tail).

sum([], 0).
sum([Head | Tail], Sum) :-
	sum(Tail, TailSum),
	Sum is Head + TailSum.

last_item([Item], Item).
last_item([_Head | Tail], Item) :-
	last_item(Tail, Item).

del(Item, [Item | Rest], Rest).
del(Item, [Head | Tail], [Head | NewTail]) :-
	del(Item, Tail, NewTail).

del_all(_Item, [], []).
del_all(Item, [Item | Tail], NewList) :-
	del_all(Item, Tail, NewList).
del_all(Item, [Head | Tail], [Head | NewList]) :-
	Item \== Head,
	del_all(Item, Tail, NewList).

double([], []).
double([Head | Tail], [Head | [Head | NewTail]]) :-
	double(Tail, NewTail).

money(X) :- X>=1000, write('Rich!').
money(X) :- X<1000, write('Poor :(').

app(Item, [], [Item]).
app(Item, [Head | Tail], [Head | NewList]) :-
	app(Item, Tail, NewList).

rev([], []).
rev([Head | Tail], Reversed) :-
	rev(Tail, ReversedTail),
	app(Head, ReversedTail, Reversed).

mrg([], AnyList, AnyList).
mrg(AnyList, [], AnyList).
mrg([WHead | WTail], [EHead | ETail], [WHead| RestOfMerge]) :-
	WHead < EHead,
	mrg(WTail, [EHead | ETail], RestOfMerge).
mrg([WHead | WTail], [EHead | ETail], [EHead| RestOfMerge]) :-
	WHead >= EHead,
	mrg([WHead | WTail], ETail, RestOfMerge).

weave([], AnyList, AnyList).
weave(AnyList, [], AnyList).
weave([Head1 | Tail1], [Head2 | Tail2], [Head1 | [Head2 | RestList]]) :-
	weave(Tail1, Tail2, RestList).



