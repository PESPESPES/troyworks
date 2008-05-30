package com.troyworks.data { 
	/**************************************************
	 *  This class implements a typed enumeration 
	 *  basically a read only static value that is a number
	 *  but extended by type information, like name.
	 */
	public class TypedEnumeration extends Number
	{
		public static var NONE : TypedEnumeration = new TypedEnumeration(0, "NONE");
		public static var A : TypedEnumeration = new TypedEnumeration(1, "A");
		public static var B : TypedEnumeration = new TypedEnumeration(2, "B");
		public static var C : TypedEnumeration = new TypedEnumeration(4, "C");
		public static var ALL : TypedEnumeration = new TypedEnumeration(A|B|C, "ALL");
		protected var __name : String;
		protected function TypedEnumeration (val : Number, name : String)
		{
			super (val);
			this.__name = name;
		}
		public function get name():String{
			return this.__name;
		}
		public function toString():String{
			return this.name + super.toString();
		}
		public static function parse(o:Object):TypedEnumeration{
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
			for(var i in TypedEnumeration){
			//	trace("comparing " + i + TypedEnumeration[i]);
				var oc =  TypedEnumeration[i];
				if(o ==  oc ){
					return oc;
				}
			}
			return null;
		}
	}
	
}