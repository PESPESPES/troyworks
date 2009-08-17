package com.troyworks.data.valueobjects {

	public class BooleanVO extends ValueObject {
		private var _val : Boolean = false;

		public function BooleanVO(val : Boolean, func : Function = null) {
			super(func);
			_val = val;
		}

		public function set value(newVal : Boolean) : void {
			if(!isWriteable) {
				return;
			}
			
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				onChanged(newVal, _val);
				_val = newVal;
			}			
		}

		public function get value() : Boolean {
			return _val;
		}

		override public function toString() : String {
			return _val.toString();
		}
	}
}