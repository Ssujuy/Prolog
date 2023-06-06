:-lib(gfd).
:-lib(branch_and_bound).

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



assignment_csp(NP,MT,ASP,ASA,X) :-
    findall(X,activity(X,act(_,_)),TotalActivities),
    length(TotalActivities,Len),
    length(Acts,Len),
    Acts #:: 1..NP.
    

constrain_acts(Couples,Acts) :-
    [H | T] = Couples,
    H = (I,J),
    element(I,Acts,ValueI),
    element(J,Acts,ValueJ),
    ValueI#\=ValueJ,
    constrain_acts(T,Acts).

constrain_acts([],_,_).

/*prepei na vrw ta zeugaria aymvatwn !!*/

find_couples(IndexList,TotalActivities,Checked,Couples) :-
    [H | T] = IndexList,
    IndexAct = H,
    find_activity_couple(IndexAct,TotalActivities,CoupleIndex),
    [Hc | Tc] = Couples,
    Hc = (IndexAct,CoupleIndex),
    /*remove ta 2 index apo to totalActivies list*/
    find_couples(IndexList,TotalActivities,Checked,Couples).

find_couples([],[],Checked,_) :- length(Checked,Len).
/*Edw findall kai to length tou findall activities na einai iso me Len*/


