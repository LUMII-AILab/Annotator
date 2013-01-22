/*****************************************************************************
 * Conversion of parsing results to XHTML format
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


/* $Revision: 754 $, $Date: 2010-11-22 13:10:04 +0200 (Mon, 22 Nov 2010) $ */

:- ensure_loaded('semti-core').
:- ensure_loaded('morphology').


parse_results_html_write(Results) :-
	parse_results_html_write(Results, 1).

parse_results_html_write([[]], _) :- !. /* Empty result */

parse_results_html_write([], _) :- !. /* No more results */

parse_results_html_write([Result | Results], ItemNumber) :-
	format('<p class="result-title">~w. variants</p>', [ItemNumber]),
	parse_result_html_write(Result),
	NextItemNumber is ItemNumber + 1,
	parse_results_html_write(Results, NextItemNumber).

parse_result_html_write(Result) :-
	(config(show_chunks, true) -> format('<p class="result-chunk"><span class="title">Chunks:</span> <br />~w</p>', [Result]) ; true),
	(chunks_html_write(Result) ; true).


chunk_html_columns(X, Columns) :- chunk_html_columns(X, Columns, 0).

chunk_html_columns([], 0, _).

chunk_html_columns(ChunkWord, 1, _) :- is_chunk_word(ChunkWord).

chunk_html_columns([H|T], Columns, ListIndex) :-
	NextListIndex is ListIndex + 1,
	chunk_html_columns(H, HColumns, 0),
	chunk_html_columns(T, TColumns, NextListIndex),
	(ListIndex =:= 0 -> Columns is 2 + HColumns + TColumns;
	                    Columns is 1 + HColumns + TColumns).


chunks_html(Chunks, HTML) :- sformat(HTML, '~@', [chunks_html_write(Chunks)]).

chunks_html_write([]).

chunks_html_write([H|T]) :-
	(config(show_chunks, true) -> format('<p class="result-chunk-element"><span class="title">Processing element:</span> <br />~w</p>', [H]) ; true),
	chunk_html_write(H),
	chunks_html_write(T).

chunks_html_write(X) :-
	format('<p>failed to process element ~w </p>', [X]).


chunk_html(Chunk, HTML) :- sformat(HTML, '~@', [chunk_html_write(Chunk)]).


chunk_html_write([]).

chunk_html_write(Word) :-
	is_word(Word),
	format('<p class="chunk-unknown">~w</p>~n', [Word]).

chunk_html_write(Chunk) :-
	is_chunk(Chunk),
	chunk_depth(Chunk, MaxDepth),
	format('<table class="chunk">~n<tbody>~n'),
	MinRow is -(MaxDepth + 1),
	MaxRow is MaxDepth + 1,
	forall(between(MinRow, MaxRow, Row),
		format('<tr>~n~@</tr>~n',[chunk_html_write(Chunk, 0, Row, MaxDepth)])),
	format('</tbody>~n</table>~n').

chunk_html_write([], _, _, _).

chunk_html_write([H|T], Level, Row, MaxLevel) :-
	chunk_html_columns([H|T], HTMLCols),
	chunk_main_word([H|T], ChunkWord),
	(ChunkWord = ([_, _, _, _, _, Source, _], _) ; Source = undef),
	(Source == xdefs -> ChunkType = 'x-chunk-head' ; (is_x_chunk_word(ChunkWord, Level+1) -> ChunkType = 'x-chunk'; ChunkType = 'chunk')),
	(Row =:= -(MaxLevel - Level + 1) -> (chunk_syntax_relation([H|T], SyntaxRelation), syntax_relation_html(SyntaxRelation, HTMLSyntaxRelation), format('<td class="~w-word-synrel" colspan="~w">~w</td>~n', [ChunkType, HTMLCols, HTMLSyntaxRelation])); true),
/*	((Row >= -(MaxLevel - Level), Row =< MaxLevel - Level) -> format('<td class="~w-border-left">&nbsp;</td>~n', [ChunkType]); true), */
	((Row =:= -(MaxLevel - Level)) -> (RowSpan is 2*(MaxLevel-Level) + 1, format('<td class="~w-border-left" rowspan="~w">&nbsp;</td>~n', [ChunkType, RowSpan])); true),
	chunk_html_write([H|T], Level, 0, Row, MaxLevel),
	((Row =:= -(MaxLevel - Level)) -> (RowSpan is 2*(MaxLevel-Level) + 1, format('<td class="~w-border-right" rowspan="~w">&nbsp;</td>~n', [ChunkType, RowSpan])); true),
/*	((Row >= -(MaxLevel - Level), Row =< MaxLevel - Level) -> format('<td class="~w-border-right">&nbsp;</td>~n', [ChunkType]); true), */
	(Row =:= (MaxLevel - Level + 1) -> (chunk_semantic_role([H|T], SemanticRole), semantic_role_html(SemanticRole, HTMLSemanticRole), format('<td class="~w-word-semrole" colspan="~w">~w</td>~n', [ChunkType, HTMLCols, HTMLSemanticRole])); true).

chunk_html_write(ChunkWord, Level, Row, MaxLevel) :-
	is_chunk_word(ChunkWord),
	chunk_html_write(ChunkWord, Level, 0, Row, MaxLevel).


chunk_html_write([], _, _, _, _).

chunk_html_write([H|T], Level, ListIndex, Row, MaxLevel) :-
	NextLevel is Level + 1,
	((ListIndex > 0, Row > -(MaxLevel - Level + 1), Row < (MaxLevel - Level + 1)) -> format('<td>&nbsp;</td>~n'); true),
	chunk_html_write(H, NextLevel, Row, MaxLevel),
	NextListIndex is ListIndex + 1,
	chunk_html_write(T, Level, NextListIndex, Row, MaxLevel).

chunk_html_write(ChunkWord, Level, _ListIndex, Row, MaxLevel) :-
	is_chunk_word(ChunkWord),
	ChunkWord = ([_, _, Morphology, BaseForm, _Concept, Source, Meaning], Word),
	(Source == xdefs -> ChunkType = 'x-chunk-head' ; (is_x_chunk_word(ChunkWord, Level) -> ChunkType = 'x-chunk'; ChunkType = 'chunk')),
	(Row =:= -1 -> (morphology_html(Morphology, HTMLMorphology), morphology_code_html(Morphology, HTMLMorphologyCode), (config(show_mcode, true) -> format('<td class="~w-word-morphology">~w<br />~w</td>~n', [ChunkType, HTMLMorphology, HTMLMorphologyCode]) ; format('<td class="~w-word-morphology">~w</td>~n', [ChunkType, HTMLMorphology]))); true),
	(Row =:=  0 -> (word_html(Word, HTMLWord), phrase(html_quoted_attribute(Meaning), [HTMLMeaning]), format('<td class="~w-word" title="~w">~w</td>~n', [ChunkType, HTMLMeaning, HTMLWord])) ; true),
	(Row =:=  1 -> (base_form_html(BaseForm, HTMLBaseForm), format('<td class="~w-word-concept"><b>~w</b><br>~w</td>~n', [ChunkType, HTMLBaseForm, Source])) ; true),
	(((Row >  1, Row < (MaxLevel - Level + 2)) ; (Row < -1, Row > -(MaxLevel - Level + 2))) -> format('<td>&nbsp;</td>~n') ; true).


word_html(Word, HTMLWord) :- sformat(HTMLWord, '~w', [Word]).

morphology_html(Morphology, '&nbsp;') :- not(var(Morphology)), is_empty(Morphology).

morphology_html(Morphology, '-') :- var(Morphology).

morphology_html([H|T], HTMLMorphology) :-
	morphology_word_type(H, lv, WordType),
	(morphology_word_info([H|T], lvsh, WordInfo); list_compact_html(T, WordInfo)),
	sformat(HTMLMorphology, '<span class="word-type">~w</span><br /><span class="word-info">~w</span>', [WordType, WordInfo]).

morphology_html(Morphology, HTMLMorphology) :-
	not(is_empty(Morphology); var(Morphology); is_list(Morphology)),
	sformat(HTMLMorphology, '!~w!', [Morphology]).

morphology_code_html(Morphology, HTMLMorphologyCode) :-
	is_list(Morphology),
	list_compact_html(Morphology, MorphologyCode),
	sformat(HTMLMorphologyCode, '<span class="morphology-code">~w</span>', [MorphologyCode]).

morphology_code_html(Morphology, HTMLMorphologyCode) :-
	not(is_list(Morphology)),
	sformat(HTMLMorphologyCode, '&nbsp;', [Morphology]).


base_form_html(BaseForm, '&nbsp;') :- is_empty(BaseForm), !.

base_form_html(BaseForm, '&nbsp;') :- var(BaseForm), !.

base_form_html(BaseForm, BaseForm).


syntax_relation_html(SyntaxRelation, '&nbsp;') :- is_empty(SyntaxRelation).

syntax_relation_html([SyntaxRole, RuleId], HTMLSyntaxRelation) :-
	not(is_empty(SyntaxRole)), not(is_empty(RuleId)),
	sformat(HTMLSyntaxRelation, '#~w, ~w', [SyntaxRole, RuleId]).

semantic_role_html(SemanticRole, '&nbsp;') :- is_empty(SemanticRole).

semantic_role_html(SemanticRole, '&nbsp;') :- var(SemanticRole). % parser doesn''t return semantic role currently

semantic_role_html(SemanticRole, HTMLSemanticRole) :-
	not(is_empty(SemanticRole)),
	sformat(HTMLSemanticRole, '#~w', [SemanticRole]).


parse_stats_html_write(ParseResults, _) :-
	var(ParseResults), !.

parse_stats_html_write(ParseResults, HtmlClass) :-
	not(var(ParseResults)),
	(
		chunk_list_list_stats(ParseResults, TotalWords, RecognizedWords, ChunkCount, ChunkLenSum) ;
		chunk_list_stats(ParseResults, TotalWords, RecognizedWords, ChunkCount, ChunkLenSum)
	), !,
	UnknownWords is TotalWords - RecognizedWords,
	GoodChunkCount is ChunkCount - UnknownWords,
	(TotalWords > 0 -> RecognizedWordsPrc is RecognizedWords * 100 / TotalWords ; RecognizedWordsPrc is 0.0),
	(GoodChunkCount > 0 -> AverageChunkLen is ChunkLenSum / GoodChunkCount * RecognizedWords / TotalWords ; AverageChunkLen is 0.0),
	format('<p class="~w">Vārdu skaits: ~d (~2f% atpazīti); Čanki: ~d (vidējais garums: ~2f)</p>', [HtmlClass, TotalWords, RecognizedWordsPrc, GoodChunkCount, AverageChunkLen]),
	!.

parse_stats_html_write(_, HtmlClass) :-
	format('<p class="~w">Error calculating stats</p>', [HtmlClass]).


parse_stats_html_write(ParseResults) :-
	parse_stats_html_write(ParseResults, 'result-title').


html_quoted_attribute(Text) -->
	{ sub_atom(Text, _, _, _, <)
	; sub_atom(Text, _, _, _, >)
	; sub_atom(Text, _, _, _, '"')
	}, !,
	{ atom_chars(Text, Chars),
	  quote_att_chars(Chars, QuotedChars),
	  concat_atom(QuotedChars, Quoted)
	},
	[ Quoted ].
html_quoted_attribute(Text) -->
	[ Text ].

quote_att_chars([], []).
quote_att_chars([H0|T0], [H|T]) :-
	quote_att_char(H0, H),
	quote_att_chars(T0, T).

quote_att_char(<, '&lt;') :- !.
quote_att_char(>, '&gt;') :- !.
quote_att_char('"', '&quot;') :- !.
quote_att_char(X, X).
