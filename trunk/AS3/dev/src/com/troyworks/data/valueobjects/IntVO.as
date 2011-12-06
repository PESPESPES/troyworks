package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;

	public class IntVO extends ValueObject {
		private var _val : int = 0;
		private var _defval : int = NaN;

		public function IntVO(val : int, func : Function = null) {
			super(func);
			_val = val;
		}

		public function set value(newVal : int) : void {
			if(!isWriteable) {
				return;
			}
			
			if(constraint != null) {
				newVal = constraint(newVal);
			}
			if (_val != newVal) {
				//PRE COMMIT
				//				trace(name+":BooleanVO.precommit" + newVal);

				var evt : DataChangedEvent = onChanged(newVal, _val, PRE_DATA_CHANGED);
				if(evt && evt.cancelable && evt.isCancelled) {
				} else {
					var oldVal : Object = _val;
					_val = newVal;
					//POST COMMIT
					//		trace(name+":BooleanVO.postcommit" + _val);

					onChanged(newVal, oldVal, DATA_CHANGED);
				}
			}
		}

		public function get value() : int {
			return _val;
		}
		public function set defaultValue(defVal:int):void{
			_defval = defVal;
		}
		public function get defaultValue() : int {
			return _defval;
		}
		public function resetToDefaults():void{
			value = new int(_defval); //value not reference	
		}

		override public function toString() : String {
			return _val.toString();
		}
	}
}