-module(parent_children).
-export([start/1, send_to_child/2, stop/0]).

%% Запускает процесс-родитель и N процессов-детей
start(N) ->
  %% Спавним процесс-родитель и получаем его PID
  Parent = spawn(fun() -> parent(N) end),
  io:format("Parent process started: ~p~n", [Parent]),
  Parent.

%% Посылает сообщение родителю, который затем пересылает его детям
send_to_child(I, Msg) ->
  Parent = self(),
  Parent ! {send_to_child, I, Msg}.

%% Останавливает родителя
stop() ->
  Parent = self(),
  Parent ! stop.

%% Функция процесса-родителя
parent(N) ->
  io:format("Parent process (~p) started~n", [self()]),
  %% Создаем N дочерних процессов и получаем их PIDs
  Children = lists:map(fun(I) -> spawn(fun() -> child(I) end) end, lists:seq(1, N)),
  %% Мониторим дочерние процессы
  monitor_children(Children).

%% Функция процесса-ребенка
child(I) ->
  io:format("Child process (~p) started~n", [self()]),
  receive
    stop ->
      io:format("Child process (~p) stopped~n", [self()]);
    die ->
      erlang:error("Child process (~p) died~n", [self()]);
    {send_to_child, I, Msg} ->
      io:format("Child process (~p) received message ~p from parent~n", [self(), Msg]),
      ok;
    _ ->
      io:format("Child process (~p) received unknown message~n", [self()]),
      ok
  end.

%% Мониторинг дочерних процессов
monitor_children(Children) ->
  receive
    {'DOWN', _, _, Child, _} ->
      io:format("Child process (~p) died~n", [Child]),
      %% Перезапускаем дочерний процесс, который упал
      NewChild = spawn(fun() -> child(find_child_index(Children, Child)) end),
      io:format("New child process (~p) started~n", [NewChild]),
      %% Заменяем упавший процесс новым в списке дочерних процессов
      monitor_children(replace_child(Children, Child, NewChild));
    stop ->
      io:format("Parent process stopped~n", []),
      %% Останавливаем все дочерние процессы
      stop_children(Children)
  end.

%% Находим индекс дочернего процесса в списке
find_child_index(Children, Child) ->
  find_child_index(Children, Child, 1).

find_child_index([Child|_], Child, Index) ->
  Index;
find_child_index([_|T], Child, Index) ->
  find_child_index(T, Child, Index + 1).

%% Заменяем упавший процесс новым в списке
replace_child(Children, OldChild, NewChild) ->
  replace_child(Children, OldChild, NewChild, []).

replace_child([], _, _, Acc) ->
  lists:reverse(Acc);
replace_child([OldChild|T], OldChild, NewChild, Acc) ->
  replace_child(T, OldChild, NewChild, [NewChild|Acc]);
replace_child([H|T], OldChild, NewChild, Acc) ->
  replace_child(T, OldChild, NewChild, [H|Acc]).

%% Останавливаем все дочерние процессы
stop_children(Children) ->
  lists:foreach(fun(Child) -> Child ! stop end, Children).