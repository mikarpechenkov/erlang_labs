-module(bin_tree).
%% API
-compile(export_all).

%% Тип tree
-type tree() :: empty | {node, any(), tree(), tree()}.

-spec empty() -> tree().
empty() -> empty.

-spec node(Data :: any(), Left :: tree(), Right :: tree()) -> tree(). %% возвращает непустое дерево с данными Data, левым наследником Left и правым наследником Right
node(Data, Left, Right) -> {node, Data, Left, Right}.

-spec view(tree()) -> 'empty' | {'node', any(), tree(), tree()}. %% возвращает атом empty, если дерево пусто, и кортеж {node, Data, Left, Right}, если оно непусто, и содержит данные Data, левое поддерево Left и правое поддерево Right
view(Tree) -> Tree.


%%Вариант 1
%%Задание 1
-spec split(tree(), any()) -> {tree(), tree()}.

%%Реализация
split(Tree, X) ->
  case view(Tree) of
    empty -> {empty, empty};
    {node, Data, Left, Right} ->
      case compare(Data, X) of
        less -> {NodeLT, TreeGT} = split(Right, X),
          {node(Data, Left, NodeLT), TreeGT};
        greater -> {NodeLT, TreeGT} = split(Left, X),
          {NodeLT, node(Data, TreeGT, Right)};
        equal -> {Left, Right}
      end
  end.

compare(Data, X) when Data == X -> equal;
compare(Data, X) when Data < X -> less;
compare(Data, X) when Data > X -> greater.

% Пример использования
split_example() ->
  Tree = {node, 5,
    {node, 3, {node, 2, empty, empty}, {node, 4, empty, empty}},
    {node, 8, {node, 7, empty, empty}, {node, 9, empty, empty}}
  },
  X = 6,
  {TreeLT, TreeGT} = split(Tree, X),
  io:format("TreeLT: ~p~n", [TreeLT]),
  io:format("TreeGT: ~p~n", [TreeGT]).
