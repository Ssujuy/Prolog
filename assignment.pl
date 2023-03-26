activity(a01, act(0,3)).
activity(a02, act(0,4)).
activity(a03, act(1,5)).
activity(a04, act(4,6)).
activity(a05, act(6,8)).
activity(a06, act(6,9)).
activity(a07, act(9,10)).
activity(a08, act(9,13)).
activity(a09, act(11,14)).
activity(a10, act(12,15)).
activity(a11, act(14,17)).
activity(a12, act(16,18)).
activity(a13, act(17,19)).
activity(a14, act(18,20)).
activity(a15, act(19,20)).

person(NP,Counter,MT,Assigned,ASP) :-
    Assigned \= [],
    Counter =< NP,
    [H | T] = ASP,
    activity_sequence(MT,0,Assigned,L,Time),
    H = Counter - L - Time,
    NCounter is Counter + 1,
    append(Assigned,L,NAssigned),
    person(NP,NCounter,MT,NAssigned,T).

person(NP,Counter,MT,[],ASP) :-
    Counter =< NP,
    [H | T] = ASP,
    activity_sequence(MT,0,[],L,Time),
    H = Counter - L - Time,
    NCounter is Counter + 1,
    append([],L,NAssigned),
    person(NP,NCounter,MT,NAssigned,T).

person(NP,Counter,_,_,[]) :-
    Counter > NP.
    

activity_sequence(MT,CurrentTime,Assigned,L,TotalTime) :-
    activity(X,act(Start,End)),
    Time is End - Start,
    NCurrentTime is CurrentTime + Time,
    NCurrentTime =< MT,
    [H | T] = L,
    H = X,
    assigned(X,Assigned),
    append(Assigned,[X],NAssigned),
    activity_sequence(MT,NCurrentTime,NAssigned,T,NTotalTime),
    TotalTime is Time + NTotalTime.

activity_sequence(_,_,_,[],0).

check([],_).

check(List,States) :-
    [H | T] = List,
    assigned(H,States),
    check(T,States).
    

assigned(_,[]).

assigned(CurrentState,States) :-
    [H | T] = States,
    CurrentState \= H,
    assigned(CurrentState,T).