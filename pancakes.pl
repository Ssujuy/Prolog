pancakes_dfs(InitialState, Operators, States) :-
    spatula(InitialState,1,States,NewState,Op),
    [H1 | T1] = States,
    [H2 | T2] = Operators,
    H1 = NewState,
    H2 = Op,
    pancakes_dfs(InitialState, T2, T1).

pancakes_dfs(InitialState,[],[H | T]) :- 
    T = [] ,
    length(InitialState,N),
    ordered_list(N,1,L),
    H = L.

spatula(InitialState,_,States,CurrentState,_) :-
    [H | T] = States,
    T = [],
    length(InitialState,Len),
    ordered_list(Len,1,L),
    H = L,
    CurrentState = L.
    

spatula(InitialState,N,States,CurrentState,N) :-
    length(InitialState,Len),
    NLen is Len - 1,
    N =< NLen,
    flip(CurrentState,N,NewState),
    NewState \= InitialState,
    in_States(NewState,States),
    spatula(InitialState,1,States,NewState,1).

    
spatula(InitialState,N,States,CurrentState,N) :-
    length(InitialState,Len),
    NLen is Len - 1,
    N =< NLen,
    NN is N + 1,
    spatula(InitialState,NN,States,CurrentState,NN).

flip(InitialState,N,NewState) :-
    length(InitialState,Len),
    N < Len,
    split_list(InitialState,Len,N,1,Top,Bottom),
    reverse_list(Top,[],Reversed),
    concatenate_list(Bottom,Reversed,NewState).

in_States(_,[]).

in_States(CurrentState,States) :-
    [H | T] = States,
    CurrentState \= H,
    in_States(CurrentState,T).

split_list([],Len,_,Counter,[],[]) :-
    Counter > Len.

split_list(InitialState,Len,_,Counter,Top,Bottom) :- 
    Counter = Len,
    [H1 | T1] = InitialState,
    [H2 | T2] = Top,
    H1 = H2,
    NCounter is Counter + 1,
    split_list(T1,Len,_,NCounter,T2,Bottom).

split_list(InitialState,Len,N,Counter,Top,Bottom) :-
    Counter < Len,
    Counter >= N,
    [H1 | T1] = InitialState,
    [H2 | T2] = Top,
    H2 = H1,
    NCounter is Counter + 1,
    split_list(T1,Len,N,NCounter,T2,Bottom).

split_list(InitialState,Len,N,Counter,Top,Bottom) :-
    Counter < Len,
    Counter < N,
    [H1 | T1] = InitialState,
    [H2 | T2] = Bottom,
    H2 = H1,
    NCounter is Counter + 1,
    split_list(T1,Len,N,NCounter,Top,T2).

ordered_list(Len,Counter,Ordered) :-
    Counter =< Len,
    [H | T] = Ordered,
    H = Counter,
    NCounter is Counter + 1,
    ordered_list(Len,NCounter,T).

ordered_list(Len,Counter,[]) :- Len < Counter.

concatenate_list([],[],[]). 

concatenate_list([],Top,Concat) :-
    [H1 | T1] = Top,
    [H2 | T2] = Concat,
    H2 = H1,
	concatenate_list([],T1,T2).  

concatenate_list(Bottom,Top,Concat) :-
    [H1 | T1] = Bottom,
    [H2 | T2] = Concat,
    H2 = H1,
	concatenate_list(T1,Top,T2). 

 reverse_list([],Reversed,Reversed).

 reverse_list([H|T],T1,Reversed) :- reverse_list(T,[H|T1],Reversed).

