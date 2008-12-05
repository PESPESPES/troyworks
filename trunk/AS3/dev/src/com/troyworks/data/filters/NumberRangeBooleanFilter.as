package com.troyworks.data.filters { 
	
	/**
	 * @author Troy Gardner
	 */
	public class NumberRangeBooleanFilter extends RangeFilter {
		public var name:String ="";
		public var min:Number =0;
		public var max:Number = 0;
		
		
		public var minRelationToMin : String = ANY;
		public var minRelationToMax : String = ANY;

		public var maxRelationToMin : String = ANY;
		public var maxRelationToMax : String = ANY;

		public static const ANY : String = "**";
		public static const LESS_THAN : String = "<";
		public static const LESS_THAN_OR_EQUAL_TO : String = "<=";
		public static const EQUAL_TO : String = "==";
		public static const NOT_EQUAL_TO : String = "!=";
		public static const GREATER_THAN_OR_EQUAL_TO : String = ">=";
		public static const GREATER_THAN : String = ">";
		
		//RESULTS 
		private var _minIn:Number;
		private var _maxIn:Number;
		protected var finalRes : Boolean;
		protected var minPassesMin : Boolean;
		protected var minPassesMax : Boolean;
		protected var maxPassesMin : Boolean;
		protected var maxPassesMax : Boolean;
		
		// black to white results
		public var invert : Boolean = false;

		
		public function NumberRangeBooleanFilter(minVal:Number = NaN, maxVal:Number= NaN, minIsInclusive:Boolean = false, maxIsInclusive:Boolean = false) {
			super(minIsInclusive, maxIsInclusive);
			min = isNaN(minVal)?Number.MIN_VALUE :minVal;
			max = isNaN(maxVal)?Number.MAX_VALUE :maxVal;
		}
		public function setToSingleDigits() : void {
			max =  (max>9)?9:max;
			min =  (min<-9)?-9:min;
		}

		public function setToDoubleDigits() : void {
			max =   (max>99)?99:max;
			min =  (min<-99)?-99:min;
		}

		public function setToTripleDigits() : void {
			max =   (max>999)?999:max;			
			min =  (min<-999)?-999:min;	
		}
		
		public function expand(minVal:Number = NaN, maxVal:Number= NaN):void{
			if(minVal < min){
			 min = minVal;	
			}
			
			if(maxVal > max){
			  max = maxVal;	
			}
		}
		public function passesMinCheck(val : Number, relationshipToA : String) : Boolean {
			var res : Boolean = false;
			switch(relationshipToA) {
				case ANY:
					res = true;
					break;
				case LESS_THAN:
					res = val < min;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= min;
					break;
				case EQUAL_TO:
					res = val == min;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= min;
					break;
				case GREATER_THAN:
					res = val > min;
					break;
				case NOT_EQUAL_TO:
					res = val != min;
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
					res = val < max;
					break;
				case LESS_THAN_OR_EQUAL_TO:
					res = val <= max;
					break;
				case EQUAL_TO:
					res = val == max;
					break;
				case GREATER_THAN_OR_EQUAL_TO:
					res = val >= max;
					break;
				case GREATER_THAN:
					res = val > max;
					break;
				case NOT_EQUAL_TO:
					res = val != max;
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
		
		public function get	length():Number{
			
			return max - min;
		}
		override public function passesFilter(itemVal:*, index:int= 0, array:Array = null):Boolean {
		//public function passesMinAndMaxCheck(minVal : Number, maxVal : Number) : Boolean {
			//trace(" passesMinAndMaxCheck "+ minVal + " " + maxVal);
			finalRes= false;
			_minIn = itemVal;
			_maxIn = itemVal;
			minPassesMin  = passesMinCheck(_minIn, minRelationToMin);
			minPassesMax  = passesMaxCheck(_minIn, minRelationToMax);
			maxPassesMin  = passesMinCheck(_maxIn, maxRelationToMin);
			maxPassesMax  = passesMaxCheck(_maxIn, maxRelationToMax);
			finalRes = minPassesMin && minPassesMax && maxPassesMin && maxPassesMax;
			return finalRes;
		}
		
	/*    override public function passesFilter(itemVal:*, index:int= 0, array:Array = null):Boolean {
		//	trace("filter " + itemVal +" [" +this.min + " " + this.max +"]");
			var passes:Boolean = true;
			if(minI){
				if (itemVal<=this.min) {
					return false;
				} else {
				}
			} else {
			//	trace("B");
				if (itemVal<min) {
					return false;
				} else {
				}
			}
			if (maxI) {
			//	trace("C");
				if (max<=itemVal) {
					return false;
				} else {
				}
			} else {
			//	trace("D");
				if (max<itemVal) {
					return false;
				} else {
				}
			}
			return passes;
		};
		*/
/*		public function toString():String{
			var res:Array = new Array();
			
			res.push((minI?("["+min):(min+"]")));
			
			res.push((maxI?(max+"]"):("["+max)));
			
			return res.join("");	
		}*/
		public function toString() : String {
			var res : Array = new Array();
			
			if(invert) {
				res.push(name + "???" + min + "......." + max + "???");
//				res.push("???" + minRelationToMin + "," + minRelationToMax + ".........." + maxRelationToMax + "???");
			}else {
				res.push(name + "...." + min + "????????" + max + "....");
	//			res.push("...." + minRelationToMin + "????????" + maxRelationToMax + "....");
			}
			var rest : String = minPassesMin + "" + minPassesMax + "" + maxPassesMin + "" + maxPassesMax;
			rest = rest.replace("false", "0");
			rest = rest.split("true").join("1");
			res.push(_minIn + " " + minRelationToMin + " " + min + ", " + _minIn + " " + minRelationToMax + " " + max + ", " + _maxIn + " " + maxRelationToMin + " " + min + ", " + _maxIn + maxRelationToMax + " " + max + " ==> " + rest + " ==> " + finalRes);
//			trace(_minIn + " " + minRelationToMin + " " + A.position + ", " + _minIn + " " + minRelationToMax + " " + B.position + ", " + _maxIn + " " + maxRelationToMin + " " + A.position + ", " + _maxIn + maxRelationToMax + " " + B.position + " ==> " + rest + " ==> " + finalRes);		
			return res.join("\r");	
		}
		
	}
}