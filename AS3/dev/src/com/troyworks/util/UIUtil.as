/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.util {
	import flash.display.Sprite;

	public class UIUtil {
		
		public static function match(changeClip:Sprite, toClip:Sprite, withProps:Array=null) :void{
			
			if (withProps == null) {
				withProps=[null, "alpha", "visible", "rotation", "scaleX", "scaleY", "x", "y"];
	
			}
			var L:Number = withProps.length;
			while (--L) {
				changeClip[withProps[L]] =toClip[withProps[L]];
			}
		}
	}
}
