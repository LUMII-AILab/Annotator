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
package lv.semti.annotator.settings;

import java.awt.AWTEvent;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class UzstadijumiFrame extends JDialog {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	JFileChooser jFileChooser = new JFileChooser();

	JPanel contentPane;
	JButton brovze = new JButton(); 
	JButton noklusētaisLeksikons = new JButton(); 
	JButton okButton = new JButton(); 
	JButton cancelButton = new JButton(); 

	JTextField leksFile;
	JTextField txtMaxChunkLength;
	JTextField txtParseTimeLimit;

	JCheckBox minētdarbv;
	JCheckBox minētdivdabjus;
	JCheckBox minētlietv;
	JCheckBox minētīpašībasv;
	JCheckBox meklētpēcgalotnes;

	JCheckBox atļautVokatīvu;
	
	JPanel leksikons = new JPanel();
	JPanel locīšanasUzstādījumi = new JPanel();
	JPanel misc = new JPanel();
	JPanel pogas = new JPanel();
	JPanel pnlMaxChunkLength = new JPanel();
	JPanel pnlParseTimeLimit = new JPanel();
	
	
	JLabel lblRādītKastītes = new JLabel("Fragmenta analīzes rezultāti: ");
	JComboBox cmbRādītKastītes = new JComboBox(new String[]{"rādīt pirms", "rādīt pēc", "nerādīt"});

	public UzstadijumiFrame() {
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		try {
			jbInit();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}

	private void jbInit() throws Exception  {
		contentPane = (JPanel) this.getContentPane();
		this.setLocale(java.util.Locale.getDefault());
		this.setResizable(false);
		this.setSize(new Dimension(355, 340));
		this.setTitle("Uzstādījumi");

		contentPane.setMaximumSize(new Dimension(355, 290));
		contentPane.setMinimumSize(new Dimension(355, 290));
		contentPane.setLayout(new BoxLayout(contentPane, BoxLayout.PAGE_AXIS));
		
		Uzstadijumi uzstādījumi = Uzstadijumi.getUzstadijumi();

		leksFile = new JTextField(uzstādījumi.getLeksikonaCeļš());
		leksFile.setPreferredSize(new Dimension(150,20));
		leksFile.setEditable(false);

		minētdarbv = new JCheckBox("Minēt darbības vārdus");
		minētdarbv.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Minēt darbības vārdus")));
		minētdivdabjus = new JCheckBox("Minēt divdabjus");
		minētdivdabjus.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Minēt divdabjus")));
		minētlietv = new JCheckBox("Minēt lietvārdus");
		minētlietv.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Minēt lietvārdus")));
		minētīpašībasv = new JCheckBox("Minēt īpašības vārdus");
		minētīpašībasv.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Minēt īpašības vārdus")));
		meklētpēcgalotnes = new JCheckBox("Minēt vārdus pēc galotnes");
		meklētpēcgalotnes.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Minēt vārdus pēc galotnes")));
		cmbRādītKastītes.setSelectedItem(uzstādījumi.parametraVērtība("Rādīt kastes"));		

		atļautVokatīvu = new JCheckBox("Atļaut vokatīvu");
		atļautVokatīvu.setSelected(Boolean.parseBoolean(uzstādījumi.parametraVērtība("Atļaut vokatīvu")));

		leksikons.add(new JLabel("Izmantotais leksikons: "));
		leksikons.add(leksFile);
		
		locīšanasUzstādījumi.setLayout(new BoxLayout(locīšanasUzstādījumi, BoxLayout.PAGE_AXIS));
		locīšanasUzstādījumi.setAlignmentX(CENTER_ALIGNMENT);
		
		JLabel labelis = new JLabel("Locīšanas uzstādījumi:");
		locīšanasUzstādījumi.add(labelis);
		labelis.setAlignmentX((float) 0.1);		
		locīšanasUzstādījumi.add(minētdarbv);
		locīšanasUzstādījumi.add(minētdivdabjus);
		locīšanasUzstādījumi.add(minētlietv);
		locīšanasUzstādījumi.add(minētīpašībasv);
		locīšanasUzstādījumi.add(meklētpēcgalotnes);
		locīšanasUzstādījumi.add(atļautVokatīvu);

		misc.add(lblRādītKastītes);
		misc.add(cmbRādītKastītes);

		txtMaxChunkLength = new JTextField(uzstādījumi.getMaxChunkLength()+"");
		txtMaxChunkLength.setPreferredSize(new Dimension(50,20));
		txtMaxChunkLength.setMaximumSize(new Dimension(50,20));
		txtMaxChunkLength.setMinimumSize(new Dimension(50,20));
		txtMaxChunkLength.setEditable(true);
		pnlMaxChunkLength.add(new JLabel("Maksimālais čunka garums: "));
		pnlMaxChunkLength.add(txtMaxChunkLength);
		
		
		txtParseTimeLimit = new JTextField(uzstādījumi.getParseTimeLimit()+"");
		txtParseTimeLimit.setPreferredSize(new Dimension(50,20));
		txtParseTimeLimit.setMaximumSize(new Dimension(50,20));
		txtParseTimeLimit.setMinimumSize(new Dimension(50,20));
		txtParseTimeLimit.setEditable(true);	
		pnlParseTimeLimit.add(new JLabel("Parsēšanas laika limits: "));
		pnlParseTimeLimit.add(txtParseTimeLimit);
		
		okButton = new JButton("Saglabāt uzstādījumus");
		okButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				okAndExit();
			}

		});

		cancelButton = new JButton("Atcelt uzstādījumus");
		cancelButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				cancelAndExit();
			}
		});

		pogas.add(okButton);
		pogas.add(cancelButton);
		
		contentPane.add(leksikons);
		contentPane.add(locīšanasUzstādījumi);
		contentPane.add(misc);
		contentPane.add(pnlMaxChunkLength);
		contentPane.add(pnlParseTimeLimit);
		contentPane.add(pogas);
		
	}

	protected void cancelAndExit() {
		this.dispose();
	}

	protected void okAndExit() {
		Uzstadijumi uzstādījumi = Uzstadijumi.getUzstadijumi();
		uzstādījumi.pieliktParametru("Minēt darbības vārdus", String.valueOf(minētdarbv.isSelected()));
		uzstādījumi.pieliktParametru("Minēt divdabjus", String.valueOf(minētdivdabjus.isSelected()));
		uzstādījumi.pieliktParametru("Minēt lietvārdus", String.valueOf(minētlietv.isSelected()));
		uzstādījumi.pieliktParametru("Minēt īpašības vārdus", String.valueOf(minētīpašībasv.isSelected()));
		uzstādījumi.pieliktParametru("Minēt vārdus pēc galotnes", String.valueOf(meklētpēcgalotnes.isSelected()));
		uzstādījumi.pieliktParametru("Atļaut vokatīvu", String.valueOf(atļautVokatīvu.isSelected()));
		uzstādījumi.pieliktParametru("Rādīt kastes", cmbRādītKastītes.getSelectedItem().toString());
		uzstādījumi.setMaxChunkLength(txtMaxChunkLength.getText());
		uzstādījumi.setParseTimeLimit(txtParseTimeLimit.getText());
		this.dispose();
	}
}
