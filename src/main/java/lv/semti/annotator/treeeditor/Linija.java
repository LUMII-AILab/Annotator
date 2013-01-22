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

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.geom.Line2D;

public class Linija {
	Klucis no;
	Klucis uz;
	Color krāsa;
	
	Linija(Klucis no, Klucis uz) {
		this.no = no;
		this.uz = uz;		
	}
	
	Line2D līnija() {
		return new Line2D.Double(
				no.x_pos + no.getPreferredSize().getWidth()/2,
				no.y_pos + no.getPreferredSize().getHeight()/2,
				uz.x_pos + uz.getPreferredSize().getWidth()/2,
				uz.y_pos + uz.getPreferredSize().getHeight()/2
		);
	}

	public BasicStroke getStroke() {
		BasicStroke stroke = new BasicStroke(2.0f);
		return stroke;
	}

	public Color getColor() {
		if (uz.getClass().toString().contains("Rimbulis") && uz.word == no.word) return Color.GRAY;
		if (uz.word.hasAttribute("X-vārds", "Jā")) return Color.BLUE;
		return Color.GREEN;
	}
	
	public String getToolTipText() {
		return "tests";
	}
}
