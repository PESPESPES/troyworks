package com.troyworks.data.valueobjects
{
	public class IntVO extends ValueObject
	{
		private var _val : int = 0;
		
		public function IntVO(val : int, func:Function = null)
		{
			super(func);
			_val = val;
		}
		
		public function set value(newVal : int):void {
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				onChanged(newVal,_val);
				_val = newVal;
			}
		}

		public function get value() : int {
			return _val;
		}

		override public function toString() : String {
			return _val.toString();
		}

	}
}