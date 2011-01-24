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

		private var _parentUnit : IUnit;
		public var parallelAllChildrenStarted : Boolean = false;
		public  var isLeafTask : Boolean = false; 

		public function UnitOfWork(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE, smName:String = "Chain") {
			super(initState, smName, false);
			mode = aMode;
			_smName = smName + "_" + (mode == SEQUENTIAL_MODE) ? SEQUENTIAL_WORKER : PARALLEL_WORKER;
			trace("smName  " + _smName + "#" + _smID);  
			children = new Array();
			finished = new Array();	
			toDo = null;
			active = new Array();
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA " + children.length);
		}

		public static function makeParallelWorker(smName : String = null) : UnitOfWork {
			var res : UnitOfWork = new UnitOfWork("s__haventStarted", PARALLEL_MODE, null);
			res.setStateMachineName(smName);
			return res;
		}

		public static function makeSequentialWorker(smName : String = null) : UnitOfWork {
			var res : UnitOfWork = new UnitOfWork("s__haventStarted", SEQUENTIAL_MODE, null);
			res.setStateMachineName(smName);
			return res;
		}

		public function getUnitName() : String {
			return _smName;
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

		public function hasStarted() : Boolean {
			return  isInState(s___partiallyDone) || isInState(s_done);
		}

		protected function fireCompletedEvent() : void {
			trace(_smName + "#" + _smID + ".dispatching ***Complete***");	
			var evt : PlayheadEvent = new PlayheadEvent(EVT_COMPLETE);
			evt.percentageDone = 1;
			dispatchEvent(evt);
		}

		// Top down query and summary of status //
		public function calcStats(evt : Event = null) : void {
			
			var i : int = 0;
			var n : int = children.length;
			var tp : Number;
			var tw : Number;
			
			var paraActive : int = 0;
			if(n > 0) {
				totalPerformed = 0;
				totalWork = 0;
				activeWork = 0;
				activePerformed = 0;
				
				var c : IUnit;
				for (;i < n; ++i) {
					c = IUnit(children[i]);
					
					tp = c.getWorkPerformed();
					tw = c.getTotalWorkToPerform();
					if(c.isComplete()) {
						trace(" D " + c.getUnitName() + " " + tp + " / " + tw);
					}else {
						trace("   " + c.getUnitName() + " " + tp + " / " + tw);
					}
					totalPerformed += tp;
					totalWork += tw;	
				}
				////////// ACTIVE LIST //////////////
				i = 0;
				n = active.length;
				
				for (;i < n; ++i) {
					c = IUnit(active[i]);
					
					tp = c.getWorkPerformed();
					tw = c.getTotalWorkToPerform();
					
					if(c.hasStarted()) {
						trace(" A " + c.getUnitName() + " " + tp + " / " + tw);
						
						paraActive++;
					}else {
						trace(" * " + c.getUnitName() + " " + tp + " / " + tw);
					}
					
					activePerformed += tp;
					activeWork += tw;		
				}
			}else {
				totalPerformed = getWorkPerformed();
				totalWork = getTotalWorkToPerform();
				activePerformed = totalPerformed;
				activeWork = totalWork;
			}
			if(paraActive == active.length) {
				parallelAllChildrenStarted = true;	
			}
			trace(_smName + "#" + _smID + ".calcStats " + totalPerformed + " / " + totalWork);
			notifyProgress();
		}

		public function bottomUpNotification() : void {
		}

		protected function notifyProgress() : void {
			
			trace(_smName + "#" + _smID + ".UnitOfWork.notifyProgress " + totalPerformed +" / " +totalWork);
			var evt : PlayheadEvent = new PlayheadEvent(EVT_PROGRESS);
			
			evt.percentageDone = totalPerformed / totalWork;
			dispatchEvent(evt);
		//	if(evt.percentageDone == 1) {
	
		//	}
		}

		public function addChild(c : IUnit) : void {
			
			trace(_smName + smID + " HIGHLIGHTR addCHild ");
			children.push(c);
			if(toDo == null ) {
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
			trace("" + _smName + "#" + _smID + ".startWork +++++++++++++++++++++++++++++++++++++++" + toDo);
			///////////////////// COMPOSITE ////////////////////////////
			if((toDo != null && ( totalWork == 0 || ( totalPerformed == totalWork && finished.length == children.length)) )) {
				///nothing to load!//////////////
				if(!hsmIsActive) {
					trace("WARNING startWork() called with nothing to load");
					_initState = s_done;
					initStateMachine();
					return;
				}else {
					trace("" + _smName + "#" + _smID + ".startWork2 ......finished");
					requestTran(s_done);
				}
			}
			if(toDo != null && toDo.length > 0) {
				///////////////////// HAS CHILDREN ////////////////////
				var c : IUnit;
				if(mode == PARALLEL_MODE) {
					//PARALLEL
					trace("[[[[[[[loading in parrallel ---------" + toDo.length);
					while(toDo.length > 0) {
						c = IUnit(toDo.shift());
						c.addEventListener(EVT_COMPLETE, onChildCompleted);
						c.startWork();
						active.push(c);
						parallelAllChildrenStarted = false;
					}
				}else {
					//SEQUENTIAL
					trace("[[[[[[[loading sequentially---------" + toDo.length);
					c = IUnit(toDo.shift());
					c.addEventListener(EVT_COMPLETE, onChildCompleted);
					c.startWork();
					active.push(c);
				//if(!pulseHasStarted()){
				//	dispatchEventententent(SIG_ENTRY);
				//}
				}
				//_initState =s__doing;
				if(!hsm_is_Active){
				initStateMachine();
				}
				if(!isInState(s__doing) && !isInState(s___partiallyDone)&& !isInState(s_done) && !isInState(s__notDoneWithErrors)){
				requestTran(s__doing);
				}
				return;				
			}else {
				//////////// LEAF/SOLO /////////////////////
				if(!hsm_is_Active){
				initStateMachine();
				}
				if(!isInState(s__doing) && !isInState(s___partiallyDone)&& !isInState(s_done) && !isInState(s__notDoneWithErrors)){
					requestTran(s__doing);
				}
			}
		}
		public function startWorkNoChildren(evt:Event = null):void{
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
					trace("child " + c.getUnitName() + " says it's completed");
					c.removeEventListener(EVT_COMPLETE, onChildCompleted);
					finished.push(c);	
					active.splice(i, 1);
				}	
			}
			if(evt.cancelable) {
				evt.stopImmediatePropagation();
			}
			
			trace(_smName + "_" + smID + ".HIGHLIGHTG onChildCompleted" + active.length);
			dispatchEvent(SIG_CALLBACK.createPrivateEvent());
		}

		public function onChildErrored(evt : Event = null) : void {
			trace("a child errored out");
			//dispatchEvent(new PlayheadEvent(EVT_COMPLETE));
		}

		public function execute() : void {
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
					if(!isLeafTask){
					if(toDo == null && finished.length == 0) {
						//FINISHED LOADING LIST
						trace(_smName + "#" + _smID + ".FINISHED EMPTY WORKLIST");
						requestTran(s_done);
					}else if ( finished.length == children.length) {
						//FINISHED LOADING LIST
						trace(_smName + "#" + _smID + ".FINISHED LOADING WORKLIST");
						requestTran(s_done);
					}else if (toDo.length >= 0) {
						//FINISHED LOADING A CHILD
						trace(_smName + "#" + _smID + ".FINISHED LOADING CHILD");
						startWork();
					}
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
					trace(_smName + "#" + _smID + ".s__doing SIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRY. start Pulse");
				
					startPulse();
					return null;
				case SIG_PULSE:
					
					calcStats();
					
					trace(_smName + "#" + _smID + ".Pulsing " + totalPerformed + "/ " + totalWork);
					
					if(totalPerformed > 0 && totalWork > 0) {
						trace("target.totalFrames " + totalWork);
						//TODO dispatchEvent("STARTED_GETTING_DATA");
						//	if(totalWork > 0  && totalWork ==totalPerformed){
						//		requestTran(s_done);						
						//	}else{
						trace("!!requestTran(s___partiallyDone)");
						requestTran(s___partiallyDone);	
					//	}
					}else {
						trace("target.totalFrames " + totalWork);
					}
					notifyProgress();
					return null;
				case SIG_EXIT :
					trace(_smName + "#" + _smID + ".s__doing SIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXIT. stop Pulse");
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
					trace(_smName + "#" + _smID + ".[[[[[[[UnitOfWork.loaded " + totalPerformed + " /  " + totalWork);
					
					
					if(parallelAllChildrenStarted && activePerformed >= activeWork) {
						
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
					trace("" + _smName + "#" + _smID + ".s_doneENTER +++++++++++++++++++++++++++++++++++++++" + toDo);
		
					fireCompletedEvent();
					return null;
				case SIG_EXIT :
					return null;
			}
			return s_root;
		}

		public function setParentTask(parent : IUnit) : void {
			
			_parentUnit = parent;
		}

		public function getParentTask() : IUnit {
			
			return _parentUnit;
		}
	}
}