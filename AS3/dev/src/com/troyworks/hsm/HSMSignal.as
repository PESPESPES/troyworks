package com.troyworks.hsm { 
	//import com.troyworks.statemachine.*;
	//enumerated type for available signals
	public class HSMSignal extends Number {
		public static var HSM_EMPTY_SIG:HSMSignal = new HSMSignal(0, "HSM_EMPTY_SIG");
		public static var HSM_INIT_SIG:HSMSignal = new HSMSignal(1, "HSM_INIT_SIG");
		public static var HSM_ENTRY_SIG:HSMSignal = new HSMSignal(2, "HSM_ENTRY_SIG");
		public static var HSM_EXIT_SIG:HSMSignal = new HSMSignal(4, "HSM_EXIT_SIG");
		public static var HSM_USER_SIG:HSMSignal = new HSMSignal(8, "HSM_USER_SIG");
	
		protected var __name : String;
		protected function HSMSignal (val : Number, name : String)
		{
			super (val);
			this.__name = name;
		}
		public function get name():String{
			return this.__name;
		}
		public function toString():String{
			return this.name + super.toString();
		}
		public static function parse(o:Object):HSMSignal{
			var n:Number = -1;
			if( typeof(o) == "string"){
				n = parseInt(String(o));
			}else if(typeof(o)== "number"){
				n = Number(o);
			}else {
				return null;
			}
			for(var i in HSMSignal){
			//	trace("comparing " + i + Signal[i]);
				var oc =  HSMSignal[i];
				if(o ==  oc ){
					return oc;
				}
			}
			return null;
		}
	}
}