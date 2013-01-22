/*****************************************************************************
 * Dependency rules for simple extended sentences of Latvian language
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

repeatable_syntax_role(laika_apstāklis).
repeatable_syntax_role(veida_apstāklis).
repeatable_syntax_role(vietas_apstāklis).
repeatable_syntax_role(netiešais_papildinātājs).
repeatable_syntax_role(apzīmētājs).

simple_syntax_role(cēloņa_apstāklis, apstāklis).
simple_syntax_role(laika_apstāklis, apstāklis).
simple_syntax_role(mēra_apstāklis, apstāklis).
simple_syntax_role(nolūka_apstāklis, apstāklis).
simple_syntax_role(veida_apstāklis, apstāklis).
simple_syntax_role(vietas_apstāklis, apstāklis).


% Attributes
b([apzīmētājs, nr1], [a, r, GEND, NUM, CASE, _, p], [n, _, GEND, NUM, CASE, _], left).
b([apzīmētājs, nr2], [a, f, GEND, NUM, CASE, _, DEG], [n, _, GEND, NUM, CASE, _], left):-member(DEG, [p, c]).
b([apzīmētājs, nr2_1], [a, f, GEND, NUM, CASE, y, s], [n, _, GEND, NUM, CASE, _], left).
b([apzīmētājs, nr3], [m, T, _, GEND, NUM, CASE, _], [n, _, GEND, NUM, CASE, _], left):-member(T, [c, o]).
b([apzīmētājs, nr3_1], [m, T, _, 0, NUM, 0, _], [n, _, _, NUM, _, _], left):-member(T, [c, o]).
b([apzīmētājs, nr4], [n, _, _, _, CASE, _], [n, _, _, _, _, _], left):-member(CASE, [g, s]).
b([apzīmētājs, nr5], [n, _, _, _, d, _], [n, _, _, _, _, _], right).
b([apzīmētājs, nr6], [p, d, 3, GEND, NUM, CASE, _, [_]], [n, _, GEND, NUM, CASE, _], left).
b([apzīmētājs, nr6_1], [p, T, 0, GEND, NUM, CASE, _, [_]], [n, _, GEND, NUM, CASE, _], left):-member(T, [g, i]).
b([apzīmētājs, nr7], [p, p, 3, _, _, g, _, [_]], [n, _, _, _, _, _], left).
b([apzīmētājs, nr7_1], [p, p, PERS, _, p, g, _, [_]], [n, _, _, _, _, _], left):-member(PERS, [1, 2]).
b([apzīmētājs, nr8], [p, s, _, GEND, NUM, CASE, _, [0]], [n, _, GEND, NUM, CASE, _], left).
b([apzīmētājs, nr9], [n, _, _, _, _, _, [pre, _, PRE]], [n, _, _, _, _, _], right):-member(PRE, [ar, bez]).
b([apzīmētājs, nr10], [v, m, n, p, d, GEND, NUM, CASE, a, p, _], [n, _, GEND, NUM, CASE, _], left).
b([apzīmētājs, nr11], [v, m, n, p, d, GEND, NUM, CASE, p, TENSE, _], [n, _, GEND, NUM, CASE, _], left):-member(TENSE, [p, s]).

% Modifiers
b([cēloņa_apstāklis, nr1], [n, _, _, _, _, _, [post, n, PRE]], [v, m|_], _):-member(PRE, [dēļ, pēc]).
b([cēloņa_apstāklis, nr2], [n, _, _, _, _, _, [pre, _, PRE]], [v, m|_], _):-member(PRE, [aiz, no]).
b([cēloņa_apstāklis, nr3], [p, _, _, _, _, _, _, [post, n, PRE]], [v, m|_], _):-member(PRE, [dēļ, pēc]).
b([cēloņa_apstāklis, nr4], [r, 0, c], [v, m|_], _).
b([laika_apstāklis, nr1], [n, _, _, _, _, _, [pre, _, PRE]], [v, m|_], _):-member(PRE, [ap, kopš, līdz, no, pa, pēc, pirms, starp]).
b([laika_apstāklis, nr2], [n, _, _, _, l, _], [v, m|_], _).
b([laika_apstāklis, nr3], [r, _, t], [v, m|_], _).
b([mēra_apstāklis, nr1], [r, _, q], [a, _, _, _, _, _, _], left).
b([mēra_apstāklis, nr2], [r, _, q], [m, _, _, _, _, _, [_]], left).
b([mēra_apstāklis, nr3], [r, _, q], [n, _, _, _, g, _], left).
b([mēra_apstāklis, nr4], [r, _, q], [v, T|_], _):-member(T, [m, o, p, e]).
b([mēra_apstāklis, nr5], [r, _, q], [r, _, _], left).
b([nolūka_apstāklis, nr1], [n, _, _, _, _, _, [post, n, labad]], [v, m|_], _).
b([nolūka_apstāklis, nr2], [n, _, _, _, _, _, [pre, _, PRE]], [v, m|_], _):-member(PRE, [par, pēc]).
b([nolūka_apstāklis, nr3], [n, _, _, _, CASE, _, [pre, _, uz]], [v, m|_], _):-member(CASE, [d, a]).
b([veida_apstāklis, nr1], [n, _, _, _, l, _], [v, m|_], _).
b([veida_apstāklis, nr2], [r, _, m], [v, m|_], _).
b([vietas_apstāklis, nr1], [r, _, p], [v, m|_], _).
b([vietas_apstāklis, nr2], [n, _, _, _, l, _], [v, m|_], _).
b([vietas_apstāklis, nr3], [n, _, _, _, _, _, [POS, y, _]], [v, m|_], _):-member(POS, [pre, rel]).
b([vietas_apstāklis, nr4], [p, T, _, _, _, l, _, [_]], [v, m|_], _):-member(T, [p, d, x]).
b([vietas_apstāklis, nr5], [p, _, _, _, _, _, _, [POS, y, _]], [v, m|_], _):-member(POS, [pre, rel]).

% Objects
b([tiešais_papildinātājs, nr1], [n, _, _, _, a, _], [v, m, _, MOOD, _, t, _, _, _, VOICE, _], _):-member(MOOD, [i, r, c, m, n]) ,  member(VOICE, [a, 0]).
b([tiešais_papildinātājs, nr1_1], [n, _, _, _, a, _], [v, m, _, MOOD, _, TRANS, _, _, _, a, _, [T, _, _, _]], _):-member(MOOD, [i, r, c]) ,  member(TRANS, [t, 0]) ,  member(T, [act, modal, modal_red, phase, phase_red, expr]).
b([tiešais_papildinātājs, nr2], [n, _, _, _, n, _], [v, m, _, d, _, t, _, 0, 0, a|_], _).
b([tiešais_papildinātājs, nr2_1], [n, _, _, _, d, _], [v, m, n, d, p, 0, 0, 0, _, p, n, [pass, s, _, d]], _).
b([tiešais_papildinātājs, nr3], [n, _, GEND, NUM, n, _], [v, m, n, MOOD, _, 0, 0, _, NUM, p, _, [pass, _, GEND, n]], _):-member(MOOD, [i, r, c]).
b([tiešais_papildinātājs, nr4], [n, _, _, _, a, _], [v, m, _, p, d, _, _, _, a, s, n], _).
b([tiešais_papildinātājs, nr5], [p, _, _, _, _, a, _, [_]], [v, m, _, MOOD, _, t, _, _, _, VOICE, _], _):-member(MOOD, [i, r, c, m, n]) ,  member(VOICE, [a, 0]).
b([tiešais_papildinātājs, nr5_1], [p, _, _, _, _, a, _, [_]], [v, m, _, MOOD, _, TRANS, _, _, _, a, _, [T, _, _, _]], _):-member(MOOD, [i, r, c]) ,  member(TRANS, [t, 0]) ,  member(T, [act, modal, modal_red, phase, phase_red, expr]).
b([netiešais_papildinātājs, nr1], [n, _, _, _, d, _], [v, T, _, MOOD, _, _, _, _, _, a, _], _):-member(T, [m, g]) ,  member(MOOD, [i, r, c]).
b([netiešais_papildinātājs, nr2], [n, _, _, _, d, _], [v, m, _, n, 0, _, _, 0, 0, 0, _], left).
b([netiešais_papildinātājs, nr3], [n, _, _, _, d, _], [v, T1, _, MOOD, _, _, _, _, _, _, _, [T2, _, _, _]], _):-member(T1, [m, g]) ,  member(MOOD, [i, r, c]) ,  member(T2, [act, pass, modal, phase, expr]).
b([netiešais_papildinātājs, nr4], [n, _, _, _, _, _, [pre, _, PRE]], [v, m|_], _):-member(PRE, [ar, bez, no, par, pret]).
b([netiešais_papildinātājs, nr5], [n, _, _, _, CASE, _, [pre, _, uz]], [v, m|_], _):-member(CASE, [d, a]).
b([netiešais_papildinātājs, nr6], [p, T1, _, _, _, d, _, [_]], [v, T2, _, MOOD, _, _, _, _, _, a, _], _):-member(T1, [p, x, d, i, q, r, g]) ,  member(T2, [m, g]) ,  member(MOOD, [i, r, c]).
b([netiešais_papildinātājs, nr7], [p, T, _, _, _, d, _, [_]], [v, m, _, n, 0, _, _, 0, 0, 0, _], left):-member(T, [p, x, d, i, q, r, g]).
b([netiešais_papildinātājs, nr8], [p, T1, _, _, _, d, _, [_]], [v, T2, _, MOOD, _, _, _, _, _, _, _, [T3, _, _, _]], _):-member(T1, [p, x, d, i, q, r, g]) ,  member(T2, [m, g]) ,  member(MOOD, [i, r, c]) ,  member(T3, [act, pass, modal, phase, expr]).
b([netiešais_papildinātājs, nr9], [p, T, _, _, _, _, _, [pre, _, PRE]], [v, m|_], _):-member(T, [p, x, d, i, q, r, g]) ,  member(PRE, [ar, bez, no, par, pret]).
b([netiešais_papildinātājs, nr10], [p, T, _, _, _, CASE, _, [pre, _, uz]], [v, m|_], _):-member(T, [p, x, d, i, q, r, g]) ,  member(CASE, [d, a]).

% Subjects
b([teikuma_priekšmets, nr1], [n, _, _, _, g, _], [v, g, n, i, _, i, _, 3, 0, a, _], _).
b([teikuma_priekšmets, nr2], [n, _, _, _, g, _], [v, g, n, MOOD, _, i, _, 0, 0, a, _], _):-member(MOOD, [c, r]).
b([teikuma_priekšmets, nr2_1], [n, _, _, _, g, _], [v, g, _, T, _, 0, 0, _, s, a, _, [act, p, m, n]], _):-member(T, [i, r, c]).
b([teikuma_priekšmets, nr3], [n, _, _, _, n, _], [v, m, _, i, _, _, _, 3, 0, a, _], _).
b([teikuma_priekšmets, nr4], [n, _, GEND, NUM, n, _], [v, m, _, MOOD, _, 0, 0, _, NUM, a, _, [act, p, GEND, n]], _):-member(MOOD, [i, c, r]).
b([teikuma_priekšmets, nr5], [n, _, _, _, n, _], [v, m, 0, MOOD, _, 0, 0, _, _, a, _, [T, _, _, n]], _):-member(MOOD, [i, c, r]) ,  member(T, [subst, pronom]).
b([teikuma_priekšmets, nr6], [n, _, GEND, NUM, n, _], [v, m, 0, MOOD, _, 0, 0, _, NUM, a, _, [adj, _, GEND, n]], _):-member(MOOD, [i, c, r]).
b([teikuma_priekšmets, nr7], [n, _, _, _, n, _], [v, m, _, MOOD, _, _, 0, PERS, _, a, _, [T, s, 0, 0]], _):-member(MOOD, [i, c, r]) ,  member(PERS, [3, 0]) ,  member(T, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr7_1], [n, _, GEND, NUM, n, _], [v, m, _, MOOD, _, _, 0, PERS, NUM, a, _, [T, p, GEND, n]], _):-member(MOOD, [i, c, r]) ,  member(PERS, [3, 0]) ,  member(T, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr8], [n, _, _, _, d, _], [v, m, _, d, _, _, 0, 0, 0, a, _, [act, _, 0, 0]], _).
b([teikuma_priekšmets, nr9], [n, _, _, _, d, _], [v, m, _, d, _, 0, 0, 0, 0, a, _, [T, _, _, d]], _):-member(T, [subst, pronom]).
b([teikuma_priekšmets, nr10], [n, _, GEND, NUM, d, _], [v, m, _, d, _, 0, 0, 0, NUM, a, _, [adj, _, GEND, d]], _).
b([teikuma_priekšmets, nr11], [p, _, _, _, _, d, _, [_]], [v, m, _, d, _, _, 0, 0, 0, a, _, [act, _, 0, 0]], _).
b([teikuma_priekšmets, nr12], [p, _, _, _, _, d, _, [_]], [v, m, _, d, _, 0, 0, 0, 0, a, _, [subst, _, _, d]], _).
b([teikuma_priekšmets, nr13], [p, _, 3, GEND, _, d, _, [_]], [v, m, _, d, _, 0, 0, 0, 0, a, _, [pronom, _, GEND, d]], _).
b([teikuma_priekšmets, nr14], [p, _, _, 0, _, d, _, [_]], [v, m, _, d, _, 0, 0, 0, 0, a, _, [pronom, _, _, d]], _).
b([teikuma_priekšmets, nr15], [p, _, 3, GEND, NUM, d, _, [_]], [v, m, _, d, _, 0, 0, 0, NUM, a, _, [adj, _, GEND, d]], _).
b([teikuma_priekšmets, nr16], [p, _, _, 0, NUM, d, _, [_]], [v, m, _, d, _, 0, 0, 0, NUM, a, _, [adj, _, _, d]], _).
b([teikuma_priekšmets, nr17], [p, _, _, _, _, g, _, [_]], [v, g, n, i, _, i, _, 3, 0, a, _], _).
b([teikuma_priekšmets, nr18], [p, _, _, _, _, g, _, [_]], [v, g, n, MOOD, _, i, _, 0, 0, a, _], _):-member(MOOD, [c, r]).
b([teikuma_priekšmets, nr18_1], [p, _, _, _, _, g, _, [_]], [v, g, _, T, _, 0, 0, _, s, a, _, [act, p, m, n]], _):-member(T, [i, r, c]).
b([teikuma_priekšmets, nr19], [p, _, _, _, _, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, _, a, _, [subst, _, _, n]], _):-member(MOOD, [i, c, r]).
b([teikuma_priekšmets, nr20], [p, T1, 3, GEND, NUM, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, NUM, a, _, [T2, _, GEND, n]], _):-member(T1, [p, d]) ,  member(MOOD, [i, c, r]) ,  member(T2, [adj, pronom]).
b([teikuma_priekšmets, nr20_1], [p, T1, 0, GEND, NUM, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, NUM, a, _, [T2, _, GEND, n]], _):-member(T1, [i, q, r, g]) ,  member(MOOD, [i, c, r]) ,  member(T2, [adj, pronom]).
b([teikuma_priekšmets, nr21], [p, T1, 3, GEND, _, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, 0, a, _, [T2, _, GEND, n]], _):-member(T1, [p, d]) ,  member(MOOD, [i, c, r]) ,  member(T2, [adj, pronom]).
b([teikuma_priekšmets, nr21_1], [p, T1, 0, GEND, _, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, 0, a, _, [T2, _, GEND, n]], _):-member(T1, [i, q, r, g]) ,  member(MOOD, [i, c, r]) ,  member(T2, [adj, pronom]).
b([teikuma_priekšmets, nr22], [p, _, _, 0, NUM, n, _, [_]], [v, m, 0, MOOD, _, 0, 0, _, NUM, a, _, [T, _, _, n]], _):-member(MOOD, [i, c, r]) ,  member(T, [adj, pronom]).
b([teikuma_priekšmets, nr23], [p, p, PERS, _, NUM, n, _, [_]], [v, m, _, i, _, _, _, PERS, NUM, a, _], _):-member(PERS, [1, 2]).
b([teikuma_priekšmets, nr24], [p, _, PERS, _, _, n, _, [_]], [v, m, _, i, _, _, _, 3, 0, a, _], _):-member(PERS, [3, 0]).
b([teikuma_priekšmets, nr25], [p, _, _, _, _, n, _, [_]], [v, m, _, MOOD, _, _, _, 0, 0, a, _], _):-member(MOOD, [c, r]).
b([teikuma_priekšmets, nr26], [p, T1, PERS, _, NUM, n, _, [_]], [v, m, _, i, _, _, 0, PERS, NUM, a, _, [T2, _, _, _]], _):-member(T1, [p, d]) ,  member(T2, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr26_1], [p, T1, _, _, _, n, _, [_]], [v, m, _, MOOD, _, _, 0, 0, 0, a, _, [T2, s, _, _]], _):-member(T1, [p, d]) ,  member(MOOD, [c, r]) ,  member(T2, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr26_2], [p, T1, _, _, NUM, n, _, [_]], [v, m, _, MOOD, _, _, 0, 0, NUM, a, _, [T2, p, _, _]], _):-member(T1, [p, d]) ,  member(MOOD, [c, r]) ,  member(T2, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr26_3], [p, T1, 3, _, _, n, _, [_]], [v, m, _, i, _, _, 0, 3, 0, a, _, [T2, _, _, _]], _):-member(T1, [p, d]) ,  member(T2, [modal, modal_red, phase, phase_red]).
b([teikuma_priekšmets, nr27], [p, _, _, GEND, NUM, n, _, [_]], [v, m, _, MOOD, _, 0, 0, _, NUM, a, _, [act, p, GEND, n]], _):-member(MOOD, [i, c, r]).
b([teikuma_priekšmets, nr28], [p, _, _, 0, NUM, n, _, [_]], [v, m, _, MOOD, _, 0, 0, _, NUM, a, _, [act, p, _, n]], _):-member(MOOD, [i, c, r]).
b([teikuma_priekšmets, nr29], [n, _, _, _, d, _], [v, m, _, d, 0, _, _, 0, 0, a, _], _).
b([teikuma_priekšmets, nr30], [n, _, GEND, NUM, n, _], [v, m, _, p, d, GEND, NUM, n, a, s, n], _).

% Semi-predicative components
b([spk, nr1], [v, m, _, n, 0, _, _, 0, 0, 0, _], [v, m, _, _, _, _, _, _, _, _, _, [T, _, _, _]], _):-member(T, [modal, phase, expr]).
b([spk, nr2], [v, m, _, n, 0, _, _, 0, 0, 0, _], [v, m, n, i, _, _, _, _, _, a, _], _).
b([spk, nr3], [v, m, _, p, _, _, _, _, _, _, _, [spk, dt]], [v, m|_], _).
b([spk, nr4], [n, c, GEND, NUM, CASE, _, [spk, sp]], [n, _, GEND, NUM, CASE, _], right).
b([spk, nr5], [a, _, GEND, NUM, CASE, n, p, [spk, sa]], [n, _, GEND, NUM, CASE, _], right).
b([spk, nr6], [n, c, GEND, NUM, CASE, _, [spk, sd]], [a, f, GEND, NUM, CASE, n, p], right).
b([spk, nr7], [n, c, _, _, _, _, [spk, sd]], [v, m, _, _, _, _, _, _, _, _, _], right).
b([spk, nr7_1], [n, c, _, _, _, _, [spk, sd]], [v, m, _, _, _, _, _, _, _, _, _, [T, _, _, _]], right):-member(T, [act, pass, modal, phase, expr]).
b([spk, nr8], [n, c, _, NUM, CASE, _, [spk, sd]], [n, _, _, NUM, CASE, _], right).

% Sentence level dependencies
b([izteicējs, nr1], [v, m|_], [z, s], left).
