/*****************************************************************************
 * User-defined morphological lexicon
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Guntis Bārzdiņš, Ilmārs Poikāns, Normunds Grūzītis
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

/* $Revision: 574 $, $Date: 2009-05-19 17:02:52 +0300 (Tue, 19 May 2009) $ */

:- dynamic a/3.
:- index(a(1,0,0)).

% a(Word, Morphology, BaseForm).
