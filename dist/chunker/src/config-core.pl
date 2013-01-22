/*****************************************************************************
 * Configuration management and usage 
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


/* $Revision: 701 $, $Date: 2009-10-03 20:42:55 +0300 (Sat, 03 Oct 2009) $ */

:- dynamic
	config_global/2.

:- dynamic
	config_runtime/2.

:- thread_local
	config_thread/2.


reset_config(thread) :-
	retractall(config_thread(_, _)).

reset_config(runtime) :-
	retractall(config_runtime(_, _)).


reset_config(thread, Key) :-
	retractall(config_thread(Key, _)).

reset_config(runtime, Key) :-
	retractall(config_runtime(Key, _)).


set_config(thread, Key, Value) :-
	ground(Key),
	ground(Value),
	retractall(config_thread(Key, _)),
	assert(config_thread(Key, Value)), !.

set_config(runtime, Key, Value) :-
	ground(Key),
	ground(Value),
	retractall(config_runtime(Key, _)),
	assert(config_runtime(Key, Value)), !.

set_config(global, Key, Value) :-
	ground(Key),
	ground(Value),
	retractall(config_global(Key, _)),
	assert(config_global(Key, Value)), !.

set_config(Type, Key, Value) :-
	sformat(Message, 'Can\'t set ~w config with key \'~w \'and value \'~w\'', [Type, Key, Value]),
	throw(Message).

/* No way to add several configs for the same key, for example, config_global(parse_defs_set, [Name | Values]). */

config(Key, Value) :- config_thread(Key, ConfValue), !, Value = ConfValue, !.

config(Key, Value) :- config_runtime(Key, ConfValue), !, Value = ConfValue, !.

config(Key, Value) :- config_global(Key, Value), !.


config(Key, Value, _) :- config(Key, Value), !.

config(_, DefaultValue, DefaultValue) :- !.


config_print(thread) :-
	format('Thread Configuration:~n'),
	forall(config_thread(Key, Value),
	       format('   ~w:~t~30|~w~n', [Key, Value])), !.

config_print(runtime) :-
	format('Runtime Configuration:~n'),
	forall(config_runtime(Key, Value),
	       format('   ~w:~t~30|~w~n', [Key, Value])), !.

config_print(global) :-
	format('Global Configuration:~n'),
	forall(config_global(Key, Value),
	       format('   ~w:~t~30|~w~n', [Key, Value])), !.


config_print :-
	findall(GKey, config_global(GKey, _), GKeys),
	findall(RKey, config_runtime(RKey, _), RKeys),
	findall(TKey, config_thread(TKey, _), TKeys),
	flatten([GKeys, RKeys, TKeys], AllKeys),
	list_to_set(AllKeys, Keys),
	format('Configuration:~n'),
	config_item_print(Keys), !.


config_item_print([]).

config_item_print([Key|Keys]) :-
	config(Key, Value),
	format('   ~w:~t~42|~w~n', [Key, Value]),
	config_item_print(Keys).

