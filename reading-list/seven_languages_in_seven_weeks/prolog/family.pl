father(zeb, john_boy_sr).
father(john_boy_sr, john_boy_jr).

ancestor(X, Y) :-
    father(X, Y).
ancestor(X, Y) :-
    father(X,Z), ancestory(Z, Y).

%% ancestor(john_boy_sr, john_boy_jr).
%% ancestor(zeb, john_boy_jr).
%% ancestor(zeb, Who).
%% ancestor(Who, john_boy_jr).
