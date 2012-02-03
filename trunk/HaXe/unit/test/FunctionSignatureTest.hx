package test;

import massive.munit.Assert;
using  massive.munit.Assert;

typedef Function1<I,O> = I -> O;

class FunctionSignatureTest{

	public var t0 : Function1<BaseClass,Dynamic>;
	//@Test
	public function testSig(){
		//var t1 : Function1<BaseClass,Dynamic> = function(x:SubClass){return null;};
	}
}
class BaseClass{
	public function new() 
	{
		
	}	
}
class SubClass extends BaseClass{
	public function new() {
		super();
	}
}
