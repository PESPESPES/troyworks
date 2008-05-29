/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.cogs {
	import com.troyworks.cogs.Hsm;
	import com.troyworks.cogs.*;
	import  flash.utils.describeType;
	
	public class NameSpaceTest extends IntrospectableObj{
		public function NameSpaceTest(){
			super();
			use namespace COG;
				var desc:XML = describeType( this);
			//			var desc:XML = flash.utils.describeType( hsm);
			trace(" RESULT TREE2 \r" +desc.toString().split(">").join("").split("<").join(""));
		}
		COG function s_COGS_INTROSPECTABLE():void{
			trace("Hello World from introspectable::s_introspectable");
		}
		public function NAME_SPACE_TEST_FUNCTION():void{
			
		}
	}
	
}
