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

public class Convert {

	public static void main(String[] args) throws IOException {

		if (args.length < 3) {
			System.out.println("Usage: Convert <file> <src charset> <dst charset>");
			System.exit(1);
		}
		
		String srcFilename = args[0];
		File srcFile = new File(srcFilename);
		
		if (!srcFile.exists()) {
			System.out.println("File '" + args[0] + "' doesn't exist");
			System.exit(1);
		}

		String srcCharset = args[1];
		String dstCharset = args[2];
		String dstFilename = srcFilename + "." + dstCharset;
		File dstFile = new File(dstFilename);
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(srcFile), srcCharset), 64*1024);
		PrintWriter out = new PrintWriter(new OutputStreamWriter(new BufferedOutputStream(new FileOutputStream(dstFile), 64*1024), dstCharset));
		String line = null;
		while ((line = in.readLine()) != null)
			out.println(line);
		in.close();
		out.close();
	}
}
