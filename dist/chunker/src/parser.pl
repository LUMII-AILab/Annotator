/*****************************************************************************
 * Dependency-based hybrid parser for languages with a rather free word order
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Guntis Bārzdiņš, Ilmārs Poikāns
 *
 * This file is part of the SemTi-Kamols Chunker
 * See <http://www.semti-kamols.lv/>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *****************************************************************************/
 
 
/* $Revision: 976 $, $Date: 2012-10-17 18:12:08 +0300 (Wed, 17 Oct 2012) $ */

:- ensure_loaded('config').
:- ensure_loaded('defs').
:- ensure_loaded('tokenize').
:- ensure_loaded('tools').

:- thread_local af/5, xf/4, bf/4.


add_to_classpath(JavaLibs) :-
    (getenv('CLASSPATH', CPOld) -> true ; CPOld = '.'),
    (current_prolog_flag(windows, true) -> Separator = ';' ; Separator = ':'),
    flatten([JavaLibs, CPOld], ConcatJavaLibs),
    concat_atom(ConcatJavaLibs, Separator, CPNew),
    setenv('CLASSPATH', CPNew).

load_jpl:-
    config(parse_use_word_analyzer, true), !,
    ensure_loaded(library('jpl')),
    jpl_set_default_jvm_opts(['-Xmx2g']).

load_jpl.

:- config(parse_java_libs, JavaLibs), add_to_classpath(JavaLibs).
:- load_jpl.


% ===============


match_x_word([],[],WordList,WordList) :- !. % Stop when X word list[1] is empty, parse result[2] is empty too
                                            % Right word list[3] is the same as sentence word list[4]

match_x_word(XWordList,[ParseResultItem|ParseResultList],RightWordList,WordList) :- 
    XWordList = [XHead|XTail],
    length_leq(XWordList,WordList), 
    split_left_non_empty(WordList,XHeadWords,TailWords),
    length_leq(XTail,TailWords),
    choose_head_word([x,x],XHead,ParseResultItem,XHeadWords),
    match_x_word(XTail,ParseResultList,RightWordList,TailWords).


choose_head_word([SyntaxRelation,SemanticRole],[Word,Morphology,BaseForm,Source,Meaning],ParseResult,WordList) :-
    Morphology = [XFIndex|_],
    xf(XFIndex,XWordList,XTree,[Word,Morphology,BaseForm,Source,Meaning]), 
    length_leq(XWordList,WordList), 
    split_right_non_empty(WordList,LeftWordList,WordWorkList),
    match_x_word(XWordList,XTree,RightWordList,WordWorkList),
    match_b_rule(Word,Morphology,LeftParseResult,LeftWordList,left),
    match_b_rule(Word,Morphology,RightParseResult,RightWordList,right), 
    check_repeated_syntax_roles(LeftParseResult, RightParseResult),
    append(XTree,RightParseResult,XRightParseResult),
    append(LeftParseResult,[([SyntaxRelation,SemanticRole,Morphology,BaseForm,_Concept,Source,Meaning],Word)|XRightParseResult],ParseResult).  % Word Concept not set currently

choose_head_word([SyntaxRelation,SemanticRole],[Word,Morphology,BaseForm,Source,Meaning],ParseResult,WordList) :-
    af(Word,Morphology,BaseForm,Source,Meaning),
    split_with_element(WordList,LeftWordList,Word,RightWordList),
    match_b_rule(Word,Morphology,LeftParseResult,LeftWordList,left),
    match_b_rule(Word,Morphology,RightParseResult,RightWordList,right),
    check_repeated_syntax_roles(LeftParseResult, RightParseResult), 
    append(LeftParseResult,[([SyntaxRelation,SemanticRole,Morphology,BaseForm,_Concept,Source,Meaning],Word)|RightParseResult],ParseResult). % Word Concept not set currently


match_b_rule(_,_,[],[],_) :- !. % Stop when word list[4] is empty. Then parse result[3] is empty too.

match_b_rule(Word,ParentMorphology,ParseResult,WordList,Position) :-
    bf(SyntaxRelation,ChildMorphology,ParentMorphology,Position),
    split_left_non_empty(WordList,ChildWordList,TailWordList),
    choose_head_word([SyntaxRelation,_SemanticRole],[_,ChildMorphology|_],ChildParseResult,ChildWordList), % Semantic Role not used currently
    match_b_rule(Word,ParentMorphology,TailParseResult,TailWordList,Position),
    ParseResult=[ChildParseResult|TailParseResult].


check_repeated_syntax_roles(LeftParseResult, RightParseResult) :-
    append(LeftParseResult,RightParseResult,TempParseResult),
    extr(TempParseResult,NonMultiUsedBRulesList),
    is_set(NonMultiUsedBRulesList). 


extr([],[]).
extr([A|B],[AA|BB]) :- extr(B,BB), elm(A,AA),!.
extr([_|B],BB) :- extr(B,BB).

elm([([SyntaxRelation|_],_)|_],Role) :- SyntaxRelation=[Role|_],not(repeatable_syntax_role(Role)).
elm([A|H],L) :- not(A=(_,_)),elm(H,L).

% ===============

parse:-
    gg(A),
    /* writeln(A), */
    prepare_words(A),
    findbest(A,AA),
    writeln(AA),
    writeln('=============== START =============='),
    niceprint(AA).

sentence_to_words(Words, Words) :-
	is_list(Words), !.

sentence_to_words(Sentence, Words) :-
    string_to_list(Sentence, SChars),
    tokenize(SChars, Words).

parse_chunky(A,OUT) :- 
    sentence_to_words(A, AA),
    prepare_words(AA),
%    findbest(AA,AAA),
    parse_wordlist_chunky(AA,OUT), !.
%    niceprint2(AAA,OUT), !.

parse_fully(Sentence, Result) :- 
    sentence_to_words(Sentence, SWords),
    length(SWords, SWordCount),
    (config(max_chunk_length, MaxChunkLen) ; MaxChunkLen=SWordCount), !,
    SWordCount =< MaxChunkLen, 
    prepare_words(SWords), !,
    choose_head_word([x,x], _, Tree, SWords),
    Result=[Tree].

parse(Sentence, Result) :-
    parse_fully(Sentence, Result).

parse(Sentence, Result) :-
    parse_chunky(Sentence, Result), !.

parse(TimeLimit, Sentence, Result) :-
    catch(call_with_time_limit(TimeLimit, parse(Sentence, Result)), _, true).
%   catch(call_with_time_limit(TimeLimit, parse(Sentence, Result)), Exception, true), format('Exception: ~w~n', Exception).

parse_all(Sentence, ResultList) :-
    config(parse_fully, true),
    bagof(Result, parse_fully(Sentence, Result), ResultList), !.

parse_all(Sentence, ResultList) :-
    parse_chunky(Sentence, Result), ResultList=[Result], !.

parse_all(TimeLimit, Sentence, ResultList) :-
    catch(call_with_time_limit(TimeLimit, parse_all(Sentence, ResultList)), _, true).
%   catch(call_with_time_limit(TimeLimit, parse_all(Sentence, ResultList)), Exception, true), format('Exception: ~w~n', Exception).


parse_by_config(Sentence, ResultList) :-
    config(parse_all, ParseAll),
    config(parse_time_limit, TimeLimit),
    parse_by_config(ParseAll, TimeLimit, Sentence, ResultList).

% parse_by_config(ParseAll, TimeLimit, Sentence, ResultList) :-

parse_by_config(true, TimeLimit, Sentence, ResultList) :-
    parse_all(TimeLimit, Sentence, ResultList), !.

parse_by_config(false, TimeLimit, Sentence, ResultList) :-
    parse(TimeLimit, Sentence, Result),
    (nonvar(Result) -> ResultList = [Result] ; ResultList = Result), !.


niceprint2([],[]). 
niceprint2([A|B],[A|BB]) :- not(A=[_|_]), niceprint2(B,BB). /* te bija labojums */
niceprint2([A|B],[Y|BB]) :- A=[_|_],  choose_head_word([x,x],_,Y,A),!, niceprint2(B,BB).

/* saja vieta pielabot; tad paliks tikai a,b izdruka standarta + left/right */
cln(A,B) :- append(L,[(_,Y)|R],A),append(L2,[(_,Y2)|R2],R),!,cln2(L,LL),cln2(L2,LL2),cln2(R2,RR2),append(LL2,[Y2|RR2],BB),append(LL,[Y|BB],B).
cln(A,B) :- append(L,[(_,Y)|R],A),cln2(L,LL),cln2(R,RR),append(LL,[Y|RR],B).
cln([],[]).

cln2([A|B],[AA|BB]):-cln(A,AA),cln2(B,BB).
cln2([],[]).


niceprint([]) :- writeln('=============== STOP ==============').
niceprint([A|B]) :- not(A=[_|_]),writeln(A), niceprint(B).
niceprint([A|B]) :- A=[_|_],  choose_head_word([x,x],_,Y,A),!, writeln(Y), niceprint(B).

findbest(A,AA) :- buildall(A,BB), /*  writeln(['BBBBBB',BB]), */  select(BB,AA).

buildall([],[]).
buildall([A|AA],[B|BB]) :- 
    buildall(AA,BB),
    C=[A|AA],
    config(max_chunk_length, MaxChunkLen),
    findall(MMM,hhhhh(C,MMM,MaxChunkLen),D),
    lengths(D,DD),
    B=[A,DD].

lengths([],[]).
lengths([A|AA],[B|BB]) :- length(A,B), lengths(AA,BB).

maxim([],0,_).
maxim([A|AA],Z,N) :- maxim(AA,ZZ,N), (A =< N,Z is max(ZZ,A);A > N,Z=ZZ).

maxima([],0,0,[]).
maxima([[W,A]|AA],Z,NN,TT) :- maxima(AA,ZZ,N,T), NN is N+1, maxim(A,K,NN), (K > ZZ,Z=K,TT=[[W,A]|AA];K =< ZZ,Z=ZZ,TT=T).

select(A,B) :- maxima(A,N,_,T), (N=0,cleans(A,B);N > 0, length(F,N), append(START,T,A),append(F,TAIL,T),
               select(START,STARTA),select(TAIL,TAILA),cleans(F,FF), append(STARTA,[FF|TAILA],B)).

cleans([],[]).
cleans([[W,_]|AA],[W|BB]) :- cleans(AA,BB).

hhhhh(A,X,MaxChunkLen) :- append(X,_,A), length(X,N), N =< MaxChunkLen, flattenR(_,_,X).

flattenR(A,B,C) :- choose_head_word([x,x],A,B,C),!.

gg(YYY):-current_input(X),read_line_to_codes(X,Y),tokenize(Y,YYY).



parse_wordlist_fully(WordList, Result) :- 
%    prepare_words(WordList), !,
    choose_head_word([x,x], _, Tree, WordList),
    Result=[Tree].

%% join_parse_result_chunks(+First,+Second,-Result)

join_parse_result_chunks([], [], []) :- !.
join_parse_result_chunks([], Second, Second) :- !.
join_parse_result_chunks([H|Tail], Two, [H|RTail]):- join_parse_result_chunks(Tail, Two, RTail).


%% find_parsable_chunk(+WordList,+ChunkLength,-LeftWords,-Chunk,-RightWords)

find_parsable_chunk(WordList, ChunkLength, LeftWords, Chunk, RightWords) :-
    split_with_list(WordList, ChunkLength, LeftWords, ChunkWords, RightWords),
    parse_wordlist_fully(ChunkWords, Chunk).


%% find_max_parsable_chunk(+WordList,+MaxStepTime,-LeftWords,-Chunk,-RightWords)

find_max_parsable_chunk([], _, [], [], []) :- !.

find_max_parsable_chunk(WordList, MaxStepTime, LeftWords, Chunk, RightWords) :-
    length(WordList, WordCount),
    (config(max_chunk_length, MaxChunkLen) ; MaxChunkLen=WordCount), !,
    LastResult = result([[], WordList, []]),
    (forall(between(1, MaxChunkLen, ChunkLength), (
        catch(call_with_time_limit(MaxStepTime, find_parsable_chunk(WordList, ChunkLength, StepLeftWords, StepChunk, StepRightWords)), _, true),
        (nonvar(StepChunk) -> nb_setarg(1, LastResult, [StepLeftWords, StepChunk, StepRightWords]) 
                            ; fail)
    )) ; true),
    arg(1, LastResult, [LeftWords, Chunk, RightWords]), !.


%% parse_wordlist_chunky(+WordList,-Result)

parse_wordlist_chunky([],[]) :- !.

parse_wordlist_chunky(WordList, Result) :-
    config(parse_chunk_step_time_limit, TimeLimit, 1), !,
    find_max_parsable_chunk(WordList, TimeLimit, LeftWords, Chunk, RightWords),
    parse_wordlist_chunky(LeftWords, LeftResult),
    parse_wordlist_chunky(RightWords, RightResult),
    join_parse_result_chunks(LeftResult, Chunk, LCResult),
    join_parse_result_chunks(LCResult, RightResult, Result), !.



prepare_words(Words) :-
%   retractall(af(_,_,_,_,_)),        /* af(Word, Morphology, BaseForm, Source, Meaning) */
%   retract all, but tool defined items
    retractall(af(_,_,_,dict,_)),
    retractall(af(_,_,_,guess,_)),
    retractall(af(_,_,_,defs,_)),
    retractall(xf(_,_,_,_)),          /* xf(XFIndex, XWordList, XTree, XWord) */
    retractall(bf(_,_,_,_)),          /* bf(SyntaxRelation, ChildMorphology, ParentMorphology, Position) */
    list_to_set(Words, WordSet),
    checklist(prepare_af, WordSet),
    prepare_xf,
    prepare_bf.

define_analyzer_afs([]) :- !.

define_analyzer_afs([[Word, Morphology, BaseForm, Source, Meaning] | Tail]) :-
    assert(af(Word, Morphology, BaseForm, Source, Meaning)),
    define_analyzer_afs(Tail), !.

define_analyzer_afs(X) :- format('Unknowns AFSDef - ~w~n', [X]).


prepare_af(Word) :-
    Found = found(false),
    forall(a(Word, Morphology, BaseForm), (
        Source = defs,
        Meaning = BaseForm,
        /* format('   af(~w, ~w, ~w, ~w, ~w)~n', [Word, Morphology, BaseForm, Source, Meaning]), */
        assert(af(Word, Morphology, BaseForm, Source, Meaning)),
        nb_setarg(1, Found, true)
    )),
    Found =@= found(true), !.

prepare_af(Word) :-
    config(parse_use_word_analyzer, true), !,
    (config(parse_word_analyzer_guess, true) -> Guess = @(true) ; Guess = @(false)), !,
    (config(parse_word_analyzer_guess_nouns, true) -> GuessNouns = @(true) ; GuessNouns = @(false)), !,
    (config(parse_word_analyzer_guess_verbs, true) -> GuessVerbs = @(true) ; GuessVerbs = @(false)), !,
    (config(parse_word_analyzer_guess_participles, true) -> GuessParticiples = @(true) ; GuessParticiples = @(false)), !,
    (config(parse_word_analyzer_guess_adjectives, true) -> GuessAdjectives = @(true) ; GuessAdjectives = @(false)), !,
    (config(parse_word_analyzer_allow_vocative, true) -> AllowVocative = @(true) ; AllowVocative = @(false)), !,
    (config(parse_word_analyzer_enable_diminutive, true) -> EnableDiminutive = @(true) ; EnableDiminutive = @(false)), !,
    (config(parse_word_analyzer_morpho_defaults, true) -> MorphoDefaults = @(true) ; MorphoDefaults = @(false)), !,
    (config(parse_java_debug, true) -> JavaDebug = true ; JavaDebug = not(true)), !,
    (JavaDebug -> format('<br />Java call for ~w ... ', [Word]) ; true), !,
    (jpl_call('lv.semti.PrologInterface.PrologWrapper', analyze, [Word, GuessNouns, GuessVerbs, GuessParticiples, GuessAdjectives, AllowVocative, EnableDiminutive, MorphoDefaults], SWordFormList) ; (JavaDebug -> format('Call failed. ') ; true)), !,
    (JavaDebug -> format('finished. Result: ~w~n', [SWordFormList]) ; true), !,
    atom_to_term(SWordFormList, WordFormList, _),
    define_analyzer_afs(WordFormList), !.

prepare_af(Word) :- format('It looks like jpl_call for ~w failed.', [Word]).


prepare_xf :-
    Found = found(false),
    forall(clause(x(XWordList, XTree, XWord), XBody), (
        XWord = [_,[XFIndex|_]|_],
        XF = xf(XFIndex, XWordList, XTree, XWord),
        (not(xf_defined(XF)), wordinfo_all_used(XWordList)) -> (
            /* format('   xf(~w, ~w, ~w, ~w)~n', [XFIndex, XWordList, XTree, XWord]), */
            assert(XF:- XBody),
            nb_setarg(1, Found, true)
        ) ; true
    )),
    Found =@= found(true) -> prepare_xf ; true. % If there is new xf defined, then go through optimization process again,
                            % so that recursive x rules are not lost.

prepare_bf :-
    forall(clause(b(SyntaxRelation, ChildMorphology, ParentMorphology, Position), BBody), (
        morphology_all_used([ChildMorphology, ParentMorphology]) -> (
            /* format('   bf(~w, ~w, ~w, ~w)~n', [SyntaxRelation, ChildMorphology, ParentMorphology, Position]), */
            assert(bf(SyntaxRelation, ChildMorphology, ParentMorphology, Position):- BBody)
        ) ; true
    )).


wordinfo_all_used([]) :- !.

wordinfo_all_used([H|T]) :-
    wordinfo_used(H), !,
    wordinfo_all_used(T), !.

wordinfo_used(WordInfo) :-
    copy_term(WordInfo, CWordInfo), !,
    CWordInfo = [Word, Morphology, _, _, _],
    (af(Word, Morphology, _, _, _); xf(_, _, _, CWordInfo)), !.


morphology_all_used([]) :- !.

morphology_all_used([H|T]) :-
    morphology_used(H), !,
    morphology_all_used(T), !.

morphology_used(Morphology) :-
    copy_term(Morphology, CMorphology), !,
    (af(_, CMorphology, _, _, _); xf(_, _, _, [_, CMorphology, _, _, _])), !.


xf_defined(XF) :-
    copy_term(XF, CXF), !,
    CXF = xf(XFIndex, WordList, Tree, XWord),
    xf(XFIndex, WordList, Tree, XWord), !.

