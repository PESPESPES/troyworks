/**
* Command Family:
* 
* ICommand
*   IAsynchCommand
*      IAsynchUndoable
*      IAsynchRedoable
*   ISynchCommand
*      ISynchUndoable
*      ISynchRedoable
* @author Default
* @version 0.1
*/

package com.troyworks.core.commands {

	public interface ICommand {
		function execute():void;
	}
	
}
