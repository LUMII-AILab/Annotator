/*****************************************************************************
 * Additional dependency rules for subordinate clauses
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

:- ensure_loaded('def-b-ref').

% Palīgteikumi
b([apzīmētājs, nr1_plt], [t, a|_], [n, _, _, _, _, _], right).
b([cēloņa_apstāklis, nr1_plt], [t, c|_], [v, m|_], right).
b([laika_apstāklis, nr2_plt], [t, l, _, _, T, _, _], [v, m, _, _, T|_], right).
b([mēra_apstāklis, nr3_plt], [t, m|_], [v, m|_], right).
b([nolūka_apstāklis, nr4_plt], [t, n|_], [v, m|_], right).
b([papildinātājs, nr1_plt], [t, p|_], [p, d, _, _, _, a, _, [_]], right).
b([papildinātājs, nr2_plt], [t, p|_], [v, m|_], right).
b([nosacījuma_palīgteikums, nr1_plt], [t, j|_], [v, m|_], right).
b([pamatojuma_palīgteikums, nr2_plt], [t, o|_], [v, m|_], right).
b([pieļāvuma_palīgteikums, nr3_plt], [t, e|_], [v, m|_], right).
b([salīdzinājuma_palīgteikums, nr4_plt], [t, z|_], [v, m|_], right).
b([seku_palīgteikums, nr5_plt], [t, s|_], [v, m|_], right).
