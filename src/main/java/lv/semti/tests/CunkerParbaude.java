/*******************************************************************************
 * Copyright 2008, 2009 Institute of Mathematics and Computer Science, University of Latvia; Author: Pēteris Paikens, Imants Borodkins
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 * 
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *******************************************************************************/
package lv.semti.tests;


import static org.junit.Assert.*;
import lv.semti.annotator.syntax.*;

import org.junit.Test;


public class CunkerParbaude {

	@Test
	public void sadalīšanaČunkos() {
		TextData teksts = new TextData(
				"\tBeidzot viņa iegriezās Āboliņa ceļā. Ceļa galā bija spējš pagrieziens, kuru mēdza saukt par \"Kapteiņa loku\". Cilvēkus te redzēja staigājam vienīgi sestdienās un svētdienās.",
				null, null, null, null, true);
		assertEquals(3, teksts.getChunksCount());
		assertEquals("Beidzot viņa iegriezās Āboliņa ceļā.", teksts.getChunk(0).getSentence());
		assertEquals("Ceļa galā bija spējš pagrieziens, kuru mēdza saukt par \"Kapteiņa loku\".", teksts.getChunk(1).getSentence());
		assertEquals("Cilvēkus te redzēja staigājam vienīgi sestdienās un svētdienās.", teksts.getChunk(2).getSentence());
	}

	@Test
	public void pēdiņas() {
		//Teksts teksts = 
			new TextData(
				"\tKapakmenī bija iegravēti vardi: \"Mazā Marija pie mums atnāca, mīļi apsveica, projām aizsteidza.\"		      Dārza tālais nostūris lejā aiz avenājiem bija īsts biezoknis, kas vai nu ziedēja, vai rotājās ar ogām.",
				null, null, null, null, true);
		/*
		assertEquals(3, teksts.getČunkuSkaits());
		assertEquals("Kapakmenī bija iegravēti vardi:", teksts.getČunku(0).getTeikums());
		assertEquals("\"Mazā Marija pie mums atnāca, mīļi apsveica, projām aizsteidza.\"", teksts.getČunku(1).getTeikums());
		assertEquals("Dārza tālais nostūris lejā aiz avenājiem bija īsts biezoknis, kas vai nu ziedēja, vai rotājās ar ogām.", teksts.getČunku(2).getTeikums());
		*/
	}
}
