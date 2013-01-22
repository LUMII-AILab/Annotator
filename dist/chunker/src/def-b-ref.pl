/*****************************************************************************
 * Additional rules for anaphoric dependencies
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

:- multifile b/4.

:- ensure_loaded('def-b-vpt').

% Anaforas
b([vietas_apstāklis_multi, nr1_ref], [n, _, _, _, l, _, [ref]], [v, m|_], _).
b([tiešais_papildinātājs, nr1_ref], [n, _, _, _, a, _, [ref]], [v, m, n, _, _, t, _, _, _, a, _], _).
b([netiešais_papildinātājs_multi, nr1_ref], [n, _, _, _, d, _, [ref]], [v, m|_], _).
b([teikuma_priekšmets, nr1_ref], [n, _, _, _, n, _, [ref]], [v, m, _, _, _, _, _, 3, 0, _, _], _).
b([teikuma_priekšmets, nr2_ref], [n, _, GEND, _, n, _, [ref]], [v, m, n, _, _, 0, 0, _, 0, _, _, [nom, _, GEND, n]], _).
b([teikuma_priekšmets, nr3_ref], [n, _, _, _, n, _, [ref]], [v, m, n, _, _, _, 0, 3, 0, _, _, [T, _, _, _]], _):-member(T, [modal, phase]).
