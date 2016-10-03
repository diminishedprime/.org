-module(day_2).
-export([double_all/1]).
-export([map/2]).
-export([get/2]).
-export([analyze_board/1]).

double_all([]) ->
    [];
double_all([First|Rest]) ->
    [First * 2 | double_all(Rest)].

map(F, L) -> [ F(X) || X <- L].

%% Do:

%% Consider a list of keyword-value tuples, such as [{erlang, "a functional
%% language"}, {ruby, "an OO language"}]. Write a function that accepts the list
%% and a keyword and returns the associated value for the keyword.
get([], _) ->
    error;
get([{Language, Value} | Xs], Keyword) ->
    if
        Language == Keyword -> Value;
        true -> get(Xs, Keyword)
    end.

%% day_2:get([{erlang, "a functional language"}, {ruby, "an OO language"}], erlang).
%% day_2:get([{erlang, "a functional language"}, {ruby, "an OO language"}], clojure).
%% day_2:get([{erlang, "a functional language"}, {ruby, "an OO language"}], ruby).


%% Consider a shopping list that looks like [{item, quantity, price}, ...].
%% Write a list comprehension that builds a list of items of the form [{item,
%% total_price}, ...], where total_price is quantity times price.

%% [{Item, Quantity * Price} || {Item, Quantity, Price} <- [{pencil,4,0.25},{pen,1,1.2},{paper,2,0.2}]].

%% Bonus problem:

%% Write a program that reads a tic-tac-toe board presented as a list or a tuple
%% of size nine. Return the winner (x or o) if a winner has been determined, cat
%% if there are no more possible moves, or no_winner if no player has won yet.
analyze_board(Gamestate) ->
    case Gamestate of

        [X, X, X,
         _, _, _,
         _, _, _] -> X;

        [_, _, _,
         X, X, X,
         _, _, _] -> X;

        [_, _, _,
         _, _, _,
         X, X, X] -> X;

        [X, _, _,
         X, _, _,
         X, _, _] -> X;

        [_, X, _,
         _, X, _,
         _, X, _] -> X;

        [_, _, X,
         _, _, X,
         _, _, X] -> X;

        [X, _, _,
         _, X, _,
         _, _, X] -> X;

        [_, _, X,
         _, X, _,
         X, _, _] -> X;

        _ -> case list:any(fun(X) -> X == " " end, Gamestate) of
                 true -> cat;
                 false -> no_winner
             end
    end.


%% day_2:analyze_board(["X", "X", "O",
%%                      "X", "O", "O",
%%                      "X", "O", "X"])
