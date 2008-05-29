/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.Tdining_philosophers {
	import com.troyworks.activeframe.QActive;
	import com.troyworks.activeframe.QEvent;
	import com.troyworks.activeframe.QSignal;
	import com.troyworks.Tdining_philosophers.DiningSignals;
	import com.troyworks.Tdining_philosophers.TableEvent;
	import com.troyworks.cogs.CogEvent;
		import com.troyworks.activeframe.QF;

	
	
	
	public class Table extends QActive{
		

		public static const DONE:QSignal = DiningSignals.DONE;
		public static const HUNGRY:QSignal = DiningSignals.HUNGRY;
		public static const EAT:QSignal = DiningSignals.EAT;
		
		private var NUMBER_OF_PHILOSOPHERS:int;
		
		private var forkInUseIdx:Array;
		private var isHundryIdx:Array;
		private var pe:TableEvent;
		
		
		public function Table(numberOfPhilosophers:int =3){
			super("s_initial", "table");
			NUMBER_OF_PHILOSOPHERS = numberOfPhilosophers;
		}
		public function getIdxLeftOf(philIdx:int):int{
			return (((philIdx)+1)% NUMBER_OF_PHILOSOPHERS);
		}
		public function getIdxRightOf(philIdx:int):int{
			return  ((philIdx) + (NUMBER_OF_PHILOSOPHERS-1))%NUMBER_OF_PHILOSOPHERS ;
		}

		///////////////// STATES /////////////////////

		/*.................................................................*/
		public function s_initial(e : CogEvent):Function {
			switch (e.sig) {
				case SIG_INIT :
				trace("s_initial.INIT");
					/* initialize extended state variable */
					QF.subscribe(HUNGRY, this);
					QF.subscribe(DONE, this);
					forkInUseIdx = new Array();
					isHundryIdx = new Array();
					
					for(var i:int = 0; i < NUMBER_OF_PHILOSOPHERS; i++){
					   forkInUseIdx[i] = false;
					   isHundryIdx[i] = false;
					}
					return s_serving;
			}
			return s_root;

		}
		/*.................................................................*/
		public function s_serving(e:CogEvent):Function{
			trace("s_serving."+ e.sig.name);
			var tblEvt:TableEvent;
			var n:int,m:int;
			if(e is TableEvent){
				tblEvt = TableEvent(e);
				n = tblEvt.philID;
				
				switch (e.sig) {
					case HUNGRY :	
						//	ASSERT
						trace("Table: Philosopher "+ n+ " is hungry");
						m = getIdxLeftOf(n);
						if(!forkInUseIdx[m]  && !forkInUseIdx[n] ){ //can 'n' eat?
						    // can eat
							trace("can eat");
							forkInUseIdx[m]  =  forkInUseIdx[n] = true;
							pe = new TableEvent(EAT);
							pe.philID = n;
							QF.publish(pe);
							trace(":):):):):):):):):):):):):):):):):):):):):):)");
							trace("Table: Philosopher "+ n + " is eating");
						}else{
							// has to wait
							trace(n + "has to wait ");
							isHundryIdx[n] = true;
							trace(this.toString());
						}
						return null;
						
					case DONE :
						trace("Table: Philosopher "+ n+ " is done/thinking");
						forkInUseIdx[getIdxLeftOf(n)]  =  forkInUseIdx[n] = false;
						m = getIdxRightOf(n);
						if(isHundryIdx[m] && !forkInUseIdx[m]){
						    forkInUseIdx[m] = forkInUseIdx[n] =  true;
							isHundryIdx[m] = false; // philosopher not hungry anymore
							pe = new TableEvent(EAT);
							pe.philID = m; //grant him permission to eat
							QF.publish(pe);
							trace(":):):):):):):):):):):):):):):):):):):):):):)");
							trace("Philosopher "+ n + " is eating");
						}
						m = getIdxLeftOf(n);
						n = getIdxLeftOf(m);
						if(isHundryIdx[m] && !forkInUseIdx[m]){
						    forkInUseIdx[m] = forkInUseIdx[n] =  true;
							isHundryIdx[m] = false; // philosopher not hungry anymore
							pe = new TableEvent(EAT);
							pe.philID = m; //grant him permission to eat
							QF.publish(pe);
							trace(":):):):):):):):):):):):):):):):):):):):):):)"); 
							trace("Philosopher "+ n + " is eating");
						}
						return null;
				}

			}


			return s_root;
		}
		override public function toString():String{
			var res:Array = new Array();
			res.push("TABLE====================================");
					for(var i:int = 0; i < NUMBER_OF_PHILOSOPHERS; i++){
					   res.push(" " + i +" isUsingFork? " + forkInUseIdx[i] + " isHungry?" + isHundryIdx[i]);
					}
					return res.join("\r");
		}
	}
}
