package com.troyworks.apps.semantica {
	import com.troyworks.data.graph.MicroNode; 

	/**
	 * @author Troy Gardner
	 */
	public class SemanticTag extends MicroNode{
		public var tag:String;
		public var ontologyAssociation:SemanticAssociation;
		public function SemanticTag(id : Number, name : String, nType : String) {
			super(id, name, nType );
		}
	}
}