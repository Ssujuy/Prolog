pancakes_dfs(InitialState, Operators, States) :-
    spatula(InitialState,InitialState,1,[],[],States,Operators).

spatula(InitialState,CurrentState,N,TempOp,TempStates,States,Operators) :-
    length(InitialState,Len),
    ordered_list(Len,1,L),
    NLen is Len - 1,
    N =< NLen,
    CurrentState \= L,
    flip(CurrentState,N,NewState),
    NewState \= InitialState,
    in_States(NewState,TempStates),
    [H1 | T1] = States,
    H1 = NewState,
    [H2 | T2] = Operators,
    H2 = N,
    append(TempOp,[N],NTempOp),
    append(TempStates,[NewState],NTempStates),
    spatula(InitialState,NewState,1,NTempOp,NTempStates,T1,T2).

spatula(InitialState,CurrentState,N,TempOp,TempStates,States,Operators) :-
    NN is N + 1,
    length(InitialState,Len),
    ordered_list(Len,1,L),
    NLen is Len - 1,
    NN =< NLen,
    CurrentState \= L,
    spatula(InitialState,CurrentState,NN,TempOp,TempStates,States,Operators).

spatula(InitialState,CurrentState,_,_,_,[],[]) :-
    length(InitialState,N),
    ordered_list(N,1,L),
    CurrentState = L.

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

