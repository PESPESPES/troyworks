/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.activeframe.events {
	import com.troyworks.cogs.CogEvent;
	import com.troyworks.cogs.CogSignal;

	public class CRUDEvents extends CogEvent{
		//-rwxr--r-- username groupname 546 Dec 10 13:10 filename
		//[0]-single or container object
		////////USER //////////
		// [1] - read
		// [2] - write  (create, update, delete)
		// [3] - execute
		////////GROUP //////////
		// [4] - read
		// [5] - write  (create, update, delete)
		// [6] - execute
		////////WORLD//////////
		// [7] - read
		// [8] - write  (create, update, delete)
		// [9] - execute
		// [10] state
		// [11] last modification date.

		///////// TYPE OF COMMANDS /////////////
		public static  const CREATE:Object;
		public static  const READ : Object;
		public static  const UPDATE : Object;
		public static  const DELETE : Object;
	
		///////// EVENT CYCLE /////////////////
		public static  const CREATING_START:Object;
		public static  const CREATING_PROGRESS:Object;
		public static  const CREATED:Object;
		
		public static  const READING_START:Object;
		public static  const READING_PROGRESS:Object;
		public static  const READ:Object;
		
		public static  const UPDATING_START:Object;
		public static  const UPDATING_PROGRESS:Object;
		public static  const UPDATED:Object;
		
		public static  const DELETING_START : Object;
		public static  const DELETING_PROGRESS : Object;
		public static  const DELETED : Object;
		
		public function CRUDEvents(sig:CogSignal){
			super(sig.name, sig);
		}
		override public function toString():String{
			return "CRUDEvents " + sig.name;
		}
	}
	
}
