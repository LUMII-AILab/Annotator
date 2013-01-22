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

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class SentenceExtractor implements FileIteratorListener {

	int files;
	
	public static void main(String[] args) {
		if (args.length < 1) {
			System.out.println("Usage: SentenceExtractor <file or root dir>");
			System.exit(1);
		}
		
		File rootDir = new File(args[0]);
		
		if (!rootDir.exists()) {
			System.out.println("File or folder '" + args[0] + "' doesn't exist");
			System.exit(1);
		}
		
		System.out.println("āčņūīē");
		
		new FileIterator(rootDir).iterate(new SentenceExtractor());
	}

	public void process(File file, String relativePath) {
		if (files % 100 == 0)
			System.out.println(relativePath + " (" + file.length() + ") - " + file);
		files++;
		
		try
		{
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file), "Cp1257"), 64*1024);
			PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream("out.txt"), "utf-8"));
			String line = null;
			while ((line = in.readLine()) != null)
				out.println(line);
			in.close();
			out.close();
		}
		catch (IOException e) {
			throw new RuntimeException("IOException while processing file '" + file + "'", e);
		}
	}

	public void fileIterationCompleted() {
		System.out.println("There were " + files + " files.");
	}

	public void fileIterationStarted() {
		// TODO Auto-generated method stub
		
	}

}
