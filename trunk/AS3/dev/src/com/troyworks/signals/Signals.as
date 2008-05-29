/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.signals {
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;
	
	public class Signals extends CogSignal{
		/*****************************************
		 * Signals are immutable and reused over and over again
		 *  across various CogEvents,
		 * 
		 * This collection of Signals covers the entire 'Family Tree'
		 * of Transitions that Cog Supports.
		 * 
		 * See 	//http://en.wikipedia.org/wiki/Cousin for a better understanding 
		 * of terms as used traditionally, 
		 * 
		 *************************************** */
		////////////////REQUEST CATEGORY //////////////////////////////////
	 	public static  const CREATE: Signals = Signals.getNextSignal("CREATE");
		public static  const READ_FROM :  Signals = Signals.getNextSignal("READ_FROM");
		public static  const UPDATE :  Signals = Signals.getNextSignal("UPDATE");
		public static  const DELETE :  Signals = Signals.getNextSignal("DELETE");
		
		///////// EVENT LIFECYCLE CYCLE /////////////////
		public static  const CREATING_START:Signals = Signals.getNextSignal("CREATING_START");
		public static  const CREATING_PROGRESS:Signals = Signals.getNextSignal("CREATING_PROGRESS");
		public static  const CREATED:Signals = Signals.getNextSignal("CREATED");
		
		public static  const READING_START:Signals = Signals.getNextSignal("READING_START");
		public static  const READING_PROGRESS:Signals = Signals.getNextSignal("READING_PROGRESS");
		public static  const READ:Signals = Signals.getNextSignal("READ");
		
		public static  const UPDATING_START:Signals = Signals.getNextSignal("UPDATING_START");
		public static  const UPDATING_PROGRESS:Signals = Signals.getNextSignal("UPDATING_PROGRESS");
		public static  const UPDATED:Signals = Signals.getNextSignal("UPDATED");
		
		public static  const DELETING_START : Signals = Signals.getNextSignal("DELETING_START");
		public static  const DELETING_PROGRESS : Signals = Signals.getNextSignal("DELETING_PROGRESS");
		public static  const DELETED : Signals = Signals.getNextSignal("DELETED");
		
		//////////// 1D COLLECTION NAVIGATION ////////////////////////////////////////////
	 	public static  const GOTO : Signals = Signals.getNextSignal("GOTO");
		public static  const GOTO_PREVIOUS: Signals = Signals.getNextSignal("GOTO_PREVIOUS");
		public static  const GOTO_NEXT : Signals = Signals.getNextSignal("GOTO_NEXT");
		public static  const GOTO_FIRST : Signals = Signals.getNextSignal("GOTO_FIRST");
		public static  const GOTO_MIDDLE: Signals = Signals.getNextSignal("GOTO_MIDPOINT");
		public static  const GOTO_LAST: Signals = Signals.getNextSignal("GOTO_LAST");
		
		public static  const REACHED : Signals = Signals.getNextSignal("REACHED");
		public static  const REACHED_PREVIOUS: Signals = Signals.getNextSignal("REACHED_PREVIOUS");
		public static  const REACHED_NEXT : Signals = Signals.getNextSignal("REACHED_NEXT");
		public static  const REACHED_FIRST : Signals = Signals.getNextSignal("REACHED_FIRST");
		public static  const REACHED_MIDDLE: Signals = Signals.getNextSignal("REACHED_MIDPOINT");
		public static  const REACHED_LAST: Signals = Signals.getNextSignal("REACHED_LAST");
		public static  const REACHED_NOT_FIRST_OR_LAST: Signals = Signals.getNextSignal("REACHED_NOT_FIRST_OR_LAST");
		
		///////////// COLLECTION 
		public static  const COLLECTION_EMPTY: Signals = Signals.getNextSignal("COLLECTION_EMPTY");
		public static  const COLLECTION_NOT_EMPTY: Signals = Signals.getNextSignal("COLLECTION_NOT_EMPTY");
		public static  const COLLECTION_FULL: Signals = Signals.getNextSignal("COLLECTION_FULL");
		public static  const COLLECTION_SIZE_CHANGED: Signals = Signals.getNextSignal("COLLECTION_SIZE_CHANGED");
		public static  const COLLECTION_CURSOR_CHANGED: Signals = Signals.getNextSignal("COLLECTION_CURSOR_CHANGED");
		
		//////////// MOUSE MOVIE
		public static  const MOUSE_DOWN: Signals = Signals.getNextSignal("MOUSE_DOWN");
		public static  const MOUSE_MOVE: Signals = Signals.getNextSignal("MOUSE_MOVE");
		public static  const MOUSE_UP: Signals = Signals.getNextSignal("MOUSE_UP");
		public static  const MOUSE_CLICK: Signals = Signals.getNextSignal("MOUSE_CLICK");
		
		public function Signals(val : uint, name : String) {
			super(val, name );
		}

		public static function getNextSignal(msg:String):Signals {
			var sig:CogSignal = CogSignal.getNextSignal(msg);
			return new Signals(sig.value,msg);
		}
		override public function toString():String{
			return String(name);
		}
	}
}
