dimension(5).

black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).


words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).

temp(L) :-
    length(L,5),
	list_length(L),
    findall([X,Y],black(X,Y),BlackSpots),
	set_black(L,BlackSpots).

set_black(L,BlackSpots) :-
	[H | T] = BlackSpots,
    [Y,X] = H,
    index_xy(L,X,Y,1,1,Target),
    Target = -1,
	set_black(L,T).

set_black(_,[]).

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

list_length(L) :-
    [H | T] = L,
    dimension(Len),
    length(H,Len),
    list_length(T).

list_length([]).
