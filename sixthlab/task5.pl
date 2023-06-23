#5 задание
gray([0], [[0], [1]]).

gray([H|T], R) :-
    gray(T, R1),
    reverse(R1, Rev),
    add_prefix(0, R1, P0),
    add_prefix(1, Rev, P1),
    append(P0, P1, R).

add_prefix(_, [], []).

add_prefix(H, [X|T], [[H|X]|R]) :-
    add_prefix(H, T, R).


% gray([0,0], Code).
% gray([0], Code).