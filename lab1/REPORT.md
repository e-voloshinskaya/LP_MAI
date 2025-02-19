# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Волошинская Е.В.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Список — это абстрактная структура данных, состоящая из узлов. Узел содержит данные и ссылку на один или два соседних узла.
Списки в Prolog являются односвязными, т.е. каждый узел содержит лишь одну ссылку. При работе с односвязными списками необходимо выделять первый узел (называемый головой списка), остальные узлы (составляющие хвост списка) можно получить, передвигаясь по указателям вплоть до последнего узла. Хвост списка является таким же списком, как и исходный, поэтому обрабатывается аналогичным образом (рекурсивно).

В императивных языках, в отличие от Пролога, списки не являются основной структурой для хранения данных. В них чаще используются массивы (статические и динамические), но императивные языки более гибкие, так как программист всегда может написать собственную структуру данных.
Одно из отличий списков в Prolog от схожих структур данных в императивных языках - программист не сталкивается с явной работой с указателями в узлах, только с интерфейсом структуры "список", в императивных же в зависимости от реализации программист может получать доступ непосредственно к ячейкам памяти компьютера (в куче) для работы с данными.

Что касается доступа к элементам списка, элемент данных в Прологе может быть очень быстро добавлен или удален из начала списка. Однако операция произвольного доступа (обращения к n-ному элементу) в Прологе выполняется гораздо дольше, чем в массивах императивных языков, т.к. требует n операций перехода по ссылкам. Императивные языки, напротив, позволяют получить доступ к любому элементу массива (статического и динамического) за O(1) по его индексу. Список в Прологе больше напоминает стек в императивных языках, так как в нем так же доступ осуществляется только к первому элементу, а остальные можно получить, рассмотрев оставшуюся часть после удаления первого элемента как новый стек.

## Задание 1.1: Предикат обработки списка

`ins(E, N, L, R)` (`ins2(E, N, L, R)`) - вставка элемента в список на указанную позицию.
Аргументы: элемент, позиция, список, новый список. Нумерация с 1.

Примеры использования:
```prolog
?- ins(100, 0, [1, 2, 3, 4], R). 
false.
?- ins(100, 1, [1, 2], R). 
R = [100, 1, 2] .
?- ins(100, 4, [1, 2, 3, 4, 5, 6], R). 
R = [1, 2, 3, 100, 4, 5, 6].
?- ins(100, 1, [], R). 
R = [100] .
?- ins(100, 3, [], R). 
false.
?- ins(100, -1, [1, 2], R). 
false.
?- ins(100, 5, [1, 2, 3], R).
false.
```
```prolog
?- ins2(100, 3, [], R).
R = [] .
?- ins2(100, 0, [1, 2, 3, 4], R).
R = [1, 2, 3, 4] .
?- ins2(100, 5, [1, 2], R).  
R = [1, 2] .
```

Реализация:
```prolog
% без стандартных предикатов
ins(E, 1, T, [E|T]).
ins(E, N, [H|T], [H|T1]) :- N1 is N - 1, ins(E, N1, T, T1).

% со станд. предикатами
ins2(E, 1, [], R):- R = [E], !.
ins2(_, _, [], R):- R = [], !.
ins2(_, N, L, R):- N < 1, R = L, !.
ins2(_, N, L, R) :- length(L, R1), R1 < N - 1, R = L, !.
ins2(E, N, L, R) :-
	length(X, N1),
	N1 is N - 1,
	append(X, Y, L),
	append(X, [E], L1),
	append(L1, Y, R), !.
```

`ins(E, N, L, R)`: В случае, если вставка элемента E происходит на 1 позицию (нумерация с 1), предикат ins составляет список [E|T], где T - исходный список. В остальных случаях предикат рекурсивно вызывает себя, передавая список без первого элемента и уменьшая указанную позицию N на 1. Таким образом происходит замена исходной задачи на вставку элемента на позицию N-1 в список T1 длины len(L)-1, пока новая позиция не станет равна 1, после чего происходит вставка и подстановка значений в новый список. Если исходный список пустой, а позиция вставки не равна 1, то (правила для пустого списка нет, а  разделить пустой список на голову и хвост нельзя) предикат вернет false. Если позиция N вне границ списка, то на некотором шаге также получится пустой список, и предикат вернет false.

`ins2(E, N, L, R)`: (Нумерация так же с 1) Отдельными правилами предикат ins2 обрабатывает случаи, когда исходный список пуст и элемент добавляется на 1 позицию, на другую позицию; когда позиция вне границ исходного списка. В отличие от ins1, ins2 выведет исходный список, если он изначально был пуст или если заданная позиция вне его границ. Последнее правило предиката заключается в том, чтобы, во-первых, найти такой список X, что его длина равна N - 1 (то есть от 1 до позиции перед той, куда необходимо вставить элемент E) и что существует список Y, при конкатенации X с которым получится исходный L, во-вторых, произвести последовательную конкатенацию списков X, [E], Y, где E - вставляемый элемент, в данном порядке.

Обоснование использования `!`: при попытке пользователя запросить другие решения (что противоречит его единственности) произойдет зацикливание, поэтому `!` необходимы для предотвращения бэктрекинга после обработки каждого из правил. При условии, что пользователь не запрашивает поиск дополнительных решений, все `!` можно убрать. Тогда предикат будет выглядеть так:
```prolog
ins2(E, 1, [], [E]).
ins2(_, _, [], []).
ins2(_, N, L, R):- N < 1, R = L.
ins2(_, N, L, R) :- length(L, R1), R1 < N - 1, R = L.
ins2(E, N, L, R) :-
	length(X, N1),
	N1 is N - 1,
	append(X, Y, L),
	append(X, [E], L1),
	append(L1, Y, R).
```

## Задание 1.2: Предикат обработки числового списка

`first_neg(L, N)` (`first_neg2(L, N)`) - вычисление позиции первого отрицательного элемента в списке. Первая реализация (за счет отсутствия условия X>=0 во 2-ом правиле) также позволяет найти последовательно индексы всех отрицательных элементов.
Аргументы: список, позиция. Нумерация с 1.

Примеры использования:
```prolog
?- first_neg([-1, 2, 8, 4], R).
R = 1 .

?- first_neg([-1, 2, 8, 4], R). 
R = 1 .

?- first_neg([1, -2, -8, -4], R).  
R = 2 ;
R = 3 ;
R = 4 ;
false.

?- first_neg([1, 0, 8, 4], R).    
false.

?- first_neg([], R).           
false.
```
Аналогично,
```prolog
?- first_neg2([-1, 2, 8, 4], R).
R = 1 .

?- first_neg2([1, -2, -8, -4], R). 
R = 2 ;
false.

?- first_neg2([1, 0, 8, 4], R).
false.

?- first_neg2([], R).
false.
```

Реализация:
```prolog
% без стандартных предикатов
first_neg([X|_], 1) :- X < 0.
first_neg([_|T], N) :- first_neg(T, N1), N is N1 + 1.

% со станд. предикатами
first_neg2([X|_], 1):- X < 0.
first_neg2([X|T], R):- X >= 0, length(T, N), N > 0, first_neg2(T, R0), R is R0 + 1.
```

`first_neg(L, N)`: предикат берет первый элемент передаваемого списка, проверяет его на отрицательность и в случае, если элемент неотрицательный, вызывает себя же, передавая список без первого элемента и уменьшая позицию на 1. Таким образом, рекурсивно просматриваются все элементы до первого отрицательного, который получает индекс 1 и в процессе возврата он увеличивается до позиции от начала исходного списка. Если же отрицательного элемента в списке нет, результатом будет false, так как нет правила для пустого исходного списка. Для пустого исходного списка предикат по той же причине вернет false.

`first_neg2(L, N)`: принцип работы тот же, что у first_neg, только на каждом шаге рекурсии при отделении первого неотрицательного элемента от переданного списка проверяется, что длина полученного хвоста списка положительная, то есть если список не содержит неотрицательных элементов, то предикат дойдет до конца списка по 2 правилу и на последнем элементе выдаст false, так как длина хвоста будет 0.

```prolog
% пример на оба предиката:
% Вставка перед первым отрицательным элементом. Аргументы: 1. вставляемый элемент; 2. исходный список; 3. результирующий список.
ins_bef_1neg(E, L, R):- first_neg2(L, N), ins2(E, N, L, R).
% пример на myRemove и ins2:
% Перемещение элемента в списке. Аргументы: 1. элемент из исходного списка; 2. позиция, на которую его нужно переместить; 3. исходный список; 4. новый список.
move(E, P, L, R):- myRemove(L, E, R0), ins2(E, P, R0, R).
```

## Задание 2: Реляционное представление данных

Преимущества реляционного представления:
- Простая и читабельная форма изложения информации. Факты, как и записи в реляционных таблицах, имеют одинаковую структуру, а имена предикатов позволяют судить об отношениях их аргументов. Так, по названию предиката grade можно понять, что он должен описывать связь оценки с учеником, получившим ее, и предметом, по которому она была выставлена.
- Основа модели - математический аппарат, который позволяется строго описывать операции над данными (логика дизъюнктов Хорна).
- Возможность использования непроцедурных языков для работы.

Недостатки:
- Трудность изменения структуры данных. Добавить или убрать 1 или несколько аргументов одновременно из всех фактов - нетривиальная задача.
- Трудность проектирования реляционной базы данных. Так как изменять структуру предиката с ростом количества данных все труднее, необходимо перед написанием предикатов четко понимать задачи, для которых они будут использоваться. Также сложные отношения трудно переводятся в реляционное представление.
- Большой расход памяти для представления. Особенно это проявляется в случае, если данных мало, то есть имеется множество фактов, многие аргументы которых не определены. В таком случае от этих аргументов в конкретных фактах нельзя избавиться, их придется заполнить символами, обоначающими пустое значение.

Преимущества представления данных two.pl:
- Единообразие данных (используется только один предикат). Упрощает чтение и унифицирует работу с данными.
- Простая структура данных. Отсутствие списков списков и предикатов внутри предиката, как в three.pl. Упрощает восприятие.

Недостатки:
- Многочисленное дублирование данных: номеров групп, фамилий, предметов. Отчего, например, доступ к списку группы усложняется и зависит не только от числа учеников, но и от количества предметов. Если разбить исходный предикат на несколько, данные можно хранить более экономно.

<br />
Принципы реализации предикатов, осуществляющих запросы к данным:


`sum(L, S)`: L - список элементов, S - сумма элементов списка L. Предикат рекурсивно складывает элементы из списка, прибавляя модуль первого элемента списка к результату предиката от списка без этого элемента.

`avg_grade(Sub, Avg)`: предикат находит и записывает в список G всевозможные оценки по предмету Sub, далее находит сумму элементов и длину G и вычисляет среднее арифметическое оценок Avg.

`print_avg(L)`: предикат рекурсивно выводит на экран средние оценки по предметам из списка предметов L, на каждом шаге рекурсии печатая информацию по первому предмету из списка.

`task1()`: предикат записывает в список Sub1 все предметы, встречающиеся в фактах из two.pl, при помощи setof в список Sub данные предметы записываются без повторений, далее печатается среднее арифметическое для каждого предмета (print_avg).


`failed(Gr, L)`: подсчет количества оценок "2" студентов из группы Gr (поиск и запись в список всех таких фактов, что группа=Gr, оценка=2, и подсчет длины этого списка). Так как у каждого ученика из фактов two.pl оценка по предмету единственная, то предикат эквивалентен поиску количества несдавших студентов в группе.

`print_failed(L)`: рекурсивная печать для каждой группы из списка L количества несдавших студентов при помощи предиката failed(Gr, L).

`task2()`: находим всевозможные учебные группы из фактов, записываем их в список G без повторов (последовательное применение findall и setof), применяем к полученному списку групп предикат print_failed(L).


`failed_2(Sub, L)`: подсчет количества несдавших (оценка "2") по предмету Sub аналогично failed(Gr, L), только условия для grade(A, B, C, D) в findall меняются на предмет=Sub, оценка=2.

`print_failed_2(L)`: рекурсивная печать для каждого предмета из списка L количества несдавших студентов при помощи предиката failed_2(Gr, L).

`task3()`: находим всевозможные предметы из фактов, записываем их в список Sub без повторов (последовательное применение findall и setof), применяем к полученному списку групп предикат print_failed_2(L).

## Выводы
В процессе выполнения лабораторной работы я научилась основам логического программирования на языке Пролог. Я изучила стандартные предикаты, научилась реализовывать собственные простейшие предикаты для решения задач, изучила структуру данных "список", научилась работать с ней и применять для обработки данных в реляционном представлении. Мне было очень сложно переключиться с концепта императивных языков на декларативный логический Пролог, и он действительно заставил мозг работать иначе, что может быть полезно будущему программисту для развития.
