%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2023 6:07 AM
%%%-------------------------------------------------------------------
-module(set_v2).
-author("mikar").

%% API
-compile(export_all).

%%Вариант 1
%%Задание 4

%%Тип set
-type set() :: [any()].

%% Конструктор: Создание пустого множества
-spec empty_set() -> set().
empty_set() -> [].

%% Конструктор: Добавление элементов в множество
-spec add_all(Set :: set(), Elements :: list()) -> set().
add_all(Set, Elements) ->
  lists:usort(Set ++ Elements).

%%Конструктор: Добавление элемента во множество
-spec add(Set :: set(), Element :: any) -> set().
add(Set, Element) ->
  lists:usort([Element | Set]).

%% Предикат: Проверка, является ли произвольное значение множеством
-spec is_set(any()) -> boolean().
is_set(Set) ->
  Map = hash_table(Set, maps:new()),
  lists:all(fun(X) -> maps:get(X, Map) == 1 end, Set).

hash_table([], Map) -> Map;
hash_table([Head | Tail], Map) ->
  case maps:is_key(Head, Map) of
    true -> NewMap = maps:put(Head, maps:get(Head, Map) + 1, Map);
    _ -> NewMap = maps:put(Head, 1, Map)
  end,
  hash_table(Tail, NewMap).

%% Предикат: Проверка, является ли множество пустым
-spec is_empty(any()) -> boolean().
is_empty([]) -> true;
is_empty(_) -> false.
%% Функция: Получение количества элементов в множестве
-spec size_set(set()) -> integer().
size_set([]) -> 0;
size_set(Set) ->
  case is_set(Set) of
    true -> [_ | Tail] = Set,
      size_set(Tail) + 1
  end.

%% Функция: Удаление элемента из множества
-spec remove(Set :: set(), Element :: any()) -> set().
remove([], _) -> [];
remove(Set, Element) ->
  case is_set(Set) of
    true ->
      [Head | Tail] = Set,
      case Head =:= Element of
        true -> Tail;
        false -> [Head] ++ remove(Tail,Element)
      end
  end.

%% Предикат: Проверка, является ли элемент членом множества
  -spec is_member(Set :: set(), Element :: any()) -> boolean().
is_member([], _) -> false;
is_member(Set, Element) ->
  case is_set(Set) of
    true ->
      [Head | Tail] = Set,
      Head =:= Element or is_member(Tail, Element)
  end.