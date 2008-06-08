package com.troyworks.core.chain {
	
	
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Hsm;	
	import flash.events.IEventDispatcher;	
	import com.troyworks.core.chain.IUnit;

	/***************************************
	 * Unit is a unit of discrete work
	 * which may be parallel or sequential
	 * providing progress along the way
	 ***************************************/
	public class UnitOfWork extends Hsm implements IUnit
	{
		
		public static const EVT_COMPLETED:String  = "EVT_WORK_COMPLETED";
		public static const EVT_PROGRESS:String  = "EVT_WORK_UPDATED_PROGRESS";
		public static const EVT_ERROR:String  = "EVT_WORK_ERROR";
		
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
		
		public function UnitOfWork(initState:String = "s__haventStarted", aMode:Boolean = SEQUENTIAL_MODE) {
			super(initState, "Chain");
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
		public function getTotalWorkToPerform() : Number{
	
			return totalWork;
		}
		// Top down query and summary of status //
		public function calcStats() : void{
			totalPerformed = 0;
			totalWork = 0;
			for( var i:String in children){
				 var c : IUnit = IUnit(children[i]);
				totalWork += c.getWorkPerformed();
				totalPerformed += c.getTotalWorkToPerform();		
			}
		}
		public function addChild(c : IUnit) : void {
			children.push(c);
			IEventDispatcher(c).addEventListener(EVT_COMPLETED, calcStats);
			IEventDispatcher(c).addEventListener(EVT_PROGRESS, calcStats);
			IEventDispatcher(c).addEventListener(EVT_ERROR, calcStats);
			calcStats();
		}
		
		public function startWork() : void {
		}
		
		public function execute() : void {
		}
		public function bottomUpNotification():void{
		}
		///////////////////// STATES /////////////////////////

		public function s_notDone(e : CogEvent) : Function
		{
			return s_root;
		}
		public function s__haventStarted(e : CogEvent) : Function
		{
			return s_notDone;
		}
		public function s__notDoneWithErrors(e : CogEvent) : Function
		{
			return s_notDone;
		}
		
		public function s__doing(e : CogEvent) : Function
		{
			return s_notDone;
		}
		public function s_done(e : CogEvent) : Function
		{
			return s_root;
		}
		
		
	}
}