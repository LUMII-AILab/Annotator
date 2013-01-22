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
import java.awt.Component;
import java.awt.event.MouseEvent;

import javax.swing.JButton;
import javax.swing.JTable;
import javax.swing.ListSelectionModel;
import javax.swing.table.AbstractTableModel;
import javax.swing.table.TableCellRenderer;

@SuppressWarnings("serial")
public class MTable extends JTable {
	private MainFrame parent;

	public MTable(AbstractTableModel mdlVIinfo, MainFrame parent) {
		this.setModel(mdlVIinfo);
		this.parent = parent;
		this.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
		
		TableCellRenderer defaultRenderer = null;
		defaultRenderer = this.getDefaultRenderer(JButton.class);
	    this.setDefaultRenderer(JButton.class,
				       new JTableButtonRenderer(defaultRenderer));

	}

	@Override
	public String getToolTipText(MouseEvent e) {
		if (columnAtPoint(e.getPoint()) == 0) return null;
		String tooltip = parent.vārdinfoModelis.getToolTip(this.convertRowIndexToModel(rowAtPoint( e.getPoint())));			
		
		if (tooltip != null)
			tooltip = "<html>"+tooltip.replaceAll("\n", "<br>")+"</html>";
		return tooltip;
	}

	class JTableButtonRenderer implements TableCellRenderer {
		//kopēts no web
		  private TableCellRenderer __defaultRenderer;

		  public JTableButtonRenderer(TableCellRenderer renderer) {
		    __defaultRenderer = renderer;
		  }

		  public Component getTableCellRendererComponent(JTable table, Object value,
								 boolean isSelected,
								 boolean hasFocus,
								 int row, int column)
		  {
		    if(value instanceof Component)
		      return (Component)value;
		    return __defaultRenderer.getTableCellRendererComponent(
			   table, value, isSelected, hasFocus, row, column);
		  }
		}

	
	@Override
	public Component prepareRenderer
    (TableCellRenderer renderer,int Index_row, int Index_col) {
		VardinfoModel mdl = (VardinfoModel) this.getModel();
		if (mdl == null) return null;
		
        Component comp = super.prepareRenderer(renderer, Index_row, Index_col);
        if (!isCellSelected(Index_row, Index_col))			     
        	comp.setBackground( mdl.getColor( this.convertRowIndexToModel(Index_row)) ); 	
        if (Index_col == 0)	comp.setBackground(Color.lightGray);
		return comp;
	}
	
}

