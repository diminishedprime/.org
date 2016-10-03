%% friends
likes(wallace, cheese).
likes(grommit, cheese).
likes(wendolene, sheep).
friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).
% Queries

% likes(wallace, sheep).
% likes(grommit, cheese).

% friend(wallace, wallace).
% friend(grommit, wallace).
% friend(wallace, grommit).


%% food
food_type(velveeta, cheese).
food_type(ritz, cracker).
food_type(spam, meat).
food_type(sausage, meat).
food_type(jolt, soda).
food_type(twinkie, dessert).
flavor(sweet, dessert).
flavor(savory, meat).
flavor(savory, cheese).
flavor(sweet, soda).
food_flavor(X, Y) :- food_type(X, Z), flavor(Y, Z).
% Queries

% food_type(What, meat).

% food_flavor(sausage, sweet).
% food_flavor(What, savory).

% flavor(sweet, What).

%% map
different(red, green). different(red, blue).
different(green, red). different(green, blue).
different(blue, red). different(blue, green).
coloring(Alabama, Mississippi, Georgia, Tennessee, Florida) :-
    different(Mississippi, Tennessee),
    different(Mississippi, Alabama),
    different(Alabama, Tennessee),
    different(Alabama, Mississippi),
    different(Alabama, Georgia),
    different(Alabama, Florida),
    different(Georgia, Florida),
    different(Georgia, Tennessee).
% Queries

% coloring(Alabama, Mississippi, Georgia, Tennessee, Florida).


%% ohmy
cat(lion).
cat(tiger).
dorothy(X, Y, Z) :- X = lion, Y = tiger, Z = bear.
twin_cats(X, Y) :- cat(X), cat(Y).
% Queries

% dorothy(lion, tiger, bear).
% dorothy(One, Two, Three).

% twin_cats(One, Two).

%% Day 1 Self-Study
% Do

%% Make a simple knowledge base. Represent some of your favorite books and
%% authors.
wrote(the_Fellowship_of_the_Ring, jrr).
wrote(the_Hobbit, jrr).
wrote(the_Martian, andy_weir).

%% Find all books in your knowledge base written by one author.
% wrote(What, jrr).

%% Make a knowledge base representing musicians and instruments. Also represent
%% musicians and their genre of music.
plays(guitar, peter_silberman).
plays(keyboard, darby_cici).
plays(drums, michael).
plays(guitar, pete).
genre(sad, peter_silberman).
genre(sad, darby_cici).
genre(sad, michael).
genre(rock, pete).

%% Find all musicians who play the guitar.
% plays(guitar, Who).
