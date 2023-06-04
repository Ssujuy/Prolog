:-lib(gfd).
:-lib(branch_and_bound).

/*All elemetns of solution are constrained here thn search is calle*/

/*Δυστυχώς μου καθυστερεί πολυ για hard 8x8 , 9x9 .
Η υλοποίηση έχει γίνει με ic ροσππάθησα να βάλω gfd και nvalues ,
αλλά η διαφορά στον χρόννο ήταν αππελιστική με το demo να θέλει 40 sec 
για να τρέξει οππότε κράτησα την ic και την παρακάτω υλοποίηση*/

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
       search(Solution,0,most_constrained_per_value,reverse_split,complete,[]),!.


/*constrains the elements of solution with the left list numbers of visible skyscrapers*/

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
       length(Visible,Len),
       find_visible(Hs,Visible,[]),
       nvalues(Visible,(=),Hl), 
       left_skyscr(Tl, Ts).

left_skyscr([],[]).

/*constrains the elements of solution with the right list numbers of visible skyscrapers*/

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
       find_visible(HsReverse,Visible,[]),
       nvalues(Visible,(=),Hr), 
       right_skyscr(Tr, Ts).  

right_skyscr([],[]).

/*constrains the elements of solution with the top list numbers of visible skyscrapers*/

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
       find_visible(YList,Visible,[]),
       nvalues(Visible,(=),Ht),
       NCounter is Counter + 1,
       top_skyscr(Tt,NCounter,Solution).

top_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.

/*constrains the elements of solution with the bottom list numbers of visible skyscrapers*/

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
       find_visible(ReversedYList,Visible,[]),
       nvalues(Visible,(=),Hb),
       NCounter is Counter + 1,
       bottom_skyscr(Tb,NCounter,Solution).

bottom_skyscr([],Counter,Solution) :-
       length(Solution,Len),
       Len < Counter.

/*Constrains the Visible list elements to 1 when it is larger than thee previous elements
and to 0 when not , 1st is always 1*/

find_visible(L,Visible,[]) :-
       [Hv | Tv] = Visible,
       [H | T] = L,
       MaxL=H,
       Hv=H,
       find_visible(T,Tv,MaxL).

find_visible(L,Visible,MaxL) :-
       MaxL \= [],
       [Hv | Tv] = Visible,
       [H | T] = L,
       append(MaxL,H,NMaxL),
       max(NMaxL,Hv),
       find_visible(T,Tv,NMaxL),

find_visible([],[],_).

/*findsthe sum of the list and constrains it*/

find_list(Solution,X,Y,Length,YList) :-
       YList = [H | T],
       index_xy(Solution,X,Y,1,1,Target),
       H = Target,
       NY is Y + 1,
       find_list(Solution,X,NY,Length,T).

find_list(_,_,NY,Length,[]) :-  NY > Length.

/*makes elements of list different*/

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

different_list(Solution) :-
       [H | T] = Solution,
       alldifferent(H),
       different_list(T).

different_list([]).

/*finds element at position X,Y*/

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

/*sets the length of the list L*/

set_length(L,N) :-
       [H | T] = L,
       length(H,N),
       set_length(T,N).

set_length([],_).

/*reverse a list*/

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