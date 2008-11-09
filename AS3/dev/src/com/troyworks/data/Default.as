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
	
		public static function getBooleanFromString(att:String,def:Boolean):Boolean {
			if(att==null) {
				return def;
			}
			if(att=="true") return true;
			else return false;
		}
		public static function getNumberFromString(att:String,def:Number= NaN):Number {
			if(!isNaN(def) && att==null) {
				return def;
			}
			return Number(att);
		}
		public static function getString(att:String,def:String= null) :String{
			if(def!=null && att==null) {
				return def;
			}
			return String(att);
		}
	}
	
}
