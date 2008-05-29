package  { 
	// First, create some utility and display methods by
	// extending or overriding some built-in methods:
	// -------------------------------------------------------------------------------
	// Count the number of properties in an object
	Object.prototype.count = function() {
		public var n = 0;
		for (public var p in this) {
			n++;
		}
		return n;
	};
	// Display properties and methods in an object
	Object.prototype.showProps = function() {
		trace(typeof this+" '"+this.getClass()+"'{");
		for (var i = 0; i<4; i++) {
			public var type = null;
			if (i == 0) {
				type = this;
				//trace("\n" + space + "this:{");
			} else if (i == 1) {
				type = this.prototype;
				trace("\n\tprototype:("+type.getClass()+"){");
			} else if (i == 2) {
				type = this.constructor;
				trace("\n\tconstructor:("+type.getClass()+"){");
			} else if (i == 3) {
				type = this.__proto__;
				trace("\n\t__proto__:("+type.getClass()+"){");
			}
			public var space = null;
			if (i==0) {
				space = "\t";
			} else {
				space = "\t\t";
			}
			for (public var p in type) {
				public var pVal = type[p];
				public var pType = typeof pVal;
				if (pType == "function") {
					trace(space+pType+" "+p+"("+pVal+")");
				} else {
					trace(space+p+":"+pVal);
				}
			}
			if (i>0) {
				trace("\t}");
			}
		}
		trace("}");
	};
	// hide from for..in loops
	ASSetPropFlags(Object.prototype, ["count,showProps"], 1);
	// Override the system Object.toString() method
	Object.prototype.toString = function() {
		var lastProp = this.count()-1;
		var s = "";
		var i = 0;
		for (var p in this) {
			var pVal = this[p];
			var pType = typeof pVal;
			if (pType != "function") {
				if (pType == "string") {
					s += p+":\""+pVal+"\"";
				} else {
					s += p+":"+pVal;
				}
				if (i<lastProp) {
					s += ",\n               ";
				}
			}
			i++;
		}
		return "{"+s+"}";
	};
	// Store the system Array.toString() method
	Array.prototype.sysToString = Array.prototype.toString;
	// Override the system Array.toString() method
	Array.prototype.toString = function() {
		var lastItem = this.length-1;
		var s = "";
		for (var i = 0; i<this.length; i++) {
			var iVal = this[i];
			var iType = typeof iVal;
			if (iType != "function") {
				if (iType == "string") {
					s += "\""+iVal+"\"";
				} else {
					s += iVal;
				}
				if (i<lastItem) {
					s += ", ";
				}
			}
		}
		return "["+s+"]";
	};
	
}