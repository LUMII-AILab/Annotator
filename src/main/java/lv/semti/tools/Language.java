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

public class Language {

	private static String latvianCharString = "AĀBCČDEĒFGĢHIĪJKĶLĻMNŅOPRSŠTUŪVZŽaābcčdeēfgģhiījkķlļmnņoprsštuūvzž";
	private static boolean[] latvianChars = new boolean[256*256];
	
	static {
		for (int i = 0; i < latvianCharString.length(); i++)
			latvianChars[latvianCharString.charAt(i)] = true;
	}
	
	public static boolean isLatvianChar(char c) {
		return latvianChars[c];
	}

	public static boolean isLatvianString(String s) {
		for (int i = 0; i < s.length(); i++) {
			if (!latvianChars[s.charAt(i)])
				return false;
		}
		return true;
	}
	
	public static String getLatvianLowerCharString() {
		return latvianCharString.substring(33);
	}
	
	public static boolean isInteger(String s) {
		for (int i = 0; i < s.length(); i++) {
			char c = s.charAt(i);
			if (c < '0' || c > '9')
				return false;
		}
		return true;
	}
	
}
