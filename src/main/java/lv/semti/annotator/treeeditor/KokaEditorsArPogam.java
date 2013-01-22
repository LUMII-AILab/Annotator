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

import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;

import lv.semti.annotator.syntax.Chunk;

@SuppressWarnings("serial")
public class KokaEditorsArPogam extends JPanel {
	JLabel čunkaVariantaNr = new JLabel("   ");
	Chunk čunks = null;
	KokaEditors kokaEditors = null;
	JButton iepriekšējaisČunks = null;
	JButton nākamaisČunks = null;
	
	public KokaEditorsArPogam(final Chunk čunks2) {
		JPanel pogas = new JPanel();
		iepriekšējaisČunks = new JButton("<-");
		iepriekšējaisČunks.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (čunks == null) return;
				čunks.previousVariant();
				atjaunotVariantu();
			}			
		});  
		pogas.add(iepriekšējaisČunks);
		
		pogas.add(čunkaVariantaNr);
		
		nākamaisČunks = new JButton("->");
		nākamaisČunks.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if (čunks == null) return;
				čunks.nextVariant();
				atjaunotVariantu();
			}			
		});  
		pogas.add(nākamaisČunks);
		
		this.čunks = čunks2;
		this.setLayout(new BorderLayout());
		this.add(pogas, BorderLayout.NORTH);
		kokaEditors = new KokaEditors();
		kokaEditors.setČunks(čunks);
		this.add(new JScrollPane(kokaEditors), BorderLayout.CENTER);
		
		atjaunotVariantu();
	}
	
	void atjaunotVariantu()  {		
		kokaEditors.actionPerformed(null);
		if (čunks != null && čunks.currentVariant != null) {
			čunkaVariantaNr.setText(čunks.getVariantNo());
		} else {
			čunkaVariantaNr.setText("   ");			
		}
		iepriekšējaisČunks.setEnabled(čunks != null);
		nākamaisČunks.setEnabled(čunks != null);
	}
	
	public void setČunks(Chunk čunks) {
		this.čunks = čunks;
		kokaEditors.setČunks(čunks);
		atjaunotVariantu();
	}

}
