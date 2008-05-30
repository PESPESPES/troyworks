/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.data {

	public class Default {
		
		public function Default() {
			
		}
		public static function useIfNotNullOrBlank(val:String, defaultVal:String = null):String{
			var res:String = (val != null && val!= "")? val: defaultVal;
			return res;
		}
		public static function useDefaultIfNull(val:Object, defaultVal:Object = null):Object{
			var res:Object = (val != null )? val: defaultVal;
			return res;
		}
	}
	
}
