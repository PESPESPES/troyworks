package  { 

	class PatternFactory {
		protected var handleEvent:Function;
		public var name = "unnamed";
		public function PatternFactory(name:String) {
			this.name = (name != null)? name: this.name;
			this.handleEvent = this.notInitedEventhandler;
		}
		public static function createToggle(core:Object, name1:Array, event:Array):void {
		}
		public static function createDiamond(core:Object, name1:String, name2:String):void {
		}
		//public INode
		public function init():void {
			this.handleEvent = initedEventhandler;
		}
		/////////////////////////////////
		protected function notInitedEventhandler(a:String, b:String, c:String):void {
			trace("notInitedEventhandler "+this.name+" a: "+a+" b: "+b+" c:"+c);
		}
		protected function initedEventhandler(a:String, b:String, c:String):void {
			trace("initedEventhandler "+this.name+" a: "+a+" b: "+b+" c:"+c);
		}
	}
	
}