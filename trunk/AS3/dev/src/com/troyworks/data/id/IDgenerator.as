package  com.troyworks.data.id { 

	class IDgenerator
	{
		// a singleton class that generates a stream of unique number id's and can recycle them.
		public var nextID:Number;
		public var lastUsedID:Number;
		public var recycledIDs:Array;
	
	    public function IDgenerator(){
			this.init();
		}
		public function init():void{
			this.recycledIDs = new Array();
			this.nextID = 0;
			this.lastUsedID = 0;
		}
		public function getNextID():Object{
			if(this.recycledIDs.length > 0){
				return  this.recycledIDs.shift();
			}else{
				this.lastUsedID = this.nextID;
				this.nextID++;
				return this.lastUsedID;
			}
		}
		public function recycleID(id:Number):void{
			this.recycledIDs.push(id);
		}
	}
}