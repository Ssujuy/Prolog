dimension(5).

black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).

//na kanw ena kathgorhma fill crossword to opoio 8a phgainei apo thn arxh mexri to telos ths listas WordsAscii, 8a kalei 8a kalei thn match kai 8a stamataei gia kenes tis listes Ascii kai EmptyWords,
//

words([adam,al,as,do,ik,lis,ma,oker,ore,pirus,po,so,ur]).    

crossword(L) :-
   empty_spots(L,EmptyWordsOrdered),
   ascii_list(WordsAscii).
	
fill_crossword(WordsAscii,EmptyWordsOrdered,Word) :-
    [H1 | T1] = WordsAscii,
    [H2 | T2] = EmptyWordsOrdered,
    Word = H2,
    find_next(WordsAscii,Word,NewWord),
    remove_list(WordsAscii,Word,NewWordsAscii),
   	fill_crossword(NewWordsAscii,T2,NewWord). 

fill_crossword(WordsAscii,EmptyWordsOrdered) :-
    [H | _] = EmptyWordsOrdered,
    find_next(WordsAscii,Word,NewWord),
    length(NewWord,Len),
    length(H,Len),
    fill_crossword(WordsAscii,T2,NewWord). 
    
fill_crossword([],[],_).

ascii_list(L) :-
    words(Words),
    sort_list(Words,OrderedWords),
    words_ascii(OrderedWords,L).
    

words_ascii(Words,L) :-
    [H1 | T1] = Words,
    [H2 | T2] = L,
    name(H1,H2),
    words_ascii(T1,T2).

words_ascii([],[]).

empty_spots(L,EmptyWordsOrdered) :-
    length(L,5),
	list_length(L),
    findall([X,Y],black(X,Y),BlackSpots),
	set_black(L,BlackSpots),
    words_y(L,1,1,EmptyWordsY),
    words_x(L,1,1,EmptyWordsX),
    append(EmptyWordsY,EmptyWordsX,EmptyWords),
    sort_list_length(EmptyWords,EmptyWordsOrdered).

find_word_y(L,X,Y,Word) :-
    dimension(D),
    Y =< D,
    index_xy(L,X,Y,1,1,Target),
    var(Target),
    [H | T] = Word,
    H = Target,
    NY is Y+1,
    find_word_y(L,X,NY,T),!.

find_word_y(_,_,_,[]).

words_y(L,X,Y,EmptyWords) :-
    dimension(D),
    X =< D,
    Y =< D,
    [H | T] = EmptyWords,
    find_word_y(L,X,Y,Word),
    Word \= [],
    H = Word,
    length(H,Len),
    NY is Len + Y + 1,
    words_y(L,X,NY,T).

words_y(L,X,Y,EmptyWords) :-  
    dimension(D),
    X =< D,
    Y =< D,
    find_word_y(L,X,Y,Word),
    Word = [],
    NY is Y + 1,
    words_y(L,X,NY,EmptyWords).

words_y(L,X,Y,EmptyWords) :-
    dimension(D),
    Y > D,
    X =< D,
    NX is X + 1,
    words_y(L,NX,1,EmptyWords).

words_y(_,X,_,[]) :-
    dimension(D),
    X > D.

find_word_x(L,X,Y,Word) :-
    dimension(D),
    X =< D,
    index_xy(L,X,Y,1,1,Target),
    var(Target),
    [H | T] = Word,
    H = Target,
    NX is X+1,
    find_word_x(L,NX,Y,T),!.

find_word_x(_,_,_,[]).


words_x(L,X,Y,EmptyWords) :-
    dimension(D),
    X =< D,
    Y =< D,
    [H | T] = EmptyWords,
    find_word_x(L,X,Y,Word),
    Word \= [],
    H = Word,
    length(H,Len),
    NX is Len + X + 1,
    words_x(L,NX,Y,T).

words_x(L,X,Y,EmptyWords) :-  
    dimension(D),
    X =< D,
    Y =< D,
    find_word_x(L,X,Y,Word),
    Word = [],
    NX is X + 1,
    words_x(L,NX,Y,EmptyWords).

words_x(L,X,Y,EmptyWords) :-
    dimension(D),
    X > D,
    Y =< D,
    NY is Y + 1,
    words_x(L,1,NY,EmptyWords).

words_x(_,_,Y,[]) :-
    dimension(D),
    Y > D.


set_black(L,BlackSpots) :-
	[H | T] = BlackSpots,
    [Y,X] = H,
    index_xy(L,X,Y,1,1,Target),
    Target = ###,
	set_black(L,T).

set_black(_,[]).

index_xy(L,X,Y,XCounter,YCounter,Target) :-
   	index_y(L,Y,YCounter,YL),
    index_x(YL,X,XCounter,Target).

index_x(L,X,XCounter,Target) :-
    XCounter < X,
    [_ | T] = L,
    NXCounter is XCounter + 1,
    index_x(T,X,NXCounter,Target).

index_x([H | _],Y,Y,H).

index_y(L,Y,YCounter,Target) :-
    YCounter < Y,
    [_ | T] = L,
    NYCounter is YCounter + 1,
    index_y(T,Y,NYCounter,Target).

index_y([H | _],Y,Y,H).


sort_list_length(List,Sorted) :-
    sorting_length(List,[],Sorted).

sorting_length([],Acc,Acc).

sorting_length([H|T],Acc,Sorted) :-
    insert_length(H,Acc,NAcc),
    sorting_length(T,NAcc,Sorted).

list_length(L) :-
    [H | T] = L,
    dimension(Len),
    length(H,Len),
    list_length(T).

list_length([]).

insert_length(X,[Y|T],[Y|NT]) :- 
    length(X,LenX),
    length(Y,LenY),
    LenX =< LenY,
	insert_length(X,T,NT),!.

insert_length(X,[Y|T],[X,Y|T]) :- 
    length(X,LenX),
    length(Y,LenY),
    LenX > LenY.

insert_length(X,[],[X]).


sort_list(List,Sorted) :-
    sorting(List,[],Sorted).

sorting([],Acc,Acc).

sorting([H|T],Acc,Sorted) :-
    insert(H,Acc,NAcc),
    sorting(T,NAcc,Sorted).

insert(X,[Y|T],[Y|NT]) :- 
    name(X,LX),
    name(Y,LY),
    length(LX,LenX),
    length(LY,LenY),
    LenX =< LenY,
	insert(X,T,NT),!.

insert(X,[Y|T],[X,Y|T]) :- 
    name(X,LX),
    name(Y,LY),
    length(LX,LenX),
    length(LY,LenY),
    LenX > LenY.

insert(X,[],[X]).

# find_next(L,Item,Target) :-
#     [H1 | T1] = L,
#     H1 \= Item,


# find_next(L,Item,Target) :-
#     [H1 | T1] = L,
#     H1 = Item,
#     [H2 | T2] = T1,
#     H2 = Target.