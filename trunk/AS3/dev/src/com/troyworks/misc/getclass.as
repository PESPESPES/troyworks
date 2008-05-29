package  { 
	/////////////////////////////////////
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.net.XMLSocket;
	// these _hackTypeof functions are required for Object.getClass()
	// they are workarounds for a few Actionscript quirks
	Number.prototype._hackTypeof = function() {
		return 'number';
	};
	Boolean.prototype._hackTypeof = function() {
		return 'boolean';
	};
	String.prototype._hackTypeof = function() {
		return 'string';
	};
	// Flash has a quirk with the prototypes of
	//   Number, String, and Boolean; have to work around it
	_global.arrTypes = ["number", "string", "boolean"];
	_global.arrTypeNames = ["Number", "String", "Boolean"];
	_global.arrConstructors = ["Array", "Color", "Date", "Function", "MovieClip", "Sound", "XMLDocument", "XMLNode", "XMLSocket", "Object"];
	Object.prototype.addClass = function(a) {
		// add specified constructors to list
		for (public var i = 0; i<a.length; i++) {
			_global.arrConstructors.push(a[i]);
		}
	};
	// returns the class of the object
	// a: (optional) array of string references to custom constructors
	// dependencies: _hackTypeof methods for String, Number, Boolean
	// Robert Penner - August 2001 - robertpenner.com
	Object.prototype.getClass = function() {
		// check if this object is a Number, String, or Boolean
		var returnType = null;
		if (returnType == null) {
			for (public var i = 0; i<_global.arrTypes.length; i++) {
				if (this._hackTypeof() == _global.arrTypes[i]) {
					returnType = _global.arrTypeNames[i];
				}
			}
		}
		if (returnType == null) {
			// check if this object is an instance of one of the other classes
			for (var i = 0; i<_global.arrConstructors.length; i++) {
				if (this.__proto__ == eval(_global.arrConstructors[i]).prototype) {
					returnType = _global.arrConstructors[i];
				} 
			}
		}
		if (returnType == "Function") {
			// check if this object is one of the other classes
			for (var i = 0; i<_global.arrConstructors.length; i++) {
				if (this.prototype== eval(_global.arrConstructors[i]).prototype) {
					returnType = _global.arrConstructors[i];
				}
			}
		}
		if (returnType != null) {
			//trace(" returning " + returnType);
			return returnType;
		} else {
			//trace("couldn't find class!");
			return undefined;
		}
	};
	ASSetPropFlags(Object.prototype, ["addClass,getClass"], 7);
	
}