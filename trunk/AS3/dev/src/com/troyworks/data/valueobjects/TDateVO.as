package com.troyworks.data.valueobjects {
	import com.troyworks.data.DataChangedEvent;
	import com.troyworks.util.datetime.TDate;

	public class TDateVO extends ValueObject {
		private var _val : TDate = null;
		private var _defval  : TDate = null;
		

		public function TDateVO(val : TDate, func : Function = null) {
			super(func);
			_val = val;
		}

		public function set value(newVal : TDate) : void {
			if(!isWriteable) {
				return;
				
			}
				trace("TDateVO.setValue from " + _val.time + " to  " + newVal.time);
			if(constraint != null) {
				trace("TDateVO.cosntrat value");
				newVal = constraint(newVal);
			}
			trace("TDateVO.value change " + _val.time + " !=  " + newVal.time);
			if (_val.time != newVal.time) {
			
				var evt : DataChangedEvent = onChanged(newVal, _val, PRE_DATA_CHANGED);
				if(evt && evt.cancelable && evt.isCancelled){
				}else {
					_val = newVal;
					//POST COMMIT
				//		trace(name+":NumberVO.postcommit" + _val);
					
					onChanged(newVal, _val, DATA_CHANGED);
				}
				
			}else {
				trace("NO value change "  + _val);		
			}
		}
		public function set defaultValue(defVal:TDate):void{
			_defval = defVal;
		}
		public function get defaultValue() : TDate {
			return _defval;
		}
		public function resetToDefaults():void{
			value = new TDate(_defval.time); //value not reference	
		}

		public function get value() : TDate {
			return _val;
		}

		override public function toString() : String {
			return _val.toDateString();
		}
	}
}