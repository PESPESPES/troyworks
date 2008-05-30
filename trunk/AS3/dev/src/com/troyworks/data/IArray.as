package com.troyworks.data { 
	import com.troyworks.data.ArrayX;
	/**
	 * @author Troy Gardner
	 */
	public interface IArray {
		///////////ARRAY ///////////////////////
		// function Array(value:Object);
		 function join(delimiter:String):String;
		 function pop():Object;
		 function push(value:Object):Number;
		 function reverse():void;
		 function shift():Object;
		 function toString():String;
		 function unshift(value:Object):Number;
		
		/////// ARRAY1 Overridden ////////////////
		 function slice(startIndex:Number, endIndex:Number):ArrayX;
		 function sort(compareFunction:Object, options: Number):ArrayX; // 'compare' might be omitted so untyped. 'options' is optional.
		 function sortOn(fieldName:Object, options: Object):ArrayX; // 'fieldName' is a String, or an Array of String. 'options' is optional.
		 function splice(startIndex:Number, deleteCount:Number, value:Object):ArrayX;
		////////// ARRAYX ////////////////////
		 function appendArray(ary : Array, to:Number):void;
		 function swapPlaces(objA : Object, objB : Object) : ArrayX;
		 function reorderPlaces(object : Array, desiredPlaces : Array) : ArrayX;
		 function shiftFromTo(idxFrom : Number, idxTo : Number) : ArrayX;
		 function shiftTowardsStart(idxFrom : Number, positions : Number) : ArrayX;
		 function shiftTowardsEnd(idxFrom : Number, positions : Number) : ArrayX;
		 function insertAt(idx : Number, values : Object) : ArrayX;
		 function removeAt(pos : Number, positions:Number) : ArrayX;
		 function removeAll():void;
		 function remove(aValue_obj : Object) : Number;
		 function getFilteredSet(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : ArrayX;
		 function getFilteredRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object;
		 function getRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object;
		 function getFirstElement() : Object;
		 function getLastElement() : Object;
		 function isEmpty() : Boolean;
		 function shuffle(len : Number) : ArrayX;
		 function isWithinIndexBounds(num : Number) : Boolean;
		 function snapToClosest(num : Number) : Number;
		 function concat(value:Object) : ArrayX;
		 function clone() : ArrayX;
		 function getFirstIndexOf(aValue_obj : Object, from : Number, to : Number) : Number;
		 function getLastIndexOf(aValue_obj : Object, from : Number, to : Number) : Number;
		 function contains(aValue_obj : Object) : Boolean;
		 function isBefore(aBeforeVaL : Object, aFromVal : Object, rng : Number) : Boolean;
		 function isAfter(aAfterVaL : Object, aFromVal : Object, rng : Number) : Boolean;	
	}
}