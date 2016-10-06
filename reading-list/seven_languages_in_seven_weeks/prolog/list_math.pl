count(0, []).
count(Count, [_Head|Tail]) :-
    count(TailCount, Tail),
    Count is TailCount + 1.

sum(0, []).
sum(Total, [Head|Tail]) :-
    sum(Sum, Tail),
    Total is Head + Sum.

average(Average, List) :-
    sum(Sum, List),
    count(Count, List),
    Average is Sum/Count.

%% count(What, [1]).

%% sum(What, [1,2,3]).
% What = 6

%% average(What, [1, 2, 3]).
% What  = 2.0
