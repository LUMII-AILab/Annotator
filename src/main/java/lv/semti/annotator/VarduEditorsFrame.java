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

import java.awt.AWTEvent;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.ArrayList;
import java.util.Date;

import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import lv.semti.annotator.MainFrame;
import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.attributes.*;
import lv.semti.morphology.lexicon.*;

@SuppressWarnings("serial")
public class VarduEditorsFrame extends JDialog  {

	private Analyzer locītājs;
	private JPanel contentPane;

 	private BorderLayout borderLayout = new BorderLayout();
	
    private JPanel vInfo = new JPanel();
	private JLabel lblVārds = new JLabel(AttributeNames.i_Lemma + ": ");
	JTextField txtVārds = new JTextField();
	private JLabel lblVārdgrupa = new JLabel(AttributeNames.i_PartOfSpeech + ": ");
	JComboBox cmbVārdgrupa = new JComboBox();

	private JPanel pogas = new JPanel();
	private JButton btnPievienot = new JButton("Pievienot vārdu");
	private JButton btnCancel = new JButton("Atcelt pievienošanu");
	String vārds;
	int wGroup = -1;
	MainFrame parent;
	
    ArrayList<Paradigm> vārdgrupas = new ArrayList<Paradigm>();

 	private JPanel parametri = new JPanel();
    private JPanel lietvProps = new JPanel();
    // i_LvTips par i_NounType
    private JLabel lblLvTips = new JLabel(AttributeNames.i_NounType + ": ");
	private JComboBox cmbLvTips;
	
    private JPanel darbVProps = new JPanel();
    private JLabel lblTransitivitāte = new JLabel(AttributeNames.i_Transitivity + ": ");
	private JComboBox cmbTransitivitāte = new JComboBox();
	// i_DvTips par i_VerbType
    private JLabel lblDVTips = new JLabel(AttributeNames.i_VerbType + ": ");
	private JComboBox cmbDVTips = new JComboBox();

    private JPanel īpVProps = new JPanel();
    // i_IipvTips par i_AdjectiveType
    private JLabel lblIpvTips = new JLabel(AttributeNames.i_AdjectiveType + ": ");
	private JComboBox cmbIpvTips = new JComboBox();

    private JPanel apstVProps = new JPanel();
    private JLabel lblApstVTips = new JLabel(AttributeNames.i_ApstTips + ": ");
	private JComboBox cmbApstVTips = new JComboBox();

	private boolean rezultāts;
	
	public VarduEditorsFrame(String vārds, Analyzer locītājs) {
		this.locītājs = locītājs;
		this.vārds = vārds;
		    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		    try {
		      jbInit();
		    }
		    catch(Exception e) {
		      e.printStackTrace();
		    }
	}

	public VarduEditorsFrame(int wGroup, Analyzer locītājs) {
		this.locītājs = locītājs;
		this.wGroup = wGroup;
		    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		    try {
		      jbInit();
		    }
		    catch(Exception e) {
		      e.printStackTrace();
		    }
	}

	public VarduEditorsFrame(String vārds, Analyzer locītājs, MainFrame parent) {
		this.parent = parent;
		this.locītājs = locītājs;
		this.vārds = vārds;
		    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		    try {
		      jbInit();
		    }
		    catch(Exception e) {
		      e.printStackTrace();
		    }
	}

	private void jbInit() throws Exception  {
			TagSet tagSet = TagSet.getTagSet();

			contentPane = (JPanel) this.getContentPane();
		    this.setLocale(java.util.Locale.getDefault());
		    this.setResizable(false);
		    //this.setSize(new Dimension(300, 195));
		    this.setTitle("Vārda pievienošana Leksikonam");
		    
		    //contentPane.setMaximumSize(new Dimension(300, 195));
		    //contentPane.setMinimumSize(new Dimension(300, 195));
		    contentPane.setLayout(borderLayout);
		    
		    Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		    Dimension frameSize = this.getSize();
		    this.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);

		    btnPievienot.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					pievienotLeksikonam();
				}
			});
		    
		    btnCancel.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					atceltPievienošanu();
				}
			});

		    cmbVārdgrupa.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent arg0) {
					vārdgrupaIzvēlēta();
				}
		    });
		    
		    txtVārds.addKeyListener(new KeyListener(){
				public void keyPressed(KeyEvent arg0) {
					//neko nedaram
					
				}
				public void keyReleased(KeyEvent arg0) {
					vārds = txtVārds.getText();
					uzstādītVārdgrupas();					
				}
				public void keyTyped(KeyEvent arg0) {
					//neko nedaram
				}		    	
		    });
		    // i_LvTips par i_NounType
		    cmbLvTips = new JComboBox(tagSet.getAllowedValues(AttributeNames.i_NounType, "LV"));

		    cmbTransitivitāte.addItem(AttributeNames.v_Transitive);
		    cmbTransitivitāte.addItem(AttributeNames.v_Intransitive);
		    //v_PatstaaviigsDv par v_MainVerb
		    cmbDVTips.addItem(AttributeNames.v_MainVerb);
		    cmbDVTips.addItem(AttributeNames.v_PaliigDv);
		    cmbDVTips.addItem(AttributeNames.v_Modaals);
		    cmbDVTips.addItem(AttributeNames.v_Faazes);
		    cmbDVTips.addItem(AttributeNames.v_IzpausmesVeida);
		    cmbDVTips.addItem(AttributeNames.v_Buut);
		    cmbDVTips.addItem(AttributeNames.v_TiktTapt);
		    
		    //v_Kaadiibas par v_QualificativeAdjective
		    cmbIpvTips.addItem(AttributeNames.v_QualificativeAdjective);
		    //v_Attieksmes par v_RelativeAdjective
		    cmbIpvTips.addItem(AttributeNames.v_RelativeAdjective);
		    
		    cmbApstVTips.addItem(AttributeNames.v_Meera);
		    cmbApstVTips.addItem(AttributeNames.v_Veida);
		    cmbApstVTips.addItem(AttributeNames.v_Vietas);
		    cmbApstVTips.addItem(AttributeNames.v_Laika);
		    cmbApstVTips.addItem(AttributeNames.v_Ceelonja);

		    lietvProps.setVisible(false);
		    lblLvTips.setPreferredSize(new Dimension(100, 20));
		    cmbLvTips.setPreferredSize(new Dimension(200, 20));
		    lietvProps.add(lblLvTips);
		    lietvProps.add(cmbLvTips);

		    darbVProps.setVisible(true);
		    darbVProps.setLayout(new BorderLayout());
		    JPanel line1 = new JPanel();
		    lblTransitivitāte.setPreferredSize(new Dimension(100, 20));
		    cmbTransitivitāte.setPreferredSize(new Dimension(200, 20));
		    line1.add(lblTransitivitāte);
		    line1.add(cmbTransitivitāte);
		    JPanel line2 = new JPanel();
		    lblDVTips.setPreferredSize(new Dimension(100, 20));
		    cmbDVTips.setPreferredSize(new Dimension(200, 20));
		    line2.add(lblDVTips);
		    line2.add(cmbDVTips);
		    darbVProps.add(line1, BorderLayout.NORTH);
		    darbVProps.add(line2, BorderLayout.CENTER);
		    
		    
		    īpVProps.setVisible(false);
		    lblIpvTips.setPreferredSize(new Dimension(100, 20));
		    cmbIpvTips.setPreferredSize(new Dimension(200, 20));
		    īpVProps.add(lblIpvTips);
		    īpVProps.add(cmbIpvTips);

		    apstVProps.setVisible(false);
		    lblApstVTips.setPreferredSize(new Dimension(100, 20));
		    cmbApstVTips.setPreferredSize(new Dimension(200, 20));
		    apstVProps.add(lblApstVTips);
		    apstVProps.add(cmbApstVTips);
		    
		    vInfo.setLayout(new BorderLayout());
		    JPanel line3 = new JPanel();
		    lblVārds.setPreferredSize(new Dimension(100, 20));
		    txtVārds.setPreferredSize(new Dimension(200, 20));
		    line3.add(lblVārds);
		    line3.add(txtVārds);
		    JPanel line4 = new JPanel();
		    lblVārdgrupa.setPreferredSize(new Dimension(100, 20));
		    cmbVārdgrupa.setPreferredSize(new Dimension(200, 20));
		    line4.add(lblVārdgrupa);
		    line4.add(cmbVārdgrupa);
		    vInfo.add(line3, BorderLayout.NORTH);
		    vInfo.add(line4, BorderLayout.CENTER);

		    parametri.add(lietvProps);
		    parametri.add(īpVProps);
		    parametri.add(darbVProps);
		    parametri.add(apstVProps);
		    parametri.setPreferredSize(new Dimension(300, 70));
		        
		    pogas.add(btnPievienot);
		    pogas.add(btnCancel);

		    contentPane.add(vInfo, BorderLayout.NORTH);
		    contentPane.add(parametri, BorderLayout.CENTER);
		    contentPane.add(pogas, BorderLayout.SOUTH);
		    
		    txtVārds.setText(vārds.toLowerCase());
		    cmbVārdgrupa.setEditable(false);
		    
		    uzstādītVārdgrupas();
	  }

	protected void atceltPievienošanu() {
		this.rezultāts = false;
		this.dispose();
	}

	protected void vārdgrupaIzvēlēta() {
		if (cmbVārdgrupa.getSelectedIndex() >= 0) {
			int vgrNr = vārdgrupas.get(cmbVārdgrupa.getSelectedIndex()).getID();
			if (1 <= vgrNr && vgrNr <= 12) {
				//lietvārda vardgrupa
				lietvProps.setVisible(true);
				darbVProps.setVisible(false);
				īpVProps.setVisible(false);
				apstVProps.setVisible(false);
			} else if (13 <= vgrNr && vgrNr <=14) {
				//īpašības varda vārdgrupa
				lietvProps.setVisible(false);
				darbVProps.setVisible(false);
				īpVProps.setVisible(true);
				apstVProps.setVisible(false);
			} else if (15 <= vgrNr && vgrNr <= 20) {
				//darb.v. vārdgrupa
				lietvProps.setVisible(false);
				darbVProps.setVisible(true);
				īpVProps.setVisible(false);
				apstVProps.setVisible(false);
				if (15 == vgrNr || 18 == vgrNr) {
					// 1. konjugācija
					//TODO: parādīt elementus
				}
			} else if (21 <= vgrNr && vgrNr <= 21) {
				//apst.v vārdgrupa
				lietvProps.setVisible(false);
				darbVProps.setVisible(false);
				īpVProps.setVisible(false);
				apstVProps.setVisible(true);
			} else if (22 <= vgrNr) {
				//šīs vārdgrupas tipa nevajadzētu aiztikt un ta nevajadzētu būt 
				lietvProps.setVisible(false);
				darbVProps.setVisible(false);
				īpVProps.setVisible(false);
				apstVProps.setVisible(false);
			}
		} else {
			return;
		}
	}

	protected void uzstādītVārdgrupas() {
		cmbVārdgrupa.removeAllItems();
		vārdgrupas.clear();
	    for (Paradigm v : locītājs.paradigms)
    	    try {
				if (vārds.endsWith(v.getLemmaEnding().getEnding()) && (v.getID() < 22 || v.getID() > 29)) {
					if (wGroup == -1 || wGroup == v.getID()) {
						vārdgrupas.add(v);
						cmbVārdgrupa.addItem(v.getName());
					}
				}
			} catch (NullPointerException e) {
				//FIXME nu nebūtu te tā kā nullpointerim jābūt...
			}
		//TODO te vajag no vārda dabūt locījumu variantus izvēlētajai vārdgrupai");
		//lblLocījumi.setText("Uhhaaaaa!");
	    this.pack();
    }

	protected void pievienotLeksikonam() {
		Lexeme jaunais = locītājs.createLexeme(txtVārds.getText().toLowerCase(), vārdgrupas.get(cmbVārdgrupa.getSelectedIndex()).getLemmaEnding().getID(), "Marķētājs (" + new Date() + ")");
		if (cmbVārdgrupa.getSelectedIndex() > -1) {
			int vgrNr = vārdgrupas.get(cmbVārdgrupa.getSelectedIndex()).getID();
			if (1 <= vgrNr && vgrNr <= 12) {
				//lietvārda vardgrupa
				// i_LvTips par i_NounType
				jaunais.addAttribute(AttributeNames.i_NounType, cmbLvTips.getSelectedItem().toString());
			} else if (13 <= vgrNr && vgrNr <=14) {
				//īpašības varda vārdgrupa
				// i_IipvTips par i_AdjectiveType
				jaunais.addAttribute(AttributeNames.i_AdjectiveType, cmbIpvTips.getSelectedItem().toString());
			} else if (15 <= vgrNr && vgrNr <= 20) {
				//darb.v. vārdgrupa
				jaunais.addAttribute(AttributeNames.i_Transitivity, cmbTransitivitāte.getSelectedItem().toString());
				// i_DvTips par i_VerbType
				jaunais.addAttribute(AttributeNames.i_VerbType, cmbDVTips.getSelectedItem().toString());
			} else if (21 <= vgrNr && vgrNr <= 21) {
				//apstaaklja vaardi
				jaunais.addAttribute(AttributeNames.i_ApstTips, cmbApstVTips.getSelectedItem().toString());
			} else if (22 <= vgrNr && vgrNr <= 29) {
				//šīs vārdgrupas tipa nevajadzētu aiztikt un ta nevajadzētu būt 
			}
		}
		this.rezultāts = true;
		this.dispose();
	}

	public boolean getRezultāts() {
		return this.rezultāts;
	}
}
