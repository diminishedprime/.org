-module(clojure).
-export([take_while/2]).
-export([iterate/2]).
-export([range/1]).
-export([map/2]).

%% clojure:take_while(clojure:map(clojure:range(1), fun(X) -> X*X end), fun(X) -> X =< 100 end).
map(GenPair, F) ->
    map(GenPair, F, []).

map({Val, NextFn}, F, Acc) ->
    Current = F(Val),
    {Current, fun () -> map(NextFn(), F, Acc ++ [Current]) end}.

take_while(GenPair, Predicate) ->
    take_while(GenPair, Predicate, []).

take_while({Val, NextFn}, Predicate, Acc) ->
    case Predicate(Val) of
        true -> [Val|take_while(NextFn(), Predicate, Acc)];
        false -> Acc
    end.

iterate(F, N) ->
    Current = F(N),
    {Current, fun () -> iterate(F, F(Current)) end}.

range(N) ->
    {N, fun() -> range(N + 1) end}.

%% clojure:take_while(clojure:range(1), fun(X) -> X < 10 end).
