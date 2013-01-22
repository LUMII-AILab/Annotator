/*****************************************************************************
 * Patterns for analytic word forms of Latvian language
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Normunds Grūzītis, Gunta Nešpore, Baiba Saulīte
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
 

/* $Revision: 741 $, $Date: 2009-12-14 16:01:20 +0200 (Mon, 14 Dec 2009) $ */

mod_word_list([], []).

mod_word_list([[Word, Morphology] | WordList], [[Word, Morphology, _, _, _] | WordListMod]) :-
	mod_word_list(WordList, WordListMod).

term_expansion(x(WordList, Tree, [Word, Morphology], ID), x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word])) :-
	mod_word_list(WordList, WordListMod).

term_expansion(x(WordList, Tree, [Word, Morphology], ID) :- XBody, x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word]) :- XBody) :-
	mod_word_list(WordList, WordListMod).

% Active voice predicates
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, REFL, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, m, REFL, i, TENSE, 0, 0, PERS, NUM, a, NEG, [act, p, GEND, n]]], act_1):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, T, REFL, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, T, REFL, i, TENSE, 0, 0, 3, NUM, a, NEG, [act, p, GEND, n]]], act_2):-member(T, [m, g]).
x([[_, [v, g, n, i, TENSE, i, i, 3, 0, a, y]], [_, [v, c, n, p, d, m, s, n, a, s, n]]], [[_], _], [izteicējs, [v, g, n, i, TENSE, 0, 0, 3, s, a, y, [act, p, m, n]]], act_3).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, T, REFL, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, T, REFL, r, TENSE, 0, 0, 0, NUM, a, NEG, [act, p, GEND, n]]], act_4):-member(TENSE, [p, f]) ,  member(T, [m, g]).
x([[_, [v, g, n, r, TENSE, i, i, 0, 0, a, y]], [_, [v, c, n, p, d, m, s, n, a, s, n]]], [[_], _], [izteicējs, [v, g, n, r, TENSE, 0, 0, 0, s, a, y, [act, p, m, n]]], act_5):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, T, REFL, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, T, REFL, c, 0, 0, 0, 0, NUM, a, NEG, [act, p, GEND, n]]], act_6):-member(T, [m, g]).
x([[_, [v, g, n, c, 0, i, i, 0, 0, a, y]], [_, [v, c, n, p, d, m, s, n, a, s, n]]], [[_], _], [izteicējs, [v, g, n, c, 0, 0, 0, 0, s, a, y, [act, p, m, n]]], act_7).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [act, s, 0, 0]]], act_8).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [act, s, 0, 0]]], act_9):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], _], [izteicējs, [v, m, REFL, d, 0, TRANS, 0, 0, 0, a, NEG, [act, s, 0, 0]]], act_10).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, _, _, n, a, s, n]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], [_], _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [act, p, 0, 0]]], act_11).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, _, n, a, s, n]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], [_], _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [act, p, 0, 0]]], act_12).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, _, n, a, s, n]], [_, [v, m, REFL, d, 0, TRANS, _, 0, 0, a, n]]], [[_], [_], _], [izteicējs, [v, m, REFL, d, 0, TRANS, 0, 0, 0, a, NEG, [act, p, 0, 0]]], act_13).

% Passive voice predicates
x([[_, [v, t, n, i, TENSE, i, 1, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, i, TENSE, 0, 0, PERS, NUM, p, NEG, [pass, s, GEND, n]]], pass_1):-member(PERS, [1, 2]).
x([[_, [v, t, n, i, TENSE, i, 1, 3, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, i, TENSE, 0, 0, 3, NUM, p, NEG, [pass, s, GEND, n]]], pass_2).
x([[_, [v, t, n, d, 0, i, 1, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], _], [izteicējs, [v, m, n, d, p, 0, 0, 0, NUM, p, n, [pass, s, GEND, d]]], pass_3).
x([[_, [v, t, n, r, TENSE, i, 1, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, r, TENSE, 0, 0, 0, NUM, p, NEG, [pass, s, GEND, n]]], pass_4):-member(TENSE, [p, f]).
x([[_, [v, t, n, c, 0, i, 1, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, c, 0, 0, 0, 0, NUM, p, NEG, [pass, s, GEND, n]]], pass_5).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, i, TENSE, 0, 0, PERS, NUM, p, NEG, [pass, p, GEND, n]]], pass_6):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, i, TENSE, 0, 0, 3, NUM, p, NEG, [pass, p, GEND, n]]], pass_7).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, r, TENSE, 0, 0, 0, NUM, p, NEG, [pass, p, GEND, n]]], pass_8):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, n, c, 0, 0, 0, 0, NUM, p, NEG, [pass, p, GEND, n]]], pass_9).

% Nominal predicates (noun)
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [n, _, GEND, _, n, _]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [subst, s, GEND, n]]], subst_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [n, _, GEND, _, n, _]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, 0, a, NEG, [subst, s, GEND, n]]], subst_2):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [n, _, GEND, _, n, _]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, 0, a, NEG, [subst, s, GEND, n]]], subst_3).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [n, _, _, _, n, _]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [subst, p, GEND, n]]], subst_4):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [n, _, _, _, n, _]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [subst, p, GEND, n]]], subst_5).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [n, _, _, _, n, _]]], [[_], [_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [subst, p, GEND, n]]], subst_6):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [n, _, GEND, _, n, _]]], [[_], [_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [subst, p, GEND, n]]], subst_7).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [subst, s, GEND, d]]], subst_8).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [subst, s, GEND, d]]], subst_9):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [subst, s, GEND, d]]], subst_10).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [subst, p, GEND, d]]], subst_11).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [subst, p, GEND, d]]], subst_12):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [n, _, GEND, _, d, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [subst, p, GEND, d]]], subst_13).

% Nominal predicates (pronoun)
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [p, T, _, GEND, _, n, _, [_]]]], [[_], [_]], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [pronom, s, GEND, n]]], pronom_1):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [p, T, _, GEND, _, n, _, [_]]]], [[_], [_]], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, 0, a, NEG, [pronom, s, GEND, n]]], pronom_2):-member(TENSE, [p, f]) ,  member(T, [p, s, d, i, g]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [p, T, _, GEND, _, n, _, [_]]]], [[_], [_]], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, 0, a, NEG, [pronom, s, GEND, n]]], pronom_3):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [p, T, _, _, _, n, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [pronom, p, GEND, n]]], pronom_4):-member(PERS, [1, 2]) ,  member(T, [p, s, d, i, g]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [p, T, _, _, _, n, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [pronom, p, GEND, n]]], pronom_5):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [p, T, _, _, _, n, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, 0, NUM, a, NEG, [pronom, p, GEND, n]]], pronom_6):-member(TENSE, [p, f]) ,  member(T, [p, s, d, i, g]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [p, T, _, _, _, n, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [pronom, p, GEND, n]]], pronom_7):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [pronom, s, GEND, d]]], pronom_8):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [pronom, s, GEND, d]]], pronom_9):-member(TENSE, [p, f]) ,  member(T, [p, s, d, i, g]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_]], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [pronom, s, GEND, d]]], pronom_10):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_], [_]], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [pronom, p, GEND, d]]], pronom_11):-member(T, [p, s, d, i, g]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_], [_]], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [pronom, p, GEND, d]]], pronom_12):-member(TENSE, [p, f]) ,  member(T, [p, s, d, i, g]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [p, T, _, GEND, _, d, _, [_]]]], [[_], [_], [_], [_]], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [pronom, p, GEND, d]]], pronom_13):-member(T, [p, s, d, i, g]).

% Nominal predicates (adjective)
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, s, GEND, n]]], adj_1):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, s, GEND, n]]], adj_2).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_3):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_4).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, p, GEND, n]]], adj_5):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, p, GEND, n]]], adj_6).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_7):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [a, _, GEND, NUM, n, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_8).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_9).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_10):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_11).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_12).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_13):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [a, _, GEND, NUM, d, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_14).

% Nominal predicates (participle)
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, s, GEND, n]]], adj_15):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, s, GEND, n]]], adj_16).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_17):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_18).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, p, GEND, n]]], adj_19):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, p, GEND, n]]], adj_20).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_21).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_22).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_23).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_24).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_25).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_26).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_27).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_28).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, s, GEND, n]]], adj_29):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, s, GEND, n]]], adj_30).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_31):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_32).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_33).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_34):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_35).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_36).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_37):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, a, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_38).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, s, GEND, n]]], adj_39).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_40).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_41).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, p, GEND, n]]], adj_42):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, p, GEND, n]]], adj_42_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_43).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_44).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_45).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_46).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_47).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_48).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_49).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, s, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_50).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, s, GEND, n]]], adj_51):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, s, GEND, n]]], adj_52).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_53):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, n]]], adj_54).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, PERS, NUM, a, NEG, [adj, p, GEND, n]]], adj_55):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 3, NUM, a, NEG, [adj, p, GEND, n]]], adj_55_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_56):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, n, p, d, GEND, NUM, n, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, i, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, n]]], adj_57).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_58).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_59).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, s, GEND, d]]], adj_60).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_61).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_62).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [v, m, n, p, d, GEND, NUM, d, p, p, n]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, NUM, a, NEG, [adj, p, GEND, d]]], adj_63).

% Adverbial predicates
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [r, _, _]]], [[_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 0, 0, a, NEG, [adv, s, 0, 0]]], adv_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [r, _, _]]], [[_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, 0, a, NEG, [adv, s, 0, 0]]], adv_2):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [r, _, _]]], [[_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, 0, a, NEG, [adv, s, 0, 0]]], adv_3).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, i, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_4).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, r, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_5):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, c, 0, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_6).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_7).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_8):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_9).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_10).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, TENSE, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_11):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, m, s, n, a, s, n]], [_, [v, c, n, d, 0, i, i, 0, 0, a, n]], [_, [r, _, _]]], [[_], [_], [_], _], [izteicējs, [v, m, 0, d, 0, 0, 0, 0, 0, a, NEG, [adv, p, 0, 0]]], adv_12).

% Modal predicates
x([[_, [v, o, n, i, TENSE, t, _, PERS, NUM, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, PERS, NUM, a, NEG, [modal, s, 0, 0]]], modal_1).
x([[_, [v, o, n, i, TENSE, t, _, PERS, NUM, a, NEG]]], [_], [redukcija, [v, m, n, i, TENSE, t, 0, PERS, NUM, a, NEG, [modal_red, s, 0, 0]]], modal_1_1).
x([[_, [v, o, n, r, TENSE, t, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, 0, a, NEG, [modal, s, 0, 0]]], modal_2):-member(TENSE, [p, f]).
x([[_, [v, o, n, r, TENSE, t, _, 0, 0, a, NEG]]], [_], [redukcija, [v, m, n, r, TENSE, t, 0, 0, 0, a, NEG, [modal_red, s, 0, 0]]], modal_2_1):-member(TENSE, [p, f]).
x([[_, [v, o, n, c, 0, t, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, 0, a, NEG, [modal, s, 0, 0]]], modal_3).
x([[_, [v, o, n, c, 0, t, _, 0, 0, a, NEG]]], [_], [redukcija, [v, m, n, c, 0, t, 0, 0, 0, a, NEG, [modal_red, s, 0, 0]]], modal_3_1).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, PERS, NUM, a, NEG, [modal, p, GEND, n]]], modal_4):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, i, TENSE, t, 0, PERS, NUM, a, NEG, [modal_red, p, GEND, n]]], modal_4_1):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, 3, NUM, a, NEG, [modal, p, GEND, n]]], modal_5).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, i, TENSE, t, 0, 3, NUM, a, NEG, [modal_red, p, GEND, n]]], modal_5_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, NUM, a, NEG, [modal, p, GEND, n]]], modal_6):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, r, TENSE, t, 0, 0, NUM, a, NEG, [modal_red, p, GEND, n]]], modal_6_1):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, NUM, a, NEG, [modal, p, GEND, n]]], modal_7).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, o, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, c, 0, t, 0, 0, NUM, a, NEG, [modal_red, p, GEND, n]]], modal_7_1).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [modal, s, 0, 0]]], modal_8).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [modal_red, s, 0, 0]]], modal_8_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [modal, s, 0, 0]]], modal_9):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [modal_red, s, 0, 0]]], modal_9_1):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, 0, TRANS, 0, 0, 0, a, NEG, [modal, s, 0, 0]]], modal_10).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, 0, t, 0, 0, 0, a, NEG, [modal_red, s, 0, 0]]], modal_10_1).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, 0, TRANS, 0, 0, 0, a, NEG, [modal, p, 0, 0]]], modal_10_2).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [modal, p, 0, 0]]], modal_11).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]]], [[_], [_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [modal_red, p, 0, 0]]], modal_11_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [modal, p, 0, 0]]], modal_12):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, o, n, d, 0, _, _, 0, 0, a, n]]], [[_], [_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [modal_red, p, 0, 0]]], modal_12_1):-member(TENSE, [p, f]).

% Phase predicates
x([[_, [v, p, n, i, TENSE, t, _, PERS, NUM, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, PERS, NUM, a, NEG, [phase, s, 0, 0]]], phase_1).
x([[_, [v, p, n, i, TENSE, t, _, PERS, NUM, a, NEG]]], [_], [redukcija, [v, m, n, i, TENSE, t, 0, PERS, NUM, a, NEG, [phase_red, s, 0, 0]]], phase_1_1).
x([[_, [v, p, n, r, TENSE, t, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, 0, a, NEG, [phase, s, 0, 0]]], phase_2):-member(TENSE, [p, f]).
x([[_, [v, p, n, r, TENSE, t, _, 0, 0, a, NEG]]], [_], [redukcija, [v, m, n, r, TENSE, t, 0, 0, 0, a, NEG, [phase_red, s, 0, 0]]], phase_2_1):-member(TENSE, [p, f]).
x([[_, [v, p, n, c, 0, t, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, 0, a, NEG, [phase, s, 0, 0]]], phase_3).
x([[_, [v, p, n, c, 0, t, _, 0, 0, a, NEG]]], [_], [redukcija, [v, m, n, c, 0, t, 0, 0, 0, a, NEG, [phase_red, s, 0, 0]]], phase_3_1).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, PERS, NUM, a, NEG, [phase, p, GEND, n]]], phase_4):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, PERS, NUM, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, i, TENSE, t, 0, PERS, NUM, a, NEG, [phase_red, p, GEND, n]]], phase_4_1):-member(PERS, [1, 2]).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, 3, NUM, a, NEG, [phase, p, GEND, n]]], phase_5).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, i, TENSE, t, 0, 3, NUM, a, NEG, [phase_red, p, GEND, n]]], phase_5_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, NUM, a, NEG, [phase, p, GEND, n]]], phase_6):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, r, TENSE, t, 0, 0, NUM, a, NEG, [phase_red, p, GEND, n]]], phase_6_1):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, NUM, a, NEG, [phase, p, GEND, n]]], phase_7).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, p, n, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [redukcija, [v, m, n, c, 0, t, 0, 0, NUM, a, NEG, [phase_red, p, GEND, n]]], phase_7_1).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [phase, s, 0, 0]]], phase_8).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [phase_red, s, 0, 0]]], phase_8_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [phase, s, 0, 0]]], phase_9):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [phase_red, s, 0, 0]]], phase_9_1):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, d, 0, TRANS, 0, 0, 0, a, NEG, [phase, s, 0, 0]]], phase_10).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]]], [[_], _], [redukcija, [v, m, n, d, 0, t, 0, 0, 0, a, NEG, [phase_red, s, 0, 0]]], phase_10_1).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, 0, 0, TRANS, 0, 0, 0, a, NEG, [phase, p, 0, 0]]], phase_10_2).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [phase, p, 0, 0]]], phase_11).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]]], [[_], [_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [phase_red, p, 0, 0]]], phase_11_1).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], [_], _, _], [izteicējs, [v, m, REFL, d, TENSE, TRANS, 0, 0, 0, a, NEG, [phase, p, 0, 0]]], phase_12):-member(TENSE, [p, f]).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, c, n, p, d, _, s, n, a, s, n]], [_, [v, p, n, d, 0, _, _, 0, 0, a, n]]], [[_], [_], _], [redukcija, [v, m, n, d, TENSE, t, 0, 0, 0, a, NEG, [phase_red, p, 0, 0]]], phase_12_1):-member(TENSE, [p, f]).
x([[_, [v, p, n, m, p, t, _, 2, NUM, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, m, p, TRANS, 0, 2, NUM, a, NEG, [phase, s, 0, 0]]], phase_13).
x([[_, [v, p, n, m, p, t, _, 2, NUM, a, NEG]]], [_], [redukcija, [v, m, n, m, p, t, 0, 2, NUM, a, NEG, [phase_red, s, 0, 0]]], phase_13_1).

% Expressive predicates
x([[_, [v, e, _, i, TENSE, i, _, 3, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, 0, 0, a, NEG, [expr, s, 0, 0]]], expr_1).
x([[_, [v, e, _, r, TENSE, i, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, 0, a, NEG, [expr, s, 0, 0]]], expr_2):-member(TENSE, [p, f]).
x([[_, [v, e, _, c, 0, i, _, 0, 0, a, NEG]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [_, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, 0, a, NEG, [expr, s, 0, 0]]], expr_3).
x([[_, [v, c, n, i, TENSE, i, i, 3, 0, a, NEG]], [_, [v, e, _, p, d, m, s, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, i, TENSE, TRANS, 0, 0, 0, a, NEG, [expr, p, 0, 0]]], expr_4).
x([[_, [v, c, n, r, TENSE, i, i, 0, 0, a, NEG]], [_, [v, e, _, p, d, m, s, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, r, TENSE, TRANS, 0, 0, 0, a, NEG, [expr, p, 0, 0]]], expr_5):-member(TENSE, [p, f]).
x([[_, [v, c, n, c, 0, i, i, 0, 0, a, NEG]], [_, [v, e, _, p, d, m, s, n, a, s, n]], [_, [v, m, REFL, n, 0, TRANS, _, 0, 0, 0, _]]], [[_], _, _], [izteicējs, [v, m, REFL, c, 0, TRANS, 0, 0, 0, a, NEG, [expr, p, 0, 0]]], expr_6).

% Semi-predicative components
x([[_, [v, m, REFL, p, d, GEND, NUM, n, a, s, n]], [_, [z, c]]], [_, [_]], [spk, [v, m, REFL, p, d, GEND, NUM, n, a, s, n, [spk, dt]]], spk_1).
x([[_, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0]], [_, [z, c]]], [_, [_]], [spk, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0, [spk, dt]]], spk_2).
x([[_, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0]], [_, [z, c]]], [_, [_]], [spk, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0, [spk, dt]]], spk_3).
x([[_, [z, c]], [_, [v, m, REFL, p, d, GEND, NUM, n, a, s, n]]], [[_], _], [spk, [v, m, REFL, p, d, GEND, NUM, n, a, s, n, [spk, dt]]], spk_4).
x([[_, [z, c]], [_, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0]]], [[_], _], [spk, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0, [spk, dt]]], spk_5).
x([[_, [z, c]], [_, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0]]], [[_], _], [spk, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0, [spk, dt]]], spk_6).
x([[_, [z, c]], [_, [v, m, REFL, p, d, GEND, NUM, n, a, s, n]], [_, [z, c]]], [[_], _, [_]], [spk, [v, m, REFL, p, d, GEND, NUM, n, a, s, n, [spk, dt]]], spk_7).
x([[_, [z, c]], [_, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0]], [_, [z, c]]], [[_], _, [_]], [spk, [v, m, REFL, p, p, GEND, NUM, n, a, p, 0, [spk, dt]]], spk_8).
x([[_, [z, c]], [_, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0]], [_, [z, c]]], [[_], _, [_]], [spk, [v, m, REFL, p, u, 0, 0, 0, 0, 0, 0, [spk, dt]]], spk_9).
x([[_, [z, c]], [_, [n, c, GEND, NUM, CASE, _]], [_, [z, c]]], [[_], _, [_]], [spk, [n, c, GEND, NUM, CASE, 0, [spk, sp]]], spk_10).
x([[_, [z, c]], [_, [n, c, GEND, NUM, CASE, _]]], [[_], _], [spk, [n, c, GEND, NUM, CASE, 0, [spk, sp]]], spk_11).
x([[_, [z, c]], [_, [a, T, GEND, NUM, CASE, n, p]], [_, [z, c]]], [[_], _, [_]], [spk, [a, T, GEND, NUM, CASE, n, p, [spk, sa]]], spk_12).
x([[_, [z, c]], [_, [a, T, GEND, NUM, CASE, n, p]]], [[_], _], [spk, [a, T, GEND, NUM, CASE, n, p, [spk, sa]]], spk_13).
x([[kā, [q, s]], [_, [n, c, GEND, NUM, CASE, _]]], [[_], _], [spk, [n, c, GEND, NUM, CASE, 0, [spk, sd]]], spk_14).

% Prepositions
x([[PRE, [s, p, NUM, CASE, [PLACE]]], [_, [n, T, GEND, NUM, CASE, _]]], [[_], _], [prievārdeklis, [n, T, GEND, NUM, CASE, 0, [pre, PLACE, PRE]]], pre_1).
x([[PRE, [s, p, NUM, CASE, [PLACE]]], [_, [p, T, PERS, GEND, NUM, CASE, NEG, [_]]]], [[_], [_]], [prievārdeklis, [p, T, PERS, GEND, NUM, CASE, NEG, [pre, PLACE, PRE]]], pre_2):-member(T, [p, d, i, q, r, g]).
x([[PRE, [s, p, s, CASE, [PLACE]]], [_, [p, x, 0, 0, 0, CASE, NEG, [_]]]], [[_], [_]], [prievārdeklis, [p, x, 0, 0, 0, CASE, NEG, [pre, PLACE, PRE]]], pre_2_1).
x([[_, [n, T, GEND, NUM, CASE, _]], [PRE, [s, t, NUM, CASE, _]]], [_, [_]], [prievārdeklis, [n, T, GEND, NUM, CASE, 0, [post, n, PRE]]], pre_3).
x([[_, [p, T, PERS, GEND, NUM, CASE, NEG, [_]]], [PRE, [s, t, NUM, CASE, _]]], [[_], [_]], [prievārdeklis, [p, T, PERS, GEND, NUM, CASE, NEG, [post, n, PRE]]], pre_4):-member(T, [p, d, i, q, r, g]).
x([[_, [p, x, 0, 0, 0, CASE, NEG, [_]]], [PRE, [s, t, s, CASE, _]]], [[_], [_]], [prievārdeklis, [p, x, 0, 0, 0, CASE, NEG, [post, n, PRE]]], pre_4_1).
x([[REL, [r, r, p]], [_, [n, T, GEND, NUM, d, _]]], [[_], _], [pusprievārds, [n, T, GEND, NUM, d, 0, [rel, y, REL]]], pre_5).
x([[REL, [r, r, p]], [_, [p, T, PERS, GEND, NUM, d, NEG, [_]]]], [[_], [_]], [pusprievārds, [p, T, PERS, GEND, NUM, d, NEG, [rel, y, REL]]], pre_6):-member(T, [p, d, i, q, r, g]).
x([[_, [n, T, GEND, NUM, d, _]], [REL, [r, r, p]]], [_, [_]], [pusprievārds, [n, T, GEND, NUM, d, 0, [rel, y, REL]]], pre_7).
x([[_, [p, T, PERS, GEND, NUM, d, NEG, [_]]], [REL, [r, r, p]]], [[_], [_]], [pusprievārds, [p, T, PERS, GEND, NUM, d, NEG, [rel, y, REL]]], pre_8):-member(T, [p, d, i, q, r, g]).

% Numerals
x([[_, [m, c, c, 0, p, 0, [d]]], [_, [m, T, s, GEND, NUM, CASE, [v]]]], [[_], [_]], [skaitlis, [m, T, j, GEND, NUM, CASE, [d]]], num_1).
x([[_, [m, c, _, 0, p, 0, [s]]], [_, [m, T, s, GEND, NUM, CASE, [v]]]], [[_], [_]], [skaitlis, [m, T, j, GEND, NUM, CASE, [s]]], num_2).
x([[_, [m, c, _, 0, p, 0, [s]]], [_, [m, T, c, 0, p, 0, [O]]]], [[_], [_]], [skaitlis, [m, T, j, 0, p, 0, [s]]], num_3):-member(O, [d, p]).

% Appositions
x([[_, [n, c, GEND, NUM, CASE, _]], [_, [n, p, GEND, NUM, CASE, _]]], [[_], [_]], [pielikums, [n, p, GEND, NUM, CASE, 0]], app_1).

% Coordinated parts of sentence (nouns)
x([[_, [n, _, _, _, CASE, _]], [',', [z, c]], [_, [n, _, _, _, CASE, _]]], [_, [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_1).
x([[_, [n, _, _, _, CASE, _]], [un, [c, c, s]], [_, [n, _, _, _, CASE, _]]], [_, [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_2).
x([[_, [n, _, _, _, CASE, _]], [vai, [c, c, s]], [_, [n, _, _, _, CASE, _]]], [_, [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_3).
x([[_, [n, _, _, _, CASE, _]], [jeb, [c, c, s]], [_, [n, _, _, _, CASE, _]]], [_, [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_4).
x([[_, [n, _, _, _, CASE, _]], [',', [z, c]], [nevis, [c, c, s]], [_, [n, _, _, _, CASE, _]]], [_, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_5).
x([[_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet, [c, c, s]], [_, [n, _, _, _, CASE, _]]], [_, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_6).
x([[gan, [c, c, r]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [gan, [c, c, r]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_7).
x([[kā, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [tā, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_8).
x([[ne_tikai, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_9).
x([[ne_tikvien, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_10).
x([[ne_vien, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_11).
x([[ne, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_12).
x([[nedz, [c, c, r]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [nedz, [c, c, r]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_13).
x([[ne, [c, c, r]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [ne, [c, c, r]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_14).
x([[nevis, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [bet, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_15).
x([[te, [c, c, r]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [te, [c, c, r]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_16).
x([[vai_nu, [c, c, d]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [vai, [c, c, d]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_17).
x([[vai, [c, c, r]], [_, [n, _, _, _, CASE, _]], [',', [z, c]], [vai, [c, c, r]], [_, [n, _, _, _, CASE, _]]], [[_], _, [_], [_], _], [apvienojums, [n, _, _, p, CASE, 0]], vtl_18).

% Coordinated parts of sentence (adjectives)
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_19).
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [un, [c, c, s]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_20).
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [vai, [c, c, s]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_21).
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [jeb, [c, c, s]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_22).
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [nevis, [c, c, s]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_23).
x([[_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet, [c, c, s]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [_, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_24).
x([[gan, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [gan, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_25).
x([[kā, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [tā, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_26).
x([[ne_tikai, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_27).
x([[ne_tikvien, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_28).
x([[ne_vien, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_29).
x([[ne, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_30).
x([[nedz, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [nedz, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_31).
x([[ne, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [ne, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_32).
x([[nevis, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [bet, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_33).
x([[te, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [te, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_34).
x([[vai_nu, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [vai, [c, c, d]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_35).
x([[vai, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]], [',', [z, c]], [vai, [c, c, r]], [_, [a, _, GEND, NUM, CASE, DEF, DEG]]], [[_], _, [_], [_], _], [apvienojums, [a, _, GEND, NUM, CASE, DEF, DEG]], vtl_36).

% Coordinated parts of sentence (adverbs)
x([[_, [r, _, _]], [',', [z, c]], [_, [r, _, _]]], [_, [_], _], [apvienojums, [r, _, _]], vtl_37).
x([[_, [r, _, _]], [un, [c, c, s]], [_, [r, _, _]]], [_, [_], _], [apvienojums, [r, _, _]], vtl_38).
x([[_, [r, _, _]], [vai, [c, c, s]], [_, [r, _, _]]], [_, [_], _], [apvienojums, [r, _, _]], vtl_39).
x([[_, [r, _, G]], [jeb, [c, c, s]], [_, [r, _, G]]], [_, [_], _], [apvienojums, [r, _, G]], vtl_40).
x([[_, [r, _, _]], [',', [z, c]], [nevis, [c, c, s]], [_, [r, _, _]]], [_, [_], [_], _], [apvienojums, [r, _, _]], vtl_41).
x([[_, [r, _, _]], [',', [z, c]], [bet, [c, c, s]], [_, [r, _, _]]], [_, [_], [_], _], [apvienojums, [r, _, _]], vtl_42).
x([[gan, [c, c, r]], [_, [r, _, _]], [',', [z, c]], [gan, [c, c, r]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_43).
x([[kā, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [tā, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_44).
x([[ne_tikai, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_45).
x([[ne_tikvien, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_46).
x([[ne_vien, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [bet_arī, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_47).
x([[ne, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [bet, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_48).
x([[nedz, [c, c, r]], [_, [r, _, _]], [',', [z, c]], [nedz, [c, c, r]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_49).
x([[ne, [c, c, r]], [_, [r, _, _]], [',', [z, c]], [ne, [c, c, r]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_50).
x([[nevis, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [bet, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_51).
x([[te, [c, c, r]], [_, [r, _, _]], [',', [z, c]], [te, [c, c, r]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_52).
x([[vai_nu, [c, c, d]], [_, [r, _, _]], [',', [z, c]], [vai, [c, c, d]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_53).
x([[vai, [c, c, r]], [_, [r, _, _]], [',', [z, c]], [vai, [c, c, r]], [_, [r, _, _]]], [[_], _, [_], [_], _], [apvienojums, [r, _, _]], vtl_54).
