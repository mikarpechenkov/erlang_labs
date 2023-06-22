-module(counter).
%% API
-export([start/0, incr/0, stop/0, loop/1]).

start() ->
  CounterPid = spawn(counter, loop, [0]),
  register(counter_server, CounterPid),
  ok.

incr() ->
  counter_server ! {increment, self()},
  receive
    {counter_value, Value} ->
      io:format("Send to  value (now ~w)~n", [Value])
  end.

stop() ->
  counter_server ! stop,
  receive
    {counter_value, Value} ->
      io:format("Stopped! Current counter value is ~w~n", [Value])
  end.

loop(Value) ->
  receive
    {increment, Pid} ->
      NewValue = Value + 1,
      io:format("Incremented counter value (now ~w)~n", [NewValue]),
      Pid ! {counter_value, NewValue},
      loop(NewValue);
    stop ->
      io:format("Stopped! Current counter value is ~w~n", [Value]),
      exit(normal)
  end.