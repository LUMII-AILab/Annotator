/*****************************************************************************
 * Logical structure and statistics of parsing results 
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Ilmārs Poikāns
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


/* $Revision: 686 $, $Date: 2009-08-21 14:21:17 +0300 (Fri, 21 Aug 2009) $ */

is_empty(X) :- not(var(X)), X == x.

is_syntax_relation(X) :- is_empty(X), !.
is_syntax_relation(priev) :- !.
is_syntax_relation([Role,RuleId]) :- atom(Role), atom(RuleId), !.

is_semantic_role(X) :- (atom(X); is_empty(X)).
is_semantic_role(X) :- var(X). % because we don't set SemanticRole currenlty

is_morphology(_).

is_base_form(X) :- (atomic(X); var(X)).

is_concept(_). /* :- (atomic(X); is_empty(X)). */

is_word(X) :- atomic(X).

is_word_source(X) :- atomic(X).

is_word_meaning(X) :- atomic(X).



is_chunk([]).

is_chunk([H|T]) :- (is_chunk(H); is_chunk_word(H)), is_chunk(T).

is_chunk_word(([SyntaxRelation, SemanticRole, Morphology, BaseForm, Concept, Source, Meaning], Word)) :-
	is_syntax_relation(SyntaxRelation),
	is_semantic_role(SemanticRole),
	is_morphology(Morphology),
	is_base_form(BaseForm),
	is_concept(Concept),
	is_word_source(Source),
	is_word_meaning(Meaning),
	is_word(Word).

is_x_chunk_word(([x, x, _, _, _, _, _], _), Level) :- Level > 1.


is_chunk_list([]).

is_chunk_list([H|T]) :- (is_chunk(H); is_word(H)), is_chunk_list(T).



chunk_main_word([H|_], ChunkMainWord) :-
	is_chunk_word(H),
	H = ([SyntaxRelation, _, _, _, _, _, _], _),
	not(SyntaxRelation == priev),
	ChunkMainWord = H.

chunk_main_word([_|T], ChunkMainWord) :-
	chunk_main_word(T, ChunkMainWord).


chunk_syntax_relation(Chunk, SyntaxRelation) :-
	chunk_main_word(Chunk, ChunkWord),
	ChunkWord = ([SyntaxRelation, _, _, _, _, _, _], _).

chunk_semantic_role(Chunk, SemanticRole) :-
	chunk_main_word(Chunk, ChunkWord),
	ChunkWord = ([_, SemanticRole, _, _, _, _, _], _).


chunk_depth([], 0).

chunk_depth(ChunkWord, 1) :- is_chunk_word(ChunkWord).

chunk_depth([H|T], Depth) :-
	chunk_depth(H, HDepth),
	chunk_depth(T, TDepth),
	(is_chunk_word(H) -> Depth is max(HDepth, TDepth);
	                     Depth is 1 + max(HDepth, TDepth - 1)).


chunk_len([], 0) :- !.

chunk_len(ChunkWord, 1) :- is_chunk_word(ChunkWord), !.

chunk_len(UnknownWord, 0) :- is_word(UnknownWord), !.

chunk_len([H|T], Len) :-
	chunk_len(H, HLen),
	chunk_len(T, TLen),
	Len is HLen + TLen, !.


list_compact_html([], '').

list_compact_html([H|T], HTML) :-
	list_compact_html(T, THTML),
	(is_list(H) -> (list_compact_html(H, HHTML), sformat(HTML, '[~w]~w', [HHTML, THTML]))
	             ; sformat(HTML, '~w~w', [H, THTML])
	), !.


simple_syntax_relation([SyntaxRole, _], [SimpleSyntaxRole, '-']) :-
	simple_syntax_role(SyntaxRole, SimpleSyntaxRole), !.
	
simple_syntax_relation(SyntaxRelation, SyntaxRelation).


simplify_syntax_roles([], []) :- !.

simplify_syntax_roles([H|Tail], [ModH|ModTail]) :-
	simplify_syntax_roles(H, ModH),
	simplify_syntax_roles(Tail, ModTail), !.

simplify_syntax_roles(ChunkWord, ModChunkWord) :-
	ChunkWord = ([SyntaxRelation, SemanticRole, Morphology, BaseForm, Concept, Source, Meaning], Word),
	simple_syntax_relation(SyntaxRelation, ModSyntaxRelation),
	ModChunkWord = ([ModSyntaxRelation, SemanticRole, Morphology, BaseForm, Concept, Source, Meaning], Word), !.

simplify_syntax_roles(ChunkWord, ChunkWord). % unknown word


chunk_list_filter_words([], []).

chunk_list_filter_words([Chunk|Chunks], [Word|Words]) :-
	is_word(Chunk),
	Word=Chunk,
	chunk_list_filter_words(Chunks, Words).

chunk_list_filter_words([Chunk|Chunks], Words) :-
	not(is_word(Chunk)),
	chunk_list_filter_words(Chunks, Words).


% chunk_list_stats(+ChunkList, -TotalWords, -RecognizedWords, -ChunkCount, -ChunkSumLen)

chunk_list_stats([], 0, 0, 0, 0) :- !.

chunk_list_stats(Chunks, 0, 0, 0, 0) :-
	var(Chunks), !.

chunk_list_stats([Chunk|Chunks], TotalWords, RecognizedWords, ChunkCount, ChunkLenSum) :-
	is_word(Chunk),
	chunk_list_stats(Chunks, CTotalWords, CRecognizedWords, CChunkCount, CChunkLenSum),
	TotalWords is CTotalWords + 1,
	RecognizedWords = CRecognizedWords,
	ChunkCount is CChunkCount + 1,
	ChunkLenSum = CChunkLenSum, !.

chunk_list_stats([Chunk|Chunks], TotalWords, RecognizedWords, ChunkCount, ChunkLenSum) :-
	is_chunk(Chunk),
	chunk_len(Chunk, ChunkLen),
	chunk_list_stats(Chunks, CTotalWords, CRecognizedWords, CChunkCount, CChunkLenSum),
	TotalWords is CTotalWords + ChunkLen,
	RecognizedWords is CRecognizedWords + ChunkLen,
	ChunkCount is CChunkCount + 1,
	ChunkLenSum is CChunkLenSum + ChunkLen, !.


chunk_list_list_stats(ChunkListList, 0, 0, 0, 0) :-
	var(ChunkListList), !.

chunk_list_list_stats([], 0, 0, 0, 0) :- !.

chunk_list_list_stats([ChunkList|ChunkLists], TotalWords, RecognizedWords, ChunkCount, ChunkLenSum) :-
	var(ChunkList),
	chunk_list_list_stats(ChunkLists, TotalWords, RecognizedWords, ChunkCount, ChunkLenSum), !.

chunk_list_list_stats([ChunkList|ChunkLists], TotalWords, RecognizedWords, ChunkCount, ChunkLenSum) :-
	not(var(ChunkList)),
	(
		chunk_list_list_stats(ChunkList, HTotalWords, HRecognizedWords, HChunkCount, HChunkLenSum) ;
		chunk_list_stats(ChunkList, HTotalWords, HRecognizedWords, HChunkCount, HChunkLenSum)
	), !,
	chunk_list_list_stats(ChunkLists, TTotalWords, TRecognizedWords, TChunkCount, TChunkLenSum),
	TotalWords is HTotalWords + TTotalWords,
	RecognizedWords is HRecognizedWords + TRecognizedWords,
	ChunkCount is HChunkCount + TChunkCount,
	ChunkLenSum is HChunkLenSum + TChunkLenSum, !.


% chunk_list_filter_unknown_words([], []).

% chunk_list_filter_unknown_words([ChunkList|ChunkLists], [Word|Words]) :-

