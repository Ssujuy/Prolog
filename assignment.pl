
/*calls find_ASP and find_ASA then returns a solution*/

assignment(NP,MT,ASA,ASP) :-
    findall(X,activity(X,act(_,_)),TotalActivities),
    sort_list(TotalActivities,Sorted),
    find_ASP(NP,1,MT,Sorted,ASP),
    findall(X,activity(X,act(_,_)),TotalActivities2),
    find_ASA(TotalActivities2,ASP,ASA).

/*finds ASA through ASP solution found previously*/

find_ASA(TotalActivities,ASP,ASA) :-
    [H1 | T1] = TotalActivities,
    find_action(H1,ASP,Z),
    [H2 | T2] = ASA,
    H2 = Z,
    find_ASA(T1,ASP,T2).

find_ASA([],_,[]).

/*Finds a sequence of activities for each person then constructs the ASP list*/
/*Base case is when there are no activities to be assigned , ASP is an emtpy list and all person have jobs assigned*/

find_ASP(NP,1,MT,TotalActivities,ASP) :-
    person(NP,1,MT,TotalActivities,ASP),
    [H1 | T1] = ASP,
    H1 = _-X-_,
    remove_sublist(TotalActivities,X,NewTotalActivities),
    find_ASP(NP,2,MT,NewTotalActivities,T1).

find_ASP(NP,Counter,MT,TotalActivities,ASP) :-
    Counter > 1,
    Counter =< NP,
    person(NP,Counter,MT,TotalActivities,ASP),
    [H1 | T1] = ASP,
    H1 = _-X-_,
    remove_sublist(TotalActivities,X,NewTotalActivities),
    NCounter is Counter + 1,
    find_ASP(NP,NCounter,MT,NewTotalActivities,T1).
	    
    
find_ASP(NP,Counter,_,[],[]) :-
    Counter > NP.

/*Constructs the ASP element , 1 for each person*/

person(NP,Counter,MT,TotalActivities,ASP) :-
    [H | _] = ASP,
    sequence(MT,0,0,TotalActivities,L,Time),
    H = Counter - L - Time,
    person(NP,Counter,MT,TotalActivities,[]).

person(_,_,_,_,[]).

/*Finds a sequence of activities for each person , checks for Total time to be less than MT*/
/*Activities must have at least 1 time unit separating them*/
/*If all statements below fail then try the next element on Total Activities list*/
/*To avoid symmetrical solutions we add CurrentTime \= 0 when skippping an element on TotalActivities list*/

sequence(MT,0,0,TotalActivities,L,TotalTime) :-
    [H1 | T1] = TotalActivities,
    activity(H1,act(Start,End)),
    Time is End - Start,
    NCurrentTime = Time,
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
    CurrentTime \= 0,
    [_ | T] = TotalActivities,
    sequence(MT,CurrentTime,PreviousAct,T,L,TotalTime).

sequence(_,_,_,[],[],0).

/*find action finds a specific activity Activity in ASP list and constructs the ASA element in Z*/

find_action(Activity,ASP,Z) :-
    [H3 | _] = ASP,
    X-Y-_ = H3,
    element_in_list(Activity,Y),
    Z = Activity-X.

find_action(Activity,[_ | T],Z) :- find_action(Activity,T,Z).

/*sorts a list of all the Activities based on the starting time of each activity first is the lowest last is the highest starting time*/

sort_list(List,Sorted) :-
    sorting(List,[],Sorted).

sorting([],Acc,Acc).

sorting([H|T],Acc,Sorted) :-
    insert(H,Acc,NAcc),
    sorting(T,NAcc,Sorted).
   
insert(X,[Y|T],[Y|NT]) :- 
    activity(X,act(XStart,_)),
    activity(Y,act(YStart,_)),
    XStart > YStart,
	insert(X,T,NT),!.

insert(X,[Y|T],[X,Y|T]) :- 
    activity(X,act(XStart,_)),
    activity(Y,act(YStart,_)),
    XStart =< YStart.

insert(X,[],[X]).

/*counts all of the activities facts*/

count_activities(Counter) :-     
	findall(_,activity(_, act(_,_)),Solutions),
  	length(Solutions, Counter).

check([],_).

check(List,States) :-
    [H | T] = List,
    assigned(H,States),
    check(T,States).

/*Checks if element is in a list , returns false if not*/

element_in_list(X,List) :-
    [H | _] = List,
    X = H.

element_in_list(X,[_ | T]) :- element_in_list(X,T).

/*checks if element is not inside a list States*/

assigned(_,[]).

assigned(CurrentState,States) :-
    [H | T] = States,
    CurrentState \= H,
    assigned(CurrentState,T).

/*removes sublist L2 from list L1 return it to final*/

remove_sublist(L1,L2,Final) :-
    [H | T] = L2,
    remove(L1,H,L3),
    remove_sublist(L3,T,Final),!.

remove_sublist(Final,[],Final).

/*Remove element X from list L*/

remove(L,X,Final) :-
    [H1 | T1] = L,
    [H2 | T2] = Final,
    H1 \= X,
    H1 = H2,
    remove(T1,X,T2),!.

remove(L,X,Final) :-
    [H | T1] = L,
    H = X,
    remove(T1,X,Final),!.

remove([],_,[]).
    
