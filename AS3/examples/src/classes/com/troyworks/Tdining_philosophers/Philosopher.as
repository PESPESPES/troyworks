/**
* ...
* http://en.wikipedia.org/wiki/Dining_philosophers_problem
* @author Default
* @version 0.1
*/

package com.troyworks.Tdining_philosophers {
	import com.troyworks.activeframe.QActive;
	import com.troyworks.Tdining_philosophers.DiningSignals;
	import com.troyworks.Tdining_philosophers.TableEvent;
	import com.troyworks.activeframe.QEvent;
	import com.troyworks.activeframe.QSignal;
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.activeframe.QF

	public class Philosopher extends QActive{
		private var id:int;
		public static var IDz:int = 0;
		
		public static const THINK_TIME_MS:Number = 7;
		public static const EAT_TIME_MS:Number = 5;
		
		public static const DONE:QSignal = DiningSignals.DONE;
		public static const HUNGRY:QSignal = DiningSignals.HUNGRY;
		public static const EAT:QSignal = DiningSignals.EAT;
		private var pe:TableEvent;
		
		public function Philosopher(id:int){
			super("s_initial", "philosopher"+id);
			trace("QF " + QF);
			this.id = IDz++;
		}
		///////////////// STATES /////////////////////

		/*.................................................................*/
		public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
					/* initialize extended state variable */
					trace("Philosopher.INIT " + QF);
					QF.subscribe(EAT, this);
					return s_thinking; // philospher starts in thinking mode
			}
			return s_root;

		}
		public function s_thinking(e : CogEvent):Function {
			switch(e.sig){
				
				case SIG_ENTRY:
				
					callbackIn(THINK_TIME_MS);
					return null;
					
				case SIG_CALLBACK:
				
					requestTran(s_hungry);
					return null;

			}
			return s_root;
		}
		public function s_hungry(e : CogEvent):Function {
			trace(hsmName + ".s_hungry " + e.sig.name);
			switch(e.sig){
				
				case SIG_ENTRY:
					pe = new TableEvent(HUNGRY);
					pe.philID = id;
					QF.publish(pe);
				   return null;
				case EAT:
				    var te:TableEvent  = TableEvent(e);
					if(te.philID == id){
						requestTran(s_eating);
					}
					return null;
			}
			return s_root;
		}

		public function s_eating(e : CogEvent):Function {
			switch(e.sig){
				
				case SIG_ENTRY:
				   trace("EATING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					callbackIn(EAT_TIME_MS);
					return null;
					
				case SIG_CALLBACK:
				trace("FULL !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					requestTran(s_thinking);
					return null;
					
				case SIG_EXIT:
				
					pe = new TableEvent(DONE);
					pe.philID = id;
					QF.publish(pe);
					return null;
			}
			return s_root;
		}

	}
	
}
