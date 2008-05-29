package  { 
	//------------------------------------------------------------
	import flash.xml.XMLDocument;
	// INSERT COLIN'S STRIPWHITESPACE CODE
	// Written by Colin Moock
	// Available at http://www.moock.org/asdg/codedepot/
	// Strips whitespace nodes from an XMLDocument document 
	// by passing twice through each level in the tree
	trace("strip whitespace loaded");
	function stripWhitespaceDoublePass(XMLnode) {
		// Loop through all the children of XMLnode
		for (public var i = 0; i<XMLnode.childNodes.length; i++) {
			// If the current node is a text node...
			if (XMLnode.childNodes[i].nodeType == 3) {
				// ...check for any useful characters in the node.
				var j = 0;
				var emptyNode = true;
				for (j=0; j<XMLnode.childNodes[i].nodeValue.length; j++) {
					// A useful character is anything over 32 (space, tab, 
					// new line, etc are all below).
					if (XMLnode.childNodes[i].nodeValue.charCodeAt(j)>32) {
						emptyNode = false;
						break;
					}
				}
				// If no useful charaters were found, delete the node.	
				if (emptyNode) {
					XMLnode.childNodes[i].removeNode();
				}
			}
		}
		// Now that all the whitespace nodes have been removed from XMLnode,
		// call stripWhitespaceDoublePass on its remaining children.
		for (var k = 0; k<XMLnode.childNodes.length; k++) {
			stripWhitespaceDoublePass(XMLnode.childNodes[k]);
		}
	}
}