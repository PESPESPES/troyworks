/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler {

	public class PrevaylerFactory {
		public static function createPrevayler( o:Object, path:String):Prevayler{
		   var res:Prevayler = new Prevayler();
		   return res;
		}
	}
	
}
