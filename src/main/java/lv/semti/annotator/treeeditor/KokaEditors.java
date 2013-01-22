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

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JPanel;

import lv.semti.annotator.syntax.Chunk;

@SuppressWarnings("serial")
public class KokaEditors extends JPanel implements ActionListener {
	KokaModelis model = null;
	Chunk čunks = null;
	private int currentWidth = 0;
	private int currentHeight = 0;
	
	public KokaEditors() {
		this.setLayout(null);
	}
	
	public void setČunks(Chunk čunks) {
		if (this.čunks != null) this.čunks.removeListener(this);
		this.čunks = čunks;
		if (this.čunks != null) this.čunks.addListener(this);
		apdeitotVariantu();
	}
	
	private void apdeitotVariantu() {
		if (čunks == null) {
			this.removeAll();
			return;
		}		
		model = new KokaModelis(čunks.currentVariant, this);		
		saliktPozīcijas();		
	}

	public void saliktPozīcijas() {
		if (čunks == null) return;
		
		model.saliktPozīcijas();
		currentWidth = this.getWidth();
		currentHeight = this.getHeight();
		
	    if (model != null)
		    for (WordBox klucis : model.vārduInfo.values()) klucis.revalidate();

		repaint();
	}
	
	public void paint (Graphics g) {
		if (currentHeight != this.getHeight() || currentWidth != this.getWidth())
			saliktPozīcijas();
		
	    Graphics2D g2 = (Graphics2D) g;
	    g2.setColor(Color.white);
	    g2.fillRect(0, 0, this.getWidth(), this.getHeight());

	    if (model != null)
		    for (Linija līnija : model.līnijas) {
		    	g2.setColor(līnija.getColor());
		    	g2.setStroke(līnija.getStroke());
		    	g2.draw(līnija.līnija());
		    }
	    
	    paintChildren(g2);	    	   
	}

	public void actionPerformed(ActionEvent e) {
		apdeitotVariantu();
	}
}
