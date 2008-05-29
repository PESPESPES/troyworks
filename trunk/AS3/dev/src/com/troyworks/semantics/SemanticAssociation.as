package com.troyworks.semantics { 
	import com.troyworks.datastructures.graph.MicroLink;
	/**
	 * @author Troy Gardner
	 */
	public class SemanticAssociation extends MicroLink{
		/* the strength of association positive or negative to a given
		 * ontological object.
		 */
		public var stength:Number;
		public function SemanticAssociation() {
			super();
		}
	}
}