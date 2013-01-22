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
package lv.semti.annotator.treeeditor;

import java.awt.Dimension;

import javax.swing.JDialog;

import lv.semti.annotator.syntax.*;

@SuppressWarnings("serial")
public class KokaFrame extends JDialog {
	
	public KokaFrame(Chunk čunks) {
		this.setPreferredSize(new Dimension(800, 600));		
		
		KokaEditorsArPogam editors = new KokaEditorsArPogam(čunks); 
		this.add(editors);
		
		this.pack();

	}
	
}
