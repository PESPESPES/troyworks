package com.troyworks.apps.semantica {
	import com.troyworks.framework.BaseObject;
	import flash.utils.getQualifiedClassName; 

	/**
	 * Fowl is a a flash based port of the OWL ontology, with support for fuzzy concepts
	 * and semantic (heirarchical tagging)
	 * 
	 * @author Troy Gardner
	 */
	public class FowlBaseObject extends BaseObject {
		public var name:String;
		public var tag:String;
		public function FowlBaseObject(name:String) {
			super();
			name = name;
			tag= String(name);
		}
		override public function toString():String{
			return getQualifiedClassName(this) + " " + tag;
		}
	}
}