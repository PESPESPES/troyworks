package com.troyworks.framework.tags { 
	/**
	 *  A categorized box for a set of 1-Many TagIndexes
	 * @author Troy Gardner
	 */
	public class TagContext extends Object {
		//e.g. useMatchesColors
		public var name:String = "unnamed";
		public var tic:Array;
		public var ti:TagIndex;
		public var whiteListAll:Boolean = false;
		
		public function TagContext(name:String, contextParams:Object) {
			super();
					init();
			trace("new TagContext " + name + " '" + contextParams+"'");
			this.name = (name == null)?"UnNamedTagContext" :name;
			if(contextParams != null){
				parseParams(contextParams);
			}
		}
		public function init():void{
			 tic= new Array();
		}
		public function parseParams(o:Object, filterIndex:TagIndex):void{
			if(o is Array){
				trace("Array Context Params  filterOn?:"+ filterIndex);
				var ary:Array = Array(o);
				for (var i : Number = 0; i < ary.length; i++) {
					var arg:Object = ary[i];
					trace("HIGHLIGHT found '" + arg+"'");
					if(arg is String || typeof(arg) == "string"){
						trace("found string");
						switch(arg){
							case "*":
							trace("found wildcard");
							whiteListAll = true;
							return;
							break;
							default:
							if(ti == null){
								trace("creating new TAG index for Context");
						    	ti = new TagIndex();
							}
							if(filterIndex != null){
								if(filterIndex.containsTerm(String(arg))){
									trace("FILTER has a valid term");
								ti.addTerm(String(arg));
								}else {
									trace("FILTER has a INvalid term");
								}
							}else{
								ti.addTerm(String(arg));
							}
							break;
						}
					}else if(arg is Number || typeof(arg) == "number"){	
							if(ti == null){
								trace("creating new TAG index for Context");
						    	ti = new TagIndex();
							}
							if(filterIndex != null){
								if(filterIndex.containsTerm(String(arg))){
									trace("FILTER has a valid term");
								ti.addTerm(String(arg));
								}else {
									trace("FILTER has a INvalid term");
								}
							}else{
								ti.addTerm(String(arg));
							}
					}else{
						trace("TagContext found unknown, and not adding " + arg + " '" + typeof(arg)+"'");
					}
				}
				
			}else{
				trace("UNRECOGNIZED Context Params");
			}
			
		}
	}
}