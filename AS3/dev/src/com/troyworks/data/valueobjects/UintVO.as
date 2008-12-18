package com.troyworks.data.valueobjects
{
	public class UintVO extends ValueObject
	{
		
		private var _val : uint = 0;
		
		public function UintVO(val : uint, func:Function = null)
		{
			super(func);
			_val = val;
		}
		
		public function set value(newVal : uint):void {
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				onChanged(newVal,_val);
				_val = newVal;
			}
		}

		public function get value() : uint {
			return _val;
		}

		override public function toString() : String {
			return _val.toString();
		}

	}
}