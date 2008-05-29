/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.Tdining_philosophers {
	import flash.display.Sprite;
	import com.troyworks.activeframe.QF;
	import com.troyworks.Tdining_philosophers.Table;
	import com.troyworks.Tdining_philosophers.Philosopher;
	
	public class BootStrapper extends Sprite{
		protected static var tbl:Table;
		protected static var phils:Array;
		
		
		public function BootStrapper(){
			var NUMBER_OF_PHILOSOPHERS:int = 3;
			QF.init();
			tbl = new Table(NUMBER_OF_PHILOSOPHERS);
			tbl.initHsm();
			phils = new Array();
			for(var i:int = 0; i < NUMBER_OF_PHILOSOPHERS; i++){
				var p:Philosopher = new Philosopher(i);
				p.initHsm();
				phils.push(p);
				
			}
		}
	}
	
}
