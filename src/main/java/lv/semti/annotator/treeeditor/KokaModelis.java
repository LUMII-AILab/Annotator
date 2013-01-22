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
import java.util.HashMap;
import java.util.LinkedList;

import javax.swing.JPanel;

import lv.semti.annotator.syntax.*;
import lv.semti.morphology.analyzer.*;

public class KokaModelis {
	LinkedList<Klucis> kastes = new LinkedList<Klucis>();
	LinkedList<Linija> līnijas = new LinkedList<Linija>();
	HashMap<Word,WordBox> vārduInfo = new HashMap<Word,WordBox>();
	HashMap<Word,Klucis> vārduKluči = new HashMap<Word,Klucis>();  // ja vārdam ir rimbulis, tad nevis wordbox bet tas rimbulis
	
	JPanel panelis;

	public KokaModelis(ChunkVariant čunkaVariants, JPanel panelis) {
		this.panelis = panelis;
		this.setČunkaVariants(čunkaVariants);
	}	
	
	private void uzliktStāvu (ChunkVariant saturs, Klucis klucis, int stāvs) {
		if (klucis.stāvs < stāvs) klucis.stāvs = stāvs;
		
		Word paskaidro = saturs.getDependencyHead(klucis.word);
		if (paskaidro == null) return;
		if (paskaidro.hasAttribute("X-vārds", "Jā")) 
			vārduKluči.get(paskaidro).esmuVirs.add(klucis);
		
		uzliktStāvu(saturs, vārduKluči.get(paskaidro), stāvs+1);
	}
	
	private void setČunkaVariants(ChunkVariant saturs) {
		panelis.removeAll();
		kastes.clear();
		līnijas.clear();
		vārduInfo.clear();
		vārduKluči.clear();
		
		if (saturs != null) { 		
			for (Word vārds : saturs.getTokens()) {
				WordBox vārdaKaste = new WordBox(vārds);
				kastes.add(vārdaKaste);
				vārduKluči.put(vārds, vārdaKaste);
				vārduInfo.put(vārds, vārdaKaste);
			}
					
			for (Word vārds : saturs.getTokens()) 
				if (!vārds.hasAttribute("X-vārds", "Jā")) 
					uzliktStāvu(saturs, vārduInfo.get(vārds), 0);
					
			for (Word vārds : saturs.getTokens())
				if (!vārds.hasAttribute("X-vārds", "Jā")) {
					Klucis klucis = vārduKluči.get(vārds);
					if (klucis.stāvs > 0) {
						Rimbulis rimbulis = new Rimbulis(vārds);
						rimbulis.stāvs = klucis.stāvs;
						rimbulis.esmuVirs.add(klucis);
						klucis.stāvs = 0;
						kastes.add(rimbulis);						
						vārduKluči.put(vārds, rimbulis);
						līnijas.add(new Linija(klucis, rimbulis));
					}
				} 
							
			for (Word vārds : saturs.getTokens()) {
				Word paskaidro = saturs.getDependencyHead(vārds);
				if (paskaidro != null) {
					līnijas.add(new Linija(vārduKluči.get(vārds), vārduKluči.get(paskaidro)));					
					vārduInfo.get(vārds).setLoma(saturs.getDependencyRole(vārds));
				}
			}
		}
		
		for (Klucis kaste : kastes)	panelis.add(kaste); 
	}

	public void saliktPozīcijas() {
		int defaultatstarpe = 10;
		int defaultaugstums = 60;
		int maluAttālums = 40;
		
		//sarēķinam stāvu skaitu
		int maxStāvs = 0;
		for (Klucis kaste : kastes) 
			if (kaste.stāvs > maxStāvs) maxStāvs = kaste.stāvs;
		
		//sarēķinam horizontālo atstarpi nulltajam stāvam
		int kopējaisPlatums = 0;
		int vārduSkaits = 0;
		for (Klucis kaste : kastes)
			if (kaste.stāvs == 0) {
				kopējaisPlatums += kaste.getPreferredSize().width;
				vārduSkaits++;
			}

		int x_atstarpe = defaultatstarpe;
		if (vārduSkaits>1)
			x_atstarpe = (panelis.getWidth()-kopējaisPlatums - 2 * maluAttālums) / (vārduSkaits-1);
		if (x_atstarpe < defaultatstarpe) x_atstarpe = defaultatstarpe;
		
		int y_pos = panelis.getHeight() - maluAttālums; // apakšējā mala šobrīd liekamajam stāvam
		int y_atstarpe = defaultatstarpe;
		if (maxStāvs>0)
			y_atstarpe = (panelis.getHeight() - 2* maluAttālums  - defaultaugstums*(maxStāvs+1)) / maxStāvs;
		
		if (y_atstarpe < defaultatstarpe) {
			y_atstarpe = defaultatstarpe;
			y_pos = (defaultaugstums + y_atstarpe) * maxStāvs + maluAttālums + defaultaugstums;
		}

		int min_panel_width = kopējaisPlatums + 2 * maluAttālums + defaultatstarpe * (vārduSkaits-1);
		int min_panel_height = defaultaugstums*(maxStāvs+1) + defaultatstarpe * maxStāvs + 2 * maluAttālums;
		panelis.setPreferredSize(new Dimension(min_panel_width, min_panel_height));
		

		for (int stāvs=0; stāvs<=maxStāvs; stāvs++) {
			int x_pos = maluAttālums; //kreisā mala šobrīd liekamajam vārdam
			int maxHeight = 0;
			
			for (Klucis kaste : kastes) 
				if (kaste.stāvs == stāvs) {
					int augstums = kaste.getPreferredSize().height;
					int platums = kaste.getPreferredSize().width;
					
					if (kaste.esmuVirs.size() > 0) {
						int minX=9999999; int maxX = 0;
						for (Klucis apakšējais : kaste.esmuVirs) {
							if (minX > apakšējais.x_pos) minX = apakšējais.x_pos;
							if (maxX < apakšējais.x_pos+apakšējais.getPreferredSize().getWidth()) maxX = Long.valueOf(Math.round(apakšējais.x_pos+apakšējais.getPreferredSize().getWidth())).intValue();
						}
						x_pos = minX + (maxX - minX - platums)/2;							
					}
				
					kaste.setBounds(x_pos, y_pos-augstums, platums, augstums);
					kaste.repaint();
					kaste.x_pos = x_pos;
					kaste.y_pos = y_pos - augstums;
					if (augstums > maxHeight) maxHeight = augstums;
					x_pos = x_pos + platums + x_atstarpe;
				}
			y_pos -= maxHeight + y_atstarpe;
		}
	}

}
