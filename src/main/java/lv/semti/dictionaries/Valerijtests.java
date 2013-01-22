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

public class Valerijtests {

	public static void main(String[] args) throws Exception {
				
		Valerijformats lietvārdi = new Valerijformats("D:\\Lingvistika\\Valeerijs\\adjectives.txt");
		Analyzer analizators = new Analyzer("D:\\Lingvistika\\Leksikons.xml");
		analizators.guessNouns = false;
		analizators.guessParticibles = false;
		analizators.guessVerbs = false;
		analizators.guessAdjectives = true;
		analizators.enableDiminutive = false;
		analizators.enablePrefixes = false;
		analizators.enableGuessing = false;
		analizators.meklētsalikteņus = false;
		
		PrintWriter izeja = new PrintWriter(new PrintStream(System.out, true, "windows-1257"));
		
		//analizators.Analizēt("abonēšana").Aprakstīt(izeja);
		
		int Valērijvārdi_kopā = 0;
		int Valērijvārdi_neatpazīti = 0;
		int Valērijvārdi_neatpazīti_uzminēti = 0;
		int Valērijvārdi_sakrīt_labi = 0;
		int Valērijvārdi_hvz = 0;
		
		for (Valerijskirklis šķirklis : lietvārdi.Šķirkļi) {	
			if (!šķirklis.saknesnr.equalsIgnoreCase("01")) continue; // skatamies tikai pirmo no visām saknēm, kas Valērijam ir vairākas pat miju dēļ
			
			Word vārds = analizators.analyze(šķirklis.vārds);
			vārds.filterByAttributes(šķirklis.VajadzīgāsĪpašības());
			
			Valērijvārdi_kopā++;
			if (vārds.wordformsCount()==0) {
				Valērijvārdi_neatpazīti++;				
				analizators.enableGuessing = true; //analizators.meklētpriedēkļus = true;
				Word minētais = analizators.analyze(šķirklis.vārds);
				//FIXME - nemin, ja ir tāds vārds leksikonā no citas vārdšķiras - piemēram, 'adhezīvs' kā īp.v un kā lietv.
				//minētais.Aprakstīt(izeja);
				minētais.filterByAttributes(šķirklis.VajadzīgāsĪpašības());				
				if (minētais.wordformsCount()==1) {
					Valērijvārdi_neatpazīti_uzminēti++;
					analizators.createLexeme(šķirklis.vārds, Integer.parseInt(minētais.wordforms.get(0).getValue("Galotnes nr")), "Valērija fails");
				} else {
					//minētais.Aprakstīt(izeja);
					izeja.println(šķirklis.vārds);
				}
				analizators.enableGuessing = false; //analizators.meklētpriedēkļus = false;
			} else if (vārds.wordformsCount()==1) {				
				Valērijvārdi_sakrīt_labi++;
			} else if (vārds.wordformsCount()>1) {
				Valērijvārdi_hvz++;  
				// parasti ir -šana, kas ir gan kā divdabjforma, gan kā substantivizējies lietvārds
				//izeja.println(šķirklis.vārds);
				//vārds.Aprakstīt(izeja);
			}
			
			//if (Valērijvārdi_kopā==100) break;
			if (Valērijvārdi_kopā % 1000 == 0) {
				izeja.println(Valērijvārdi_kopā);
				izeja.flush();
			}
		}
		
		izeja.printf("No %d vārdiem %d sakrīt; %d neatpazīti (un %d no tiem pielikti leksikonam); bet %d nevar saprast.\n",
					Valērijvārdi_kopā,Valērijvārdi_sakrīt_labi,Valērijvārdi_neatpazīti,Valērijvārdi_neatpazīti_uzminēti,Valērijvārdi_hvz);
		izeja.flush();
		
		analizators.toXML("Leksikons2.xml");
	}

}
