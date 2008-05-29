/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.demo1 {
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import com.troyworks.Prevayler;
	import com.troyworks.PrevaylerFactory;


	public class Main extends Sprite{
		
		public function Main() {
			trace("\nRobustness Reminder: You can kill this process at any time.\nWhen you restart the system, you will see that nothing was lost.\nPress Enter to continue.\n");
			addEventListener(MouseEvent.CLICK, run);
		}
		private function run(): void {
			removeEventListener(MouseEvent.CLICK, run);
			trace("starting Prevayler");
			var prevayler:Prevayler = PrevaylerFactory.createPrevayler(new NumberKeeper(), "demo1");
			new PrimeCalculator(prevayler).start();
			
			
		}	
	}
	
}
