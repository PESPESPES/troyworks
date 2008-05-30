/**
* A utility fascade for making sure that external interfaces calls
* a) are only called when ExternalInterface is available to eliminate security errors
* when running outside of the file
* b) Mandates that required parameters exist, as sometimes error trapping from the ExternalIntefface 
* may not work as expected.
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.io {
	import flash.external.*;
	public class ExternalInterfaceUtil {
		//public static function add
		public static function call1(arg1:String):Object{
			
			if(ExternalInterface.available){
				if(arg1 == null){
					throw new Error("ExternalInterfaceUtil.call1 argument cannot be null");
				}
				return ExternalInterface.call(arg1);
			}
			return null;
		}
		public static function call2(arg1:String, arg2:String):Object{
			
			if(ExternalInterface.available){
				if(arg1 == null){
					throw new Error("ExternalInterfaceUtil.call2 argument1 cannot be null");
				}
				if(arg2 == null){
					throw new Error("ExternalInterfaceUtil.call2 argument2 cannot be null");
				}

				return ExternalInterface.call(arg1, arg2);
			}
			return null;
		}
		public static function call3(arg1:String, arg2:String, arg3:String):Object{
			
			if(ExternalInterface.available){
				if(arg1 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument1 cannot be null");
				}
				if(arg2 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument2 cannot be null");
				}
				if(arg3 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument3 cannot be null");
				}
				return ExternalInterface.call(arg1, arg2, arg3);
			}
			return null;
		}
		public static function call4(arg1:String, arg2:String, arg3:String, arg4:String):Object{
			
			if(ExternalInterface.available){
				if(arg1 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument1 cannot be null");
				}
				if(arg2 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument2 cannot be null");
				}
				if(arg3 == null){
					throw new Error("ExternalInterfaceUtil.call3 argument3 cannot be null");
				}
				if(arg4 == null){
					throw new Error("ExternalInterfaceUtil.call4 argument4 cannot be null");
				}

				return ExternalInterface.call(arg1, arg2, arg3, arg4);
			}
			return null;
		}

	}
	
}
