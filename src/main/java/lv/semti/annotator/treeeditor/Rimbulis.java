package lv.semti.annotator.treeeditor;
/*******************************************************************************
 * Copyright 2008, 2009 Institute of Mathematics and Computer Science, University of Latvia; 
 * Author: Pēteris Paikens, Imants Borodkins
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

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.geom.Ellipse2D;

import javax.swing.BorderFactory;

import lv.semti.morphology.analyzer.Word;

@SuppressWarnings("serial")
public class Rimbulis extends Klucis {
	private static int defaultSize = 60;
	
	Rimbulis (Word vārds) {
		this.word = vārds;
		this.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		this.setPreferredSize(new Dimension (defaultSize, defaultSize));
	}	
	
	public void paint (Graphics g) {
	    Graphics2D g2 = (Graphics2D) g;
	    //Ellipse2D e = new Ellipse2D.Double(10, 10, defaultSize-20, defaultSize-20);
	    //g2.draw(new Ellipse2D.Double(10, 10, defaultSize-20, defaultSize-20));
		 g2.setPaint(Color.DARK_GRAY);
		 g2.fill (new Ellipse2D.Double(17, 17, defaultSize-30, defaultSize-30));
		 g2.setPaint(Color.GREEN);
		 g2.fill (new Ellipse2D.Double(15, 15, defaultSize-30, defaultSize-30));

	}


}
