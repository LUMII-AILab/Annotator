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

import java.awt.Cursor;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import edu.stanford.nlp.ling.CoreLabel;
import edu.stanford.nlp.ling.CoreAnnotations.AnswerAnnotation;
import edu.stanford.nlp.ling.CoreAnnotations.LVMorphologyAnalysis;
import edu.stanford.nlp.ling.CoreAnnotations.TextAnnotation;
import edu.stanford.nlp.sequences.LVMorphologyReaderAndWriter;

import antlr.TokenStream;

import lv.semti.PrologInterface.ChunkerInterface;
import lv.semti.PrologInterface.ChunkerVariant;
import lv.semti.PrologInterface.SpecificAttributeNames;

import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.attributes.AttributeNames;
import lv.semti.morphology.attributes.AttributeValues;

/**
 * Satur info par čunka/teikuma morfoloģisko un sintaktisko marķējumu, arī
 * pusmarķētiem tekstiem utml
 * 
 * @author Pēteris Paikens
 */
public class Chunk {
	TextData text;
	public String chunk;
	//FIXME nevajag šo string! varētu uztaisīt no vārdiem!	

	private boolean isChunkingDone = false;
	private boolean isTokenized = false;
	
	private ArrayList<ChunkVariant> variants = new ArrayList<ChunkVariant>();
	public ChunkVariant currentVariant = null;
	
	Vector <ActionListener> changeListeners = new Vector <ActionListener>();
	
	public Chunk (TextData text, String chunk) {
		this.text = text;
		this.chunk = chunk;
	}		

	/**
	 * Ielasa čunku/teikumu no XML
	 * 
	 * @param text   Teikuma teksts
	 * @param node     XML node ar teikuma datiem
	 */
	public Chunk(TextData text, Node node) {
		this.text = text;
		
		if (node.getNodeName().equalsIgnoreCase("Čunks")) {  // Anotatora paša XML formāts
			chunk = node.getTextContent().trim();
	
			NodeList nodes = node.getChildNodes();
			for (int i = 0; i < nodes.getLength(); i++) {
				Node n = nodes.item(i);
				if (n.getNodeName().equalsIgnoreCase("ČunkaVariants")) {
					variants.add(new ChunkVariant(this, n));
				}
			}
	
			Node n = node.getAttributes().getNamedItem("irNočunkots");
			if (n != null)
				isChunkingDone = Boolean.parseBoolean(n.getTextContent());
			n = node.getAttributes().getNamedItem("irSadalītsVārdos");
			if (n != null)
				isTokenized = Boolean.parseBoolean(n.getTextContent());
			
			n = node.getAttributes().getNamedItem("aktuālaisVariants");
			if (n != null)
				setCurrentVariant(Integer.parseInt(n.getTextContent()));
		} else throw new Error("Node " + node.getNodeName() + " nav anotatora XML Čunks");
	}

	/**
	 * Ielasa čunku/teikumu no PML formāta
	 * 
	 * @param text   Teikuma teksts
	 * @param node     XML node no 'm' faila ar teikuma datiem
	 * @param wfile		vārdu ID atbilstošie ieraksti no wfaila 
	 */
	public Chunk(TextData text, Node node, Map<String, Node> wfile) {
		this.text = text;
		
		if (node.getNodeName().equalsIgnoreCase("s")) {  // PML formāts
			LinkedList<Word> tokens = new LinkedList<Word>();
			chunk = "";
			boolean needsspace = false;
			
			NodeList nodes = node.getChildNodes();
			for (int i = 0; i < nodes.getLength(); i++) {
				Node n = nodes.item(i);
				if (n.getNodeName().equalsIgnoreCase("m")) {
					if (needsspace) chunk = chunk+" ";
					needsspace = true;
					
					String token = null;
					String tag = null;
					String lemma = null;
					String w_id = null;
					NodeList nodes2 = n.getChildNodes();
					for (int i2 = 0; i2 < nodes2.getLength(); i2++) {
						Node n2 = nodes2.item(i2);
						if (n2.getNodeName().equalsIgnoreCase("form")) token = n2.getTextContent();
						if (n2.getNodeName().equalsIgnoreCase("lemma")) lemma = n2.getTextContent();
						if (n2.getNodeName().equalsIgnoreCase("tag")) tag = n2.getTextContent();
						if (n2.getNodeName().equalsIgnoreCase("w.rf")) w_id = n2.getTextContent().substring(2); // removes leading 'w#' from the id
					}
					if (token == null || tag == null || lemma == null) throw new Error("Not enough data in word 'm' element "+n.getTextContent());
					
					Word vārds = text.morphoAnalyzer.analyze(token);
					boolean goodOption = false;
					for (Wordform wf: vārds.wordforms) {
						if (tag.equalsIgnoreCase(wf.getTag()) && lemma.equalsIgnoreCase(wf.getValue(AttributeNames.i_Lemma))) {
							goodOption = true;
							vārds.setCorrectWordform(wf);
						}
					}
					if (!goodOption) {
						Wordform pareizā = new Wordform(token);
						pareizā.addAttributes(MarkupConverter.fromKamolsMarkup(tag));
						pareizā.addAttribute(AttributeNames.i_Lemma, lemma);
						vārds.addWordform(pareizā);
						vārds.setCorrectWordform(pareizā);
					}
					
					tokens.add(vārds);
					if (wfile != null && w_id != null) {
						Node w_node = wfile.get(w_id); 
						if (w_node != null)
							for (int k = 0; k < w_node.getChildNodes().getLength(); k++) {
								Node n3 = w_node.getChildNodes().item(k);
								if (n3.getNodeName().equals("token")) chunk = chunk + n3.getTextContent();
								if (n3.getNodeName().equals("no_space_after")) needsspace = false;
							}
						else chunk = chunk + token;
					} else chunk = chunk + token;
				}
			}
			
			currentVariant = new ChunkVariant(this, tokens);
			variants.add(currentVariant);
			
			if (text.getWordModel() != null && currentVariant.tokens.size() > 0)
				text.getWordModel().setVārds(currentVariant.tokens.get(0) );
			currentVariant.setFirstToken();
			
			isTokenized = true;
			isChunkingDone = false; //FIXME - jāčeko a-fails, to arī varētu ielasīt
		} else throw new Error("Node " + node.getNodeName() + " nav anotatora XML Čunks, nedz PML formāta <s>");
	}

	/***
	 * Creates a Chunk object out of a sentence that is already tokenized and morphoanalyzed.
	 * Performs tagging if available.
	 * @param text
	 * @param sentence
	 */
	public Chunk(TextData text, List<Word> sentence) {
		this.text = text;
		String chunk_text = "";
		for (Word word : sentence) {
			if (!chunk_text.isEmpty()) chunk_text += " ";
			chunk_text += word.getToken();
		}
		this.chunk = chunk_text;
		
		List<Word> words;
		if (this.text.tageris != null) {
			List<CoreLabel> labeled_words = LVMorphologyReaderAndWriter.analyzeSentence2(sentence);
			labeled_words = this.text.tageris.classify(labeled_words);
			words = new LinkedList<Word>();
			for (CoreLabel label : labeled_words) {
				String token = label.getString(TextAnnotation.class);
				if (token.contains("<s>")) continue;
				Word analysis = label.get(LVMorphologyAnalysis.class);
				Wordform maxwf = analysis.getMatchingWordform(label.getString(AnswerAnnotation.class), true);
				maxwf.addAttribute(AttributeNames.i_Tagged, AttributeNames.v_Yes);
				words.add(analysis);
			}
		} else words = sentence; 
			
		currentVariant = new ChunkVariant(this, words);
		variants.add(currentVariant);
		
		if (text.getWordModel() != null && currentVariant.tokens.size() > 0)
			text.getWordModel().setVārds(currentVariant.tokens.get(0));
		isTokenized = true;
		
		currentVariant.setFirstToken();				
	}

	/**
	 * Veic sintakses analīzi ar prologa čunkeri
	 * 
	 * @param morphoAnalyzer Morfoanalizatora objekts
	 * @param chunkerInterface Prologa interfeiss
	 */
	public void doChunking(Analyzer morphoAnalyzer, ChunkerInterface chunkerInterface) {
		if (!isTokenized || currentVariant == null)
			tokenize(morphoAnalyzer);
		
		if (chunkerInterface == null) {
			setCurrentVariant(0);
			isChunkingDone = true;
			return; //FIXME - nav nočekots, vai tas visu izdara ko vajag			
		}
		
		chunkerInterface.izdzēstAtabulu();
		String čunkošanai = "";
		
		LinkedList<String> jauPieliktie = new LinkedList<String>();
		for (Word vārds : currentVariant.tokens) {
			if (!vārds.hasAttribute(SpecificAttributeNames.i_XWord, AttributeNames.v_Yes))
				try {				
					if (čunkošanai.length()>0) čunkošanai = čunkošanai + " ";
					čunkošanai = čunkošanai + vārds.getToken();
					
					if (!jauPieliktie.contains(vārds.getToken())) 
						chunkerInterface.pieliktVārdu(MarkupConverter.wordToChunkerFormat(vārds, true));
					jauPieliktie.add(vārds.getToken());				
				} catch (Exception e) {
					e.printStackTrace();
				}
		}		
		
		if (čunkošanai.isEmpty()) {
			isChunkingDone = true;
			return;
		}
		
		Cursor hourglassCursor = new Cursor(Cursor.WAIT_CURSOR);
		Cursor normalCursor = new Cursor(Cursor.DEFAULT_CURSOR);
		if (text.parent != null) {
			text.parent.setCursor(hourglassCursor);
			text.parent.getGlassPane().setCursor(Cursor.getPredefinedCursor(Cursor.WAIT_CURSOR));
			text.parent.getGlassPane().setVisible(true);
		}		

		variants.clear();
		ArrayList<ChunkerVariant> č_varianti = chunkerInterface.parse(čunkošanai);
		//TODO - moš ar tukšo sākotnējo variantu kautkas jāizdara
		for (ChunkerVariant čv : č_varianti) {
			variants.add(new ChunkVariant(this, čv, currentVariant.getTokens()));
		}
		
		if (text.parent != null) {
			text.parent.setCursor(normalCursor);
			text.parent.getGlassPane().setCursor(Cursor.getPredefinedCursor(Cursor.DEFAULT_CURSOR));
			text.parent.getGlassPane().setVisible(false);			
		}
		
		setCurrentVariant(0);
		text.dataHasChanged(); //TODO - vai vajag, vai nedublējas?
		isChunkingDone = true;
	}

	void tokenize(Analyzer morphoAnalyzer) {
		if (isTokenized) throw new Error("Ir jau sadalīts vārdos");
		variants.clear();
		
		List<Word> words;
		if (this.text.tageris != null) {
			List<CoreLabel> labeled_words = LVMorphologyReaderAndWriter.analyzeSentence(chunk);
			labeled_words = this.text.tageris.classify(labeled_words);
			words = new LinkedList<Word>();
			for (CoreLabel label : labeled_words) {
				String token = label.getString(TextAnnotation.class);
				if (token.contains("<s>")) continue;
				Word analysis = label.get(LVMorphologyAnalysis.class);
				Wordform maxwf = analysis.getMatchingWordform(label.getString(AnswerAnnotation.class), true);
				maxwf.addAttribute(AttributeNames.i_Tagged, AttributeNames.v_Yes);
				words.add(analysis);
			}
		} else words = Splitting.tokenize(morphoAnalyzer, chunk); 
			
		currentVariant = new ChunkVariant(this, words);
		variants.add(currentVariant);
		
		if (text.getWordModel() != null && currentVariant.tokens.size() > 0)
			text.getWordModel().setVārds(currentVariant.tokens.get(0));
		isTokenized = true;
		
		currentVariant.setFirstToken();
	}
	
	/***
	 * Marks all the wordforms suggested by the tagger as the correct options 
	 */
	public void applyTaggedWordforms() {
		for (Word w : currentVariant.tokens) {
			for (Wordform wf : w.wordforms) {
				if (wf.isMatchingStrong(AttributeNames.i_Tagged, AttributeNames.v_Yes)) {
					w.setCorrectWordform(wf);
				}
			}
		}
	}

	public String getSentence() {
		return chunk;
	}
		
	public void toXML(Writer stream) throws IOException {
		stream.write("<Čunks");
		stream.write(" irNočunkots=\""+isChunkingDone+"\"");
		stream.write(" irSadalītsVārdos=\""+isTokenized+"\"");
		if (currentVariant != null)
			stream.write(" aktuālaisVariants=\""+variants.indexOf(currentVariant)+"\"");
		stream.write(">\n");
		for (ChunkVariant var : variants) {
			var.toXML(stream);
		}
		
//		if (pareizaisČunkotājaVariants > 0)
//			č_varianti.get(pareizaisČunkotājaVariants-1).uzXML(straume);
		//FIXME - seivošana jāpārskata
		stream.write(chunk.replace("\"", "&quot;"));
		stream.write("</Čunks>\n");
	}

	public boolean isChunkingDone() {
		return isChunkingDone;
	}

	public void setChunkingDone(boolean b) {
		this.isChunkingDone = b;
	}

	public void redoChunking() {
		setSentence(chunk);
	}

	public void setSentence(String chunk) {
		this.chunk = chunk;
		
		variants.clear();
		//TODO - ja ir kautkas darīts esošajā, tad varbūt jāpārnes uz jauno...
		
		currentVariant = null;
		isChunkingDone = false;
		isTokenized = false;
				
		if (text.getCurrentChunk() == this) {
			//refreshojamies 
			doChunking(text.morphoAnalyzer, text.chunkerInterface);
		}
		
		text.dataHasChanged();
	}
	
	/** 
	 * Vai čunks ir iesākts marķēt 
	 * @return
	 */
	public boolean inProgress() {
		if (currentVariant == null) return false;
		return (currentVariant.getCurrentToken() != null);
	}
	
	public boolean isFinished() {
		return this.isChunkingDone() && !this.inProgress();
	}
	
	public void setText(TextData text) {
		this.text = text;
	}

	public TextData getText() {
		return text;
	}

	public void setCurrentVariant(int variantNo) {
		if (variantNo<0 || variantNo >= variants.size()) return;
		
		currentVariant = variants.get(variantNo);
		
		text.dataHasChanged();
	}

	public void previousVariant() {
		if (variants.indexOf(currentVariant) > 0)
			setCurrentVariant(variants.indexOf(currentVariant) - 1);
	}

	public void nextVariant() {
		if (variants.indexOf(currentVariant) < variants.size() - 1)
			setCurrentVariant(variants.indexOf(currentVariant) + 1);
	}
	
	public String getVariantNo() {
		return String.format("%d/%d" , variants.indexOf(currentVariant)+1, variants.size());
	}
	
	public void addListener(ActionListener actionListener) {
		changeListeners.add(actionListener);
	}
	
	public void removeListener(ActionListener actionListener) {
		changeListeners.remove(actionListener);
	}
	
	public void notifyListeners(){
		for (ActionListener actionListener : changeListeners) 
			actionListener.actionPerformed(null);
	}
}
