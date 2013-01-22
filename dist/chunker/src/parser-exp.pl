/*****************************************************************************
 * Dependency-based hybrid parser for languages with a rather free word order
 *
 * Copyright 2009
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

:- ensure_loaded('parser').
 
 
%% SyntaxRelation = [SyntaxRole, GrammarRuleId]

%% word_info(Word, Morphology, BaseForm, Source)

%% parse_node(WordInfo, SyntaxRelation, LeftChildNodes, RightChildNodes, ChildSyntaxRoles)


%% lookup_word(+Word,-WordInfo)

lookup_word(Word, WordInfo) :-
    af(Word, Morphology, BaseForm, Source, _),
    WordInfo = word_info(Word, Morphology, BaseForm, Source).


%% lookup_word_all(+Word,-WordInfoList)

lookup_word_all(Word, WordInfoList) :-
    findall(WordInfo, lookup_word(Word, WordInfo), WordInfoList).


%% lookup_words(+WordList,-WordInfoList)

lookup_words([], []) :- !.

lookup_words([Word|WTail], [WordInfoList|WILTail]) :-
    lookup_word_all(Word, WordInfoList),
    lookup_words(WTail, WILTail).


create_flat_wordinfo_list([], []).

create_flat_wordinfo_list([WordInfoList|WILTail], [WordInfo|FWILTail]) :-
    member(WordInfo, WordInfoList),
    create_flat_wordinfo_list(WILTail, FWILTail).


%% create_leaf_parsenode(+WordInfoList,-Node) 

create_leaf_parsenode([], []).

create_leaf_parsenode(WordInfoList, Node) :-
   member(WordInfo, WordInfoList),
   Node = parse_node(WordInfo, _, [], [], []).


%% create_leaf_parsenodes(+WordInfoListList,-NodeList) 
%
% there will be many variants of leaf nodes, depending
% on number of distinct word info for each word.

create_leaf_parsenodes([], []).

create_leaf_parsenodes([WordInfoList|WILTail], [Node|NTail]) :-
    create_leaf_parsenode(WordInfoList, Node),
    create_leaf_parsenodes(WILTail, NTail).

/*
dcg_word_info(word_info(Word, Morphology, BaseForm, Source)) -->
    [word_info(Word, Morphology, BaseForm, Source)].

dcg_word(parse_node(WordInfo, _, [], [], [])) -->
    dcg_word_info(WordInfo).

dcg_sentence(parse_node(WordInfo, [root, root], LeftChildNodes, RightChildNodes, ChildSyntaxRoles)) -->
    dcg_word(parse_node(WordInfo, _, LeftChildNodes, RightChildNodes, ChildSyntaxRoles)).

dcg_sentence(NewParseNode) -->
    dcg_word(Word1), dcg_word(Word2), {
    match_b_rule(Word1, Word2, left, NewParseNode);
    match_b_rule(Word2, Word1, right, NewParseNode)
    }.
*/


%% match_rule(+ParseNodes,-NewParseNodes)
% will fail, if there is no "real" matches, only skips.

match_rule([ParseNode1, ParseNode2 | PNTail], [NewParseNode | PNTail]) :-
    match_b_rule(ParseNode1, ParseNode2, left, NewParseNode) ;
    match_b_rule(ParseNode2, ParseNode1, right, NewParseNode).

match_rule(ParseNodes, [NewParseNode|NPNTail]) :-
    match_x_rule(ParseNodes, NewParseNode, NPNTail). 

match_rule([ParseNode|PNTail], [ParseNode|NPNTail]) :-
    !, match_rule(PNTail, NPNTail).


%% match_b_rule(+ChildParseNode,+ParentParseNode,+ChildPosition,-NewParseNode)
% ChildPosition is left or right.
% CSyntaxRelation will be grounded to b rule argument
% PSyntaxRelation remains variable

match_b_rule(ChildParseNode, ParentParseNode, ChildPosition, NewParseNode) :-
    ChildParseNode = parse_node(CWordInfo, CSyntaxRelation, _, _, _),
    ParentParseNode = parse_node(PWordInfo, PSyntaxRelation, PLeftChildNodes, PRightChildNodes, PChildSyntaxRoles),
    CWordInfo = word_info(_, CMorphology, _, _),
    PWordInfo = word_info(_, PMorphology, _, _), !,
    bf(CSyntaxRelation, CMorphology, PMorphology, ChildPosition),
    CSyntaxRelation = [CSyntaxRole|_],
    (not(repeatable_syntax_role(CSyntaxRole)) -> not(member(CSyntaxRole, PChildSyntaxRoles)) ; true),
    (ChildPosition = left -> NLeftChildNodes = [ChildParseNode|PLeftChildNodes] ; NLeftChildNodes = PLeftChildNodes),
    (ChildPosition = right -> NRightChildNodes = [ChildParseNode|PRightChildNodes] ; NRightChildNodes = PRightChildNodes),
    NChildSyntaxRoles = [CSyntaxRole|PChildSyntaxRoles],
    NewParseNode = parse_node(PWordInfo, PSyntaxRelation, NLeftChildNodes, NRightChildNodes, NChildSyntaxRoles).


%% match_x_rule(+ParseNodes, -NewParseNode, -UnmatchedNodes). 

match_x_rule(ParseNodes, NewParseNode, UnmatchedNodes) :-
    xf(_, XWordList, XTree, XWord),
    match_x_rule_words(ParseNodes, XWordList, XTree, MatchedNodes, UnmatchedNodes),
    XWord = [Word, Morphology, BaseForm, Source, _],
    NewWordInfo = word_info(Word, Morphology, BaseForm, Source),
    NewParseNode = parse_node(NewWordInfo, _, [], MatchedNodes, []).

match_x_rule_words(ParseNodes, [], [], [], ParseNodes).
	
match_x_rule_words([ParseNode|PNTail], [XWordListItem|XWLTail], [XTreeItem|XTTail], [ParseNode|MNTail], UnmatchedNodes) :-
    XWordListItem = [Word, Morphology|_],
    ParseNode = parse_node(word_info(Word, Morphology, _, _), SyntaxRelation, LeftChildNodes, RightChildNodes, _),
    (XTreeItem =@= [_] -> (LeftChildNodes = [], RightChildNodes = []) ; true),
    match_x_rule_words(PNTail, XWLTail, XTTail, MNTail, UnmatchedNodes),
    SyntaxRelation = [x, x].


%% build_parsetre e(+ParseNodes,-RootParseNode)

build_parsetree([], []).

build_parsetree([ParseNode], ParseNode) :-
    ParseNode = parse_node(_, [root,root], _, _, _).

build_parsetree(ParseNodes, RootNode) :-
    match_rule(ParseNodes, NextParseNodes),
    build_parsetree(NextParseNodes, RootNode).


%% print_parsenodes(+ParseNodes)

print_parsenodes(ParseNodes) :-
    print_parsenodes(ParseNodes, ''), !.

print_parsenodes([], _) :- !.

print_parsenodes([ParseNode|PNTail], Indent) :-
    print_parsenode(ParseNode, Indent),        
    print_parsenodes(PNTail, Indent).        


print_parsenode(ParseNode) :-
    print_parsenode(ParseNode, ''), !.

print_parsenode(ParseNode, Indent) :-
    ParseNode = parse_node(WordInfo, SyntaxRelation, LeftChildNodes, RightChildNodes, _),
    format('~wNode: ~w, ~w~n', [Indent, WordInfo, SyntaxRelation]),
    string_concat(Indent, '  ', NextIndent),
    (not(LeftChildNodes =@= []) -> (format('~w Left:~n', [Indent]),  print_parsenodes(LeftChildNodes, NextIndent)) ; true),
    (not(RightChildNodes =@= []) -> (format('~w Right:~n', [Indent]), print_parsenodes(RightChildNodes, NextIndent)) ; true).


%% convert_parse_results(+RootNode, -OldFormat)
