package com.troyworks.framework.security { 
	import com.troyworks.data.bit.BitFlag;
	import com.troyworks.data.bit.MaskedBitFlag;
	 //binary are stored in strings, so bit
	public class AccessControlList extends MaskedBitFlag{

		public function AccessControlList (val : uint = NaN, mask:uint = NaN, name: String = ""){
			super(val, mask, name);
		}
		public function evaluateACL(permissionsAt:uint):Object{
			var o:Object = new Object();
			o.granted = b & m & permissionsAt;
			o.denied =  b & m & permissionsAt;
			trace("granted " + BitFlag.toBinary(o.granted, permissionsAt));
			trace("denied " + BitFlag.toBinary(o.denied, permissionsAt));
			return o;
		}
		public function evaluateAtPosition(permissionsAt:uint):Boolean{
			trace("NOt implemented");
			return true;
		}
		public function toString():String{
			var res:String = "SimpleACL " + BitFlag.toBinary(b, m);
			trace(res);
			return res;
		}
	}
}