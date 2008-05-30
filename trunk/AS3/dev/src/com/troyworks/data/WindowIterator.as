package  com.troyworks.data { 
	public class WindowIterator {
		// Define property names and types
		public var loopAtEnd:Boolean;
		public var dataprovider:Object;
		public var hasNext:Boolean;
		public var curAIdx:Number = 0;
		public var curBIdx:Number = 1;
		public var idxHeight:Number = 1;
		// Following line is constructor
		// because it has the same name as the class
		public function WindowIterator() {
			trace("WindowIterator");
			this.curAIdx = 0;
			this.curBIdx = this.curAIdx + this.idxHeight;
		}
		function setDataProvider(dataP:Object):void {
			this.dataprovider = dataP;
		}
		// zero based!!!!!!!!!!!!!!
		function fitIntoRange(num:Number):Number {
			if(this.loopAtEnd){
				//////recycle into range/////////////////
				var elen = this.dataprovider.length-1;
				//trace("valid range " + 0  + " " + (this.length-1));
				if (Math.abs(num)>elen) {
					var rem = (num%this.dataprovider.length);
					return fitIntoRange(rem);
				} else {
					if (num<0) {
						// went under, go to the end and count back
						return (this.dataprovider.length+num);
					} else {
						// within bounds
						return num;
					}
				}
			}else{
				//////just fit into range/////////////////
				if(num < 0){
					return 0;
				}else if(num > this.dataprovider.length-1){
					return this.dataprovider.length-1;
				}else{
					return num;
				}
			}
		}
		function incrementWindow(steps:Number):void{
			steps = (steps == null)?1:steps;
			this.curAIdx = this.fitIntoRange(this.curAIdx+steps);
			this.curBIdx = this.fitIntoRange(this.curBIdx+steps);
		}
		function decrementWindow(steps:Number):void{
			steps = (steps == null)?1:steps;
			this.curAIdx = this.fitIntoRange(this.curAIdx-steps);
			this.curBIdx = this.fitIntoRange(this.curBIdx-steps);
		}
		function getNextA():Object {
			//trace("getNextA");
			this.hasNext = true;
	
			return this.dataprovider[this.curAIdx];
		}
		function getNextB():Object {
			//trace("getNextB");
			this.hasNext = true;
	
			return this.dataprovider[this.curBIdx];
		}
	}
	
}