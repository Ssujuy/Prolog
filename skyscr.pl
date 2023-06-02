:-lib(ic).
:-lib(branch_and_bound).


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
       Visible#:: 0..1,
       constrain_skyscr(Hs,Visible,0),
       find_sum(Visible,0,TotalSum),
       TotalSum#=Hl, 
       left_skyscr(Tl, Ts).

left_skyscr([],[]).

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
       Visible#:: 0..1,
       reverse_list(Hs,[],HsReverse),
       constrain_skyscr(HsReverse,Visible,0),
       find_sum(Visible,0,TotalSum),
       TotalSum#=Hr, 
       right_skyscr(Tr, Ts).  

right_skyscr([],[]).

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
       Visible#:: 0..1,
       find_list(Solution,Counter,1,Len,YList),
       constrain_skyscr(YList,Visible,0),
       find_sum(Visible,0,TotalSum),
       TotalSum#=Ht, 
       NCounter is Counter + 1,
       top_skyscr(Tt,NCounter,Solution).

top_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.

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
       Visible#:: 0..1,
       find_list(Solution,Counter,1,Len,YList),
       reverse_list(YList,[],ReversedYList),
       constrain_skyscr(ReversedYList,Visible,0),
       find_sum(Visible,0,TotalSum),
       TotalSum#=Hb, 
       NCounter is Counter + 1,
       bottom_skyscr(Tb,NCounter,Solution).

bottom_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.


constrain_skyscr(L,Visible,0) :-
       [Hv | Tv] = Visible,
       [H | T] = L,
       Hv#=1,
       constrain_skyscr(T,Tv,H).

constrain_skyscr(L,Visible,MaxVar) :-
       MaxVar \= 0,
       [Hv | Tv] = Visible,
       [H | T] = L,
       H #> MaxVar,
       Hv#=1,
       constrain_skyscr(T,Tv,H).

constrain_skyscr(L,Visible,MaxVar) :-
       MaxVar \= 0,
       [Hv | Tv] = Visible,
       [H | T] = L,
       H #< MaxVar,
       Hv#=0,
       constrain_skyscr(T,Tv,MaxVar).

constrain_skyscr([],[],_).


find_sum(Visible,Sum,TotalSum) :-
    [H | T] = Visible,
    NSum #= Sum + H,
    find_sum(T,NSum,TotalSum).

find_sum([],TotalSum,TotalSum).

find_list(Solution,X,Y,Length,YList) :-
       YList = [H | T],
       index_xy(Solution,X,Y,1,1,Target),
       H = Target,
       NY is Y + 1,
       find_list(Solution,X,NY,Length,T).

find_list(_,_,NY,Length,[]) :-  NY > Length.

different_list_y(Solution,Counter) :-
       length(Solution,Len),
       Counter =< Len,
       find_list(Solution,Counter,1,Len,YList),
       unique_element(YList),
       NCounter is Counter + 1,
       different_list_y(Solution,NCounter).

different_list_y(Solution,Counter) :-
       length(Solution,Len),
       Counter > Len.

different_list(Solution) :-
       [H | T] = Solution,
       unique_element(H),
       different_list(T).

different_list([]).

smaller_element(X,L) :-
    L \= [],
    [H | T] = L,
    X #\= H,
    smaller_element(X,T).

smaller_element(_,[]).

unique_element(L) :-
    L \= [],
    [H | T] = L,
    smaller_element(H,T),
    unique_element(T).

unique_element([]).

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

set_length(L,N) :-
       [H | T] = L,
       length(H,N),
       set_length(T,N).

set_length([],_).

reverse_list([],Reversed,Reversed).

reverse_list([H|T],T1,Reversed) :- reverse_list(T,[H|T1],Reversed).

reverse_list([],Z,Z).

puzzle(demo, 5,
       [0,2,0,2,4], [4,0,2,0,0],
       [0,0,0,0,0], [0,3,0,2,0],
       [[_,_,_,_,_],
        [_,_,_,_,_],
        [_,5,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_]]).

puzzle(easy4x4, 4, 
       [3,2,1,3], [1,3,3,2],
       [3,2,2,1], [2,3,1,2],
       [[_,_,_,_],
        [_,_,_,_],
        [_,_,_,_],
        [_,_,_,_]]).

puzzle(normal4x4, 4, 
       [0,0,0,0], [3,0,2,0],
       [0,0,0,0], [0,0,1,2],
       [[_,_,_,_],
        [_,_,_,_],
        [_,_,_,_],
        [_,_,_,_]]).

puzzle(hard4x4, 4, 
       [0,2,2,0], [0,0,0,0],
       [0,0,0,0], [0,2,0,3],
       [[_,_,2,_],
        [_,_,_,_],
        [_,_,4,_],
        [_,_,_,_]]).

puzzle(easy5x5, 5, 
       [5,2,2,1,3], [1,4,2,4,2],
       [4,2,3,2,1], [2,3,1,3,2],
       [[_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_]]).

puzzle(normal5x5, 5, 
       [0,3,0,0,0], [0,0,0,0,4],
       [3,2,0,0,0], [0,0,0,5,3],
       [[_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_]]).

puzzle(hard5x5, 5, 
       [0,2,4,0,0], [0,0,0,3,0],
       [0,0,2,4,0], [0,3,0,0,0],
       [[_,_,_,2,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,_],
        [_,_,_,_,1]]).

puzzle(easy6x6, 6, 
       [2,3,3,1,2,3], [1,2,2,4,3,2],
       [2,4,2,3,2,1], [2,2,2,1,3,3],
       [[_,_,_,_,4,_],
        [_,_,_,_,_,_],
        [_,_,_,_,_,5],
        [_,_,3,_,_,_],
        [_,_,_,3,_,_],
        [3,_,_,_,_,_]]).

puzzle(normal6x6, 6, 
       [0,4,0,3,0,0], [0,0,0,0,5,0],
       [3,1,0,3,0,4], [0,0,0,3,4,0],
       [[_,_,_,_,_,_],
        [_,_,_,_,_,_],
        [_,_,_,1,_,_],
        [_,_,_,_,_,_],
        [_,_,_,_,_,_],
        [_,_,2,_,_,_]]).

puzzle(hard6x6, 6, 
       [4,0,2,0,2,0], [0,3,2,3,0,0],
       [0,2,2,2,4,0], [0,0,0,4,0,3],
       [[_,_,_,_,_,_],
        [_,_,_,_,_,_],
        [_,_,_,_,_,_],
        [_,_,3,_,_,_],
        [_,_,_,_,_,_],
        [_,_,_,_,_,_]]).

puzzle(hard7x7, 7,
       [2,3,0,1,3,2,0], [0,2,0,0,0,0,3],
       [3,0,3,3,0,0,0], [0,0,2,0,3,0,0],
       [[_,1,_,_,_,_,_],
        [_,_,_,_,4,_,_],
        [_,5,_,_,_,_,_],
        [_,_,_,_,_,4,_],
        [_,_,_,_,_,_,_],
        [_,_,_,_,1,_,_],
        [_,_,_,5,_,_,_]]).

puzzle(hard8x8, 8,
       [3,0,4,2,0,3,3,0], [0,0,3,3,5,3,4,0],
       [2,0,0,5,3,0,0,0], [3,0,0,0,4,4,0,0],
       [[_,_,5,_,_,_,_,_],
        [_,4,3,_,_,_,2,_],
        [_,_,_,_,_,_,_,1],
        [_,_,_,_,_,_,_,_],
        [_,_,_,_,_,5,_,2],
        [_,_,_,8,_,_,_,_],
        [_,6,_,_,_,1,4,_],
        [_,_,_,_,_,_,_,_]]).

puzzle(hard9x9, 9,
       [0,0,0,0,1,5,3,0,3], [0,3,3,2,3,0,0,5,0],
       [2,3,0,0,3,4,2,0,3], [3,0,6,4,3,0,2,2,4],
       [[_,_,_,_,_,_,_,_,_],
        [_,1,_,_,_,_,3,_,_],
        [_,_,_,_,1,2,_,_,5],
        [_,_,_,4,2,6,_,_,_],
        [_,_,_,_,_,_,_,1,_],
        [_,_,7,_,_,8,_,_,_],
        [_,_,_,_,_,_,_,3,_],
        [4,_,_,_,_,_,_,_,2],
        [_,_,_,_,_,9,_,_,_]]).