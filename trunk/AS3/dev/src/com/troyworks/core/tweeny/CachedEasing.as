package com.troyworks.core.tweeny {

	/**
	 * CachedEasing is used to render a easing equasion to an array
	 * this can be used in a variety of contexts.
	 * 1) optmizing complicated easing equasions for runtime/playback
	 * 2) for weighting the ArrayWeighting.
	 * 
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Apr 28, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class CachedEasing {

		
		private var cache : Array;

		public function CachedEasing() {
			cache = new Array();	
		}

		/* Easing equation function for a simple linear tweening, with no easing.
		 *
		 * @param t		Current time (in frames or seconds).
		 * @param b		Starting value.
		 * @param c		Change needed in value.
		 * @param d		Expected easing duration (in frames or seconds).
		 * @return		The correct value.
		 */		

		public static function render(ease : Function, steps : int, t : Number = 0, b : Number = 0, c : Number = 1, d : Number = 1) : Array {
			var res : Array = new Array();
			var i:int = 0;
			var l:int = steps;
			var s:Number = d/steps;
			for(;i<l;++i){			
				res[i] = ease(t,b,c,d);
				t+= s;
			}
			return res;
		}
	}
}
