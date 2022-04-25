:-['data.pl'].

male(X) :- father(X, _).
female(X) :- mother(X, _).

dever(D, Y) :- husband(H, Y), brother(D, H).
husband(H, W) :- mother(W, C), father(H, C).
wife(W, H) :- husband(H, W).

brother(B, X) :- father(F, X), father(F, B), X \= B, male(B).
brother(B, X) :- mother(M, X), mother(M, B), X \= B, male(B).

sister(S, X) :- father(F, S), father(F, X), X \= S, female(S).
sister(S, X) :- mother(M, S), mother(M, X), X \= S, female(S).

son(S, P):- (father(P, S); mother(P, S)), male(S).
daughter(D, P):- (father(P, D); mother(P, D)), female(D).

grandma(G, C):- mother(G, P), (mother(P, C); father(P, C)).
grandpa(G, C):- father(G, P), (father(P, C); mother(P, C)).

grandchild(C, G):- grandma(G, C); grandpa(G, C).
grandson(C, G):- male(C), grandchild(C, G).
granddaughter(C, G):- female(C), grandchild(C, G).


move(X, Y, father):-
    father(X, Y).
move(X, Y, mother) :-
    mother(X, Y).
move(X, Y, daughter) :-
    daughter(X, Y).
move(X, Y, son) :-
    son(X, Y).
move(X, Y, husband) :- 
    husband(X, Y).
move(X, Y, wife):- 
    wife(X, Y).
move(X, Y, sister) :-
    sister(X, Y).
move(X, Y, brother) :-
    brother(X, Y).
move(X, Y, grandson) :-
    grandson(X, Y).
move(X, Y, granddaughter) :-
    granddaughter(X, Y).
move(X, Y, grandpa ):-
    grandpa(X, Y).
move(X, Y, grandma) :-
    grandma(X, Y).

% итерационный поиск с заглублением

int(1).
int(M) :- int(N), M is N + 1.

path_id([X|T], X, [X|T], [], 0). 
path_id(Path, Finish, W, [R|T], N) :-
	N > 0,
    prolong(Path, Path1, R),
	N1 is N - 1,
	path_id(Path1, Finish, W, T, N1).

prolong([X|T], [Y, X|T], R) :-
	move(X, Y, R),
	not(member(Y, [X|T])).


search_id(Start, Finish, W, R) :- int(DepLimit), (DepLimit > 5, ! ; path_id([Start], Finish, W, R, DepLimit)).

relative(A, B, Res) :-
	search_id(B, A, _, Res).
