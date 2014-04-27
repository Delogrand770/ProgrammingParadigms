:- dynamic person/1.
:- dynamic parent/2.

person(gavin).
person(adrian).
person(hailey).
person(grant).
person(cheryl).
person(tellis).
person(marge).
person(jill).
person(bob).

gender(gavin, male).
gender(adrian, male).
gender(hailey, female).
gender(grant, male).
gender(cheryl, female).
gender(tellis, male).
gender(marge, female).
gender(jill, female).
gender(bob, male).

parent(cheryl, gavin).
parent(grant, gavin).
parent(cheryl, adrian).
parent(grant, adrian).
parent(cheryl, hailey).
parent(grant, hailey).
parent(marge, cheryl).
parent(tellis, cheryl).
parent(jill, grant).
parent(bob, grant).

mother(M, C) :-
	parent(M, C),
	gender(M, female),
	person(M),
	person(C).


father(F, C) :-
	parent(F, C),
	gender(F, male),
	person(F),
	person(C).

grandparent(GP, GC) :-
	    parent(GP, P),
	    parent(P, GC),
	    person(GP), person(GC), person(P).

sibling(Child1, Child2) :-
	parent(Parent, Child1),
	parent(Parent, Child2),
	Child1 \= Child2,
	person(Child1),
	person(Child2),
	person(Parent).

brother(B, P) :-
	sibling(B, P),
	gender(B, male).

sister(S, P) :-
	sibling(S, P),
	gender(S, female).

aunt(A, X) :-
	parent(P, X),
	sister(A, P).


uncle(U, X) :-
	parent(P, X),
	brother(U, P).

niece(N, X) :-
	sibling(S, X),
	parent(S, N),
	gender(N, female).

newphew(N, X) :-
	sibling(S, X),
	parent(S, N),
	gender(N, male).

cousin(X, Y) :-
	parent(P, Y),
	sibling(S, P),
	parent(S, X).

spouse(cheryl, grant).
spouse(jill, bob).
spouse(marge, tellis).

married(A, B) :- spouse(A, B).
married(A, B) :- spouse(B, A).

%This is syntactic sugar
%married(A, B) :- spouse(A, B) ; spouse(B, A).

ancestor(A, D) :-
	parent(A, D).
ancestor(A, D) :-
	parent(A, M), %Middle person
	ancestor(M, D).

%debug. nodebug.
%trace. notrace.

orphan(Child) :-
	not(parent(_Someone,Child)).


ancestors(D, []) :-
	orphan(D).
ancestors(D, [Parent | RestOfAncestors]) :-
	parent(Parent, D),
	ancestors(Parent, RestOfAncestors).


ancestors(Person, Person, [Person]).
ancestors(A, D, [ A | RestOfAncestors]) :-
	parent(A, Middle),
	ancestors(Middle, D, RestOfAncestors).
