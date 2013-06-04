package lv.semti.annotator.syntax;
/*
 *******************************************************************************
 * Copyright 2008-2011 Institute of Mathematics and Computer Science, University of Latvia;
 * Author: Lauma Pretkalniņa
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

import java.util.HashMap;

/**
 * Transforms locally used roles to the PML roles.
 * @author lauma
 */
public class RoleTransformator {

	private HashMap <String, String> roleMapping;
	private HashMap <String, String> xRoleMapping;
	
	public RoleTransformator()
	{
		roleMapping = new HashMap <String, String>();
		// TODO atrast kur tās teksta konstantes ir, un uztaisīt, kā minimums, konstanšu klasi. /Lauma
		// From def-b-vpt.pl
		roleMapping.put("laika apstāklis", "adv");
		roleMapping.put("veida apstāklis", "adv");
		roleMapping.put("vietas apstāklis", "adv");
		roleMapping.put("netiešais papildinātājs", "obj");
		roleMapping.put("apzīmētājs", "attr");

		roleMapping.put("apstāklis", "adv");
		roleMapping.put("cēloņa apstāklis", "adv");
		roleMapping.put("mēra apstāklis", "adv");
		roleMapping.put("nolūka apstāklis", "adv");
		
		roleMapping.put("tiešais papildinātājs", "obj");
		roleMapping.put("teikuma priekšmets", "subj");
		roleMapping.put("spk", "spc");
		roleMapping.put("izteicējs", "pred");
		
		// Aditional
		roleMapping.put("papildinātājs", "obj");
		
		// From def-x-vpt.pl
		roleMapping.put("prievārdeklis", "xPrep");
		roleMapping.put("skaitlis", "xNum");
		roleMapping.put("apvienojums", "crdParts");
		roleMapping.put("quot", "quot");
		
		// From def-x-plt.pl
		roleMapping.put("plt", "subrCl");
		
		//From def-x-ref.pl
		roleMapping.put("pusprievārds", "xPrep");
		
		xRoleMapping = new HashMap<String, String>();
		
		xRoleMapping.put("izteicējs", "xPred");
		xRoleMapping.put("simile", "xSimile");
		xRoleMapping.put("spk", "spcPmc");
		xRoleMapping.put("named_entity", "namedEnt");
		xRoleMapping.put("pielikums", "xApp");
		
	}
	
	/**
	 * Transforms locally used role to PML role.
	 * @param localRole	local role, like "teikuma priekšmets"
	 * @return	role suitable for PML-A.
	 */
	private String transform(String localRole)
	{
		if (localRole == null) return "N/A";
		localRole = localRole.trim();
		if (roleMapping.containsKey(localRole))
			return roleMapping.get(localRole);
		if (!localRole.equals("")) {
			//System.err.println("RoleTransformator could not transform \"" + localRole + "\"");
			new Throwable().printStackTrace();
			System.err.println("RoleTransformator could not transform \"" + localRole + "\"");
		}
		return "N/A";
	}
	
	/**
	 * Transforms locally used role to PML role.
	 * @param localRole	local role, like "teikuma priekšmets"
	 * @param context	usage context describing what kind of role (xtype,
	 * 					pmctype or dependency role) needs to be obtained.
	 * @return	role suitable for PML-A.
	 */
	public String transform (String localRole, PMLRelTypes context)
	{
		switch (context)
		{
			case X:	if (xRoleMapping.containsKey(localRole)) return xRoleMapping.get(localRole); //break; missing on purpose
			default: return transform(localRole);
		}
	}
}
