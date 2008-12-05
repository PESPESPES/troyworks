package com.troyworks.apps.tester {
	import flash.display.Sprite;	
	import flash.display.Stage;	
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import com.troyworks.apps.tester.TestSuite;
	import flash.utils.describeType;
	
	public class TestTask extends Object
	{
		public var cls:Class;
		public var suite:TestSuite;
		
		public var methodName:String;
		public var asynch:Boolean = false;
		
		public var stage : Stage;
		public var view : Sprite;
		
		public function TestTask(clas:Class, methodName:String){
			trace("HIGHLIGHT new TestTask(" + clas + "," + methodName+")");
			this.cls = clas;
			this.methodName = methodName;
			if(methodName.indexOf("atest_")== 0){
				asynch = true;
			}
		}
		public function runTest(listener:Function = null):Object{
			var inst:Object =  new cls();
			if(inst is TestSuite){
				trace("found a TestSuite");
				suite = inst as TestSuite;
				suite.stage = stage;
				suite.view = view;
				
			}
			if(asynch && listener != null){
				IEventDispatcher(inst).addEventListener(Event.COMPLETE,listener);
			}
			var passed:Object = inst[methodName]();
			return passed;
		}
		public function toString():String{
			return "TestTask " + methodName + " " + ((asynch)?"ASYNC":"SYC");
		}
	}
}