-module(day_1).
-export([mirror/1]).
-export([number/1]).
-export([another_factorial/1]).
-export([another_fib/1]).
-export([words_in_string/1]).
-export([count_to_10/0]).
-export([did_it_work/1]).

%% Mirror
mirror(Anything) ->
    Anything.

%% Number
number(one) ->
    1;
number(two) ->
    2;
number(three) ->
    3.

%% factorial
another_factorial(0) ->
    1;
another_factorial(N) ->
    N * another_factorial(N-1).
%% Fibonacci
another_fib(0) ->
    1;
another_fib(1) ->
    1;
another_fib(N) ->
    another_fib(N-1) + another_fib(N-2).

%% Number of words in a string.
words_in_string([]) ->
    0;
words_in_string(N) ->
    words_in_string(N, 1).

words_in_string([], NumWords) ->
    NumWords;
words_in_string([32|Xs], NumWords) ->
    words_in_string(Xs, NumWords + 1);
words_in_string([_|Xs], NumWords) ->
    words_in_string(Xs, NumWords).

count_to_10() ->
    count_to_10(0).
count_to_10(10) ->
    10;
count_to_10(N) ->
    count_to_10(N + 1).

did_it_work({error, Message}) ->
    "error: " ++ Message;
did_it_work(success) ->
    "success".
