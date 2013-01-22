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
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.util.ArrayList;
import java.util.Map.Entry;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

import lv.semti.annotator.settings.*;
import lv.semti.morphology.attributes.AttributeNames;
import lv.semti.morphology.lexicon.*;

@SuppressWarnings("serial")
public class Sinhronizetajs extends JDialog {
	JPanel contentPane;

	Lexicon darbaLexicon;
	Lexicon salīdzināmaisLexicon;

	DefaultTableModel atšķirībuModelis = new DefaultTableModel();
	JTable atšķirībuTabula = null;
	JScrollPane span3 = new JScrollPane();

	DefaultTableModel mod4 = new DefaultTableModel();
	JTable tabula4 = null;
	JScrollPane span4 = new JScrollPane();

	JLabel tabulasVārds = null;
	JLabel izmVārds = null;

	JPanel tablePane;
	JButton saglabātBtn = new JButton("Saglabāt izmaiņas");
	JButton aizvērt = new JButton("Aizvērt");

	public Sinhronizetajs(Lexicon lexicon) {
		darbaLexicon = lexicon;
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		try {
			jbInit();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void jbInit() throws Exception {
		contentPane = (JPanel) this.getContentPane();
		this.setLocale(java.util.Locale.getDefault());
		this.setResizable(false);
		this.setSize(new Dimension(415, 555));
		this.setTitle("Leksikonu sinhronizēšana");

		contentPane.setLayout(new BorderLayout());

		izmVārds = new JLabel("Izmaiņas:");
		contentPane.add(izmVārds, BorderLayout.NORTH);

		atšķirībuModelis.addColumn("Vārdgrupas Nr");
		atšķirībuModelis.addColumn("Nr");
		atšķirībuModelis.addColumn("Pamatforma");
		atšķirībuModelis.addColumn("Apraksts");
		atšķirībuTabula = new JTable(atšķirībuModelis) {
			@Override
			public String getToolTipText(MouseEvent e) {				
				String tmp = atšķirībuTabula.getValueAt(rowAtPoint( e.getPoint()), 1).toString();
				Lexeme jaunāLeksēma = salīdzināmaisLexicon.lexemeByID(Integer.parseInt(tmp));
				
		    	String tooltip = "";
		    	for (Entry<String,String> pāris : jaunāLeksēma.entrySet()) 
		    		tooltip = tooltip + pāris.getKey() + " = " + pāris.getValue() + "\n";
		    	tooltip = tooltip + "\n";
				
				ArrayList<Lexeme> sakrītošie = darbaLexicon.paradigmByID(jaunāLeksēma.getParadigmID()).getLexemesByStem().get(0).get(jaunāLeksēma.getStem(0));
				if (sakrītošie == null || sakrītošie.size() == 0) {
					tooltip = tooltip + "Nav esošajā leksikonā\n";					
				} else if (sakrītošie.size() == 1) {
					Lexeme oriģinālāLeksēma = sakrītošie.get(0);
			    	for (Entry<String,String> pāris : oriģinālāLeksēma.entrySet()) 
			    		tooltip = tooltip + pāris.getKey() + " = " + pāris.getValue() + "\n";
			    	tooltip = tooltip + "\n";
				} else {
					tooltip = tooltip + "Ir vairākas atbilstības, jāskatās ar editoru\n";
				}
				
				
				tooltip = "<html>"+tooltip.replaceAll("\n", "<br>")+"</html>";
				return tooltip;					
			}
		};

		
		contentPane.add(atšķirībuTabula, BorderLayout.CENTER);
		contentPane.add(span3, BorderLayout.CENTER);
		span3.getViewport().add(atšķirībuTabula, null);

		JPanel apakša = new JPanel();
		apakša.setLayout(new BorderLayout());
		JPanel pogas = new JPanel();
		JButton btnPievienot = new JButton("Pievienot atzīmētos ierakstus");
		btnPievienot.setPreferredSize(new Dimension(190, 20));
		btnPievienot.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pievienotAtzīmētos();
			}
		});
		pogas.add(btnPievienot);

		JButton btnAtvērtLeksikonu = new JButton("Atvērt sinhornizējamo leksikonu");
		btnAtvērtLeksikonu.setPreferredSize(new Dimension(190, 20));
		btnAtvērtLeksikonu.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				atvērtOtruLeksikonu();
			}
		});
		pogas.add(btnAtvērtLeksikonu);
		apakša.add(pogas, BorderLayout.NORTH);

//		JPanel līnija = new JPanel();
//		līnija.setBorder(BorderFactory.createLineBorder(Color.black));
//		līnija.setPreferredSize(new Dimension(395, 1));
//		apakša.add(līnija, BorderLayout.CENTER);

		JPanel pogas2 = new JPanel();
		aizvērt.setPreferredSize(new Dimension(190, 20));
		aizvērt.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				aizvērtLogu();
			}
		});
		pogas2.add(aizvērt);
		apakša.add(pogas2, BorderLayout.SOUTH);
		contentPane.add(apakša, BorderLayout.SOUTH);

		atvērtOtruLeksikonu();
	}

	boolean atvērtOtruLeksikonu() {
		JFileChooser jFileChooser = new JFileChooser(Uzstadijumi.getUzstadijumi().getDarbaCeļš());
		jFileChooser.setDialogTitle("Norādiet sinhronizējamā leksikona datnes vietu");
		if (JFileChooser.APPROVE_OPTION == jFileChooser.showOpenDialog(this)) {
			String inFile = jFileChooser.getSelectedFile().getPath();

			try {
				salīdzināmaisLexicon = new Lexicon(inFile);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			while (atšķirībuModelis.getRowCount() > 0) 
				atšķirībuModelis.removeRow(0);
			pārbaudītTabulas();
			return true;
		} 
		return false;
	}

	private void pārbaudītTabulas() {
		for (Paradigm vārdgrupa : darbaLexicon.paradigms) {				
			Paradigm salīdzināmāVārdgrupa = salīdzināmaisLexicon.paradigmByID(vārdgrupa.getID());
			if (salīdzināmāVārdgrupa == null) continue;
			
			for (Lexeme salīdzināmāLeksēma : salīdzināmāVārdgrupa.lexemes) {
				ArrayList<Lexeme> sakrītošie = vārdgrupa.getLexemesByStem().get(0).get(salīdzināmāLeksēma.getStem(0)); 
				if (sakrītošie == null || sakrītošie.size() == 0) {
					atšķirībuModelis.addRow(new Object[] {
							vārdgrupa.getID(),
							salīdzināmāLeksēma.getID(),
							salīdzināmāLeksēma.getValue(AttributeNames.i_Lemma),
							"Jauna leksēma"});
				} else {
					
					boolean vaiIrKautVienaKasSakrītPilnībā = false;					
					for (Lexeme sakrītošā : sakrītošie) {
						boolean sakrīt = sakrītošā.isMatchingStrong(salīdzināmāLeksēma);
						for (int sakne = 0; sakne < vārdgrupa.getStems(); sakne++) {
							if (!sakrītošā.getStem(sakne).equalsIgnoreCase(salīdzināmāLeksēma.getStem(sakne)))
								sakrīt = false;
						}
						if (sakrīt) vaiIrKautVienaKasSakrītPilnībā = true;
					}
					
					if (!vaiIrKautVienaKasSakrītPilnībā) {
						boolean tikaiPapildinfo = false;						
						boolean irKasJauns = false;
						if (sakrītošie.size()==1) {					
							Lexeme sakrītošā = sakrītošie.get(0);
							for (int sakne = 0; sakne < vārdgrupa.getStems(); sakne++) {
								if (!sakrītošā.getStem(sakne).equalsIgnoreCase(salīdzināmāLeksēma.getStem(sakne)))
									tikaiPapildinfo = false;
							}														

							for (Entry<String,String> pāris : salīdzināmāLeksēma.entrySet()) {
								if (!sakrītošā.isMatchingWeak(pāris.getKey(), pāris.getValue())) {
									tikaiPapildinfo = false;
									irKasJauns = true;
								}
								if (sakrītošā.getValue(pāris.getKey()) == null) irKasJauns = true;
							}
							tikaiPapildinfo = sakrītošā.isMatchingWeak(salīdzināmāLeksēma);
						} else irKasJauns = true;												
						
						if (irKasJauns)
							atšķirībuModelis.addRow(new Object[] {
								vārdgrupa.getID(),
								salīdzināmāLeksēma.getID(),
								salīdzināmāLeksēma.getValue(AttributeNames.i_Lemma),
								tikaiPapildinfo ? "Papildinformācija" : "Atšķirīgas īpašības"});
					}
				}
				
			}
		}
	}

	void pievienotAtzīmētos() {
		int[] selectedRows = atšķirībuTabula.getSelectedRows();
		for (int i = 0; i < atšķirībuTabula.getSelectedRowCount(); i++) { 
			if (atšķirībuTabula.getValueAt(selectedRows[i], 3).toString().equals("Jauna leksēma")) {
				String tmp = atšķirībuTabula.getValueAt(selectedRows[i], 1).toString();
				Lexeme pievienojamāLeksēma = salīdzināmaisLexicon.lexemeByID(Integer.parseInt(tmp));
				tmp = atšķirībuTabula.getValueAt(selectedRows[i], 0).toString();
				Paradigm vārdgrupa = darbaLexicon.paradigmByID(Integer.parseInt(tmp));

				System.out.println("Pievienojam "+pievienojamāLeksēma.getStem(0));
				Lexeme jaunā = new Lexeme(pievienojamāLeksēma.getStem(0));
				for (int sakne = 0; sakne < vārdgrupa.getStems(); sakne++) {
					jaunā.setStem(sakne, pievienojamāLeksēma.getStem(sakne));
				}
				jaunā.addAttributes(pievienojamāLeksēma);
				vārdgrupa.addLexeme(jaunā);
			}

			if (atšķirībuTabula.getValueAt(selectedRows[i], 3).toString().equals("Papildinformācija")) {
				//FIXME - ja citas atšķirības, tad nemākam neko izdarīt
				String tmp = atšķirībuTabula.getValueAt(selectedRows[i], 1).toString();
				Lexeme pievienojamāLeksēma = salīdzināmaisLexicon.lexemeByID(Integer.parseInt(tmp));

				ArrayList<Lexeme> sakrītošie = darbaLexicon.paradigmByID(pievienojamāLeksēma.getParadigmID()).getLexemesByStem().get(0).get(pievienojamāLeksēma.getStem(0));
				if (sakrītošie.size() == 1) {
					Lexeme oriģinālāLeksēma = sakrītošie.get(0);
			    	for (Entry<String,String> pāris : pievienojamāLeksēma.entrySet()) {
			    		if (oriģinālāLeksēma.getValue(pāris.getKey()) == null)
			    			oriģinālāLeksēma.addAttribute(pāris.getKey(), pāris.getValue());
			    	}
				} 				
				
				System.out.println("Pievienojam īpašības "+pievienojamāLeksēma.getStem(0));
			}
		}

		int numRows = atšķirībuTabula.getSelectedRows().length;
		for(int i=0; i<numRows ; i++ ) atšķirībuModelis.removeRow(atšķirībuTabula.getSelectedRow());
		//FIXME - novāc arī tās rindas, kuras nemācējām apstrādāt
	}

	protected void aizvērtLogu() {
		this.dispose();
	}
}
