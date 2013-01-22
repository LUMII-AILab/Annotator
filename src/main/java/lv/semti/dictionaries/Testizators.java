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
package lv.semti.dictionaries;
import java.io.PrintStream;
import java.io.PrintWriter;

import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.lexicon.*;

public class Testizators {

	public static void main(String[] args) throws Exception {
		
		//Vārdnīca LLVI = new Vārdnīca("D:\\Lingvistika\\Vaardniica\\LLVV_1_029_517.xml");
		Dictionary LVV = new Dictionary("D:\\Lingvistika\\Vaardniica\\LVV.xml");
		Analyzer analizators = new Analyzer("D:\\Lingvistika\\Leksikons.xml");
		
		PrintWriter izeja = new PrintWriter(new PrintStream(System.out, true, "windows-1257"));
		
		for (Entry šķirklis : LVV.entries) {
			//šķirklis.Aprakstīt(izeja);	
			Word vārds = analizators.analyze(šķirklis.wordform);
			if (vārds.wordformsCount()==1) {				
				Lexeme leksēma = analizators.lexemeByID(Integer.parseInt(vārds.wordforms.get(0).getValue("Leksēmas nr")));
				int nozīmesnr = 0;
				for (String def : šķirklis.d) {
					nozīmesnr++;					
					leksēma.addAttribute(String.format("Nozīme %s", nozīmesnr), def);
				}			
			}			
			vārds = analizators.analyze(šķirklis.wordform);
			//vārds.Aprakstīt(izeja);
			izeja.printf("%s\n",šķirklis.wordform);
		}
		analizators.toXML("Leksikons2.xml");
		
		izeja.flush();
	}

}
