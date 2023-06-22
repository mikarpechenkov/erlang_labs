%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Jun 2023 4:28 AM
%%%-------------------------------------------------------------------
-module(set).
-author("mikar").

%% API
-compile(export_all).

%%Вариант 1
%%Задание 2, 4

%%Тип set
-type set() :: [any()].

%% Конструктор: Создание пустого множества
-spec empty_set() -> set().
empty_set() -> [].

%% Конструктор: Добавление элементов в множество
-spec add_all(Set :: set(), Elements :: list()) -> set().
add_all(Set, [_]) ->
  case is_set(Set) of
    true -> Set
  end;
add_all(Set, Elements) ->
  case is_set(Set) of
    true ->
      [Head | _] = Elements,
      add(Set, Head)
  end.

%%Конструктор: Добавление элемента во множество
-spec add(Set :: set(), Element :: any) -> set().
add(Set, Element) ->
  case (is_set(Set)) of
    true -> case is_member(Element, Set) of
              true -> Set;
              false -> [Element | Set]
            end
  end.

%% Предикат: Проверка, является ли произвольное значение множеством
-spec is_set(any()) -> boolean().
is_set(Set) -> Set =:= lists:usort(Set).

%% Предикат: Проверка, является ли множество пустым
-spec is_empty(any()) -> boolean().
is_empty(Set) -> Set == [].

%% Функция: Получение количества элементов в множестве
-spec size_set(set()) -> integer().
size_set(Set) -> case is_set(Set) of true -> length(Set) end.

%% Функция: Удаление элемента из множества
-spec remove(Set :: set(), Element :: any()) -> set().
remove(Set, Element) -> case is_set(Set) of true -> lists:delete(Element, Set) end.

%% Предикат: Проверка, является ли элемент членом множества
-spec is_member(Set :: set(), Element :: any()) -> boolean().
is_member(Set, Element) -> case is_set(Set) of true -> lists:member(Element, Set) end.

%%=================================================================================================%%
%%Задание 3
-spec is_subset(set(), set()) -> boolean().
is_subset(Set1, Set2) ->
  case is_set(Set1) and is_set(Set2) of
    true -> case length(Set1) < length(Set2) of
              true -> lists:all(fun(X) -> is_member(Set2, X) end, Set1);
              false -> lists:all(fun(X) -> is_member(Set1, X) end, Set2)
            end
  end.