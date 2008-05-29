/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.util {

	public class NumberUtil {
		public static function snap (src:Number, range:Number, base:Number):Number {
			var dif = (src-base)%range;
			var n = src-dif;
			if (dif>0) {
				if (dif>range/2) {
					n += range;
				}
			} else if (dif<-range/2) {
				n -= range;
			}
			return n;
		}
	}
	
}
