/*****************************************************************************
 * Common helper predicates
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


/* $Revision: 708 $, $Date: 2009-10-08 23:45:42 +0300 (Thu, 08 Oct 2009) $ */

:- multifile
	version/2.

:- thread_local
	counter_value/2.


version(tools, '$Id: tools.pl 708 2009-10-08 20:45:42Z ilmars $').


counter(Name, LastIdx) :-
	counter_value(Name, LastIdx), !.

counter(_, 0).


counter(Name) :-
	counter(Name, LastIdx),
	format('~d', [LastIdx]).

counter_next(Name, NextIdx) :-
	counter(Name, LastIdx),
	NextIdx is LastIdx + 1,
	counter_set(Name, NextIdx).

counter_next(Name) :-
	counter_next(Name, NextIdx),
	format('~d', [NextIdx]).

counter_set(Name, Value) :-
	retractall(counter_value(Name, _)),
	assert(counter_value(Name, Value)).

counter_reset(Name) :-
	counter_set(Name, 0).

counter_delete(Name) :-
	retractall(counter_value(Name, _)).


atom_digit('0', 0).
atom_digit('1', 1).
atom_digit('2', 2).
atom_digit('3', 3).
atom_digit('4', 4).
atom_digit('5', 5).
atom_digit('6', 6).
atom_digit('7', 7).
atom_digit('8', 8).
atom_digit('9', 9).


list_alphanumeric([], []) :- !.

list_alphanumeric([Atom | Tail], [AlphaNum | ANTail]) :-
	(atom_digit(Atom, AlphaNum) ; AlphaNum = Atom), !,
	list_alphanumeric(Tail, ANTail), !.


atom_alphanumerics(Atom, AlphaNums) :-
	atom_chars(Atom, Chars),
	list_alphanumeric(Chars, AlphaNums).


list_replace([], [], _, _) :- !.

list_replace([H|T],[RH|RT], Elements, Replacements) :-
	nth0(Index, Elements, H),
	nth0(Index, Replacements, RH),
	list_replace(T, RT, Elements, Replacements), !.

list_replace([H|T],[H|RT], Elements, Replacements) :-
	list_replace(T, RT, Elements, Replacements), !.

	
%% length_leq(+List1, +List2)

length_leq([],_) :- !.
length_leq(_,[]) :- !, fail.
length_leq([_|ATail],[_|BTail]) :- !, length_leq(ATail, BTail), !.


%% split(+List,-LeftSublist,-RightSublist)

split(List,[],List).
split([H|Tail],[H|LTail],RList) :- split(Tail,LTail,RList).


%% split_with_element(+List,-LeftSublist,-ListElement,-RightSublist)

split_with_element([H|Tail],[],H,Tail).
split_with_element([H|Tail],[H|LTail],CH,RList) :- split_with_element(Tail,LTail,CH,RList).


%% split_left_non_empty(+List,-NonEmptyLeftSublist,-RightSublist)

split_left_non_empty([H|Tail],[H],Tail).
split_left_non_empty([H|Tail],[H|LTail],RList) :- split_left_non_empty(Tail,LTail,RList).


%% split_right_non_empty(+List,-LeftSublist,-NonEmptyRightSublist)

split_right_non_empty([H|Tail],[],[H|Tail]).
split_right_non_empty([H|Tail],[H|LTail],RList) :- split_right_non_empty(Tail,LTail,RList).


%% split_left(+List,+LeftSublistLength,-LeftSublist,-RightSublist)

split_left(List, 0, [], List) :- !.

split_left([H|Tail], Length, [H|LTail], RList) :-
    Length > 0, NextLength is Length - 1,
    split_left(Tail, NextLength, LTail, RList).


%% split_with_list(+List,+SublistLength,-LeftSublist,-Sublist,-RightSublist)

split_with_list(List, SublistLength, [], Sublist, RightSublist):-
    split_left(List, SublistLength, Sublist, RightSublist).
    
split_with_list([H|Tail], SublistLength, [H|LTail], Sublist, RList):-
    split_with_list(Tail, SublistLength, LTail, Sublist, RList).
   
	