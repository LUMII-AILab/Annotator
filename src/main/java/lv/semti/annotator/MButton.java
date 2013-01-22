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
package lv.semti.annotator;

import java.awt.event.ActionEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;

import javax.swing.JButton;

@SuppressWarnings("serial")
public class MButton extends JButton {
	//FIXME - nestrādā. neapdeitojas, ja pogu nospiež;  un nenoķer kliku, ja pele pakustas par kādu pikseli
	
	MainFrame parent; 
	int npk = -1;
	private boolean irPareizs = false;
	
	public MButton(MainFrame p, int i) {
		parent = p;
		npk = i;
		this.setText("+");
		
		this.addMouseListener(new MouseListener() {
			//@Override
			public void mouseReleased(MouseEvent arg0) {
				// Tīšām neko nedaram
			}

			//@Override
			public void mouseClicked(MouseEvent e) {
				parent.pieliktMarķējumuTabulā(npk);
				repaint();
			}

			//@Override
			public void mouseEntered(MouseEvent e) {
				// Tīšām neko nedaram
			}

			//@Override
			public void mouseExited(MouseEvent e) {
				// Tīšām neko nedaram
			}

			//@Override
			public void mousePressed(MouseEvent e) {
				// Tīšām neko nedaram
			}
		});
		
	}
	
	public boolean getIrPareizs() {
		return irPareizs;
	}
	
	public int getNpk() {
		return npk;
	}
	
	public void actionPerformed(ActionEvent arg0) {
		parent.pieliktMarķējumuTabulā(npk);
	}
}
