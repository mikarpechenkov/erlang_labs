%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2023 7:03 AM
%%%-------------------------------------------------------------------
-module(ring).
-author("mikar").

%% API
-compile(export_all).

ring(N, M) ->
  Pids = create_processes(N),
  start_ring(Pids, M).

create_processes(N) ->
  [spawn(fun() -> process() end) || _ <- lists:seq(1, N)].

process() ->
  receive
    {From, Msg, 0} ->
      io:format("~p received ~p from ~p~n", [self(), Msg, From]),
      From ! {self(), Msg, 0};
    {From, Msg, Count} ->
      io:format("~p received ~p from ~p~n", [self(), Msg, From]),
      Next = spawn(fun() -> process() end),
      Next ! {self(), Msg, Count - 1},
      process()
  end.

start_ring([First | Rest], M) ->
  First ! {First, 0, M},
  loop(Rest ++ [First], M).

loop([], _) ->
  ok;
loop([P | Rest], M) ->
  receive
    {P, 0, 0} ->
      [Proc ! {P, 0, 0} || Proc <- Rest],
      loop([], M - 1);
    {P, Msg, Count} ->
      Next = lists:nthtail(1, Rest),
      Next ! {P, Msg + 1, Count},
      loop(Rest ++ [P], M)
  end.