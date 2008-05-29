/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.sketch {
	import flash.display.Sprite;

	public class LayoutUtil {
		public static const VISIBILE_PROPS:Array = ["alpha", "visible", "rotation", "xscale", "yscale", "x", "y"];
		public static function matchClips(mc1:Sprite, mc2:Sprite, props:Array = VISIBILE_PROPS){		
			trace("Matching");
			var L:Number = props.length;
			while (--L) {
				mc1[props[L]] =mc2[props[L]];
			}
		}
	}
	
}
