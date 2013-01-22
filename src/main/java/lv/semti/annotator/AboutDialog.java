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

import java.awt.AWTEvent;
import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.ProgressMonitor;
import javax.swing.SwingConstants;

//import lv.semti.annotator.Updater; // TODO Kāpēc gan šito vajadzētu importēt?!
import lv.semti.morphology.lexicon.Lexicon;

@SuppressWarnings("serial")
public class AboutDialog extends JDialog {

	private Lexicon lexicon;
	
	ProgressMonitor progressMonitor;
	
	public AboutDialog(Lexicon lexicon) {
		this.lexicon = lexicon;
		enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		try {
			jbInit();
		}
		catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	private void jbInit() throws Exception  {
		JPanel contentPane = (JPanel) this.getContentPane();
		this.setLocale(java.util.Locale.getDefault());
		this.setResizable(false);
//		this.setSize(new Dimension(355, 290));
		this.setTitle("Par Marķētāju...");

//		contentPane.setMaximumSize(new Dimension(355, 290));
//		contentPane.setMinimumSize(new Dimension(355, 290));
		contentPane.setLayout(new BorderLayout(10,10));
		contentPane.setBorder(BorderFactory.createEmptyBorder(10,10,10,10));
		
		JLabel virsraksts = new JLabel("", new ImageIcon("logo.png"), SwingConstants.LEFT);
		Font virsrakstaFonts = new Font("Dialog", Font.BOLD, 22);		
		virsraksts.setFont(virsrakstaFonts);
		contentPane.add(virsraksts, BorderLayout.NORTH);
	
		JLabel teksts = new JLabel();
		String appRevision = "$Rev: 783 $"; // SVN commit nr
		appRevision = appRevision.substring(6, appRevision.indexOf(" $"));
		
		String about = "<HTML><B>Latviešu valodas tekstu korpusu morfoloģiskās un sintaktiskās marķēšanas rīks</B><BR>";
		about += "Izstrādāts LU Matemātikas un informātikas institūta Mākslīgā intelekta laboratorijā<BR>";
		about += "(c) 2005-2009, <A HREF=\"http://www.semti-kamols.lv\">http://www.semti-kamols.lv</A><BR><BR>";
		about += "Jautājumiem, ierosinājumiem, atsauksmēm: <A href=\"mailto:info@semti-kamols.lv\">info@semti-kamols.lv</A><BR><BR>";
		about += "Marķētāja redakcija: " + appRevision + "<BR>Leksikona redakcija: " + lexicon.getRevisionNumber() + "</HTML>";
		teksts.setText(about);
		contentPane.add(teksts, BorderLayout.CENTER);
		
		JPanel pogas = new JPanel();
		JButton btnAizvērt = new JButton("Aizvērt");
		btnAizvērt.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				exit();
			}
		});
		JButton btnAtjaunot = new JButton("Atjaunināt leksikonu");
		btnAtjaunot.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				apdeitot();
			}
		});
		
		pogas.add(btnAtjaunot);
		pogas.add(btnAizvērt);
		contentPane.add(pogas, BorderLayout.SOUTH);
				
		this.pack();

		this.setLocationRelativeTo(null);
	}

	protected void exit() {
		this.dispose();
	}
	
	void apdeitot() {
		final Updater updater = Updater.update(lexicon);
		progressMonitor = new ProgressMonitor(this, "Atjaunojam leksikonu", "", 0, 100);

		final AboutDialog aboutDialog = this;
		final Updater.Status status = updater.getStatus();
		
		Updater.StatusListener listener = new Updater.StatusListener() {
			
			public void progressChanged(int p) {
				if (progressMonitor.isCanceled())
					updater.stop();
				progressMonitor.setProgress(status.getProgress());
			}
			
			public void statusChanged(String s) {
				if (progressMonitor.isCanceled())
					updater.stop();
				progressMonitor.setProgress(status.getProgress());
			}
			
			public void updateCompleted(String msg) {
				progressMonitor.close();
				JOptionPane.showMessageDialog(aboutDialog, msg, null, JOptionPane.INFORMATION_MESSAGE);
			}
			
			public void updateFailed(String msg) {
				progressMonitor.close();
				JOptionPane.showMessageDialog(aboutDialog, msg, null, JOptionPane.ERROR_MESSAGE);
			}
		};
		
		status.setListener(listener);
	}	
}

