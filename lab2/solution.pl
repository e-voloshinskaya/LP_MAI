% Statements of boys:

% Andrey accuses Vitya OR Tolya
say("Andrey", "Vitya").
say("Andrey", "Tolya").

% Vitya says he AND Yura are innocent
say("Vitya", Guilty):-
    Guilty \= "Vitya", Guilty \= "Yura".

% Dima says either Andrey OR Vitya is lying
say("Dima", Guilty):-
    (say("Andrey", Guilty), not(say("Vitya", Guilty)));
    (say("Vitya", Guilty), not(say("Andrey", Guilty))).

% Yura believes Dima is lying
say("Yura", Guilty):-
    not(say("Dima", Guilty)).

% Check whether all people from the list are telling the truth
true_says([], _).
true_says([H|T], Guilty):-
        say(H, Guilty), true_says(T, Guilty).

% Find such person (Liar) from all 4 speakers
% that the rest of boys told the truth
% and get the name of guilty person (Guilty; of all 5 boys) from true says. 
solve(Guilty):-
    member(Guilty, ["Andrey", "Vitya", "Dima", "Yura", "Tolya"]),
    member(Liar, ["Andrey", "Vitya", "Dima", "Yura"]),
    delete(["Andrey", "Vitya", "Dima", "Yura"], Liar, Speakers),
    true_says(Speakers, Guilty), !.

% Print the result
print():- solve(X), write(X), write(" broke the window."), nl.
