person("Настя").
person("Толя").
person("Саша").
person("Ира").

object("игрушки").
object("кубики").
object("мячи").
object("стихи").
object("прозы").
object("пьесы").
object("театр").
object("кино").
object("сериалы").
object("мультфильмы").

like(["любит"]).
nlike(["не", "любит"]).
comma(",").
but("но").
but("а").
and("и").

decompose([H|T], X) :- person(H), info(H, T, X).
info(Person, Text, X) :-
	append(T1, [C, B | _], Text),
	comma(C), but(B), verbph(Person, T1, X).
info(Person, Text, X) :-
	append(_, [C, B | T2], Text),
	comma(C), but(B), verbph(Person, T2, X).
verbph(Person, Text, likes(Person, Object)) :- append(L, Objects, Text), like(L), objs(Objects, Person, Object).
verbph(P, T, not_likes(P, O)) :- append(L, Os, T), nlike(L), objs(Os, P, O).

objs([O], _, O) :- object(O).
objs([O, And, _], _, O) :- and(And), object(O).
objs([_, And, O], _, O) :- and(And), object(O).

%objs([H|_], _, H) :- object(H).
%objs([_|T], P, O) :- objs(T, P, O).
