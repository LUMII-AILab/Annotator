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
import org.junit.Test;

import lv.semti.PrologInterface.WordDescription;

public class VardaprakstsTest {
	@Test
	public void meitenīte() {
		WordDescription vārdapraksts = new WordDescription(
			"'[[teikuma_priekšmets, nr3], _G70, [n, _G71, f, s, n, 5], meitenīte, _G90, tool, null], meitenīte'");
		
		assertEquals("meitenīte",vārdapraksts.getForm());
		assertEquals("n_fsn5",vārdapraksts.getTag());
		assertEquals("teikuma priekšmets",vārdapraksts.getRole());
		assertEquals(false, vārdapraksts.isXWord());
	}
	
	@Test
	public void dzīvoja() {
		WordDescription vārdapraksts = new WordDescription(
			"'[x, x, [v, m, n, i, s, t, _G0, 2, 3, s, _G1, _G2], dzīvot, _G39, tool, null], \'Dzīvoja\''");
		
		assertEquals("Dzīvoja",vārdapraksts.getForm());
		assertEquals("vmnist_23s__",vārdapraksts.getTag());
		assertEquals("",vārdapraksts.getRole());
		assertEquals(false, vārdapraksts.isXWord());
	}

	@Test
	public void www() {
		WordDescription vārdapraksts = new WordDescription(
			"www");
		
		assertEquals("www",vārdapraksts.getForm());
		assertEquals("x",vārdapraksts.getTag());
		assertEquals("",vārdapraksts.getRole());
		assertEquals(false, vārdapraksts.isXWord());
	}

	@Test
	public void xVārds() {
		WordDescription vārdapraksts = new WordDescription(
			"[x, x, [n, _G0, _G1, _G2, n, _G3], _G22, _G23, defs, apvienojums], apvienojums");
		
		assertEquals("apvienojums",vārdapraksts.getForm());
		assertEquals("n___n_",vārdapraksts.getTag());
		assertEquals("",vārdapraksts.getRole());
		assertEquals(true, vārdapraksts.isXWord());
	}

	@Test
	public void komats() {
		WordDescription vārdapraksts = new WordDescription(
			"[x, x, [z, c], (\\',\\'), _G243, tool, null], \\',\\'");
		
		assertEquals(",",vārdapraksts.getForm());
		assertEquals("zc",vārdapraksts.getTag());
		assertEquals("",vārdapraksts.getRole());
		assertEquals(false, vārdapraksts.isXWord());
	}
}
