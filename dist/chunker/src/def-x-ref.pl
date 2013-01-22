/*****************************************************************************
 * Patterns for analytic, anaphoric word forms of Latvian language
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Normunds Grūzītis, Gunta Nešpore, Baiba Saulīte, Ilze Auziņa
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

% mod_word_list/2 imported from def-x-vpt

term_expansion(x(WordList, Tree, [Word, Morphology], ID), x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word])) :-
	mod_word_list(WordList, WordListMod).

term_expansion(x(WordList, Tree, [Word, Morphology], ID) :- XBody, x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word]) :- XBody) :-
	mod_word_list(WordList, WordListMod).

:- multifile x/3.

:- ensure_loaded('def-x-vpt').

% Anaforas
x([[_, [p, p, 3, GEND, NUM, CASE, NEG, [s]]]], [[_]], [anafora, [p, p, 3, GEND, NUM, CASE, NEG, [ref]]], ref_1).
x([[_, [p, d, 3, GEND, NUM, CASE, NEG, [s]]]], [[_]], [anafora, [p, d, 3, GEND, NUM, CASE, NEG, [ref]]], ref_2).
x([[_, [a, _, GEND, NUM, CASE, y, _]], [_, [n, T, GEND, NUM, CASE, _]]], [_, _], [anafora, [n, T, GEND, NUM, CASE, 0, [ref]]], ref_3).
x([[_, [p, p, 3, GEND, NUM, g, _, [s]]], [_, [n, T, GEND, NUM, CASE, _]]], [[_], _], [anafora, [n, T, GEND, NUM, CASE, 0, [ref]]], ref_4).
x([[_, [p, d, 3, GEND, NUM, CASE, _, [s]]], [_, [n, T, GEND, NUM, CASE, _]]], [[_], _], [anafora, [n, T, GEND, NUM, CASE, 0, [ref]]], ref_5).

% Prievārdekļi ar anaforām
x([[PRE, [s, p, NUM, CASE, [PLACE]]], [anafora, [n, T, GEND, NUM, CASE, _, [ref]]]], [[_], [_]], [prievārdeklis, [n, T, GEND, NUM, CASE, 0, [pre, PLACE, PRE]]], pre_1_ref).
x([[PRE, [s, p, NUM, CASE, [PLACE]]], [anafora, [p, T, PERS, GEND, NUM, CASE, NEG, [ref]]]], [[_], [_]], [prievārdeklis, [p, T, PERS, GEND, NUM, CASE, NEG, [pre, PLACE, PRE]]], pre_2_ref):-member(T, [p, x, d, i, q, r, g]).
x([[anafora, [n, T, GEND, NUM, CASE, _, [ref]]], [PRE, [s, t, NUM, CASE, _]]], [[_], [_]], [prievārdeklis, [n, T, GEND, NUM, CASE, 0, [post, n, PRE]]], pre_3_ref).
x([[anafora, [p, T, PERS, GEND, NUM, CASE, NEG, [ref]]], [PRE, [s, t, NUM, CASE, _]]], [[_], [_]], [prievārdeklis, [p, T, PERS, GEND, NUM, CASE, NEG, [post, n, PRE]]], pre_4_ref):-member(T, [p, x, d, i, q, r, g]).
x([[REL, [r, r, p]], [anafora, [n, T, GEND, NUM, d, _, [ref]]]], [[_], [_]], [pusprievārds, [n, T, GEND, NUM, d, 0, [rel, y, REL]]], pre_5_ref).
x([[REL, [r, r, p]], [anafora, [p, T, PERS, GEND, NUM, d, NEG, [ref]]]], [[_], [_]], [pusprievārds, [p, T, PERS, GEND, NUM, d, NEG, [rel, y, REL]]], pre_6_ref):-member(T, [p, x, d, i, q, r, g]).
x([[anafora, [n, T, GEND, NUM, d, _, [ref]]], [REL, [r, r, p]]], [[_], [_]], [pusprievārds, [n, T, GEND, NUM, d, 0, [rel, y, REL]]], pre_7_ref).
x([[anafora, [p, T, PERS, GEND, NUM, d, NEG, [ref]]], [REL, [r, r, p]]], [[_], [_]], [pusprievārds, [p, T, PERS, GEND, NUM, d, NEG, [rel, y, REL]]], pre_8_ref):-member(T, [p, x, d, i, q, r, g]).
