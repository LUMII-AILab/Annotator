/*****************************************************************************
 * Patterns for subordinate clauses of Latvian language
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

% mod_word_list/2 imported from def-x-ref

term_expansion(x(WordList, Tree, [Word, Morphology], ID), x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word])) :-
	mod_word_list(WordList, WordListMod).

term_expansion(x(WordList, Tree, [Word, Morphology], ID) :- XBody, x(WordListMod, Tree, [Word, Morphology, ID, xdefs, Word]) :- XBody) :-
	mod_word_list(WordList, WordListMod).

:- multifile x/3.

:- ensure_loaded('def-x-ref').

% Saikļi
x([[līdz, [s, p, s, d, [y]]], [kurienei, [n, c, f, s, d, 5]]], [[_], [_]], [saiklis, [n, c, f, s, d, 5, [pre, y, līdz]]], conj_1).
x([[no, [s, p, s, g, [y]]], [kurienes, [n, c, f, s, g, 5]]], [[_], [_]], [saiklis, [n, c, f, s, g, 5, [pre, y, no]]], conj_2).
x([[uz, [s, p, s, a, [y]]], [kurieni, [n, c, f, s, a, 5]]], [[_], [_]], [saiklis, [n, c, f, s, a, 5, [pre, y, uz]]], conj_3).

% Palīgteikumi
x([[',', [z, c]], [kurp, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_1).
x([[',', [z, c]], [kad, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_2).
x([[',', [z, c]], [no_kurienes, [n, c, f, s, g, 5, [pre, y, no]]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_3).
x([[',', [z, c]], [uz_kurieni, [n, c, f, s, a, 5, [pre, y, uz]]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_4).
x([[',', [z, c]], [tāpēc, [r, 0, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_5).
x([[',', [z, c]], [kādēļ, [r, 0, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_6).
x([[',', [z, c]], [[p, r|_]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_7).
x([[',', [z, c]], [lai, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_8).
x([[',', [z, c]], [vai, [c, c, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_9).
x([[',', [z, c]], [ja, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_10).
x([[',', [z, c]], [it_kā, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_11).
x([[',', [z, c]], [kā, [r, 0, m]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_12).
x([[',', [z, c]], [kur, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, a, _, _, _, _, _]], plt_13).
x([[',', [z, c]], [tādēļ_ka, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, c, _, _, _, _, _]], plt_14).
x([[',', [z, c]], [tāpēc_ka, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, c, _, _, _, _, _]], plt_15).
x([[',', [z, c]], [tālab_ka, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, c, _, _, _, _, _]], plt_16).
x([[',', [z, c]], [tamdēļ_ka, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, c, _, _, _, _, _]], plt_17).
x([[',', [z, c]], [līdz, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_18).
x([[',', [z, c]], [kamēr, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_19).
x([[',', [z, c]], [kopš, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_20).
x([[',', [z, c]], [kad, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_21).
x([[',', [z, c]], [tikko, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_22).
x([[',', [z, c]], [līdzko, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_23).
x([[',', [z, c]], [kolīdz, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, l, _, _, _, _, _]], plt_24).
x([[',', [z, c]], [tiklīdz, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]]], [[_], [_], _], [plt, [t, l, M, _, T, P, S]], plt_25).
x([[',', [z, c]], [pirms, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]]], [[_], [_], _], [plt, [t, l, M, _, T, P, S]], plt_26).
x([[',', [z, c]], [iekams, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]]], [[_], [_], _], [plt, [t, l, M, _, T, P, S]], plt_27).
x([[',', [z, c]], [cik, [r, 0, q]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, m, _, _, _, _, _]], plt_28).
x([[',', [z, c]], [ka, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, m, _, _, _, _, _]], plt_29).
x([[',', [z, c]], [lai, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, m, _, _, _, _, _]], plt_30).
x([[',', [z, c]], [lai, [c, s, s]], [_, [v, m, _, c|_]]], [[_], [_], _], [plt, [t, n, c, _, _, _, _]], plt_31).
x([[',', [z, c]], [ja, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, j, _, _, _, _, _]], plt_32).
x([[',', [z, c]], [jo, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, o, _, _, _, _, _]], plt_33).
x([[',', [z, c]], [ka, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_34).
x([[',', [z, c]], [kāpēc, [r, 0, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_35).
x([[',', [z, c]], [lai, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_36).
x([[',', [z, c]], [vai, [c, c, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_37).
x([[',', [z, c]], [_, [p, r|_]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_38).
x([[',', [z, c]], [kā, [r, 0, m]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_39).
x([[',', [z, c]], [kur, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_40).
x([[',', [z, c]], [kurp, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_41).
x([[',', [z, c]], [kad, [r, 0, t]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_42).
x([[',', [z, c]], [cik, [r, 0, q]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, p, _, _, _, _, _]], plt_43).
x([[',', [z, c]], [lai_arī, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, e, _, _, _, _, _]], plt_44).
x([[',', [z, c]], [lai_gan, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, e, _, _, _, _, _]], plt_45).
x([[',', [z, c]], [kaut_arī, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, e, _, _, _, _, _]], plt_46).
x([[',', [z, c]], [kaut_gan, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, e, _, _, _, _, _]], plt_47).
x([[',', [z, c]], [ja_arī, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, e, _, _, _, _, _]], plt_48).
x([[',', [z, c]], [turklāt, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, r, _, _, _, _, _]], plt_49).
x([[',', [z, c]], [kādēļ, [r, 0, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, r, _, _, _, _, _]], plt_50).
x([[',', [z, c]], [pie_tam, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, r, _, _, _, _, _]], plt_51).
x([[',', [z, c]], [kā, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_52).
x([[',', [z, c]], [nekā, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_53).
x([[',', [z, c]], [it_kā, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_54).
x([[',', [z, c]], [itin_kā, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_55).
x([[',', [z, c]], [tāpat_kā, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_56).
x([[',', [z, c]], [kā_kad, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_57).
x([[',', [z, c]], [cik, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, z, _, _, _, _, _]], plt_58).
x([[',', [z, c]], [tā_ka, [c, s, c]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, s, _, _, _, _, _]], plt_59).
x([[',', [z, c]], [kā, [r, 0, m]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, d, _, _, _, _, _]], plt_60).
x([[',', [z, c]], [ka, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, d, _, _, _, _, _]], plt_61).
x([[',', [z, c]], [lai, [c, s, s]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, d, _, _, _, _, _]], plt_62).
x([[',', [z, c]], [kur, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, v, _, _, _, _, _]], plt_63).
x([[',', [z, c]], [kurp, [r, 0, p]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, v, _, _, _, _, _]], plt_64).
x([[',', [z, c]], [no_kurienes, [n, c, f, s, g, 5, [pre, y, no]]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, v, _, _, _, _, _]], plt_65).
x([[',', [z, c]], [uz_kurieni, [n, c, f, s, a, 5, [pre, y, uz]]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, v, _, _, _, _, _]], plt_66).
x([[',', [z, c]], [līdz_kurienei, [n, c, f, s, d, 5, [pre, y, līdz]]], [_, [v, m|_]]], [[_], [_], _], [plt, [t, v, _, _, _, _, _]], plt_67).
x([[līdz, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_68).
x([[kamēr, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_69).
x([[kopš, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_70).
x([[kad, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_71).
x([[tikko, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_72).
x([[līdzko, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_73).
x([[kolīdz, [r, 0, t]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, _, _, _, _, _]], plt_74).
x([[tiklīdz, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, M, _, T, P, S]], plt_75).
x([[pirms, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, M, _, T, P, S]], plt_76).
x([[iekams, [r, 0, t]], [_, [v, m, _, M, T, _, _, _, P, S|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, l, M, _, T, P, S]], plt_77).
x([[lai, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, n, _, _, _, _, _]], plt_78).
x([[ja, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, j, _, _, _, _, _]], plt_79).
x([[lai_arī, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, e, _, _, _, _, _]], plt_80).
x([[lai_gan, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, e, _, _, _, _, _]], plt_81).
x([[kaut_arī, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, e, _, _, _, _, _]], plt_82).
x([[kaut_gan, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, e, _, _, _, _, _]], plt_83).
x([[ja_arī, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, e, _, _, _, _, _]], plt_84).
x([[kā, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_85).
x([[nekā, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_86).
x([[it_kā, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_87).
x([[itin_kā, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_88).
x([[tāpat_kā, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_89).
x([[kā_kad, [c, s, c]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_90).
x([[jo, [c, c, r]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, z, _, _, _, _, _]], plt_91).
x([[jo, [c, c, r]], [_, [v, m|_]]], [[_], _], [plt, [t, z, _, _, _, _, _]], plt_92).
x([[kā, [r, 0, m]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, d, _, _, _, _, _]], plt_93).
x([[ka, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, d, _, _, _, _, _]], plt_94).
x([[lai, [c, s, s]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, d, _, _, _, _, _]], plt_95).
x([[kur, [r, 0, p]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, v, _, _, _, _, _]], plt_96).
x([[kurp, [r, 0, p]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, v, _, _, _, _, _]], plt_97).
x([[no_kurienes, [n, c, f, s, g, 5, [pre, y, no]]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, v, _, _, _, _, _]], plt_98).
x([[uz_kurieni, [n, c, f, s, a, 5, [pre, y, uz]]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, v, _, _, _, _, _]], plt_99).
x([[līdz_kurienei, [n, c, f, s, d, 5, [pre, y, līdz]]], [_, [v, m|_]], [',', [z, c]]], [[_], _, [_]], [plt, [t, v, _, _, _, _, _]], plt_100).
x([[',', [z, c]], [kas, [p, q, 0, 0, 0, n, [_]]], [_, [v, m|_]], [un, [c, c, s]], [kas, [p, q, 0, 0, 0, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_101).
x([[',', [z, c]], [kurš, [p, q, 0, m, s, n, [_]]], [_, [v, m|_]], [un, [c, c, s]], [kurš, [p, q, 0, m, s, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_102).
x([[',', [z, c]], [kura, [p, q, 0, f, s, n, [_]]], [_, [v, m|_]], [un, [c, c, s]], [kura, [p, q, 0, f, s, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_103).
x([[',', [z, c]], [kas, [p, q, 0, 0, 0, n, [_]]], [_, [v, m|_]], [vai, [c, c, s]], [kas, [p, q, 0, 0, 0, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_104).
x([[',', [z, c]], [kurš, [p, q, 0, m, s, n, [_]]], [_, [v, m|_]], [un, [c, c, s]], [kurš, [p, q, 0, m, s, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_105).
x([[',', [z, c]], [kura, [p, q, 0, f, s, n, [_]]], [_, [v, m|_]], [vai, [c, c, s]], [kura, [p, q, 0, f, s, n, [_]]], [_, [v, m|_]]], [[[_], [_], _], [_], [[_], [_], _]], [plt, [t, a, _, _, _, _, _]], plt_106).
