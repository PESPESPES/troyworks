/**
* Indicates that this command/transaction can be performed in a synchronous fashion, immediately returning
* (or at least from the perspective of the thread calling it returning before timing out), rather than a call
* callback method
* 
* @author Troy Gardner Troy@TroyWorks.com
* @version 0.1
*/

package com.troyworks.core.commands {
	import com.troyworks.core.commands.ICommand;

	public interface ISynchronousCommand extends ICommand {
		function execute():void;
	}
	
}
