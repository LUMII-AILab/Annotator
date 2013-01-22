/*****************************************************************************
 * Description of the SemTi-Kamols morphological tagset for Latvian language
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


/* $Revision: 743 $, $Date: 2010-03-22 15:13:52 +0200 (Mon, 22 Mar 2010) $ */

/* === PARTS-OF-SPEECH ===================================================== */

morphology_word_type(n, en, 'noun').
morphology_word_type(n, lv, 'lietvārds').
morphology_word_type(n, lvsh, 'lietv.').

morphology_word_type(v, en, 'verb').
morphology_word_type(v, lv, 'darbības vārds').
morphology_word_type(v, lvsh, 'darb.v.').

morphology_word_type(a, en, 'adjective').
morphology_word_type(a, lv, 'īpašības vārds').
morphology_word_type(a, lvsh, 'īp.v.').

morphology_word_type(p, en, 'pronoun').
morphology_word_type(p, lv, 'vietniekvārds').
morphology_word_type(p, lvsh, 'v-v.').

morphology_word_type(r, en, 'adverb').
morphology_word_type(r, lv, 'apstākļa vārds').
morphology_word_type(r, lvsh, 'apst.v.').

morphology_word_type(s, en, 'preposition').
morphology_word_type(s, lv, 'prievārds').
morphology_word_type(s, lvsh, 'priev.').

morphology_word_type(c, en, 'conjunction').
morphology_word_type(c, lv, 'saiklis').
morphology_word_type(c, lvsh, 'saiklis').

morphology_word_type(m, en, 'numeral').
morphology_word_type(m, lv, 'skaitļa vārds').
morphology_word_type(m, lvsh, 'sk.v.').

morphology_word_type(i, en, 'interjection').
morphology_word_type(i, lv, 'izsauksmes vārds').
morphology_word_type(i, lvsh, 'izs.v.').

morphology_word_type(q, en, 'particle').
morphology_word_type(q, lv, 'partikula').
morphology_word_type(q, lvsh, 'part.').

morphology_word_type(z, en, 'punctuation mark').
morphology_word_type(z, lv, 'pieturzīme').
morphology_word_type(z, lvsh, 'pieturz.').

morphology_word_type(x, en, 'residual').
morphology_word_type(x, lv, 'bezmorfoloģijas elements').
morphology_word_type(x, lvsh, 'bezmorf.elem.').

/* ========================================================================= */


/* === NOUN ================================================================ */

% From the A table
morphology_word_info([n,Type,Gender,Number,Case,Declension], Format, Info) :-
       morphology_markup(noun, type, Type, Format, SType),
       morphology_markup(noun, gender, Gender, Format, SGender),
       morphology_markup(noun, number, Number, Format, SNumber),
       morphology_markup(noun, case, Case, Format, SCase),
       morphology_markup(noun, declension, Declension, Format, SDeclension),
       
       sformat(Info, '~w ~w ~w ~w ~w', [SType,SGender,SNumber,SCase,SDeclension]).

% From the X table (prepositional constructions)
morphology_word_info([n,Type,Gender,Number,Case,Declension,[XPosition,XPlace,XPreposition]], Format, Info) :-
       morphology_markup(noun, type, Type, Format, SType),
       morphology_markup(noun, gender, Gender, Format, SGender),
       morphology_markup(noun, number, Number, Format, SNumber),
       morphology_markup(noun, case, Case, Format, SCase),
       morphology_markup(noun, declension, Declension, Format, SDeclension),
       morphology_markup(preposition, xposition, XPosition, Format, SXPosition),
       morphology_markup(preposition, xplace, XPlace, Format, SXPlace),
       morphology_markup(preposition, xpreposition, XPreposition, Format, SXPreposition),
       
       sformat(Info, '~w ~w ~w ~w ~w',
       [SType,SGender,SNumber,SCase,SDeclension,SXPosition,SXPlace,SXPreposition]).
       
% From the X table (SPK)
morphology_word_info([n,Type,Gender,Number,Case,Declension,[XType,XSubtype]], Format, Info) :-
       morphology_markup(noun, type, Type, Format, SType),
       morphology_markup(noun, gender, Gender, Format, SGender),
       morphology_markup(noun, number, Number, Format, SNumber),
       morphology_markup(noun, case, Case, Format, SCase),
       morphology_markup(noun, declension, Declension, Format, SDeclension),
       morphology_markup(spk, xtype, XType, Format, SXType),
       morphology_markup(noun, xsubtype, XSubtype, Format, SXSubtype),
       
       sformat(Info, '~w ~w ~w ~w ~w',
       [SType,SGender,SNumber,SCase,SDeclension,SXType,SXSubtype]).

% From the X table (anaphors)
morphology_word_info([n,Type,Gender,Number,Case,Declension,[ref]], Format, Info) :-
       morphology_markup(noun, type, Type, Format, SType),
       morphology_markup(noun, gender, Gender, Format, SGender),
       morphology_markup(noun, number, Number, Format, SNumber),
       morphology_markup(noun, case, Case, Format, SCase),
       morphology_markup(noun, declension, Declension, Format, SDeclension),
       
       sformat(Info, '~w ~w ~w ~w ~w',
       [SType,SGender,SNumber,SCase,SDeclension]).

/* ========================================================================= */


/* === VERB ================================================================ */

% From the A table
morphology_word_info([v,Type,Reflexivity,Mood,Tense,Transitivity,Conjugation,Person,Number,Voice,Negative], Format, Info) :-
       not(Mood = p),
       not(Transitivity = 0),
       not(Conjugation = 0),
       
       % A <-> B = (A -> B) & (B -> A)
       % A -> B = ~A v B
       % A <-> B = (~A v B) & (~B v A)
       % (Mood = n ; Mood = d ; Mood = c -> Tense = 0) , (Tense = 0 -> Mood = n ; Mood = d ; Mood = c)
       
       ((not((Mood = n ; Mood = d ; Mood = c)) ; Tense = 0) , (not(Tense = 0) ; (Mood = n ; Mood = d ; Mood = c))),
       ((not((Mood = n ; Mood = d ; Mood = r ; Mood = c)) ; Person = 0) , (not(Person = 0) ; (Mood = n ; Mood = d ; Mood = r ; Mood = c))),
       ((not((Mood = n ; Mood = d ; Mood = r ; Mood = c ; Person = 3)) ; Number = 0) , (not(Number = 0) ; (Mood = n ; Mood = d ; Mood = r ; Mood = c ; Person = 3))),
       ((not(Mood = n) ; Voice = 0) , (not(Voice = 0) ; Mood = n)),

       morphology_markup(verb, type, Type, Format, SType),
       morphology_markup(verb, reflexivity, Reflexivity, Format, SReflexivity),
       morphology_markup(verb, mood, Mood, Format, SMood),
       morphology_markup(verb, tense, Tense, Format, STense),
       morphology_markup(verb, transitivity, Transitivity, Format, STransitivity),
       morphology_markup(verb, conjugation, Conjugation, Format, SConjugation),
       morphology_markup(verb, person, Person, Format, SPerson),
       morphology_markup(verb, number, Number, Format, SNumber),
       morphology_markup(verb, voice, Voice, Format, SVoice),
       morphology_markup(verb, negative, Negative, Format, SNegative),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w ~w ~w ~w ~w',
       [SType,SReflexivity,SMood,STense,STransitivity,SConjugation,SPerson,SNumber,SVoice,SNegative]).

% From the X table (predicate)
morphology_word_info([v,Type,Reflexivity,Mood,Tense,Transitivity,0,Person,Number,Voice,Negative,[XType,XTense,XGender,XCase]], Format, Info) :-
       not(Mood = p),
       
       (not((XType = subst ; XType = adj ; XType = pronom ; XType = adv)) ; Reflexivity = 0),
       (not(Reflexivity = 0) ; (XType = subst ; XType = adj ; XType = pronom ; XType = adv)),
       (not((XType = subst ; XType = adj ; XType = pronom ; XType = adv)) ; Transitivity = 0),
       
       morphology_markup(verb, type, Type, Format, SType),
       morphology_markup(verb, reflexivity, Reflexivity, Format, SReflexivity),
       morphology_markup(verb, mood, Mood, Format, SMood),
       morphology_markup(verb, tense, Tense, Format, STense),
       morphology_markup(verb, transitivity, Transitivity, Format, STransitivity),
       morphology_markup(verb, conjugation, 0, Format, SConjugation),
       morphology_markup(verb, person, Person, Format, SPerson),
       morphology_markup(verb, number, Number, Format, SNumber),
       morphology_markup(verb, voice, Voice, Format, SVoice),
       morphology_markup(verb, negative, Negative, Format, SNegative),
       morphology_markup(verb, xtype, XType, Format, SXType),
       morphology_markup(verb, xtense, XTense, Format, SXTense),
       morphology_markup(verb, gender, XGender, Format, SXGender),
       morphology_markup(verb, xcase, XCase, Format, SXCase),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w ~w ~w ~w ~w',
       [SType,SReflexivity,SMood,STense,STransitivity,SConjugation,SPerson,SNumber,SVoice,SNegative,SXType,SXTense,SXGender,SXCase]).
       
% From the X table (SPK)
morphology_word_info([v,Type,Reflexivity,p,Declension,Gender,Number,Case,Voice,Tense,Definitness,[XType,XSubtype]], Format, Info) :-
       ((not(Declension = u) ; Gender = 0) , (not(Gender = 0) ; Declension = u)),
       ((not(Declension = u) ; Number = 0) , (not(Number = 0) ; Declension = u)),
       ((not(Declension = u) ; Case = 0) , (not(Case = 0) ; Declension = u)),
       ((not(Declension = u) ; Voice = 0) , (not(Voice = 0) ; Declension = u)),
       ((not(Declension = u) ; Tense = 0) , (not(Tense = 0) ; Declension = u)),
       ((not((Declension = u ; Declension = p)) ; Definitness = 0) , (not(Definitness = 0) ; (Declension = u ; Declension = p))),
       
       morphology_markup(verb, type, Type, Format, SType),
       morphology_markup(verb, reflexivity, Reflexivity, Format, SReflexivity),
       morphology_markup(verb, mood, p, Format, SMood),
       morphology_markup(verb, declension, Declension, Format, SDeclension),
       morphology_markup(verb, gender, Gender, Format, SGender),
       morphology_markup(verb, number, Number, Format, SNumber),
       morphology_markup(verb, case, Case, Format, SCase),
       morphology_markup(verb, voice, Voice, Format, SVoice),
       morphology_markup(verb, ptense, Tense, Format, STense),
       morphology_markup(verb, definitness, Definitness, Format, SDefinitness),
       morphology_markup(spk, xtype, XType, Format, SXType),
       morphology_markup(verb, xsubtype, XSubtype, Format, SXSubtype),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w ~w ~w ~w ~w',
                     [SType,SReflexivity,SMood,SDeclension,SGender,SNumber,SCase,SVoice,STense,SDefinitness,SXType,SXSubtype]).

/* [PARTICIPLE] ------------------------------------------------------------ */

% From the A table
morphology_word_info([v,Type,Reflexivity,p,Declension,Gender,Number,Case,Voice,Tense,Definitness], Format, Info) :-
       ((not(Declension = u) ; Gender = 0) , (not(Gender = 0) ; Declension = u)),
       ((not(Declension = u) ; Number = 0) , (not(Number = 0) ; Declension = u)),
       ((not(Declension = u) ; Case = 0) , (not(Case = 0) ; Declension = u)),
       ((not(Declension = u) ; Voice = 0) , (not(Voice = 0) ; Declension = u)),
       ((not(Declension = u) ; Tense = 0) , (not(Tense = 0) ; Declension = u)),
       ((not((Declension = u ; Declension = p)) ; Definitness = 0) , (not(Definitness = 0) ; (Declension = u ; Declension = p))),
       
       morphology_markup(verb, type, Type, Format, SType),
       morphology_markup(verb, reflexivity, Reflexivity, Format, SReflexivity),
       morphology_markup(verb, mood, p, Format, SMood),
       morphology_markup(verb, declension, Declension, Format, SDeclension),
       morphology_markup(verb, gender, Gender, Format, SGender),
       morphology_markup(verb, number, Number, Format, SNumber),
       morphology_markup(verb, case, Case, Format, SCase),
       morphology_markup(verb, voice, Voice, Format, SVoice),
       morphology_markup(verb, ptense, Tense, Format, STense),
       morphology_markup(verb, definitness, Definitness, Format, SDefinitness),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w ~w ~w ~w ~w',
                     [SType,SReflexivity,SMood,SDeclension,SGender,SNumber,SCase,SVoice,STense,SDefinitness]).

/* ========================================================================= */


/* === ADJECTIVE =========================================================== */

% From the A table
morphology_word_info([a,Type,Gender,Number,Case,Definitness,Degree], Format, Info) :-
       (not(Type = r) ; Degree = p),

       morphology_markup(adjective, type, Type, Format, SType),
       morphology_markup(adjective, gender, Gender, Format, SGender),
       morphology_markup(adjective, number, Number, Format, SNumber),
       morphology_markup(adjective, case, Case, Format, SCase),
       morphology_markup(adjective, definitness, Definitness, Format, SDefinitness),
       morphology_markup(adjective, degree, Degree, Format, SDegree),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w', [SType,SGender,SNumber,SCase,SDefinitness,SDegree]).

% From the X table (SPK)       
morphology_word_info([a,Type,Gender,Number,Case,Definitness,Degree,[XType,XSubtype]], Format, Info) :-
       (not(Type = r) ; Degree = p),

       morphology_markup(adjective, type, Type, Format, SType),
       morphology_markup(adjective, gender, Gender, Format, SGender),
       morphology_markup(adjective, number, Number, Format, SNumber),
       morphology_markup(adjective, case, Case, Format, SCase),
       morphology_markup(adjective, definitness, Definitness, Format, SDefinitness),
       morphology_markup(adjective, degree, Degree, Format, SDegree),
       morphology_markup(spk, xtype, XType, Format, SXType),
       morphology_markup(adjective, xsubtype, XSubtype, Format, SXSubtype),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w', [SType,SGender,SNumber,SCase,SDefinitness,SDegree,SXType,SXSubtype]).

/* ========================================================================= */


/* === PRONOUN ============================================================= */

% From the A table
morphology_word_info([p,Type,Person,Gender,Number,Case,Negative,[Anaphora]], Format, Info) :-
       (not(Type = d) ; (Anaphora = s ; Anaphora = a)),
       (not(Person = 3) ; Anaphora = s),
	   (not(Anaphora = s) ; (Type = d ; Person = 3)),
	   (not(Anaphora = a) ; Type = d),

       morphology_markup(pronoun, type, Type, Format, SType),
       morphology_markup(pronoun, person, Person, Format, SPerson),
       morphology_markup(pronoun, gender, Gender, Format, SGender),
       morphology_markup(pronoun, number, Number, Format, SNumber),
       morphology_markup(pronoun, case, Case, Format, SCase),
       morphology_markup(pronoun, negative, Negative, Format, SNegative),
       morphology_markup(pronoun, anaphora, Anaphora, Format, SAnaphora),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w', [SType,SPerson,SGender,SNumber,SCase,SNegative,SAnaphora]).

% From the X table (prepositional constructions)
morphology_word_info([p,Type,Person,Gender,Number,Case,Negative,[XPosition,XPlace,XPreposition]], Format, Info) :-
       morphology_markup(pronoun, type, Type, Format, SType),
       morphology_markup(pronoun, person, Person, Format, SPerson),
       morphology_markup(pronoun, gender, Gender, Format, SGender),
       morphology_markup(pronoun, number, Number, Format, SNumber),
       morphology_markup(pronoun, case, Case, Format, SCase),
       morphology_markup(pronoun, negative, Negative, Format, SNegative),
       morphology_markup(preposition, xposition, XPosition, Format, SXPosition),
       morphology_markup(preposition, xplace, XPlace, Format, SXPlace),
       morphology_markup(preposition, xpreposition, XPreposition, Format, SXPreposition),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w',
       [SType,SPerson,SGender,SNumber,SCase,SNegative,SXPosition,SXPlace,SXPreposition]).

% From the X table (anaphors)
morphology_word_info([p,Type,Person,Gender,Number,Case,Negative,[ref]], Format, Info) :-
       morphology_markup(pronoun, type, Type, Format, SType),
       morphology_markup(pronoun, person, Person, Format, SPerson),
       morphology_markup(pronoun, gender, Gender, Format, SGender),
       morphology_markup(pronoun, number, Number, Format, SNumber),
       morphology_markup(pronoun, case, Case, Format, SCase),
       morphology_markup(pronoun, negative, Negative, Format, SNegative),
       
       sformat(Info, '~w ~w ~w ~w ~w ~w',
       [SType,SPerson,SGender,SNumber,SCase,SNegative]).

/* ========================================================================= */


/* === ADVERB ============================================================== */

morphology_word_info([r,Degree,Group], Format, Info) :-
       morphology_markup(adverb, degree, Degree, Format, SDegree),
       morphology_markup(adverb, group, Group, Format, SGroup),
       
       sformat(Info, '~w ~w', [SDegree,SGroup]).

/* ========================================================================= */


/* === PREPOSITION ========================================================= */

morphology_word_info([s,Position,Number,Case,[Place]], Format, Info) :-
       (not((Position = p , Number = p)) ; Case = d),

       morphology_markup(preposition, position, Position, Format, SPosition),
       morphology_markup(preposition, number, Number, Format, SNumber),
       morphology_markup(preposition, case, Case, Format, SCase),
       morphology_markup(preposition, xplace, Place, Format, SPlace),
       
       sformat(Info, '~w ~w ~w', [SPosition,SNumber,SCase,SPlace]).

/* ========================================================================= */


/* === CONJUNCTION ========================================================= */

morphology_word_info([c,Type,Formation], Format, Info) :-
       morphology_markup(conjunction, type, Type, Format, SType),
       morphology_markup(conjunction, formation, Formation, Format, SFormation),
       
       sformat(Info, '~w ~w', [SType,SFormation]).

/* ========================================================================= */


/* === NUMERAL ============================================================= */

morphology_word_info([m,Type,Formation,Gender,Number,Case,[Order]], Format, Info) :-
       morphology_markup(numeral, type, Type, Format, SType),
       morphology_markup(numeral, formation, Formation, Format, SFormation),
       morphology_markup(numeral, gender, Gender, Format, SGender),
       morphology_markup(numeral, number, Number, Format, SNumber),
       morphology_markup(numeral, case, Case, Format, SCase),
       morphology_markup(numeral, order, Order, Format, SOrder),
       
       sformat(Info, '~w ~w ~w ~w ~w',
       [SType,SFormation,SGender,SNumber,SCase,SOrder]).

/* ========================================================================= */


/* === INTERJECTION ======================================================== */

morphology_word_info([i,Formation], Format, Info) :-
       morphology_markup(interjection, formation, Formation, Format, SFormation),
       sformat(Info, '~w', [SFormation]).

/* ========================================================================= */


/* === PARTICLE ============================================================ */

morphology_word_info([q,Formation], Format, Info) :-
       morphology_markup(particle, formation, Formation, Format, SFormation),
       sformat(Info, '~w', [SFormation]).

/* ========================================================================= */


/* === PUNCTUATION ========================================================= */

morphology_word_info([z,Type], Format, Info) :-
       morphology_markup(punctuation, type, Type, Format, SType),
       sformat(Info, '~w', [SType]).

/* ========================================================================= */


/* === NOUN: FEATURES ====================================================== */

morphology_markup(noun, type, c, en, 'common').
morphology_markup(noun, type, c, lv, 'sugas vārds').
morphology_markup(noun, type, c, lvsh, 'sugas v.').

morphology_markup(noun, type, p, en, 'proper').
morphology_markup(noun, type, p, lv, 'īpašvārds').
morphology_markup(noun, type, p, lvsh, 'īpašv.').


morphology_markup(noun, gender, m, en, 'masculine').
morphology_markup(noun, gender, m, lv, 'vīriešu dzimte').
morphology_markup(noun, gender, m, lvsh, 'vīr.').

morphology_markup(noun, gender, f, en, 'feminine').
morphology_markup(noun, gender, f, lv, 'sieviešu dzimte').
morphology_markup(noun, gender, f, lvsh, 'siev.').

morphology_markup(noun, gender, k, en, '').
morphology_markup(noun, gender, k, lv, 'kopdzimte').
morphology_markup(noun, gender, k, lvsh, 'kop.').


morphology_markup(noun, number, s, en, 'singular').
morphology_markup(noun, number, s, lv, 'vienskaitlis').
morphology_markup(noun, number, s, lvsh, 'vsk.').

morphology_markup(noun, number, p, en, 'plural').
morphology_markup(noun, number, p, lv, 'daudzskaitlis').
morphology_markup(noun, number, p, lvsh, 'dsk.').

morphology_markup(noun, number, v, en, '').
morphology_markup(noun, number, v, lv, 'vienskaitlinieks').
morphology_markup(noun, number, v, lvsh, 'vsk-nieks').

morphology_markup(noun, number, d, en, '').
morphology_markup(noun, number, d, lv, 'daudzskaitlinieks').
morphology_markup(noun, number, d, lvsh, 'dsk-nieks').


morphology_markup(noun, case, n, en, 'nominative').
morphology_markup(noun, case, n, lv, 'nominatīvs').
morphology_markup(noun, case, n, lvsh, 'nom.').

morphology_markup(noun, case, g, en, 'genitive').
morphology_markup(noun, case, g, lv, 'ģenitīvs').
morphology_markup(noun, case, g, lvsh, 'ģen.').

morphology_markup(noun, case, d, en, 'dative').
morphology_markup(noun, case, d, lv, 'datīvs').
morphology_markup(noun, case, d, lvsh, 'dat.').

morphology_markup(noun, case, a, en, 'accusative').
morphology_markup(noun, case, a, lv, 'akuzatīvs').
morphology_markup(noun, case, a, lvsh, 'akuz.').

morphology_markup(noun, case, l, en, 'locative').
morphology_markup(noun, case, l, lv, 'lokatīvs').
morphology_markup(noun, case, l, lvsh, 'lok.').

morphology_markup(noun, case, v, en, 'vocative').
morphology_markup(noun, case, v, lv, 'vokatīvs').
morphology_markup(noun, case, v, lvsh, 'vok.').

morphology_markup(noun, case, s, en, '').
morphology_markup(noun, case, s, lv, 'ģenetīvenis').
morphology_markup(noun, case, s, lvsh, 'ģen-is').


morphology_markup(noun, declension, 1, en, '1st declension').
morphology_markup(noun, declension, 1, lv, '1. deklinācija').
morphology_markup(noun, declension, 1, lvsh, '1.dekl.').

morphology_markup(noun, declension, 2, en, '2nd declension').
morphology_markup(noun, declension, 2, lv, '2. deklinācija').
morphology_markup(noun, declension, 2, lvsh, '2.dekl.').

morphology_markup(noun, declension, 3, en, '3rd declension').
morphology_markup(noun, declension, 3, lv, '3. deklinācija').
morphology_markup(noun, declension, 3, lvsh, '3.dekl.').

morphology_markup(noun, declension, 4, en, '4th declension').
morphology_markup(noun, declension, 4, lv, '4. deklinācija').
morphology_markup(noun, declension, 4, lvsh, '4.dekl.').

morphology_markup(noun, declension, 5, en, '5th declension').
morphology_markup(noun, declension, 5, lv, '5. deklinācija').
morphology_markup(noun, declension, 5, lvsh, '5.dekl.').

morphology_markup(noun, declension, 6, en, '6th declension').
morphology_markup(noun, declension, 6, lv, '6. deklinācija').
morphology_markup(noun, declension, 6, lvsh, '6.dekl.').

morphology_markup(noun, declension, 0, en, '').
morphology_markup(noun, declension, 0, lv, '').
morphology_markup(noun, declension, 0, lvsh, '').

morphology_markup(noun, declension, r, en, 'reflexive').
morphology_markup(noun, declension, r, lv, 'atgriezenisks').
morphology_markup(noun, declension, r, lvsh, 'atgr.').


morphology_markup(noun, xsubtype, sp, en, '').
morphology_markup(noun, xsubtype, sp, lv, 'savrupināts pielikums').
morphology_markup(noun, xsubtype, sp, lvsh, 'savrup.piel.').

morphology_markup(noun, xsubtype, sd, en, '').
morphology_markup(noun, xsubtype, sd, lv, 'salīdzinātājdaļa').
morphology_markup(noun, xsubtype, sd, lvsh, 'salīdz.').

/* ========================================================================= */


/* === VERB: FEATURES ====================================================== */

morphology_markup(verb, type, m, en, 'main').
morphology_markup(verb, type, m, lv, 'patstāvīgs').
morphology_markup(verb, type, m, lvsh, 'patst.').

morphology_markup(verb, type, a, en, 'auxiliary').
morphology_markup(verb, type, a, lv, 'palīgverbs').
morphology_markup(verb, type, a, lvsh, 'palīg.').

morphology_markup(verb, type, o, en, 'modal').
morphology_markup(verb, type, o, lv, 'modāls').
morphology_markup(verb, type, o, lvsh, 'mod.').

morphology_markup(verb, type, p, en, 'phase').
morphology_markup(verb, type, p, lv, 'fāzes').
morphology_markup(verb, type, p, lvsh, 'fāzes').

morphology_markup(verb, type, e, en, '').
morphology_markup(verb, type, e, lv, 'izpausmes veida').
morphology_markup(verb, type, e, lvsh, 'izp.veida').

morphology_markup(verb, type, c, en, '').
morphology_markup(verb, type, c, lv, 'palīgverbs būt').
morphology_markup(verb, type, c, lvsh, 'palīg.').

morphology_markup(verb, type, t, en, '').
morphology_markup(verb, type, t, lv, 'palīgverbs tikt/tapt').
morphology_markup(verb, type, t, lvsh, 'palīg.').

morphology_markup(verb, type, g, en, '').
morphology_markup(verb, type, g, lv, 'nebūt/trūkt/pietikt').
morphology_markup(verb, type, g, lvsh, 'ģen.').


morphology_markup(verb, reflexivity, n, en, '').
morphology_markup(verb, reflexivity, n, lv, '').
morphology_markup(verb, reflexivity, n, lvsh, '').

morphology_markup(verb, reflexivity, y, en, 'reflexive').
morphology_markup(verb, reflexivity, y, lv, 'atgriezenisks').
morphology_markup(verb, reflexivity, y, lvsh, 'atgr.').

morphology_markup(verb, reflexivity, 0, en, '').
morphology_markup(verb, reflexivity, 0, lv, '').
morphology_markup(verb, reflexivity, 0, lvsh, '').


morphology_markup(verb, mood, i, en, 'indicative').
morphology_markup(verb, mood, i, lv, 'īstenības izteiksme').
morphology_markup(verb, mood, i, lvsh, 'īst.izt.').

morphology_markup(verb, mood, r, en, 'relative').
morphology_markup(verb, mood, r, lv, 'atstāstījuma izteiksme').
morphology_markup(verb, mood, r, lvsh, 'atst.izt.').

morphology_markup(verb, mood, c, en, 'conditional').
morphology_markup(verb, mood, c, lv, 'vēlējuma izteiksme').
morphology_markup(verb, mood, c, lvsh, 'vēl.izt.').

morphology_markup(verb, mood, d, en, 'debitive').
morphology_markup(verb, mood, d, lv, 'vajadzības izteiksme').
morphology_markup(verb, mood, d, lvsh, 'vajadz.izt.').

morphology_markup(verb, mood, m, en, 'imperative').
morphology_markup(verb, mood, m, lv, 'pavēles izteiksme').
morphology_markup(verb, mood, m, lvsh, 'pav.izt.').

morphology_markup(verb, mood, n, en, 'infinitive').
morphology_markup(verb, mood, n, lv, 'nenoteiksme').
morphology_markup(verb, mood, n, lvsh, 'nenot.').

morphology_markup(verb, mood, p, en, 'participle').
morphology_markup(verb, mood, p, lv, 'divdabis').
morphology_markup(verb, mood, p, lvsh, 'divd.').


morphology_markup(verb, tense, p, en, 'present').
morphology_markup(verb, tense, p, lv, 'tagadne').
morphology_markup(verb, tense, p, lvsh, 'tag.').

morphology_markup(verb, tense, f, en, 'future').
morphology_markup(verb, tense, f, lv, 'nākotne').
morphology_markup(verb, tense, f, lvsh, 'nāk.').

morphology_markup(verb, tense, s, en, 'past').
morphology_markup(verb, tense, s, lv, 'pagātne').
morphology_markup(verb, tense, s, lvsh, 'pag.').

morphology_markup(verb, tense, 0, en, '').
morphology_markup(verb, tense, 0, lv, '').
morphology_markup(verb, tense, 0, lvsh, '').


morphology_markup(verb, transitivity, t, en, 'transitive').
morphology_markup(verb, transitivity, t, lv, 'pārejošs').
morphology_markup(verb, transitivity, t, lvsh, 'pārej.').

morphology_markup(verb, transitivity, i, en, 'intransitive').
morphology_markup(verb, transitivity, i, lv, 'nepārejošs').
morphology_markup(verb, transitivity, i, lvsh, 'nepārej.').

morphology_markup(verb, transitivity, 0, en, '').
morphology_markup(verb, transitivity, 0, lv, '').
morphology_markup(verb, transitivity, 0, lvsh, '').


morphology_markup(verb, conjugation, 1, en, '1st conjugation').
morphology_markup(verb, conjugation, 1, lv, '1. konjugācija').
morphology_markup(verb, conjugation, 1, lvsh, '1.konj.').

morphology_markup(verb, conjugation, 2, en, '2nd conjugation').
morphology_markup(verb, conjugation, 2, lv, '2. konjugācija').
morphology_markup(verb, conjugation, 2, lvsh, '2.konj.').

morphology_markup(verb, conjugation, 3, en, '3rd conjugation').
morphology_markup(verb, conjugation, 3, lv, '3. konjugācija').
morphology_markup(verb, conjugation, 3, lvsh, '3.konj.').

morphology_markup(verb, conjugation, i, en, 'irregular').
morphology_markup(verb, conjugation, i, lv, 'nekārtnais').
morphology_markup(verb, conjugation, i, lvsh, 'nekārtn.').

morphology_markup(verb, conjugation, 0, en, '').
morphology_markup(verb, conjugation, 0, lv, '').
morphology_markup(verb, conjugation, 0, lvsh, '').


morphology_markup(verb, person, 1, en, '1st person').
morphology_markup(verb, person, 1, lv, '1. persona').
morphology_markup(verb, person, 1, lvsh, '1.pers.').

morphology_markup(verb, person, 2, en, '2nd person').
morphology_markup(verb, person, 2, lv, '2. persona').
morphology_markup(verb, person, 2, lvsh, '2.pers.').

morphology_markup(verb, person, 3, en, '3rd person').
morphology_markup(verb, person, 3, lv, '3. persona').
morphology_markup(verb, person, 3, lvsh, '3.pers.').

morphology_markup(verb, person, 0, en, '').
morphology_markup(verb, person, 0, lv, '').
morphology_markup(verb, person, 0, lvsh, '').


morphology_markup(verb, number, s, en, 'singular').
morphology_markup(verb, number, s, lv, 'vienskaitlis').
morphology_markup(verb, number, s, lvsh, 'vsk.').

morphology_markup(verb, number, p, en, 'plural').
morphology_markup(verb, number, p, lv, 'daudzskaitlis').
morphology_markup(verb, number, p, lvsh, 'dsk.').

morphology_markup(verb, number, 0, en, '').
morphology_markup(verb, number, 0, lv, '').
morphology_markup(verb, number, 0, lvsh, '').


morphology_markup(verb, voice, a, en, 'active').
morphology_markup(verb, voice, a, lv, 'darāmā kārta').
morphology_markup(verb, voice, a, lvsh, 'dar.k.').

morphology_markup(verb, voice, p, en, 'passive').
morphology_markup(verb, voice, p, lv, 'pasīvā kārta').
morphology_markup(verb, voice, p, lvsh, 'pas.k.').

morphology_markup(verb, voice, 0, en, '').
morphology_markup(verb, voice, 0, lv, '').
morphology_markup(verb, voice, 0, lvsh, '').


morphology_markup(verb, negative, y, en, 'negative').
morphology_markup(verb, negative, y, lv, 'negatīvs').
morphology_markup(verb, negative, y, lvsh, 'neg.').

morphology_markup(verb, negative, n, en, '').
morphology_markup(verb, negative, n, lv, '').
morphology_markup(verb, negative, n, lvsh, '').

/* X-WORD: SPECIFIC FEATURES ----------------------------------------------- */

morphology_markup(verb, xtype, act, en, 'active').
morphology_markup(verb, xtype, act, lv, 'darāmās kārta').
morphology_markup(verb, xtype, act, lvsh, 'dar.k.').

morphology_markup(verb, xtype, pass, en, 'passive').
morphology_markup(verb, xtype, pass, lv, 'ciešamā kārta').
morphology_markup(verb, xtype, pass, lvsh, 'cieš.k.').

morphology_markup(verb, xtype, subst, en, 'nominal predicate').
morphology_markup(verb, xtype, subst, lv, 'nomināls izteicējs').
morphology_markup(verb, xtype, subst, lvsh, 'nom.izteic.').

morphology_markup(verb, xtype, adj, en, 'nominal predicate').
morphology_markup(verb, xtype, adj, lv, 'nomināls izteicējs').
morphology_markup(verb, xtype, adj, lvsh, 'nom.izteic.').

morphology_markup(verb, xtype, pronom, en, 'nominal predicate').
morphology_markup(verb, xtype, pronom, lv, 'nomināls izteicējs').
morphology_markup(verb, xtype, pronom, lvsh, 'nom.izteic.').

morphology_markup(verb, xtype, modal, en, 'modal predicate').
morphology_markup(verb, xtype, modal, lv, 'modāls izteicējs').
morphology_markup(verb, xtype, modal, lvsh, 'mod.izteic.').

morphology_markup(verb, xtype, modal_red, en, 'modal reduction').
morphology_markup(verb, xtype, modal_red, lv, 'modāla redukcija').
morphology_markup(verb, xtype, modal_red, lvsh, 'mod.red.').

morphology_markup(verb, xtype, phase, en, 'phasal predicate').
morphology_markup(verb, xtype, phase, lv, 'fāzes izteicējs').
morphology_markup(verb, xtype, phase, lvsh, 'fāzes izteic.').

morphology_markup(verb, xtype, phase_red, en, 'phasal reduction').
morphology_markup(verb, xtype, phase_red, lv, 'fāzes redukcija').
morphology_markup(verb, xtype, phase_red, lvsh, 'fāzes red.').

morphology_markup(verb, xtype, expr, en, 'expressive predicate').
morphology_markup(verb, xtype, expr, lv, 'izpausmes izteicējs').
morphology_markup(verb, xtype, expr, lvsh, 'izp.izteic.').

morphology_markup(verb, xtype, adv, en, 'adverbial predicate').
morphology_markup(verb, xtype, adv, lv, 'adverbiāls izteicējs').
morphology_markup(verb, xtype, adv, lvsh, 'adv.izteic.').


morphology_markup(verb, xtense, s, en, 'simple').
morphology_markup(verb, xtense, s, lv, 'vienkāršs').
morphology_markup(verb, xtense, s, lvsh, 'vienk.').

morphology_markup(verb, xtense, p, en, 'perfect').
morphology_markup(verb, xtense, p, lv, 'salikts').
morphology_markup(verb, xtense, p, lvsh, 'sal.').


morphology_markup(verb, xcase, n, en, 'nominative').
morphology_markup(verb, xcase, n, lv, 'nominatīvs').
morphology_markup(verb, xcase, n, lvsh, 'nom.').

morphology_markup(verb, xcase, g, en, 'genitive').
morphology_markup(verb, xcase, g, lv, 'ģenitīs').
morphology_markup(verb, xcase, g, lvsh, 'ģen.').

morphology_markup(verb, xcase, d, en, 'dative').
morphology_markup(verb, xcase, d, lv, 'datīvs').
morphology_markup(verb, xcase, d, lvsh, 'dat.').

morphology_markup(verb, xcase, 0, en, '').
morphology_markup(verb, xcase, 0, lv, '').
morphology_markup(verb, xcase, 0, lvsh, '').

/* PARTICIPLE: SPECIFIC FEATURES ------------------------------------------- */

morphology_markup(verb, declension, d, en, 'declinable').
morphology_markup(verb, declension, d, lv, 'lokāms').
morphology_markup(verb, declension, d, lvsh, 'lok.').

morphology_markup(verb, declension, p, en, 'partly declinable').
morphology_markup(verb, declension, p, lv, 'daļēji lokāms').
morphology_markup(verb, declension, p, lvsh, 'd.lok.').

morphology_markup(verb, declension, u, en, 'undeclinable').
morphology_markup(verb, declension, u, lv, 'nelokāms').
morphology_markup(verb, declension, u, lvsh, 'nelok.').


morphology_markup(verb, gender, m, en, 'masculine').
morphology_markup(verb, gender, m, lv, 'vīriešu dzimte').
morphology_markup(verb, gender, m, lvsh, 'vīr.').

morphology_markup(verb, gender, f, en, 'feminine').
morphology_markup(verb, gender, f, lv, 'sieviešu dzimte').
morphology_markup(verb, gender, f, lvsh, 'siev.').

morphology_markup(verb, gender, 0, en, '').
morphology_markup(verb, gender, 0, lv, '').
morphology_markup(verb, gender, 0, lvsh, '').


morphology_markup(verb, case, n, en, 'nominative').
morphology_markup(verb, case, n, lv, 'nominatīvs').
morphology_markup(verb, case, n, lvsh, 'nom.').

morphology_markup(verb, case, g, en, 'genitive').
morphology_markup(verb, case, g, lv, 'ģenitīs').
morphology_markup(verb, case, g, lvsh, 'ģen.').

morphology_markup(verb, case, d, en, 'dative').
morphology_markup(verb, case, d, lv, 'datīvs').
morphology_markup(verb, case, d, lvsh, 'dat.').

morphology_markup(verb, case, a, en, 'accusative').
morphology_markup(verb, case, a, lv, 'akuzatīs').
morphology_markup(verb, case, a, lvsh, 'akuz.').

morphology_markup(verb, case, l, en, 'locative').
morphology_markup(verb, case, l, lv, 'lokatīvs').
morphology_markup(verb, case, l, lvsh, 'lok.').

morphology_markup(verb, case, v, en, 'vocative').
morphology_markup(verb, case, v, lv, 'vokatīvs').
morphology_markup(verb, case, v, lvsh, 'vok.').

morphology_markup(verb, case, 0, en, '').
morphology_markup(verb, case, 0, lv, '').
morphology_markup(verb, case, 0, lvsh, '').


morphology_markup(verb, ptense, p, en, 'present').
morphology_markup(verb, ptense, p, lv, 'tagadne').
morphology_markup(verb, ptense, p, lvsh, 'tag.').

morphology_markup(verb, ptense, s, en, 'past').
morphology_markup(verb, ptense, s, lv, 'pagātne').
morphology_markup(verb, ptense, s, lvsh, 'pag.').

morphology_markup(verb, ptense, 0, en, '').
morphology_markup(verb, ptense, 0, lv, '').
morphology_markup(verb, ptense, 0, lvsh, '').


morphology_markup(verb, definitness, n, en, 'undefinite').
morphology_markup(verb, definitness, n, lv, 'nenoteiktais').
morphology_markup(verb, definitness, n, lvsh, 'nenot.').

morphology_markup(verb, definitness, y, en, 'definite').
morphology_markup(verb, definitness, y, lv, 'noteiktais').
morphology_markup(verb, definitness, y, lvsh, 'not.').

morphology_markup(verb, definitness, 0, en, '').
morphology_markup(verb, definitness, 0, lv, '').
morphology_markup(verb, definitness, 0, lvsh, '').


morphology_markup(verb, xsubtype, dt, en, 'participial clause').
morphology_markup(verb, xsubtype, dt, lv, 'divdabja teiciens').
morphology_markup(verb, xsubtype, dt, lvsh, 'divd.teic.').

/* ========================================================================= */


/* === ADJECTIVE: FEATURES ================================================= */

morphology_markup(adjective, type, f, en, 'qualificative').
morphology_markup(adjective, type, f, lv, 'kādības').
morphology_markup(adjective, type, f, lvsh, 'kādības').

morphology_markup(adjective, type, r, en, 'relative').
morphology_markup(adjective, type, r, lv, 'attieksmes').
morphology_markup(adjective, type, r, lvsh, 'attieksmes').


morphology_markup(adjective, gender, m, en, 'masculine').
morphology_markup(adjective, gender, m, lv, 'vīriešu dzimte').
morphology_markup(adjective, gender, m, lvsh, 'vīr.').

morphology_markup(adjective, gender, f, en, 'feminine').
morphology_markup(adjective, gender, f, lv, 'sieviešu dzimte').
morphology_markup(adjective, gender, f, lvsh, 'siev.').


morphology_markup(adjective, number, s, en, 'singular').
morphology_markup(adjective, number, s, lv, 'vienskaitlis').
morphology_markup(adjective, number, s, lvsh, 'vsk.').

morphology_markup(adjective, number, p, en, 'plural').
morphology_markup(adjective, number, p, lv, 'daudzskaitlis').
morphology_markup(adjective, number, p, lvsh, 'dsk.').


morphology_markup(adjective, case, n, en, 'nominative').
morphology_markup(adjective, case, n, lv, 'nominatīvs').
morphology_markup(adjective, case, n, lvsh, 'nom.').

morphology_markup(adjective, case, g, en, 'genitive').
morphology_markup(adjective, case, g, lv, 'ģenitīs').
morphology_markup(adjective, case, g, lvsh, 'ģen.').

morphology_markup(adjective, case, d, en, 'dative').
morphology_markup(adjective, case, d, lv, 'datīvs').
morphology_markup(adjective, case, d, lvsh, 'dat.').

morphology_markup(adjective, case, a, en, 'accusative').
morphology_markup(adjective, case, a, lv, 'akuzatīs').
morphology_markup(adjective, case, a, lvsh, 'akuz.').

morphology_markup(adjective, case, l, en, 'locative').
morphology_markup(adjective, case, l, lv, 'lokatīvs').
morphology_markup(adjective, case, l, lvsh, 'lok.').

morphology_markup(adjective, case, v, en, 'vocative').
morphology_markup(adjective, case, v, lv, 'vokatīvs').
morphology_markup(adjective, case, v, lvsh, 'vok.').


morphology_markup(adjective, definitness, y, en, 'definite').
morphology_markup(adjective, definitness, y, lv, 'noteikts').
morphology_markup(adjective, definitness, y, lvsh, 'noteikts').

morphology_markup(adjective, definitness, n, en, 'undefinite').
morphology_markup(adjective, definitness, n, lv, 'nenoteikts').
morphology_markup(adjective, definitness, n, lvsh, 'nenot.').


morphology_markup(adjective, degree, p, en, 'positive').
morphology_markup(adjective, degree, p, lv, 'pamata pakāpe').
morphology_markup(adjective, degree, p, lvsh, 'pam.pak.').

morphology_markup(adjective, degree, c, en, 'comparative').
morphology_markup(adjective, degree, c, lv, 'pārākā pakāpe').
morphology_markup(adjective, degree, c, lvsh, 'pār.pak.').

morphology_markup(adjective, degree, s, en, 'superlative').
morphology_markup(adjective, degree, s, lv, 'vispārākā pakāpe').
morphology_markup(adjective, degree, s, lvsh, 'visp.pak.').


morphology_markup(adjective, xsubtype, sa, en, '').
morphology_markup(adjective, xsubtype, sa, lv, 'savrupināts apzīmētājs').
morphology_markup(adjective, xsubtype, sa, lvsh, 'savrup.apzīm.').

/* ========================================================================= */


/* === PRONOUN: FEATURES =================================================== */

morphology_markup(pronoun, type, p, en, 'personal').
morphology_markup(pronoun, type, p, lv, 'personas').
morphology_markup(pronoun, type, p, lvsh, 'pers.').

morphology_markup(pronoun, type, x, en, 'reflexsive').
morphology_markup(pronoun, type, x, lv, 'atgriezeniskais').
morphology_markup(pronoun, type, x, lvsh, 'atgr.').

morphology_markup(pronoun, type, s, en, 'possesive').
morphology_markup(pronoun, type, s, lv, 'piederības').
morphology_markup(pronoun, type, s, lvsh, 'pied.').

morphology_markup(pronoun, type, d, en, 'demonstrative').
morphology_markup(pronoun, type, d, lv, 'norādāmais').
morphology_markup(pronoun, type, d, lvsh, 'norād.').

morphology_markup(pronoun, type, i, en, 'indefinite').
morphology_markup(pronoun, type, i, lv, 'nenoteiktais').
morphology_markup(pronoun, type, i, lvsh, 'nenot.').

morphology_markup(pronoun, type, q, en, 'interrogative').
morphology_markup(pronoun, type, q, lv, 'jautājamais').
morphology_markup(pronoun, type, q, lvsh, 'jaut.').

morphology_markup(pronoun, type, r, en, 'relative').
morphology_markup(pronoun, type, r, lv, 'attieksmes').
morphology_markup(pronoun, type, r, lvsh, 'attieksmes').

morphology_markup(pronoun, type, g, en, 'general').
morphology_markup(pronoun, type, g, lv, 'noteiktais').
morphology_markup(pronoun, type, g, lvsh, 'not.').


morphology_markup(pronoun, person, 1, en, '1st person').
morphology_markup(pronoun, person, 1, lv, '1. persona').
morphology_markup(pronoun, person, 1, lvsh, '1.pers.').

morphology_markup(pronoun, person, 2, en, '2nd person').
morphology_markup(pronoun, person, 2, lv, '2. persona').
morphology_markup(pronoun, person, 2, lvsh, '2.pers.').

morphology_markup(pronoun, person, 3, en, '3rd person').
morphology_markup(pronoun, person, 3, lv, '3. persona').
morphology_markup(pronoun, person, 3, lvsh, '3.pers.').

morphology_markup(pronoun, person, 0, en, '').
morphology_markup(pronoun, person, 0, lv, '').
morphology_markup(pronoun, person, 0, lvsh, '').


morphology_markup(pronoun, gender, m, en, 'masculine').
morphology_markup(pronoun, gender, m, lv, 'vīriešu dzimte').
morphology_markup(pronoun, gender, m, lvsh, 'vīr.').

morphology_markup(pronoun, gender, f, en, 'feminine').
morphology_markup(pronoun, gender, f, lv, 'sieviešu dzimte').
morphology_markup(pronoun, gender, f, lvsh, 'siev.').

morphology_markup(pronoun, gender, 0, en, '').
morphology_markup(pronoun, gender, 0, lv, '').
morphology_markup(pronoun, gender, 0, lvsh, '').


morphology_markup(pronoun, number, s, en, 'singular').
morphology_markup(pronoun, number, s, lv, 'vienskaitlis').
morphology_markup(pronoun, number, s, lvsh, 'vsk.').

morphology_markup(pronoun, number, p, en, 'plural').
morphology_markup(pronoun, number, p, lv, 'daudzskaitlis').
morphology_markup(pronoun, number, p, lvsh, 'dsk.').

morphology_markup(pronoun, number, 0, en, '').
morphology_markup(pronoun, number, 0, lv, '').
morphology_markup(pronoun, number, 0, lvsh, '').


morphology_markup(pronoun, case, n, en, 'nominative').
morphology_markup(pronoun, case, n, lv, 'nominatīvs').
morphology_markup(pronoun, case, n, lvsh, 'nom.').

morphology_markup(pronoun, case, g, en, 'genitive').
morphology_markup(pronoun, case, g, lv, 'ģenitīvs').
morphology_markup(pronoun, case, g, lvsh, 'ģen.').

morphology_markup(pronoun, case, d, en, 'dative').
morphology_markup(pronoun, case, d, lv, 'datīvs').
morphology_markup(pronoun, case, d, lvsh, 'dat.').

morphology_markup(pronoun, case, a, en, 'accusative').
morphology_markup(pronoun, case, a, lv, 'akuzatīvs').
morphology_markup(pronoun, case, a, lvsh, 'akuz.').

morphology_markup(pronoun, case, l, en, 'locative').
morphology_markup(pronoun, case, l, lv, 'lokatīvs').
morphology_markup(pronoun, case, l, lvsh, 'lok.').


morphology_markup(pronoun, negative, y, en, 'negative').
morphology_markup(pronoun, negative, y, lv, 'negatīvs').
morphology_markup(pronoun, negative, y, lvsh, 'neg.').

morphology_markup(pronoun, negative, n, en, '').
morphology_markup(pronoun, negative, n, lv, '').
morphology_markup(pronoun, negative, n, lvsh, '').


morphology_markup(pronoun, anaphora, a, en, 'adjective-reference').
morphology_markup(pronoun, anaphora, a, lv, 'aizstāj adjektīvu').
morphology_markup(pronoun, anaphora, a, lvsh, 'adj.').

morphology_markup(pronoun, anaphora, s, en, 'noun-reference').
morphology_markup(pronoun, anaphora, s, lv, 'aizstāj substantīvu').
morphology_markup(pronoun, anaphora, s, lvsh, 'subst.').

morphology_markup(pronoun, anaphora, 0, en, '').
morphology_markup(pronoun, anaphora, 0, lv, '').
morphology_markup(pronoun, anaphora, 0, lvsh, '').

/* ========================================================================= */


/* === ADVERB: FEATURES ==================================================== */

morphology_markup(adverb, degree, r, en, 'relative').
morphology_markup(adverb, degree, r, lv, 'relatīvais adverbs').
morphology_markup(adverb, degree, r, lvsh, 'rel.').

morphology_markup(adverb, degree, p, en, 'positive').
morphology_markup(adverb, degree, p, lv, 'pamata pakāpe').
morphology_markup(adverb, degree, p, lvsh, 'pam.pak.').

morphology_markup(adverb, degree, c, en, 'comparative').
morphology_markup(adverb, degree, c, lv, 'pārākā pakāpe').
morphology_markup(adverb, degree, c, lvsh, 'pār.pak.').

morphology_markup(adverb, degree, s, en, 'superlative').
morphology_markup(adverb, degree, s, lv, 'vispārākā pakāpe').
morphology_markup(adverb, degree, s, lvsh, 'vispār.pak.').

morphology_markup(adverb, degree, 0, en, '').
morphology_markup(adverb, degree, 0, lv, '').
morphology_markup(adverb, degree, 0, lvsh, '').


morphology_markup(adverb, group, q, en, 'quantitative').
morphology_markup(adverb, group, q, lv, 'mēra apstākļa vārds').
morphology_markup(adverb, group, q, lvsh, 'mēra').

morphology_markup(adverb, group, m, en, 'manner').
morphology_markup(adverb, group, m, lv, 'veida apstākļa vārds').
morphology_markup(adverb, group, m, lvsh, 'veida').

morphology_markup(adverb, group, p, en, 'place').
morphology_markup(adverb, group, p, lv, 'vietas apstākļa vārds').
morphology_markup(adverb, group, p, lvsh, 'vietas').

morphology_markup(adverb, group, t, en, 'time').
morphology_markup(adverb, group, t, lv, 'laika apstākļa vārds').
morphology_markup(adverb, group, t, lvsh, 'laika').

morphology_markup(adverb, group, c, en, 'causative').
morphology_markup(adverb, group, c, lv, 'cēloņa/nolūka apstākļa vārds').
morphology_markup(adverb, group, c, lvsh, 'cēl./nol.').

/* ========================================================================= */


/* === PREPOSITION: FEATURES =============================================== */

morphology_markup(preposition, position, p, en, 'pre').
morphology_markup(preposition, position, p, lv, 'prepozīcija').
morphology_markup(preposition, position, p, lvsh, 'prep.').

morphology_markup(preposition, position, t, en, 'post').
morphology_markup(preposition, position, t, lv, 'postpozīcija').
morphology_markup(preposition, position, t, lvsh, 'postp.').


morphology_markup(preposition, number, s, en, 'singular').
morphology_markup(preposition, number, s, lv, 'vienskaitlis').
morphology_markup(preposition, number, s, lvsh, 'vsk.').

morphology_markup(preposition, number, p, en, 'plural').
morphology_markup(preposition, number, p, lv, 'daudzskaitlis').
morphology_markup(preposition, number, p, lvsh, 'dsk.').


morphology_markup(preposition, case, g, en, 'genitive').
morphology_markup(preposition, case, g, lv, 'ģenitīvs').
morphology_markup(preposition, case, g, lvsh, 'ģen.').

morphology_markup(preposition, case, d, en, 'dative').
morphology_markup(preposition, case, d, lv, 'datīvs').
morphology_markup(preposition, case, d, lvsh, 'dat.').

morphology_markup(preposition, case, a, en, 'accusative').
morphology_markup(preposition, case, a, lv, 'akuzatīvs').
morphology_markup(preposition, case, a, lvsh, 'akuz.').

/* X-WORD: SPECIFIC FEATURES ----------------------------------------------- */

morphology_markup(preposition, xposition, pre, en, 'pre').
morphology_markup(preposition, xposition, pre, lv, 'prepozīcija').
morphology_markup(preposition, xposition, pre, lvsh, 'prep.').

morphology_markup(preposition, xposition, post, en, 'post').
morphology_markup(preposition, xposition, post, lv, 'postpozīcija').
morphology_markup(preposition, xposition, post, lvsh, 'postp.').

morphology_markup(preposition, xposition, rel, en, 'rel').
morphology_markup(preposition, xposition, rel, lv, 'relatīvais adverbs').
morphology_markup(preposition, xposition, rel, lvsh, 'rel.').


morphology_markup(preposition, xplace, y, en, 'modifier-place').
morphology_markup(preposition, xplace, y, lv, 'vietas apstāklis').
morphology_markup(preposition, xplace, y, lvsh, 'vieta').

morphology_markup(preposition, xplace, n, en, '').
morphology_markup(preposition, xplace, n, lv, '').
morphology_markup(preposition, xplace, n, lvsh, '').


morphology_markup(preposition, xpreposition, P, en, P).
morphology_markup(preposition, xpreposition, P, lv, P).
morphology_markup(preposition, xpreposition, P, lvsh, P).

/* ========================================================================= */


/* === CONJUNCTION: FEATURES =============================================== */

morphology_markup(conjunction, type, c, en, 'coordinating').
morphology_markup(conjunction, type, c, lv, 'sakārtojuma').
morphology_markup(conjunction, type, c, lvsh, 'sak.').

morphology_markup(conjunction, type, s, en, 'subcoordinating').
morphology_markup(conjunction, type, s, lv, 'pakārtojuma').
morphology_markup(conjunction, type, s, lvsh, 'pak.').


morphology_markup(conjunction, formation, s, en, 'simple').
morphology_markup(conjunction, formation, s, lv, 'vienkāršs').
morphology_markup(conjunction, formation, s, lvsh, 'vienk.').

morphology_markup(conjunction, formation, c, en, 'compound').
morphology_markup(conjunction, formation, c, lv, 'salikts').
morphology_markup(conjunction, formation, c, lvsh, 'sal.').

morphology_markup(conjunction, formation, d, en, 'double').
morphology_markup(conjunction, formation, d, lv, 'divkāršs').
morphology_markup(conjunction, formation, d, lvsh, 'divk.').

morphology_markup(conjunction, formation, r, en, 'repetit').
morphology_markup(conjunction, formation, r, lv, 'atkārtots').
morphology_markup(conjunction, formation, r, lvsh, 'atk.').

/* ========================================================================= */


/* === NUMERAL: FEATURES =================================================== */

morphology_markup(numeral, type, c, en, 'cardinal').
morphology_markup(numeral, type, c, lv, 'pamata').
morphology_markup(numeral, type, c, lvsh, 'pam.').

morphology_markup(numeral, type, o, en, 'ordinal').
morphology_markup(numeral, type, o, lv, 'kārtas').
morphology_markup(numeral, type, o, lvsh, 'kārtas').

morphology_markup(numeral, type, f, en, 'fractal').
morphology_markup(numeral, type, f, lv, 'daļskaitlis').
morphology_markup(numeral, type, f, lvsh, 'daļsk.').


morphology_markup(numeral, formation, s, en, 'simple').
morphology_markup(numeral, formation, s, lv, 'vienkāršs').
morphology_markup(numeral, formation, s, lvsh, 'vienk.').

morphology_markup(numeral, formation, c, en, 'compound').
morphology_markup(numeral, formation, c, lv, 'salikts').
morphology_markup(numeral, formation, c, lvsh, 'sal.').

morphology_markup(numeral, formation, j, en, 'conjunction').
morphology_markup(numeral, formation, j, lv, 'savienots').
morphology_markup(numeral, formation, j, lvsh, 'savien.').


morphology_markup(numeral, gender, m, en, 'masculine').
morphology_markup(numeral, gender, m, lv, 'vīriešu dzimte').
morphology_markup(numeral, gender, m, lvsh, 'vīr.').

morphology_markup(numeral, gender, f, en, 'feminine').
morphology_markup(numeral, gender, f, lv, 'sieviešu dzimte').
morphology_markup(numeral, gender, f, lvsh, 'siev.').

morphology_markup(numeral, gender, 0, en, '').
morphology_markup(numeral, gender, 0, lv, '').
morphology_markup(numeral, gender, 0, lvsh, '').


morphology_markup(numeral, number, s, en, 'singular').
morphology_markup(numeral, number, s, lv, 'vienskaitlis').
morphology_markup(numeral, number, s, lvsh, 'vsk.').

morphology_markup(numeral, number, p, en, 'plural').
morphology_markup(numeral, number, p, lv, 'daudzskaitlis').
morphology_markup(numeral, number, p, lvsh, 'dsk.').


morphology_markup(numeral, case, n, en, 'nominative').
morphology_markup(numeral, case, n, lv, 'nominatīvs').
morphology_markup(numeral, case, n, lvsh, 'nom.').

morphology_markup(numeral, case, g, en, 'genitive').
morphology_markup(numeral, case, g, lv, 'ģenitīs').
morphology_markup(numeral, case, g, lvsh, 'ģen.').

morphology_markup(numeral, case, d, en, 'dative').
morphology_markup(numeral, case, d, lv, 'datīvs').
morphology_markup(numeral, case, d, lvsh, 'dat.').

morphology_markup(numeral, case, a, en, 'accusative').
morphology_markup(numeral, case, a, lv, 'akuzatīs').
morphology_markup(numeral, case, a, lvsh, 'akuz.').

morphology_markup(numeral, case, l, en, 'locative').
morphology_markup(numeral, case, l, lv, 'lokatīvs').
morphology_markup(numeral, case, l, lvsh, 'lok.').

morphology_markup(numeral, case, 0, en, '').
morphology_markup(numeral, case, 0, lv, '').
morphology_markup(numeral, case, 0, lvsh, '').


morphology_markup(numeral, order, v, en, '').
morphology_markup(numeral, order, v, lv, 'vieni').
morphology_markup(numeral, order, v, lvsh, 'vieni').

morphology_markup(numeral, order, d, en, '').
morphology_markup(numeral, order, d, lv, 'desmiti').
morphology_markup(numeral, order, d, lvsh, 'desmiti').

morphology_markup(numeral, order, p, en, '').
morphology_markup(numeral, order, p, lv, 'padsmiti').
morphology_markup(numeral, order, p, lvsh, 'padsmiti').

morphology_markup(numeral, order, s, en, '').
morphology_markup(numeral, order, s, lv, 'simti').
morphology_markup(numeral, order, s, lvsh, 'simti').

morphology_markup(numeral, order, t, en, '').
morphology_markup(numeral, order, t, lv, 'tūkstoši').
morphology_markup(numeral, order, t, lvsh, 'tūkstoši').

morphology_markup(numeral, order, m, en, '').
morphology_markup(numeral, order, m, lv, 'miljoni').
morphology_markup(numeral, order, m, lvsh, 'miljoni').

morphology_markup(numeral, order, r, en, '').
morphology_markup(numeral, order, r, lv, 'miljardi').
morphology_markup(numeral, order, r, lvsh, 'miljardi').

/* ========================================================================= */


/* === SPK: FEATURES ================================================== */

morphology_markup(spk, xtype, spk, en, 'semi-predicative component').
morphology_markup(spk, xtype, spk, lv, 'sekundāri predikatīvs komponents').
morphology_markup(spk, xtype, spk, lvsh, 'spk').

/* ========================================================================= */


/* === INTERJECTION: FEATURES ============================================== */

morphology_markup(interjection, formation, s, en, 'simple').
morphology_markup(interjection, formation, s, lv, 'vienkāršs').
morphology_markup(interjection, formation, s, lvsh, 'vienk.').

morphology_markup(interjection, formation, c, en, 'compound').
morphology_markup(interjection, formation, c, lv, 'salikts').
morphology_markup(interjection, formation, c, lvsh, 'sal.').

/* ========================================================================= */


/* === PARTICLE: FEATURES ================================================== */

morphology_markup(particle, formation, s, en, 'simple').
morphology_markup(particle, formation, s, lv, 'vienkāršs').
morphology_markup(particle, formation, s, lvsh, 'vienk.').

morphology_markup(particle, formation, c, en, 'compound').
morphology_markup(particle, formation, c, lv, 'salikts').
morphology_markup(particle, formation, c, lvsh, 'sal.').

/* ========================================================================= */


/* === PUNCTUATION: FEATURES =============================================== */

morphology_markup(punctuation, type, c, en, 'comma').
morphology_markup(punctuation, type, c, lv, 'komats').
morphology_markup(punctuation, type, c, lvsh, 'komats').

morphology_markup(punctuation, type, q, en, 'quote').
morphology_markup(punctuation, type, q, lv, 'pēdiņa').
morphology_markup(punctuation, type, q, lvsh, 'pēdiņa').

morphology_markup(punctuation, type, s, en, 'stop').
morphology_markup(punctuation, type, s, lv, 'punkts').
morphology_markup(punctuation, type, s, lvsh, 'punkts').

morphology_markup(punctuation, type, b, en, 'bracket').
morphology_markup(punctuation, type, b, lv, 'iekava').
morphology_markup(punctuation, type, b, lvsh, 'iekava').

morphology_markup(punctuation, type, d, en, 'dash').
morphology_markup(punctuation, type, d, lv, 'defise/domu zīme').
morphology_markup(punctuation, type, d, lvsh, 'd.z.').

morphology_markup(punctuation, type, o, en, 'colon').
morphology_markup(punctuation, type, o, lv, 'kols').
morphology_markup(punctuation, type, o, lvsh, 'kols').

/* ========================================================================= */


/* morphology_markup(_, _, Markup, _, Markup). */
