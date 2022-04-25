:-['data.pl'].

male(X) :- father(X, _).
female(X) :- mother(X, _).

dever(X, Y) :- husband(X, H), brother(H, Y).
husband(W, H) :- mother(W, C), father(H, C).
brother(X, B) :-
	(father(F, X), father(F, B) ; mother(M, X), mother(M, B)),
	X \= B, male(B).
