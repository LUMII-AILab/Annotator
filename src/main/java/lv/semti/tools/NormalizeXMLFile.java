/*******************************************************************************
 * Copyright 2008, 2009 Institute of Mathematics and Computer Science, University of Latvia; 
 * Author: Ilmārs Poikāns
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
package lv.semti.tools;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

public class NormalizeXMLFile {

	public final static byte[] BOM_UTF8 = new byte[] { (byte)0xEF, (byte)0xBB, (byte)0xBF };
	
	public static void main(String[] args) throws Exception {

		if (args.length < 2) {
			System.err.println("Usage: NormalizeXMLFile <filein> <fileout>");
			System.exit(1);
		}
		
		File filein = new File(args[0]);
		File fileout = new File(args[1]);
		
		BufferedOutputStream outs = new BufferedOutputStream(new FileOutputStream(fileout), 64*1024);
		// outs.write(BOM_UTF8);
		PrintWriter out = new PrintWriter(new OutputStreamWriter(outs, "utf-8"));
		out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
		
		SAXParser parser = SAXParserFactory.newInstance().newSAXParser();
		Handler handler = new Handler(out);
		
		parser.parse(filein, handler);

		out.close();
	}

	private static class Handler extends DefaultHandler {
		
		private PrintWriter out;
		private StringBuffer indent = new StringBuffer();
		private boolean[] childElement = new boolean[128];
		private int level = 0;
		
		public Handler(PrintWriter out) {
			this.out = out;
		}

		@Override
		public void startElement(String uri, String localName, String qName, Attributes attributes) {
			out.println();
			out.print(indent + "<" + qName);
			for (int i = 0; i < attributes.getLength(); i++)
				out.print(" " + attributes.getQName(i) + "=\"" + escape(attributes.getValue(i)) + "\"");
			out.print(">");
			level++;
			childElement[level-1] = true;
			childElement[level] = false;
//			System.out.println(level + ": startElement " + charsInside[level]);
			indent.append(' ');
		}
		
		@Override
		public void endElement(String uri, String localName, String qName) {
			indent.setLength(indent.length() - 1);
			if (childElement[level]) {
				out.println();
				out.print(indent);
			}
//			System.out.println(level + ": endElement " + charsInside[level+1]);
			level--;
			out.print("</" + qName + ">");
			out.flush();
		}
		
		@Override
		public void characters(char[] ch, int start, int length) {
			String val = new String(ch, start, length).trim();
			out.print(escape(val));
//			System.out.println(level + ": Chars " + charsInside[level]);
		}
		
		@Override
		public void endDocument() {
			//stub
		}
		
		private static String escape(String val) {
			return val.replaceAll("&", "&amp;").replaceAll("<", "&lt;").
				       replaceAll(">", "&gt;").replaceAll("\"", "&quot;");
		}
	}
}

