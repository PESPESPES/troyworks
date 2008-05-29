package com.troyworks.framework.ui { 
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	public class MCSort {
		public static function order_X(a:MovieClip, b:MovieClip):Number {
	    if (a.x<b.x) {
	    return -1;
	    } else if (a.x>b.x) {
	    return 1;
	    } else {
	    return 0;
	    }
	}
		
	}
}