package com.troyworks.data.valueobjects
{
	public class DateVO extends ValueObject
	{
		private var _val : Date = null;
		
		public function DateVO(val : Date, func:Function = null)
		{
			super(func);
			_val = val;
		}

		public function set value(newVal : Date):void {
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				onChanged(newVal,_val);
				_val = newVal;
			}			
		}

		public function get value() : Date {
			return _val;
		}

		override public function toString() : String {
			return _val.toDateString();
		}
	}
}