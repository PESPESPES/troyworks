package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;	

	import flash.events.Event;	

	/*
	 * NumberVO
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
	 * A NumberVO is a 'Value Object' it's meant at the model layer to wrap
	 * a Number, and have constraints as to what it can be set to (rounding, quantizing)
	 *  as well as multiple complex actions that can be taken when the value
	 *  it get into certain ranges or specific values, e.g. call function Hot when the value
	 *  is between 80-100, call function Cold when the value is between 0-60.
	 */

	public class NumberVO extends ValueObject {
		private var _val : Number = NaN;
		private var _defval : Number = NaN;
		
		public function NumberVO(val : Number, myConstraint : Function = null, myTriggers : Array = null) {
			super();
			_val = val;
			constraint = myConstraint;
			triggers = (myTriggers == null) ? new Array() : myTriggers;	
		}

		public function set value(newVal : Number) : void {
		//	trace(name+":NumberVO.setValue " + newVal);
			if(!isWriteable) {
				return;
			}
			
			if(constraint != null) {
			//	trace(name+":NumberVO.constracit" + newVal);
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				//PRE COMMIT
				//				trace(name+":NumberVO.precommit" + newVal);
				
				var evt : DataChangedEvent = onChanged(newVal, _val, PRE_DATA_CHANGE);
				if(evt.cancelable && evt.isCancelled){
				}else {
					var oldVal : Object = _val;
					_val = newVal;
					//POST COMMIT
				//		trace(name+":NumberVO.postcommit" + _val);
					
					onChanged(newVal, oldVal, DATA_CHANGE);
				}
			}
		}

		public function get value() : Number {
			//trace(name+":NumberVO.getValue " + _val);
			return _val;
		}
		public function set defaultValue(defVal:Number):void{
			_defval = defVal;
		}
		public function resetToDefaults():void{
			value = new Number(_defval); //value not reference	
		}
		override public function toString() : String {
			return _val.toString();
		}
	}
}
