package com.troyworks.util.codeGen.model { 
	/**
	 * @author Troy Gardner
	 */
	public class CodeClass {
		public var package:CodePackage;
	//--------------------------------------
		public var implementz:Array = new Array();
			public var extendz:Array = new Array(); 
		 
	//----------------------------------------------	
		public var attributes:Array = new Array(); 
		public var methods:Array = new Array();
		public var states:Array = new Array();
	
		protected var className : Object;
		
		
		public function CodeClass() {
			
		}
		public function addPublicAttribute(name:String, type:String):void{
			var ca:CodeAttribute = new CodeAttribute();
			ca.name = name;
			ca.type = type;
			ca.visibility = CodeVisibility.PUBLIC;
			attributes.push(ca);
		}
		public function addPrivateAttribute(name:String, type:String):void{
			var ca:CodeAttribute = new CodeAttribute();
			ca.name = name;
			ca.type = type;
			ca.visibility = CodeVisibility.PRIVATE;
			attributes.push(ca);
			
		}
		
		public function toArray():Array{
			var res:Array = new Array();
			
			res.push("/***************************************");
			res.push("* Translated by CodeGen");
			res.push("*/");
			res.push("class "+package + className + "{");
			return res;
		}
	}
}