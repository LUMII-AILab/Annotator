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
import java.awt.Color;
import java.awt.Component;
import java.awt.Cursor;
import java.awt.Desktop;
import java.awt.Dimension;
import java.awt.Font;
import java.awt.Frame;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.Toolkit;
import java.awt.Window;
import java.awt.Dialog.ModalExclusionType;
import java.awt.Dialog.ModalityType;
import java.awt.datatransfer.Clipboard;
import java.awt.datatransfer.DataFlavor;
import java.awt.datatransfer.Transferable;
import java.awt.datatransfer.UnsupportedFlavorException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowEvent;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

import javax.swing.AbstractAction;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JCheckBox;
import javax.swing.JDialog;
import javax.swing.JFileChooser;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPopupMenu;
import javax.swing.JProgressBar;
import javax.swing.JScrollPane;
import javax.swing.JTabbedPane;
import javax.swing.JTable;
import javax.swing.KeyStroke;
import javax.swing.ListSelectionModel;
import javax.swing.RowSorter;
import javax.swing.SortOrder;
import javax.swing.SwingUtilities;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;
import javax.swing.table.TableCellRenderer;
import javax.swing.table.TableColumnModel;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.SAXException;

import lv.semti.PrologInterface.ChunkerInterface;
import lv.semti.annotator.lexiconeditor.LeksikonaEditorsFrame;
import lv.semti.annotator.settings.*;
import lv.semti.annotator.syntax.*;
import lv.semti.annotator.treeeditor.*;
import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.lexicon.Lexicon;

import cpdetector.io.CodepageDetectorProxy;
import cpdetector.io.JChardetFacade;
import edu.stanford.nlp.ie.AbstractSequenceClassifier;
import edu.stanford.nlp.ie.ner.CMMClassifier;
import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.sequences.LVMorphologyReaderAndWriter;

@SuppressWarnings("serial")
public class MainFrame extends JFrame {
	// Atslēgt advancētās un testa iespējas, lai nemulsina lietotāju
	// TODO - uz uzstādījumu logu
	boolean advancedUI = false;
	
	class TabulasPoguListener implements MouseListener {
		//kopēts no web
		  private JTable __table;

		  private void __forwardEventToButton(MouseEvent e) {
		    TableColumnModel columnModel = __table.getColumnModel();
		    int column = columnModel.getColumnIndexAtX(e.getX());
		    int row    = e.getY() / __table.getRowHeight();
		    Object value;
		    JButton button;
		    MouseEvent buttonEvent;

		    if(row >= __table.getRowCount() || row < 0 ||
		       column >= __table.getColumnCount() || column < 0)
		      return;

		    value = __table.getValueAt(row, column);

		    if(!(value instanceof JButton))
		      return;
		    button = (JButton)value;

		    buttonEvent = SwingUtilities.convertMouseEvent(__table, e, button);
		    button.dispatchEvent(buttonEvent);
		    // This is necessary so that when a button is pressed and released
		    // it gets rendered properly.  Otherwise, the button may still appear
		    // pressed down when it has been released.
		    __table.repaint();
		  }

		  public TabulasPoguListener(JTable table) {
		    __table = table;
		  }

		  public void mouseClicked(MouseEvent e) {
		    __forwardEventToButton(e);
		  }

		  public void mouseEntered(MouseEvent e) {
		    __forwardEventToButton(e);
		  }

		  public void mouseExited(MouseEvent e) {
		    __forwardEventToButton(e);
		  }

		  public void mousePressed(MouseEvent e) {
		    __forwardEventToButton(e);
		  }

		  public void mouseReleased(MouseEvent e) {
		    __forwardEventToButton(e);
		  }
	}
	
	private String revīzija = "$Rev: 979 $"; // SVN commit nr
	private String versijasNumurs = "0.9." + revīzija.substring(6, 9);
	TextData teksts = null;
	Analyzer locītājs = null;
	AbstractSequenceClassifier<CoreLabel> tageris = null;
	ChunkerInterface čunkerinterfeiss= null;
	
	private static final String INSTRUCTION_FILENAME = "doc/Instrukcija.pdf";
	private static final String TAGSET_FILENAME = "doc/TagSet.pdf";

	JFileChooser jFileChooser = new JFileChooser();
	JPanel contentPane;
	BorderLayout borderLayout1 = new BorderLayout();
	JTable čunkuTabula;
	CunkuModelis čunkuModelis = null;
	JScrollPane jScrollPane = new JScrollPane();	
	
	MarkejumaModelis marķējumaModelis = null;
	JTable marķējumuTabula = null;
	JScrollPane jScrollPane2 = new JScrollPane();	

	VardinfoModel vārdinfoModelis;
	JTable tblVInfo;
	JScrollPane jScrollPane3 = new JScrollPane();	

	JTabbedPane labāPuse = new JTabbedPane();
	KokaEditorsArPogam sintaksesPanelis = new KokaEditorsArPogam(null);
	
	JCheckBox rādītVisusVārdus = new JCheckBox("Rādīt visus vārdus");
    JPanel panelTeksts = new JPanel(new BorderLayout());
    JPanel panelMarķTabula = new JPanel(new BorderLayout());
    JPanel panelMarķējumi = new JPanel(new BorderLayout());
    JPanel panelApakša = new JPanel(new BorderLayout());
    JPanel panelAugša = new JPanel(new BorderLayout());
	
	int čunkuTabulasPopupRinda = -1; // čunku tabulas row, uz kura ir uzklikināts popupmenu 
	int marķējumuTabulasPopupRinda = -1; // marķējumu tabulas row, uz kura ir uzklikināts popupmenu 
	
	public MainFrame() throws Exception {
		    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
		      jbInit();
	}


	private void jbInit() {
		  	initializeAnalyzer(Lexicon.DEFAULT_LEXICON_FILE);
		    inicializētChunkotāju("chunker/src");
		    
		    contentPane = (JPanel) this.getContentPane();
		    this.setLocale(java.util.Locale.getDefault());
		    this.setResizable(true);
		    this.setSize(new Dimension(830, 600));
		    //this.setTitle("Marķētājs - " + versijasNumurs);
		    this.setTitle("Marķētājs 1.1 (alfa versija)");
		    this.setExtendedState(this.getExtendedState() | Frame.MAXIMIZED_BOTH);

		    contentPane.setMinimumSize(new Dimension(415, 600));
		    contentPane.setLayout(new BorderLayout());
		    
		    JMenuItem jMenuFileJauns = new JMenuItem("Jauns teksts");
		    jMenuFileJauns.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					newFile();
				}	    	
		    });
			
		    ActionListener saveListener = new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					saveMarked(e.getActionCommand());
				}	    	
		    };
		    JMenuItem jMenuFileSaveAll = new JMenuItem("Saglabāt marķēto tekstu visos formātos");
		    jMenuFileSaveAll.setActionCommand("all");
		    jMenuFileSaveAll.addActionListener(saveListener);
		    JMenuItem jMenuFileSaveTxt = new JMenuItem("Saglabāt marķēto tekstu parastajā formātā");
		    jMenuFileSaveTxt.setActionCommand("txt");
		    jMenuFileSaveTxt.addActionListener(saveListener);
		    JMenuItem jMenuFileSaveXML = new JMenuItem("Saglabāt marķēto tekstu XML");
		    jMenuFileSaveXML.setActionCommand("xml");
		    jMenuFileSaveXML.addActionListener(saveListener);
		    JMenuItem jMenuFileSavePML = new JMenuItem("Saglabāt marķēto tekstu PML");
		    jMenuFileSavePML.setActionCommand("pml");
		    jMenuFileSavePML.addActionListener(saveListener);
		    JMenuItem jMenuFileSavePML2 = new JMenuItem("Notagot visu tekstu uz PML");
		    jMenuFileSavePML2.setActionCommand("pml2");
		    jMenuFileSavePML2.addActionListener(saveListener);
		    
		    JMenuItem jMenuFileAtvērt = new JMenuItem("Atvērt marķējamo tekstu");
		    jMenuFileAtvērt.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					openFile();
				}	    	
		    });
		    
		    JMenuItem jMenuFileBeigtDarbu = new JMenuItem("Beigt darbu");
		    jMenuFileBeigtDarbu.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					beigtDarbu();
				}	    	
		    });
		    
		    JMenu jMenuFile = new JMenu("Korpuss");
		    jMenuFile.add(jMenuFileJauns);
		    jMenuFile.add(jMenuFileAtvērt);
		    jMenuFile.add(jMenuFileSaveAll);
		    jMenuFile.add(jMenuFileSaveTxt);
		    jMenuFile.add(jMenuFileSaveXML);
		    jMenuFile.add(jMenuFileSavePML);
		    jMenuFile.add(jMenuFileSavePML2);
		    jMenuFile.addSeparator();
		    jMenuFile.add(jMenuFileBeigtDarbu);
		    
		    JMenuBar jMenuBar = new JMenuBar();
		    jMenuBar.add(jMenuFile);
		    
		    JMenuItem jMenuRīkiUzstādījumi = new JMenuItem("Mainīt uzstādījumus");
		    jMenuRīkiUzstādījumi.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					UzstadijumiFrame uzst = new UzstadijumiFrame();  
					centerFrame(uzst);
					uzst.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
					uzst.setModalityType(ModalityType.APPLICATION_MODAL);
					uzst.setVisible(true);
					//aplajojam uzstādījumus uz leksikonu
					Uzstadijumi.getUzstadijumi().uzliktLocītājam(locītājs);
					if (čunkerinterfeiss != null) {
						čunkerinterfeiss.setMaxChunkLength(Uzstadijumi.getUzstadijumi().getMaxChunkLength());
						čunkerinterfeiss.setParseTimeLimit(Uzstadijumi.getUzstadijumi().getParseTimeLimit());
					}
				}	    	
		    });
		    
		    JMenuItem jMenuRīkiLabotLeksikonu = new JMenuItem("Labot leksikonu");
		    jMenuRīkiLabotLeksikonu.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					LeksikonaEditorsFrame loc = new LeksikonaEditorsFrame(locītājs);
					centerFrame(loc);
					loc.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
					loc.setModalityType(ModalityType.APPLICATION_MODAL);
					loc.setVisible(true);
				}	    	
		    });
		    
		    JMenuItem jMenuRīkiSinhronizētājs = new JMenuItem("Sinhronizēt leksikonus");
		    jMenuRīkiSinhronizētājs.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					Sinhronizetajs sinh = new Sinhronizetajs(locītājs);
					centerFrame(sinh);
					sinh.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
					sinh.setModalityType(ModalityType.APPLICATION_MODAL);
					sinh.setVisible(true);
				}	    	
		    });
		    
		    JMenuItem jMenuRīkiIelasītEtalonu = new JMenuItem("Ielasīt etalonu");
		    jMenuRīkiIelasītEtalonu.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
					getGlassPane().setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
					getGlassPane().setVisible(true);

					//CorpusProcessing.ielasītEtalonu(locītājs);
					
					setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
					getGlassPane().setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
					getGlassPane().setVisible(false);
				}	    	
		    });
		    
		    JMenuItem jMenuRīkiUpdate = new JMenuItem("Atjaunināt leksikonu");
		    jMenuRīkiUpdate.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					//TODO
				}	    	
		    });
		    jMenuRīkiUpdate.setEnabled(false);
		    
		    JMenu jMenuRīki = new JMenu("Rīki");
		    jMenuRīki.add(jMenuRīkiLabotLeksikonu);
		    //jMenuRīki.add(jMenuRīkiUpdate);
		    //if (advancedUI)
		    jMenuRīki.add(jMenuRīkiSinhronizētājs);
		    if (advancedUI) jMenuRīki.add(jMenuRīkiIelasītEtalonu);
		    jMenuRīki.addSeparator();
		    jMenuRīki.add(jMenuRīkiUzstādījumi);
		    jMenuBar.add(jMenuRīki);

			JMenu jMenuPalīgs = new JMenu("Palīgs");
			
			JMenuItem jMenuPalīgsInstrukcija = new JMenuItem("Lietošanas instrukcija");
			jMenuPalīgsInstrukcija.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					try {
						Desktop.getDesktop().open( new File(INSTRUCTION_FILENAME) );
					} catch (IOException e1) {
						e1.printStackTrace();	
					}
				}	    	
		    });
			
			JMenuItem jMenuPalīgsTagSet = new JMenuItem("Morfoloģisko pazīmju kopa");
			jMenuPalīgsTagSet.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					try {
						Desktop.getDesktop().open( new File(TAGSET_FILENAME) );
					} catch (IOException e1) {
						e1.printStackTrace();
					}
				}	    	
		    });
			
			JMenuItem jMenuPalīgsPar = new JMenuItem("Par...");
			jMenuPalīgsPar.addActionListener(new ActionListener(){
				public void actionPerformed(ActionEvent e) {
					AboutDialog about = new AboutDialog(locītājs);
					centerFrame(about);
					about.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
					about.setModalityType(ModalityType.APPLICATION_MODAL);
					about.setVisible(true);					
				}	    	
		    });
			
			jMenuPalīgs.add(jMenuPalīgsInstrukcija);
			jMenuPalīgs.add(jMenuPalīgsTagSet);
			jMenuPalīgs.addSeparator();
			jMenuPalīgs.add(jMenuPalīgsPar);
			jMenuBar.add(jMenuPalīgs);

		    
		    čunkuModelis = new CunkuModelis();
		    čunkuTabula = new JTable(čunkuModelis) {

				@Override
				public Component prepareRenderer
			    (TableCellRenderer renderer,int Index_row, int Index_col) {
					CunkuModelis mdl = (CunkuModelis) this.getModel();
					if (mdl == null) return null;
					
			        Component comp = super.prepareRenderer(renderer, Index_row, Index_col);
			        if (!isCellSelected(Index_row, Index_col))			     
			        	comp.setBackground( mdl.getColor(Index_row) ); 			        
					return comp;
				}
		    };
		    čunkuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		    čunkuTabula.getSelectionModel().addListSelectionListener(new ListSelectionListener() {
		        public void valueChanged(ListSelectionEvent e) {
		    		if (!e.getValueIsAdjusting()) čunksSelektēts();
		    	}
		    });
		    
		    final JPopupMenu čunkuTabulasMenu = new JPopupMenu(){
		    	@Override
		        public void show(Component c, int x, int y) {
		            čunkuTabulasPopupRinda = čunkuTabula.rowAtPoint(new Point(x,y));
		            super.show(c, x, y);
		        }
		    };
		    
		    JMenuItem ielīmētNoStarpliktuves = new JMenuItem("Ielikt tekstu no starpliktuves");
		    ielīmētNoStarpliktuves.addActionListener(new ActionListener() {
		    	public void actionPerformed(ActionEvent arg0) {
		    		String result = "";
		    		Clipboard clipboard = Toolkit.getDefaultToolkit().getSystemClipboard();
		    		Transferable contents = clipboard.getContents(null);
		    		if ( (contents != null) &&
		    				contents.isDataFlavorSupported(DataFlavor.stringFlavor) ) {
		    			try {
		    				result = (String)contents.getTransferData(DataFlavor.stringFlavor);
		    			}
		    			catch (UnsupportedFlavorException ex){
		    				System.out.println(ex);
		    				ex.printStackTrace();
		    			}
		    			catch (IOException ex) {
		    				System.out.println(ex);
		    				ex.printStackTrace();
		    			}

		    			if ( čunkuTabulasPopupRinda >= 0 &&
		    					čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
		    				teksts.insertText(result ,čunkuTabulasPopupRinda);						
		    			}					
		    		}

		    	}		    	
		    });
		    čunkuTabulasMenu.add(ielīmētNoStarpliktuves);
		    čunkuTabulasMenu.addSeparator();

		    JMenuItem turpinātMarķēt = new JMenuItem("Turpināt marķēt no šīs rindiņas");
		    turpinātMarķēt.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
						teksts.setCurrentChunk(čunkuTabulasPopupRinda);						
					}
				}		    	
		    });
		    čunkuTabulasMenu.add(turpinātMarķēt);
		    
		    JMenuItem pārčunkotČunku = new JMenuItem("Pārmarķēt šo rindiņu");
		    pārčunkotČunku.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
						teksts.setCurrentChunk(čunkuTabulasPopupRinda);
						teksts.getCurrentChunk().redoChunking();
					}
				}		    	
		    });
		    čunkuTabulasMenu.add(pārčunkotČunku);
		    čunkuTabulasMenu.addSeparator();
		    
		    JMenuItem apvienotČunkus = new JMenuItem("Apvienot ar nākamo rindiņu");
		    apvienotČunkus.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() )
						teksts.mergeWithNextChunk(čunkuTabulasPopupRinda);
				}		    	
		    });
		    čunkuTabulasMenu.add(apvienotČunkus);
		    
		    JMenuItem iespraustČunku = new JMenuItem("Iespraust tukšu rindiņu");
		    iespraustČunku.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
						teksts.insertEmptyChunk(čunkuTabulasPopupRinda);						
					}
				}		    	
		    });
		    čunkuTabulasMenu.add(iespraustČunku);

		    JMenuItem dzēstČunku = new JMenuItem("Dzēst rindiņu");
		    dzēstČunku.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
						teksts.deleteChunk(čunkuTabulasPopupRinda);						
					}
				}		    	
		    });
		    čunkuTabulasMenu.add(dzēstČunku);
		    čunkuTabulasMenu.addSeparator();
		    
		    JMenuItem parādītSintaksi = new JMenuItem("Rādīt sintaksi atsevišķā logā...");
		    parādītSintaksi.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( čunkuTabulasPopupRinda >= 0 &&
							čunkuTabulasPopupRinda < čunkuTabula.getRowCount() ) {
						lv.semti.annotator.treeeditor.KokaFrame kokaFreims = new lv.semti.annotator.treeeditor.KokaFrame(teksts.getChunk(čunkuTabulasPopupRinda));
//						kokaFreims.setModalityType(ModalityType.APPLICATION_MODAL);
//						kokaFreims.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
						kokaFreims.setVisible(true);
					}
				}		    	
		    });
		    //if (advancedUI) 
		    	čunkuTabulasMenu.add(parādītSintaksi);
		    
		    čunkuTabula.setComponentPopupMenu(čunkuTabulasMenu);
		    	    
			marķējumaModelis = new MarkejumaModelis();
			marķējumuTabula = new JTable(marķējumaModelis) {
				@Override
				public String getToolTipText(MouseEvent e) {
					String tooltip = marķējumaModelis.getToolTip( rowAtPoint( e.getPoint()));
					
					if (tooltip != null)
						tooltip = "<html>"+tooltip.replaceAll("\n", "<br>")+"</html>";
					return tooltip;					
				}
				
				@Override
				public Component prepareRenderer
			    (TableCellRenderer renderer,int Index_row, int Index_col) {
					MarkejumaModelis mdl = (MarkejumaModelis) this.getModel();
					if (mdl == null) return null;
					
			        Component comp = super.prepareRenderer(renderer, Index_row, Index_col);
			        if (!isCellSelected(Index_row, Index_col))			     
			        	comp.setBackground( mdl.getColor(Index_row) ); 			        
					return comp;
				}
			};
			Font fmarķējumuTabulaFont = marķējumuTabula.getFont();
			marķējumuTabula.setFont(new Font(fmarķējumuTabulaFont.getName(), fmarķējumuTabulaFont.getStyle(), (int)(fmarķējumuTabulaFont.getSize() * 1.2f)));
			marķējumuTabula.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		    marķējumuTabula.setPreferredScrollableViewportSize(new Dimension(500, 70));
		    marķējumuTabula.setBorder(BorderFactory.createLineBorder(Color.black));
		    marķējumuTabula.getColumn("Vārds").setPreferredWidth(150);
		    marķējumuTabula.getColumn("Marķējums").setPreferredWidth(100);
		    marķējumuTabula.getColumn("Pamatforma").setPreferredWidth(100);
		    marķējumuTabula.getColumn("Loma").setPreferredWidth(140);

		    final JPopupMenu marķējumuTabulasMenu = new JPopupMenu(){
		    	@Override
		        public void show(Component c, int x, int y) {
		    		marķējumuTabulasPopupRinda = marķējumuTabula.rowAtPoint(new Point(x,y));
		            super.show(c, x, y);
		        }
		    };
		    JMenuItem atkārtotVārdaMarķēšanu = new JMenuItem("Pārmarķēt šo vārdu");
		    atkārtotVārdaMarķēšanu.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent arg0) {
					if ( marķējumuTabulasPopupRinda >= 0 &&
							marķējumuTabulasPopupRinda < marķējumuTabula.getRowCount() )
						marķējumaModelis.atkārtotVārdaMarķēšanu(marķējumuTabulasPopupRinda);
				}		    	
		    });
		    marķējumuTabulasMenu.add(atkārtotVārdaMarķēšanu);		    

		    marķējumuTabula.setComponentPopupMenu(marķējumuTabulasMenu);
		    		    
		    rādītVisusVārdus.setSelected(true);
		    rādītVisusVārdus.addChangeListener(new ChangeListener() {
				public void stateChanged(ChangeEvent e) {
					if (rādītVisusVārdus.isSelected())	{
						marķējumaModelis.setČunks(null);
					} else {
						marķējumaModelis.setČunks(teksts.getChunk(čunkuTabula.getSelectedRow()));
					}
					
				}
		    });
		    
		    vārdinfoModelis = new VardinfoModel(this);
		    
		    tblVInfo = new MTable(vārdinfoModelis, this);
		    Font fVInfoFont = tblVInfo.getFont();
		    // Font nfVInfoFont = new Font(fVInfoFont.getName(), fVInfoFont.getStyle(), (int)(fVInfoFont.getSize() * 1.4));
		    tblVInfo.setFont(new Font(Font.MONOSPACED, Font.PLAIN, (int)(fVInfoFont.getSize() * 1.5f)));
		    tblVInfo.setRowHeight((int)(tblVInfo.getRowHeight() * 1.4f));
		    tblVInfo.moveColumn(3, 5);
		    tblVInfo.getColumn("").setWidth(50);
		    tblVInfo.getColumn("").setMaxWidth(50);
		    tblVInfo.getColumn("").setMinWidth(50);
		    tblVInfo.getColumn("").setCellRenderer(new ButtonRenderer());
		    tblVInfo.addMouseListener(new TabulasPoguListener(tblVInfo));	    		    
		    tblVInfo.getInputMap().put(KeyStroke.getKeyStroke(KeyEvent.VK_ENTER,0), "selectWord");
		    tblVInfo.getActionMap().put("selectWord",new AbstractAction() {
		    	public void actionPerformed(ActionEvent e) {
		    		pieliktMarķējumuTabulā(tblVInfo.convertRowIndexToModel(tblVInfo.getSelectedRow()));
		    	}
		    });

		    tblVInfo.getColumn("Vārds").setPreferredWidth(50);
		    tblVInfo.getColumn("Marķējums").setPreferredWidth(250);
		    tblVInfo.getColumn("Apraksts").setPreferredWidth(400);
		    tblVInfo.getColumn("Galotnes nr.").setPreferredWidth(30);
		    tblVInfo.getColumn("Ticamība").setPreferredWidth(30);
		    if (!advancedUI) {		    	
		    	tblVInfo.removeColumn(tblVInfo.getColumn("Galotnes nr.")); 
		     	//tblVInfo.removeColumn(tblVInfo.getColumn("Ticamība"));  
		    }
		    tblVInfo.setAutoCreateRowSorter(true);
		    
		    List <RowSorter.SortKey> sortKeys = new ArrayList<RowSorter.SortKey>();
		    sortKeys.add(new RowSorter.SortKey(5, SortOrder.DESCENDING));
		    tblVInfo.getRowSorter().setSortKeys(sortKeys);
		    
		    //tblVInfo.setPreferredScrollableViewportSize(new Dimension(500, 70));
		    tblVInfo.setBorder(BorderFactory.createLineBorder(Color.black));
		    		   
		    panelTeksts.add(čunkuTabula, BorderLayout.CENTER);
		    panelTeksts.add(jScrollPane);
		    jScrollPane.getViewport().add(čunkuTabula, null);

		    panelMarķTabula.add(marķējumuTabula, BorderLayout.CENTER);
		    panelMarķTabula.add(jScrollPane2);
		    jScrollPane2.getViewport().add(marķējumuTabula, null);

		    panelMarķējumi.add(panelMarķTabula, BorderLayout.CENTER);
		    panelMarķējumi.add(rādītVisusVārdus, BorderLayout.SOUTH);

		    labāPuse.addTab("Marķējuma tabula", panelMarķējumi);		    
		    labāPuse.addTab("Sintakse", sintaksesPanelis);

		    try { 
		    	labāPuse.setSelectedIndex(Integer.parseInt(Uzstadijumi.getUzstadijumi().parametraVērtība("Aktīvais tabbed pane panelis")));
		    } catch (Exception e) {
				labāPuse.setSelectedIndex(0);
			}

		    panelApakša.add(tblVInfo);
			panelApakša.add(jScrollPane3);
		    jScrollPane3.getViewport().add(tblVInfo, null);
		    panelApakša.setPreferredSize(new Dimension(800, 200));

//		    panelAugša.add(panelTeksts);
//		    panelAugša.add(labāPuse);
		    
		    contentPane.add(jMenuBar, BorderLayout.PAGE_START);

		    contentPane.add(labāPuse, BorderLayout.CENTER);

		    //čunkuTabula.setPreferredSize(new Dimension(300, 200));
		    contentPane.add(panelTeksts, BorderLayout.LINE_START);
		    //contentPane.add(jScrollPane);
		    //jScrollPane.getViewport().add(čunkuTabula, null);

		    //tblVInfo.setPreferredSize(new Dimension(300, 200));
		    contentPane.add(panelApakša, BorderLayout.PAGE_END);
		    //contentPane.add(jScrollPane3);
		    //jScrollPane3.getViewport().add(tblVInfo, null);
		    
//		    contentPane.add(jMenuBar, BorderLayout.NORTH);
//		    contentPane.add(panelAugša, BorderLayout.CENTER);
//		    contentPane.add(panelApakša, BorderLayout.SOUTH);

		    //contentPane.add(panelAugša, new PaneConstraints("pane1", "pane1", PaneConstraints.ROOT, 0.5f));
		    //contentPane.add(panelApakša, new PaneConstraints("pane3", "pane1", PaneConstraints.BOTTOM, 0.3f));
		    
		    inicializētTekstu("");
		    this.pack();
		    čunkuTabula.grabFocus();
		    čunkuTabula.changeSelection(0, 0, false, true);
	}

	protected void newFile() {
		Object[] options = {
				"Jā, visos formātos",
				"Jā, kā tekstu",
				"Jā, kā XML",
				"Jā, kā PML",
                "Nē",
                "Atcelt"};
		int n = JOptionPane.showOptionDialog(this,
				"Vai saglabāt nomarķēto?",
				"Saglabāt?",
				JOptionPane.DEFAULT_OPTION,
				JOptionPane.QUESTION_MESSAGE,
				null,
				options,
				options[5]);
		if (n == 0) saveMarked("all");
		else if (n == 1) saveMarked("txt");
		else if (n == 2) saveMarked("xml");
		else if (n == 3) saveMarked("pml");
		else if (n == 5) return;
		
		teksts = new TextData("", locītājs, čunkerinterfeiss, tageris, this);			
		marķējumaModelis.setTeksts(teksts);
		čunkuModelis.setTeksts(teksts);
		teksts.setWordModel(vārdinfoModelis);
		sintaksesPanelis.setČunks(teksts.getChunk(0));
	}

	protected boolean pieliktLeksikonam() {
		VarduEditorsFrame pielicējs = new VarduEditorsFrame(teksts.getCurrentWord().getToken(), locītājs, this);
		pielicējs.setModalExclusionType(ModalExclusionType.APPLICATION_EXCLUDE);
		pielicējs.setModalityType(ModalityType.APPLICATION_MODAL);
		pielicējs.setVisible(true);
		
		return pielicējs.getRezultāts(); 
	}

	/**
	 * initializes morphological analyzer/lexicon, and also attempts to initialize the statistical morphological tagger.
	 * @param filename
	 */
	private void initializeAnalyzer(String filename){
		try {
			locītājs = new Analyzer(filename);
		} catch (Exception e) {
			e.printStackTrace();
			jFileChooser.setDialogTitle("Norādiet Lexicon.xml ceļu!");
			jFileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
			if (JFileChooser.APPROVE_OPTION == jFileChooser.showOpenDialog(this)) {
				initializeAnalyzer(jFileChooser.getSelectedFile().getPath());
			} else {
				//bez lociitaaja nav arshana!
				throw new Error("Bez locītāja nav aršana!");
			}
		}
		Uzstadijumi.getUzstadijumi().uzliktLocītājam(locītājs);
		Uzstadijumi.getUzstadijumi().setLeksikonaCeļš(filename);
		
		try {
			LVMorphologyReaderAndWriter.preloadedAnalyzer(locītājs);
			String serializedClassifier = "models/lv-morpho-model.ser.gz"; //FIXME - make it configurable
			tageris = CMMClassifier.getClassifier(serializedClassifier);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println("Working without the tagger.");
			tageris = null;
		}
	}

	private void inicializētChunkotāju(String fails){
		try {
			čunkerinterfeiss = new ChunkerInterface(fails);
			čunkerinterfeiss.setMaxChunkLength(Uzstadijumi.getUzstadijumi().getMaxChunkLength());
			čunkerinterfeiss.setParseTimeLimit(Uzstadijumi.getUzstadijumi().getParseTimeLimit());
		} catch (UnsatisfiedLinkError e) {
			System.err.println("Nevarējām pielinkot čankeri");
			System.err.println(System.getProperty("java.library.path"));
			System.err.println(e.toString());
			čunkerinterfeiss = null;
			//JOptionPane.showMessageDialog(this, System.getProperty("java.library.path"));
			//System.exit(0);
		} catch (java.lang.NoClassDefFoundError e) {
			System.err.println("Nevarējām pielinkot čankeri");
			System.err.println(System.getProperty("java.library.path"));
			System.err.println(e.toString());
			čunkerinterfeiss = null;
		} catch (Exception e) {
			System.err.println(e.toString());
			jFileChooser.setDialogTitle("Norādiet Čankera direktoriju!");
			jFileChooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
			if (JFileChooser.APPROVE_OPTION == jFileChooser.showOpenDialog(this)) {
				inicializētChunkotāju(jFileChooser.getSelectedFile().getPath());
			} else {
				//bez lociitaaja nav arshana!
				//throw new Error("Bez čankera nav aršana!");
			}
		}
	}

	protected void beigtDarbu() {
		this.dispose();
	}

	/**
	 * 
	 * @param type	Save type - "txt", "xml", "pml" or "all"
	 */
	protected void saveMarked(String type) {
		//TODO - nesaglabā izvēlēto čunkera variantu
		jFileChooser = new JFileChooser(Uzstadijumi.getUzstadijumi().getDarbaCeļš());
		if (JFileChooser.APPROVE_OPTION == jFileChooser.showSaveDialog(this)) {
			Uzstadijumi.getUzstadijumi().setDarbaCeļš(jFileChooser.getSelectedFile().getParent());
			File izejasFails = jFileChooser.getSelectedFile();
			this.repaint();
	        try {
	        	if (type.equals("txt") || type.equals("all"))
	        		teksts.saveAsText(izejasFails);			      
	        	if (type.equals("xml") || type.equals("all"))
	        		teksts.saveAsXML(izejasFails, versijasNumurs);
	        	if (type.equals("pml") || type.equals("all"))
	        		teksts.saveAsPML(izejasFails, "Eksperimentāls anotācijas paraugs.", null, versijasNumurs);
	        	if (type.equals("pml2")) {
	        		TextData notagotais = teksts.taggedTextData();
	        		notagotais.saveAsPML(izejasFails, "Eksperimentāls anotācijas paraugs.", null, versijasNumurs);
	        	}	        		
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	protected void openFile() {
		jFileChooser = new JFileChooser(Uzstadijumi.getUzstadijumi().getDarbaCeļš());
		if (JFileChooser.APPROVE_OPTION == jFileChooser.showOpenDialog(this)) {
			Uzstadijumi.getUzstadijumi().setDarbaCeļš(jFileChooser.getSelectedFile().getParent());
			if (jFileChooser.getSelectedFile().getName().endsWith(".xml")) {
				openXMLFile(jFileChooser.getSelectedFile().getPath());
			} else if (jFileChooser.getSelectedFile().getName().endsWith(".m")) {
				openPMLFile(jFileChooser.getSelectedFile().getPath());
			} else {
				openTXTFile(jFileChooser.getSelectedFile().getPath());
			}
		}
	}

	private void openXMLFile(String filename) {
		Document doc = null;
		try {
			DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
			doc = docBuilder.parse(new File(filename));
			Node node = doc.getDocumentElement(); 
			teksts = new TextData(node, locītājs, čunkerinterfeiss, tageris, this);
			marķējumaModelis.setTeksts(teksts);
			čunkuModelis.setTeksts(teksts);
			teksts.setWordModel(vārdinfoModelis);
			sintaksesPanelis.setČunks(teksts.getChunk(0));

		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		}
	}
	
	private void openPMLFile(String filename) {
		try {
			teksts = TextData.loadPML(filename, locītājs, čunkerinterfeiss, tageris, this);
	        if (JOptionPane.YES_OPTION == JOptionPane.showConfirmDialog(null, "Vai sačunkot visus teikumus?\nTas var būt ilgi!", "Čunkot", JOptionPane.YES_NO_OPTION)) {
	        	runChunkingForAll();
	        } 
			
			marķējumaModelis.setTeksts(teksts);
			čunkuModelis.setTeksts(teksts);
			teksts.setWordModel(vārdinfoModelis);
			sintaksesPanelis.setČunks(teksts.getChunk(0));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Run the prolog chunker for all sentences currently loaded
	 */
	private void runChunkingForAll() {	
	    JLabel jl = new JLabel();
	    jl.setText("Count : 0");

	    final JDialog dlg = new JDialog(this, "Progress Dialog", true);
	    JProgressBar dpb = new JProgressBar(0, teksts.getChunksCount());
	    dlg.add(BorderLayout.CENTER, dpb);
	    dlg.add(BorderLayout.NORTH, new JLabel("Progress..."));
	    dlg.setDefaultCloseOperation(JDialog.DO_NOTHING_ON_CLOSE);
	    dlg.setSize(300, 75);
	    dlg.setLocationRelativeTo(this);

	    int i = 0;
    	for (Chunk čunks : teksts.getChunkList()) {    		
    		jl.setText(String.format("Teikums : %d/%d", i, teksts.getChunksCount()));    		
    		if (!čunks.isChunkingDone()) čunks.doChunking(locītājs, čunkerinterfeiss);
    		i += 1;
    		dpb.setValue(i);
    	    Thread t = new Thread(new Runnable() {
    		      public void run() {
    		        dlg.setVisible(true);
    		      }
    		    });
    		t.start();
			try {
			    Thread.sleep(25);
			} catch (InterruptedException e) {
			    e.printStackTrace();
			}
			// if (i>5) break;
    	}
        dlg.setVisible(false);
        
        //FIXME - progressbar nestrādā, jāpaskatās kā java ui vispār taisa banckround thread kas updeito progresbarus
	}


	private void openTXTFile(String failaVārds) {
		Uzstadijumi.getUzstadijumi().setDarbaFails(failaVārds);
		BufferedReader ieeja = null;
		StringBuffer failaSaturs = new StringBuffer();
			
		CodepageDetectorProxy detector = CodepageDetectorProxy.getInstance(); // A singleton.
	    detector.add(JChardetFacade.getInstance()); 
	    
	    
		java.nio.charset.Charset charset = null;
	    try {
			charset = detector.detectCodepage(new File(failaVārds).toURI().toURL());
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		//FIXME - ir problēma, ka "pielīp" pirmā lielā atvērtā faila encoding uz nākamajiem failiem. Un ka UTF-16 detektējas kā win-1257
		try { 
		    if (charset == null){	      	   
		       System.out.println("neatradu - liekam UTF-8");
		       charset = myDetect(failaVārds);	       
		    }
		    System.out.println(charset.displayName());
		    if (charset.displayName().equalsIgnoreCase("windows-1252")){
			   charset = Charset.forName("windows-1257");
			} 

		
			ieeja = new BufferedReader(new InputStreamReader(new FileInputStream(failaVārds), charset));
			this.setTitle();

			String rinda;
		    while ((rinda = ieeja.readLine()) != null) {
	    		failaSaturs.append("\n");
	    		failaSaturs.append(rinda);
		    }
		    
			inicializētTekstu(failaSaturs.toString().replace("﻿", "")); 
			// pirmais "" nav tukšs string, bet EF BF ... baiti, ko pieliek notepads u.c. unicode teksta saakumaa
		    
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
	}

	private Charset myDetect(String failaVārds) throws IOException {
		Charset csWin1257 = Charset.forName("windows-1257");
		BufferedReader ieeja = new BufferedReader(new InputStreamReader(new FileInputStream(failaVārds), csWin1257));

		String rinda;
		int lvSimboliNoWin1257 = 0;
		int lvSimboliNoUTF8 = 0;
		while ((rinda = ieeja.readLine()) != null) {
			for (int i = rinda.length() - 1; i >= 0; i--)
			{  
				if ("āčēīķļņšūž".contains( rinda.subSequence(i,i+1))) lvSimboliNoWin1257++;
				if ("»æÅÅ¾Ä¼Å†Å†Å".contains( rinda.subSequence(i,i+1))) lvSimboliNoUTF8++;
			}
		}
		System.out.printf("Saskaitījās %d kā ANSI;  %d kā UTF8\n", lvSimboliNoWin1257, lvSimboliNoUTF8);
		return (lvSimboliNoUTF8 > lvSimboliNoWin1257) ? Charset.forName("UTF-8") : Charset.forName("windows-1257");
	}

	private void inicializētTekstu(String txt) {
		Cursor hourglassCursor = new Cursor(Cursor.WAIT_CURSOR);
		setCursor(hourglassCursor);					
		teksts = new TextData(txt, locītājs, čunkerinterfeiss, tageris, this);
				
		marķējumaModelis.setTeksts(teksts);
		čunkuModelis.setTeksts(teksts);
		teksts.setWordModel(vārdinfoModelis);
		sintaksesPanelis.setČunks(teksts.getChunk(0));

		//rēķina tabulas platumu pēc rindu satura...
		int platums = 200;
		for (int i = 0; i < čunkuTabula.getRowCount(); i++) {
			Component comp = čunkuTabula.getDefaultRenderer(
					čunkuModelis.getColumnClass(0)).getTableCellRendererComponent(čunkuTabula, čunkuTabula.getValueAt(i, 0), false,
							false, 0, 0);
			int cellWidth = comp.getPreferredSize().width;
			if (cellWidth > platums) platums = cellWidth;
			
		}
		čunkuTabula.getColumn("Fragmenti").setMinWidth(platums+2);
		//rēķina tabulas platumu pēc rindu satura...
		
		Cursor normalCursor = new Cursor(Cursor.DEFAULT_CURSOR);
		setCursor(normalCursor);
		
		tblVInfo.grabFocus();
	}

	private void setTitle() {
		if (Uzstadijumi.getUzstadijumi().getDarbaFails().length() > 0)
			this.setTitle("Marķētājs 1.1 (alfa versija) [" + Uzstadijumi.getUzstadijumi().getDarbaFails() + "]");
		else
			this.setTitle("Marķētājs 1.1 (alfa versija)");			
	}

	@Override
	protected void processWindowEvent(WindowEvent e) {
	    super.processWindowEvent(e);
	    
	    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
	    	try {
	    		//locītājs.toXML(Uzstadijumi.getUzstadijumi().getLeksikonaCeļš());
	    		// FIXME - seivošana aizkomentēta pagaidām - jo pēc multileksikonu ieviešanas saglabāšana nestrādā..
	    		//TODO - varētu advancēti pārbaudīt, vai ir kautkas mainījies
	    		
	    		Uzstadijumi.getUzstadijumi().pieliktParametru("Aktīvais tabbed pane panelis", String.valueOf(labāPuse.getSelectedIndex()));
	    		Uzstadijumi.getUzstadijumi().saglabāt(); 
			} catch (IOException e1) {
				e1.printStackTrace();
			}
	      System.exit(0);
	    }
	  }
/**
 * 
 * @param npk - rindas numurs no *modeļa* numerācijas, nevis no tabulas
 */
	public void pieliktMarķējumuTabulā(int npk) {
		Word vārds = teksts.getCurrentWord(); 
		if (npk == vārds.wordformsCount()) { // es zinu labāk
			if (pieliktLeksikonam()) {
				Word pāranalizētais = locītājs.analyze(vārds.getToken());
				vārds.wordforms.clear();
				for (Wordform vārdforma : pāranalizētais.wordforms) {
					vārds.wordforms.add(vārdforma);
				}
				vārds.dataHasChanged();
				return;
			}
		}
		
		vārdinfoModelis.pareizaisVariantsIr(npk);
		teksts.dataHasChanged();

		teksts.nextWord();
		čunkuTabula.setRowSelectionInterval(teksts.getCurrentChunkNo(),teksts.getCurrentChunkNo());
		Rectangle r = čunkuTabula.getCellRect(teksts.getCurrentChunkNo(), 0, true);
		čunkuTabula.scrollRectToVisible(r);
		
		tblVInfo.grabFocus();
		if (vārdinfoModelis.getRowCount()>1)
			tblVInfo.changeSelection(tblVInfo.convertRowIndexToView(vārdinfoModelis.autofocusRow()), 1, false, true);
	}

	protected void čunksSelektēts() {
		if (teksts.getChunk(čunkuTabula.getSelectedRow()) == null) return;
				
		if (!rādītVisusVārdus.isSelected())	
			marķējumaModelis.setČunks(teksts.getChunk(čunkuTabula.getSelectedRow()));
		
		sintaksesPanelis.setČunks(teksts.getChunk(čunkuTabula.getSelectedRow()));
	}
	
	void centerFrame(Window frame) {
		Dimension screenSize = this.getSize();
	    Dimension frameSize = frame.getSize();
	    if (frameSize.height > screenSize.height) {
	      frameSize.height = screenSize.height;
	    }
	    if (frameSize.width > screenSize.width) {
	      frameSize.width = screenSize.width;
	    }
	    frame.setLocation((screenSize.width - frameSize.width) / 2, (screenSize.height - frameSize.height) / 2);		
	}

}