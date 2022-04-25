% Task 2: Relational Data

% Вариант 2
% Напечатать средний балл для каждого предмета
% Для каждой группы, найти количество не сдавших студентов
% Найти количество не сдавших студентов для каждого из предметов


% The line below imports the data
:- ['two.pl'].


% 1) Print average grade for each subject from data
task1() :-
    %setof(X, grade(_, _, X, _), Sub),
    findall(X, grade(_, _, X, _), Sub1),
    setof(X, member(X, Sub1), Sub),
    print_avg(Sub).

% Sum predicate
sum([], 0).
sum([X|Y], S) :- sum(Y, S1), S is X + S1.

% Subject average grade
avg_grade(Sub, Avg) :-
    findall(X, grade(_, _, Sub, X), G),
    sum(G, Sum), length(G, Len), Avg is Sum / Len.

% Print avg for subjects from the list
print_avg([]).
print_avg([Sub|T]) :-
    avg_grade(Sub, Avg), write(Sub),
    write(': '), write(Avg), nl, print_avg(T).



% 2) For each group from data count students who failed
task2() :-
    findall(X, grade(X, _, _, _), G1),
    setof(X, member(X, G1), G),
    %setof(X, grade(X, _, _, _), G),
    print_failed(G).

% Counting failed students per group
failed(Gr, L) :-
    findall(X, grade(Gr, X, _, 2), F),
    length(F, L).

% Print number of failed students in groups from the list
print_failed([]).
print_failed([Gr|T]) :-
    failed(Gr, L), write(Gr), write(': '),
    write(L), nl, print_failed(T).



% 3) Count failed students for each subject from data
task3() :-
    findall(X, grade(_, _, X, _), Sub1),
    setof(X, member(X, Sub1), Sub),
    %setof(X, grade(_, _, X, _), S),
    print_failed_2(Sub).

% Counting failed students per subject
failed_2(Sub, L) :-
    findall(X, grade(_, X, Sub, 2), F),
    length(F, L).

% Print number of failed students per subject from the list
print_failed_2([Sub|T]) :-
    failed_2(Sub, L), write(Sub), write(': '), write(L), nl, print_failed_2(T).
print_failed_2([]).
