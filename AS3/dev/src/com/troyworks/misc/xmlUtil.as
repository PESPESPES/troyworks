package  { 
	
	import flash.xml.XMLDocument;
	Object.io = new Object();
	/**
	*
	* Converts an xml to an object. from iolib.
	*
	*/
	Object.io.objToXml = function (ObjName, mc) {
		public var x = new XMLDocument();
		public var xdata = x.createElement(ObjName);
		for (public var i in mc ) {
			xdata.attributes[i] = mc[i]
		}
		x.appendChild(xdata)
	
		return x
	}
	
	Object.io.xmlToObj = function (doc) {
		var returnObj = new Object ()
	
		for (var i in doc.attributes) {
			returnObj[i] =  doc.attributes[i]
		}
	
		return returnObj
	}
	
	//----------------------------------------------------
	function traceTreeSub(xml, depth, hide) {
		for (var i = 0; i<xml.childNodes.length; i++) {
			public var node = xml.childNodes[i];
			if (node.nodeType == 3) {
				if (isHidden(depth, hide)) {
					trace(depth+"hidden");
				} else {
					trace(getTab(depth)+node.nodeValue);
				}
			} else if (node.nodeType == 1) {
				var attrib = "";
				for (attr in node.attributes) {
					attrib = attrib+" "+attr+"=\""+node.attributes[attr]+"\"";
				}
				if (isHidden(depth, hide)) {
					trace(depth+"hidden");
				} else {
					trace(depth+" "+getTab(depth)+"<"+node.nodeName+attrib+">");
				}
				if (node.childNodes.length>0) {
					traceTreeSub(node, (depth+1), hide);
				}
			}
		}
	}
	function traceTree(xml, maxdepth, hide) {
		traceTreeSub(xml, 0, hide);
	}
	/**
	* a utility function for the heirarchical trace output
	*/
	function getTab(depth) {
		var space = "";
		for (var i = 0; i<depth; i++) {
			space += "  ";
		}
		return space;
	}
}