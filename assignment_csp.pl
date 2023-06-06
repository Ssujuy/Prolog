:-lib(gfd).
:-lib(branch_and_bound).

assignment_csp(NP,MT,ASP,ASA,Couples) :-
    findall(X,activity(X,act(_,_)),TotalActivities),
    length(TotalActivities,Len),
    length(Acts,Len),
    Acts #:: 1..NP,
    act_index(TotalActivities,1,ActIndex),
    find_couples(ActIndex,0,Couples).
    

constrain_acts(Couples,Acts) :-
    [H | T] = Couples,
    H = (I,J),
    element(I,Acts,ValueI),
    element(J,Acts,ValueJ),
    ValueI#\=ValueJ,
    constrain_acts(T,Acts).

constrain_acts([],_,_).

find_couples(ActIndex,Current,Couples) :-
    Current = 0,
    ActIndex = [H | _],
    NCurrent = H,
    find_couples(ActIndex,NCurrent,Couples).

find_couples(ActIndex,Current,Couples) :-
    Current \= 0,
    Couples = [Hc | Tc],
    find_activity_couple(ActIndex,Current,Couple),
    remove_list(ActIndex,Current,NActIndex),
    remove_list(NActIndex,Couple,NewActIndex),
    NewActIndex \= [],
    Couple = (IndexCouple,_),
    Current = (IndexC,_),
    Hc = (IndexC,IndexCouple),
    [Ha | _] = NewActIndex,
    NewCurrent = Ha,
    find_couples(NewActIndex,NewCurrent,Tc).

find_couples(ActIndex,Current,Couples) :-
    Current \= 0,
    length(ActIndex,2),
    Couples = [Hc | Tc],
    [H1 | T1] = ActIndex,
    T1 = [H2 | []],
    H1 = (Index1,_),
    H2 = (Index2,_),
    Hc = (Index1,Index2),
    find_couples([],Current,Tc).

find_couples([],_,[]). 

find_activity_couple(ActIndex,Current,Couple) :-
    [H | _] = ActIndex,
    H \= Current,
    Current = (_,ActC),
    H = (_,ActH),
    activity(ActC,act(StartC,EndC)),
    activity(ActH,act(StartH,_)),
    StartH >= StartC,
    StartH =< EndC,
    Couple = H.

find_activity_couple(ActIndex,Current,Couple) :-
    [_ | T] = ActIndex,
    find_activity_couple(T,Current,Couple).

act_index(TotalActivities,Counter,ActIndex) :-
    [Ht | Tt] = TotalActivities,
    [Ha | Ta] = ActIndex,
    Ha = (Counter,Ht),
    NCounter is Counter + 1,
    act_index(Tt,NCounter,Ta).

act_index([],_,[]).

remove_list(L,X,Final) :-
    [H1 | T1] = L,
    [H2 | T2] = Final,
    H1 \= X,
    H1 = H2,
    remove_list(T1,X,T2),!.

remove_list(L,X,Final) :-
    [H | T1] = L,
    H = X,
    remove_list(T1,[],Final),!.

remove_list([],_,[]).


activity(a001, act(41,49)).
activity(a002, act(72,73)).
activity(a003, act(80,85)).
activity(a004, act(65,74)).
activity(a005, act(96,101)).
activity(a006, act(49,55)).
activity(a007, act(51,59)).
activity(a008, act(63,65)).
activity(a009, act(66,69)).
activity(a010, act(80,87)).
activity(a011, act(71,76)).
activity(a012, act(64,68)).
activity(a013, act(90,93)).
activity(a014, act(49,56)).
activity(a015, act(23,29)).
activity(a016, act(94,101)).
activity(a017, act(25,34)).
activity(a018, act(51,54)).
activity(a019, act(13,23)).
activity(a020, act(67,72)).
activity(a021, act(19,21)).
activity(a022, act(12,16)).
activity(a023, act(99,104)).
activity(a024, act(92,94)).
activity(a025, act(74,83)).
activity(a026, act(95,100)).
activity(a027, act(39,47)).
activity(a028, act(39,49)).
activity(a029, act(37,39)).
activity(a030, act(57,66)).
activity(a031, act(95,101)).
activity(a032, act(71,74)).
activity(a033, act(86,93)).
activity(a034, act(51,54)).
activity(a035, act(74,83)).
activity(a036, act(75,81)).
activity(a037, act(33,43)).
activity(a038, act(29,30)).
activity(a039, act(58,60)).
activity(a040, act(52,61)).
activity(a041, act(35,39)).
activity(a042, act(46,51)).
activity(a043, act(71,72)).
activity(a044, act(17,24)).
activity(a045, act(94,103)).
activity(a046, act(77,87)).
activity(a047, act(83,87)).
activity(a048, act(83,92)).
activity(a049, act(59,62)).
activity(a050, act(2,4)).
activity(a051, act(86,92)).
activity(a052, act(94,103)).
activity(a053, act(80,81)).
activity(a054, act(39,46)).
activity(a055, act(60,67)).
activity(a056, act(72,78)).
activity(a057, act(58,61)).
activity(a058, act(8,18)).
activity(a059, act(12,16)).
activity(a060, act(47,50)).
activity(a061, act(49,50)).
activity(a062, act(71,78)).
activity(a063, act(34,42)).
activity(a064, act(21,26)).
activity(a065, act(92,95)).
activity(a066, act(80,81)).
activity(a067, act(74,79)).
activity(a068, act(28,29)).
activity(a069, act(100,102)).
activity(a070, act(29,37)).
activity(a071, act(4,12)).
activity(a072, act(79,83)).
activity(a073, act(98,108)).
activity(a074, act(91,100)).
activity(a075, act(82,91)).
activity(a076, act(59,66)).
activity(a077, act(34,35)).
activity(a078, act(51,60)).
activity(a079, act(92,94)).
activity(a080, act(77,83)).
activity(a081, act(38,48)).
activity(a082, act(51,59)).
activity(a083, act(35,39)).
activity(a084, act(22,24)).
activity(a085, act(67,68)).
activity(a086, act(90,97)).
activity(a087, act(82,83)).
activity(a088, act(51,53)).
activity(a089, act(78,88)).
activity(a090, act(74,79)).
activity(a091, act(100,105)).
activity(a092, act(53,63)).
activity(a093, act(57,66)).
activity(a094, act(32,41)).
activity(a095, act(48,56)).
activity(a096, act(92,96)).
activity(a097, act(4,8)).
activity(a098, act(31,33)).
activity(a099, act(69,77)).
activity(a100, act(88,93)).