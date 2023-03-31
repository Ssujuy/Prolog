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

find_ASP(NP,Counter,MT,Assigned,ASP) :-
    person(NP,Counter,MT,Assigned,Assigned2,ASP),
    count_activities(Number),
    length(Assigned2,Number).

person(NP,Counter,MT,Assigned,Assigned2,ASP) :-
    Counter =< NP,
    [H | T] = ASP,
    activity_sequence(MT,0,0,Assigned,L,Time),
    append(L,Tail,Assigned2),
    H = Counter - L - Time,
    NCounter is Counter + 1,
    append(Assigned,L,NAssigned),
    person(NP,NCounter,MT,NAssigned,Tail,T).

person(NP,Counter,_,_,[],[]) :-
    Counter > NP.

sequence(MT,CurrentTime,0,TotalActivities,L,TotalTime) :-
    [H1 | T1] = TotalActivities,
    activity(H1,act(Start,End)),
    Time is End - Start,
    NCurrentTime is CurrentTime + Time,
    NCurrentTime =< MT,
    [H2 | T2] = L,
    H1 = H2,
    sequence(MT,NCurrentTime,H1,T1,T2,NTotalTime),
    TotalTime is Time + NTotalTime.

sequence(MT,CurrentTime,PreviousAct,TotalActivities,L,TotalTime) :-
    [H1 | T1] = TotalActivities,
    activity(H1,act(Start,End)),
    activity(PreviousAct,act(_,PrevEnd)),
    NPrevEnd is PrevEnd + 1,
    NPrevEnd =< Start,
    Time is End - Start,
    NCurrentTime is CurrentTime + Time,
    NCurrentTime =< MT,
    [H2 | T2] = L,
    H1 = H2,
    sequence(MT,NCurrentTime,H1,T1,T2,NTotalTime),
    TotalTime is Time + NTotalTime.

sequence(MT,CurrentTime,PreviousAct,TotalActivities,L,TotalTime) :-
    [_ | T] = TotalActivities,
    sequence(MT,CurrentTime,PreviousAct,T,L,TotalTime).

sequence(_,_,_,_,[],0).

activity_sequence(MT,CurrentTime,0,Assigned,L,TotalTime) :-
    activity(X,act(Start,End)),
    Time is End - Start,
    NCurrentTime is CurrentTime + Time,
    NCurrentTime =< MT,
    [H | T] = L,
    H = X,
    assigned(X,Assigned),
    append(Assigned,[X],NAssigned),
    activity_sequence(MT,NCurrentTime,X,NAssigned,T,NTotalTime),
    TotalTime is Time + NTotalTime.

activity_sequence(MT,CurrentTime,PreviousAct,Assigned,L,TotalTime) :-
    PreviousAct \= 0,
    activity(X,act(Start,End)),
    activity(PreviousAct,act(_,PrevEnd)),
    NPrevEnd is PrevEnd + 1,
    NPrevEnd =< Start,
    Time is End - Start,
    NCurrentTime is CurrentTime + Time,
    NCurrentTime =< MT,
    [H | T] = L,
    H = X,
    assigned(X,Assigned),
    append(Assigned,[X],NAssigned),
    activity_sequence(MT,NCurrentTime,X,NAssigned,T,NTotalTime),
    TotalTime is Time + NTotalTime.

activity_sequence(_,_,_,_,[],0).

count_activities(Counter) :-     
	findall(_,activity(_, act(_,_)),Solutions),
  	length(Solutions, Counter).

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