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
package lv.semti.annotator.lexiconeditor;

import javax.swing.DefaultCellEditor;
import javax.swing.JComboBox;
import javax.swing.JTable;
import javax.swing.table.TableCellEditor;

import lv.semti.morphology.attributes.TagSet;
import lv.semti.morphology.lexicon.TableModels.AttributeModel;

@SuppressWarnings("serial")
public class IpasibuTable extends JTable{
	private AttributeModel attributeModel;
	
	public IpasibuTable(AttributeModel tableModel) {
		super(tableModel);
		attributeModel = tableModel;
	}

	@Override
	public TableCellEditor getCellEditor(int row, int col)
	{
		Object[] comboboxValues = null;
		if (col == 0) comboboxValues = TagSet.getTagSet().allowedAttributes("LV").toArray();  
		if (col == 1) {
			String attribute = attributeModel.getAttribute(row);
			comboboxValues = TagSet.getTagSet().getAllowedValues(attribute, "LV");
		}
			
		if (comboboxValues == null)
			return super.getCellEditor(row,col);
		
		return new DefaultCellEditor(new JComboBox(comboboxValues));		
	}

}
