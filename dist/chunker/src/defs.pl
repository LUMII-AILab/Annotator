/*****************************************************************************
 * Grammar rules loader
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

:- ensure_loaded('config').

init :-
	config(parse_active_defs, DefSet),
	config(parse_defs_set, [DefSet, TDefA, TDefB, TDefX]),
	term_to_atom(TDefA, DefA),
	term_to_atom(TDefB, DefB),
	term_to_atom(TDefX, DefX),
	ensure_loaded(DefA),
	ensure_loaded(DefB),
	ensure_loaded(DefX).

:- init.
