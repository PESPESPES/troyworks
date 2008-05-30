/**
* This is the interface for asynchronous commands, that use the execute to start and then dispatch and event 
* for completion, and possibly progress along the way.
* 
* @author Default
* @version 0.1
*/

package com.troyworks.core.commands {
	import com.troyworks.core.commands.ICommand;
	import flash.events.IEventDispatcher;
	
	public interface IAsynchronousCommand extends ICommand, IEventDispatcher {

	}
	
}
