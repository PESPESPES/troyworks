package com.troyworks.geom.d1 {

	/**
	 * LineQuery
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Nov 16, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class LineQuery extends Line1D { 
		public var minRelationToMin : String = ANY;
		public var minRelationToMax : String = ANY;

		public var maxRelationToMin : String = ANY;
		public var maxRelationToMax : String = ANY;
		//RESULTS 
		private var _minIn:Number;
		private var _maxIn:Number;
		protected var finalRes : Boolean;
		protected var minPassesMin : Boolean;
		protected var minPassesMax : Boolean;
		protected var maxPassesMin : Boolean;
		protected var maxPassesMax : Boolean;
		public static const ANY : String = "**";
		public static const LESS_THAN : String = "<";
		public static const LESS_THAN_OR_EQUAL_TO : String = "<=";
		public static const EQUAL_TO : String = "==";
		public static const NOT_EQUAL_TO : String = "!=";
		public static const GREATER_THAN_OR_EQUAL_TO : String = ">=";
		public static const GREATER_THAN : String = ">";

		
		///line relations comparison
		//                                      MIN     MAX
		//completely outside (to the left) .***..[-------]...... DOESNT INTERSECT
		//completely outside (to the right)......[-------]..***. DOESNT INTERSECT
		//overlapping left side           .....**[*------]...... ENDS 
		//overlapping right side          .......[------*]**.... STARTS
		//completely inside                ......[--***--]...... STARTS AND ENDS
		//touches both sides               ......[*****--]...... EQUALS LEFT
		//touches both sides               ......[--*****]...... EQUALS RIGHT
		//touches both sides               ......[*******]...... EQUALS LEFT+RIGHT
		//overlapping both sides          .....**[*******]**.... CONTINUES
		// SPATIAL QUERY
		// *
		// <                  **.. |..
		// <=                 **|..
		// ==                ..*|*..
		// =>		
		// >                 **|..
		// black to white results
		public var invert : Boolean = false;

		public function LineQuery(start : Number = NaN, length : Number = NaN, end : Number = NaN) {
			super(null, NaN, start, length, end);
		}

		public function passesMinCheck(val : Number, relationshipToA : String) : Boolean {
			var res : Boolean = false;
			switch(relationshipToA) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < A.position;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= A.position;
					break;
				case EQUAL_TO:
					res = val == A.position;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= A.position;
					break;
				case GREATER_THAN:
					res = val > A.position;
					break;
				case NOT_EQUAL_TO:
					res = val != A.position;
					break;
			}
			if(invert) {
				res = !res;
			}
			return res;
		}

		public function passesMaxCheck(val : Number,  relationshipToB : String) : Boolean {
			var res : Boolean = false;
			switch(relationshipToB) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < Z.position;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= Z.position;
					break;
				case EQUAL_TO:
					res = val == Z.position;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= Z.position;
					break;
				case GREATER_THAN:
					res = val > Z.position;
					break;
				case NOT_EQUAL_TO:
					res = val != A.position;
					break;
			}
			if(invert) {
				res = !res;
			}
			return res;
		}

		public function passesMinAndMaxCheck(minVal : Number, maxVal : Number) : Boolean {
			//trace(" passesMinAndMaxCheck "+ minVal + " " + maxVal);
			finalRes= false;
			_minIn = minVal;
			_maxIn = maxVal;
			minPassesMin  = passesMinCheck(_minIn, minRelationToMin);
			minPassesMax  = passesMaxCheck(_minIn, minRelationToMax);
			maxPassesMin  = passesMinCheck(_maxIn, maxRelationToMin);
			maxPassesMax  = passesMaxCheck(_maxIn, maxRelationToMax);
			finalRes = minPassesMin && minPassesMax && maxPassesMin && maxPassesMax;
			return finalRes;
		}

		//		public function passesMinOrMaxCheck(minVal : Number, maxVal : Number) : Boolean {
		//			var minPassesMin : Boolean = passesMinCheck(minVal);
		//			var minPassesMax : Boolean = passesMaxCheck(maxVal);
		//			return minPassesMin || minPassesMax;
		//		}
		public static function getStartsBetweenQuery(minVal:Number, maxVal:Number):LineQuery{
			var qry:LineQuery = new LineQuery(minVal, NaN,maxVal);
			qry.name = "startingBetween"+minVal+"And" + maxVal;
			qry.minRelationToMin = LineQuery.GREATER_THAN_OR_EQUAL_TO;
			qry.minRelationToMax = LineQuery.LESS_THAN;
			return qry;
		}
		public static function getEndsBetweenQuery(minVal:Number, maxVal:Number):LineQuery{
			var qry:LineQuery = new LineQuery(minVal, NaN,maxVal);
			qry.name = "endingBetween"+minVal+"And" + maxVal;
			qry.maxRelationToMin = LineQuery.GREATER_THAN_OR_EQUAL_TO;
			qry.maxRelationToMax = LineQuery.LESS_THAN;
			return qry;
		}
		
		override public function toString() : String {
			var res : Array = new Array();
			
			if(invert) {
				res.push(name + "???" + A.position + "......." + Z.position + "???");
//				res.push("???" + minRelationToMin + "," + minRelationToMax + ".........." + maxRelationToMax + "???");
			}else {
				res.push(name + "...." + A.position + "????????" + Z.position + "....");
	//			res.push("...." + minRelationToMin + "????????" + maxRelationToMax + "....");
			}
			var rest : String = minPassesMin + "" + minPassesMax + "" + maxPassesMin + "" + maxPassesMax;
			rest = rest.replace("false", "0");
			rest = rest.split("true").join("1");
			res.push(_minIn + " " + minRelationToMin + " " + A.position + ", " + _minIn + " " + minRelationToMax + " " + Z.position + ", " + _maxIn + " " + maxRelationToMin + " " + A.position + ", " + _maxIn + maxRelationToMax + " " + Z.position + " ==> " + rest + " ==> " + finalRes);
//			trace(_minIn + " " + minRelationToMin + " " + A.position + ", " + _minIn + " " + minRelationToMax + " " + Z.position + ", " + _maxIn + " " + maxRelationToMin + " " + A.position + ", " + _maxIn + maxRelationToMax + " " + Z.position + " ==> " + rest + " ==> " + finalRes);		
			return res.join("\r");	
		}
	}
}
