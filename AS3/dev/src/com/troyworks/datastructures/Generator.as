package com.troyworks.datastructures { 
	/**
	* Returns a random collection, in a given distance around a midpoint.
	 * @author Troy Gardner
	 */
	public class Generator {
		public static function getRandomNumberSet(from:Number, items:Number, range:Number):ArrayX{
			var res:ArrayX = new ArrayX();
			var pot:ArrayX = new ArrayX();
			//fill potentials
			var minRange:Number = from - Math.round(.5* range);
			var maxRange:Number = from + Math.round(.5* range);
			for(var i = minRange; i< maxRange; i++){
				pot.push(i);
			}
			while(items--){
				res.push(pot.getRandomElement(null,null, res));
			}
			return res;
		}
	}
}