package com.troyworks.datastructures { 
	 /*
	* A replacement for the built in Array values, that permit shuffling and shifting of child values.
	*
	* var s_ary = new ShiftingArray(1,2,3);
	* trace(s_ary); //1,2,3
	* s_ary.shuffle();
	* trace(s_ary); //3,1,2
	*/
	public class Array2D extends ArrayX
	{
		public function Array2D ()
		{
			//super();--won't work see http://chattyfig.figleaf.com/ezmlm/ezmlm-cgi?1:msn:108710:gfdhpdjdimjpaiklabja
			//and this http://chattyfig.figleaf.com/ezmlm/ezmlm-cgi?1:mss:90590:gfdhpdjdimjpaiklabja
			splice.apply (this, Array([0, 0]).concat (arguments));
			//trace("XXXX Array2" + this.join);
			for(var i in this){
			_global.ASSetPropFlags (this, i, 1);
	//		_global.ASSetPropFlags (this, "swapPlaces", 1);
			}
			
		}
		public function getItem(x:Number, y:Number):Object{
			return this[x][y];
		}
		public function appendArray(ary:Array):void{
				for (var i : Number = 0; i < ary.length; i++) {
					this.push(ary[i]);
				}
		}
		public function swapPlaces (objA : Object, objB : Object) : Array2
		{
			//find positions of existing objects
			//create mapping
			var aI = getLastIndexOf(objA);
			var bI = getLastIndexOf(objB);
			if(aI == -1 || bI == -1){
				trace("error in swap places, could not find one of the elements");
				return null;
			}
			this[aI] = objB;
			this[bI] = objA;
			return this;
		};
	
		public function reorderPlaces (object : Array, desiredPlaces : Array) : Array2
		{
			//determine if single or array
			trace ("ERROR REORDER NOT IMPLMENTED");
			throw new Error("Array2.reorderPlaces not implmented yet!");
			return this;
		};
		public function shiftFromTo (idxFrom : Number, idxTo : Number) : Array2
		{
			var tempVar : Object = this [idxFrom];
			this.splice (idxFrom, 1);
			this.splice (idxTo, 0, tempVar);
			return this;
		};
		public function shiftTowardsStart (idxFrom : Number, positions : Number) : Array2
		{
			if (positions == 0)
			{
				return this;
			} else
			{
				var idxTo = idxFrom - positions;
				if (positions == null || idxTo < 0)
				{
					idxTo = 0;
				}
				//range check
				var tempVar = this [idxFrom];
				this.splice (idxFrom, 1);
				this.splice (idxTo, 0, tempVar);
				return this;
			}
		};
		public function shiftTowardsEnd (idxFrom : Number, positions : Number) : Array2
		{
			if (positions == 0)
			{
				return this;
			} else
			{
				var idxTo = idxFrom + positions;
				if (positions == null || idxTo >= this.length)
				{
					idxTo = this.length - 1;
				}
				//range check
				var tempVar = this [idxFrom];
				this.splice (idxFrom, 1);
				//trace(this);
				this.splice (idxTo, 0, tempVar);
				return this;
			}
		};
		public function insertAt (idx : Number, values : Object) : Array2
		{
			var args = arguments.concat ();
			trace ("args " + args);
			//add a zero to args inbetween arg0, and arg1-N to make it an insert
			args.splice (1, 0, 0);
			trace ("args: " + args);
			this.splice.apply (this, args);
			return this;
		};
		public function removeAt (pos : Number, positions:Number) : Array2
		{
			if (positions == null)
			{
				positions = 1;
			}
			this.splice (pos, positions);
			return this;
		};
		public function removeAll ():void
		{
			this.splice (0, this.length );
		} 
		//look for a reference and splice from array 
		public function remove(aValue_obj:Object): Number
		{
			var tIndexOfMatch_num:Number = getLastIndexOf(aValue_obj);
			if(tIndexOfMatch_num != -1){
				splice (tIndexOfMatch_num, 1);
			}
			return tIndexOfMatch_num;
		}
		/*******************************************************
		 * in the given set, from a start point and end point (inclusive)
		 * get those that pass the black and white filters
		 * if no filtesr are passed in, the copy of the set is returned
		 */
		public function getFilteredSet(from:Number, to:Number, aThatsNot:Array,  aThatsIsOneOf:Array):Array2{
				var filteredSet:Array2 = new Array2();
			from = (from == null)? 0:from;
			to = (to == null)? length: to;
			for (var i : Number = from; i < to; i++) {
				var item:Object = this[i];
				var passes:Boolean = true;
				for (var j : Number = 0; j < aThatsNot.length; j++) {
					//black list
					var compareTo:Object = aThatsNot[j];
					if(compareTo == item){
						passes = false;
					}
				}
				for (var k : Number = 0; k < aThatsIsOneOf.length; k++) {
					//white list
					var compareTo:Object = aThatsIsOneOf[k];
					if(compareTo != item){
						passes = false;
					}
				}
				
				if(passes){
					filteredSet.push(item);
				}
			}
			return filteredSet;
		}
		public function getFilteredRandomElement(from:Number, to:Number, aThatsNot:Array,  aThatsIsOneOf:Array):Object{
			var options:Array2 = this.getFilteredSet(from, to, aThatsNot, aThatsIsOneOf);
			return options.getRandomElement();
		}
		/*
		 * return a random item from inside this set
		 */
		public function getRandomElement(from:Number, to:Number, aThatsNot:Array,  aThatsIsOneOf:Array):Object{
			var len:Number = (this.length - 1);
			var offset:Number = 0;
			if(from != null && to != null){
				len = to - from;
				offset =from;
			}else if(from != null){
				len = (this.length - 1) - from;
				offset =from;
			}else if(to != null){
					len = to;
			}
			var rndI:Number = null;
			var res:Object = null;
			rndI = offset + Math.round(Math.random()* len);
			res = this[rndI];
			trace("BBBBBBgetRandomElement returning " + res + " at " + rndI);
			return res;
		}
		/*
		 * returns the first item from inside this data set
		 */
		public function getFirstElement():Object{
			var res:Object = this[0];
			//trace("getFirstElement " + res);
			return res;
		}
		/*
		 * returns the last item from inside this data set
		 */
		public function getLastElement():Object{
			var res:Object = this[(this.length-1)];
			//trace("getLastElement " + res);
			return res;
		}
		public function isEmpty():Boolean{
			return this.length == 0;
		}
		//shuffle up to the given value (by default shuffle all)
		public function shuffle (len : Number) : Array2
		{
			if (len == null || len <= 0)
			{
				len = this.length;
			}
			var rand : Number;
			var temp : Number;
			var i : Number;
			for (i = 0; i < len; i ++)
			{
				rand = random (len);
				temp = this [i];
				this [i] = this [rand];
				this [rand] = temp;
				//return this[i];
			}
			return this;
		}
		public function isWithinIndexBounds(num:Number):Boolean{
			return (0<= num && num <= this.length - 1); 
		}
		public function snapToClosest (num : Number) : Number
		{
			var range = this;
			num = Math.round (num);
			var index : Number = Math.floor (range.length / 2);
			//pick half way pt.
			var increment : Number = index;
			var proceed : Boolean = true;
			while (proceed)
			{
				if (num == range [index])
				{
					return num;
				}
				increment -= Math.round (increment / 2);
				if (num > range [index])
				{
					index += increment;
				} else
				{
					index -= increment;
				}
				proceed = increment > 0;
			} //while
			// This is the new part. Basically you need to check
			// the boundary conditions, which is always the tricky part
			// of searching and sorting
			if (range [index] < num && range [index + 1] - num < num - range [index])
			{
				return range [index + 1];
			} 
			else if (range [index] > num && num - range [index - 1] < range [index] - num)
			{
				return range [index - 1];
			}
			return range [index];
		}
		/* create a shallow copy of this array) just a copy of the index of references to the original arrays content
		* thus values are shared
		
		var a_ary = new Array2(1,2,3);
		trace(a_ary);
		var b_ary = a_ary.concat();
		trace("b1 " + b_ary);
		b_ary.shuffle();
		
		trace("b2: " + b_ary);
		trace("a:" + a_ary);
		
		//OUTPUT
		1,2,3
		before
		args: 1,2,3
		args applied: 0,0,1,2,3
		before
		b1 1,2,3
		b2: 2,1,3
		a:1,2,3
		
		*/
		public function concat () : Array2
		{
			var sa : Array2 = new Array2 ();
			var args : Array = super.concat ();
			//splice the arguments into the shifting array at the correct spot, thus at positoin zero, delete zero
			args.splice (0, 0, 0, 0);
			sa.splice.apply (sa, args);
			return sa;
		}
		// Function to deep copy/ clone (create a cloned value copy of an array) an Object (crude - would not work with custom types)
		/*
		
		var s_ary = new Array2(1,2,3);
		trace(s_ary);
		var b_ary = s_ary.clone();
		trace(b_ary);
		b_ary.shuffle();
		trace(b_ary);*/
		public function clone () : Array2
		{
			// Create a new instance
			var o = this;
			var newObj = new o.__constructor__ ();
			if (newObj == undefined)
			{
				//	trace("no constructor");
				newObj = new Object ();
			}
			//	trace("newObj:" + typeof(newObj));
			for (var n in o)
			{
				var v = o [n];
				//	trace(n + ":" + v);
				if (typeof (v) == "string" || typeof (v) == "number" || typeof (v) == "boolean")
				{
					//		trace("found primitive");
					newObj [n] = v;
					//	trace("primitive: " + n + ":" + newObj[n]);
				} else
				{
					//	trace("found composite");
					newObj [n] = v.clone ();
					//	trace("composite: " + n + ":" + newObj[n]);
				}
			}
			//		trace(" -- newObj -- ")
			//		for (var t in newObj) {
			//			trace(p+t + ":" + newObj[t]);
			//		}
			return newObj;
		}
		//see if a reference is in the array, returns the first index that
		//matches the given object with that name
		public function getFirstIndexOf(aValue_obj:Object, from:Number, to:Number):Number
		{
		//	trace("getFirstIndexOf1 " +aValue_obj + " from " + from + " to " + to);
			
	
			var tFrom:Number = (from == null)?0:from;
			var tTo:Number = (to == null)?length:to;
	//	trace("getFirstIndexOf2 " +aValue_obj + " from bottom " + tFrom + " ++ to Top " + tTo);
			
			var tIndex_num:Number;
			for (tIndex_num = tFrom; tIndex_num < tTo; tIndex_num++) {
		//		trace(this[tIndex_num] + " counting up");
				if (this[tIndex_num] == aValue_obj) {
			//		trace(" found it at!! " + tIndex_num);
					return tIndex_num;
				}
			}
			//trace(" not foundt ");
			return -1;
		}
		/**********************
		 *see if a reference is in the array, returns the first index that
		 *	matches the given object with that name*/
		public function getLastIndexOf(aValue_obj:Object, from:Number, to:Number):Number
		{
			//trace("getLastIndexOf1 " +aValue_obj + " from " + from + " to " + to);
			var tFrom:Number = (to == null)?length:to;
			var tTo:Number = (from == null)?0:from;
			//trace("getLastIndexOF2 " +aValue_obj + " from Top " + tFrom + " -- to Bottom " + tTo);
			while(tFrom-- > tTo){
				//trace(this[tFrom] + " counting down---");
				if (this[tFrom] == aValue_obj) {
				//	trace(" found it at !!" + tFrom);
					return tFrom;
				}
			}
		//	trace(" not found!!");
			return -1;
		}
		/****************************************************
		 *  checks to see if this dataset contains th give value object
		 *  returns true if so.
		 */
		public function contains(aValue_obj:Object):Boolean{
			for (var i : String in this) {
				if (this[i] == aValue_obj) {
					return true;
				}
			}
			return false;
		}
		public function isBefore(aBeforeVaL:Object, aFromVal:Object, rng:Number):Boolean{
		//	trace("Array2 " + aBeforeVaL + " is before " + aFromVal +" by " + rng +"?");
			var fromIdx:Number = 0;
			var toIdx:Number = length;
			if(aBeforeVaL == aFromVal){
		//		trace("self reference");
				return false;
			}else{
				var tmpToIdx = getFirstIndexOf(aFromVal);
			
				toIdx = tmpToIdx + (rng == null?length:(rng+1));			
				fromIdx =tmpToIdx;
				
			//	trace( aBeforeVaL +"[?]" + "  after: " +aFromVal +"[" + tmpToIdx + "] searching " + fromIdx + " rng " + rng + " " + toIdx);
	
				var n:Number = getLastIndexOf(aBeforeVaL, fromIdx , toIdx);
		//		trace(aBeforeVaL + " before is at");
				return (n != -1);
			}
		}
		public function isAfter(aAfterVaL:Object, aFromVal:Object, rng:Number):Boolean{
		//trace("Array2 " + aAfterVaL + " is after " + aFromVal +" by " + rng +"?");
			var fromIdx:Number = 0;
			var toIdx:Number = length;
			if(aAfterVaL == aFromVal){
		//		trace(" self refence");
				return false;
			}else{
				fromIdx = getLastIndexOf(aFromVal);
				toIdx = (rng !=null)?(fromIdx + rng+1): length;
			//	trace(aFromVal + " from is at ind " + fromIdx);
				var n:Number = getFirstIndexOf(aAfterVaL, fromIdx, toIdx);
			//	trace(aAfterVaL + " after is at ");
				return (n != -1);
			}
		}
	}
	
}