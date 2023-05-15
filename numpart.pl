:-lib(ic).
:-lib(branch_and_bound).


my_search(N,L1,L2):-
    even(N),
    Length is N // 2,
    length(L1,Length),
    length(L2,Length),  
    L1#::1..N,
    L2#::1..N,
    diff_lists(L1,L2),
    unique_element(L1),
    unique_element(L2),
    SumL1 #= N* (N + 1) / 4,
    SumL1 #= SumL2,
    SqSumL1 #=  SumL1* (2* N + 1) / 3,
    SqSumL1 #= SqSumL2,
    find_sum(L1,0,SumL1),
    find_sum(L2,0,SumL2),
    find_square_sum(L1,0,SqSumL1),
    find_square_sum(L2,0,SqSumL2),
    search(L1,0,input_order,indomain,complete,[]),
    search(L2,0,input_order,indomain,complete,[]).

/*bb_min(search(Tents,0,input_order,indomain,complete,[]),Cost,bb_options{strategy:restart, solutions: all}).*/

find_sum(L,Sum,SumL) :-
    [H | T] = L,
    NSum #= Sum + H,
    find_sum(T,NSum,SumL).

find_sum([],SumL,SumL).

find_square_sum(L,SqSum,SqSumL) :-
    [H | T] = L,
    SqH #= H * H,
    NSqSum #= SqSum + SqH,
    find_square_sum(T,NSqSum,SqSumL).

find_square_sum([],SqSumL,SqSumL).

/*finds list of length Len , if Len is 4 list is [1,2,3,4]*/

ordered_list(Len,Counter,Ordered) :-
    Counter =< Len,
    [H | T] = Ordered,
    H = Counter,
    NCounter is Counter + 1,
    ordered_list(Len,NCounter,T).

ordered_list(Len,Counter,[]) :- Len < Counter.

diff_lists(L1,L2) :-
    L1 \= [],
    [H | T] = L1,
    diff_element(H,L2),
    diff_lists(T,L2).

diff_lists([],_).

diff_element(X,L) :-
    L \= [],
    [H | T] = L,
    X #\= H,
    diff_element(X,T).

diff_element(_,[]).

unique_element(L) :-
    L \= [],
    [H | T] = L,
    diff_element(H,T),
    unique_element(T).

unique_element([]).

even(N) :- 
    mod(N,2) =:= 0.
