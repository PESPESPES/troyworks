package com.troyworks.controls.tautocomplete { 

	/**
	 * @author Troy Gardner
	 */
	public class AutoCompleteDataItem {
		public var abbreviation:String;
		public var name:String;
		public var data:Object;
		public var presentor:Object;
		
		public function AutoCompleteDataItem(name:String, data:Object, abbrev:String) {
			this.name = name;
			this.data = data;
			 this.abbreviation = abbrev;
			
		}
	 
	}
}