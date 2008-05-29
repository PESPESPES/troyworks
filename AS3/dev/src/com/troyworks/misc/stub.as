package  { 
	////////////////////////////////////////////////////////////
	//
	// Primarily for creating methods/variables inside the constructor
	// to visually encapsulate the methods/variables (to look more like Class 
	// based langauges like Java) while also following Macromedia's 'best practices' 
	// document's recommendation of avoiding 'this.<whatever>' in favor of 
	// the shared 'prototype.<whatever>' space to save memory, 
	//
	// '_c.<whatever>' creates a class level reference similar to:
	//
	//  MyClass.myvariable = "myVariableValue";
	//  MyClass.myfunction = new function(){ <statements...>}
	//
	// '_i.<whatever>' creates a instance level reference similar to:
	//
	//  MyClass.prototype.myvariable = "myVariableValue";
	//  MyClass.prototype.myfunction = new function(){ <statements...>}
	//
	// e.g.:
	//     MyClass = function(){
	//	    var _ = this.createStubs();
	//        _.x = "a "; //instance var
	//        _.f1 = function(){return "b ";}//instance function
	//        this._c.x = "c "; //class var 
	//        this._c.f1 = function(){return "d ";} //class function
	//        this.removeStubs();//optional
	//     }
	//    myObj = new MyClass();
	//    trace(myObj.x + myObj.f1() + MyClass.x + MyClass.f1()); //outputs 'a b c d'
	//
	Object.prototype.createStubs = function() {
		this._c = this.constructor;
		this._i = this._c.prototype;
		//since we use instances the most return it for eacsy access.
		return this._i;
		//hides them from for-in Loops
		ASSetPropFlags(this, ["_c,_i"], 7);
	};
	// removeRelated methods is a boolean
	Object.prototype.removeStubs = function(removeRelatedMethods) {
	//if calling class is same as current class (not inherited).
		//unhide/protect them to allow deletion
		ASSetPropFlags(this, ["_c,_i"], 8);
		delete this._c;
		delete this._i;
		if (removeRelatedMethods) {
			//if true, remove the constructor/deconstructors as well
			delete Object.prototype.createStubs;
			delete Object.prototype.removeStubs;
		}
	};
	// hide from for..in loops
	ASSetPropFlags(Object.prototype, ["createStubs,removeStubs"], 7);
}