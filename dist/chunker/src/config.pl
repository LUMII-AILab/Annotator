/*****************************************************************************
 * Parser configuration file
 *
 * Copyright 2005, 2006, 2007, 2008, 2009
 * Institute of Mathematics and Computer Science, University of Latvia
 * Authors: Ilmārs Poikāns, Normunds Grūzītis
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


/* $Revision: 638 $, $Date: 2009-06-02 17:00:58 +0300 (Tue, 02 Jun 2009) $ */

:- ensure_loaded('config-core').

config_global(server, enabled).
config_global(port, 88).
config_global(language, lv).
config_global(parse_fully, true).    % true or false
config_global(parse_all, true).      % true or false
config_global(max_chunk_length, 8). % number > 0 (8=7+1)
config_global(show_chunks, false).   % true or false
config_global(show_mcode, true).     % true or false
config_global(print_config, true).   % true or false
config_global(autorun, true).        % true or false
config_global(print_times, true).    % true or false
config_global(parse_time_limit, 11). % in seconds (11=10+1)
config_global(parse_chunk_step_time_limit, 2). % in seconds

config_global(parse_active_defs, vpt). % vpt, ref or plt
config_global(parse_defs_set, [vpt, def-a, def-b-vpt, def-x-vpt]).
config_global(parse_defs_set, [ref, def-a, def-b-ref, def-x-ref]).
config_global(parse_defs_set, [plt, def-a, def-b-plt, def-x-plt]).

config_global(simplify_syntax_roles, false).

config_global(parse_use_word_analyzer, false).               % true or false
config_global(parse_word_analyzer_guess, true).              % true or false
config_global(parse_word_analyzer_guess_nouns, false).       % true or false
config_global(parse_word_analyzer_guess_verbs, false).       % true or false
config_global(parse_word_analyzer_guess_participles, false). % true or false
config_global(parse_word_analyzer_guess_adjectives, false).  % true or false
config_global(parse_word_analyzer_allow_vocative, false).    % true or false
config_global(parse_word_analyzer_enable_diminutive, false). % true or false
config_global(parse_word_analyzer_morpho_defaults, true).    % true or false
config_global(parse_java_debug, false).                      % true or false

config_global(parse_java_libs, ['morphology.jar', 'chunker.jar']).

% Load config-local file, if it exists.
% Used for deployment specific config value override.

:- (exists_file('config-local.pl') ; exists_file('config-local.qlf')) -> ensure_loaded('config-local') ; true.
