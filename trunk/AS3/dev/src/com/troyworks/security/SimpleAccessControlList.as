package com.troyworks.security { 
	import com.troyworks.util.BitFlag;
	//binary are stored in strings, so bit
	public class SimpleAccessControlList extends Object
	{
		public static var className : String = "SimpleAccessControlList";
		public var permissions : Number;
		public var validMask : Number;
		public var resourceID : Number;
		public function SimpleAccessControlList (permissions : Number, validMask : Number)
		{
			this.permissions = BitFlag.ALLBITSOFF;
			this.validMask = BitFlag.ALLBITSOFF;
		}
		public function evaluateACL (permissionsAt : Number) : Object
		{
			var o : Object = new Object ();
			o.granted = this.permissions && this.validMask && permissionsAt;
			o.denied = this.permissions && this.validMask && permissionsAt;
			trace ("granted " + BitFlag.toBinary (o.granted, permissionsAt));
			trace ("denied " + BitFlag.toBinary (o.denied, permissionsAt));
			return o;
		}
		public function grantAt (permissionsAt : Number) : void {
			this.permissions = BitFlag.flipBitsON (this.permissions, permissionsAt);
			this.validMask = BitFlag.flipBitsON (this.validMask, permissionsAt);
		}
		public function denyAt (permissionsAt : Number) : void {
			this.permissions = BitFlag.flipBitsOFF (this.permissions, permissionsAt);
			this.validMask = BitFlag.flipBitsON (this.validMask, permissionsAt);
		}
		public function clearAt (permissionsAt : Number) : void {
			this.permissions = BitFlag.flipBitsOFF (this.permissions, permissionsAt);
			this.validMask = BitFlag.flipBitsOFF (this.validMask, permissionsAt);
		}
		//XXX implement me
		public function evaluateAtPosition (permissionsAt : Number) : Boolean
		{
			throw new Error("SimpleAccessControlList.evaluateAtPosition not implemented");
			return false;
		}
		public function isGrantedAt (permissionsAt : Number) : Boolean
		{
			//trace("IsGranted \r VG:\t" + BitFlag.toBinary (this.permissions, this.validMask) + "\r Ct:\t"+ BitFlag.toBinary (BitFlag.ALLBITSON,permissionsAt));
			var mask : Number = (this.validMask & permissionsAt);
			if (mask > 0)
			{ //has positions to test
				//	trace(" mk:\t" + BitFlag.toBinary (~0, mask) );
				//	trace(" pr:\t" + BitFlag.toBinary (this.permissions, permissionsAt) );
				var res : Number = this.permissions & mask;
				//	trace(" rs:\t" + BitFlag.toBinary (res) + " dec " + res);
				return (res > 0);
			} else
			{
			 //has no positions to test
			 return false;
			}
		}
		public function isDeniedAt (permissionsAt : Number) : Boolean
		{
			var mask : Number = (this.validMask & permissionsAt);
			if (mask > 0)
			{ //has positions to test
				//	trace(" mk:\t" + BitFlag.toBinary (~0, mask) );
				//	trace(" pr:\t" + BitFlag.toBinary (this.permissions, permissionsAt) );
				var res : Number = this.permissions & mask;
				//	trace(" rs:\t" + BitFlag.toBinary (res) + " dec " + res);
				return (res == 0);
			} else
			{
			 //has no positions to test
			 return false;
			}
		}
		public function toString () : String
		{
			var r : String = "SimpleACL \r G:\t" + BitFlag.toBinary (this.permissions) + "\r V:\t" + BitFlag.toBinary (this.validMask) + " \r\t" + BitFlag.toBinary (this.permissions, this.validMask);
			//trace (r);
			return r;
		}
	}
	
}