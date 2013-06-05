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
package lv.semti.annotator.syntax;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.regex.Pattern;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.table.AbstractTableModel;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import edu.stanford.nlp.ie.AbstractSequenceClassifier;
import edu.stanford.nlp.ling.CoreLabel;

import lv.semti.PrologInterface.ChunkerInterface;
import lv.semti.PrologInterface.SpecificAttributeNames;
import lv.semti.annotator.VardinfoModel;
import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.attributes.AttributeNames;


/**
 * Main data structure. It models text as array of chunks.
 */
public class TextData {
	public final static RoleTransformator roles = new RoleTransformator ();
	//TODO - moš apvienot/ekstendot to JTextArea, kura attēlo to tekstu
	private String text;
	private ArrayList<Chunk> chunks = new ArrayList<Chunk>();
	
	//private String nesačunkotaisTekstsBeigās;
	
	private int currentChunk = -1;
	Analyzer morphoAnalyzer;
	ChunkerInterface chunkerInterface;
	AbstractSequenceClassifier<CoreLabel> tageris;
	private LinkedList<AbstractTableModel> models = new LinkedList<AbstractTableModel>();
	private VardinfoModel wordModel = null;
	
	//TODO - moš korektāk ar listeneriem
	JFrame parent = null;

	private TextData (Analyzer morphoAnalyzer, ChunkerInterface chunkerInterface, AbstractSequenceClassifier<CoreLabel> tageris, JFrame parent) {
		this.morphoAnalyzer = morphoAnalyzer;
		this.chunkerInterface = chunkerInterface;
		this.tageris = tageris;
		this.parent = parent;
	}
	
	/*
	 * Reads a text document, and splits into sentences (chunks)
	 */
	public TextData (String text, Analyzer morphoAnalyzer, ChunkerInterface chunkerInterface, AbstractSequenceClassifier<CoreLabel> tageris, JFrame parent) {
		this.text = text;
		this.morphoAnalyzer = morphoAnalyzer;
		this.chunkerInterface = chunkerInterface;
		this.tageris = tageris;
		this.parent = parent;
		
		for (String paragraph : text.split("\n")) {
			LinkedList<Word> tokens = Splitting.tokenize(morphoAnalyzer, paragraph); //TODO - performance hit, nevajadzīgi analizē visus vārdus vēlreiz
			
			String chunk_text = "";
			for (Word word : tokens) {
				if (!chunk_text.isEmpty() && Splitting.isChunkOpener(word)) { // vai šis tokens izskatās pēc jauna teikuma sākuma				
					chunks.add(new Chunk(this, chunk_text));
					chunk_text = "";
				}
				if (!chunk_text.isEmpty()) chunk_text += " ";
				chunk_text += word.getToken();
				if (Splitting.isChunkCloser(word)) { // vai šis tokens izskatās pēc teikuma beigām				
					chunks.add(new Chunk(this, chunk_text));
					chunk_text = "";
				}
			}
			
			if (!chunk_text.isEmpty()) 
				chunks.add(new Chunk(this, chunk_text));			
		}
				
		setCurrentChunk(0);
	}

	/***
	 * Reads an XML file in this tools own data format
	 * @param node
	 * @param morphoAnalyzer
	 * @param chunkerInterface
	 * @param parent
	 */
	public TextData (Node node, Analyzer morphoAnalyzer, ChunkerInterface chunkerInterface, AbstractSequenceClassifier<CoreLabel> tageris, JFrame parent) {
		if (!node.getNodeName().equalsIgnoreCase("MarķētājaDarbaFails")) throw new Error("Node " + node.getNodeName() + " nav MarķētājaDarbaFails"); 
		this.morphoAnalyzer = morphoAnalyzer;
		this.chunkerInterface = chunkerInterface;
		this.tageris = tageris;
		this.parent = parent;
		
		NodeList nodes = node.getChildNodes();		
		for (int i = 0; i < nodes.getLength(); i++) {
			if (nodes.item(i).getNodeName().equals("Čunks")) 
				chunks.add(new Chunk(this, nodes.item(i)));
			else if (nodes.item(i).getNodeName().equals("OriģinālaisTeksts"))
				text = nodes.item(i).getTextContent().trim();				
		}
		
		Node n = node.getAttributes().getNamedItem("aktuālaisČunks");
		if (n != null)
			this.setCurrentChunk(Integer.parseInt(n.getTextContent()));
	}
	
	/**
	 * Builds a new copy that is freshly tagged and can be altered w/o touching the original one. 
	 * Not an exact clone - does not link to the UI 
	 * @param source - the source text data object to be cloned
	 */
	public TextData taggedTextData () {
		TextData jaunais = new TextData(morphoAnalyzer,chunkerInterface,tageris,null);
		
		jaunais.text = this.text;
		jaunais.chunks = new ArrayList<Chunk>();
		for (Chunk c : this.chunks) {
			Chunk tagotais = new Chunk(jaunais,c.chunk);
			tagotais.tokenize(morphoAnalyzer);
			tagotais.doChunking(morphoAnalyzer, chunkerInterface);
			tagotais.applyTaggedWordforms();
			tagotais.currentVariant.setCurrentToken(null);
			jaunais.chunks.add(tagotais);
		}
		return jaunais;
	}
	
	public void addModel(AbstractTableModel model) {
		models.add(model);
	}
	
	public void removeModel(AbstractTableModel model) {
		models.remove(model);		
	}

	public Chunk getCurrentChunk() {
		if (currentChunk < 0 || currentChunk >= chunks.size()) return null;
		return chunks.get(currentChunk);
	}

	public void setCurrentChunk(int i) {
		if (i<0 || i>=chunks.size()) return;
		if (currentChunk == i) return;
		
		currentChunk = i;
		Chunk newChunk = chunks.get(currentChunk);
				
		if (!newChunk.isChunkingDone()) {
			newChunk.doChunking(morphoAnalyzer, chunkerInterface);
		} 
		
		this.dataHasChanged();
	}

	public Word getCurrentWord() {
		if (currentChunk<0 || currentChunk>=chunks.size()) return null; 
		
		try {
			ChunkVariant variant = chunks.get(currentChunk).currentVariant;
			if (variant==null) return null;
			return variant.getCurrentToken();
		} catch (Exception e) {
			System.err.println(String.format("Teikums %d/%d nav atrasts", currentChunk, chunks.size()));
			e.printStackTrace();
			return null;
		}
	}

	public boolean nextWord() {
	// false - ja nevar dabūt nākamo vārdu, jo ir beigas
		boolean result = true;
		
		if (!chunks.get(currentChunk).currentVariant.nextToken()) { // teikums ir pabeidzies
			// rečunkojam, jo esam nomarķējuši morfoloģiju un tagad sintakse būs pareizāka eksportam uz PML kokiem
			chunks.get(currentChunk).doChunking(morphoAnalyzer, chunkerInterface);
			this.dataHasChanged();
			
			int čunkanr = currentChunk + 1;
			if (čunkanr >= chunks.size()) čunkanr = 0;
			
			while (chunks.get(čunkanr).isFinished() || 
					chunks.get(čunkanr).getSentence().length() < 1) {
				čunkanr++;
				if (čunkanr >= chunks.size()) čunkanr = 0;
				if (čunkanr == currentChunk) {
					result = false; //visi teikumi apstrādāti
					break;
				}
			}
						
			setCurrentChunk(čunkanr);
		}
		return result;
	}

	protected String getText() {
		return text;
	}

	public void dataHasChanged() {
		for (AbstractTableModel modelis : models)
			modelis.fireTableDataChanged();
		
		if (getCurrentChunk() != null)
			getCurrentChunk().notifyListeners();
		
		if (wordModel != null) 
			wordModel.setVārds(this.getCurrentWord());
	}

	public void rechunkCurrentChunk() {
		this.getCurrentChunk().redoChunking();
	}

	public int getChunksCount() {
		return chunks.size();
	}

	public Chunk getChunk(int chunkNo) {
		if (chunkNo >= 0 && chunkNo < chunks.size())
			return chunks.get(chunkNo);
		return null;
	}

	public int getCurrentChunkNo() {
		return currentChunk;
	}

	public JFrame getParent() {
		return parent;
	}

	public void mergeWithNextChunk(int firstChunkNo) {
		if (firstChunkNo >= chunks.size()) throw new Error("pēdējo čunku nevar apvienot");
		chunks.get(firstChunkNo).setSentence(
				chunks.get(firstChunkNo).getSentence()
				+ " " + chunks.get(firstChunkNo + 1).getSentence());
		removeChunk(firstChunkNo + 1);
	}

	private void removeChunk(int chunkNo) {
		chunks.remove(chunkNo);
		if (currentChunk >= chunkNo) currentChunk--;
		if (currentChunk == chunkNo) setCurrentChunk(chunkNo);
		dataHasChanged();
	}

	public void setWordModel(VardinfoModel wordModel) {
		this.wordModel = wordModel;
		wordModel.setVārds(this.getCurrentWord());
	}
	
	VardinfoModel getWordModel() {
		return wordModel;
	}

	public void insertEmptyChunk(int row) {
		this.chunks.add(row+1, new Chunk(this, ""));
		if (row < this.currentChunk) 
			this.setCurrentChunk(this.currentChunk+1); 
		dataHasChanged();
	}

	public void insertText(String result, int row) {
		TextData jaunais = new TextData(result, morphoAnalyzer, chunkerInterface, tageris, parent);
		chunks.addAll(row, jaunais.getChunkList());
		for (Chunk čunks : jaunais.getChunkList()) {
			čunks.setText(this);
		}
		if (row < this.currentChunk) 
			this.setCurrentChunk(this.currentChunk + jaunais.getChunkList().size());
		if (chunks.get(currentChunk + jaunais.getChunksCount()).getSentence().length() == 0)
			this.deleteChunk(currentChunk + jaunais.getChunksCount());
		dataHasChanged();
	}

	public ArrayList<Chunk> getChunkList() {
		return chunks;
	}

	public void setCurrentChunk(Chunk chunk) {
		setCurrentChunk(chunks.indexOf(chunk));
	}

	public void deleteChunk(int row) {
		if (row >= 0 && row < chunks.size() && chunks.size() > 1) {
			this.chunks.remove(row);
			if (row < currentChunk) {
				this.setCurrentChunk(currentChunk - 1);
			} else if (row == currentChunk) {
				int čunkanr = currentChunk + 1;
				if (čunkanr >= chunks.size()) čunkanr = 0;
				boolean vissDone = false;
				while (chunks.get(čunkanr).isFinished() || 
						chunks.get(čunkanr).getSentence().length() < 1) {
					čunkanr++;
					if (čunkanr >= chunks.size()) čunkanr = 0;
					if (čunkanr == currentChunk) {
						vissDone = true; //visi teikumi apstrādāti
						break;
					}
				}
				if (!vissDone) this.setCurrentChunk(čunkanr);
			}
		} else if (chunks.size() == 1) {
			chunks.get(0).setSentence("");
		}
		dataHasChanged();
	}

	public void saveAsText(File fileName) throws IOException {
		//BufferedWriter out = new BufferedWriter(outputStreamWriter);
		String name = fileName.getPath();
		if (!name.endsWith(".txt")) name += ".txt";
		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(name), "UTF-8"));

		LinkedList<Word> vārdi = new LinkedList<Word> (); 

		for (Chunk čunks : getChunkList()) 
			if (čunks.currentVariant != null){    		
				for (Word vārds : čunks.currentVariant.getTokens()) 
					vārdi.add(vārds);

				for (Word vārds : čunks.currentVariant.getTokens()) {
					out.write(vārds.getToken() + " <");

					if (vārds.getCorrectWordform() != null ) {
						out.write(MarkupConverter.charsToPrologList(vārds.getCorrectWordform().getTag()));
						out.write(",'" + vārds.getCorrectWordform().getValue(AttributeNames.i_Lemma) + "'");    			
					} else out.write(",''");

					if (čunks.currentVariant.getDependencyRole(vārds) != null) 
						out.write(",'" + čunks.currentVariant.getDependencyRole(vārds) + "'");
					else out.write(",''");

					if (čunks.currentVariant.getDependencyHead(vārds) != null) 
						out.write(",'" + čunks.currentVariant.getDependencyHead(vārds).getToken() + "'");
					else out.write(",''");

					//FIXME - neefektīvi
					out.write("," + (vārdi.indexOf(vārds)+1));
					if (čunks.currentVariant.getDependencyHead(vārds) != null) 
						out.write("," + (vārdi.indexOf(čunks.currentVariant.getDependencyHead(vārds)) +1) );

					out.write(">");
					out.newLine();    			
				}
			}

		out.close();
	}
	
	public void saveAsXML(File fileName, String versionNo) throws IOException {
		String name = fileName.getPath();
		if (!name.endsWith(".xml")) name += ".xml";
		Writer straume = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(name), "UTF-8"));
		
		straume.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
		straume.write("<MarķētājaDarbaFails");
		straume.write(" marķētājaVersijasNumurs=\""+versionNo+"\"\n");
		straume.write(" aktuālaisČunks=\""+currentChunk+"\">\n");
		for (Chunk čunks : chunks) {
			čunks.toXML(straume);
		}
		straume.write("<OriģinālaisTeksts>" + text + "</OriģinālaisTeksts>");
		straume.write("</MarķētājaDarbaFails>\n");
		straume.flush();
		straume.close();
	}
	
	/**
	 * Saves annotation information in the Latvian Treebank PML format.
	 * Partly implemented.
	 * 
	 * @param fileName	name (path) of output files without any extension.
	 * @param metaInfo	string for <code>docmeta</code> tag.
	 * @param sourceId	source text identificator. If not given,
	 * 					<code>fileName</code> is used instead.
	 * @throws IOException
	 */
	public void saveAsPML(File fileName, String metaInfo, String sourceId, String versionNo)
	throws IOException
	{
		BufferedWriter wOut = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(fileName.getPath() + ".w"), "UTF-8"));
		BufferedWriter mOut = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(fileName.getPath() + ".m"), "UTF-8"));
		BufferedWriter aOut = new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(fileName.getPath() + ".a"), "UTF-8"));
		String fileId = fileName.getName();
		if (metaInfo == null)
			metaInfo = "";
		if (sourceId == null || sourceId.trim().equals(""))
			sourceId = fileId;
		
		// Write headers for W, M and A.
		writeWHead(wOut, fileId, sourceId, metaInfo);
		writeMHead(mOut, fileId, versionNo);
		writeAHead(aOut, fileId);
		
		// Last thing written in W is <para>.
		boolean openPara = true;
		String reminding = this.text;
		// Counters will be used to generate IDs.
		int wWordID = 1;
		int wParID = 1;
		int sentNo = 1;
		// Each chunk corresponds to one sentence (and one a-level tree).
		for (Chunk ch : getChunkList())
		{
			int mWordID = 1;
			// Only finished chunks are written in PML file - to ensure that
			// the whole sentence is written in one file (when loading from 
			// file will be implemented).
			if (ch.isFinished())
			{
				boolean firstWordEncountered = false;
				String mSentId = "m-" + fileId + "-p" + wParID + "s" + sentNo;				
				
				HashMap<Word, String> word2mid = new HashMap<Word, String>();
				
				// Write in M and W information corresponding to each token.
				for (Word token : ch.currentVariant.tokens)
				{
					// Determine which morphological variant must be written.
					Wordform wf = token.getCorrectWordform();
					if (wf == null && token.wordformsCount() == 1)
						wf = token.wordforms.get(0);
					if (wf == null)
						System.out.println("!" + token);
					// This filters of the x-words.
					if (wf == null || wf.getValue(SpecificAttributeNames.i_XWord) != null
							&& wf.getValue(SpecificAttributeNames.i_XWord).equals(AttributeNames.v_Yes))
						continue;
					
					// Write new paragraph in w file (if necessary).
					Pattern jaunaRinda = Pattern.compile("^\\s*[\\n\\f\\r]+", Pattern.DOTALL);
					if (jaunaRinda.matcher(reminding).find() && !openPara)
					{
						wOut.write("\t\t</para>"); wOut.newLine();
						wOut.write("\t\t<para>"); wOut.newLine();
						wOut.flush();
						openPara = true;
						wParID++;
						wWordID = 1;
						sentNo = 1;
						// If chunk starts with newline, sentence ID is recalculated.
						if (!firstWordEncountered) mSentId = "m-" + fileId + "-p" + wParID + "s" + sentNo;
					}
					
					// Start new sentence in M file, if necessary.
					if (!firstWordEncountered)
					{
						mOut.write("\t<s id=\"" + mSentId + "\">");
						mOut.newLine();						
					}
					
					// Cut of the current token from the reminding text.
					String t = token.getToken().trim();
					reminding = reminding.trim();
					if (reminding.indexOf(t) < 0)
					{
						// This happens when additional text from buffer is added.
						/*System.out.println(t);
						System.out.println(token.getCorrectWordform().getToken());
						throw new IllegalArgumentException(
								"Source text does not contain current token. "
								+ "Check source code for logic flaws.");*/
					} else reminding = reminding.substring(reminding.indexOf(t) + t.length());

					// Write W block.
					wOut.write("\t\t\t<w id=\"w-" + fileId + "-p" + wParID + "w" + wWordID + "\">");
					wOut.newLine();
					String outToken = token.getToken().replace("&", "&amp;").replace("<","&lt;").replace("\"", "&quot;");
					wOut.write("\t\t\t\t<token>" + outToken + "</token>"); wOut.newLine();
					openPara = false;
					if (!reminding.startsWith(" ") && !jaunaRinda.matcher(reminding).find())
					{
						wOut.write("\t\t\t\t<no_space_after>1</no_space_after>");
						wOut.newLine();
					}
					wOut.write("\t\t\t</w>"); wOut.newLine();
					wOut.flush();
					
					// Write M block.
					String mId = mSentId + "w" + mWordID;
					mOut.write("\t\t<m id=\"" + mId + "\">");
					mOut.newLine();
					mOut.write("\t\t\t<src.rf>annotator</src.rf>"); mOut.newLine();
					mOut.write("\t\t\t<w.rf>w#w-" + fileId + "-p" + wParID + "w" 
							+ wWordID + "</w.rf>");
					mOut.newLine();
					mOut.write("\t\t\t<form>" + outToken + "</form>"); mOut.newLine();
					String outLemma = wf.getValue(AttributeNames.i_Lemma).replace("&", "&amp;").replace("<","&lt;").replace("\"", "&quot;");
					mOut.write("\t\t\t<lemma>" + outLemma + "</lemma>");
					mOut.newLine();
					mOut.write("\t\t\t<tag>" + wf.getTag() + "</tag>");
					mOut.newLine();
					mOut.write("\t\t</m>"); mOut.newLine();
					mOut.flush();
					
					word2mid.put(token, mId);
					
					// Increase counters, when block is finished.
					wWordID++;
					mWordID++;
					firstWordEncountered = true;
				}
				// Finish sentence in the M.
				mOut.write("\t</s>"); mOut.newLine();
				
				// Start new tree in A file.
				String aSentId = "a" + mSentId.substring(mSentId.indexOf('-'));
				aOut.write("\t\t<LM id=\"" + aSentId + "\">");
				aOut.newLine();
				aOut.write("\t\t\t<s.rf>m#" + mSentId + "</s.rf>");
				aOut.newLine();
				aOut.write("\t\t\t<children>"); aOut.newLine();
				aOut.write("\t\t\t\t<pmcinfo>"); aOut.newLine();
				aOut.write("\t\t\t\t\t<pmctype>sent</pmctype>"); aOut.newLine();
				aOut.write("\t\t\t\t\t<children>"); aOut.newLine();
				
				int xId = 1;
				ChunkVariant chunk = ch.currentVariant;
				HashSet<Word> roots = chunk.findRoots();
	
	
				for (Word r : roots)
				{
					xId = writeANodesDFS(aOut, r, PMLRelTypes.PMC, aSentId,
							xId, word2mid, chunk);
					//.out.println(r.getToken());
				}
				
				// Finish tree in the A.
				aOut.write("\t\t\t\t\t</children>"); aOut.newLine();
				aOut.write("\t\t\t\t</pmcinfo>"); aOut.newLine();
				aOut.write("\t\t\t</children>"); aOut.newLine();
				aOut.write("\t\t</LM>"); aOut.newLine();
				
				sentNo++;

			}
			
		}
		
		// Write W, M and A tails and close all.
		writeWTail(wOut);
		wOut.close();
		writeMTail(mOut);
		mOut.close();
		writeATail(aOut);
		aOut.close();
	}
	
	/*=========================================================================
	 * Here starts supporting functions, detached from main functions to
	 * improve readability.
	 *=======================================================================*/
	
	/*=========================================================================
	 * Supporting functions for "saveAsPML".
	 *=======================================================================*/
	
	
	private int writeANodesDFS(
			BufferedWriter out, Word current,  PMLRelTypes parentType, String sentId, int xId,
			HashMap<Word, String> word2mid, ChunkVariant chunk)
	throws IOException
	{
		Wordform wf = current.getCorrectWordform();
		if (wf == null && current.wordformsCount() == 1)
			wf = current.wordforms.get(0);

		// Role adjustment for output.
		String role = roles.transform(chunk.getDependencyRole(current), PMLRelTypes.DEP);
		if (role.equals("N/A")) role = autoAddRole(wf.getTag(), parentType);
		
		// X-word or coordination.
		if (wf.getValue(SpecificAttributeNames.i_XWord) != null
			&& wf.getValue(SpecificAttributeNames.i_XWord).equals(AttributeNames.v_Yes))
		{
			out.write("<node id=\"" + sentId + "x" + xId+ "\">");
			out.newLine();
			out.write("\t<role>" + role + "</role>"); out.newLine();
			out.write("\t<children>"); out.newLine();
			String xType = roles.transform(wf.getToken(), PMLRelTypes.X);
			
			PMLRelTypes relType = PMLRelTypes.X;
			if (xType.equals("crdParts")) relType = PMLRelTypes.COORD;
			if (xType.equals("spcPmc") || xType.equals("quot")) relType = PMLRelTypes.PMC;
			switch (relType) {
			case COORD:
				out.write("\t\t<coordinfo>"); out.newLine();
				out.write("\t\t\t<coordtype>" + xType + "</coordtype>"); out.newLine();
				break;
			case PMC:
				out.write("\t\t<pmcinfo>"); out.newLine();
				out.write("\t\t\t<pmctype>" + xType + "</pmctype>"); out.newLine();
				break;
			default:
				out.write("\t\t<xinfo>"); out.newLine();
				out.write("\t\t\t<xtype>" + xType + "</xtype>"); out.newLine();
			}
			
			if (relType != PMLRelTypes.PMC) {
				out.write("\t\t\t<tag>" + wf.getTag());
				if (wf.getValue(SpecificAttributeNames.i_XTag) != null)
				{
					String addTag = wf.getValue(SpecificAttributeNames.i_XTag);
					if (xType.equals("xPrep"))
					{
						// Cutting off x-prepositions attribute 7.3.
						if (addTag.contains("y"))
							addTag = addTag.substring(0, addTag.indexOf('y') + 1);
						else addTag = addTag.substring(0, addTag.indexOf('n') + 1);
					}
					out.write("[" + addTag + "]");
				}
				out.write("</tag>");
				out.newLine();
			}
			out.write("\t\t\t<children>"); out.newLine();
			int tmpXId = xId + 1;
			ArrayList<Word> postponed = new ArrayList<Word>();

			for  (Word child : chunk.children.get(current))
			{
				Wordform childWf = child.getCorrectWordform();
				if (childWf == null && child.wordformsCount() == 1)
					childWf = child.wordforms.get(0);
				if (childWf.getValue(SpecificAttributeNames.i_XPart) != null
						&& childWf.getValue(SpecificAttributeNames.i_XPart).equals(AttributeNames.v_Yes))
				{
					tmpXId = writeANodesDFS(
							out, child, relType,
							sentId, tmpXId, word2mid, chunk);
				} else postponed.add(child);
			}
			
			out.write("\t\t\t</children>"); out.newLine();
			
			switch (relType) {
			case COORD:
				out.write("\t\t</coordinfo>"); out.newLine();
				break;
			case PMC:
				out.write("\t\t</pmcinfo>"); out.newLine();
				break;
			default:
				out.write("\t\t</xinfo>"); out.newLine();
			}
			
			for (Word child : postponed)
			{
				tmpXId = writeANodesDFS(
						out, child, PMLRelTypes.DEP, sentId, tmpXId, word2mid, chunk);
			}
			out.write("\t</children>"); out.newLine();
			out.write("</node>"); out.newLine();
			return tmpXId;
		}
		// Dependency.
		else
		{
			String mId = word2mid.get(current);
			String wId = mId.substring(mId.lastIndexOf('w') + 1);
			out.write("<node id=\"" + sentId + "w" + wId + "\">");
			out.newLine();
			out.write("\t<m.rf>m#" + mId + "</m.rf>");
			out.newLine();
			out.write("\t<role>" + role + "</role>"); out.newLine();
			out.write("\t<ord>" + wId + "</ord>"); out.newLine();
						
			// TODO: Ilmaar, paskaties.
			// It's a kind of magic...
		/*	System.out.println("containsKey:" + chunk.children.containsKey(current));
			for (Map.Entry<Word, LinkedHashSet<Word>> e: chunk.children.entrySet())
			{
				System.out.println("tokens:" + (e.getKey()).getToken() + " " + (e.getValue()).size());
				System.out.println("atsleegas vienaadiiba ar karento:" +(e.getKey()).equals(current));
				if ((e.getKey()).equals(current))
				{
					System.out.println("atsleegas hc: " + e.getKey().hashCode() + ", karentaa hc:" + current.hashCode() +
							", hc vienaadiiba:" + (e.getKey().hashCode() == current.hashCode()));
				}
			}	//*/
			
			// Punctuation marks do not have children, only siblings.
			int tmpXId = xId;
			boolean isPunct = wf.getTag().startsWith("z");
			if (isPunct) out.write("</node>"); out.newLine();
			if (chunk.children.containsKey(current))
			{
				
				if (!isPunct) out.write("\t<children>"); out.newLine();
				//int tmpXId = xId;
				for (Word child : chunk.children.get(current))
				{
					tmpXId = writeANodesDFS(
							out, child, (isPunct ? PMLRelTypes.PMC : PMLRelTypes.DEP),
							sentId, tmpXId, word2mid, chunk);
				}
				if (!isPunct) out.write("\t</children>"); out.newLine();
			}
			if (!isPunct) out.write("</node>"); out.newLine();
			
			return tmpXId;
		}//*/
	}
	
	/**
	 * Logic for adding roles to x-word and pmc constituents automatically.
	 */
	private String autoAddRole (String tag, PMLRelTypes type)
	{
		switch (type)
		{
			case COORD:
				switch (tag.charAt(0))
				{
					case 'z': return"punct";
					case 'c': return "conj";
					case 'n':;
					case 'v':;
					case 'a':;
					case 'p':;
					case 'r':;
					case 'm': return "crdPart";
				}
			case X:;
			case PMC:
				switch (tag.charAt(0))
				{
					case 'z': return"punct";
					case 's': return "prep";
					case 'n': return "basElem";
					case 'c': return "conj";
					case 'v':
						switch (tag.charAt(1))
						{
							case 'm':;
							case 'p': return "basElem";
							case 'o': return "mod";
							case 'c':;
							case 't': return "auxVerb";
						}
				}
		}
		return "N/A";
	}
	
	/**
	 * Writes PML-W file header in the output stream.
	 * @param out		stream, where to write
	 * @param fileId	file identificator (usually file name without extension)
	 * @param sourceId	source text identificator (e.g. source file name)
	 * @param metaInfo	information for <code>docmeta</code> tag.
	 * @throws IOException
	 */
	private void writeWHead(
			BufferedWriter out, String fileId, String sourceId, String metaInfo)
	throws IOException
	{
		out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"); out.newLine();
		out.write("<lvwdata xmlns=\"http://ufal.mff.cuni.cz/pdt/pml/\">"); out.newLine();
		out.write("\t<head>"); out.newLine();
		out.write("\t\t<schema href=\"lvwschema.xml\" />"); out.newLine();
		out.write("\t</head>"); out.newLine();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		out.write("\t<meta>" + dateFormat.format(new Date()) + "</meta>"); out.newLine();
		out.write("\t<doc id=\"" + fileId + "\" source_id=\"" + sourceId + "\">"); out.newLine();
		out.write("\t\t<docmeta>" + metaInfo + "</docmeta>"); out.newLine();
		out.newLine();
		out.write("\t\t<para>"); out.newLine();
		out.flush();
	}	
	/**
	 * Writes PML-M file header in the output stream.
	 * @param out		stream, where to write
	 * @param fileId	file identificator (usually file name without extension)
	 * @param versionNo	morphological annotator's version
	 * @throws IOException
	 */
	private void writeMHead(BufferedWriter out, String fileId, String versionNo)
	throws IOException
	{
		out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"); out.newLine();
		out.write("<lvmdata xmlns=\"http://ufal.mff.cuni.cz/pdt/pml/\">"); out.newLine();
		out.write("\t<head>"); out.newLine();
		out.write("\t\t<schema href=\"lvmschema.xml\" />"); out.newLine();
		out.write("\t\t<references>"); out.newLine();
		out.write("\t\t\t<reffile id=\"w\" name=\"wdata\" href=\"" + fileId + ".w\" />");
		out.newLine();
		out.write("\t\t</references>"); out.newLine();
		out.write("\t</head>"); out.newLine();
		out.write("\t<meta>"); out.newLine();
		out.write("\t\t<lang>lv</lang>"); out.newLine();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		out.write("\t\t<annotation_info>SemTi-Kamols Annotator, version: " + versionNo
				+ ", date: " + dateFormat.format(new Date()) + "</annotation_info>");
		out.newLine();
		out.write("\t</meta>"); out.newLine();
		out.newLine();
		out.flush();
	}
	/**
	 * Writes PML-A file header in the output stream.
	 * @param out		stream, where to write
	 * @param fileId	file identificator (usually file name without extension)
	 * @throws IOException
	 */
	private void writeAHead(BufferedWriter out, String fileId)
	throws IOException
	{
		out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"); out.newLine();
		out.write("<lvadata xmlns=\"http://ufal.mff.cuni.cz/pdt/pml/\">"); out.newLine();
		out.write("\t<head>"); out.newLine();
		out.write("\t\t<schema href=\"lvaschema.xml\" />"); out.newLine();
		out.write("\t\t<references>"); out.newLine();
		out.write("\t\t\t<reffile id=\"m\" name=\"mdata\" href=\"" + fileId + ".m\" />");
		out.newLine();
		out.write("\t\t\t<reffile id=\"w\" name=\"wdata\" href=\"" + fileId + ".w\" />");
		out.newLine();
		out.write("\t\t</references>"); out.newLine();
		out.write("\t</head>"); out.newLine();
		out.write("\t<meta>"); out.newLine();
		out.write("\t\t<annotation_info>"); out.newLine();
		out.write("\t\t\t<desc>Čankera sagatave manuālai korekcijai.</desc>"); out.newLine();
		out.write("\t\t</annotation_info>"); out.newLine();
		out.write("\t</meta>"); out.newLine();
		out.newLine();
		out.write("\t<trees>"); out.newLine();
		out.flush();
	}
	/**
	 * Writes PML-W file tail in the output stream.
	 * @param out	stream, where to write
	 * @throws IOException
	 */
	private void writeWTail(BufferedWriter out)
	throws IOException
	{
		out.write("\t\t</para>"); out.newLine();
		out.write("\t</doc>"); out.newLine();
		out.write("</lvwdata>"); out.newLine();
		out.flush();
	}
	/**
	 * Writes PML-M file tail in the output stream.
	 * @param out	stream, where to write
	 * @throws IOException
	 */
	private void writeMTail(BufferedWriter out)
	throws IOException
	{
		out.write("</lvmdata>"); out.newLine();
		out.flush();
	}	
	/**
	 * Writes PML-A file tail in the output stream.
	 * @param out	stream, where to write
	 * @throws IOException
	 */
	private void writeATail(BufferedWriter out)
	throws IOException
	{
		out.write("\t</trees>"); out.newLine();
		out.write("</lvadata>"); out.newLine();
		out.flush();
	}
	
	/***
	 * Loads a chunk from Prague Markup Language format
	 * @param filename
	 * @param morphoAnalyzer
	 * @param chunkerInterface
	 * @param parent
	 * @return
	 * @throws Exception
	 */
	public static TextData loadPML(String filename, Analyzer morphoAnalyzer, ChunkerInterface chunkerInterface, AbstractSequenceClassifier<CoreLabel> tageris, JFrame parent) throws Exception {
		TextData result = new TextData(morphoAnalyzer, chunkerInterface, tageris, parent);
		result.text = "";
		
		DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document doc = docBuilder.parse(new File(filename));
		Node node = doc.getDocumentElement(); 

		if (!node.getNodeName().equalsIgnoreCase("lvmdata")) throw new Error("Node " + node.getNodeName() + " nav PML formāta fails ar galveno elementu lvmdata"); 

		Map<String, Node> wfile = null;
		NodeList nodes = node.getChildNodes();	
		System.out.println();
		System.out.println("lasam iekshaa");
		for (int i = 0; i < nodes.getLength(); i++) {
			if (nodes.item(i).getNodeName().equals("s")) 
				result.chunks.add(new Chunk(result, nodes.item(i), wfile));
			if (nodes.item(i).getNodeName().equals("head")) {
				for (int j = 0; j < nodes.item(i).getChildNodes().getLength(); j++) {
					Node n2 = nodes.item(i).getChildNodes().item(j);
					if (n2.getNodeName().equals("references")) {
						for (int k = 0; k < n2.getChildNodes().getLength(); k++) {
							Node n3 = n2.getChildNodes().item(k);
							if (n3.getNodeName().equals("reffile")) {
								if (n3.getAttributes().getNamedItem("id").getTextContent().equals("w")) {
									File wfilename = new File(new File(filename).getParent()+File.separator+n3.getAttributes().getNamedItem("href").getTextContent());									
									if (wfilename.isFile()) 
										wfile = loadPMLwfile(wfilename);
								}
							}
						}
					}
				}
			}				
		}
		
		for (Chunk chunks : result.chunks) {
			if (!result.text.isEmpty()) result.text = result.text + "\n\n";
			result.text = result.text + chunks.getSentence();
		}
							
		if (result.chunks.size() == 0) 
			result.chunks.add(new Chunk(result, ""));
				
		result.setCurrentChunk(0);
		
		return result;
	}
	
	
	private static Map<String, Node> loadPMLwfile(File filename) throws ParserConfigurationException, SAXException, IOException {
		Map<String, Node> result = new HashMap<String,Node>();
		DocumentBuilder docBuilder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document doc = docBuilder.parse(filename);
		Node node = doc.getDocumentElement(); 
		NodeList nodes = node.getChildNodes();	
		
		for (int i = 0; i < nodes.getLength(); i++) {
			if (nodes.item(i).getNodeName().equals("doc")) {
				for (int j = 0; j < nodes.item(i).getChildNodes().getLength(); j++) {
					Node n2 = nodes.item(i).getChildNodes().item(j);
					if (n2.getNodeName().equals("para")) {
						for (int k = 0; k < n2.getChildNodes().getLength(); k++) {
							Node n3 = n2.getChildNodes().item(k);					
							if (n3.getNodeName().equals("w")) 
								result.put(n3.getAttributes().getNamedItem("id").getTextContent(), n3);
						}
					}
				}	
			}
		}
		return result;
	}
}
