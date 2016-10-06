%%% (1,2,3) = (1,2,3).
% yes

%%% (1,2,3) = (1,2,3,4).
% no

%%% (1,2,3) = (3,2,1).
% no

%%% (A,B,C) = (1,2,3).
% A = 1
% B = 2
% C = 3

%%% (1,2,3) = (A,B,C).
% A = 1
% B = 2
% C = 3

%%% (A,2,C) = (1,B,3).
% A = 1
% B = 2
% C = 3

%%% [1, 2, 3] = [1, 2, 3].
%yes

%%% [1, 2, 3] = [X, Y, Z].
% X = 1
% Y = 2
% Z = 3

%%% [2, 2, 3] = [X, X, Z].
% X = 2
% Z = 3

%%% [1, 2, 3] = [X, X, Z].

%%% [] = [].

%%% [a, b, c] = [Head|Tail].
% Head = a
% Tail = [b,c]

%%%% Using Rules in Both Directions

%%% append([oil], [water], [oil, water]).
% yes

%%% append([oil], [water], [oil, slick]).
% no

%%% append([tiny], [bubbles], What).
% What = [tiny,bubbles]

%%% append([dessert_topping], Who, [dessert_topping, floor_wax]).
% Who = [floor_wax]


%%% append(One, Two, [apples, oranges, bananas]).
% One = []
% Two = [apples,oranges,bananas]

% One = [apples]
% Two = [oranges,bananas]

% One = [apples,oranges]
% Two = [bananas]

% One = [apples,oranges,bananas]
% Two = []

%%% Reverse a List
reverse(L,R):-  reverse(L,[],R).
reverse([H|T],A,R) :-
    reverse(T,[H|A],R).
reverse([],A,A).

% reverse([1,2,3],What).

%%% Find the smallest element of a List.
min([H|T], Min) :-
    min(T, H, Min).
min([], Min, Min).
min([H|T], Min0, Min) :-
    Min1 is min(H, Min0),
    min(T, Min1, Min).

% min([1,2,3,4], What).
% min([4,3,2,1], What).

%%% Sort the elements of a List.
quicksort([X|Xs],Ys) :-
    split(Xs,X,Left,Right),
    quicksort(Left,Ls),
    quicksort(Right,Rs),
    append(Ls,[X|Rs],Ys).
quicksort([],[]).

split([X|Xs],Y,[X|Ls],Rs) :-
    X @=< Y,
    split(Xs,Y,Ls,Rs).
split([X|Xs],Y,Ls,[X|Rs]) :-
    X @> Y,
    split(Xs,Y,Ls,Rs).
split([],Y,[],[]).

% quicksort([3,2,10,1], What).
% quicksort([1,2,3,4], What).
