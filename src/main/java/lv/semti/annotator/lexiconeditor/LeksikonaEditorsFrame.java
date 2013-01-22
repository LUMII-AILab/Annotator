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
package lv.semti.annotator.lexiconeditor;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.KeyStroke;
import javax.swing.ListSelectionModel;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.TableColumn;

import lv.semti.morphology.lexicon.*;
import lv.semti.morphology.lexicon.TableModels.*;

@SuppressWarnings("serial")
public class LeksikonaEditorsFrame extends JDialog {

	Lexicon lexicon;

	JLabel lblVgr = new JLabel("Vārdgrupas:"); 
	JTable vārdgrupas = null;
	VardgrupuModelis vgrMod = null;
	JScrollPane spanVgr = new JScrollPane();
	JPopupMenu menuWGroup;
	
	JLabel lblVgrĪp = new JLabel("Vārdgrupu īpašības:"); 
	IpasibuTable vgrĪpašībuTabula = null;
	AttributeModel vgrĪpMod = null;
	JScrollPane spanVgrĪp = new JScrollPane();
	JPopupMenu menuWGroupProperties;

	JLabel lblGal = new JLabel("Galotnes:"); 
	JTable galotņuTabula = null;
	EndingModel galMod = null;
	JScrollPane spanGal = new JScrollPane();
	JPopupMenu menuEnding;

	JLabel lblGalĪp = new JLabel("Galotņu īpašības:"); 
	IpasibuTable  galotņuĪpašībuTabula = null;
	AttributeModel galĪpMod = null;
	JScrollPane spanGalĪp = new JScrollPane();
	JPopupMenu menuEngingProperties;

	JLabel lblLeks = new JLabel("Leksēmas:"); 
	JTable leksēmuTabula = null;
	LexemeModel leksMod = null;
	JScrollPane spanLeks = new JScrollPane();
	JPopupMenu menuLexeme;
	
	JLabel lblLeksĪp = new JLabel("Leksēmu īpašības:"); 
	IpasibuTable leksēmuĪpašībuTabula = null;
	AttributeModel leksĪpMod = null;
	JScrollPane spanLeksĪp = new JScrollPane();
	JPopupMenu menuLexemeProperties;

	JButton saglabātBtn = new JButton("Saglabāt izmaiņas");
	JButton aizvērt = new JButton("Aizvērt");
	JButton pārslēgt = new JButton("Galotņu tabula");
	
	boolean rādaGalotnes = false;

	JPanel pnlGalotnes = new JPanel(new BorderLayout());
	JPanel pnlLeksēmas = new JPanel(new BorderLayout());
    JPanel pnlLabais = new JPanel();
    JPanel centrs = new JPanel(new BorderLayout());
	JPanel pnlKreisais = new JPanel(new BorderLayout());

	protected int intWGroupPopup;
	protected int intWGroupPropertiesPopup;
	protected int intEndingPopup;
	protected int intEndingPropertiesPopup;
	protected int intLexemePopup;
	protected int intLexemePropertiesPopup;
	
	public LeksikonaEditorsFrame(Lexicon _lexicon) {
		this.lexicon = _lexicon;

	    JPanel panelis = (JPanel) this.getContentPane();
//	    panelis.setMaximumSize(new Dimension(820, 672));
	    panelis.setMinimumSize(new Dimension(820, 610));
//	    this.setLocale(java.util.Locale.getDefault());
	    this.setPreferredSize(new Dimension(820, 610));
	    this.setTitle("Leksikona redaktors");
	    //this.setResizable(false);

	    panelis.setLayout(new BorderLayout());

	    vgrMod = new VardgrupuModelis (lexicon);
	    vārdgrupas = new JTable(vgrMod);
	    vārdgrupas.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
	    TableColumn column = null;
	    for (int i = 0; i < vgrMod.getColumnCount(); i++) {
	        column = vārdgrupas.getColumnModel().getColumn(i);
	        if (i == 1) {
	            column.setPreferredWidth(300); //third column is bigger
	        } else {
	            column.setPreferredWidth(50);
	        }
	    }
	    vārdgrupas.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    vārdgrupas.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    vārdgrupas.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteWGroup(vārdgrupas.convertRowIndexToModel(vārdgrupas.getSelectedRow()));
	    	}
	    });
	    vārdgrupas.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		insertWGroup();
	    	}
	    });
	    
	    vārdgrupas.setBorder(BorderFactory.createLineBorder(Color.black));
	    vārdgrupas.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
	        public void valueChanged(ListSelectionEvent e) {
	    		vārdgrupaSelektēta();
	    	}
	    });
	    
	    vgrĪpMod = new AttributeModel(null);
	    vgrĪpašībuTabula = new IpasibuTable(vgrĪpMod);
	    vgrĪpašībuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
	    vgrĪpašībuTabula.setBorder(BorderFactory.createLineBorder(Color.black));
	    vgrĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    vgrĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    vgrĪpašībuTabula.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteWgroupProperty(vgrĪpašībuTabula.convertRowIndexToModel(vgrĪpašībuTabula.getSelectedRow()));
	    	}
	    });
	    vgrĪpašībuTabula.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		addWgroupProperty();
	    	}
	    });

	    galMod = new EndingModel();
	    galotņuTabula = new JTable(galMod);
	    galotņuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
//	    galotņuTabula.setPreferredScrollableViewportSize(new Dimension(500, 70));
	    galotņuTabula.setBorder(BorderFactory.createLineBorder(Color.black));	 
	    galotņuTabula.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
	        public void valueChanged(ListSelectionEvent e) {
	    		galotneSelektēta();
	    	}
	    });
	    galotņuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    galotņuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    galotņuTabula.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteEnding(galotņuTabula.convertRowIndexToModel(galotņuTabula.getSelectedRow()));
	    	}
	    });
	    galotņuTabula.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		addEnding();
	    	}
	    });

	    galĪpMod = new AttributeModel(null);
	    galotņuĪpašībuTabula = new IpasibuTable(galĪpMod);
	    galotņuĪpašībuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
//	    galotņuĪpašībuTabula.setPreferredScrollableViewportSize(new Dimension(500, 70));
	    galotņuĪpašībuTabula.setBorder(BorderFactory.createLineBorder(Color.black));
	    galotņuĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    galotņuĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    galotņuĪpašībuTabula.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteEndingProperty(galotņuĪpašībuTabula.convertRowIndexToModel(galotņuĪpašībuTabula.getSelectedRow()));
	    	}
	    });
	    galotņuĪpašībuTabula.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		addEndingProperty();
	    	}
	    });

	    leksMod = new LexemeModel();
	    
	    leksēmuTabula = new JTable(leksMod);
	    leksēmuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
	    leksēmuTabula.setBorder(BorderFactory.createLineBorder(Color.black));
	    // leksēmuTabula.setAutoCreateRowSorter(true);
	    leksēmuTabula.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
	        public void valueChanged(ListSelectionEvent e) {
	    		leksēmaSelektēta();
	    	}
	    });

	    leksēmuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    leksēmuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    leksēmuTabula.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteLexeme(leksēmuTabula.convertRowIndexToModel(leksēmuTabula.getSelectedRow()));
	    	}
	    });
	    leksēmuTabula.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		addLexeme();
	    	}
	    });

	    leksĪpMod = new AttributeModel(null);
	    leksēmuĪpašībuTabula = new IpasibuTable(leksĪpMod);
	    leksēmuĪpašībuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
	    leksēmuĪpašībuTabula.setBorder(BorderFactory.createLineBorder(Color.black));
	    leksēmuĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,java.awt.event.InputEvent.CTRL_DOWN_MASK), "deleteRow");
	    leksēmuĪpašībuTabula.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_INSERT,java.awt.event.InputEvent.CTRL_DOWN_MASK), "insertRow");
	    leksēmuĪpašībuTabula.getActionMap().put("deleteRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		deleteLexemeProperty(leksēmuĪpašībuTabula.convertRowIndexToModel(leksēmuĪpašībuTabula.getSelectedRow()));
	    	}
	    });
	    leksēmuĪpašībuTabula.getActionMap().put("insertRow",new AbstractAction() {
	    	public void actionPerformed(ActionEvent e) {
	    		addLexemeProperty();
	    	}
	    });

	    JPanel leja = new JPanel(new BorderLayout());
	    JPanel pnlVgrTab = new JPanel(new BorderLayout());
	    JPanel pnlVgrĪpTab = new JPanel(new BorderLayout());
	    JPanel pnlGalTab = new JPanel(new BorderLayout());
	    JPanel pnlGalĪpTab = new JPanel(new BorderLayout());
	    JPanel pnlLeksTab = new JPanel(new BorderLayout());
	    JPanel pnlLeksĪpTab = new JPanel(new BorderLayout());

	    pnlVgrTab.add(lblVgr, BorderLayout.NORTH);
	    pnlVgrTab.add(vārdgrupas, BorderLayout.SOUTH);
	    pnlVgrTab.add(spanVgr);
	    spanVgr.getViewport().add(vārdgrupas, null);
	    
	    pnlVgrĪpTab.add(lblVgrĪp, BorderLayout.NORTH);
	    pnlVgrĪpTab.add(vgrĪpašībuTabula, BorderLayout.SOUTH);
	    pnlVgrĪpTab.add(spanVgrĪp);
	    spanVgrĪp.getViewport().add(vgrĪpašībuTabula, null);

	    pnlGalTab.add(lblGal, BorderLayout.NORTH);
	    pnlGalTab.add(galotņuTabula, BorderLayout.SOUTH);
	    pnlGalTab.add(spanGal);
	    spanGal.getViewport().add(galotņuTabula, null);

	    pnlGalĪpTab.add(lblGalĪp, BorderLayout.NORTH);
	    pnlGalĪpTab.add(galotņuĪpašībuTabula, BorderLayout.SOUTH);
	    pnlGalĪpTab.add(spanGalĪp);
	    spanGalĪp.getViewport().add(galotņuĪpašībuTabula, null);

	    pnlLeksTab.add(lblLeks, BorderLayout.NORTH);
	    pnlLeksTab.add(leksēmuTabula, BorderLayout.SOUTH);
	    pnlLeksTab.add(spanLeks);
	    spanLeks.getViewport().add(leksēmuTabula, null);

	    pnlLeksĪpTab.add(lblLeksĪp, BorderLayout.NORTH);
	    pnlLeksĪpTab.add(leksēmuĪpašībuTabula, BorderLayout.SOUTH);
	    pnlLeksĪpTab.add(spanLeksĪp);
	    spanLeksĪp.getViewport().add(leksēmuĪpašībuTabula, null);
	    
	    pnlGalTab.setPreferredSize(new Dimension(400, 400));
	    pnlGalotnes.add(pnlGalTab, BorderLayout.CENTER);
	    pnlGalĪpTab.setPreferredSize(new Dimension(400, 150));
	    pnlGalotnes.add(pnlGalĪpTab, BorderLayout.SOUTH);

	    pnlLeksTab.setPreferredSize(new Dimension(400, 400));
	    pnlLeksēmas.add(pnlLeksTab, BorderLayout.CENTER);
	    pnlLeksĪpTab.setPreferredSize(new Dimension(400, 150));
	    pnlLeksēmas.add(pnlLeksĪpTab, BorderLayout.SOUTH);
	    
	    pnlVgrTab.setPreferredSize(new Dimension(400, 400));
	    pnlKreisais.add(pnlVgrTab, BorderLayout.CENTER);
	    pnlVgrĪpTab.setPreferredSize(new Dimension(400, 150));
	    pnlKreisais.add(pnlVgrĪpTab, BorderLayout.SOUTH);
	    
	    centrs.add(pnlKreisais, BorderLayout.WEST);
	    centrs.add(pnlLeksēmas, BorderLayout.CENTER);

	    pārslēgt.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				changeTables();
			}
		});

	    aizvērt.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				aizvērtLogu();
			}
		});

	    leja.add(pārslēgt, BorderLayout.LINE_START);
	    leja.add(aizvērt, BorderLayout.LINE_END);
	    
	    panelis.add(centrs, BorderLayout.CENTER);
	    panelis.add(leja, BorderLayout.SOUTH);
	    
	    addWGroupPopupMenu();
	    addWGroupPropertiesPopupMenu();
	    addEndingPopupMenu();
	    addEngingPropertiesPopupMenu();
	    addLexemePopupMenu();
	    addLexemePropertiesPopupMenu();

	    this.pack();
	}

	protected void changeTables() {
		if (rādaGalotnes) {
			pārslēgt.setText("Galotņu tabula");
			centrs.removeAll();
		    centrs.add(pnlKreisais, BorderLayout.WEST);
		    centrs.add(pnlLeksēmas, BorderLayout.CENTER);
		    rādaGalotnes = false;
		} else {
			pārslēgt.setText("Leksēmu tabula");			    
			centrs.removeAll();
		    centrs.add(pnlKreisais, BorderLayout.WEST);
		    centrs.add(pnlGalotnes, BorderLayout.CENTER);
		    rādaGalotnes = true;
		}
		vārdgrupaSelektēta();
		this.pack();
	}

	private void addWGroupPopupMenu() {
		menuWGroup = new JPopupMenu(){
	    	@Override
	        public void show(Component c, int x, int y) {
	            intWGroupPopup = vārdgrupas.rowAtPoint(new Point(x,y));
	            super.show(c, x, y);
	        }			
		};
	    JMenuItem insertWGroup = new JMenuItem("Pievienot vārdgrupu");
	    insertWGroup.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intWGroupPopup >= 0 &&
						intWGroupPopup < vārdgrupas.getRowCount() )
					insertWGroup();
			}		    	
	    });
	    JMenuItem deleteWGroup = new JMenuItem("Dzēst vārdgrupu");
	    deleteWGroup.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intWGroupPopup >= 0 &&
						intWGroupPopup < vārdgrupas.getRowCount() )
					deleteWGroup(intWGroupPopup);
			}		    	
	    });
	    menuWGroup.add(insertWGroup);
	    menuWGroup.add(deleteWGroup);
	    vārdgrupas.setComponentPopupMenu(menuWGroup);
	}

	private void addWGroupPropertiesPopupMenu() {
		menuWGroupProperties = new JPopupMenu(){
	    	@Override
	        public void show(Component c, int x, int y) {
	            intWGroupPropertiesPopup = vgrĪpašībuTabula.rowAtPoint(new Point(x,y));
	            super.show(c, x, y);
	        }			
		};
	    JMenuItem addProperty = new JMenuItem("Pievienot īpašību");
	    addProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intWGroupPropertiesPopup >= 0 &&
						intWGroupPropertiesPopup < vgrĪpašībuTabula.getRowCount() )
					addWgroupProperty();
			}		    	
	    });
	    JMenuItem deleteProperty = new JMenuItem("Dzēst īpašību");
	    deleteProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intWGroupPropertiesPopup >= 0 &&
						intWGroupPropertiesPopup < vgrĪpašībuTabula.getRowCount() )
					deleteWgroupProperty(intWGroupPropertiesPopup);
			}		    	
	    });
	    menuWGroupProperties.add(addProperty);
	    menuWGroupProperties.add(deleteProperty);
	    vgrĪpašībuTabula.setComponentPopupMenu(menuWGroupProperties);
	}

	private void addEndingPopupMenu() {
		menuEnding = new JPopupMenu(){
	    	@Override
	        public void show(Component c, int x, int y) {
	            intEndingPopup = galotņuTabula.rowAtPoint(new Point(x,y));
	            super.show(c, x, y);
	        }			
		};
	    JMenuItem addEnding = new JMenuItem("Pievienot galotni");
	    addEnding.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intEndingPopup >= 0 &&
						intEndingPopup < galotņuTabula.getRowCount() )
					addEnding();
			}		    	
	    });
	    JMenuItem deleteEnding = new JMenuItem("Dzēst galotni");
	    deleteEnding.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if ( intEndingPopup >= 0 &&
						intEndingPopup < galotņuTabula.getRowCount() )
					deleteEnding(intEndingPopup);
			}		    	
	    });
	    menuEnding.add(addEnding);
	    menuEnding.add(deleteEnding);
	    galotņuTabula.setComponentPopupMenu(menuEnding);
	}

	private void addEngingPropertiesPopupMenu() {
		menuEngingProperties = new JPopupMenu() {
			@Override
			public void show(Component c, int x, int y) {
				intEndingPropertiesPopup = galotņuĪpašībuTabula.rowAtPoint(new Point(x, y));
				super.show(c, x, y);
			}
		};
		JMenuItem addEndingProperty = new JMenuItem("Pievienot īpašību");
		addEndingProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intEndingPropertiesPopup >= 0
						&& intEndingPropertiesPopup < galotņuĪpašībuTabula.getRowCount())
					addEndingProperty();
			}
		});
		JMenuItem deleteEndingProperty = new JMenuItem("Dzēst īpašību");
		deleteEndingProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intEndingPropertiesPopup >= 0
						&& intEndingPropertiesPopup < galotņuĪpašībuTabula.getRowCount())
					deleteEndingProperty(intEndingPropertiesPopup);
			}
		});
		menuEngingProperties.add(addEndingProperty);
		menuEngingProperties.add(deleteEndingProperty);
		galotņuĪpašībuTabula.setComponentPopupMenu(menuEngingProperties);		
	}

	private void addLexemePopupMenu() {
		menuLexeme = new JPopupMenu() {
			@Override
			public void show(Component c, int x, int y) {
				intLexemePopup = leksēmuTabula.rowAtPoint(new Point(x, y));
				super.show(c, x, y);
			}
		};
		JMenuItem addLexeme = new JMenuItem("Pievienot leksēmu");
		addLexeme.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intLexemePopup >= 0
						&& intLexemePopup < leksēmuTabula.getRowCount())
					addLexeme();
			}
		});
		JMenuItem deleteLexeme = new JMenuItem("Dzēst leksēmu");
		deleteLexeme.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intLexemePopup >= 0
						&& intLexemePopup < leksēmuTabula.getRowCount())
					deleteLexeme(intLexemePopup);
			}
		});
		menuLexeme.add(addLexeme);
		menuLexeme.add(deleteLexeme);
		leksēmuTabula.setComponentPopupMenu(menuLexeme);		
	}

	private void addLexemePropertiesPopupMenu() {
		menuLexemeProperties = new JPopupMenu() {
			@Override
			public void show(Component c, int x, int y) {
				intLexemePropertiesPopup = leksēmuĪpašībuTabula.rowAtPoint(new Point(x, y));
				super.show(c, x, y);
			}
		};
		JMenuItem addLexemeProperty = new JMenuItem("Pievienot īpašību");
		addLexemeProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intLexemePropertiesPopup >= 0
						&& intLexemePropertiesPopup < leksēmuĪpašībuTabula.getRowCount())
					addLexemeProperty();
			}
		});
		JMenuItem deleteLexemeProperty = new JMenuItem("Dzēst īpašību");
		deleteLexemeProperty.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if (intLexemePropertiesPopup >= 0
						&& intLexemePropertiesPopup < leksēmuĪpašībuTabula.getRowCount())
					deleteLexemeProperty(intLexemePropertiesPopup);
			}
		});
		menuLexemeProperties.add(addLexemeProperty);
		menuLexemeProperties.add(deleteLexemeProperty);
		leksēmuĪpašībuTabula.setComponentPopupMenu(menuLexemeProperties);		
	}

	protected void deleteWGroup(int i) {
		vgrMod.removeRow(i);
	}

	protected void insertWGroup() {
		vgrMod.addRow();
	}

	protected void deleteWgroupProperty(int i) {
		vgrĪpMod.removeRow(i);
	}

	protected void addWgroupProperty() {
		vgrĪpMod.addRow();
	}

	protected void deleteEnding(int i) {
		galMod.removeRow(i);	    		
	}

	protected void addEnding() {
		galMod.addRow();
	}

	protected void deleteEndingProperty(int i) {
		galĪpMod.removeRow(i);
	}

	protected void addEndingProperty() {
		galĪpMod.addRow();
	}

	protected void deleteLexeme(int i) {
		leksMod.removeRow(i);
	}

	protected void addLexeme() {
		leksMod.addRow();
	}

	protected void deleteLexemeProperty(int i) {
		leksĪpMod.removeRow(i);
	}

	protected void addLexemeProperty() {
		leksĪpMod.addRow();
	}

	protected void aizvērtLogu() {
		this.dispose();		
	}

	void vārdgrupaSelektēta() {
		int i = vārdgrupas.getSelectedRow();
		Paradigm vārdgrupa = null;
		if (i > -1) {
			String s = vārdgrupas.getValueAt(i, 0).toString();
			vārdgrupa = lexicon.paradigmByID(Integer.parseInt(s));
		}
		
		vgrĪpašībasAtjaunot(vārdgrupa);
	}
	
	private void vgrĪpašībasAtjaunot(Paradigm vārdgrupa) {
		vgrĪpMod.setAttributes(vārdgrupa);		
		galMod.setVārdgrupa(vārdgrupa);		
		leksMod.setVārdgrupa(vārdgrupa);
		
		if (vārdgrupa != null) {
			if (galMod.getRowCount() > 0)
				galotņuTabula.setRowSelectionInterval(0,0); 
			galotneSelektēta();
			if (leksMod.getRowCount() > 0)
				leksēmuTabula.setRowSelectionInterval(0,0); 
			leksēmaSelektēta();
		}
	}

	void galotneSelektēta() {		
		Ending ending = null;
		int i = galotņuTabula.getSelectedRow();
		Object o = null;
		if (i>=0) o = galotņuTabula.getValueAt(i, 0);
		if (o != null) ending = lexicon.endingByID(Integer.parseInt(o.toString()));
		galĪpMod.setAttributes(ending);
	}

	void leksēmaSelektēta() {
		Lexeme leksēma = null;		
		int i = leksēmuTabula.getSelectedRow();			
		Object o = null;
		if (i>=0) o = leksēmuTabula.getValueAt(i, 0);
		if (o != null) leksēma = lexicon.lexemeByID(Integer.parseInt(o.toString()));			
		leksĪpMod.setAttributes(leksēma);
	}
}
