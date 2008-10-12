package com.troyworks.util.datetime {
	import com.troyworks.events.EventWithArgs;	

	import flash.utils.Dictionary;	
	import flash.events.Event;
	import flash.events.EventDispatcher;	

	public class StopWatchLogger {
		private var log : Array;
		private var watches : Dictionary = new Dictionary(true);

		
		public function StopWatchLogger(stopWatch : StopWatch = null) {
			super();
			addWatch(stopWatch);
		}

		public function addWatch(stopWatch : StopWatch) : void {
			
			if(stopWatch == null) {
				return;	
			}
			watches[stopWatch] = stopWatch;
			
		//	trace("stopWatch " + stopWatch + " " + StopWatch);
			stopWatch.addEventListener(StopWatch.START, onStart);
			stopWatch.addEventListener(StopWatch.STOP, onStop);
			stopWatch.addEventListener(StopWatch.RESET, onReset);
			stopWatch.addEventListener(StopWatch.COMPLETE, onComplete);
		}

		public function removeWatch(stopWatch : StopWatch) : Boolean {
			if(stopWatch == null) {
				return false;	
			}
			
			if (watches[stopWatch] != null) {
				
				
				stopWatch.removeEventListener(StopWatch.START, onStart);
				stopWatch.removeEventListener(StopWatch.STOP, onStop);
				stopWatch.removeEventListener(StopWatch.RESET, onReset);
				stopWatch.removeEventListener(StopWatch.COMPLETE, onComplete);
				delete(watches[stopWatch]);
				return true;
			}
			else return false;
		}

		public function onStart(evt : Event) : void {
			trace("hear Start logging evt  evt.target.timeStamp " + evt.target.timeStamp);
			log = new Array();
			log["start"] = new TimeLogEntry(evt.target.timeStamp);
		}

		public function onStop(evt : Event) : void {
			trace("onStop evt " + evt);
			if (log == null) return;
			log["stop"] = new TimeLogEntry(evt.target.timeStamp);
		}

		public function onComplete(evt : Event) : void {
			trace("onComplete evt " + evt);
			if (log == null) return;
			log["complete"] = new TimeLogEntry(evt.target.timeStamp);
		}		

		public function onReset(evt : Event) : void {
			trace("onReset evt " + evt);
			log = new Array();
		}

		
		public function addLogEntry(evt : EventWithArgs) : void {
			
			trace("addLogEntry " + evt.args[0] + " evt.target.timeStamp " + evt.target.timeStamp);
			if (log == null) return;
			log[evt.args[0]] = new TimeLogEntry(evt.target.timeStamp);
		}

		public function traceLog() : void {
			trace("Log Entries:");
			if (log == null) trace("Counter has not been started. Log is empty");
			var entry : TimeLogEntry;
			for (var obj:Object in log) {
				entry = log[obj.toString()];
				trace(obj.toString() + " date " + entry.getDate().toString() + " time " + entry.getTime());
			}
		}

		public function getDelta(name1 : String, name2 : String) : TimeQuantity {
			var entry1 : TimeLogEntry = log[name1];
			var entry2 : TimeLogEntry = log[name2];
			if (entry1 == null || entry2 == null) return null;
			var delta : TimeQuantity = entry2.getDelta(entry1); 
			return delta;			
		}
	}
}