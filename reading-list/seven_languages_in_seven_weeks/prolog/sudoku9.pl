sudoku(Puzzle, Solution) :-
    length(Puzzle, L),
    Size is floor(sqrt(L)),

    Solution = Puzzle,
    fd_domain(Solution, 1, Size),

    slice(Puzzle, Rows, Size, 'row'),
    slice(Puzzle, Cols, Size, 'col'),
    slice(Puzzle, Squares, Size, 'square'),

    valid(Rows),
    valid(Cols),
    valid(Squares),

    pretty_print(Rows).

valid([]).
valid([Head | Tail]) :- fd_all_different(Head), valid(Tail).

sublist_length([], _).
sublist_length([Head | Tail], Length) :- length(Head, Length), sublist_length(Tail, Length).

nth0(I, List, Out) :- I1 is I + 1, nth(I1, List, Out).

insert_into_slice(Item, Values, X, Y) :-
    nth0(X, Values, Bucket),
    nth0(Y, Bucket, Item).

slice_position('row', Size, I, X, Y) :-
    X is I // Size,
    Y is I mod Size.

slice_position('col', Size, I, X, Y) :-
    X is I mod Size,
    Y is I // Size.

slice_position('square', Size, I, X, Y) :-
    Size_Sqrt is floor(sqrt(Size)),
    X is (I mod Size // Size_Sqrt) + (Size_Sqrt * (I // (Size * Size_Sqrt))),
    Y is (I mod Size_Sqrt) + (Size_Sqrt * ((I mod (Size * Size_Sqrt)) // Size)).

slice(Puzzle, Slice, Size, Type) :- slice(Puzzle, Slice, Size, Type, 0).
slice(_, Slice, Size, _, I) :- I is Size * Size, length(Slice, Size), sublist_length(Slice, Size).
slice([Head | Tail], Slice, Size, Type, I) :-
    slice_position(Type, Size, I, X, Y),
    insert_into_slice(Head, Slice, X, Y),
    I1 is I + 1,
    slice(Tail, Slice, Size, Type, I1).

pretty_print([Head | Tail]) :-
    print(Head),
    print('\n'),
    pretty_print(Tail).

%% | ?- sudoku([5, 3, _, _, 7, _, _, _, _,
%%              6, _, _, 1, 9, 5, _, _, _,
%%              _, 9, 8, _, _, _, _, 6, _,
%%              8, _, _, _, 6, _, _, _, 3,
%%              4, _, _, 8, _, 3, _, _, 1,
%%              7, _, _, _, 2, _, _, _, 6,
%%              _, 6, _, _, _, _, 2, 8, _,
%%              _, _, _, 4, 1, 9, _, _, 5,
%%              _, _, _, _, 8, _, _, 7, 9],
%%             Solution).

%% [5,3,4,6,7,8,9,1,2]
%% [6,7,2,1,9,5,3,4,8]
%% [1,9,8,3,4,2,5,6,7]
%% [8,5,9,7,6,1,4,2,3]
%% [4,2,6,8,5,3,7,9,1]
%% [7,1,3,9,2,4,8,5,6]
%% [9,6,1,5,3,7,2,8,4]
%% [2,8,7,4,1,9,6,3,5]
%% [3,4,5,2,8,6,1,7,9]
