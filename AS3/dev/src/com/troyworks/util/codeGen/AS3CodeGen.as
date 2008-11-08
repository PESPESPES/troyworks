package com.troyworks.util.codeGen {
	import com.troyworks.util.StringUtil;	

	/**
	 * AS3CodeGen
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 7, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class AS3CodeGen {
		/*
		import com.troyworks.util.*;
var d:Date = new Date();
var xml:XML = describeType(d);
trace("xml " + xml);
trace(codeGenAccessorsFromDescribeTypeXML(xml));*/
		public function codeGenAccessorsFromDescribeTypeXML(xml : XML) :String{
			var acc : XMLList = xml..accessor;
			var res : Array = new Array();
			for (var i = 0;i < acc.length(); i++) {
				var n : XML = acc[i];
				//trace(i + " " + n.@name);
				res.push(codeGenAccessor(n.@name, n.@access, n.@type));
				res.push("\r");
			}
			return res.join("\r");
		}

		public function codeGenAccessor(fnName : String , access : String,  type : String = null) : String {
			var res : Array = new Array();
			var Pc : String = StringUtil.toPCase(fnName);
			if (type == "" || type == null) {
				type == "void";
			}
			if (access == "readonly" || access == "readwrite") {
				res.push("public function get " + fnName + "():" + type + "{");
				res.push("\t return innerDate." + fnName + ";");
				res.push("}");
			}
			if (access == "writeonly" || access == "readwrite") {
				res.push("public function set " + fnName + "(new" + Pc + ":" + type + "):void{");
				res.push("\t innerDate." + fnName + " = new" + Pc + ";");
				res.push("}");
			}
			return res.join("\r");
		}
	}
}
