package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;	
	import com.troyworks.data.filters.Filter;	

	import flash.events.EventDispatcher;	

	/*
	 * ValueObject
	 *
	 *  Author: Troy Gardner  
	 * Copyright (c) TroyWorks 2007-2008   http://www.troyworks.com/
	 * Version: 1.0.0  Created:  Dec 14, 2008
	 * 
	 * License Agreement
	 * 
	 * Permission is hereby granted, free of charge, to any person obtaining a copy
	 * of this software and associated documentation files (the "Software"), to deal
	 * in the Software without restriction, including without limitation the rights
	 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	 * copies of the Software, and to permit persons to whom the Software is
	 * furnished to do so, subject to the following conditions:
	 * 
	 * The above copyright notice and this permission notice shall be included in
	 * all copies or substantial portions of the Software.
	 * 
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	 * THE SOFTWARE.
	 *
	 * DESCRIPTION
	 * 
	 * Core Value Object, designed as a enhanced version of using Object.watch
	 * for property value changes.
	 * 
	 * 	Any VO is a 'Value Object' that wraps an underlying primitive,
	 * 	
	 * 	it's meant to be used at the model layer,
	 * 	
	 * 	-it can have optional constraints as to what the value can actually be set to
	 * 	  (rounding, quantizing) e.g. pass in 1.234 and it is rounded to 1.0;
	 *  - multiple complex actions that can be taken when the value
	 *   it get into certain ranges or specific values, e.g. 
	 *          fire event Hot when the value is between 80-100
	 *          call function Cold when the value is between 0-60.
	 *  
	 *  
	 *  TODO
	 *  String
	 *  Boolean
	 *  Date
	 *  int
	 *  uint
	 *  Array?
	 *  Object?
	 *  Null/void?
	 *  Boolean data type
	 *  
	 *
	//  EXAMPLE: mood machine, has a value that must range between 0 and 100 for the mood
 	var constraint:NumberRangeConstraint = new NumberRangeConstraint(0,100);
	// initial value is 50, and the constrait we just setup
	var mood:NumberVO= new NumberVO(50, constraint.constrainToRange); 
	// add some events for before the change and after the change
	mood.addEventListener( DataChangedEvent.PRE_DATA_CHANGED, onPrecommitCheck);
	mood.addEventListener( DataChangedEvent.DATA_CHANGED, onPostcommitCheck);
	 
	//Cancel the value from actually being commited, in this case the post commit event won't take place.
	function onPrecommitCheck(evt:DataChangedEvent):void{
	    trace("onPrecommitCheck");
	    evt.stopPropagation();  
	    trace(evt);
 	}

	function onPostcommitCheck(evt:DataChangedEvent):void{
    	trace("onPostcommitCheck");
	    trace(evt);

	}
	 // It's very useful when combined with Filters, to trigger events/callbacks
	 // when data enters certain ranges
	 
	var rFilter1:NumberRangeBooleanFilter = new NumberRangeBooleanFilter(95,100, true, true);
		mood.addOnValueChangedAction(rFilter1, onRangeSuperHappy);
  It's useful when used with the EventAdapter to turn that function call into dispatching 
	 *  Events etc.

	 */

	public class ValueObject extends EventDispatcher {
		public var name : String = "ValueObject";
		public var description:String ="";
		
		public var constraint : Function = null;
		public var triggers : Array = new Array();
		//used when synchroizing
		public var hasChangedFromDefault : Boolean = false;
		public var isDirty : Boolean = false;
		public var isWriteable : Boolean = true;

		public static const PRE_DATA_CHANGED : String = DataChangedEvent.PRE_DATA_CHANGED;
		public static const DATA_CHANGED : String = DataChangedEvent.DATA_CHANGED;

		public function ValueObject(func : Function = null) {
			super();
			constraint = func;
		}

		/*
		 * 
		var rFilter1:NumberRangeBooleanFilter = new NumberRangeBooleanFilter(95,100, true, true);
		mood.addOnValueChangedAction(rFilter1, onRangeSuperHappy);
		 */
		public function addOnValueChangedAction(rangeFilter : Filter, fn : Function) : void {
			triggers.push({gaurd:rangeFilter, fn:fn});
		}

		private var _dispatchEventsEnabled : Boolean = false;

		public function set dispatchEventsEnabled( value : Boolean  ) : void {
			if(_dispatchEventsEnabled != value) {
				_dispatchEventsEnabled = value;
				//dispatchEvent(new Event(Event.CHANGE, true, true));
			}
		}

		public function get dispatchEventsEnabled( ) : Boolean {
			return _dispatchEventsEnabled;
		}
		override public function addEventListener(type:String, listener:Function,useCapture:Boolean =false,priority:int=0,useWeakReference:Boolean = false):void{
			dispatchEventsEnabled = true;
			super.addEventListener(type, listener,useCapture,priority,useWeakReference);
		}
		
		
		public function removeOnValueChangedAction(rangeFilter : Filter = null, fn : Function = null) : Boolean {
			var tr : Object = null;
			var remove : Boolean = false;
			for (var i : Number = 0;i < triggers.length; i++) {
				tr = triggers[i];
				if(rangeFilter != null && fn != null && tr.gaurd == rangeFilter && tr.fn == fn) {
					remove = true;
				}else if(rangeFilter != null && tr.gaurd == rangeFilter) {
					remove = true;
				}else if(fn != null && tr.fn == fn) {
					remove = true;
				}
				if(remove) {
				//	trace("removing inRangeAction");
					triggers.splice(i, 1);
					return true;	
				}
			}
			return false;
		}

		protected function onChanged(currentVal : *, oldVal : *, phase : String = null) : DataChangedEvent {
			if(dispatchEventsEnabled) {
				//trace("dispatchEventsEnabled " + phase);
				var evt : DataChangedEvent;
				if(phase == PRE_DATA_CHANGED) {
					evt = new DataChangedEvent(PRE_DATA_CHANGED, true, true);
				}else if(phase == DATA_CHANGED || phase == null) {
				//	trace("DATA CHANGE phase");
					evt = new DataChangedEvent(DATA_CHANGED, true, false);
				}
				evt.oldVal = oldVal;
				evt.currentVal = currentVal;
				if(phase == DATA_CHANGED) {
					isDirty = true;
					hasChangedFromDefault = true;
				}
				dispatchEvent(evt);
			}else{
				isDirty = true;
				hasChangedFromDefault = true;
			}
		//	trace("POST dispatchEventsEnabled");
			if(phase == DATA_CHANGED) {
				///////////
				for (var i : int = 0;i < triggers.length; i++) {
					var tr : Object = triggers[i];
					if (tr.gaurd.passesFilter(currentVal)) {
						tr.fn();
					}
				}
			}
			return evt;
		}
	}
}
