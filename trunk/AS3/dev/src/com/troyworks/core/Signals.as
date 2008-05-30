/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.core {
	import com.troyworks.framework.QEvent;
	import flash.events.Event;
	import com.troyworks.core.cogs.CogEvent;
	import com.troyworks.core.cogs.CogSignal;
	
	public class Signals extends CogSignal{
		/*****************************************
		 * A signal is like a cached Event.name /type.
		 * 
		 * It differs from an Event in that Events are unique in time, signals are generic.
		 * 
		 * The use of signals in both event generators and event handlers is *much* faster
		 * than using strings for comparison inside switch statements, as it uses direct equality "===" rather than
		 * value of. 
		 * 
		 * Strings are created once rather than every time as normal new Event("etc").
		 * This may be less of an issue when using pointer e.g. new Event(MouseEvent.CLICK);
		 * 
		 * Signals are immutable and reused over and over again
		 *  across various CogEvents,
		 * 		 * 
		 *************************************** */
		//////////////////ACTIVATION / DEACTIVEATION ///////////////////////////
		public static  const REQUEST_ACTIVATION:Signals = Signals.getNextSignal("REQUEST_ACTIVATION");
		public static  const ACTIVATION_START:Signals = Signals.getNextSignal("ACTIVATION_START");
		public static  const ACTIVATION_PROGRESS:Signals = Signals.getNextSignal("ACTIVATION_PROGRESS");
		public static  const ACTIVATED:Signals = Signals.getNextSignal("ACTIVATED");
		public static  const REQUEST_DEACTIVATION:Signals = Signals.getNextSignal("REQUEST_DEACTIVATION");
		public static  const DEACTIVATION_START:Signals = Signals.getNextSignal("DEACTIVATION_START");
		public static  const DEACTIVATION_PROGRESS:Signals = Signals.getNextSignal("DEACTIVATION_PROGRESS");
		public static  const DEACTIVATED:Signals = Signals.getNextSignal("DEACTIVATED");
		
		
		////////////////// INIT / ENTER / EXIT / TRANSITION ///////////////////////////
		public static  const REQUEST_ENTER:Signals = Signals.getNextSignal("REQUEST_ENTER");
		public static  const ENTER_START:Signals = Signals.getNextSignal("ENTER_START");
		public static  const ENTER_PROGRESS:Signals = Signals.getNextSignal("ENTER_PROGRESS");
		public static  const ENTERED:Signals = Signals.getNextSignal("ENTERED");

		public static  const REQUEST_EXIT:Signals = Signals.getNextSignal("REQUEST_EXIT");
		public static  const EXIT_START:Signals = Signals.getNextSignal("EXIT_START");
		public static  const EXIT_PROGRESS:Signals = Signals.getNextSignal("EXIT_PROGRESS");
		public static  const EXITED:Signals = Signals.getNextSignal("EXITED");
		
		public static  const REQUEST_TRANSITION:Signals = Signals.getNextSignal("REQUEST_TRANSITION");
		public static  const TRANSITION_START:Signals = Signals.getNextSignal("TRANSITION_START");
		public static  const TRANSITION_PROGRESS:Signals = Signals.getNextSignal("TRANSITION_PROGRESS");
		public static  const TRANSITIONED:Signals = Signals.getNextSignal("TRANSITIONED");
		
		public static  const REQUEST_INITIALIZATION:Signals = Signals.getNextSignal("REQUEST_INITIALIZATION");
		public static  const INITIALIZATION_START:Signals = Signals.getNextSignal("INITIALIZATION_START");
		public static  const INITIALIZATION_PROGRESS:Signals = Signals.getNextSignal("INITIALIZATION_PROGRESS");
		public static  const INITIALIZED:Signals = Signals.getNextSignal("INITIALIZED");
		
		//////////////// COMMAND LIFECYCLE ///////////////////////////////////
		public static  const CONFIRM :  Signals = Signals.getNextSignal("CONFIRM");
		public static  const EXECUTE :  Signals = Signals.getNextSignal("EXECUTE");
		public static  const CANCEL :  Signals = Signals.getNextSignal("CANCEL");
		public static  const TIMEOUT :  Signals = Signals.getNextSignal("TIMEOUT");
		public static  const ERROR :  Signals = Signals.getNextSignal("ERROR");
		///////////////////// DO /UNDO //////////////////////////////////////
		public static  const UNDO :  Signals = Signals.getNextSignal("UNDO");
		public static  const REQUEST_UNDO :  Signals = Signals.getNextSignal("REQUEST_UNDO");
		public static  const UNDOING_START :  Signals = Signals.getNextSignal("UNDOING_START");
		public static  const UNDOING_PROGRESS :  Signals = Signals.getNextSignal("UNDOING_PROGRESS");
		public static  const UNDONE :  Signals = Signals.getNextSignal("UNDONE");
		
		public static  const REDO :  Signals = Signals.getNextSignal("REDO");
		public static  const REQUEST_REDO :  Signals = Signals.getNextSignal("REQUEST_REDO");
		public static  const REDOING_START :  Signals = Signals.getNextSignal("REDOING_START");
		public static  const REDOING_PROGRESS :  Signals = Signals.getNextSignal("REDOING_PROGRESS");
		public static  const REDONE :  Signals = Signals.getNextSignal("REDONE");
		////////////////REQUEST CATEGORY //////////////////////////////////
	 	public static  const CREATE: Signals = Signals.getNextSignal("CREATE");
		public static  const READ_FROM :  Signals = Signals.getNextSignal("READ_FROM");
		public static  const UPDATE :  Signals = Signals.getNextSignal("UPDATE");
		public static  const DELETE :  Signals = Signals.getNextSignal("DELETE");
		public static  const REQUEST_CREATE: Signals = Signals.getNextSignal("REQUEST_CREATE");
		public static  const REQUEST_READ_FROM :  Signals = Signals.getNextSignal("REQUEST_READ_FROM");
		public static  const REQUEST_UPDATE :  Signals = Signals.getNextSignal("REQUEST_UPDATE");
		public static  const REQUEST_DELETE :  Signals = Signals.getNextSignal("REQUEST_DELETE");
		
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
		
		//////////// 1D COLLECTION CURSOR NAVIGATION ////////////////////////////////////////////
	 	public static  const GOTO : Signals = Signals.getNextSignal("GOTO");
		public static  const GOTO_SELF: Signals = Signals.getNextSignal("GOTO_SELF");
		public static  const GOTO_PREVIOUS: Signals = Signals.getNextSignal("GOTO_PREVIOUS");
		public static  const GOTO_NEXT : Signals = Signals.getNextSignal("GOTO_NEXT");
		public static  const GOTO_FIRST : Signals = Signals.getNextSignal("GOTO_FIRST");
		public static  const GOTO_MIDDLE: Signals = Signals.getNextSignal("GOTO_MIDPOINT");
		public static  const GOTO_LAST: Signals = Signals.getNextSignal("GOTO_LAST");
		
		public static  const REACHED : Signals = Signals.getNextSignal("REACHED");
		public static  const REACHED_SELF: Signals = Signals.getNextSignal("REACHED_SELF");
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
		public static  const ENTER_FRAME: Signals = Signals.getNextSignal("ENTER_FRAME");
		public static  const MOUSE_DOWN: Signals = Signals.getNextSignal("MOUSE_DOWN");
		public static  const MOUSE_MOVE: Signals = Signals.getNextSignal("MOUSE_MOVE");
		public static  const MOUSE_UP: Signals = Signals.getNextSignal("MOUSE_UP");
		public static  const MOUSE_RELEASED_OUTSIDE: Signals = Signals.getNextSignal("MOUSE_RELEASED_OUTSIDE");
		public static  const MOUSE_OUT: Signals = Signals.getNextSignal("MOUSE_OUT");
		public static  const MOUSE_OVER: Signals = Signals.getNextSignal("MOUSE_OVER");
		public static  const MOUSE_CLICK: Signals = Signals.getNextSignal("MOUSE_CLICK");
		public static  const MOUSE_DOUBLE_CLICK: Signals = Signals.getNextSignal("MOUSE_DOUBLE_CLICK");
		public static  const MOUSE_LEAVE: Signals = Signals.getNextSignal("MOUSE_LEAVE"); 
		public static  const MOUSE_WHEEL: Signals = Signals.getNextSignal("MOUSE_WHEEL");
		public static  const ROLL_OVER: Signals = Signals.getNextSignal("ROLL_OVER"); 
		public static  const ROLL_OUT: Signals = Signals.getNextSignal("ROLL_OUT");
		
		//////////// MEDIA PLAYER 
		//indicate static states

		public static const START :Signals = Signals.getNextSignal("START");
		public static const STARTING :Signals = Signals.getNextSignal("STARTING");
		public static const STARTED :Signals = Signals.getNextSignal("STARTED");
		
		
		public static const REPLAY :Signals = Signals.getNextSignal("REPLAY");
		public static const REPLAYING :Signals = Signals.getNextSignal("REPLAYING");
		public static const REPLAYED :Signals = Signals.getNextSignal("REPLAYED");
						
		public static const PLAY :Signals = Signals.getNextSignal("PLAY");
		public static const PLAYING :Signals = Signals.getNextSignal("PLAYING");
		public static const PLAYED :Signals = Signals.getNextSignal("PLAYED");

			
		
		public static const PAUSE : Signals = Signals.getNextSignal("PAUSE");
		public static const PAUSING : Signals = Signals.getNextSignal("PAUSING");
		public static const PAUSED : Signals = Signals.getNextSignal("PAUSED");
		public static const REWIND_AND_STOP : Signals = Signals.getNextSignal("REWIND_AND_STOP");
		public static const REWIND_AND_PLAY : Signals = Signals.getNextSignal("REWIND_AND_PLAY");
		public static const STARTED_CLIP :Signals = Signals.getNextSignal("STARTED_CLIP");
		public static const FINISHED_CLIP :Signals = Signals.getNextSignal("FINISHED_CLIP");	
		public static const STOP : Signals = Signals.getNextSignal("STOP");
		public static const STOPPING : Signals = Signals.getNextSignal("STOPPING");
		public static const STOPPED : Signals = Signals.getNextSignal("STOPPED");
		public static const GOTOANDSTOP : Signals = Signals.getNextSignal("GOTOANDSTOP");
		public static const GOTOANDPLAY :Signals = Signals.getNextSignal("GOTOANDPLAY");
		public static const INCREMENT_FRAME : Signals = Signals.getNextSignal("INCREMENT_FRAME");
		public static const DECREMENT_FRAME :Signals = Signals.getNextSignal("DECREMENT_FRAME");
		public static const PLAYBACK_STATE_CHANGED : Signals = Signals.getNextSignal("PLAYBACK_STATE_CHANGED");
		public static const PROGRESS_CHANGED :Signals = Signals.getNextSignal("PROGRESS_CHANGED");
		public static const REQUEST_RECORD :Signals = Signals.getNextSignal("REQUEST_RECORD");
		public static const RECORDING_START :Signals = Signals.getNextSignal("RECORDING_START");
		public static const RECORDING_PROGRESS :Signals = Signals.getNextSignal("RECORDING_PROGRESS");
		public static const RECORDING_FINISHED :Signals = Signals.getNextSignal("RECORDING_FINISHED");
				

		public static const PLAYFLV : Signals = Signals.getNextSignal("PLAYFLV");
		public static const PLAYMP3 : Signals = Signals.getNextSignal( "PLAYMP3");
		public static const PLAYIMAGE : Signals = Signals.getNextSignal("PLAYIMAGE");
		public static const PLAYSWF : Signals = Signals.getNextSignal("PLAYSWF");
		///////////////// TRANSITIONS
		public static const REQUEST_TRANSIN : Signals = Signals.getNextSignal("REQUEST_TRANSIN");
		public static const TRANSIN_START : Signals = Signals.getNextSignal("TRANSIN_START");
		public static const TRANSIN_PROGRESS : Signals = Signals.getNextSignal("TRANS_IN_PROGRESS");
		public static const TRANSIN_FINISHED : Signals = Signals.getNextSignal("TRANSIN_FINISHED");
		public static const REQUEST_TRANSOUT : Signals = Signals.getNextSignal("REQUEST_TRANSOUT");
		public static const TRANSOUT_START : Signals = Signals.getNextSignal("TRANSOUT_START");
		public static const TRANSOUT_PROGRESS : Signals = Signals.getNextSignal("TRANSOUT_PROGRESS");
		public static const TRANSOUT_FINISHED : Signals = Signals.getNextSignal("TRANSOUT_FINISHED");
		//////////////////FILE /EDIT
		public static const OPEN : Signals = Signals.getNextSignal("OPEN");
		public static const OPENING : Signals = Signals.getNextSignal("OPENING");
		public static const OPENED : Signals = Signals.getNextSignal("OPENED");
		public static const SAVE : Signals = Signals.getNextSignal("SAVE");
		public static const SAVING : Signals = Signals.getNextSignal("SAVING");
		public static const SAVED : Signals = Signals.getNextSignal("SAVED");
						
		public static const SAVE_AS : Signals = Signals.getNextSignal("SAVE_AS");
		public static const SAVE_ALL : Signals = Signals.getNextSignal("SAVE_ALL");	
		public static const CLOSE : Signals = Signals.getNextSignal("CLOSE");
		public static const CLOSING : Signals = Signals.getNextSignal("CLOSING");
		public static const CLOSED : Signals = Signals.getNextSignal("CLOSED");
		public static const CLOSE_ALL : Signals = Signals.getNextSignal("CLOSE_ALL");	
		
		////////////////// ENABLED / DISABLED 
		public static const ENABLE : Signals = Signals.getNextSignal("ENABLE");
		public static const ENABLING : Signals = Signals.getNextSignal("ENABLING");
		public static const ENABLED : Signals = Signals.getNextSignal("ENABLED");
		public static const DISABLE : Signals = Signals.getNextSignal("DISABLE");
		public static const DISABLING : Signals = Signals.getNextSignal("DISABLING");
		public static const DISABLED : Signals = Signals.getNextSignal("DISABLED");
		
		public static const UP : Signals = Signals.getNextSignal("UP");
		public static const OVER : Signals = Signals.getNextSignal("OVER");
		public static const DOWN : Signals = Signals.getNextSignal("DOWN");
		public static const RELEASED : Signals = Signals.getNextSignal("RELEASED");
		public static const RIGHT : Signals = Signals.getNextSignal("RIGHT");
		public static const LEFT : Signals = Signals.getNextSignal("LEFT");
				
		public function Signals(val : uint, name : String) {
			super(val, name );
		}

		public function createQEvent():QEvent{
			return new QEvent(this);
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
