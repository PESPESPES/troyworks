/**
* ...
* @author Default
* @version 0.1
*/

package  reflection{

	import reflection.introspectable;

	public dynamic class IntrospectableObj extends Object{
		
		//private var ns:Namespace;// = me "com.troyworks";

		//// Instance ////////////
		introspectable var introVar:Function = new Function();
		internal var defVar:Function = new Function();
		private var priVar:Function = new Function();
		protected var proVar:Function = new Function();
		public var pubVar:Function = new Function();
		//// Statics /////////////
		static introspectable var introVarStat:Function= new Function();
		static internal var defVarStat:Function= new Function();
		static private var priVarStat:Function= new Function();
		static protected var proVarStat:Function= new Function();
		static public var pubVarStat:Function= new Function();
		
		//// Constants  /////////////
		introspectable const introConstStat:Function= new Function();
		internal const defConstStat:Function= new Function();
		static private const priConstStat:Function= new Function();
		static protected const proConstStat:Function= new Function();
		static public const pubConstStat:Function= new Function();

		protected var _item:Array; // array of object's properties

		public function IntrospectableObj(){
			//super();
			//trace("props " + _item.join("\r"));
			trace("new Introspectable");
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
		 public function getNS():Namespace{
			 return introspectable;
		 }
		/////////////////// INSTANCE /////////////////////////
		introspectable function s_introspectable():void{
			trace("Hello World from introspectable::s_introspectable");
		}

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

	}
	
}
