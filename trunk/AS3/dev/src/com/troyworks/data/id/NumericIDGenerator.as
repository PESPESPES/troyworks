package com.troyworks.data.id { 

	public class NumericIDGenerator extends Object
	{
		// a singleton class that generates a stream of unique number id's and can recycle them.
		public var nextID:int;
		public var lastUsedID:int;
		public var recycledIDs:Array;
	
	    public function NumericIDGenerator(){
			this.init();
		}
		public function init():void{
			this.recycledIDs = new Array();
			this.nextID = 0;
			this.lastUsedID = 0;
		}
		public function getNextID():int{
			if(this.recycledIDs.length > 0){
				return int(this.recycledIDs.shift());
			}else{
				this.lastUsedID = this.nextID;
				this.nextID++;
				return this.lastUsedID;
			}
		}
		public function recycleID(id:int):void{
			this.recycledIDs.push(id);
		}
	}
}