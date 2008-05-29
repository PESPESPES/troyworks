//--------------------------------------------------------------------
/**
 * Instance inherits superClass properties (used inside of constructor)
 *
 * @param superclass [function] reference to the superclass
 * @param argObj [object] arguments object (or a single argument)
*/
Object.prototype.inherits = function(superClass, argObj) {
	this.tmp_Base = superClass;
	this.tmp_Base(argObj);
	delete this.tmp_Base;
	var o = this.__proto__;
	// Check for multi-level inheritance
	var p = o.__proto__.__proto__;
	while (p != null) {
		p = p.__proto__;
		o = o.__proto__;
	}
	// Complete the prototype chain by linking back to parent.prototype
	o.__proto__ = superClass.prototype;
};
// hide from for..in loops
ASSetPropFlags(Object.prototype, ["inherits"], 1);

// another way of doing it (e.g. for runtime clips from the drawing api).
Object.resolve = function(obj, theClass) {
 obj.__resolve = function(p) {
  if (theClass.prototype[p] instanceof Function) {
   return function () {
    return theClass.prototype[p].apply(obj, arguments);
   };
  } else {
   return theClass.prototype[p];
  }
 };
};
/*
//usage example
MyClass = function () {
};
MyClass.prototype = new MovieClip();
MyClass.prototype.testMethod = function(word) {
 return word + this;
};
MyClass.prototype.testProp = "hello";

this.createEmptyMovieClip("mc", 1);

Object.resolve(mc, MyClass); // makes mc inherit from MyClass.

trace(mc.testMethod("I am ")); //I am _level0.mc
trace(mc.testProp);                   //hello
*/