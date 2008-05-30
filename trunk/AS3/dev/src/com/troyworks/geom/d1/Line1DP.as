/**
* 
*  A point bound between two points on a line (inclusive or non-inclusive)
*  where length is the Z- A.
* 
* eg.:     A[......C.......]Z
* 
* Useful for volume slider like application models.
* 
* @author Troy Gardner
* @version 0.1
*/

package com.troyworks.geom.d1 {
	import flash.events.EventDispatcher;

	public class Line1DP extends EventDispatcher {
		
		public var _A : Point1D = null;
		public var _C : Point1D = null;
		public var _Z : Point1D = null;
		
		// A Constraints inclusive or not
		// Z Constraints inclusive or not
		// length is constrained to increments/grid
		
		public var length : Number = NaN;

		public var hasScaled:Boolean = false;
		public var hasLength:Boolean = false;
		
		public function Line1DP() {
			
		}
		///////// START POINT ////////////
		public function get A():Number{
			return _A.val;
		}
		public function set A(end:Number):void{
			A = end;
			//push z over.
			Z = A + length;
			length = end -A ;
			hasLength = (length != 0);
			
			//change event
		}
		///////// SETCURSOR POINT ////////////
		public function get C():Number{
			return _Z.val;
		}

		public function set C(pos:Number):void{
			//distance before
			//distance after
			//dispatch change
		}
		///////// END POINT ////////////
		public function get Z():Number{
			return _Z.val;
		}

		public function set Z(end:Number):void{
			Z = end;
			length = end -A ;
			hasLength = (length != 0);
			//change event
		}
	}
	
}
