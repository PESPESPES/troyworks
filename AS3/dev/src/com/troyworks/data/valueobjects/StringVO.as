package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;

	public class StringVO extends ValueObject {
		private var _val : String = "";
		private var _defval : String = "";

		public function StringVO(val : String, func : Function = null) {
			super(func);
			_val = val;
		}

		public function set value(newVal : String) : void {
			if(!isWriteable) {
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

		public function get value() : String {
			return _val;
		}

		public function set defaultValue(defVal : String) : void {
			_defval = defVal;
		}
		public function get defaultValue() : String {
			return _defval;
		}

		public function resetToDefaults() : void {
			value = new String(_defval); //value not reference	
		}

		override public function toString() : String {
			return _val;
		}
	}
}