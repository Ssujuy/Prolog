:-lib(gfd).
:-lib(branch_and_bound).

/*Κατάφερα να κάνω την υλοποίηση με gfd και nvalues 
Το Puzzle hard9x9 τρέχει 1,11 sec*/


/*
Take the puzzle id and Take the constraints for the number of visible scryscrapers, for each size.
All elements of Solution are constrained here then search is called*/

skyscr(Id, Solution) :-
       puzzle(Id, Max, Left, Right, Top, Bottom , Board),
       Solution = Board,
       Solution#:: 1..Max,
       different_list(Solution),
       different_list_y(Solution,1),
       left_skyscr(Left, Solution),
       right_skyscr(Right, Solution),
       top_skyscr(Top,1,Solution),
       bottom_skyscr(Bottom,1,Solution),
       search(Solution,0,most_constrained ,indomain,complete,[]),!.

/*Constrain the visible scyscrapers from the left side.
Create a visible list which is the max of every Solution , starting from x1 , x1,x2 , etc.
Then constrain the number of maximum different max number to be Hl*/

left_skyscr(Left, Solution) :-
       [Hl | Tl] = Left,
       [_ | Ts] = Solution,
       Hl = 0,
       left_skyscr(Tl, Ts).

left_skyscr(Left, Solution) :-
       [Hl | Tl] = Left,
       [Hs | Ts] = Solution,
       Hl \= 0,
       length(Hs, Len),
       length(Visible, Len),
       constrain_skyscr(Hs,Visible,0),
       nvalues(Visible, (#=), Hl), 
       left_skyscr(Tl, Ts).

left_skyscr([],[]).

/*Constrain the visible scyscrapers from the right side.
Note : That the Solution list is reversed!
Create a visible list which is the max of every Solution , starting from x1 , x1,x2 , etc.
Then constrain the number of maximum different max number to be Hr*/

right_skyscr(Right, Solution) :-
       [Hr | Tr] = Right,
       [_ | Ts] = Solution,
       Hr = 0,
       right_skyscr(Tr, Ts).

right_skyscr(Right, Solution) :-
       [Hr | Tr] = Right,
       [Hs | Ts] = Solution,
       Hr \= 0,
       length(Hs, Len),
       length(Visible, Len),
       reverse_list(Hs,[],HsReverse),
       constrain_skyscr(HsReverse,Visible,0),
       nvalues(Visible, (#=), Hr), 
       right_skyscr(Tr, Ts).  

right_skyscr([],[]).

/*Constrain the visible scyscrapers from the top side.
Note : The list is found with find_list , which takes a static x each time and increases y.
Create a visible list which is the max of every Solution , starting from x1 , x1,x2 , etc.
Then constrain the number of maximum different max number to be Hl*/

top_skyscr(Top, Counter, Solution) :-
       [Ht | Tt] = Top,
       Ht = 0,
       NCounter is Counter + 1,
       top_skyscr(Tt,NCounter,Solution).

top_skyscr(Top, Counter,Solution) :-
       [Ht | Tt] = Top,
       Ht \= 0,
       length(Solution, Len),
       length(Visible, Len),
       find_list(Solution,Counter,1,Len,YList),
       constrain_skyscr(YList,Visible,0),
       nvalues(Visible, (#=), Ht),
       NCounter is Counter + 1,
       top_skyscr(Tt,NCounter,Solution).

top_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.

/*Constrain the visible scyscrapers from the bottom side.
Note : The list is found with find_list , which takes a static x each time and increases y.
Then the list found is reversed , because it is for the bottom side.
Create a visible list which is the max of every Solution , starting from x1 , x1,x2 , etc.
Then constrain the number of maximum different max number to be Hl*/

bottom_skyscr(Bottom, Counter, Solution) :-
       [Hb | Tb] = Bottom,
       Hb = 0,
       NCounter is Counter + 1,
       bottom_skyscr(Tb,NCounter,Solution).

bottom_skyscr(Bottom, Counter,Solution) :-
       [Hb | Tb] = Bottom,
       Hb \= 0,
       length(Solution, Len),
       length(Visible, Len),
       find_list(Solution,Counter,1,Len,YList),
       reverse_list(YList,[],ReversedYList),
       constrain_skyscr(ReversedYList,Visible,0),
       nvalues(Visible, (#=), Hb),
       NCounter is Counter + 1,
       bottom_skyscr(Tb,NCounter,Solution).

bottom_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.

/*Constrains every Visible list variable (Hv), to be the max of every H variable and all
the max of all the previous ones.*/

constrain_skyscr(L,Visible,0) :-
       [Hv | Tv] = Visible,
       [H | T] = L,
       Hv=H,
       constrain_skyscr(T,Tv,H).

constrain_skyscr(L,Visible,MaxVar) :-
       MaxVar \= 0,
       [Hv | Tv] = Visible,
       [H | T] = L,
       NMax#=max(MaxVar,H),
       Hv=NMax,
       constrain_skyscr(T,Tv,NMax).

constrain_skyscr([],[],_).

/*Basically finds the list with a static x index
and an index y which starts from 1 to Length*/

find_list(Solution,X,Y,Length,YList) :-
       YList = [H | T],
       index_xy(Solution,X,Y,1,1,Target),
       H = Target,
       NY is Y + 1,
       find_list(Solution,X,NY,Length,T).

find_list(_,_,NY,Length,[]) :-  NY > Length.

/*Makes column elements of list different*/

different_list_y(Solution,Counter) :-
       length(Solution,Len),
       Counter =< Len,
       find_list(Solution,Counter,1,Len,YList),
       alldifferent(YList),
       NCounter is Counter + 1,
       different_list_y(Solution,NCounter).

different_list_y(Solution,Counter) :-
       length(Solution,Len),
       Counter > Len.

/*Makes rows elemnts of list different*/

different_list(Solution) :-
       [H | T] = Solution,
       alldifferent(H),
       different_list(T).

different_list([]).

/*Find element at index x,y . Call index_y to find column of element then index_y to find the element*/

index_xy(L,X,Y,XCounter,YCounter,Target) :-
       index_y(L,Y,YCounter,YL),
       index_x(YL,X,XCounter,Target).

index_x(L,X,XCounter,Target) :-
       XCounter < X,
       [_ | T] = L,
       NXCounter is XCounter + 1,
       index_x(T,X,NXCounter,Target).

index_x([H | _],Y,Y,H).

index_y(L,Y,YCounter,Target) :-
       YCounter < Y,
       [_ | T] = L,
       NYCounter is YCounter + 1,
       index_y(T,Y,NYCounter,Target).

index_y([H | _],Y,Y,H).

/*Reverse a list*/

reverse_list([],Reversed,Reversed).

reverse_list([H|T],T1,Reversed) :- reverse_list(T,[H|T1],Reversed).

reverse_list([],Z,Z).
