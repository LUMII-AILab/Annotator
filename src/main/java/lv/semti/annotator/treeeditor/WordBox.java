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

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.Font;
import java.util.Map.Entry;

import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.SwingConstants;

import lv.semti.morphology.analyzer.Word;
import lv.semti.morphology.analyzer.Wordform;
import lv.semti.morphology.attributes.AttributeNames;

@SuppressWarnings("serial")
public class WordBox extends Klucis {
	private static int defaultHeight = 72;	
	private JLabel lblLoma = null;
	private JLabel lblVārds = null;
	private JPanel augšasPanelis = null;
	
	public void setLoma(String loma) {
		if (lblLoma == null) {
			lblLoma = new JLabel();
			Font fontV = new Font("Dialog", Font.ITALIC, 10);
			lblLoma.setFont(fontV);
			lblLoma.setHorizontalAlignment(SwingConstants.CENTER);
			
			augšasPanelis.add(lblLoma, BorderLayout.CENTER);			
		}
		
		lblLoma.setText(loma);
		
		if (lblLoma.getPreferredSize().width + 10 > this.getPreferredSize().width) {
			this.setPreferredSize(new Dimension (lblLoma.getPreferredSize().width + 10, defaultHeight));
		}
	}
	
	WordBox (Word vārds) {
		word = vārds;
		this.setLayout(new BorderLayout(5,0));
		if (vārds.hasAttribute("X-vārds", "Jā")) 
			this.setBorder(BorderFactory.createLineBorder(Color.BLUE, 2));
		else
			this.setBorder(BorderFactory.createLineBorder(Color.BLACK, 2));
		this.setBackground(Color.WHITE);
		
		lblVārds = new JLabel(vārds.getToken());
		lblVārds.setBorder(BorderFactory.createEmptyBorder(5, 5, 5, 5));
		Font fontV = new Font("Dialog", Font.BOLD, 16);
		lblVārds.setFont(fontV);
		lblVārds.setHorizontalAlignment(SwingConstants.CENTER);
		this.add(lblVārds, BorderLayout.CENTER);

		augšasPanelis = new JPanel();
		augšasPanelis.setLayout(new BorderLayout(5,0));
		augšasPanelis.setOpaque(false);
		this.add(augšasPanelis, BorderLayout.NORTH);
				
		Wordform pareizāVārdforma = vārds.getCorrectWordform();
		if (pareizāVārdforma != null) {
			JLabel lblMarķējums = new JLabel(pareizāVārdforma.getTag());
			lblMarķējums.setHorizontalAlignment(SwingConstants.CENTER);
			this.add(lblMarķējums, BorderLayout.SOUTH);
			lblMarķējums.setBorder(BorderFactory.createEmptyBorder(0, 5, 2, 5));
			
			JLabel lblVārdšķira = new JLabel(pareizāVārdforma.getValue(AttributeNames.i_PartOfSpeech));
			lblVārdšķira.setHorizontalAlignment(SwingConstants.CENTER);
			lblVārdšķira.setBorder(BorderFactory.createEmptyBorder(2, 5, 0, 5));
			augšasPanelis.add(lblVārdšķira, BorderLayout.NORTH);

			String īpašības = "";
			for (Entry<String, String> pāris : pareizāVārdforma.entrySet())
				īpašības = īpašības + pāris.getKey() + " = " + pāris.getValue()
						+ "\n";
			īpašības = "<html>"+īpašības.replaceAll("\n", "<br>")+"</html>";
			this.setToolTipText(īpašības);
		} else this.setToolTipText(word.getToken());				
				
		this.setPreferredSize(new Dimension (Math.max(this.getPreferredSize().width, 50), defaultHeight));
	}	
}
