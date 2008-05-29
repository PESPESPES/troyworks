/**
* ...
* @author Default
* @version 0.1
*/

package  com.troyworks.prevayler{

	import com.troyworks.activeframe.events.CRUDEvents;
	import com.troyworks.reflection.introspectable;
	import com.troyworks.cogs.COG;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	public dynamic class IntrospectableObj extends EventDispatcher{
		
		//private var ns:Namespace;// = me "com.troyworks";

		//// Instance ////////////
		COG var introVar:Function = new Function();
		internal var defVar:Function = new Function();
		private var priVar:Function = new Function();
		protected var proVar:Function = new Function();
		public var pubVar:Function = new Function();
		
		public var pubStrVar:String = "public testString";
		public var pubNumVar:Number = .5;
		public var pubIntVar:int = -1;
		public var pubUIntVar:uint = 1;
		public var pubBooFalseVar:Boolean = false;
		public var pubBooTrueVar:Boolean= true;
		public var pubDateVar:Date = new Date();
		
		
		private var priStrVar:String = "priTestString";
		private var priNumVar:Number = .2;
		private var priIntVar:int = 2;
		private var priUIntVar:uint = 2;
		private var priBooFalseVar:Boolean = false;
		private var priBooTrueVar:Boolean= true;
		private var pritDateVar:Date = new Date();
		
		//// Statics /////////////
		static introspectable var introVarStat:Function= new Function();
		static internal var defVarStat:Function= new Function();
		static private var priVarStat:Function= new Function();
		static protected var proVarStat:Function= new Function();
		static public var pubVarStat:Function= new Function();
		
		//// Constants  /////////////
		//COG const introConstStat:Function= new Function();
		internal const defConstStat:Function= new Function();
		static private const priConstStat:Function= new Function();
		static protected const proConstStat:Function= new Function();
		static public const pubConstStat:Function= new Function();

		protected var _item:Array; // array of object's properties
		
		private var intro2:IntrospectableObj;
		private var self:IntrospectableObj;

		public function IntrospectableObj(create:Boolean = true){
			super();
			//trace("props " + _item.join("\r"));
			trace("new Introspectable ");
			if(create){
			intro2 = new IntrospectableObj(false);
			addEventListener(Event.CHANGE, intro2.onChangedHandler);
			}
			self = this;
			
			
		//	trace("s_internal "  + s_internal);
		//	trace("s_private "  + s_private);
		//	trace("s_protected "  + s_protected);
		//				trace("s_public "  + s_public);
	//	IntrospectableNS.uri = "com.troyworks";
		
				for (var x:* in this) {
					 trace("pushing " + x);
					//_item.push(x);
				 }
			/*	 for (var y:* in this.ns::) {
					 trace("pushing " + y);
					//_item.push(x);
				 }*/
		}
	/*override flash_proxy function nextNameIndex (index:int):int {
         // initial call
		 trace(" Introspectable.nextNameIndex " + index);
			 if (index == 0) {
				  trace("new  " + x);
				 _item = new Array();
				 for (var x:* in this) {
					 trace("pushing " + x);
					_item.push(x);
				 }
			 }
		 
			 if (index < _item.length) {
				 return index + 1;
			 } else {
				 return 0;
			 }
		}
		 override flash_proxy function nextName(index:int):String {
			 return _item[index - 1];
		 }*/
		 public function notifyOfChange():void{
			 dispatchEvent(new Event(Event.CHANGE));
		 }
		 public function onChangedHandler(event:Event):void{
			 trace("**Changed**");
		 }
		 public function get priStr():String{
			 return priStrVar;
		 }
		 public function getNS():Namespace{
			 return COG;
		 }
		/////////////////// INSTANCE /////////////////////////
		/*COG function s_introspectable():void{
			trace("Hello World from introspectable::s_introspectable");
		}*/

		internal function s_internal():void{
			
		}
		private function s_private():void{
			
		}
		protected function s_protected():void{
			
		}
		public function s_public():void{
			
		}
		///////////////////// STATICS ///////////////////////
		static internal function stat_internal():void{
			
		}
		static private function stat_private():void{
			
		}
		static protected function stat_protected():void{
			
		}
		static public function stat_public():void{
			
		}
		///////////////////// CONST ///////////////////////
	/*	const function const_internal():void{
			
		}
		const private function const_private():void{
			
		}
		const protected function const_protected():void{
			
		}
		const public function const_protected():void{
			
		}*/
		override public function toString():String{
			var res:Array = new Array();
			res.push("pubStrVar "+ pubStrVar);
			res.push("pubNumVar "+ pubNumVar);
			res.push("pubIntVar "+ pubIntVar);
			res.push("pubUIntVar "+ pubUIntVar);
			res.push("pubBooFalseVar "+ pubBooFalseVar);
			res.push("pubBooTrueVar "+ pubBooTrueVar);
			res.push("pubDateVar "+ pubDateVar);

			res.push("priStrVar "+ priStrVar);
			res.push("priNumVar "+ priNumVar);
			res.push("priIntVar "+ priIntVar);
			res.push("priUIntVar "+ priUIntVar);
			res.push("priBooFalseVar "+ priBooFalseVar);
			res.push("priBooTrueVar "+ priBooTrueVar);
			res.push("pritDateVar "+ pritDateVar);
			res.push(
			return res.join("\r");
			
		}

	}
	
}
