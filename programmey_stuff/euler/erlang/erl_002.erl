-module(erl_002).
-export([solve/0]).
-export([fib_gold/1]).

solve() ->
    io:format("Solving with naive fib~n", []),
    my_timer:time_call(fun() -> even_fibs_under_4_million(fun naive_fib/1) end),
    io:format("~nSolving with list fib~n", []),
    my_timer:time_call(fun() -> even_fibs_under_4_million(fun fib_list/1) end),
    io:format("~nSolving with golden ration fib~n", []),
    my_timer:time_call(fun() -> even_fibs_under_4_million(fun fib_gold/1) end).

even_fibs_under_4_million(FibFn) ->
    Integers = clojure:range(1),
    Fibs = clojure:map(Integers, FibFn),
    SmallEnough = clojure:take_while(Fibs, fun (X) -> X =< 4000000 end),
    Evens = lists:filter(fun(X) -> X rem 2 =:= 0 end, SmallEnough),
    Summation = lists:sum(Evens),
    io:format("Answer was: ~p~n", [Summation]).

%% Naive Fib
naive_fib(0) -> 0;
naive_fib(1) -> 1;
naive_fib(N) -> naive_fib(N - 1) + naive_fib(N - 2).

%% Fib Using List
fib_list(0) -> 0;
fib_list(1) -> 1;
fib_list(N) ->
    fib_list(N + 1, [1,0]).

fib_list(End, [H|_]=L) when length(L) == End -> H;
fib_list(End, [A,B|_]=L) ->
    fib_list(End, [A+B|L]).

%% Golden Ration Voodoo
floor(X) when X < 0 ->
    T = trunc(X),
    case X - T == 0 of
        true -> T;
        false -> T - 1
    end;
floor(X) ->
    trunc(X).

fib_gold(N) ->
    Sqrt_5 = math:sqrt(5),
    P_Phi = (Sqrt_5 + 1) / 2,
    No_Round = (math:pow(P_Phi, N) - math:pow(-P_Phi, -N)) / Sqrt_5,
    floor(No_Round).
