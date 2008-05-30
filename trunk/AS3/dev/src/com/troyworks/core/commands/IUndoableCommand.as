package com.troyworks.core.commands {

	public interface IUndoableCommand extends ICommand {
	
		function undo():void;
		
	}
}