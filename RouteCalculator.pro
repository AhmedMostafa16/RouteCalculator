domains
i = integer
f = real
s = string
l = integer*
tree = reference t(i, tree, tree)

predicates
nondeterm road(s, s, i, f).
nondeterm path(s, s, i, f).
nondeterm minimum_path(s, s, i, f).
nondeterm distance(s, s, i).
nondeterm hours(s, s, f).
nondeterm sort(l, l).
nondeterm insert(i, tree).
nondeterm instree(l, tree).
nondeterm treemembers(f, tree)

clauses
% Knowledge base of roads information
road(cairo, minya, 200, 3).
road(minya, asyut, 150, 2.5).
road(asyut, sohag, 100, 2).
road(sohag, qena, 80, 1.5).
road(qena, luxor, 60, 1).
road(luxor, aswan, 210, 3.5).

% The paths from point A to point B
path(A, B, Distance, Hours) :-
    road(A, B, Distance, Hours).
path(A, B, Distance, Hours) :-
    road(A, X, Distance1, Hours1),
    path(X, B, Distance2, Hours2),
    Distance = Distance1 + Distance2,
    Hours = Hours1 + Hours2.

% The minimum path from point A to point B
minimum_path(A, B, Distance, Hours) :-
    findall(Path, path(A, B, Path, _), Paths),
    sort(Paths, [Shortest|_]),
    path(A, B, Distance, Hours),
    Distance = Shortest.

% The distance from point A to point B
distance(A, B, Distance) :-
    path(A, B, Distance, _).

% Total traveling hoursfrom point A to B (assuming speed limit for each road)
hours(A, B, Hours) :-
    path(A, B, _, Hours).

% Predicates to sort and check if a list is sorted
% Inspired from the book: https://studylib.net/doc/8096752/visual-prolog-5.2
insert(Val,t(Val,_,_)):- !.
insert(Val,t(Val1,Tree,_)):-
	Val<Val1,!,
	insert(Val,Tree).
insert(Val,t(_,_,Tree)):-
	insert(Val,Tree).
	instree([],_).
instree([H|T],Tree):-
	insert(H,Tree),
	instree(T,Tree).

treemembers(_,T):-
	free(T),!,fail.
treemembers(X,t(_,L,_)):-
	treemembers(X,L).
treemembers(X,t(Refstr,_,_)):-
	X = Refstr.
treemembers(X,t(_,_,R)):-
	treemembers(X,R).

sort(L,L1):-
	instree(L,Tree),
	findall(X,treemembers(X,Tree),L1).

goal
% Example queries

% The paths from Cairo to Aswan
% path(cairo, aswan, Distance, Hours).
% Output: Distance = 600, Hours = 13.5

% The minimum path from Cairo to Aswan
% minimum_path(cairo, aswan, Distance, Hours).
% Output: Distance = 600, Hours = 13.5

% The distance from Cairo to Aswan
% distance(cairo, aswan, Distance).
% Output: Distance = 600

% Total traveling hours from Cairo to Aswan
% hours(cairo, aswan, Hours).
% Output: Hours = 13.5

% Sort a list of distances
% sort([150, 80, 210, 200, 60], Sorted).
% Output: Sorted = [60, 80, 150, 200, 210]


