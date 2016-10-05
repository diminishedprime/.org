-module(erl_001).
-export([solve/0]).

solve() ->
    my_timer:time_call(fun multiples/0).

multiples() ->
    Range = lists:seq(1,1000),
    Filtered = [X || X <- Range,
                     (X rem 3 == 0) or (X rem 5 == 0)],
    Total = lists:foldl(fun(A, B) -> A + B end, 0, Filtered),
    io:format("The Total is ~p~n", [Total]).
