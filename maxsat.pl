maxsat(NV, NC, D, F, S, M) :-
    create_formula(NV, NC, D, F),
    length(Vars,NV),
    Vars #= 0..1,
    length(Sentence,NC),
    match_vars(Vars,Sentence,F),
    


match_vars(Vars,Sentence,F) :-
    [Hs | Ts] = Sentence,
    [Hf | Tf] = F,
    length(Hs,Len),
    length(Hf,Len),
    matching(Vars,Hs,Hf),
    match_vars(Vars,Ts,Tf).

match_vars(_,[],[]).

matching(Vars,L1,L2) :-
    [H1 | T1] = L1,
    [H2 | T2] = L2,
    Value is abs(H2),
    list_get(Vars,1,H2,Target),
    H1 #= Target,
    mathing(Vars,T1,T2).

matching(_,[],[]).

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

   na dhmiourghw ton ari8mo twn metavlhtwn pou prepei 5 -> L = [x1,x2,x3,x4,x5]
   na ftiaksw mia lista apo F = [[x1,x2],[-x3,x5]] klp
   na valw tis x1,x2 ... na pairnoun times apo 0 mexri 1
   na ftiaksw mia metavlhth gia ka8e protash C1 = x1 or x2 
   kai sto telos 8a prepei to a8roisma C1+C2+...Cn na einai megisto 
