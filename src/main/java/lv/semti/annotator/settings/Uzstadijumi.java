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
package lv.semti.annotator.settings;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.Map.Entry;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import lv.semti.morphology.analyzer.Analyzer;
import lv.semti.morphology.attributes.*;

public class Uzstadijumi extends AttributeValues {
	
	public static String DEFAULT_SETTINGS_FILE = "Settings.xml";

	private static Uzstadijumi ref; //Singletona reference
	
	public String getDarbaCeļš() {
		return this.parametraVērtība("darbaCeļš");
	}

	public void setDarbaCeļš(String darbaCeļš) {
		this.pieliktParametru("darbaCeļš", darbaCeļš);
	}

	private Uzstadijumi (String failaVārds){
		Document doc = null;
		try {
			DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			doc = docBuilder.parse(new File(failaVārds));
			Node node = doc.getDocumentElement(); 
			if (node.getNodeName().equals("Uzstādījumi")) {
				for (int j = 0; j < doc.getFirstChild().getAttributes().getLength(); j++) {
					Node n = doc.getFirstChild().getAttributes().item(j);
					addAttribute(n.getNodeName().replaceAll("_", " "), n.getTextContent());			
				}
			}
			else {
				throw new RuntimeException("There is node '" + node.getNodeName() + "' in " + DEFAULT_SETTINGS_FILE + " but 'Uzstādījumi' was expected!");
			}
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		}
	}
	
	public static synchronized Uzstadijumi getUzstadijumi(){
		if (ref == null) { // ja nav, tad ielasam no faila
			ref = new Uzstadijumi(DEFAULT_SETTINGS_FILE);
		}
		return ref;
	}
	
	public void saglabāt () throws IOException {
		String filename = DEFAULT_SETTINGS_FILE;
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filename), "UTF-8"));
		out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		out.write("<Uzstādījumi");
		for (Entry<String,String> pāris : attributes.entrySet()) {
			String īpašība = pāris.getKey().replace(" ", "_").replace("\"", "&quot;");
			String vērtība = pāris.getValue().replace("\"", "&quot;");
			out.write(" "+īpašība+"=\""+vērtība+"\"");
		} 
		out.write("/>");
		out.close();					  
	}

	public String getLeksikonaCeļš() {
		return this.parametraVērtība("leksikonaCeļš");
	}

	public void setLeksikonaCeļš(String leksikonaCeļš) {
		this.pieliktParametru("leksikonaCeļš", leksikonaCeļš);
	}

	public String getDarbaFails() {
		return this.parametraVērtība("darbaFails");
	}

	public void setDarbaFails(String darbaFails) {
		this.pieliktParametru("darbaFails", darbaFails);
	}
	
	public void pieliktParametru(String parametrs, String vērtība) {
		//FIXME - vajag nodalīt īpašību pielikšanu no īpašību aizvietošanas
		this.addAttribute(parametrs, vērtība);
	}
	
	public String parametraVērtība(String parametrs) {
		return this.getValue(parametrs);
	}

	public void uzliktLocītājam(Analyzer locītājs) {
		locītājs.guessVerbs = Boolean.parseBoolean(parametraVērtība("Minēt darbības vārdus"));
		locītājs.guessParticibles = Boolean.parseBoolean(parametraVērtība("Minēt divdabjus"));
		locītājs.guessNouns = Boolean.parseBoolean(parametraVērtība("Minēt lietvārdus"));
		locītājs.guessAdjectives = Boolean.parseBoolean(parametraVērtība("Minēt īpašības vārdus"));
		locītājs.enableGuessing = Boolean.parseBoolean(parametraVērtība("Minēt vārdus pēc galotnes"));
		locītājs.enableVocative = Boolean.parseBoolean(parametraVērtība("Atļaut vokatīvu") );
		
		//FIXME - locītājam ir vēl daudz īpašības
	}

	@Override
	public Object clone() throws CloneNotSupportedException {		
		throw new CloneNotSupportedException(); 
	}

	public boolean rādītKastītesPirms() {
		return ("rādīt pirms".equalsIgnoreCase(this.parametraVērtība("Rādīt kastes")));
	}

	public int getMaxChunkLength() {
		try {
			if (Integer.parseInt(this.parametraVērtība("maxChunkLength")) > 0) {
				return Integer.parseInt(this.parametraVērtība("maxChunkLength"));			
			}
		} catch (NumberFormatException e) {
			return 8;
		}
		return 8;
	}

	public void setMaxChunkLength(String max_chunk_length) {
		this.pieliktParametru("maxChunkLength", max_chunk_length);
	}

	public int getParseTimeLimit() {
		try {
			if (Integer.parseInt(this.parametraVērtība("parseTimeLimit")) > 0) {
				return Integer.parseInt(this.parametraVērtība("parseTimeLimit"));
			}
		} catch (NumberFormatException e) {
			return 20;
		}
		return 20;
	}

	public void setParseTimeLimit(String parse_time_limit) {
		this.pieliktParametru("parseTimeLimit", parse_time_limit);
	}
}
