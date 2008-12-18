package com.troyworks.data.valueobjects
{
	public class StringVO extends ValueObject
	{
		private var _val : String = "";
		
		public function StringVO (val:String, func:Function = null)
		{
			super(func);
			_val = val;
		}
		
		public function set value(newVal : String):void {
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				onChanged(newVal,_val);
				_val = newVal;
			}
		}

		public function get value() : String {
			return _val;
		}

		override public function toString() : String {
			return _val;
		}

	}
}