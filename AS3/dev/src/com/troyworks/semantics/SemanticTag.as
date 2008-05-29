package com.troyworks.semantics { 
	import com.troyworks.framework.model.BaseModelObject;
	import com.troyworks.datastructures.graph.MicroNode;
	/**
	 * @author Troy Gardner
	 */
	public class SemanticTag extends MicroNode{
		public var tag:String;
		public var ontologyAssociation:SemanticAssociation;
		public function SemanticTag() {
			super();
		}
	}
}