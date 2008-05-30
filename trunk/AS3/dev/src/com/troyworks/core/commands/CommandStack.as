/**
* ...
* This uses a 0 based array for representing the comand stack, versus a 1 based array (as in Joey's example)
* TC : *01234
*  -1: ^. redo
*   0: -^ undo 
* @author Default
* @version 0.1
*/

package com.troyworks.core.commands {
//	import com.troyworks.core.CRUDEvent;
	import com.troyworks.core.cogs.CogEvent;
//	import com.troyworks.framework.QEvent;
//	import com.troyworks.core.cogs.CogExternalEvent;
	import com.troyworks.core.Signals;
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.logging.TraceAdapter;
	import flash.events.Event;
	
	public class CommandStack extends Hsm{
		public static const GOTO_PREVIOUS: Signals = Signals.GOTO_PREVIOUS;
		public static const GOTO_NEXT: Signals = Signals.GOTO_NEXT;
		
		private var _curCommand:ICommand;
		private var _commands:Array;
		
		private var _index:int = -1;
		private var _last_index:int =-1;
		
		public function CommandStack(initState:String = "s_initial") {
			super(initState, "CommandStack");
			trace = TraceAdapter.TraceToSOS;
			_commands = new Array();
			 trace("HIGHLIGHTP " + _index + " / " + _commands.length);
		
		}
		/////////////////// MODIFIERS /////////////////////////////////////
		public function putCommand(command:ICommand, dispatchChange:Boolean = true):void {
			 var tIdx:int = _index +1;
	
			_commands[tIdx] = command;
					 trace("HIGHLIGHTP putCommand at " + tIdx + "  len " + _commands.length);
			setIndex (tIdx, false);
			//erase commands past the entry point
			_commands.splice(_index+1, _commands.length - _index+1);
			//commands length changed.
			//dispatchEvent(new CRUDEvents(
			if(dispatchChange){
				onCollectionChanged();
			}
		}
	/*	private function onUndo(event:MouseEvent):void {
			var stack:CommandStack = CommandStack.getInstance();
			if(stack.hasPreviousCommands()) {
				var command:ICommand = stack.previous();
				if(command is IUndoableCommand) {
					IUndoableCommand(command).undo();
				}
			}
		}

		private function onRedo(event:MouseEvent):void {
			var stack:CommandStack = CommandStack.getInstance();
			if(stack.hasNextCommands()) {
				var command:ICommand = stack.next();
				if(command is IRedoableCommand) {
					IRedoableCommand(command).redo();
				}
			}
		}*/
		// INTENTIONALLY no remove command
		private function setIndex(idx:int, dispatchChange:Boolean = true):void{
			if(_index != idx){
				trace("HIGHLIGHT going to index " + idx + " from " + _index);
				var directionForward:Boolean = true;
				if(_index < idx){
					_curCommand = ICommand(_commands[idx]);
					if(idx == _commands.length -1){
												 trace("HIGHLIGHTo doable------------");
						_curCommand.execute();
					}else if(_curCommand is IRedoableCommand) {
							 trace("HIGHLIGHTo redoable------------");
					   IRedoableCommand(_curCommand).redo();
					 }
				}else if(_index > idx){
					_curCommand = ICommand(_commands[_index]);
					 if(_curCommand is IUndoableCommand) {
							 trace("HIGHLIGHTo doable------------");
							 IUndoableCommand(_curCommand).undo();
					 }
	
				}
				_last_index = _index;
				_index = idx;
				if(_index > 0){

					
				}else{
					_curCommand = null;
				}

				///////// DISPATCH INDEX CHANGED
				if(dispatchChange){
					onCollectionChanged();
				}
			}else{
				trace("HIGHLIGHTO NOT going to index " + idx + " last " + _last_index);
			}
		}
		private function onCollectionChanged():void{
			trace("HIGHLIGHT1 onCollectionChanged" + _commands.length );
			if(_commands.length > 0){
				requestTran( s_hasMultipleItems(EVT_INIT));
			}else {
				requestTran( s_noItems);
			}
		}
		
		/////////////////// EVENT GENERATORS ////////////////////////////////
		public function previous(evt:*):void {
		   dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PROTECTED_EVENT, GOTO_PREVIOUS));
		}
		
		public function next(evt:*):void {
		   dispatchEvent(new CogEvent(CogEvent.EVTD_COG_PROTECTED_EVENT, GOTO_NEXT));
		}

		////////////////// STATE GETTERS /////////////////////////////////////////
		public function getCurrentCommand():ICommand{
			return _curCommand;
		}
		public function hasItems():Boolean{
			return (_commands.length > 0) ;
		}
		public function hasPreviousCommands():Boolean {
			return _index > -1;
		}
		
		public function hasNextCommands():Boolean {
			return _index < _commands.length;
		}
		public function isAtFirstItem():Boolean{
			return (_commands.length > 0) &&(_index == -1);
		}
		public function isAtLastItem():Boolean{
			return  (_commands.length > 0) &&(_index == _commands.length-1 );
		}

		///////////////////////STATES/////////////////////////
		/*.................................................................*/
		 public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				if(_commands.length > 0){
					return s_hasMultipleItems;
				}else{
					return s_noItems;
				}
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_noItems(e : CogEvent):Function {
			
			switch (e.sig) {
				case SIG_ENTRY :
					dispatchEvent(new Event(Signals.COLLECTION_EMPTY.name));
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_oneItem(e : CogEvent):Function {
			
			switch (e.sig) {
				case SIG_ENTRY :
					dispatchEvent(new Event(Signals.COLLECTION_NOT_EMPTY.name));
					return null;
				case SIG_EXIT :
					return null;
			}
			return  s_root;
		}
		/*.................................................................*/
		public function s_hasMultipleItems(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				    trace("HIGHLIGHTG INIT " + _index + " " + _commands.length);
					
					if(_index ==(_commands.length-1)){
						return s_atLastOfMultipleItems;
					}else if(_index == -1){
						return s_atFirstOfMultipleItems;	
					}else{
					    return s_inMiddleOfMultipleItems;	
					}
				case SIG_ENTRY :
					dispatchEvent(new Event(Signals.COLLECTION_NOT_EMPTY.name));
					return null;

				case SIG_EXIT :

					return null;


					
				case GOTO_PREVIOUS:
					if(hasPreviousCommands()){
						trace("HIGHLIGHT  going to previous " + (_index - 1));
						setIndex((_index - 1), true);
					
					//	if(_curCommand is IUndoableCommand) {
					//		trace("HIGHLIGHTo undo------------");
					//		IUndoableCommand(_curCommand).undo();
					//	}
						//onCollectionChanged();
					}
					return null;
					
				case GOTO_NEXT:
					if(hasNextCommands()){
						 trace("HIGHLIGHT  going to next " + (_index + 1));
						 setIndex((_index + 1), true);
						 
					//	 if(_curCommand is IRedoableCommand) {
					//		 trace("HIGHLIGHTo redo------------");
					//		IRedoableCommand(_curCommand).redo();
					//	}
						//onCollectionChanged();
					}

					return null;
			
			}
			return s_root;
		}
		/*.................................................................*/
		public function s_atFirstOfMultipleItems(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					//enable next
					dispatchEvent(new Event(Signals.REACHED_FIRST.name));
					return null;

				case SIG_EXIT :

					return null;
				case GOTO_PREVIOUS:
					//override behavior
				     return null;
					
			}
			return s_hasMultipleItems;
		}

		/*.................................................................*/
		public function s_inMiddleOfMultipleItems(e : CogEvent):Function {

			switch (e.sig) {
				case SIG_ENTRY :
					//enable next and previous
						dispatchEvent(new Event(Signals.REACHED_NOT_FIRST_OR_LAST.name));
					return null;

				case SIG_EXIT :

					return null;
					
			}
			return s_hasMultipleItems;
		}
		/*.................................................................*/
		public function s_atLastOfMultipleItems(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_ENTRY :
					//enable previous
					dispatchEvent(new Event(Signals.REACHED_LAST.name));
					return null;

				case SIG_EXIT :

					return null;
					
				case GOTO_NEXT:
				    //override behavior
				    return null;
			}
			return s_hasMultipleItems;
		}		
	}
	
}
