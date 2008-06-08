package com.troyworks.framework {
	import flash.events.Event;	
	
	import com.troyworks.util.DesignByContract; 
	import com.troyworks.core.cogs.Fsm;
	import com.troyworks.data.ArrayX;
//	import com.troyworks.events.TEventDispatcher;
//	import com.troyworks.framework.model.BaseModelObject;
	
	/**
	 * This wraps the underlying ArrayX and provides 
	 *  - event notification on changes (primarily to do batch changes)
	 *  - serialization to and from XMLDocument (customizable names);
	 *  - supported operations for introspected UI.
	 * @author Troy Gardner
	 */
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	public class CollectionManager extends Fsm implements com.troyworks.data.IArray {
		
		public var ASSERT : Function;
		public var REQUIRE : Function;
		
		public static var CASEINSENSITIVE : Number = Array.CASEINSENSITIVE;
		public static var DESCENDING : Number = Array.DESCENDING;
		public static var NUMERIC : Number = Array.NUMERIC;
		public static var RETURNINDEXEDARRAY : Number = Array.RETURNINDEXEDARRAY;
		public static var UNIQUESORT : Number = Array.UNIQUESORT;
	
		public static var EVTD_MODEL_CHANGED : String = "EVTD_MODEL_CHANGED";
		public static var EVTD_COLLECTION_SIZE_CHANGED : String = "EVTD_COLLECTION_SIZE_CHANGED";
		public static var EVTD_CONTENTS_CHANGED_ORDER : String = "EVTD_CONTENTS_CHANGED_ORDER";
		public static var EVTD_CONTENTS_ACCESSED : String = "EVTD_CONTENTS_ACCESSED";
		//
		//public static var EVTD_ELEMENTS_ADDED:String = "EVTD_CONTENTS_CHANGED_POSITION";
		//public static var EVTD_ELEMENTS_REMOVED:String = "EVTD_CONTENTS_CHANGED_POSITION";
		//public static var EVTD_ELEMENTS_CHANGED:String = "EVTD_CONTENTS_CHANGED_POSITION";
		//public static var EVTD_ELEMENTS_READ:String = "EVTD_CONTENTS_CHANGED_POSITION";
		protected var c : ArrayX;
		protected var previousLength : Number;
	
		protected var name : String;
		/*****************************************************
		 *  Constructor
		 */
		public function CollectionManager(name : String) {
			super();
			DesignByContract.initialize(this);
//			REQUIRE($tevD != null, "COLLECTION MANAGER TED can't be null");
			c  = new ArrayX();
			this.name = (name == null)?"CollectionManager" :name;
		}
	
		public function get length():Number{
			return c.length;
		}
		//////////////////EVENTS ///////////////////////////
		protected function startReorderElementsTransaction() : void{
		//	previousLength = c.length;
		}
		protected function endReorderElementsTransaction() : void{
		}
	
		protected function dispatchContentChangedOrder() : void{
			dispatchEvent (	new	Event(EVTD_CONTENTS_CHANGED_ORDER));
			dispatchEvent (	new	Event(EVTD_MODEL_CHANGED));
		}
		protected function startSizeChangeTransaction() : void{
			previousLength = c.length;
		}
		protected function endSizeChangeTransaction() : void{
		}
		protected function dispatchSizeChanged() : void{
			$tevD.debugTracesOn = true;
			//trace("dispacthSizeChagned");
			dispatchEvent (
			{
				type :EVTD_COLLECTION_SIZE_CHANGED , target : this, oldVal : previousLength, newVal :c.length
			});
			dispatchEvent (
			{
				type : EVTD_MODEL_CHANGED, target : this
			});	
		}
		protected function dispatchContentsRead() : void{
			dispatchEvent (
			{
				type : EVTD_CONTENTS_ACCESSED, target : this
			});
		}
		//	public function getSupportedOperations():void
		//////////// ARRAY1 and ArrayX //////////////////////////////////
		public function appendArray(ary : Array, to : Number) : void{
			startSizeChangeTransaction();
			trace("CollectionManager.appendArray " + ary + " to " + to);
			c.appendArray.apply(c, arguments);
			endSizeChangeTransaction();
			dispatchSizeChanged();
		}
	
		public function insertAt(idx : Number, values : Object) : ArrayX {
			startSizeChangeTransaction();
			var r : ArrayX = c.insertAt.apply(c, arguments);//(idx, values);
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;	
		}
	
		public function removeAt(pos : Number, positions : Number) : ArrayX {
			startSizeChangeTransaction();
			var r : ArrayX = c.removeAt.apply(c,arguments);//(pos,positions);
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
		public function removeAll() : void {
			startSizeChangeTransaction();
			c.removeAll.apply(c, arguments);//();
			endSizeChangeTransaction();
			dispatchSizeChanged();
		}
	
		public function remove(aValue_obj : Object) : Number {
			startSizeChangeTransaction();
			var r : Number = c.remove.apply(c, arguments);//aValue_obj);
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
		public function pop() : Object {
			startSizeChangeTransaction();
			var r : Object = c.pop.apply(c, arguments);//();
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
	
		public function push(value : Object) : Number {
			startSizeChangeTransaction();
			var r : Number = c.push.apply(c, arguments);//(value);
	//		trace("push " + this.toString());
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
	
		public function splice(startIndex : Number, deleteCount : Number, value : Object) : ArrayX {
			startSizeChangeTransaction();
			var r : ArrayX = c.splice.apply(c, arguments);//startIndex, deleteCount, value);
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
	
		public function unshift(value : Object) : Number {
			startSizeChangeTransaction();
			var r : Number = c.unshift.apply(c, arguments);
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
		public function shift() : Object {
			startSizeChangeTransaction();
			var r : Object = c.shift.apply(c,arguments);//();
			endSizeChangeTransaction();
			dispatchSizeChanged();
			return r;
		}
		///////////////////////////// REARRANGERS  //////////////////////////////
		public function swapPlaces(objA : Object, objB : Object) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.swapPlaces.apply(c, arguments);//objA, objB);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
	
		public function reorderPlaces(object : Array, desiredPlaces : Array) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.reorderPlaces.apply(c, arguments);//(object, desiredPlaces);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
	
		public function shiftFromTo(idxFrom : Number, idxTo : Number) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.shiftFromTo.apply(c, arguments);//(idxFrom, idxTo);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
	
		public function shiftTowardsStart(idxFrom : Number, positions : Number) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.shiftTowardsStart.apply(c, arguments);//(idxFrom, positions);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
	
		public function shiftTowardsEnd(idxFrom : Number, positions : Number) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.shiftTowardsEnd.apply(c, arguments);//(idxFrom, positions);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
		public function shuffle(len : Number) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.shuffle.apply(c, arguments);//(len);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
		public function reverse() : void {
			startReorderElementsTransaction();
			c.reverse.apply(c, arguments);//();
			dispatchContentChangedOrder();
		}
		public function sort(compareFunction : Object, options : Number) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.sort.apply(c, arguments);//(compareFunction, options);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
	
		public function sortOn(fieldName : Object, options : Object) : ArrayX {
			startReorderElementsTransaction();
			var r : ArrayX = c.sortOn.apply(c, arguments);//(fieldName,options);
			endReorderElementsTransaction();
			dispatchContentChangedOrder();
			return r;
		}
		
	///////////////////////////////// GET / QUERYIES //////////////////////////////////////////
		public function getFilteredSet(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : ArrayX {
			var r : ArrayX = c.getFilteredSet.apply(c, arguments);//(from, to, aThatsNot, aThatsIsOneOf);
			return r;
		}
	
		public function getFilteredRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object {
			var r : Object = c.getFilteredRandomElement.apply(c, arguments);//(from, to, aThatsNot, aThatsIsOneOf);
			return r;
		}
	
		public function getRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object {
			var r : Object = c.getRandomElement.apply(c, arguments);//(from, to, aThatsNot, aThatsIsOneOf);
			return r;
		}
	
		public function getFirstElement() : Object {
			var r : Object = c.getFirstElement.apply(c, arguments);//();
			return r;
		}
		public function getElementAt(idx : Number) : Object {
			var r : Object = c[idx];//();
			return r;
		}
		public function getLastElement() : Object {
			var r : Object = c.getLastElement.apply(c, arguments);//();
			return r;
		}
	
		public function isEmpty() : Boolean {
			var r : Boolean = c.isEmpty.apply(c, arguments);//();
			return r;
		}
	
		public function isWithinIndexBounds(num : Number) : Boolean {
			var r : Boolean = c.isWithinIndexBounds.apply(c, arguments);//(num);
			return r;
		}
	
		public function snapToClosest(num : Number) : Number {
			var r : Number = c.snapToClosest.apply(c, arguments);//(num);
			return r;
		}
	
		public function getFirstIndexOf(aValue_obj : Object, from : Number, to : Number) : Number {
			var r : Number = c.getFirstIndexOf.apply(c, arguments);//(aValue_obj, from, to);
			return r;
		}
	
		public function getLastIndexOf(aValue_obj : Object, from : Number, to : Number) : Number {
			var r : Number = c.getLastIndexOf.apply(c, arguments);//(aValue_obj, from, to);
			return r;
		}
	
		public function contains(obj : Object) : Boolean {
			var r : Boolean = c.contains.apply(c, arguments);//(obj);
			return r;
		}
	
		public function isBefore(aBeforeVaL : Object, aFromVal : Object, rng : Number) : Boolean {
			var r : Boolean = c.isBefore.apply(c, arguments);//(aBeforeVaL, aFromVal, rng);
			return r;
		}
	
		public function isAfter(aAfterVaL : Object, aFromVal : Object, rng : Number) : Boolean {
			var r : Boolean = c.isAfter.apply(c, arguments);//(aAfterVaL, aFromVal, rng);
			return r;
		}
	
		public function join(delimiter : String) : String {
			var r : String = c.join.apply(c, arguments);//(delimiter);
			return r;
		}
	
		public function concat(value : Object) : ArrayX {
	
			var r : ArrayX = c.concat.apply(c, arguments);//(value);
			return r;
		}
	
		public function clone() : ArrayX {
			//trace(" clone()" + util.Trace.me(c));
			
			var r : ArrayX = c.clone.apply(c, arguments);//();
			//trace(" clone res " + r.join("\r"));
			return r;
		}
		public function slice(startIndex : Number, endIndex : Number) : ArrayX {
			var r : ArrayX = c.slice.apply(c, arguments);//(startIndex,endIndex);
			return r;
		}
		public function toString() : String{
			var r : String = c.toString.apply(c, arguments);//();
			return r;
		}
		public function addEventListener(evt : String, arg1 : Object, arg2 : Object, arg3 : Object) : void {
			super.addEventListener.apply(this, arguments);
		}
		public function toXML(tree : XMLDocument) : XMLNode {
			if (tree == null) {
				tree = new XMLDocument();
			}
			var n : XMLNode = tree.createElement(name);
			n.attributes.objRef = this;
			n.attributes.label = name+ " " + this.length;
			/////////////////////////////
			for(var i : Number = 0; i < this.length; i++){
				var tm = this.getElementAt(i);
				var n1 : XMLNode = tm.toXML(tree);
				n.appendChild(n1);
			}
			return n;
		}
	  
	    
	}
}