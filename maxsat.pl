:-lib(ic).
:-lib(branch_and_bound).

#maxsat

maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F),
    length(S,NV),
    S #:: 0..1,
    length(Sentence,NC),
    match_vars(S,Sentence,F),
    length(Clause,NC),
    Clause #:: 0..1,
    clauses_bool(Clause,Sentence),
    find_cost(Clause,0,M),
    ordered_list(NC,L),
    member(M,L),
    bb_min(search(S,0,input_order,indomain,complete,[]),M,bb_options{strategy:restart,solutions: one}),!.

clauses_bool(Clause,S) :-
    [Hc | Tc] = Clause,
    [Hs | Ts] = S,
    c_find_bool(0,Hc,Hs),
    clauses_bool(Tc,Ts).

clauses_bool([],[]).

c_find_bool(TempC,C,L) :-
    [H | T] = L,
    NewC #= TempC or H,
    c_find_bool(NewC,C,T).

c_find_bool(C,C,[]).


find_cost(Clause,Cost,CostC) :-
    [H | T] = Clause,
    NCost #= Cost + H,
    find_cost(T,NCost,CostC).

find_cost([],CostC,CostC).

match_vars(S,Sentence,F) :-
    [Hs | Ts] = Sentence,
    [Hf | Tf] = F,
    length(Hf,Len),
    length(Hs,Len),
    matching(S,Hs,Hf),
    match_vars(S,Ts,Tf).

match_vars(_,[],[]).

matching(S,L1,L2) :-
    [H1 | T1] = L1,
    [H2 | T2] = L2,
    H2 < 0,
    Value is abs(H2),
    list_get(S,1,Value,Target),
    H1 #= 1 - Target,
    matching(S,T1,T2).

matching(S,L1,L2) :-
    [H1 | T1] = L1,
    [H2 | T2] = L2,
    H2 > 0,
    list_get(S,1,H2,Target),
    H1 #= Target,
    matching(S,T1,T2).

matching(_,[],[]).

ordered_list(Len,Ordered) :-
    Len > 1,
    [H | T] = Ordered,
    H = Len,
    NLen is Len - 1,
    ordered_list(NLen,T).

ordered_list(1,[H | T]) :- H = 1,T = [].

list_get(L,Counter,X,Target) :-
    Counter < X,
    [_ | T] = L,
    NCounter is Counter + 1,
    list_get(T,NCounter,X,Target).

list_get([H | _],Y,Y,H).

create_formula(NVars, NClauses, Density, Formula) :-
   formula(NVars, 1, NClauses, Density, Formula).

formula(_, C, NClauses, _, []) :-
   C > NClauses.
formula(NVars, C, NClauses, Density, [Clause|Formula]) :-
   C =< NClauses,
   one_clause(1, NVars, Density, Clause),
   C1 is C + 1,
   formula(NVars, C1, NClauses, Density, Formula).

one_clause(V, NVars, _, []) :-
   V > NVars.
one_clause(V, NVars, Density, Clause) :-
   V =< NVars,
   rand(1, 100, Rand1),
   (Rand1 < Density ->
      (rand(1, 100, Rand2),
       (Rand2 < 50 ->
        Literal is V ;
        Literal is -V),
       Clause = [Literal|NewClause]) ;
      Clause = NewClause),
   V1 is V + 1,
   one_clause(V1, NVars, Density, NewClause).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.

/*   na dhmiourghw ton ari8mo twn metavlhtwn pou prepei 5 -> L = [x1,x2,x3,x4,x5]
   na ftiaksw mia lista apo F = [[x1,x2],[-x3,x5]] klp
   na valw tis x1,x2 ... na pairnoun times apo 0 mexri 1
   na ftiaksw mia metavlhth gia ka8e protash C1 = x1 or x2 
   kai sto telos 8a prepei to a8roisma C1+C2+...Cn na einai megisto */