package com.troyworks.framework.tags { 
	import com.troyworks.util.BitFlag;
	import mx.data.kinds.ForeignKeyAPI;
	import com.troyworks.util.MaskedBitFlag;
	/**
	 * This is a utility to index string based tags (e.g. color)
	 * and flatten them into a bitmask to speed comparisons.
	 * @author Troy Gardner
	 */
	public class TagIndex extends Object {
		public var tagsID : Object = new Object();
		public var tagsBF : Object = new Object();
		public var tagsCount : Object = new Object();
	
		public static var tagCount : Number = 0;
		public var length : Number = 0;
		public var allMask : Number = 0;
	
		//public var bitF : MaskedBitFlag;
		public function TagIndex() {
			super();
			init();
		}
		public function init() : void{
			tagsID  = new Object();
			tagsBF  = new Object();
			tagsCount  = new Object();
			tagCount  = 0;
			length  = 0;
			allMask  = 0;
	
			
		}
		public function addTerms(tags : Array) : Number{
			var res : Number = 0;
			var l : Number = tags.length;
			if(l > 0){
			while(l--){
					var tag : String = String(tags[l]);
					if(tagsID[tag] == null){
					//////////ADDING NEW TERM /////////////
						tagCount++;
						length++;
						var bf : Number = 1 << tagCount-1;
						trace("adding new tag '" +tag + "' at " + tagCount);
						tagsID[tag] = tagCount;
						tagsCount[tag] = 1;
						tagsBF[tag] = bf;
						res |= bf;
						allMask |= bf ;
					}else{
					////////TERM  ALREADY IN/////////////
						trace("'" + tag + "' tag already in ");
						tagsCount[tag]++;
					}
				}
			}
			trace("AddedTerms to " + BitFlag.toBinary(res, allMask));
			return res;
		}
		public function addTerm(tag : String) : Number{
			var res : Number = 0;
			if(tagsID[tag] == null){
				//////////ADDING NEW TERM /////////////
				tagCount++;
				length++;
				var bf : Number = 1 << tagCount-1;
				trace("adding new tag '" +tag + "' at " + tagCount);
				tagsID[tag] = tagCount;
				tagsCount[tag] = 1;
				tagsBF[tag] = bf;
				res = bf;
				allMask |= bf ;
			}else{
				////////TERM  ALREADY IN/////////////
				trace("'" + tag + "' tag already in ");
				tagsCount[tag]++;
			}
			return res;
		}
		public function containsTerm(tag : String) : Boolean{
			var res : Boolean = false;
			if(tagsID[tag] != null){
				res = true;
			}
			return res;
			
		}
		public function getTermsByBF(indexPos : Array) : Array{
			var res : Array = new Array();
			for (var j : Number = 0; j < indexPos.length; j++) {
				var idx : Number = indexPos[j];
				trace("looking for a id of  " + idx);
				for (var tag : String in tagsID) {
				  if(tagsBF[tag] == idx){
						trace("found an id match " + idx + " = " + tag);
						res.push(tag);
				  }	
				}
			}
			return res;
		}
		public function getTerms() : Array{
			trace("TagIndex.getTerms ");
			var res : Array = new Array();
			for(var i in tagsID){
				trace("get Term " + i);
				res.push(String(i));
			}
			return res;
		}
		/*************************************************
		 * This is called for each item to create a bitflag
		 * for compariable purposes, should be 
		 */
		public function createBitFlag(tags : Array) : MaskedBitFlag{
			var res : Number = BitFlag.ALLBITSOFF;
			var mask : Number = BitFlag.ALLBITSOFF;
			for (var i:String in tags){
				var tag : String = String(tags[i]);
				trace("looking at tag " +tag);
				var tBF : Number = Number(tagsBF[tag]);
				if(tBF != null){
					//set the bitflag at the id's place, bsed
					trace(" has bf  " + tBF);
					res  |= tBF;
					mask |= tBF;
				}else{
					//
					trace("error bit flag not recognized");
				}
			}
			var k : MaskedBitFlag = new MaskedBitFlag();
			k.b = res;
			k.m = mask;
			trace("new bitflag+maks--------\r"+BitFlag.toBinary(res, allMask));
			return k;
		}
	}
}