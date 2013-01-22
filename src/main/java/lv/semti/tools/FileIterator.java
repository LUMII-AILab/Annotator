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

import java.io.File;

public class FileIterator {

	File root;
	String rootStr; 
	
	public FileIterator(File root) {
		this.root = root;
		this.rootStr = root.getAbsolutePath() + (root.isDirectory() ? File.pathSeparator : "");
	}
	
	private void iterate (File dir, FileIteratorListener listener) {
		File[] files = dir.listFiles();
		for (int i = 0; i < files.length; i++) {
			if (files[i].isDirectory())
				iterate(files[i], listener);
			else if (files[i].isFile())
				listener.process(files[i], files[i].getAbsolutePath().substring(rootStr.length()));
			else
				System.out.println("Ignoring '" + files[i].getAbsolutePath() + "'");
		}
	}
	
	public void iterate (FileIteratorListener listener) {
		
		listener.fileIterationStarted();
		
		if (root.isDirectory())
			iterate(root, listener);
		else
			listener.process(root, root.getAbsolutePath().substring(rootStr.length()));
		
		listener.fileIterationCompleted();
	}
}
