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
import javax.swing.table.AbstractTableModel;

import lv.semti.annotator.syntax.TextData;

@SuppressWarnings("serial")
public class CunkuModelis extends AbstractTableModel {
	String[] columnNames = {"Fragmenti"};
	TextData teksts = null;

    public void setTeksts(TextData teksts) {
		if (this.teksts != null) 
			this.teksts.removeModel(this);

		this.teksts = teksts;
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
    	return teksts.getChunksCount();
    }
    
    @Override
	public boolean isCellEditable(int row, int col) {
    	if (teksts == null) return false;
    	return true;
    }

	//@Override
	public Object getValueAt(int row, int col) {
    	if (teksts == null) return null;

    	switch (col) {
    	case 0 : return teksts.getChunk(row).getSentence();
    	default : return null;
    	}

	}
	
    @Override
	public void setValueAt(Object value, int row, int col) {
    	if (teksts == null) return;

		switch (col) {
		case 0 : 
			if (!teksts.getChunk(row).getSentence().equals(value.toString()))
				teksts.getChunk(row).setSentence(value.toString()); 
			break;
    	default : return;
		}
    	
    	fireTableCellUpdated(row, col);
    }    
    	
	public Color getColor(int row) {
    	if (teksts == null) return Color.white;
    	if (row == teksts.getCurrentChunkNo()) return Color.green;
    	if (teksts.getChunk(row).isChunkingDone()) 
    		return (teksts.getChunk(row).inProgress()) ? Color.yellow : Color.lightGray;
    	return Color.white;
	}

}
