package com.troyworks.data.bit { 

	//binary are stored in strings, so bit
	public class BitFlag extends Object {
		public static const ALLBITSOFF : uint = 0;
		public static const ALLBITSON : uint = ~0;

		public static const _0 : uint = 1 << 0;
		public static const _1 : uint = 1 << 1;
		public static const _2 : uint = 1 << 2;
		public static const _3 : uint = 1 << 3;
		public static const _4 : uint = 1 << 4;
		public static const _5 : uint = 1 << 5;
		public static const _6 : uint = 1 << 6;
		public static const _7 : uint = 1 << 7;
		public static const _8 : uint = 1 << 8;
		public static const _9 : uint = 1 << 9;
		public static const _10 : uint = 1 << 10;
		public static const _11 : uint = 1 << 11;
		public static const _12 : uint = 1 << 12;
		public static const _13 : uint = 1 << 13;
		public static const _14 : uint = 1 << 14;
		public static const _15 : uint = 1 << 15;
		public static const _16 : uint = 1 << 16;
		public static const _17 : uint = 1 << 17;
		public static const _18 : uint = 1 << 18;
		public static const _19 : uint = 1 << 19;
		public static const _20 : uint = 1 << 20;
		public static const _21 : uint = 1 << 21;
		public static const _22 : uint = 1 << 22;
		public static const _23 : uint = 1 << 23;
		public static const _24 : uint = 1 << 24;
		public static const _25 : uint = 1 << 25;
		public static const _26 : uint = 1 << 26;
		public static const _27 : uint = 1 << 27;
		public static const _28 : uint = 1 << 28;
		public static const _29 : uint = 1 << 29;
		public static const _30 : uint = 1 << 30;
		public static const _31 : uint = 1 << 31;

		
		public function BitFlag(buint : uint) {
		//	this = buint;
		}

		//	public function toBinary():uint
		//	{
		//		return BitFlag.toBinary (this);
		//	};
		//////////Static Methods////////////////////
		/***********************************************************
		 * This is a utility to output uints as formatted strings
		 * typically representative of the bits when masked.
		 *	//		trace ("filtered      " +  BitFlag.toBinary(tmp));
		//		trace ("uinterested in " + BitFlag.toBinary (tmp, WHOLE_MASK));
		///   32---------------1 position
		//    010101010100101001 with no mask
		//    ----------001010-- with mask input as arg 2
		// One could use the following:
		//trace(myColorValue.toString(16)); // hexadecimal: ff00cc
		//trace(myColorValue.toString(2)); // binary: 111111110000000011001100
		// but those only works well with RGB values because the toString method has a maximum value of 24bits/ 2147483647 (0x7FFFFFFF), which ARGB values will exceed.
		// This doesn't have that limiation 
		 * 			trace("Place00 " + BitFlag.toBinary(BitFlag.ALLBITSOFF)); 

		trace("Place1 " + BitFlag.toBinary(BitFlag._1)); 
		trace("Place2 " + BitFlag.toBinary(BitFlag._2)); 
		trace("Place3" + BitFlag.toBinary(BitFlag._3)); 
		trace("Place4 " + BitFlag.toBinary(BitFlag._4)); 
		trace("Place5 " + BitFlag.toBinary(BitFlag._5));
								 
		trace("Place29 " + BitFlag.toBinary(BitFlag._29)); 
		trace("Place30 " + BitFlag.toBinary(BitFlag._30)); 
		trace("Place31 " + BitFlag.toBinary(BitFlag._31)); 
		 */
		public static function toBinary(bits : uint,bitMask : Number = NaN, returnNumber:Boolean = true) : String {
			//	trace("toBinary " +arguments[0] + " " + arguments[1] );

			//if (bits == 0) return "00000000000000000000000000000001";
			var bits2:uint = bits;
			var output : String = "";
			var i : int;
			var n : int = 31;
			for (i = 0;i < n; ++i) {
				if(!isNaN(bitMask)) {
					//					trace("bitMask isn't null");
					if((bitMask & 1)) {
						output = (bits & 1) + output;
					} else {
						output = "-" + output;
					}
					bitMask >>= 1;
				} else {
					//		trace(i + " ouput " + output);
					output = (bits & 1) + output;
				}
				// store the binary one's place digit
				bits >>= 1;
				// shift temp right one binary digit
			}
			return (returnNumber) ?output + "="+bits2:output;
		};

		public static function toDecimal(bits : String) : Number {
			var i : Number;
			var b : Number;
			var result : Number = 0;
			for (i = 0;i < bits.length; i++) {
				b = Number(bits.charAt(bits.length - 2 - i));
				result += b * Math.pow(2, i);
			}
			return result;
		}

		
		public static function generateBinary(arguments : Array) : String {
			var ky : Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
			for (var i : uint = 0;i < arguments.length; i++) {
				var index : uint = arguments[i];
				//since Flash uses 32 bits make sure we range check
				if (index > 0 && index < 33) {
					ky[31 - index] = 1;
					//flash is big-endian
				}
			}
			return (ky.join(""));
		};

		/* for a bitset and a bitmask, go through and find the index (from 1-32) of the
		 * on bits.
		 */
		public static function getOnBitIndex(bits : uint ,bitMask : Number = NaN) : Array {
			var res : Array = new Array();
			var i : int = 0;
			var n : int = 32;
			for (;i < n; ++i) {
				if(!isNaN(bitMask) ) {
					//		trace("mask isn't null");
					if((bitMask & 1) && bits & 1) {
						//		trace("masked bit is on");
						//MASKED BIT IS ON
						res.push(i);
					}else {
						//MASKED BIT IS OFF
				//		trace("masked bit is off");
	//					output = "-" + output;
					}
					//				bits >>=1;
					bitMask >>= 1;
				} else {
					if(bits & 1) {
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

		public static function getOnBitBF(bits : uint, bitMask : uint) : Array {
			var res : Array = new Array();
			var i : int = 0;
			var n : int = 32;
			for (;i < n; ++i) {
				if(!isNaN(bitMask)) {
					//		trace("mask isn't null");
					if((bitMask & 1) && (bits & 1)) {
						//BIT IS ON
						res.push(1 << i);
					}else {
	//					output = "-" + output;
					}
					bitMask >>= 1;
				} else {
					if(bits & 1) {
						// UNMASKED BIT IS ON
						res.push(1 << i);
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
		// where position 1 = 1, position 32 = large uint
		//	a = BitFlag.create(1, 2, 5, 6);
		//	b = BitFlag.create(1, 3, 5, 7);
		// returns:
		//  a        00000000000000000000000000110011
		//  b        00000000000000000000000001010101
		// a = BitFlag.create(1);
		// trace("a =" + a); // return a = 1;

		public static function create(...rest) : uint {
			var output : uint = 0;
			var i : int = 0;
			//			var n:int = arguments.length;
			var n : int = rest.length;
			for (;i < n; ++i) {
				//				var pos :uint= arguments [i];
				var pos : uint = rest[i];
				//since Flash uses 32 bits make sure we range check
				if (pos > 0 && pos < 33) {
					output += Math.pow(2, pos - 1);
				} else {
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
		public static function flipBitsON(bits : uint, positions : uint) : uint {
			bits |= positions;
			return bits;
		};

		///////////////////////////////
		// for a given range of positions,
		// turns them all off leaving anything
		// not in the positions alone
		public static function flipBitsOFF(bits : uint, positions : uint) : uint {
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
		public static function setBitsAtTo(bitflag : uint, desiredBitValues : uint, atPositions : uint) : uint {
			//	trace ("current " + BitFlag.toBinary (bitflag));
			//	trace ("desired " + BitFlag.toBinary (desiredBitValues));
			//	trace ("at      " + BitFlag.toBinary (atPositions));
			//sett all off at the mask first the set the desired bits on to on.
			bitflag &= ~atPositions;
			bitflag |= desiredBitValues;
			return bitflag;
		};

		public static function getBitsAt(bitflag : uint, atPositions : uint) : uint {
			//01010101010101010
			//00000000001111100
			//&---------01010--
			var res : uint = bitflag & atPositions;
			//		trace ("res     " + BitFlag.toBinary (res));
			return res;
		};

		public static function getuintBitsON(bits : uint, mask : Number) : uint {
			var count : uint = 0;
			if (!isNaN(mask)) {
				bits &= mask;
			}
			var i : int = 0;
			var n : int = 32;
			for (;i < n; ++i) {
				if ((bits & 1) == 1) {
					trace("i" + i + " " + (bits & 1));
					count++;
				}
				// store the binary one's place digit
				bits >>= 1;
				// shift temp right one binary digit
			}
			return count;
		};

		public static function getScoredMatch(a : uint, b : uint, bitmask : Number) : Object {
			if (!isNaN(bitmask)) {
				a &= bitmask;
				b &= bitmask;
			} else {
				a &= b;
				bitmask = b;
			}
			var hitcount : uint = 0;
			var bincount : uint = 0;
			var i : int = 0;
			var n : int = 32;
			for (;i < n; ++i) {
				if ((a & 1) == 1) {
					trace("i" + i + " a:" + (a & 1));
					hitcount++;
				}
				if ((bitmask & 1) == 1) {
					trace("i" + i + " bitmask:" + (bitmask & 1));
					bincount++;
				}
				// store the binary one's place digit
				a >>= 1;
				bitmask >>= 1;
				// shift temp right one binary digit
			}
			var res : Object = new Object();
			if (bincount > 0) {
				res.score = hitcount / bincount;
				res.hits = hitcount;
				res.bins = bincount;
			} else {
				res = null;
			}
			trace("hits: " + res.hits + " of " + res.bins + " match " + res.score);
			return res;
		};

		public static function isMatch(a : uint, b : uint, bitmask : Number) : Boolean {
			//keep only the bits from the mask
			if (!isNaN(bitmask)) {
				a &= bitmask;
				b &= bitmask;
			} else {
				a &= b;
			}
			//see if they match
			return (a == b);
		};

		public static function isPartialMatch(a : uint, b : uint, bitmask : Number) : Boolean {
			//keep only the bits from the mask
			if (!isNaN(bitmask)) {
				a &= bitmask;
				b &= bitmask;
			} else {
				a &= b;
			}
			//see if they match
			var res : Number = a & b;
			trace("partial match " + res);
			return (res > 0);
		};

		public static function isPartialMatchDetailed(a : uint, b : uint, bitmask : Number) : uint {
			//keep only the bits from the mask
			if (!isNaN(bitmask)) {
				a &= bitmask;
				b &= bitmask;
			} else {
				a &= b;
			}
			//see if they match
			var res : Number = a & b;
			trace("partial match " + res);
			return (res);
		};
	}
}