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
import java.io.*;
import java.util.*;

import org.xml.sax.XMLReader;
import org.xml.sax.Attributes;
import org.xml.sax.InputSource;
import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.XMLReaderFactory;

public class Dictionary {
	ArrayList<Entry> entries;
	
	public enum WhereAreWe {
//		NEKAS, ŠĶIRKLIS, NOZĪME, PIEMĒRS, FRĀZE//, VĀRDS, DEFINĪCIJA
		NO, ENTRY, WORD_SENSE, EXAMPLE, PHRASE//, VĀRDS, DEFINĪCIJA
	}
	
	class LLVVReader extends DefaultHandler {
//		Ielasa Latviešu Literārās Valodas Vārdnīcas XML formātu
				
		Entry currentEntry; // pagaidu mainīgais, kurā tiek savākti dati 
		WhereAreWe kurEsam; // vai šobrīd tiek lasīti šķirkļa dati, vai arī esam kur citur
		
		String xmlElement="";  // XML elementa nosaukums, kuru šobrīd lasa, lai ieliktu laukā
		String xmlValue=""; // pagaidām nolasītā vērtība - XML'a teksta daļa.
		String text=""; //'t' lauks XML'ā
		
		@Override
		public void startDocument() {
			kurEsam = WhereAreWe.NO;
			entries = new ArrayList<Entry>();			
	    }

	    @Override
		public void startElement (String uri, String name,
				      String qName, Attributes atts) {
	    	
	    	switch (kurEsam) {
	    	case ENTRY:
	    		if (name.equals("n")) { // sākas nozīme  
	    			kurEsam = WhereAreWe.WORD_SENSE;	    			  
	    		} else if (name.equals("fraz")) { // sākas frāze  
	    			kurEsam = WhereAreWe.PHRASE;	    			  
	    		} else xmlValue = "";
	    	  //else System.out.println("Sākas nesaprotams elements "+name);
		    	break;
	    	case NO:
	    		if (name.equals("s")) {
	    			currentEntry = new Entry();
	    			kurEsam = WhereAreWe.ENTRY;
	    			xmlElement = "";
	    		}
	    		break;
	    	case WORD_SENSE:
	    	    if (name.equals("d")) { // sākas definīcija  
	    			text = "";	    			  
	    		} else if (name.equals("piem")) { // sākas piemērs  
	    			kurEsam = WhereAreWe.EXAMPLE;	    			  
	    		} else xmlValue = "";	    		
	    		break;
	    	case EXAMPLE:
	    		break;
	    	case PHRASE:
	    		break;
	    	default: System.out.println("Sākas nesaprotams elements "+name); 
	    	}
	    }

	    @Override
		public void endElement (String uri, String name, String qName) {
	      try {	
		    switch (kurEsam) {
		    case ENTRY:
	    		if (name.equals("s")) {
	    			entries.add(currentEntry);
	    			currentEntry = null;
	    			kurEsam = WhereAreWe.NO;	    			
	    		} else if (name.equals("vf")) {
	    			currentEntry.wordform = xmlValue;
	    			xmlValue = "";
	    		} else if (name.equals("gram")) {
	    			currentEntry.morpho = xmlValue;
	    			xmlValue = "";
	    		} //else System.out.println("Beidzas nesaprotams elements "+name);
	    		break;
		    case WORD_SENSE:
	    		if (name.equals("n")) {
	    			kurEsam = WhereAreWe.ENTRY;
	    			xmlValue = "";
	    		} else if (name.equals("d")) {
	    			currentEntry.d.add(text);
	    			text = "";	    			
	    		} else if (name.equals("t")) {
	    			text = xmlValue;
	    			xmlValue = "";
	    		}//else System.out.println("Beidzas nesaprotams elements "+name); 
	    		break;
		    case EXAMPLE:
		    	if (name.equals("piem")) {	    			
	    			kurEsam = WhereAreWe.WORD_SENSE;	    					    		
		    	}//else System.out.println("Beidzas nesaprotams elements "+name);
		    	break;
		    case PHRASE:
		    	if (name.equals("fraz")) {	    			
	    			kurEsam = WhereAreWe.ENTRY;	    					    		
		    	}//else System.out.println("Beidzas nesaprotams elements "+name);
		    	break;
	    	default: 
	    		System.out.println("Neesam šķirklī, beidzas elements "+name); 
		    }  
	      }
	      catch (NumberFormatException e) {
			System.out.printf("Laukā %s bija vērtība %s\n",xmlElement,xmlValue);}
	    }

	    @Override
	    public void characters (char ch[], int start, int length) {
	    	for (int i = start; i < start + length; i++) {
				xmlValue += ch[i];
			}
	    }		
	}
	
	public Dictionary(String filename) throws Exception	{		
		XMLReader xr = XMLReaderFactory.createXMLReader();
		LLVVReader lasītājs = new LLVVReader();
		xr.setContentHandler(lasītājs);
				
		BufferedReader straume = 
			new BufferedReader(
					new InputStreamReader(new FileInputStream(filename), "UTF8"));		
		xr.parse(new InputSource(straume)); 
				
	}	
}
