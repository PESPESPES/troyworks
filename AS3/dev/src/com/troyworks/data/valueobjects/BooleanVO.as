package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;

	public class BooleanVO extends ValueObject {
		private var _val : Boolean = false;
		private var _defval : Boolean = false;

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
				//PRE COMMIT
				//				trace(name+":BooleanVO.precommit" + newVal);

				var evt : DataChangedEvent = onChanged(newVal, _val, PRE_DATA_CHANGE);
				if(evt.cancelable && evt.isCancelled) {
				} else {
					var oldVal : Object = _val;
					_val = newVal;
					//POST COMMIT
					//		trace(name+":BooleanVO.postcommit" + _val);

					onChanged(newVal, oldVal, DATA_CHANGE);
				}
			}		
		}

		public function get value() : Boolean {
			return _val;
		}

		public function set defaultValue(defVal : Boolean) : void {
			_defval = defVal;
		}

		public function toggle() : void {
			trace("BooleanVo.toggle()");
			value = !value;
		}

		public function resetToDefaults() : void {
			value = _defval;	
		}

		override public function toString() : String {
			return _val.toString();
		}
	}
}