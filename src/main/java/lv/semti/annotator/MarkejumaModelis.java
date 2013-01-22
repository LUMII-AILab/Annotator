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

import java.awt.Color;
import java.util.ArrayList;
import java.util.Date;
import java.util.Map.Entry;

import javax.swing.JOptionPane;
import javax.swing.table.AbstractTableModel;

import lv.semti.annotator.syntax.*;
import lv.semti.morphology.analyzer.*;
import lv.semti.morphology.attributes.*;

@SuppressWarnings("serial")
public class MarkejumaModelis extends AbstractTableModel {
	
	private String[] columnNames = {"Npk.","Vārds","Marķējums","Pamatforma","Loma", "Paskaidro"};
	private TextData teksts = null;
	private Chunk rādāmaisČunks = null;

    public void setTeksts(TextData teksts) {
		if (this.teksts != null) 
			this.teksts.removeModel(this);

		this.teksts = teksts;
		rādāmaisČunks = null;
		teksts.addModel(this);
		fireTableDataChanged();
	}

	@Override
	public String getColumnName(int col) {
        return columnNames[col].toString();
    }
    
    //@Override
    public int getColumnCount() { return columnNames.length; }

    public int getRowCount() { 
    	if (teksts == null) return 0;
    	
		ArrayList<Chunk> čunkliste;
		if (rādāmaisČunks == null) čunkliste = teksts.getChunkList();
		else {
			čunkliste = new ArrayList<Chunk>();
			čunkliste.add(rādāmaisČunks);
		}
    	
    	int rindas = 0;
    	for (Chunk čunks : čunkliste) {
    		if (čunks.currentVariant != null)
	    		for (@SuppressWarnings("unused") Word vārds : čunks.currentVariant.getTokens()) {
	//    			if (vārds.getPareizāVārdforma() != null)
	    				rindas++;
	    		}
    	}
    	    	
    	return rindas;
    }
    
    @Override
	public boolean isCellEditable(int row, int col) {
    	if (teksts == null) return false;
    	if (col <= 1 || row < 0 || col == 5) return false;

    	Word apskatāmais = rindasVārds(row);    	
    	if (apskatāmais == null) return false;    	       
        return (apskatāmais.getCorrectWordform() != null || col != 3);
    }

	//@Override
	public Object getValueAt(int row, int col) {
    	if (teksts == null) return null;

    	Word apskatāmais = rindasVārds(row);
    	Chunk apskatāmaisČunks = rindasČunks(row);
    	if (apskatāmais == null) return null;
    	
    	if (apskatāmais.getCorrectWordform() == null && (col == 2 || col == 3)) return null;
    	
    	switch (col) {
    	case 0 : return row+1;
    	case 1 : return apskatāmais.getToken();
    	case 2 : return apskatāmais.getCorrectWordform().getTag();
    	case 3 : return apskatāmais.getCorrectWordform().getValue(AttributeNames.i_Lemma);
    	case 4 : return apskatāmaisČunks.currentVariant.getDependencyRole(apskatāmais);    	
    	case 5 : {
    		Word koPaskaidro = apskatāmaisČunks.currentVariant.getDependencyHead(apskatāmais);
    		if (koPaskaidro == null) return null;    	
    		return koPaskaidro.getToken();
    	}
    	default : return null;
    	}

	}
	
    @Override
	public void setValueAt(Object value, int row, int col) {
    	if (teksts == null) return;

    	Word apskatāmais = rindasVārds(row);
    	Chunk apskatāmaisČunks = rindasČunks(row);
    	if (apskatāmais == null) return;
    	if (apskatāmais.getCorrectWordform() == null && col == 3) return;
    	if (col == 5) return;

    	try {
			switch (col) {
			case 0 : return; //TODO var jau arī suportēt vārda rediģēšanu no šejienes
			case 1 : return; 
	    	case 2 :
	    		try { 
	    			AttributeValues īpašības = MarkupConverter.fromKamolsMarkup(value.toString());
	    			
		    		String pamatforma = apskatāmais.getCorrectWordform().getValue(AttributeNames.i_Lemma);
		    		String loma = apskatāmais.getCorrectWordform().getValue("Loma");
		    		apskatāmais.getCorrectWordform().clear();
		    		
		    		//apskatāmais.getCorrectWordform().addAttribute(AttributeNames.i_Tag,value.toString());
		    		apskatāmais.getCorrectWordform().addAttributes(īpašības);
		    		apskatāmais.getCorrectWordform().addAttribute(AttributeNames.i_Source,String.format("Lietotājs mainīja marķējumu %tF", new Date()));
		    		apskatāmais.getCorrectWordform().addAttribute(AttributeNames.i_Lemma,pamatforma);	    				    			    		
		    		apskatāmais.getCorrectWordform().addAttribute(AttributeNames.i_Role,loma);
	    		} catch (Exception E) {
	        		JOptionPane.showMessageDialog(null, "Nekorekts marķējums!");
	        	}
	    		
	    		break;
	    	case 3 : 
	    		apskatāmais.getCorrectWordform().addAttribute(AttributeNames.i_Lemma,value.toString());
	    		break;
	    	case 4 : 
	    		apskatāmaisČunks.currentVariant.setDependencyRole(apskatāmais, value.toString()); 
	    		break;
	    	default : return;
			}
    	} catch (Exception E) {
    		JOptionPane.showMessageDialog(null, "Nekorekts kautkas!");
    	}
    	
    	fireTableCellUpdated(row, col);
    }

	private Word rindasVārds(int row) {
		Word apskatāmais = null;
		
		ArrayList<Chunk> čunkliste;
		if (rādāmaisČunks == null) čunkliste = teksts.getChunkList();
		else {
			čunkliste = new ArrayList<Chunk>();
			čunkliste.add(rādāmaisČunks);
		}
		
		int rinda = 0;
		ārējais:
    	for (Chunk čunks : čunkliste) {
    		//FIXME - lēns!! neskeilosies lielam marķētam tekstam.
    		if (čunks.currentVariant != null)
	    		for (Word vārds : čunks.currentVariant.getTokens()) {
					if (rinda == row) {
						apskatāmais = vārds;
						break ārējais;
					}
					rinda++;
	    		}
    	}
		return apskatāmais;
	}    
    
	public String getToolTip(int row) {
		Word apskatāmais = rindasVārds(row);
		if (apskatāmais == null) return null;
		if (apskatāmais.getCorrectWordform() == null) return null;
    	
    	Wordform vārdforma = apskatāmais.getCorrectWordform();
    	String īpašības = "";
    	for (Entry<String,String> pāris : vārdforma.entrySet()) 
			īpašības = īpašības + pāris.getKey() + " = " + pāris.getValue() + "\n";
		
		return īpašības;
	}
	
	public Color getColor(int row) {
    	if (teksts == null) return Color.white;

      	Word apskatāmais = rindasVārds(row);
      	
    	if (apskatāmais == null) return Color.white;
    	if (teksts.getCurrentChunk().currentVariant.getCurrentToken()==apskatāmais) return Color.green; 

		if (apskatāmais.wordforms.size() == 0) return Color.white;
    	Wordform pirmā = apskatāmais.wordforms.get(0);
		return (pirmā.isMatchingStrong("X-vārds", "Jā")) ? Color.yellow : Color.white; 		
	}

	public void setČunks(Chunk čunks) {
		this.rādāmaisČunks = čunks;
		this.fireTableStructureChanged();
	}

	public void atkārtotVārdaMarķēšanu(int row) {
		ArrayList<Chunk> čunkliste;
		if (rādāmaisČunks == null) čunkliste = teksts.getChunkList();
		else {
			čunkliste = new ArrayList<Chunk>();
			čunkliste.add(rādāmaisČunks);
		}
		
		int rinda = 0;
    	for (Chunk čunks : čunkliste) {
    		//FIXME - lēns!! neskeilosies lielam marķētam tekstam.
    		if (čunks.currentVariant != null) 
	    		for (Word vārds : čunks.currentVariant.getTokens()) {
	    			if (rinda == row) {
	    				čunks.currentVariant.setCurrentToken(vārds);
	    				teksts.setCurrentChunk(čunks);
	    				return;
	    			}
	    			rinda++;
	    		}
    		else System.err.println("Čunka currentVariant ir null, nav labi");
    	}
	}

	
	private Chunk rindasČunks(int row) {
		Chunk apskatāmais = null;
		
		ArrayList<Chunk> čunkliste;
		if (rādāmaisČunks == null) čunkliste = teksts.getChunkList();
		else {
			čunkliste = new ArrayList<Chunk>();
			čunkliste.add(rādāmaisČunks);
		}
		
		int rinda = 0;
		ārējais:
    	for (Chunk čunks : čunkliste) {
    		//FIXME - lēns!! neskeilosies lielam marķētam tekstam.
    		if (čunks.currentVariant != null)
	    		for (@SuppressWarnings("unused") Word vārds : čunks.currentVariant.getTokens()) {
					if (rinda == row) {
						apskatāmais = čunks;
						break ārējais;
					}
					rinda++;
	    		}
    		else System.err.println("Čunka currentVariant ir null, nav labi");
    	}
		return apskatāmais;
	}    

}
