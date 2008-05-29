package com.troyworks.datastructures { 
	 /*
	* A replacement for the built in Array values, 
	* that permit shuffling and shifting of child values, searching, swapping, getting a random element
	* It's very useful, at a modest size.
	*
	TODO add features from the DataProvider api
	addItem, removeItem, replaceItem, merge, invalidate, sort, toArray
	EVENT
	add, remove, replace, sort, etc with items/indexes affected
	* var s_ary = new ArrayX(1,2,3);
	* trace(s_ary); //1,2,3
	* s_ary.shuffle();
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	* trace(s_ary); //3,1,2
	* 
	* http://livedocs.adobe.com/flex/201/langref/Array.html
	*/
	public dynamic class ArrayX extends Array {//implements IArray {
	
		public function ArrayX(...args)
		{
			var n:uint = args.length
			if (n == 1 && (args[0] is Number))
			{
				var dlen:Number = args[0];
				var ulen:uint = dlen
				if (ulen != dlen)
					throw new RangeError("Array index is not a 32-bit unsigned integer ("+dlen+")")
				length = ulen;
			}
			else
			{
				length = n;
				for (var i:int=0; i < n; i++) {
					this[i] = args[i] 
				}
			}

		}
		/*AS3 override function pop():Object{
			var res:Object = this[this.length-1];
			var args:Array = [this.length-1,1];
			//returns undefined at tend for some reason? super.pop.apply(this, arguments);
			super.splice.apply(this, args);
			//trace(" ArrayX.pop " + res + " me " + this.join(","));
			return res;
		}*/
	/*	AS3 override function unshift(...args):uint{
			args.unshift(0);
			args.unshift(0);
			super.splice.apply(this,args);
			return length;
		}*/
		/*AS3 override function shift():Object{
			var res:Object = this[0];
			var args:Array = [0,1];
			//returns two of the end item at tend for some reason? super.shift.apply(this, arguments);
			super.splice.apply(this, args);
			return res;
		}*/
		//startIndex : Number = 0, endIndex : Number= length : ArrayX
		public function sliceX(...args) : ArrayX {
			var r : ArrayX = new ArrayX();
			var ary : Array = super.slice.apply(this, args);//(startIndex,endIndex);
			r.appendArray(ary);
			return r;
		}
	    public function slice(startIndex:int = 0, endIndex:int = 16777215):Array
		{
			var r : ArrayX = new ArrayX();
			var ary : Array = (super.slice.call(this, startIndex, endIndex));
			r.appendArray(ary);
			return r;
		}
	    AS3 override function splice(...args):*
		{
			var r : ArrayX = new ArrayX();
			var ary : Array = (super.splice.apply(this, args));
			r.appendArray(ary);
			return r;
		}
		public function spliceX(startIndex : Number = 0, deleteCount : Number= 1, value : Object = null) : ArrayX {
			var r : ArrayX = new ArrayX();
			var ary : Array = super.splice.apply(this, arguments);//(startIndex, deleteCount, value);
			r.appendArray(ary);
			return r;
		}
		/***************************************************
		 * Adds the values to the array to the specified position
		 * e.g. [A,B,C].appendArray([D,E]); is [A,B,C,D,E] (not [A,B,C,[D,E]] 
		 */
		public function appendArray(ary : Array, to : Number = -1) : void{
		//	trace("ArrayX.appendArray " + ary + " " + ary.length + " to position: " + to);
			if(ary == null ){
				trace("*** WARNING **** ArrayX.appendArray had null arg");
				return;
			}else if( ary.length == 0){
				trace("*** WARNING **** ArrayX.appendArray had empty arg");
				return;
			}
		//	trace("appendArray BEFORE: " + this + " appending:"  + ary.length+" \r" + ary.join("\r"));
			var args:Array = ary;//.concat();
		//	a.push(0);
			var pos : Number = (to == -1)?this.length:to; //where to insert, by default to end
	//		a.push(pos);
			args.unshift(0); //Number to delete
			args.unshift(pos);
	      //  var args:Array = a.concat(ary);
		//	trace("args \r" + args.join("\r"));
			super.splice.apply(this,args);
		//	trace("appendArray AFTER: len " +this.length+" \r" + this.join("\r"));
	
		}
		public function swapPlaces(objA : Object, objB : Object) : ArrayX
		{
			//find positions of existing objects
			//create mapping
			var aI:Number = getLastIndexOf(objA);
			var bI:Number = getLastIndexOf(objB);
			if(aI == -1 || bI == -1){
				trace("error in swap places, could not find one of the elements");
				return null;
			}
			this[aI] = objB;
			this[bI] = objA;
			return this;
		};
	
		public function reorderPlaces(object : Array, desiredPlaces : Array) : ArrayX
		{
			//determine if single or array
			trace ("ERROR REORDER NOT IMPLMENTED");
			throw new Error("ArrayX.reorderPlaces not implmented yet!");
			return this;
		};
		public function shiftFromTo(idxFrom : Number, idxTo : Number) : ArrayX
		{
			var tempVar : Object = this [idxFrom];
			super.splice (idxFrom, 1);
			super.splice (idxTo, 0, tempVar);
			return this;
		};
		public function shiftTowardsStart(idxFrom : *=null, positions : * = null) : ArrayX
		{
			if (positions == 0)
			{
				return this;
			} else
			{
				var idxFromN:Number = (idxFrom==null)?length-1:idxFrom;
	
				var idxTo:Number = idxFromN - positions;
				if (positions == null || idxTo < 0)
				{
					idxTo = 0;
				}
				//range check
				var tempVar:Object = this [idxFromN];
				super.splice (idxFromN, 1);
				super.splice (idxTo, 0, tempVar);
				return this;
			}
		};
		public function shiftTowardsEnd(idxFrom : * = null, positions :  * = null) : ArrayX
		{
			if (positions == 0)
			{
				return this;
			} else
			{
				idxFrom = (idxFrom==null)?0:idxFrom;
				var idxTo:Number = idxFrom + positions;
				if (positions == null || idxTo >= this.length)
				{
					idxTo = this.length - 1;
				}
				//range check
				var tempVar:Object = this [idxFrom];
				super.splice (idxFrom, 1);
				//trace(this);
				super.splice (idxTo, 0, tempVar);
				return this;
			}
		};
		public function insertAt(idx : Number, values : Object) : ArrayX
		{
			var args:Array = arguments.concat ();
		//	trace ("args " + args);
			//add a zero to args inbetween arg0, and arg1-N to make it an insert
			args.splice (1, 0, 0);
		//	trace ("args: " + args);
			super.splice.apply (this, args);
			return this;
		};
		public function removeAt(pos : Number, positions:Number = 1) : ArrayX
		{
			super.splice (pos, positions);
			return this;
		};
		public function removeAll() : void
		{
			super.splice (0, this.length );
		} 
		//look for a reference and splice from array
		public function remove(aValue_obj : Object) : Number
		{
			var tIndexOfMatch_num : Number = getLastIndexOf(aValue_obj);
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
		public function getFilteredSet(fromIdx : * = 0, toIdx : *= null, aThatsNot : Array = null, aThatsIsOneOf : Array = null) : ArrayX{
		//	trace("getFilteredSet  from " + fromIdx + " toIdx " + toIdx+ " aThatsNot " + aThatsNot);
			var filteredSet : ArrayX = new ArrayX();
			fromIdx = (fromIdx == null || fromIdx <0)? 0:fromIdx;
			toIdx = (toIdx == null || length < toIdx)? length: toIdx;
	//	trace("getFilteredSet2  from " + fromIdx + " toIdx " + toIdx+ " aThatsNot " + aThatsNot);

			for (var i : Number = fromIdx; i < toIdx; i++) {
				var item : Object = this[i];
				var passes : Boolean = true;
		   		 	if(aThatsIsOneOf != null || aThatsNot != null){
				//	trace("filtering");
					if(aThatsNot != null){
						for (var j : Number = 0; j < aThatsNot.length; j++) {
							//black list
							var compareTo : Object = aThatsNot[j];
							if(compareTo == item){
								passes = false;
							}
						}
					}
					if(aThatsIsOneOf != null){
						for (var k : Number = 0; k < aThatsIsOneOf.length; k++) {
							//white list
							var compareTo2 : Object = aThatsIsOneOf[k];
							if(compareTo2 != item){
								passes = false;
							}
						}
					}
				}		
				if(passes){
					filteredSet.push(item);
				}
		
			}
		//	trace("filtered set " + filteredSet);
			return filteredSet;
		}
		public function getFilteredRandomElement(from : Number, to : Number, aThatsNot : Array, aThatsIsOneOf : Array) : Object{
		//	trace("Arr2.getFilteredRandomElement from " + from + " to " + to+ " aThatsNot " + aThatsNot);
			var options : ArrayX = this.getFilteredSet(from, to, aThatsNot, aThatsIsOneOf);
			var res:Object = null;
			if(options.length >0){
				res =options.getRandomElement(null, null, aThatsNot, aThatsIsOneOf);
			}
			return res;
		}
		/*
		 * return a random item from inside this set
		 */
		public function getRandomElement(from :  * = null, to :  * = null, aThatsNot : Array = null, aThatsIsOneOf : Array= null) : Object{
		//	trace("getRandomElement from " + from + " to " + to+ " aThatsNot " + aThatsNot);
			
			if(length == 0){
				return null;
			}
			var len : Number = (this.length - 1);
			var offset : Number = 0;
			if(from != null && to != null){
				len = to - from;
				offset =from;
			}else if(from != null){
				len = (this.length - 1) - from;
				offset =from;
			}else if(to != null){
				len = to;
			}
		//	trace("getRandomElement2 " +from + " from " + from + " to " + to+ " aThatsNot " + aThatsNot);
			var rndI : Number;
			var res : Object = null;
			rndI = offset + Math.round(Math.random()* len);
			///////////range check//////////////
			rndI = Math.min(Math.max(0, rndI), length);
			res = this[rndI];
		//	trace("BBBBBBgetRandomElement returning " + res + " at " + rndI);
			return res;
		}
		/*
		 * returns the first item from inside this data set
		 */
		public function getFirstElement() : Object{
			var res : Object = this[0];
	//		trace("getFirstElement " + res);
			return res;
		}
		/*
		 * returns the last item from inside this data set
		 */
		public function getLastElement() : Object{
			var res : Object = this[(length-1)];
		//	trace("getLastElement " + res + " " + length);
			return res;
		}
		public function isEmpty() : Boolean{
			return this.length == 0;
		}
		//shuffle up to the given value (by default shuffle all)
		public function shuffle(len :  * = null) : ArrayX
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
				rand = Math.round(Math.random()*len);
				temp = this [i];
				this [i] = this [rand];
				this [rand] = temp;
				//return this[i];
			}
			return this;
		}
		public function isWithinIndexBounds(num : Number) : Boolean{
			return (0<= num && num <= this.length - 1); 
		}
		public function snapToClosest(num : Number) : Number
		{
			var range:Array = this;
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
		
		var a_ary = new ArrayX(1,2,3);
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
		AS3 override function concat(...args) : Array
		{
			var r : Array = super.concat.apply(this,args);
			//trace("super.concat is " + r);
			var res : ArrayX = new ArrayX ();
			res.appendArray(r);

			//trace("resulting concact " + res.join(","));
			return res;
		}
		// Function to deep copy/ clone (create a cloned value copy of an array) an Object (crude - would not work with custom types)
		/*
		
		var s_ary = new ArrayX(1,2,3);
		trace(s_ary);
		var b_ary = s_ary.clone();
		trace(b_ary);
		b_ary.shuffle();
		trace(b_ary);*/
		public function clone() : ArrayX
		{
			// Create a new instance
			var o:Array = this;
			var newObj:ArrayX = new ArrayX();
			/*if (newObj == undefined)
			{
				//	trace("no constructor");
				newObj = new Object ();
			}*/
			//	trace("newObj:" + typeof(newObj));
			for (var n:Object in o)
			{
				var v:Object = o [n];
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
		public function getFirstIndexOf(aValue_obj : Object, from :  * = null, to :  * = null) : Number
		{
		//	trace("getFirstIndexOf1 " +aValue_obj + " from " + from + " to " + to);
			var tFrom : Number = (from == null)?0:from;
			var tTo : Number = (to == null)?length:to;
	//	trace("getFirstIndexOf2 " +aValue_obj + " from bottom " + tFrom + " ++ to Top " + tTo);
			var tIndex_num : Number;
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
		public function getLastIndexOf(aValue_obj : Object = null, fromIdx : * = null, toIdx : *=null) : Number
		{
			//trace("getLastIndexOf1 " +aValue_obj + " from " + from + " to " + to);
			var tFrom : Number = (toIdx == null)?length:toIdx;
			var tTo : Number = (fromIdx == null)?0:fromIdx;
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
		public function contains(aValue_obj : Object) : Boolean{
			trace("ArrayX.contains( " + aValue_obj +" )"+ length);
			var res : Boolean = false;
			trace(" this " + this);
			for (var i : Number = 0; i < this.length; i++) {
				trace(" Ak " + i + " v= " + this[i] + ":" + this[i].length + " =? " + aValue_obj);
				if (this[i] == aValue_obj) {
					trace("  contains it " + aValue_obj);
					res = true;
					break;
				}
	
			}
			return res;
		}
		public function isBefore(aBeforeVaL : Object, aFromVal : Object, rng :  * = null) : Boolean{
		//	trace("ArrayX " + aBeforeVaL + " is before " + aFromVal +" by " + rng +"?");
			var fromIdx : Number = 0;
			var toIdx : Number = length;
			if(aBeforeVaL == aFromVal){
		//		trace("self reference");
				return false;
			}else{
				var tmpToIdx:Number = getFirstIndexOf(aFromVal);
	
				toIdx = tmpToIdx + (rng == null?length:(rng+1));
				fromIdx =tmpToIdx;
				
			//	trace( aBeforeVaL +"[?]" + "  after: " +aFromVal +"[" + tmpToIdx + "] searching " + fromIdx + " rng " + rng + " " + toIdx);
				var n : Number = getLastIndexOf(aBeforeVaL, fromIdx , toIdx);
		//		trace(aBeforeVaL + " before is at");
				return (n != -1);
			}
		}
		public function isAfter(aAfterVaL : Object, aFromVal : Object, rng : Number) : Boolean{
		//trace("ArrayX " + aAfterVaL + " is after " + aFromVal +" by " + rng +"?");
			var fromIdx : Number = 0;
			var toIdx : Number = length;
			if(aAfterVaL == aFromVal){
		//		trace(" self refence");
				return false;
			}else{
				fromIdx = getLastIndexOf(aFromVal);
				toIdx = fromIdx + rng+1;//(rng !=null)?(fromIdx + rng+1): length;
			//	trace(aFromVal + " from is at ind " + fromIdx);
				var n : Number = getFirstIndexOf(aAfterVaL, fromIdx, toIdx);
			//	trace(aAfterVaL + " after is at ");
				return (n != -1);
			}
		}
	/*	public function toXML(tree:XML):XMLDocument {
			trace("ArrayX.toXML");
			
			if (tree == null) {
				tree = new XMLDocument();
			}
			var n : XMLNode = tree.createElement("ArrayX");
			n.attributes.objRef = this;
			
			var n:XMLNode = tree.createElement("root");
			n.attributes.label = "ProductBuilder ";
			n.attributes.objRef = this; 
			n.attributes.treeID = -2;
			tree.appendChild(n);
			//trace("going over children: " +  this.allTimers.length);
	/*		for(var i:Number = 0; i < this.allTimers.length; i++){ 
			    var tm = this.allTimers[i];
				var n1 = tm.toXML(tree);
				n.appendChild(n1);
			}*
				trace("ProductBuilder.toXML2" + tree);
				return tree;
		}*/
	}
	
}