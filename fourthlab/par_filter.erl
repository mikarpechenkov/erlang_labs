%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2023 7:57 AM
%%%-------------------------------------------------------------------
-module(par_filter).
-author("mikar").

%% API
-compile(export_all).

par_filter(F, List, _Options) ->
  Filtered = lists:map(fun(Elem) -> F(Elem) end, List),
  lists:zipwith(fun(Elem, Keep) -> case Keep of true -> Elem; false -> skip end end, List, Filtered).

main() ->
  List = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
  Filtered = par_filter:par_filter(fun par_filter:is_even/1, List, []),
  io:format("~p~n", [Filtered]).

is_even(Num) ->
  Num rem 2 =:= 0.

