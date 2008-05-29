package com.troyworks.commandexample {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import com.troyworks.commandexample.commandcontainers.CommandContainer;
	import com.troyworks.commandexample.shapes.Rectangle;
	import com.troyworks.commandexample.commands.RotateClockwiseCommand;
	import com.troyworks.commandexample.commands.RotateCounterclockwiseCommand;
	import com.troyworks.commandexample.commands.ScaleUpCommand;
	import com.troyworks.commandexample.controls.CommandButton;
	import com.troyworks.controls.BasicButton;
	import com.troyworks.cogs.CogExternalEvent;
	
	import com.troyworks.commandexample.commands.ScaleDownCommand;

	import com.troyworks.commands.CommandStack;
	import com.troyworks.commands.ICommand;
	import com.troyworks.commands.IUndoableCommand;
	import com.troyworks.commands.IRedoableCommand;
	import com.troyworks.signals.Signals;
	import com.troyworks.logging.TraceAdapter;
		
	public class CommandExample extends Sprite {
		
		private var cmdStk:CommandStack;
		private var undoButton:BasicButton; 
		private var redoButton:BasicButton;
		private var button:CommandButton;
		private var trace:Function;
		
		public function CommandExample() {
			trace = TraceAdapter.TraceToSOS;
			cmdStk = new CommandStack();
			
			
			var rectangle:Rectangle = new Rectangle(0xFF0000, 50);
			rectangle.x = 200;
			rectangle.y = 200;
			addChild(rectangle);

			button = new CommandButton("apply command", cmdStk);
			addChild(button);
			button.y = 250;

			var container:CommandContainer = new CommandContainer(new RotateClockwiseCommand(rectangle), "rotate clockwise", 0, 0);
			addChild(container);
			container = new CommandContainer(new RotateCounterclockwiseCommand(rectangle), "rotate counter-clockwise", 0, 55);
			addChild(container);
			container = new CommandContainer(new ScaleUpCommand(rectangle), "scale up", 0, 110);
			addChild(container);
			container = new CommandContainer(new ScaleDownCommand(rectangle), "scale down", 0, 165);
			addChild(container);

			
			undoButton = new BasicButton("undo");
			addChild(undoButton);
			undoButton.y = 280;
			undoButton.addEventListener(MouseEvent.CLICK, cmdStk.previous);
			undoButton.enabled = false;
			
			redoButton = new BasicButton("redo");
			addChild(redoButton);
			redoButton.y = 310;
			redoButton.addEventListener(MouseEvent.CLICK, cmdStk.next);
			redoButton.enabled = false;
			//////////////////////////////////////////
			//cmdStk.addEventListener(CogExternalEvent.CHANGED,onCommandCursorChanged);
			cmdStk.addEventListener(Signals.REACHED_FIRST.name, onReachedFirstHandler);
			cmdStk.addEventListener(Signals.REACHED_NOT_FIRST_OR_LAST.name, onReachedNotFirstOrLast);
			cmdStk.addEventListener(Signals.REACHED_LAST.name, onReachedLastHandler);
			cmdStk.addEventListener(Signals.COLLECTION_EMPTY.name, onCollectionEmpty);
			cmdStk.initHsm();
			
		}
		private function onCommandCursorChanged(evt:Event):void{
			trace("CommandExample.onCommandCursorChanged");
		}
		private function onCollectionEmpty(evt:Event):void{
			trace("CommandExample.onCollectionEmpty");
			undoButton.enabled = false;
			redoButton.enabled = false;
		}
		private function onReachedFirstHandler(evt:Event):void{
			trace("CommandExample.onReachedFirstHandler");
			undoButton.enabled = false;
			redoButton.enabled = true;

		}
		private function onReachedNotFirstOrLast(evt:Event):void{
			trace("CommandExample.onReachedNotFirstOrLast");
			undoButton.enabled = true;
			redoButton.enabled = true;
		}
		private function onReachedLastHandler(evt:Event):void{
			trace("CommandExample.onReachedLastHandler");
			undoButton.enabled = true;
			redoButton.enabled = false;

		}

		
	}
}
