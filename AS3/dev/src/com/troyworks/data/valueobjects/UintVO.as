package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;

	public class UintVO extends ValueObject
	{
		
		private var _val : uint = 0;
		private var _defval : uint = 0;
		public function UintVO(val : uint, func:Function = null)
		{
			super(func);
			_val = val;
		}
		
		public function set value(newVal : uint):void {
			if(!isWriteable){
				return;
			}
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				var evt : DataChangedEvent = onChanged(newVal, _val, PRE_DATA_CHANGED);
				if(evt && evt.cancelable && evt.isCancelled) {
				} else {
					var oldVal : Object = _val;
					_val = newVal;
					//POST COMMIT
					//		trace(name+":StringVO.postcommit" + _val);

					onChanged(newVal, oldVal, DATA_CHANGED);
				}
			}
		}

		public function get value() : uint {
			return _val;
		}
		public function set defaultValue(defVal:uint):void{
			_defval = defVal;
		}
		public function get defaultValue() : uint {
			return _defval;
		}
		public function resetToDefaults():void{
			value = new uint(_defval); //value not reference	
		}

		override public function toString() : String {
			return _val.toString();
		}

	}
}