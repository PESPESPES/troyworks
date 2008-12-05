package com.troyworks.apps.semantica { 
	import com.troyworks.framework.controller.BaseController;
	import com.troyworks.data.ArrayX;
	/**
	 * This holds the links to the semantic ontology (e.g wordnet, theasurus, user supplied)
	 * and is used for parsing string tags into the resulting ontology, 'clarifying'
	 * and disambigating when there is more than one ontology returned.
	 * 
	 * @author Troy Gardner
	 */
	public class SemanticOracle extends BaseController{
		public var availableTags:ArrayX;
		public var availableClasses:ArrayX;
		
		protected static var instance : SemanticOracle;
			
		/**
		 * @return singleton instance of SemanticaOracle
		 */
		public static function getInstance() : SemanticOracle {
				if (instance == null)
					instance = new SemanticOracle();
				return instance;
		}
		public function SemanticOracle() {
			super();
			availableTags = new ArrayX();
			availableClasses = new ArrayX();
			
		}
		public function getSemanticClassForTag(tag:String):ArrayX{
				var res:ArrayX = new ArrayX();
				var len : Number = availableClasses.length;
				var fnd:Boolean = false;
				trace("SemanticOracle.searching " + len + "classes");
				for (var i : Number = 0; i < len; i ++)
				{
					var cla:Object = availableClasses[i];
					for (var j : String in cla) {
						var o = cla[j];
						if (o is FowlBaseObject)
						{
							var f:FowlBaseObject = FowlBaseObject(o);
							if(f.tag == tag){
							//	trace("found Fowl Object " + f + " " +f.tag);
								res.push(f);
								fnd = true;
							}
							//break;
						}
					}				
				}
				trace("getSemanticClassForTag found:"+ fnd + " res " + res);
				if(fnd){
					return res;
				}else{
					return null;
				}
		}
	}
}