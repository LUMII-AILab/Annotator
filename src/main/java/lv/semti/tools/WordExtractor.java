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
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.Set;
import java.util.StringTokenizer;
import java.util.TreeSet;

public class WordExtractor implements FileIteratorListener {

	private char firstChar;
	
//	private Set<String> words = new HashSet<String>();
	private Set<String> words = new TreeSet<String>();

	private int filesProcessed;
	private long tokensProcessed;
	private long wordsProcessed;

	public WordExtractor() {
		this((char)0);
	}

	public WordExtractor(char firstChar) {
		this.firstChar = firstChar;
	}
	

	public static void main(String[] args) {
		if (args.length < 1) {
			System.out.println("Usage: WordExtractor <file or root dir>");
			System.exit(1);
		}
		
		File rootDir = new File(args[0]);
		
		if (!rootDir.exists()) {
			System.out.println("File or folder '" + args[0] + "' doesn't exist");
			System.exit(1);
		}

		new FileIterator(rootDir).iterate(new WordExtractor());
		
//		String firstChars = Language.getLatvianLowerCharString();
//		
//		for (int i = 0; i < firstChars.length(); i++) {
//			char firstChar = firstChars.charAt(i);
//			System.out.println("Processing letter " + firstChar);
//			new FileIterator(rootDir).iterate(new WordExtractor(firstChar));
//		}
	}

	public void process(File file, String relativePath) {
		
		String filename = file.getName();
		
		if (filename.equalsIgnoreCase("index") ||
				filename.equalsIgnoreCase("statistika") ||
				filename.equalsIgnoreCase("vaardi.xml"))
			return;
		
		// System.out.println("Processing file " + filename);
		
		try
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "Cp1257"), 64*1024);
			String line = null;
			while ((line = in.readLine()) != null)
				processLine(line);
			in.close();
		}
		catch (IOException e) {
			throw new RuntimeException("IOException while processing file '" + file + "'", e);
		}

		filesProcessed++;
		
		if (filesProcessed % 100 == 0)
			System.out.print(".");
		
		if (filesProcessed % 5000 == 0) {
			System.gc();
			long memoryUsed = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
			System.out.println("\n\tFiles: " + filesProcessed + ", Tokens: " + tokensProcessed + ", Words: " + wordsProcessed + ", Unique: " + words.size() + ", Memory: " + memoryUsed);
			System.out.println("\tCWD: " + file.getParent());
		}
	}

	private void processLine(String line) {
		StringTokenizer st = new StringTokenizer(line, " \t\"-:;,!?.()={}[]<>/#&%$*~«»");
		while (st.hasMoreTokens()) {
			String token = st.nextToken();
			tokensProcessed++;
			String word = filterWord(token);
			if (word != null) {
				wordsProcessed++;
				words.add(word);
			}
		}
	}

	private String filterWord(String token) {
		if (token.length() < 2 || token.length() > 18)
			return null;
		String word = token.toLowerCase();
		if (firstChar != 0 && token.charAt(0) != firstChar) {
			return null;
		}
		if (!Language.isLatvianString(word)) {
//			if (!Language.isInteger(word))
//				System.out.println("Ignoring " + token);
			return null;
		}
		return new String(word);
	}

	public void fileIterationCompleted() {
		System.out.println("============");
		System.out.println("\tFiles: " + filesProcessed + ", Tokens: " + tokensProcessed + ", Words: " + wordsProcessed + ", Unique: " + words.size());
		
		try {
			String filename = "words" + (firstChar != 0 ? Integer.toHexString(firstChar) : "") + ".txt";
			PrintWriter out = new PrintWriter(new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(filename), 64*1024), "utf-8"));
			Iterator<String> i = words.iterator();
			while (i.hasNext())
				out.println(i.next());
			out.close();
		} catch (IOException e) {
			throw new RuntimeException("IOException while writing word file", e);
		}

		words.clear();
	}

	public void fileIterationStarted() {
		//stub
	}

}
