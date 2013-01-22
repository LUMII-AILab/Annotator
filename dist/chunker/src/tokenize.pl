/*****************************************************************************
 * Predicates for string tokenization
 *
 * Copyright 2009
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


whitespace(Char) :-
	member(Char, " \t\r\n").

punctuation(Char) :-
	member(Char, ",.!?:;'\"„”`´«»-()[]{}<>=…").


specialtoken("...").
specialtoken("---").
specialtoken("--").


% tokenize(+CharCodeList, -AtomTokens)

tokenize([], []) :- !.

tokenize([Char|TChars], Tokens) :-
	whitespace(Char), !,
	tokenize(TChars, Tokens), !.

tokenize(Chars, [Token|TTokens]) :-
	match_token(Chars, TokenChars, ReminderChars),
	string_to_list(TokenString, TokenChars),
	string_to_atom(TokenString, Token), !,
	tokenize(ReminderChars, TTokens), !.


% match_token(+CharCodeList, -TokenCharCodeList, -ReminderCharCodeList)

match_token([], [], []) :- !.

match_token(Chars, SpecialTokenChars, ReminderChars) :-
	specialtoken(SpecialTokenChars),
	append(SpecialTokenChars, ReminderChars, Chars), !.

match_token([Char|TChars], [Char], TChars) :-
	punctuation(Char), !.

match_token(Chars, TokenChars, ReminderChars) :-
	match_word(Chars, TokenChars, ReminderChars).


% match_word(+CharCodeList, -WordCharCodeList, -ReminderCharCodeList)

match_word([], [], []) :- !.

match_word(Chars, [], Chars) :-
	Chars = [Char|_],
	(whitespace(Char); punctuation(Char)), !.

match_word([Char|TChars], [Char|WChars], RChars) :-
	match_word(TChars, WChars, RChars), !.

