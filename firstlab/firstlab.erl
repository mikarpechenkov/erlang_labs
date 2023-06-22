%%%-------------------------------------------------------------------
%%% @author mikar
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 20. May 2023 5:24 PM
%%%-------------------------------------------------------------------
-module(firstlab).
-compile(export_all).
-import(math, [pi/0]).

%%Первое задание – общее
intersect(List1, List2) -> [X || X <- List1, Y <- List2, X =:= Y].

%%Вариант 1
%%Задание 1
ball_volume(R) -> 4 / 3 * math:pi() * pow(R, 3).

pow(_, Exponent) when Exponent =:= 0 -> 1;
pow(Base, Exponent) when Exponent < 0 -> 1 / Base * pow(Base, Exponent + 1);
pow(Base, Exponent) when Exponent > 0 -> Base * pow(Base, Exponent - 1).


%%Задание 2
from_to(From, To) when From =:= To -> [From];
from_to(From, To) when From < To -> [From] ++ from_to(From + 1, To);
from_to(From, To) when From > To -> [From] ++ from_to(From - 1, To).

%%Задание 3
delta([Head | Tail]) ->
  [Head] ++ delta(Tail, Head).
delta([], _) -> [];
delta([Head | Tail], Previous) ->
  [Head - Previous] ++ delta(Tail, Head).

%%Задание 4
int_to_binary(0) -> "";
int_to_binary(Number) ->
  int_to_binary(Number div 2) ++ [Number rem 2].

%%Задание 5
rle_encode([Head | Tail]) ->
  rle_encode(Tail, Head, 1).
rle_encode([], Previous, Count) ->
  case Count > 1 of
    true -> [{Previous, Count}];
    false -> [Previous]
  end;
rle_encode([Head | Tail], Previous, Count) ->
  case Head =:= Previous of
    true -> rle_encode(Tail, Head, Count + 1);
    false ->
      case Count > 1 of
        true -> [{Previous, Count} | rle_encode(Tail, Head, 1)];
        false -> [Previous | rle_encode(Tail, Head, 1)]
      end
  end.

%%День недели
is_date(Day, Month, Year) ->
  case is_valid_date(Day, Month, Year) of
    true -> StartDayOfWeek = 5,
      DaysSinceStart = count_days(1, 1, 2000, Day, Month, Year),
      (StartDayOfWeek + DaysSinceStart) rem 7 + 1;
    _ -> "Invalid date"
  end.

is_valid_date(Day, Month, Year) when is_integer(Day), is_integer(Month), is_integer(Year) ->
  case {Day > 0, (Month > 0) and (Month < 13), Year > 0} of
    {true, true, true} ->
      Day =< days_in_month(Month, Year);
    _ -> false
  end.

is_leap_year(Year) ->
  (Year rem 4 == 0 andalso Year rem 100 /= 0) orelse Year rem 400 == 0.

days_in_month(Month, Year) ->
  case Month of
    1 -> 31;
    2 -> case is_leap_year(Year) of
           true -> 29;
           _ -> 28 end;
    3 -> 31;
    4 -> 30;
    5 -> 31;
    6 -> 30;
    7 -> 31;
    8 -> 31;
    9 -> 30;
    10 -> 31;
    11 -> 30;
    12 -> 31
  end.

%%Когда даты равны
count_days(Day, Month, Year, Day, Month, Year) -> 0;
count_days(Day, Month1, Year1, Day, Month2, Year2) ->
  {MinMonth, MinYear, MaxMonth, MaxYear} = min_max_resolver(Month1, Year1, Month2, Year2),
  case MinMonth + 1 > 12 of
    true -> days_in_month(MinMonth, MinYear) + count_days(Day, 1, MinYear + 1, Day, MaxMonth, MaxYear);
    _ -> days_in_month(MinMonth, MinYear) + count_days(Day, MinMonth + 1, MinYear, Day, MaxMonth, MaxYear)
  end;
count_days(Day1, Month1, Year1, Day2, Month2, Year2) ->
  abs(Day2 - Day1) + count_days(max(Day1, Day2), Month1, Year1, max(Day1, Day2), Month2, Year2).

min_max_resolver(Month1, Year, Month2, Year) when Month1 < Month2 ->
  {Month1, Year, Month2, Year};
min_max_resolver(Month1, Year, Month2, Year) when Month2 =< Month1 ->
  {Month2, Year, Month1, Year};
min_max_resolver(Month1, Year1, Month2, Year2) when Year1 < Year2 ->
  {Month1, Year1, Month2, Year2};
min_max_resolver(Month1, Year1, Month2, Year2) when Year2 =< Year1 ->
  {Month2, Year2, Month1, Year1}.