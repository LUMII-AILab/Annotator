/*****************************************************************************
 * Standalone web server to parse sentences and display results
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


/* $Revision: 732 $, $Date: 2009-12-08 16:32:28 +0200 (Tue, 08 Dec 2009) $ */

:- style_check(-discontiguous).

:- use_module(library(socket)).
:- initialization load_foreign_library(foreign(socket), install_socket).

:- use_module(library('http/thread_httpd')).
:- use_module(library('http/http_dispatch')).
:- use_module(library('http/http_header')).
:- use_module(library('http/http_error')).
:- use_module(library('http/http_parameters')).

:- http_handler('/style-box.css', http_reply_file('style-box.css', []), []).
:- http_handler('/', reply_root, []).

:- ensure_loaded('config').
:- ensure_loaded('parser').
:- ensure_loaded('semti-html').


main :- 
	(config(print_config, true) -> config_print; true),
	(config(server, enabled) -> (config(port, Port), http_server(http_dispatch, [port(Port), workers(1)])); true),
	(config(autorun, true) -> (sformat(File, 'http://localhost:~w/', [Port]), win_shell(open, File)); true).

checkbox_value(ConfName, Value, ConfInitialized) :-
	(var(Value) -> (atom(ConfInitialized) -> Value = false ; config(ConfName, Value)) ; true),
	set_config(thread, ConfName, Value), !.

write_checkbox(Label, Name, Value) :-
	(Value = true -> Checked = checked ; Checked = ''),
	format(' <input type="checkbox" name="~w" value="true" ~w /> ~w &nbsp; ', [Name, Checked, Label]).

reply_root(Request) :-
	Params = [
		sentence(Sentence, [default('')]),
		conf_initialized(ConfInitialized, [optional(true)]),
		parse_fully(ConfParseFully, [optional(true)]),
		parse_all(ConfParseAll, [optional(true)]),
		show_chunks(ConfShowChunks, [optional(true)]),
		show_mcode(ConfShowMCode, [optional(true)]),
		simplify_syntax_roles(ConfSimplifySyntaxRoles, [optional(true)]),
		parse_use_word_analyzer(ConfParseUseWordAnalyzer, [optional(true)]),
		parse_guess_nouns(ConfGuessNouns, [optional(true)]),
		parse_guess_verbs(ConfGuessVerbs, [optional(true)]),
		parse_guess_participles(ConfGuessParticiples, [optional(true)]),
		parse_guess_adjectives(ConfGuessAdjectives, [optional(true)]),
		parse_allow_vocative(ConfAllowVocative, [optional(true)]),
		parse_enable_diminutive(ConfEnableDiminutive, [optional(true)]),
		parse_morpho_defaults(ConfMorphoDefaults, [optional(true)]),
		parse_java_debug(ConfParseJavaDebug, [optional(true)])
	],
	http_parameters(Request, Params), 

	reset_config(thread),
	checkbox_value(parse_fully, ConfParseFully, ConfInitialized),
	checkbox_value(parse_all, ConfParseAll, ConfInitialized),
	checkbox_value(show_chunks, ConfShowChunks, ConfInitialized),
	checkbox_value(show_mcode, ConfShowMCode, ConfInitialized),
	checkbox_value(simplify_syntax_roles, ConfSimplifySyntaxRoles, ConfInitialized),
	checkbox_value(parse_use_word_analyzer, ConfParseUseWordAnalyzer, ConfInitialized),
	checkbox_value(parse_word_analyzer_guess_nouns, ConfGuessNouns, ConfInitialized),
	checkbox_value(parse_word_analyzer_guess_verbs, ConfGuessVerbs, ConfInitialized),
	checkbox_value(parse_word_analyzer_guess_participles, ConfGuessParticiples, ConfInitialized),
	checkbox_value(parse_word_analyzer_guess_adjectives, ConfGuessAdjectives, ConfInitialized),
	checkbox_value(parse_word_analyzer_allow_vocative, ConfAllowVocative, ConfInitialized),
	checkbox_value(parse_word_analyzer_enable_diminutive, ConfEnableDiminutive, ConfInitialized),
	checkbox_value(parse_word_analyzer_morpho_defaults, ConfMorphoDefaults, ConfInitialized),
	checkbox_value(parse_java_debug, ConfParseJavaDebug, ConfInitialized),

	format('Content-type: text/html~n~n', []),
	writeln('<?xml version="1.0" encoding="utf-8"?>'),

	writeln('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'),
	writeln('<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">'),
	writeln('<head>'),
	writeln('<meta http-equiv="Content-Type" content="text/html" />'),
	writeln('<title>Čankeris</title>'),
	writeln('<link rel="stylesheet" type="text/css" href="/style-box.css" />'),
	writeln('</head>'),
	writeln('<body onload="javascript:document.forma.sentence.select();">'), 

	writeln('<table border="0" width="100%"><tr><td>'),
	writeln('<h2>Latviešu valodas gramatikas analizators "Čankeris"</h2>'),
	writeln('LU MII :: SemTi-Kamols :: vers. 2009.12.08 <sup>alfa</sup> (Ziemassvētku versija)'),
	writeln('</td><td align="right">'),
	writeln('<a href="http://www.semti-kamols.lv" target="_new"><img src="http://www.semti-kamols.lv/images_upl/semti-logo.jpg" border="0" alt="SemTi-Kamols" /></a>'),
	writeln('</td></tr></table><p>&nbsp;</p>'),

	writeln('Teikums:'),
	writeln('<form name="forma" action="/" method="post">'),
	writeln('<input type="hidden" name="conf_initialized" value="true">'),
	format('<input name="sentence" type="text" size="80" value="~w" onclick="javascript:this.select();" />&nbsp;', [Sentence]),
	format('<input type="submit" value="Analizēt" />'),
	
	format('<table border="0"><tr><td>Analīze: &nbsp;</td><td>'),
	write_checkbox('Lietot morf. analizatoru', parse_use_word_analyzer, ConfParseUseWordAnalyzer),
	write_checkbox('Meklēt deminutīvus', parse_enable_diminutive, ConfEnableDiminutive),
	write_checkbox('Atļaut vokatīvu', parse_allow_vocative, ConfAllowVocative),
	write_checkbox('Noklusētās pazīmes', parse_morpho_defaults, ConfMorphoDefaults),
	write_checkbox('Visi varianti', parse_all, ConfParseAll),
	write_checkbox('Pilna analīze', parse_fully, ConfParseFully),
	format('</td></tr><tr><td>Izdrukas: &nbsp;</td><td>'),
	write_checkbox('Vienkāršot sintaktiskās lomas', simplify_syntax_roles, ConfSimplifySyntaxRoles),
	write_checkbox('Pazīmju kodi', show_mcode, ConfShowMCode),
	write_checkbox('Morf. analizatora izsaukumi', parse_java_debug, ConfParseJavaDebug),
	write_checkbox('Rezultāti txt formātā', show_chunks, ConfShowChunks),
	format('</td></tr><tr><td>Minēšana: &nbsp;</td><td>'),
	write_checkbox('Lietvārdi', parse_guess_nouns, ConfGuessNouns),
	write_checkbox('Darbības vārdi', parse_guess_verbs, ConfGuessVerbs),
	write_checkbox('Divdabji', parse_guess_participles, ConfGuessParticiples),
	write_checkbox('Īpašības vārdi', parse_guess_adjectives, ConfGuessAdjectives),
	
	writeln('</td></tr></table></form><p>&nbsp;</p>'),

	get_time(STimestamp),

	config(parse_all, ParseAll),
	config(parse_time_limit, TimeLimit),

	parse_by_config(ParseAll, TimeLimit, Sentence, RawResults),
	
	(config(simplify_syntax_roles, true) -> (simplify_syntax_roles(RawResults, SimplifiedResults), list_to_set(SimplifiedResults, Results))
        	                               ; Results = RawResults),

	get_time(MTimestamp),
	parse_stats_html_write(Results),
	(nonvar(Results) -> parse_results_html_write(Results) ; format('<p class="parse-error">Pārsniegts izpildes laika limits: ~d sek.</p>', [TimeLimit])),
	get_time(ETimestamp),

	(config(print_times, true) -> (PTime is MTimestamp - STimestamp, RTime is ETimestamp - MTimestamp, format('<p>Analīze: ~2f sek., zīmēšana: ~2f sek.</p>', [PTime, RTime])); true),

	writeln('</body>'),
	writeln('</html>').


:- main.
