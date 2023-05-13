dimension(5).

black(1,3).
black(2,3).
black(3,2).
black(4,3).
black(5,1).
black(5,5).

/*Find the answer as 2d list , convert ascii characters to letters , print solution*/

crossword(S) :-
    answer(S,LAscii),
    to_letters(LAscii,L),
    write_x(L).

/*prints list of characters*/

write_x(L) :-
    [H | T] = L,
    write_xy(H),
    nl,
	write_x(T).

write_x([]).

/*prints 1 element of the list at a time*/

write_xy(L) :-
    [H | T] = L,
    H \= ###,
    write(' '),
    write(H),
    write('  '),
    write_xy(T).

write_xy(L) :-
    [H | T] = L,
    H = ###,
    write(H),
    write(' '),
    write_xy(T).

write_xy([]).

/*find answer to the crossword*/

answer(S,L) :-
   empty_spots(L,EmptyWordsOrdered),
   ascii_list(S,WordsAscii),
   fill_crossword(WordsAscii,EmptyWordsOrdered,[]),!.
    

/*recursively filling the empty words list with words as ascii characters */
/*Both ascii words and empty words are sorted from biggest to lowest length*/

fill_crossword(WordsAscii,EmptyWords,[]) :-
    WordsAscii \= [],
	[H1 | T1] = WordsAscii,
    [H2 | _] = T1,
    [H3 | T3] = EmptyWords,
    H1 = H3,
    fill_crossword(T1,T3,H2).
    

fill_crossword(WordsAscii,EmptyWords,Word) :-
    WordsAscii \= [],
    [H1 | _] = EmptyWords,
    Word = H1,
    remove(EmptyWords,H1,NewEmptyWords),
    remove(WordsAscii,Word,NewWordsAscii),
    [H2 | _] = NewWordsAscii,
    fill_crossword(NewWordsAscii,NewEmptyWords,H2).

fill_crossword(WordsAscii,EmptyWords,Word) :-
    WordsAscii \= [],
    [H | _] = EmptyWords,
    find_next(WordsAscii,Word,NewWord),
    length(H,Len),
    length(NewWord,Len),
    \+check_empty_list(EmptyWords),
    fill_crossword(WordsAscii,EmptyWords,NewWord). 

fill_crossword(WordsAscii,EmptyWords,_) :-
    WordsAscii \= [],
    check_empty_list(EmptyWords),
    remove_all(WordsAscii,EmptyWords),
    fill_crossword([],[],_).
    
fill_crossword([],[],_).

/**/
    
ascii_list(S,L) :-
    sort_list(S,OrderedWords),
    words_ascii(OrderedWords,L).
    
/*Convert Words(list of words) to list of ascii words*/

words_ascii(Words,L) :-
    [H1 | T1] = Words,
    [H2 | T2] = L,
    name(H1,H2),
    words_ascii(T1,T2).

words_ascii([],[]).

/*Find all empty spots set black spots , create empty words list*/

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

/*sets defined black spots in crossword*/

set_black(L,BlackSpots) :-
	[H | T] = BlackSpots,
    [Y,X] = H,
    index_xy(L,X,Y,1,1,Target),
    Target = ###,
	set_black(L,T).

set_black(_,[]).

/*Find element on position x,y*/

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

to_letters(LAscii,L) :-
    [H1 | T1] = LAscii,
    [H2 | T2] = L,
    to_letters2(H1,H2),
    to_letters(T1,T2).

/*Conver list of ascii words to list of words*/

to_letters([],[]).

to_letters2(Ascii,L) :-
    [H1 | T1] = Ascii,
    [H2 | T2] = L,
    H1 \= ###,
    char_code(X,H1),
    X = H2,
    to_letters2(T1,T2).

to_letters2(Ascii,L) :-
    [H1 | T1] = Ascii,
    [H2 | T2] = L,
    H1 = ###,
    H1 = H2,
    to_letters2(T1,T2).

to_letters2([],[]).
    

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

/*Insert element in list*/

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

/*Remove all elements of list L2 from L1*/

remove_all(L1,L2) :-
    L1 \= [],
    [H | T] = L2,
    remove(L1,H,NewL1),
    remove_all(NewL1,T).

remove_all([],_).
    
/*Remove X element from list L*/

remove(L,X,Final) :-
    [H1 | T1] = L,
    [H2 | T2] = Final,
    H1 \= X,
    H1 = H2,
    remove(T1,X,T2),!.

remove(L,X,Final) :-
    [H | T1] = L,
    H = X,
    remove(T1,[],Final),!.

remove([],_,[]).

/*Find next element after X , from list L*/

find_next(L,X,Y) :- 
    [H | T] = L,
    X \= H,
    find_next(T,X,Y),!.

find_next(L,X,Y) :-
    [H1 | T1] = L,
    [H2 | _] = T1,
    X = H1,
    Y = H2.

check_empty_list(L) :-
    [H | T] = L,
    check_empty(H),
    check_empty_list(T).

check_empty_list([]).

check_empty(L) :-
    [H | T] = L,
    number(H),
    check_empty(T).

check_empty([]).
