%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2023 7:41 AM
%%%-------------------------------------------------------------------
-module(secondtask).
-author("mikar").

-export([start/1, send_to_child/2, stop/0]).

start(N) ->
  Parent = self(),
  Pids = create_children(N, Parent),
  loop(Pids, Parent).

create_children(N, Parent) ->
  [spawn_link(fun() -> child(Parent) end) || _ <- lists:seq(1, N)].

child(Parent) ->
  receive
    stop ->
      ok;
    die ->
      exit(error);
    Msg ->
      io:format("Child ~p received: ~p~n", [self(), Msg]),
      child(Parent)
  end.

loop(Pids, Parent) ->
  receive
    {Parent, Msg} ->
      lists:foreach(fun(Pid) -> Pid ! Msg end, Pids),
      loop(Pids, Parent);
    {Child, {'EXIT', Pid, Reason}} ->
      io:format("Child ~p died with reason: ~p~n", [Child, Reason]),
      NewPid = spawn_link(fun() -> child(Parent) end),
      loop(replace_child(Pid, NewPid, Pids), Parent)
  end.

replace_child(OldPid, NewPid, Pids) ->
  lists:map(fun(Pid) -> if Pid =:= OldPid -> NewPid; true -> Pid end end, Pids).

send_to_child(I, Msg) ->
  Parent = self(),
  Parent ! {Parent, {I, Msg}}.

stop() ->
  exit(normal).

