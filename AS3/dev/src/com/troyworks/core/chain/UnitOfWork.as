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
		/*- in parallel preloading chain/UnitOfWork.as now waits for the completion event to fire prior to moving on, rather than looking at raw bytes loaded.
		- renamed the queues to make more sense.  AllTasks (unfinished or not), ToDo(those left to do), active (those being worked on), finished (all finished regardless of ok or failed), finished_with_errors and finished_ok just the subset of finished that do that thing.
		 */
		protected var totalWork : Number = 0;
		protected var totalPerformed : Number = 0;
		protected var activeWork : Number = 0;
		protected var activePerformed : Number = 0;
		protected var totalHaveSaidFinished : Number = 0;
		protected var totalToBeFinished : Number = 0;
		public var alltasks : Array = null;
		// piles to denote what of the children are done,
		public var toDo : Array = null;
		// which are actively downloading at present
		public var active : Array = null;
		// which are currently errored/done
		public var finished : Array = null;
		public var finished_with_errors : Array = null;
		protected var finished_ok : Array = null;
		public var mode : Boolean = SEQUENTIAL_MODE;
		public var checkInterval : Number = 1000 / 12;
		private var _parentUnit : IUnit;
		public var parallelAllChildrenStarted : Boolean = false;
		public  var isLeafTask : Boolean = false;
		public var traceEnabled : Boolean = false;
		public var hasFiredComplete : Boolean = false;
		private var hasRequestedDoneTransition : Boolean;

		public function UnitOfWork(initState : String = "s__haventStarted", aMode : Boolean = SEQUENTIAL_MODE, smName : String = "Chain") {
			super(initState, smName, false);

			_smName = smName + "_" + (mode == SEQUENTIAL_MODE) ? SEQUENTIAL_WORKER : PARALLEL_WORKER;
			trace2("smName  " + _smName + "#" + _smID);
			init(aMode);
			trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA " + alltasks.length);
		}

		public function init(aMode : Boolean = SEQUENTIAL_MODE) : void {
			mode = aMode;
			alltasks = new Array();
			toDo = null;
			active = new Array();
			finished = new Array();
			finished_with_errors = new Array();
			finished_ok = new Array();
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

		public function isFinishedOK() : Boolean {
			return isInState(s_done);
		}

		public function isFinishedWithErrors() : Boolean {
			return isInState(s__notDoneWithErrors);
		}

		public function hasStarted() : Boolean {
			return  isInState(s___partiallyDone) || isInState(s_done);
		}

		protected function firePulseEvent(evt : Event = null) : void {
			dispatchEvent(CogEvent.getPulseEvent());
		}

		protected function fireCompletedEvent() : void {
			if (!hasFiredComplete) {
				trace(_smName + "#" + _smID + ".fireCompletedEvent");
				trace2(_smName + "#" + _smID + ".dispatching ***Complete***");
				var evt : PlayheadEvent = new PlayheadEvent(EVT_COMPLETE);
				evt.percentageDone = 1;
				dispatchEvent(evt);
				hasFiredComplete = true;
			} else {
				throw new Error("ERROR DOUBLE DIP");
			}
		}
		/* a somewhat nasty hack as this unit of work gets going and donebefore the 
		 * statemachine has fully intialized
		 * which means it tends to reinitialize itself after it's already done
		 */
		override protected function hsm_s_Activating(event : CogEvent) : void {
			if (isInState(s_done)) {
				return;
			} else {
				super.hsm_s_Active(event);
			}
		}

		// Top down query and summary of status //
		public function calcStats(evt : Event = null) : void {
			var i : int = 0;
			var n : int = alltasks.length;
			var tp : Number;
			var tw : Number;

			var paraActive : int = 0;
			if (n > 0) {
				totalPerformed = 0;
				totalWork = 0;
				activeWork = 0;
				activePerformed = 0;
				totalHaveSaidFinished = 0;
				// ----- go through all children and see if they are done --//
				var c : IUnit;

				for (;i < n; ++i) {
					c = IUnit(alltasks[i]);

					tp = c.getWorkPerformed();
					tw = c.getTotalWorkToPerform();
					if (c.isFinishedOK() || c.isFinishedWithErrors()) {
						trace2(" D " + c.getUnitName() + " " + tp + " / " + tw);
						totalHaveSaidFinished++;
					} else {
						trace2(" ?  " + c.getUnitName() + " " + tp + " / " + tw);
					}
					totalPerformed += tp;
					totalWork += tw;
				}
				// // ////// ACTIVE LIST // // //////////
				i = 0;
				n = active.length;

				for (;i < n; ++i) {
					c = IUnit(active[i]);

					tp = c.getWorkPerformed();
					tw = c.getTotalWorkToPerform();

					if (c.hasStarted()) {
						trace2(" A " + c.getUnitName() + " " + tp + " / " + tw);

						paraActive++;
					} else {
						trace2(" * " + c.getUnitName() + " " + tp + " / " + tw);
					}

					activePerformed += tp;
					activeWork += tw;
				}
			} else {
				totalPerformed = getWorkPerformed();
				totalWork = getTotalWorkToPerform();
				activePerformed = totalPerformed;
				activeWork = totalWork;
				if (isFinishedOK()) {
					totalHaveSaidFinished = 1;
				}
			}
			if (paraActive == active.length) {
				parallelAllChildrenStarted = true;
			}
			trace2(_smName + "#" + _smID + ".calcStats " + totalPerformed + " / " + totalWork);
			notifyProgress();
		}

		public function bottomUpNotification() : void {
		}

		protected function notifyProgress() : void {
			trace2(_smName + "#" + _smID + ".UnitOfWork.notifyProgress " + totalPerformed + " / " + totalWork);
			var evt : PlayheadEvent = new PlayheadEvent(EVT_PROGRESS);

			evt.percentageDone = totalPerformed / totalWork;
			dispatchEvent(evt);
			// if(evt.percentageDone == 1) {
	
			// }
		}

		public function addChild(c : IUnit) : void {
			trace2(_smName + smID + " HIGHLIGHTR addCHild ");
			alltasks.push(c);
			if (toDo == null ) {
				toDo = new Array();
			}
			toDo.push(c);
			totalToBeFinished = alltasks.length;
			c.setParentTask(this);
			IEventDispatcher(c).addEventListener(EVT_COMPLETE, calcStats);
			IEventDispatcher(c).addEventListener(EVT_PROGRESS, calcStats);
			IEventDispatcher(c).addEventListener(EVT_ERROR, calcStats);
			calcStats();
		}

		public function startWork() : void {
			trace2("" + _smName + "#" + _smID + ".startWork +++++++++++++++++++++++++++++++++++++++ todo:" + toDo);
			hasFiredComplete = false;
			// // ///////////////// COMPOSITE // // ////////////////////////
			if ((toDo != null && ( totalWork == 0 || ( totalPerformed == totalWork && finished.length == alltasks.length)) )) {
				// /nothing to load!//////////////
				if (!hsmIsActive) {
					trace2("WARNING startWork() called with nothing to load");
					_initState = s_done;
					initStateMachine();
					return;
				} else {
					trace2("" + _smName + "#" + _smID + ".startWork2 ......FINISHED");
					requestTran(s_done);
				}
			}
			if (toDo != null && toDo.length > 0) {
				// // ///////////////// HAS CHILDREN // // ////////////////
				var c : IUnit;
				if (mode == PARALLEL_MODE) {
					// PARALLEL
					trace2("[[[[[[[loading in parrallel ---------" + toDo.length);
					while (toDo.length > 0) {
						c = IUnit(toDo.shift());
						c.addEventListener(EVT_COMPLETE, onChildCompleted);
						c.addEventListener(EVT_ERROR, onChildErrored);
						c.addEventListener(EVT_PROGRESS, calcStats);
						c.startWork();
						active.push(c);
						parallelAllChildrenStarted = false;
					}
				} else {
					// SEQUENTIAL
					trace2("[[[[[[[loading sequentially---------" + toDo.length);
					c = IUnit(toDo.shift());
					c.addEventListener(EVT_COMPLETE, onChildCompleted);
					c.addEventListener(EVT_ERROR, onChildErrored);
					c.addEventListener(EVT_PROGRESS, calcStats);
					c.startWork();
					active.push(c);
					// if(!pulseHasStarted()){
					// dispatchEventententent(SIG_ENTRY);
					// }
				}
				if (toDo.length == 0) {
					toDo = null;
				}

				// _initState =s__doing;
				if (!hsm_is_Active) {
					initStateMachine();
				}
				if (!isInState(s__doing) && !isInState(s___partiallyDone) && !isInState(s_done) && !isInState(s__notDoneWithErrors)) {
					requestTran(s__doing);
				}
				return;
			} else {
				// // //////// LEAF/SOLO // // /////////////////
				if (!hsm_is_Active) {
					initStateMachine();
				}
				if (!isInState(s__doing) && !isInState(s___partiallyDone) && !isInState(s_done) && !isInState(s__notDoneWithErrors)) {
					requestTran(s__doing);
				}
			}
		}

		public function startWorkNoChildren(evt : Event = null) : void {
			initStateMachine();
			requestTran(s__doing);
		}

		public function onChildCompleted(evt : Event = null) : void {
			// called when a child has broadcast the COMPLETE event
			var i : int = 0;
			var n : int = active.length;
			// cross the finished off our active list////////////////
			for (;i < n; ++i) {
				var c : IUnit = IUnit(active[i]);
				if (c == evt.target) {
					trace2("child " + c.getUnitName() + " says it's completed!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					c.removeEventListener(EVT_COMPLETE, onChildCompleted);
					c.removeEventListener(EVT_PROGRESS, calcStats);
					c.removeEventListener(EVT_ERROR, onChildErrored);
					finished.push(c);
					finished_ok.push(c);
					active.splice(i, 1);
					break;
				}
			}
			if (evt.cancelable) {
				evt.stopImmediatePropagation();
			}

			trace2(_smName + "_" + smID + ".HIGHLIGHTG onChildCompleted" + active.length);
			dispatchEvent(SIG_CALLBACK.createPrivateEvent());
		}

		public function onChildErrored(evt : Event = null) : void {
			trace2("onChildErrored OUT");
			var i : int = 0;
			var n : int = active.length;
			// cross the finished off our active list////////////////
			for (;i < n; ++i) {
				var c : IUnit = IUnit(active[i]);
				if (c == evt.target) {
					trace2("child " + c.getUnitName() + " says it's completed");
					c.removeEventListener(EVT_COMPLETE, onChildCompleted);
					c.removeEventListener(EVT_PROGRESS, calcStats);
					c.removeEventListener(EVT_ERROR, onChildErrored);
					finished.push(c);
					finished_with_errors.push(c);
					active.splice(i, 1);
				}
			}
			if (evt.cancelable) {
				evt.stopImmediatePropagation();
			}

			var pE : PlayheadEvent = new PlayheadEvent(EVT_ERROR);
			pE.percentageDone = totalPerformed / totalWork;
			dispatchEvent(pE);
			requestTran(s__notDoneWithErrors);
		}

		public function execute() : void {
		}

		override public function initStateMachine() : void {
			calcStats();
			super.initStateMachine();
		}

		// // ///////////////// STATES // // /////////////////////
		// notdone > doing > done
		// 11111111111111111111111111111111111111111111111111111111
		public function s_notDone(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					hasRequestedDoneTransition = false;
					return null;
				case SIG_EXIT :
					stopPulse();
					return null;
				case SIG_CALLBACK:
					if (!isLeafTask) {
						if (toDo == null && finished.length == 0) {
							// FINISHED LOADING LIST
							trace2(_smName + "#" + _smID + ".FINISHED EMPTY WORKLIST");
							if(!hasRequestedDoneTransition){
								requestTran(s_done);
								hasRequestedDoneTransition = true;
							}
						} else if ( finished.length == alltasks.length) {
							// FINISHED LOADING LIST
							trace2(_smName + "#" + _smID + ".FINISHED LOADING WORKLIST");
							if(!hasRequestedDoneTransition){
								requestTran(s_done);
								hasRequestedDoneTransition = true;
							}
						} else if (alltasks.length >= 0) {
							// FINISHED LOADING A CHILD
							trace2(_smName + "#" + _smID + ".FINISHED LOADING CHILD");
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

		// 222222222222222222222222222222222222222222222222222222222
		public function s__doing(e : CogEvent) : Function {
			switch (e.sig) {
				// case SIG_INIT:
				// return (totalPerformed > 0 && totalWork > 0 )? s___partiallyDone:null;
				case SIG_ENTRY :
					trace2(_smName + "#" + _smID + ".s__doing SIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRYSIG_ENTRY. start Pulse");
					startPulse();
					return null;
				case SIG_PULSE:
					calcStats();
					trace2(_smName + "#" + _smID + ".Pulsing " + totalPerformed + "/ " + totalWork);
					if ((totalHaveSaidFinished != totalToBeFinished) && (totalPerformed > 0) && (totalWork > 0)) {
						trace2(totalHaveSaidFinished + " " + totalToBeFinished + "  " + totalPerformed + " target.totalFrames " + totalWork);
						// TODO dispatchEvent("STARTED_GETTING_DATA");
						// if(totalWork > 0  && totalWork ==totalPerformed){
						// requestTran(s_done);
						// }else{
						trace2("!!requestTran(s___partiallyDone)");
						requestTran(s___partiallyDone);
						// }
					} else {
						trace2("target.totalFrames " + totalWork);
					}
					notifyProgress();
					return null;
				case SIG_EXIT :
					trace2(_smName + "#" + _smID + ".s__doing SIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXITSIG_EXIT. stop Pulse");
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
					trace2("[[[[[[[----pulse-----");
					calcStats();
					trace2(_smName + "#" + _smID + ".[[[[[[[UnitOfWork.loaded " + totalPerformed + " /  " + totalWork);
					if (parallelAllChildrenStarted && totalHaveSaidFinished >= totalToBeFinished ) {
						if (active == null || active.length == 0) {
							// trace2("[[[[[[[finished Loading child(ren)------ LOADING " + active.length + " LEFT " + toDo.length);

							dispatchEvent(SIG_CALLBACK.createPrivateEvent());
						}
					}
					return null;
				case SIG_EXIT :
					return null;
			}
			return s__doing;
		}

		// 33333333333333333333333333333333333333333333333333333333
		public function s_done(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_ENTRY :
					notifyProgress();
					// // //////dispatch complete event // // ////////
					trace2("" + _smName + "#" + _smID + ":UnitOfWork.s_doneENTER +++++++++++++++++++++++++++++++++++++++" + toDo);
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

		public function trace2(st : String) : void {
			if (traceEnabled) {
				trace(st);
			}
		}
	}
}