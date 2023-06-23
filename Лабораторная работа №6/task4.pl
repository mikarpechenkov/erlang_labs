#4 задание
my_flatten([], []).

my_flatten(X, [X]) :- \+ is_list(X). %true - если не выполнено

my_flatten([H|T], R) :-
    my_flatten(H, FH),
    my_flatten(T, FT),
    append(FH, FT, R).

% my_flatten([a, [b, [c, d]], [[e], f]], Flattened).