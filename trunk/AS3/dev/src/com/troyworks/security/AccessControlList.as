package com.troyworks.security { 
	import com.troyworks.util.BitFlag;
	 //binary are stored in strings, so bit
	public class AccessControlList extends Object{
		public var permissions:Number;
		public var validMask:Number;
		public function AccessControlList (permissions : Number, validMask:BitFlag) {
			this.permissions = BitFlag.ALLBITSOFF;
			this.validMask = BitFlag.ALLBITSOFF;
		}
		public function evaluateACL(permissionsAt:Number):Object{
			var o:Object = new Object();
			o.granted = this.permissions && this.validMask && permissionsAt;
			o.denied =  this.permissions && this.validMask && permissionsAt;
			trace("granted " + BitFlag.toBinary(o.granted, permissionsAt));
			trace("denied " + BitFlag.toBinary(o.denied, permissionsAt));
			return o;
		}
		public function evaluateAtPosition(permissionsAt:Number):Boolean{
			trace("NOt implemented");
			return true;
		}
		public function toString():String{
			var res:String = "SimpleACL " + BitFlag.toBinary(this.permissions, this.validMask);
			trace(res);
			return res;
		}
	}
}