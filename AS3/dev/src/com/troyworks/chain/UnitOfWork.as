package com.troyworks.workflow
{
	import com.troyworks.cogs.Fsm;
	import com.troyworks.workflow.IUnit;

	/***************************************
	 * Unit is a unit of discrete work
	 * which may be parallel or sequential
	 * providing progress along the way
	 ***************************************/
	public class UnitOfWork extends Fsm implements IUnit
	{
		
		public static const SEQUENTIAL_MODE:Boolean = true;
		public static const PARALLEL_MODE:Boolean = false;
		public static const SEQUENTIAL_WORKER:String = "SequentialWorker";
		public static const PARALLEL_WORKER:String = "ParallelWorker";
		
		protected var totalWork : Number;
		protected var totalPerformed : Number;
	
		public var children : Array = null;
		protected var finished : Array = null;
		protected var toDo : Array = null;
		protected var active : Array = null; 
	
		protected var mode:Boolean = SEQUENTIAL_MODE;
		public var checkInterval:Number = 1000/12;
		
		public function UnitOfWork(aMode:Boolean) {
			super();
			mode = (aMode == null)?mode:aMode;
			smName = (mode == SEQUENTIAL_MODE)?SEQUENTIAL_WORKER:PARALLEL_WORKER;
			trace("smName  " + hsmName);  
			children  = new Array();
			finished = new Array();	
			toDo = new Array();
			active = new Array();
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA " + children.length);
	
		}
		public function getWorkPerformed() : Number{
			return totalLoaded;
		}
		function getTotalWorkToPerform() : Number{
	
			return totalSize;
		}
		function calcStats() : void{
			totalLoaded = 0;
			totalSize = 0;
			for(public var i:String in children){
				public var c : ILoader = ILoader(children[i]);
				totalSize += c.getAmountLoaded();
				totalLoaded += c.getTotalSize();		
			}
		}
		function addChild(c : ILoader) : void {
			children.push(c);
			TEventDispatcher(c).addEventListener(EVT_FINISHED_LOADING, createCallback(PULSE_EVT));
			calcStats();
		}
	}
}