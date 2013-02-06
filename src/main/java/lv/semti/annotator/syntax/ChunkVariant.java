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
package lv.semti.annotator.syntax;

import java.io.IOException;

import java.io.Writer;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import lv.semti.PrologInterface.ChunkerVariant;
import lv.semti.PrologInterface.SpecificAttributeNames;
import lv.semti.PrologInterface.WordDescription;
import lv.semti.morphology.analyzer.MarkupConverter;
import lv.semti.morphology.analyzer.Word;
import lv.semti.morphology.analyzer.Wordform;
import lv.semti.morphology.attributes.AttributeNames;

/**
 * Syntax tree (chunk) as object-based data structure.
 */
public class ChunkVariant {
	private class Dependency{
		Word dependant = null;
		Word head = null;
		String role = null;
		
		Dependency(Word dependant, Word dependencyHead, String role) {
			this.dependant = dependant;
			this.head = dependencyHead;
			this.role = role;
			if (this.role == null) this.role = "";
		}
		
		/**
		 * Meaningful comparison.
		 */
		@Override
		public boolean equals(Object o)
		{
			try
			{
				Dependency d = (Dependency)o;
				if (dependant == null ^ d.dependant == null 
						|| head == null ^ d.head == null
						|| role == null ^ d.role == null) return false;
				return (dependant == d.dependant ||dependant.equals(d.dependant))
					&& (head == d.head || head.equals(d.head))
					&& (role == d.role || role.equals(d.role));
			} catch (ClassCastException e)
			{
				return false;
			}
		}
		@Override
		public int hashCode()
		{
			return (getClass().getCanonicalName() + dependant + head + role)
				.hashCode();
		}		
	}
	
	/**
	 * List of all tokens of the chunk.
	 */
	List<Word> tokens;
	/**
	 * Mapping from dependants to dependency objects.
	 */
	Map<Word, Dependency> dependencies = new HashMap<Word, Dependency>();
	/**
	 * Mapping form dependency heads to dependency children.
	 */
	Map<Word, LinkedHashSet<Word>> children = new HashMap<Word, LinkedHashSet<Word>>();
	
	public Chunk chunk = null;
	private Word currentToken = null;
	
	ChunkerVariant chunkerVariant = null; //vai vajag?
	
	/***
	 * Loads from Annotator's own XML data format
	 * @param chunk
	 * @param node
	 */
	public ChunkVariant(Chunk chunk, Node node) {		
		if (!node.getNodeName().equalsIgnoreCase("ČunkaVariants")) 
			throw new Error("Node " +node.getNodeName() + " nav ČunkaVariants"); 
		
		this.chunk = chunk;
		this.tokens = new LinkedList<Word>();
		
		NodeList nodes = node.getChildNodes();

		for (int i = 0; i < nodes.getLength(); i++) {
			Node n = nodes.item(i);
			if (n.getNodeName().equalsIgnoreCase("Vārds")) {
				tokens.add(new Word(n));
			}
		}

		for (int i = 0; i < nodes.getLength(); i++) {
			Node n = nodes.item(i);
			if (n.getNodeName().equalsIgnoreCase("Paskaidrojums")) {
				//FIXME pagaidām nečekojam vai tāds attribūts ir vai nav
				Word kas = tokens.get(Integer.parseInt(n.getAttributes().getNamedItem("kasPaskaidro").getTextContent()));
				Word ko = tokens.get(Integer.parseInt(n.getAttributes().getNamedItem("koPaskaidro").getTextContent()));
				String loma = n.getAttributes().getNamedItem("loma").getTextContent();
				dependencies.put(kas, new Dependency(kas, ko, loma));
				LinkedHashSet<Word> dep = children.get(ko) != null
						? children.get(ko) : new LinkedHashSet<Word>();
				dep.add(kas);
				children.put(ko, dep);
				
			}
		}
		
		Node n = node.getAttributes().getNamedItem("aktuālaisVārds");
		if (n != null)
			currentToken = tokens.get(Integer.parseInt(n.getTextContent()));
	}
	
	public ChunkVariant(Chunk chunk, List<Word> tokens) {
		this.chunk = chunk;
		this.tokens = tokens;
	}

	/**
	 *  Nodzēš lieko sintaksi - vecos x-vārdus 
	 */
	private void izmestXvārdus(List<Word> tokens) {
		LinkedList<Word> izmetamie = new LinkedList<Word>();
		
		for (Word vārds : tokens) 
			//if (vārds.irĪpašība("X-vārds", "Jā"))
			if (vārds.hasAttribute(SpecificAttributeNames.i_XWord, AttributeNames.v_Yes))
				izmetamie.add(vārds);
		
		for (Word izmetamais : izmetamie)
			tokens.remove(izmetamais);
	}
	
	public ChunkVariant(Chunk chunk, ChunkerVariant chunkerVariant, List<Word> cleanTokens) {
		this.chunk = chunk;
		this.chunkerVariant = chunkerVariant;
		tokens = new LinkedList<Word>();

		// Creation of nodes for tokens.
		for (Word w : cleanTokens) {
			tokens.add((Word) w.clone());
		}
		izmestXvārdus(tokens);  
		
		int wordId = 0;
		// Creation of nodes for x-words.
		for (WordDescription wordDescription : chunkerVariant.getVārdi()) {
			if (wordDescription.isXWord()) {
				Word newWord = new Word(wordDescription.getForm());
				Wordform newWordform = new Wordform(wordDescription.getForm());
				newWordform.addAttribute(SpecificAttributeNames.i_XWord, AttributeNames.v_Yes);
				newWord.addWordform(newWordform);
				newWord.setCorrectWordform(newWordform);

				// This maintains the same order in tokens list as in chunkerVariant.getVārdi()
				tokens.add(wordId, newWord);				
			}
			wordId++;
		}	

		int wordDescId = 0;
		// Creation of tree edges.
		for (WordDescription wordDescription : chunkerVariant.getVārdi()) // Go through all Prolog terms describing the nodes. 
		{
			if (wordDescId >= tokens.size()) {
				System.err.printf("Problēmas ar worddescription tokeniem. Size = %d; mekleejamais id = %d.\n", tokens.size(), wordDescId);
				for (WordDescription wordDescription2 : chunkerVariant.getVārdi()) {
					System.err.printf("\tdescription: %s\tXword : %b\n", wordDescription2.getDescription(), wordDescription2.isXWord());
				}
				System.err.printf("Tokens:\n");
				for (Word token : tokens) {
					System.err.printf("\ttoken: %s\tXword :%b\n", token.getToken(), token.hasAttribute(SpecificAttributeNames.i_XWord, AttributeNames.v_Yes));
				}
				System.err.printf("Cleantokens:\n");
				for (Word token : cleanTokens) {
					System.err.printf("\ttoken: %s\tXword :%b\n", token.getToken(), token.hasAttribute(SpecificAttributeNames.i_XWord, AttributeNames.v_Yes));
				}
				break;
			}
				
			for (Wordform vārdforma : tokens.get(wordDescId).wordforms) // Go through all forms of the specified node.
			{
				//System.out.println(vārdforma.getToken());
				if (vārdforma.isMatchingWeak(MarkupConverter.fromKamolsMarkup(wordDescription.getTag()))
						|| wordDescription.isXWord())
				{						
					vārdforma.addAttribute(AttributeNames.i_Recommended, AttributeNames.v_Yes);
					vārdforma.addAttributes(MarkupConverter.fromKamolsMarkup(wordDescription.getTag()));
					if (!(wordDescription.getDependencyHead() == null))
					{
						Word kas = tokens.get(wordDescId);
						Word ko = tokens.get(chunkerVariant.getVārdi().indexOf(wordDescription.getDependencyHead()));
						dependencies.put(kas, 
								new Dependency(kas, ko, wordDescription.getRole()));
						LinkedHashSet<Word> dep = children.get(ko) != null
								? children.get(ko) : new LinkedHashSet<Word>();
						dep.add(kas);
						children.put(ko, dep);
					}
					tokens.get(wordDescId).dataHasChanged();
				}
				if (wordDescription.isPartOfXWord())
					vārdforma.addAttribute(SpecificAttributeNames.i_XPart, AttributeNames.v_Yes);
				//TODO - CHECK-ME
				if (wordDescription.isXWord() && wordDescription.getAdittionalTag() != null)
				{
					String xTag = wordDescription.getAdittionalTag();
					xTag = xTag.replace(" ", "");
					xTag = xTag.replace(",", "");
					vārdforma.addAttribute(
							SpecificAttributeNames.i_XTag, xTag);
					
				}	
			}
			wordDescId++;
		}

		setFirstToken();
		chunk.text.dataHasChanged();
	}

	public void toXML(Writer stream) throws IOException {
		stream.write("<ČunkaVariants");
		if (tokens.indexOf(currentToken) > -1) 
			stream.write(" aktuālaisVārds=\""+tokens.indexOf(currentToken)+"\"");
		stream.write(">");

		for (Word vārds : tokens) {
			vārds.toXML(stream);
			/*if (vārds.getPareizāVārdforma() != null)
				vārds.getPareizāVārdforma().uzXML(straume); TODO - apdomāt vai neseivot tikai pareizo*/
		}
		for (Dependency paskaidrojums : dependencies.values()) {
			stream.write("  <Paskaidrojums\n");
			stream.write("    kasPaskaidro=\"" + tokens.indexOf(paskaidrojums.dependant) + "\"\n");
			stream.write("    koPaskaidro=\"" + tokens.indexOf(paskaidrojums.head) + "\"\n");
			stream.write("    loma=\"" + paskaidrojums.role + "\"/>\n");
		}
		stream.write("</ČunkaVariants>\n");
	}

	public List<Word> getTokens() {
		return tokens;
	}
	
	public Word getDependencyHead(Word dependant) {
		Dependency paskaidrojums = dependencies.get(dependant);
		if (paskaidrojums == null) return null;
		return paskaidrojums.head;
	}
	
	public void setDependency(Word dependant, Word dependencyHead) {
		Dependency paskaidrojums = dependencies.get(dependant);
		if (paskaidrojums == null) {
			dependencies.put(dependant, 
					new Dependency(dependant, dependencyHead, ""));
		} else
		{
			// Drops out the old parent2child link.
			LinkedHashSet<Word> dep = children.get(paskaidrojums.head);
			if (dep != null) dep.remove(paskaidrojums.dependant);
			
			paskaidrojums.head = dependencyHead;
			
		}
		// Creates new parent2child link.
		LinkedHashSet<Word> dep = children.get(dependencyHead) != null
				? children.get(dependencyHead) : new LinkedHashSet<Word>();
		dep.add(dependant);
		children.put(dependencyHead, dep);
		
		chunk.text.dataHasChanged();
	}

	public String getDependencyRole(Word dependant) {
		Dependency paskaidrojums = dependencies.get(dependant);
		if (paskaidrojums == null) return "";
		return paskaidrojums.role;
	}

	public void setDependencyRole(Word dependant, String role) {
		Dependency paskaidrojums = dependencies.get(dependant);
		if (paskaidrojums != null)
			paskaidrojums.role = role;	
		chunk.text.dataHasChanged();
	}

	public void addToken(Word token) {
		tokens.add(token);		
	}
	
	public Word getCurrentToken() {
		return currentToken;
	}

	public boolean nextToken() {
		// false - ja nevar dabūt nākamo vārdu, jo ir beigas
		int nr = tokens.indexOf(currentToken);
		nr++;
		while (nr < tokens.size() && tokens.get(nr).getCorrectWordform() != null) {
			nr++;
		}

		if (nr < tokens.size()) {
			setCurrentToken(nr);
			return true;
		}
				
		setCurrentToken(null);
		return false;
	}
	
	public void setFirstToken() {
		int nr = 0;
		while (nr < tokens.size() && tokens.get(nr).getCorrectWordform() != null) 
			nr++;

		if (nr < tokens.size()) {
			setCurrentToken(nr);
			return;
		}				
		setCurrentToken(null);
	}

	public void setCurrentToken(Word token) {
		this.currentToken = token;
		if (chunk.text.getWordModel() != null)
			chunk.text.getWordModel().setVārds(this.getCurrentToken());
	}
	
	public void setCurrentToken(int tokenNo) {
		this.currentToken = tokens.get(tokenNo);
		if (chunk.text.getWordModel() != null)
			chunk.text.getWordModel().setVārds(this.getCurrentToken());
	}

	/**
	 * Finds all tokens which are not in any dependency as dependants.
	 * @return	set of all potential roots
	 */
	public HashSet<Word> findRoots()
	{
		HashSet<Word> res = new HashSet<Word>();
		res.addAll(tokens);
		for (HashSet<Word> wordSet : children.values())
		{
			res.removeAll(wordSet);
		}
		return res;
	}
}
