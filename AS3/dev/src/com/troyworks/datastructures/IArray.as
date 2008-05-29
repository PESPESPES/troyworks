package com.troyworks.datastructures { 
	import com.troyworks.datastructures.ArrayX;
	/**
	 * @author Troy Gardner
	 */
	interface IArray {
		///////////ARRAY ///////////////////////
		//public function Array(value:Object);
		public function join(delimiter:String):String;
		public function pop():Object;
		public function push(value:Object):Number;
		public function reverse():void;
		public function shift():Object;
		public function toString():String;
		public function unshift(value:Object):Number;
		
		/////// ARRAY1 Overridden ////////////////
		public function slice(startIndex:Number, endIndex:Number):ArrayX;
		public function sort(compareFunction:Object, options: Number):ArrayX; // 'compare' might be omitted so untyped. 'options' is optional.
		public function sortOn(fieldName:Object, options: Object):ArrayX; // 'fieldName' is a String, or an Array of String. 'options' is optional.
		public function splice(startIndex:Number, deleteCount:Number, value:Object):ArrayX;
		////////// ARRAYX ////////////////////
		public function appendArray(ary : Array, to:Number):void;
		public function swapPlaces(objA : Object, objB : Object) : ArrayX;
		public function reorderPlaces(object : Array, desiredPlaces : Array) : ArrayX;
		public function shiftFromTo(idxFrom : Number, idxTo : Number) : ArrayX;
		public function shiftTowardsStart(idxFrom : Number, positions : Number) : ArrayX;
		public function shiftTowardsEnd(idxFrom : Number, positions : Number) : ArrayX;
		public function insertAt(idx : Number, values : Object) : ArrayX;
		public function removeAt(pos : Number, positions:Number) : ArrayX;
		public function removeAll():void;
		public function remove(aValue_obj : Object) : Number;
		public function getFilteredSet(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : ArrayX;
		public function getFilteredRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object;
		public function getRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object;
		public function getFirstElement() : Object;
		public function getLastElement() : Object;
		public function isEmpty() : Boolean;
		public function shuffle(len : Number) : ArrayX;
		public function isWithinIndexBounds(num : Number) : Boolean;
		public function snapToClosest(num : Number) : Number;
		public function concat(value:Object) : ArrayX;
		public function clone() : ArrayX;
		public function getFirstIndexOf(aValue_obj : Object, from : Number, to : Number) : Number;
		public function getLastIndexOf(aValue_obj : Object, from : Number, to : Number) : Number;
		public function contains(aValue_obj : Object) : Boolean;
		public function isBefore(aBeforeVaL : Object, aFromVal : Object, rng : Number) : Boolean;
		public function isAfter(aAfterVaL : Object, aFromVal : Object, rng : Number) : Boolean;	
	}
}