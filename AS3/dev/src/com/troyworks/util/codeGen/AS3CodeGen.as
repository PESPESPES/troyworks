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
		
		public static function codeGenAccessorsFromDescribeTypeXML(xml : XML) :String{
			var acc : XMLList = xml..accessor;
			var res : Array = new Array();
			for each (var n:XML in acc)	
			{				
				res.push(codeGenAccessor(n.@name, n.@access, n.@type));
				res.push("\r");
			}
			return res.join("\r");
		}

		public static function codeGenAccessor(fnName : String , access : String,  type : String = null) : String {
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
		
		public static function codeGenConstructorFromDescribeTypeXML(xml : XML) :String{
			var className : String = xml..@name[0];
			var res : String = "public function "+className+"(){\r}\r";
			return res;
		}
		
		public static function codeGenMethodsFromDescribeTypeXML(xml : XML) :String{
			var methods : XMLList = xml..method;
			var res : Array = new Array();
			var args : Array;
			var paramList : XMLList;
			var paramObj:Object;
			for each (var m:XML in methods)	
			{
				args = new Array();
				paramList = m..parameter;
				for each (var p:XML in paramList)								
				{
					paramObj = new Object();
					paramObj.index = p.@index;
					paramObj.type = p.@type;
					paramObj.optional = (p.@optional == true);
					args.push(paramObj);
				}
				res.push(codeGenMethod(m.@name, m.@returnType, args));
				res.push("\r");
			}
			return res.join("\r");
		}
		
		public static function codeGenMethod(methodName : String , returnType : String = null, arguments : Array = null) : String {
			var res : Array = new Array();
			var Pc : String = StringUtil.toPCase(methodName);
			if (returnType == "" || returnType == null) {
				returnType == "void";
			}
			
			var args : Array = new Array();
			var argString;
			for each (var arg:Object in arguments)
			{
				argString = "param"+arg.index+" : "+arg.type;
				if (arg.optional) argString += " = null";
				args.push(argString);
			}
			res.push("public function "+methodName+"("+args.join(", ")+"):"+returnType+" {\r}"); 
			return res.join("\r");
		}		
	}
}
