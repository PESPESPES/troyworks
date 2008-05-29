package com.troyworks.semantics { 
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.datastructures.Array2;
	import com.troyworks.fowl.FowlBaseObject;
	
	/**
	 * @author Troy Gardner
	 */
	public class SemanticMetaData extends BaseModelObject {
		/*string tags*/
		public var tags:Array2;
		/*semantic entry points*/
		public var sePts:Array2;
		public var sOracle:SemanticOracle;
		public function SemanticMetaData() {
			super();
			sOracle = SemanticOracle.getInstance();
			tags = new Array2();
			sePts = new Array2();
		}
		public function addTag(tagStr:String):void{
			public var cl = sOracle.getSemanticClassForTag(tagStr);
			trace("SemanticMetaData.addTag " + tagStr + " returns " + cl);
			tags.push(tagStr);
			if(cl!= null){
				sePts.push(tagStr);
			}
		}
		public function isA(fo:FowlBaseObject):Boolean{
			public var res:Boolean = false;		
			if(sePts.contains(fo)){
				res = true;
			}
			return res;
			
		}
		public function hasA(fo:FowlBaseObject):Boolean{
			public var res:Boolean = false;
			if(sePts.contains(fo)){
				res = true;
			}
			return res;
			
		}
		public function containsTag(tagStr:String):Boolean{
			public var res:Boolean = false;
			public var cl:Array2 = sOracle.getSemanticClassForTag(tagStr);
			if(sePts.contains(cl[0])){
				res = true;
			}
			if(res!= true){
				res = tags.contains(tagStr);
			}
			return res;
		}
	
	}
}