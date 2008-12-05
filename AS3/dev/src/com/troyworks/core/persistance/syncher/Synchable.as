package com.troyworks.core.persistance.syncher { 

	 public class Synchable extends Object
	{
		public function Synchable(){
			trace("new Synchable");
				
			
		}
		public function init():void{
	
		}
		public function initFromDiskXML():void{
	
		}
		/////////////////////////////////////////////
		//
		public function getHashCode () : Number
		{ 
			return null;
		}
		public function compareTo (o : Object) : Number
		{
			return null;
		}
		public function equals (o : Object) : Boolean
		{
			return null;
		}
		/*Ideally, a hashcode should be:
	
		0. equal for equal object (this is mandatory!)
		1. fast to compute
		2. based on all or most of the internal state of
		an object.
		3. use all or most of the space of 32-bit integers
		in a fairly uniform way
		4. likely to be different even for objects that are
		very similar */
		/**
		* simplified version of how String.hashCode works.
		* For the actual version see src.jar java/lang/String.java
		* @return a hash code value for this String.
		*/
	//	public function hashCode ():Number
	//	{
	//		// inside the String is a char[] val that holds the characters.
	//		var hash:Number = 0;
	//		var len:Number = char.length ();
	//		for (int i = 0; i < len; i ++)
	//		{
	//			hash = 31 * hash + val [i];
	//		}
	//		return hash;
	//	}
		/**
		Here is a fast hash algorithm you can apply to bytes, short, chars, ints, arrays etc. I used an assembler version of it it my BBL Forth compiler hashcode where it is essentially implemented in two instructions, ROL and XOR.
		* Java version of the assembler hashCode used in the BBL Forth compiler.
		* @return a hash code value for the byte[] val byte array in this object.
		*/
	//	public int hashCode ()
	//	{
	//		//  byte[] val  holds the data.
	//		int hash = 0;
	//		int len = val.length ();
	//		for (int i = 0; i < len; i ++)
	//		{
	//			// rotate left and xor (very fast in assembler, a bit clumsy in Java)
	//			hash <<= 1;
	//			if (hash < 0 )
	//			{
	//				hash |= 1;
	//			}
	//			hash ^ = val [i];
	//		}
	//		return hash;
	//	}
	}
	
}