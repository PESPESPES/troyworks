package com.troyworks.core.chain {
	import com.troyworks.tester.Test_AsynchronousTestSuite;

	/**
	 * Test_PlaceHolderUnitOfWork
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 5, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_PlaceHolderUnitOfWork extends Test_AsynchronousTestSuite {
		public function Test_PlaceHolderUnitOfWork() {
			super();
		}

		public function setupChain(id : int = 0) : UnitOfWork {
			var chainA : UnitOfWork = new PlaceHolderUnitOfWork();
			switch(id) {
				case 0:
					break;
				case 2:
					var chainA1 : UnitOfWork = new PlaceHolderUnitOfWork();
					var chainA2 : UnitOfWork = new PlaceHolderUnitOfWork();
					chainA.addChild(chainA1);
					chainA.addChild(chainA2);
					break;
			}	
			return chainA;
		}
		public function test_1():void{
			var chainA : UnitOfWork = setupChain();
			chainA.startWork();
			trace("CREAting chainA" + chainA);
		}
	}
}
