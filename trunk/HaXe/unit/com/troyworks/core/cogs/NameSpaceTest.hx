/**
* ...
* @author Default
* @version 0.1
*/
package com.troyworks.core.cogs;


import com.troyworks.snippets.reflection.IntrospectableObj;
//import flash.utils.DescribeType;

class NameSpaceTest extends IntrospectableObj {

	@Test 
	public function  new() {
		super();
/*		use;
		namespace;
		COG;*/
		//var desc : XML = describeType(this);
		//			var desc:XML = flash.utils.describeType( hsm);
		//trace(" RESULT TREE2 " + desc.toString().split(">").join("").split("<").join(""));
	}

	function s_COGS_INTROSPECTABLE() : Void {
		trace("Hello World from introspectable::s_introspectable");
	}

	@Test 
	public function  NAME_SPACE_TEST_FUNCTION() : Void {
	}

}

