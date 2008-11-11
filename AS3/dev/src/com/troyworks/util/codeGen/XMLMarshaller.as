package com.troyworks.util.codeGen
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;	

	public class XMLMarshaller
	{
		public function XMLMarshaller()
		{
		}
		
		public static function fromXML(xml:XML, obj:Object):void
		{
			trace("fromXML");
			trace(xml.toString());
			
			var xl:XMLList = xml..variable;
			var varNameStr:String;
			var varTypeStr:String;
			var varValueStr:String;
			
			if(xl.length() == 0)
			{
				throw("DataObj Error: XML does not contain any variable nodes.");
			}
			else
			{
				for each(var n:XML in xl)
				{
					varNameStr = n.@name;
					varTypeStr = n.@type;
					varValueStr = n.toString();

					if(obj.hasOwnProperty(varNameStr) == true)
					{
						try
						{
							obj[varNameStr] = varValueStr;
						}
						catch(e:Error)
						{
							switch(varTypeStr)
							{
								case "Array": obj[varNameStr] = varValueStr.split(",");
									break;
								default:
									throw("DataObj Error: Conversion of " + varValueStr + " to " + varTypeStr 
									+ " failed for variable "+ varNameStr + ". \r" + e.message);
									break;
							}
						}
					}
					else
					{
						throw("DataObj Error: XML contains a variable node that is not a class variable.");
					}
				}
			}
		}
		
		public static function toXML(obj:Object):XML
		{
			var x:XML = describeType(obj);
			var xl:XMLList = x..variable;
			var xmlStr:String = "";
			xmlStr ="<object type=\""+ getQualifiedClassName(obj)+"\">\r";

			for each(var n:XML in xl)
			{
				xmlStr += "<variable name=\"" +n.@name.toString() + "\" type=\"" + n.@type.toString() +"\">";
				xmlStr += obj[n.@name.toString()].toString();
				xmlStr += "</variable>\r";
			}
						
			xmlStr += "</object>";
			var res:XML = new XML(xmlStr);
			return res;
		} 		
	}
}