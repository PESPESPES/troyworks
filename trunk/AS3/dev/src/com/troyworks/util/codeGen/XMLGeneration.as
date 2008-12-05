package com.troyworks.util.codeGen { 
	
	
	
	/**
	 *
	 * @author
	 * @version
	 **/
	public class XMLGeneration extends Object  {
		public function XMLGeneration(){
		}
		public static function generateCaseStatement(nodeName:String):String{
			var res:String =
			"					case \""+ nodeName +"\" : " + "\r" +
			"					{"+ "\r" +
			"						//		updateList += node2.firstChild.nodeValue;" +"\r" +
			"					}"+"\r" +
			"                    break;"+"\r";
			return res;
		}
	
	}
}