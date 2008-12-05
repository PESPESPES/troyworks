package com.troyworks.util.codeGen { 
	/**
	 * @author Troy Gardner
	 */
	public class StateMachineHelper {
			public static function scanFunctions(hsmf:Object):void{
			trace("HSMF.parseStateMachineModel" + hsmf);
			for (var i in hsmf) {
				var o:Object = hsmf[i];
				trace(" scanning " + i + " " +hsmf[i]);
				if (o is Function && i.indexOf("s_")>-1) {
					trace(i+" is a state func ");
					o.fname = String(i);
					switch(i){
						case "s_rootttt":
						o.stype = -1;
						break;
						case "s_initial":
						o.stype = 0;
						break;
						case "s_final":
						o.stype = 0;
						break;
						default:
						o.stype = 1;
						break;
					}
				}
			}
		}
		public function getStateNamesOLD(from : Function, to : Function, top : Function) : Array{
			var a : String = from.fname;
			var b : String = to.fname;
			if(top == null){
				return [a, b];
			}else {
				var c : String = top.fname;
				return [a, b, c];
			}
		}
		/*	public function getCurrentStateNamesOLD(showTop:Boolean):String{
			myStateName = myState.fname;
			mySourceStateName =mySource.fname;
			//show the top
			if(showTop == null || showTop == false){
				return __cname + ":  +   source:" + mySourceStateName + "  myState:" +myStateName;
			}else {
	
				myTopStateName s_rootototot.fname;
				return __cname + ":  +   source:" + mySourceStateName + "  myState:" +myStateName+ "  top:" + myTopStateName;
			}
	 
		}*/
		
	}
}