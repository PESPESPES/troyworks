package com.troyworks.data.filters {
	import flash.events.Event;	
	import flash.events.EventDispatcher; 

	/**
	 *  A filter is designed to be used with the Array.filter or other data iterators
	 * to determine if a particular value passes. It's like SQL lite in querying data
	 * collections.
	 * 
	 * Filters can be stacked using a composite Filter
	 * @author Troy Gardner
	 */
	public class Filter extends EventDispatcher {
		public static const PASSED_FILTER:String = "PASSED_FILTER";
		public var dispatchEventOn:Boolean = false;
		public var invert:Boolean = false;
		public function passesFilter(item:*,  index:int= 0, array:Array = null):Boolean{
			var passes:Boolean = true;
			var res:Boolean =(invert)?!passes:passes;
			 if(res){
			 	onPassedFiltered();
			 }
			return res;
		}
		public function onPassedFiltered():void{
			if(dispatchEventOn){
			dispatchEvent(new Event("PASSED_FILTER"));
			}
		}
		
	}
}