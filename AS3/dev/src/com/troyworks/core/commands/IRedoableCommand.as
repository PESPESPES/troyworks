package com.troyworks.core.commands {

	public interface IRedoableCommand extends ICommand {
	
		function redo():void;
		
	}
}