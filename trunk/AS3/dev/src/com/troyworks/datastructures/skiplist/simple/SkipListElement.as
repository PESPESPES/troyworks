package com.troyworks.datastructures.skiplist.simple { 
	/*
	* Skip lists offer good performance for both random
	* and sorted input without the need to do any kind of reorganization.
	* This relatively new structure first came to light in the 1989 work
	*  of Bill Pugh from Department of Computer Science at the University of Maryland.
	* In his original paper, which is freely available at ftp://ftp.cs.umd.edu/pub/skipLists/,
	*  Pugh provides details into the mathematical background.
	*
	* This is a port of the java version here
	* http://www.ftponline.com/Archives/premier/mgznarch/javapro/1998/jp_aprmay_98/tw0498/tw0498.asp#applet
	*
	* author: Troy Gardner 9/7/2004 www.troyworks.com
	*
	* Example Usage:
	* var  anElement:SkipListElement =  new SkipListElement(3, 142, "Jim");
	* this uses a Number for a Keyboard and an Object for the value.
	* */
	import flash.ui.Keyboard;
	public class SkipListElement
	{
	   // Constructor:
	   //   Constructs a new list element
	   public function SkipListElement( level:Number, key:Number, value:Object)
	   {
	      this.key = key;
	      this.value = value;
		  //SkipListElement array
		  //since it operates on a list forward represents
		  // the list of forward pointers (A, B, C)
		  //`
		  // HDR           NIL
	      // 2--C----------->2
	      // 1--B------->[]->1
		  // 0--A-->[]-->[]->0
	      this.forward =new Array(level+1);
	   }
	   // accessible attributes:
	   public var key:Number;     // key data
	   public var value:Object;   // associated value
	   // array of forward pointers (SkipListElement) //
	   public var forward:Array;
	}
}