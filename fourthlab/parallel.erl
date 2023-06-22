-module(parallel).

-export([par_map/2]).

par_map(F, List) ->
  par_map(F, List, []).

par_map(F, List, Options) ->
  SublistSize = proplists:get_value(sublist_size, Options, 1),
  Processes = proplists:get_value(processes, Options, length(List)),
  Sublists = split_list(List, SublistSize),
  Timeout = proplists:get_value(timeout, Options, infinity),
  Results = start_processes(F, Sublists, Processes, Timeout),
  lists:flatten(Results).

split_list(List, SublistSize) ->
  split_list(List, SublistSize, []).

split_list([], _SublistSize, Acc) ->
  lists:reverse(Acc);
split_list(List, SublistSize, Acc) ->
  {Sublist, Rest} = lists:split(SublistSize, List),
  split_list(Rest, SublistSize, [Sublist | Acc]).

start_processes(F, Sublists, Processes, Timeout) ->
  Pids = lists:map(fun(_) -> spawn_link(fun() -> worker(F) end) end, lists:seq(1, Processes)),
  lists:foreach(fun({Pid, Sublist}) -> Pid ! {self(), Sublist} end, lists:zip(Pids, Sublists)),
  Results = lists:map(fun(_) ->
    receive {Pid, Result} -> Result
    after Timeout -> {error, timeout}
    end end, Pids),
  lists:flatten(Results).

worker(F) ->
  receive
    {Pid, Sublist} ->
      Result = lists:map(F, Sublist),
      Pid ! {self(), Result}
  end.
