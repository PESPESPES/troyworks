package com.troyworks.core.chain
{
	import com.troyworks.core.cogs.Fsm;
	import com.troyworks.core.chain.IUnit;

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
		
		public function UnitOfWork(aMode:Boolean = SEQUENTIAL_MODE) {
			super();
			mode = aMode;
			_smName = (mode == SEQUENTIAL_MODE)?SEQUENTIAL_WORKER:PARALLEL_WORKER;
			trace("smName  " + _smName);  
			children  = new Array();
			finished = new Array();	
			toDo = new Array();
			active = new Array();
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA " + children.length);
	
		}
		public function getWorkPerformed() : Number{
			return totalPerformed;
		}
		function getTotalWorkToPerform() : Number{
	
			return totalWork;
		}
		function calcStats() : void{
			totalPerformed = 0;
			totalWork = 0;
			for( var i:String in children){
				 var c : ILoader = ILoader(children[i]);
				totalWork += c.getAmountLoaded();
				totalPerformed += c.getTotalSize();		
			}
		}
		function addChild(c : ILoader) : void {
			children.push(c);
			IEventDispatcher(c).addEventListener(EVT_FINISHED_LOADING, createCallback(PULSE_EVT));
			calcStats();
		}
		
		public function startWork() : void {
		}
		
		public function execute() : void {
		}
	}
}