package com.troyworks.data.valueobjects {
	import com.troyworks.util.datetime.TDate;

	public class DateVO extends ValueObject {
		private var _val : TDate = null;

		public function DateVO(val : TDate, func : Function = null) {
			super(func);
			_val = val;
		}

		public function set value(newVal : TDate) : void {
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

		public function get value() : TDate {
			return _val;
		}

		override public function toString() : String {
			return _val.toDateString();
		}
	}
}