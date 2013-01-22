package lv.semti.annotator;
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


import java.awt.Dimension;
import java.awt.Toolkit;

import javax.swing.UIManager;

/**
 * Entry point for the Annotator application GUI.
 */
public class AnnotatorApplication {
	  boolean packFrame = false;

	  public AnnotatorApplication() {
		MainFrame frame; 
		try {
			frame = new MainFrame();
		} catch(Exception e) {
			e.printStackTrace();
			System.exit(1);
			return;
		}

	    if (packFrame) {
	      frame.pack();
	    }
	    else {
	      frame.validate();
	    }
	    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
	    Dimension frameSize = frame.getSize();
	    if (frameSize.height > screenSize.height) {
	      frameSize.height = screenSize.height;
	    }
	    if (frameSize.width > screenSize.width) {
	      frameSize.width = screenSize.width;
	    }
	    frame.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);
	    frame.setVisible(true);
	  }
	  
	  public static void main(String[] args) {
	    try {
	      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
	    }
	    catch(Exception e) {
	      e.printStackTrace();
	    }
	    new AnnotatorApplication();
	  }
	}