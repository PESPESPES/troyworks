package com.troyworks.data { 

	/**
	 * Returns a random collection, in a given distance around a midpoint.
	 * @author Troy Gardner
	 */
	public class Generator {
		// Data array to use
		protected var $data : Array;

		// Length of data array
		protected var $len : Number;

		// Number of iterations left
		protected var $left : Number;

		// Total number of iterations
		protected var $total : Number;

		
		/**
		 *	The number of iterations left
		 */
		public function get left() : Number {
			return $left;
		}

		/**
		 *	The number of total iterations
		 */
		public function get total() : Number {
			return $total;
		}

		/**
		 *	Generator constructor
		 *
		 * 	@param	data	Data array to use
		 */
		 function Generator(data : Array) {
			$data = data;
		}

		/**
		 *	Initializes generator.
		 */
		public function init(len:int = 0) : void {
			$len = $data.length;
		}

		/**
		 * 	Resets generator.
		 */
		public function reset() : void {
		// empty implementation
		}

		/**
		 * 	Checks if generator has more iterations left.
		 *
		 * 	@return	True or false
		 */
		public function hasMore() : Boolean {
			return $left > 0;
		}

		/**
		 * 	Returns current iteration.
		 *
		 * 	@return	Current iteration array
		 */
		public function current() : Array {
			return null;
		}

		/**
		 * 	Returns next iteration.
		 *
		 * 	@return	Next iteration array
		 */
		public function next() : Array {
			return null;
		}

		/**
		 *	Calculates factorial value of given number.
		 *
		 *	@param	n	Number value
		 *	@return	Factorial value
		 */
		public static function factorial(n : Number) : Number {
			var val : Number = 1;
			for (var i : Number = n;i > 1; i--) val *= i;
			return val;
		}

		
		public static function getRandomNumberSet(from : int, items : Number, range : int) : ArrayX {
			var res : ArrayX = new ArrayX();
			var pot : ArrayX = new ArrayX();
			//fill potentials
			var minRange : int = from - Math.round(.5 * range);
			var maxRange : int = from + Math.round(.5 * range);
			for(var i:int = minRange;i < maxRange; i++) {
				pot.push(i);
			}
			while(items--) {
				res.push(pot.getRandomElement(null, null, res));
			}
			return res;
		}
	}
}