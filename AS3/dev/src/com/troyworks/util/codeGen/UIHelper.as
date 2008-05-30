package com.troyworks.util.codeGen {
	import flash.utils.describeType;

	/**
	 * @author Troy Gardner
	 */
	public class UIHelper {

		public static function genClassMembers(obj : Object) : String {
			//trace("genClassMembers....................................");
			var xml : XMLList = describeType(obj)..variable;
			//trace("xml " + xml);
			var res : Array = new Array();
			
			var t : String = "";
			var i : int = 0;
			var n : int = xml.length();
			var xn : XML;
			var ty : String = "";
			for (;i < n; ++i) {
				xn = xml[i];
				ty = String(xn.@type);;
				trace(i + " " + xn);
				t = ty.substring(ty.indexOf("::") + 2, ty.length);
				res.push("public var " + xn.@name + ":" + t + ";");
			}
			

			return res.join("\r");
		}
	}
}
