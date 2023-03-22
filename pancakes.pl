pancakes_dfs(InitialState,[],[H | T]) :- 
    T = [] ,
    length(InitialState,N),
    ordered_list(N,1,L),
    H = L.

pancakes_dfs(InitialState, Operators, States) : 

spatula()

in_States(_,[]).

in_States(CurrentState,States) :-
    [H | T] = States,
    CurrentState \= H,
    inStates(CurrentState,T).

ordered_list(Len,Counter,[]) :- Len = Counter + 1.

ordered_list(Len,Counter,Ordered) :-
    [H | T] = Ordered,
    H = Counter,
    NCounter = Counter + 1,
    order_list(Len,NCounter,T).