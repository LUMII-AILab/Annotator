/* $Revision$, $Date$ */

:- ensure_loaded('config-core').

% Format:
% :- set_config(Type, Key, Value).

:- set_config(global, max_chunk_length, 8). 
:- set_config(global, parse_time_limit, 11).
