package  { 
	class com.troyworks.statemachine.Joint extends Object{
	
		public var guards:Array = new Array();
		public var actions:Array = new Array();
	
		protected var myString : String;
	
		protected var myNum : Number;
	
	
	
	
		public function Joint(name:String){
			trace("new Joint " + name);
			this.myString = name;
			this.myNum = 1;
		}
	    public function evaluate():Boolean{
	//		var l = this.guards.length;
			var res:Boolean = true;
			for(var i in this.guards){
				var g = this.guards[i];
				var r = g.check();
				if(!r){
					//failed gaurd
					res = false;
					break;
				}
			}
			return res;
		}
		public function fire():void{
			for(var i in this.actions){
				var a = this.actions[i];
				a.fire();
			}
	
		}
	}
}