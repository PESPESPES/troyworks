/**
* A range filter is operates with a minimum and maximum bounds, by default inclusive,
* e.g. 3-8 filter  0123456789012345678
*      *inclusive  ---[PASS]----------
*       exclusive  ---]PASS[----------
*        
* this is designed to be subclassed by filters that do appropriate datatype range. 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.data.filters {

	public class RangeFilter extends Filter{
		
		public static const ANY : String = "**";
		public static const LESS_THAN : String = "<";
		public static const LESS_THAN_OR_EQUAL_TO : String = "<=";
		public static const EQUAL_TO : String = "==";
		public static const NOT_EQUAL_TO : String = "!=";
		public static const GREATER_THAN_OR_EQUAL_TO : String = ">=";
		public static const GREATER_THAN : String = ">";
		
		public var minRelationToMin : String = ANY;
		public var minRelationToMax : String = ANY;

		public var maxRelationToMin : String = ANY;
		public var maxRelationToMax : String = ANY;
		
		public var minI:Boolean = false;
		public var maxI:Boolean = false;
		
		public function RangeFilter(minInclusive:Boolean = true, maxInclusive:Boolean = true) {
			super();
			minI = minInclusive;
			maxI = maxInclusive;
		}
		
	}
	
}
