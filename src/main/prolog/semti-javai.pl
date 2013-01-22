/* $Revision: 1.17 $, $Date: 2008/06/25 00:32:45 $ */

:- ensure_loaded('semti-core').
:- ensure_loaded('morphology').

                                                                                                
parse_results_java2(Something, JavaResult) :-
	sformat(JavaResult, '~q', [Something]).

parse_results_java([],[]).

parse_results_java([Result | Results], [JavaResult | JavaResults]) :-
	parse_results_java( Results, JavaResults ),
	parse_chunks_java(Result, JavaResult).	

parse_chunks_java([],[]).

parse_chunks_java( [Chunk | Chunks], [JavaResult | JavaResults]) :-
	parse_chunks_java( Chunks, JavaResults),
	parse_chunk_java( Chunk, JavaResult).
	                     

parse_chunk_java( Word , Word ) :-
	is_word(Word).

parse_chunk_java( Word , JavaResult) :-
	is_chunk_word(Word),
	sformat(JavaResult, '~q', Word).

parse_chunk_java( [WordOrChunk | [] ], JavaResult) :-
	parse_chunk_java( WordOrChunk, JavaResult).

parse_chunk_java( [WordOrChunk | Chunk ], [JavaResult | JavaResults]) :-
	parse_chunk_java( WordOrChunk, JavaResult),
	parse_chunk_java( Chunk, JavaResults). 

add_analyzer_words(SWordFormList) :-
	atom_to_term(SWordFormList, WordFormList, _),
	define_analyzer_afs(WordFormList).
                                        
retracttool :-
	retractall(af(_,_,_,tool,_)).