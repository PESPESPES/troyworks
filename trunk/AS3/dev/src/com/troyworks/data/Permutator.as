package com.troyworks.data {

	/**
	 * Permutator
	 * 
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: May 6, 2008
	 *	Array permutator class used to generate all permutations of items in array.
	 *	e.g. passed in A,B,C
	 *	
	 *OUTPUTS:	
	 *	A,B,C
     *  A,C,B
     *  B,A,C
     *  B,C,A
     *  C,A,B
     *  C,B,A
     *  
     *  Contrast this with Combinator 
	 *
	 * 	Based on Java Permutation Generator (http://www.merriampark.com/perm.htm)
	 *	by Michael Gilleland (Merriam Park Software)
	 *
	 *	@author Tomas Lehuta (lharp@lharp.net)
	 *	@author Troy Gardner (troy@troyworks.com) converted to AS3.0
	 *	@version 1.0
	 *
	 */
	public class Permutator extends Generator {
		// Permutation array
		private var $perm : Array;

		/**
		 *	Permutator constructor
		 *
		 * 	@param	data	Data array to use for permutations
		 * 	@param	size	Size of permutation arrays
		 */
		public function Permutator(data : Array) {
			super(data);

			init();
		}

		/**
		 *	Initializes permutator.
		 */
		override public function init(len:int = 0) : void {
			super.init();

			$perm = new Array($len);
			$total = Generator.factorial($len);

			reset();
		}

		/**
		 * 	Resets permutator.
		 */
		override public function reset() : void {
			var len : Number = $perm.length;
			for (var i : Number = 0;i < len; i++) {
				$perm[i] = i;
			}
			$left = $total;
		}

		/**
		 * 	Returns current permutation.
		 *
		 * 	@return	Current permutation array
		 */
		override public function current() : Array {
			// create current data permutation
			var len : Number = $perm.length;
			var data : Array = new Array(len);
			for (var i : Number = 0;i < len; i++) {
				data[i] = $data[$perm[i]];
			}
			return data;
		}

		/**
		 * 	Returns next permutation.
		 *
		 * 	@return	Next permutation array
		 */
		override public function next() : Array {
			if (hasMore()) {
				if ($left-- < $total) {
					var len : Number = $perm.length;

					// find largest index i with $perm[i] < $perm[i+1]
					var i : Number = len - 2;
					while ($perm[i] > $perm[i + 1]) i--;

					// find index j such that $perm[j] is smallest integer
					// greater than $perm[i] to the right of $perm[i]
					var j : Number = len - 1;
					while ($perm[i] > $perm[j]) j--;

					// swap $perm[i] and $perm[j];
					swap($perm, i, j);

					// put tail end of permutation after i-th position in increasing order
					var k : Number = len - 1;
					var l : Number = i + 1;
					while (k > l) {
						swap($perm, k, l);
						k--;
						l++;
					}
				}
				return current();
			}
			return null;
		}

		/**
		 * 	Generates all permutations of given data.
		 *
		 * 	@param	data	Data array to use for permutations
		 * 	@return	Array of all permutations
		 */
		public static function generate(data : Array) : Array {
			var result : Array = new Array();
			var g : Generator = new Permutator(data);
			while (g.hasMore()) {
				result.push(g.next());
			}
			return result;
		}

		/**
		 *	Swaps values between two indexes of given data array.
		 *
		 *	@param   i	First index
		 *	@param   j	Second index
		 */
		private static function swap(data : Array, i : Number, j : Number) : void {
			var temp : Number = data[j];
			data[j] = data[i];
			data[i] = temp;
		}
	}
}
