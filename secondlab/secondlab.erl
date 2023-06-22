%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 11. Jun 2023 4:44 AM
%%%-------------------------------------------------------------------
-module(secondlab).
-author("mikar").

%% API
-compile(export_all).

%%Задание 1 (общее)
for(Init, Cond, Step, Body) ->
  case Cond(Init) of
    true ->
      Body(Init),
      for(Step(Init), Cond, Step, Body);
    _ -> for_end
  end.
%%Запускается в cmd: secondlab:for(0, fun(X)-> X < 3 end, fun(X)-> X + 1 end, fun(X)-> io:format("~w~n", [X]) end).

%%Задание 2 (общее) - по рекомендации сортировка слиянием
sort_by(Comparator, List) ->
  case List of
    [] -> [];
    [X] -> [X];
    _ ->
      {L1, L2} = split(List, length(List) div 2),
      merge(sort_by(Comparator, L1), sort_by(Comparator, L2), Comparator)
  end.

split(List, N) ->
  split(List, N, []).
split(List, 0, Acc) ->
  {Acc, List};
split([H | T], N, Acc) ->
  split(T, N - 1, Acc ++ [H]).

merge([], L, _) -> L;
merge(L, [], _) -> L;
merge([H1 | T1], [H2 | T2], Comparator) ->
  case Comparator(H1, H2) of
    less ->
      [H1 | merge(T1, [H2 | T2], Comparator)];
    equal ->
      [H1, H2 | merge(T1, T2, Comparator)];
    greater ->
      [H2 | merge([H1 | T1], T2, Comparator)]
  end.

my_comparator(X, Y) ->
  case (X < Y) of
    true -> less;
    false -> case (X > Y) of
               true -> greater;
               false -> equal
             end
  end.

example_of_sort() ->
  sort_by(fun(X, Y) -> my_comparator(X, Y) end, [5, 8, 9, 1, 2, 7, 16, 0, 1]).

%%Вариант 1
%%Задание 1
sum_neg_squares(List) ->
  lists:foldl(fun(X, Acc) -> X * X + Acc end, 0, lists:filter(fun(X) -> (is_number(X) andalso (X < 0)) =:= true end, List)).

%%Задание 2
dropwhile(Pred, [Head | Tail]) ->
  case Pred(Head) of
    true -> dropwhile(Pred, Tail);
    false -> [Head | Tail]
  end.

%%Задание 3
antimap(List, X) ->
  lists:foldl(fun(Fun, Acc) -> Acc ++ [Fun(X)] end, [], List).
%%Пример вызова secondlab:antimap([fun(X)->X*X end, fun(X)->X+1 end, fun(X)->X*2 end], 3).

%%Задание 4
%%Всегда гарантируется, что A>B
solve(Fun, A, B, Eps) ->
  case Fun(A) * Fun(B) >= 0 of
    true -> there_are_no_solutions_in_this_section;
    false ->
      Length = abs(A - B),
      case Length =< Eps of
        true -> B - Length;
        false ->
          Middle = A + Length / 2,
          %%Здесь мы получили границы двух subотрезков
          case Fun(A) * Fun(Middle) < 0 of
            true -> solve(Fun, A, Middle, Eps);
            false -> solve(Fun, Middle, B, Eps)
          end
      end
  end.