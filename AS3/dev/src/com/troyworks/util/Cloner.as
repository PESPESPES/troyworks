package com.troyworks.util { 
	/**
	 * @author Troy Gardner
	 */
	public class Cloner {
		public static var cloneingEnabled:Boolean = false;
		/************************************************
		 * using a mixin, adds a clone method to the basic types
		 * object, array, boolean, String and Number.
		 */
		public static function enable() : void{
			cloneingEnabled = true;
			Object.prototype.clone = function() {
				var r = false;
					if (_global.__cloneTemp__===undefined) {
					_global.__cloneTemp__=[];
					r=true;
					}
				var a = _global.__cloneTemp__;
	
				for (var i in a) {
						if (a[i].o===this) {
						return a[i].n;
						}
					}
	
				var obj = {};
	
				a.push({o: this, n: obj});
	
				for(var p:String in this) {
					obj[p] = Object(this)[p].clone();
					}
					
					if (r) {
					delete _global.__cloneTemp__;
					}
				return obj;
				};
	
			_global.ASSetPropFlags(Object.prototype,["clone"],1);
	
			Array.prototype.clone = function() {
				var obj = [];
				for (var p in this) {
					obj[p] = Object(this)[p].clone();
					}
				return obj;
				};
			_global.ASSetPropFlags(Array.prototype, ["clone"], 1);
			Boolean.prototype.clone = function() {
				return (this == true) ? true : false;
				};
			_global.ASSetPropFlags(Boolean.prototype, ["clone"], 1);
			String.prototype.clone = function() {
				return this+"";
				};
			_global.ASSetPropFlags(String.prototype, ["clone"], 1);
			Number.prototype.clone = function() {
				return this-0;
				};
			_global.ASSetPropFlags(Number.prototype, ["clone"], 1);
				
				
			}
	}
}