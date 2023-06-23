#3 задание
replace([], _, _, []).
replace([X|Xs], X, Y, [Y|Ys]) :- replace(Xs, X, Y, Ys).
replace([X|Xs], Y, Z, [X|Ys]) :- X \= Y, replace(Xs, Y, Z, Ys).