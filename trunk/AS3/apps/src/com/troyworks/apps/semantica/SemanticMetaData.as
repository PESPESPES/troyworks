package com.troyworks.apps.semantica { 
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.data.ArrayX;

	
	/**
	 * @author Troy Gardner
	 */
	public class SemanticMetaData extends BaseModelObject {
		/*string tags*/
		var tags:ArrayX;
		/*semantic entry points*/
		var sePts:ArrayX;
		var sOracle:SemanticOracle;
		public function SemanticMetaData() {
			super();
			sOracle = SemanticOracle.getInstance();
			tags = new ArrayX();
			sePts = new ArrayX();
		}
		public function addTag(tagStr:String):void{
			var cl = sOracle.getSemanticClassForTag(tagStr);
			trace("SemanticMetaData.addTag " + tagStr + " returns " + cl);
			tags.push(tagStr);
			if(cl!= null){
				sePts.push(tagStr);
			}
		}
		public function isA(fo:FowlBaseObject):Boolean{
			var res:Boolean = false;		
			if(sePts.contains(fo)){
				res = true;
			}
			return res;
			
		}
		public function hasA(fo:FowlBaseObject):Boolean{
			 var res:Boolean = false;
			if(sePts.contains(fo)){
				res = true;
			}
			return res;
			
		}
		public function containsTag(tagStr:String):Boolean{
			var res:Boolean = false;
			var cl:ArrayX = sOracle.getSemanticClassForTag(tagStr);
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