package com.troyworks.core.chain {
	import com.troyworks.core.events.PlayheadEvent;	
	import com.troyworks.core.cogs.IStateMachine;	

	import flash.events.Event;	

	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Hsm;	

	import flash.events.IEventDispatcher;	

	import com.troyworks.core.chain.IUnit;

	/***************************************
	 * Unit is a unit of discrete work
	 * which may be parallel or sequential
	 * providing progress along the way
	 * 
	 * This class is devoted to the comedian George Carlin, who passed away while
	 * about the moment this was being finished, and his devotion to lack of authority
	 * which this class attempts to impose on assets/workflow. 
	 *
	 * 
	 ***************************************/
	public class UnitOfWork extends Hsm implements IUnit {

		public static const EVT_COMPLETE : String = Event.COMPLETE;
		public static const EVT_PROGRESS : String = "EVT_UPDATED_PROGRESS";
		public static const EVT_ERROR : String = "EVT_ERROR";

		public static const SEQUENTIAL_MODE : Boolean = true;
		public static const PARALLEL_MODE : Boolean = false;
		public static const SEQUENTIAL_WORKER : String = "SequentialWorker";
		public static const PARALLEL_WORKER : String = "ParallelWorker";

		protected var totalWork : Number = 0;
		protected var totalPerformed : Number = 0;

		protected var activeWork : Number = 0;
		protected var activePerformed : Number = 0;

		public var children : Array = null;
		//piles to denote what of the children are done,
		protected var toDo : Array = null;
		//which are actively downloading at present
		protected var active : Array = null;
		//which are currently errored/done
		protected var finished : Array = null; 

		protected var mode : Boolean = SEQUENTIAL_MODE;
		public var checkInterval : Number = 1000 / 12;
		
		private var _parentUnit:IUnit;

		public function UnitOfWork(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE) {
			super(initState, "Chain");
			mode = aMode;
			_smName = (mode == SEQUENTIAL_MODE) ? SEQUENTIAL_WORKER : PARALLEL_WORKER;
			trace("smName  " + _smName);  
			children = new Array();
			finished = new Array();	
			toDo = null;
			active = new Array();
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA " + children.length);
		}

		public static function makeParallelWorker() : UnitOfWork {
			var res : UnitOfWork = new UnitOfWork("s__haventStarted", PARALLEL_MODE);
			
			return res;
		}

		public static function makeSequentialWorker() : UnitOfWork {
			var res : UnitOfWork = new UnitOfWork("s__haventStarted", SEQUENTIAL_MODE);
			
			return res;
		}

		public function getWorkPerformed() : Number {
			return totalPerformed;
		}

		
		
		public function getTotalWorkToPerform() : Number {
	
			return totalWork;
		}

		public function isComplete() : Boolean {
			return isInState(s_done);
		}

		// Top down query and summary of status //
		public function calcStats(evt : Event = null) : void {
			
			var i : int = 0;
			var n : int = children.length;
			
			if(n > 0) {
				totalPerformed = 0;
				totalWork = 0;
				activeWork = 0;
				activePerformed = 0;
				
				var c : IUnit;
				for (;i < n; ++i) {
					c = IUnit(children[i]);
					totalPerformed += c.getWorkPerformed();
					totalWork += c.getTotalWorkToPerform();		
				}
				i = 0;
				n = active.length;
				for (;i < n; ++i) {
					c = IUnit(active[i]);
					activePerformed += c.getWorkPerformed();
					activeWork += c.getTotalWorkToPerform();		
				}
			}else {
				totalPerformed = getWorkPerformed();
				totalWork = getTotalWorkToPerform();
				activePerformed = totalPerformed;
				activeWork = totalWork;
			}
			trace("HIGHLIGHTP cal stats " + totalPerformed + " / " + totalWork);
		}

		public function addChild(c : IUnit) : void {
			
			trace(smID +" HIGHLIGHTR addCHild ");
			children.push(c);
			if(toDo == null ){
				toDo = new Array();

			}
			toDo.push(c);
			c.setParentTask(this);
			IEventDispatcher(c).addEventListener(EVT_COMPLETE, calcStats);
			IEventDispatcher(c).addEventListener(EVT_PROGRESS, calcStats);
			IEventDispatcher(c).addEventListener(EVT_ERROR, calcStats);
			calcStats();
		}

		public function startWork() : void {
			trace("HIGHLIGHTO " + _smName + ".startWork +++++++++++++++++++++++++++++++++++++++" + toDo);
			///////////////////// COMPOSITE ////////////////////////////
			if((toDo != null  &&  ( totalWork == 0 || totalPerformed == totalWork) )) {
				///nothing to load!//////////////
				trace("WARNING startWork() called with nothing to load");
				_initState =s_done;
				initStateMachine();
				return;
			}
			if(toDo != null && toDo.length > 0) {
				var c : IUnit;
				if(mode == PARALLEL_MODE) {
					//PARALLEL
					while(toDo.length > 0) {
						c = IUnit(toDo.shift());
						c.addEventListener(EVT_COMPLETE, onChildCompleted);
						c.startWork();
						active.push(c);
					}
				}else {
					//SEQUENTIAL
					trace("[[[[[[[loading sequentially---------" + toDo.length);
					c = IUnit(toDo.shift());
					c.addEventListener(EVT_COMPLETE, onChildCompleted);
					c.startWork();
					active.push(c);
				//if(!pulseHasStarted()){
				//	Q_dispatch(SIG_ENTRY);
				//}
				}
				//_initState =s__doing;
				initStateMachine();
			trace("333333333333333333333333333333333333333333333333333333");
			trace("333333333333333333333333333333333333333333333333333333");
			trace("333333333333333333333333333333333333333333333333333333");
			trace("333333333333333333333333333333333333333333333333333333");
			trace("333333333333333333333333333333333333333333333333333333");
				requestTran(s__doing);
				return;				
			}
			//////////// LEAF/SOLO /////////////////////
				initStateMachine();
				requestTran(s__doing);
		}

		public function onChildCompleted(evt : Event = null) : void {
			//called when a child has broadcast the COMPLETE event
			var i : int = 0;
			var n : int = active.length;
			//cross the finished off our active list////////////////
			for (;i < n; ++i) {
				var c : IUnit = IUnit(active[i]);
				if(c == evt.target) {
					c.removeEventListener(EVT_COMPLETE, onChildCompleted);
					finished.push(c);	
					active.splice(i, 1);
				}	
			}
			
			trace(smID + ".HIGHLIGHTG onChildCompleted" + active.length);
			dispatchEvent(SIG_CALLBACK.createPrivateEvent());
		}
		public function onChildErrored(evt:Event = null):void{
			trace("a child errored out");
			dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
		}
		public function execute() : void {
		}

		public function bottomUpNotification() : void {
		}

		protected function notifyProgress() : void {
			var evt : PlayheadEvent = new PlayheadEvent(EVT_PROGRESS);
			
			evt.percentageDone = totalPerformed / totalWork;
			dispatchEvent(evt);
		//	if(evt.percentageDone == 1) {
	
		//	}
		}

		override public function initStateMachine() : void {
			calcStats();
			super.initStateMachine();
		}		

		///////////////////// STATES /////////////////////////
		// notdone > doing > done
		
		//11111111111111111111111111111111111111111111111111111111
		public function s_notDone(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
					
				case SIG_CALLBACK:
			
					if(toDo == null || toDo.length == 0) {
						//FINISHED LOADING LIST
						requestTran(s_done);
					}else if (toDo.length >= 0) {
						//FINISHED LOADING A CHILD
						startWork();
					}
				
					return null;	
				case SIG_INIT :
					return s__haventStarted;
			}
			return s_root;
		}

		public function s__haventStarted(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}
			return s_notDone;
		}

		public function s__notDoneWithErrors(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					return null;
				case SIG_EXIT :
					return null;
			}			
			return s_notDone;
		}

		
		//222222222222222222222222222222222222222222222222222222222
		public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				//case SIG_INIT:
				//	return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					startPulse();
					return null;
				case SIG_PULSE:
					
					calcStats();
					
					trace(smID + ".Pulsing " + totalPerformed + "/ " + totalWork);
					
					if(totalPerformed > 0 && totalWork > 0) {
						trace("target.totalFrames " + totalWork);
						//TODO dispatchEvent("STARTED_GETTING_DATA");
					//	if(totalWork > 0  && totalWork ==totalPerformed){
					//		requestTran(s_done);						
					//	}else{
							requestTran(s___partiallyDone);	
					//	}
					}else {
						trace("target.totalFrames " + totalWork);
					}
					notifyProgress();
					return null;
				case SIG_EXIT :
					stopPulse();
					return null;
			}
			return s_notDone;
		}

		public function s___partiallyDone(e : CogEvent) : Function {
			switch (e.sig) {
				
				case SIG_ENTRY :
					return null;
				case SIG_PULSE:
					trace("[[[[[[[----pulse-----");
					calcStats();
					trace("[[[[[[[UnitOfWork.loaded " + totalPerformed + " /  " + totalWork);
					
					
					if(activePerformed >= activeWork) {
						
						if(active == null || active.length == 0) {
						//	trace("[[[[[[[finished Loading child(ren)------ LOADING " + active.length + " LEFT " + toDo.length);
	
							dispatchEvent(SIG_CALLBACK.createPrivateEvent());
						}
					}
					return null;
					
	
				case SIG_EXIT :
					return null;
			}			
			return s__doing;
		}

		//33333333333333333333333333333333333333333333333333333333
		public function s_done(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					notifyProgress();
				
					//////////dispatch complete event ////////////
					trace("*dispatching ***Complete***");	
					var evt : PlayheadEvent = new PlayheadEvent(EVT_COMPLETE);
					evt.percentageDone = 1;
					dispatchEvent(evt);
					
					return null;
				case SIG_EXIT :
					return null;
			}
			return s_root;
		}
		
		public function setParentTask(parent : IUnit) : void {
			
			_parentUnit = parent;
		}
		
		public function getParentTask() :  IUnit {
			
			return _parentUnit;
		}
	}
}