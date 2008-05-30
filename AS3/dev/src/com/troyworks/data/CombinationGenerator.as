package com.troyworks.data {
	import com.troyworks.data.Generator;
	
	/**
	 * CombinationGenerator
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: May 6, 2008
 *	Array combinator class used to generate all combinations of items in array.
 *
 * 	Based on Java Combination Generator (http://www.merriampark.com/comb.htm)
 *	by Michael Gilleland (Merriam Park Software)
 *
 *	@author Tomas Lehuta (lharp@lharp.net)
	 *
	 */
	public class CombinationGenerator extends Generator {


	// Combination array
	private var $comb:Array;

	// Combination number
	private var $k:Number;

	/**
	 *	Combinator constructor
	 *
	 * 	@param	data	Data array to use for combinations
	 * 	@param	len		Length of combination arrays
	 */
	public function CombinationGenerator(data:Array, len:Number)
	{
		super(data);

		init(len);
	}

	/**
	 *	Initializes combinator with given combination number.
	 *
	 *	@param	k	Combination number that defines the number of items
	 */
	override public function init(k:int = -1):void
	{
		super.init();

		$k = (k != -1 && k <= $len) ? k : $len;

		$comb = new Array($k);
		$total = factorial($len) / (factorial($k) * factorial($len - $k));

		reset();
	}

	/**
	 * 	Resets combinator.
	 */
	override public function reset():void
	{
		var len:Number = $comb.length;
		for (var i:Number = 0; i < len; i++) {
			$comb[i] = i;
		}
		$left = $total;
	}

	/**
	 * 	Returns current combination.
	 *
	 * 	@return	Current combination array
	 */
	override public function current():Array
	{
		// create current data combination
		var len:Number = $comb.length;
		var data:Array = new Array(len);
		for (var i:Number = 0; i < len; i++) {
			data[i] = $data[$comb[i]];
		}
		return data;
	}

	/**
	 * 	Returns next combination.
	 *
	 * 	@return	Next combination array
	 */
	override public function next():Array
	{
		if (hasMore()) {
			if ($left-- < $total) {
				var i:Number = $k - 1;
				while ($comb[i] == $len - $k + i) i--;
				$comb[i]++;

				for (var j:Number = i + 1; j < $k; j++) {
					$comb[j] = $comb[i] + j - i;
				}
			}
			return current();
		}
		return null;
	}

	/**
	 * 	Generates all combinations of given data with given length.
	 *
	 * 	@param	data	Data array to use for combinations
	 * 	@param	len		Length of combination arrays
	 * 	@return	Array of all combinations
	 */
	public static function generate(data:Array, len:Number):Array
	{
		var result:Array = new Array();
		var g:Generator = new CombinationGenerator(data, len);
		while (g.hasMore()) {
			result.push(g.next());
		}
		return result;
	}

	}
}
