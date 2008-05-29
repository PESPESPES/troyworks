package com.troyworks.util { 
	 //binary are stored in strings, so bit
	public class BitFlag extends Object
	{
		public static const ALLBITSOFF : int = 0;
		public static const ALLBITSON : int = ~0;
		
		
		public function BitFlag (bint : int)
		{
		//	this = bint;
		}
	//	public function toBinary():int
	//	{
	//		return BitFlag.toBinary (this);
	//	};
		//////////Static Methods////////////////////
		/***********************************************************
		 * This is a utility to output ints as formatted strings
		 * typically representative of the bits when masked.
		 *	//		trace ("filtered      " +  BitFlag.toBinary(tmp));
		//		trace ("interested in " + BitFlag.toBinary (tmp, WHOLE_MASK));
		///   32---------------1 position
		//    010101010100101001 with no mask
		//    ----------001010-- with mask input as arg 2
		// One could use the following:
		//trace(myColorValue.toString(16)); // hexadecimal: ff00cc
	    //trace(myColorValue.toString(2)); // binary: 111111110000000011001100
	   // but those only works well with RGB values because the toString method has a maximum value of 24bits/ 2147483647 (0x7FFFFFFF), which ARGB values will exceed.
	   // This doesn't have that limiation 
		 */
		public static function toBinary (bits:int, bitMask:int):String
		{
			//trace("toBinary " +arguments[0] + " " + arguments[1] );
			var output:String = "";
			var temp = arguments[0];
			var mask = arguments[1];
			for (var i:int = 0; i < 32; i ++)
			{
				if(mask  != null ){
			//		trace("mask isn't null");
					if((mask&1)){
						output = (temp & 1) + output;
					}else {
						output = "-" + output;
					}
					mask >>=1;
	
				}else{
					output = (temp & 1) + output;
				}
				// store the binary one's place digit
				temp >>= 1;
				// shift temp right one binary digit
	
			}
			return output;
		};
		public static function generateBinary():String
		{
			var ky:Array = new Array (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			for (var i:int = 0; i < arguments.length; i ++)
			{
				var index:int = arguments [i];
				//since Flash uses 32 bits make sure we range check
				if (index > 0 && index < 33)
				{
					ky [32 - index] = 1;
					//flash is big-endian
	
				}
			}
			return (ky.join (""));
		};
		/* for a bitset and a bitmask, go through and find the index (from 1-32) of the
		 * on bits.
		 */
		public static function getOnBitIndex(bits:int, bitMask:int):Array{
			var res:Array = new Array();
			for (var i:int = 0; i < 32; i ++)
			{
				if(bitMask  != null ){
			//		trace("mask isn't null");
					if((bitMask&1) && bits&1){
				//		trace("masked bit is on");
						//MASKED BIT IS ON
						res.push(i);
					}else {
						//MASKED BIT IS OFF
				//		trace("masked bit is off");
	//					output = "-" + output;
					}
	//				bits >>=1;
					bitMask >>=1;
	
				}else{
					if(bits & 1){
						// UNMASKED BIT IS ON
				//		trace("unmasked bit is on");
						res.push(i);
						
					}else{
						//UNMASKED BIT IS OFF
				//		trace("unmasked bit is off");
					}
				}
				// store the binary one's place digit
				bits >>= 1;
				// shift temp right one binary digit
	
			}
			return res;
		}
		/* for a bitset and a bitmask, go through and find the BitFlag value (e.g. 1,2,4,8,16,32...) of the
		 * on bits.
		 */
		
			public static function getOnBitBF(bits:int, bitMask:int):Array{
			var res:Array = new Array();
			for (var i:int = 0; i < 32; i ++)
			{
				if(bitMask  != null ){
			//		trace("mask isn't null");
					if((bitMask&1)&& (bits&1)){
						//BIT IS ON
						res.push(1<<i);
					}else {
	//					output = "-" + output;
					}
					bitMask >>=1;
	
				}else{
					if(bits & 1){
						// UNMASKED BIT IS ON
						res.push(1<<i);
						
					}
				}
				// store the binary one's place digit
				bits >>= 1;
				// shift temp right one binary digit
	
			}
			return res;
		}
		///////////////////////////////////////////////////////////////////
		// creates a big flag 1-32 being valid values for a 32 bit flag
		// where position 1 = 1, position 32 = large int
		//	a = BitFlag.create(1, 2, 5, 6);
		//	b = BitFlag.create(1, 3, 5, 7);
		// returns:
		//  a        00000000000000000000000000110011
		//  b        00000000000000000000000001010101
		// a = BitFlag.create(1);
		// trace("a =" + a); // return a = 1;
	
		public static function create ():int
		{
			var output:int = 0;
			for (var i:int = 0; i < arguments.length; i ++)
			{
				var pos :int= arguments [i];
				//since Flash uses 32 bits make sure we range check
				if (pos > 0 && pos < 33)
				{
					output += Math.pow (2, pos - 1);
				}else{
					trace("BITFLAG.create WARNING, " + pos + " Arg out of range");
				}
			}
			//trace("creating bitflag: " + BitFlag.toBinary(output));
			return output;
		};
		///////////////////////////////
		// for a given range of positions,
		// turns them all on leaving the
		// other values alone
		public static function flipBitsON (bits:int, positions:int):int
		{
			bits |= positions;
			return bits;
		};
		///////////////////////////////
		// for a given range of positions,
		// turns them all off leaving anything
		// not in the positions alone
		public static function flipBitsOFF  (bits:int, positions:int):int
		{
			bits &= ~positions;
			return bits;
		};
		////////////////////////////////////////////////////
		// sets the bitflags values at the given position
		// to the exact bit pattern as provided in desiredBitValues
		//bitflag 11111111111111111111111111111100
		//mask    00000000000000000000000000000011
		//desired 00000000000000000000000000000001
		//after   11111111111111111111111111111101
		public static function setBitsAtTo  (bitflag:int, desiredBitValues:int, atPositions:int):int
		{
		//	trace ("current " + BitFlag.toBinary (bitflag));
		//	trace ("desired " + BitFlag.toBinary (desiredBitValues));
		//	trace ("at      " + BitFlag.toBinary (atPositions));
			//sett all off at the mask first the set the desired bits on to on.
			bitflag &= ~atPositions;
			bitflag |= desiredBitValues;
			return bitflag;
		};
		public static function getBitsAt  (bitflag:int, atPositions:int):int
		{
			//01010101010101010
			//00000000001111100
			//&---------01010--
			var res = bitflag & atPositions;
	//		trace ("res     " + BitFlag.toBinary (res));
			return res;
		};
		public static function getintBitsON  (bits:int, mask:int):int
		{
			var count:int = 0;
			if (mask != null)
			{
				bits &= mask;
			}
			for (var i:int = 0; i < 32; i ++)
			{
				if ((bits & 1) == 1)
				{
					trace ("i" + i + " " + (bits & 1));
					count ++;
				}
				// store the binary one's place digit
				bits >>= 1;
				// shift temp right one binary digit
	
			}
			return count;
		};
		public static function getScoredMatch (a:int, b:int, bitmask:int):Object
		{
			if (bitmask != null)
			{
				a &= bitmask;
				b &= bitmask;
			} else
			{
				a &= b;
				bitmask = b;
			}
			var hitcount:int = 0;
			var bincount:int = 0;
			for (var i = 0; i < 32; i ++)
			{
				if ((a & 1) == 1)
				{
					trace ("i" + i + " a:" + (a & 1));
					hitcount ++;
				}
				if ((bitmask & 1) == 1)
				{
					trace ("i" + i + " bitmask:" + (bitmask & 1));
					bincount ++;
				}
				// store the binary one's place digit
				a >>= 1;
				bitmask >>= 1;
				// shift temp right one binary digit
	
			}
			var res = new Object ();
			if (bincount > 0)
			{
				res.score = hitcount / bincount;
				res.hits = hitcount;
				res.bins = bincount;
			}else{
				res = null;
			}
			trace ("hits: " + res.hits + " of " + res.bins + " match " + res.score);
			return res;
		};
		public static function isMatch (a:int, b:int, bitmask:int):Boolean
		{
			//keep only the bits from the mask
			if (bitmask != null)
			{
				a &= bitmask;
				b &= bitmask;
			} else
			{
				a &= b;
			}
			//see if they match
			return (a == b);
		};
		public static function isPartialMatch(a:int, b:int, bitmask:int):Boolean
		{
			//keep only the bits from the mask
			if (bitmask != null)
			{
				a &= bitmask;
				b &= bitmask;
			} else
			{
				a &= b;
			}
			//see if they match
			var res = a & b;
			trace ("partial match " + res);
			return (res > 0);
		};
		public static function isPartialMatchDetailed(a:int, b:int, bitmask:int):int
		{
			//keep only the bits from the mask
			if (bitmask != null)
			{
				a &= bitmask;
				b &= bitmask;
			} else
			{
				a &= b;
			}
			//see if they match
			var res = a & b;
			trace ("partial match " + res);
			return (res);
		};
	}
}