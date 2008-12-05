package com.troyworks.core.persistance.syncher {
	import com.troyworks.data.bit.BitFlag; 

	public class SynchState extends Object
	{
		// since flash only has 32 bit numbers (nothing less, nothing really bigger) might as well use
		// all the flags in one
		//the Change Update Delete Flag is a 32 bit littleendian number with the ranges represnting what's changed
		public var cud : Number;
		public static var EXISTS_MASK : Number = BitFlag.create (1, 2);
		public static var DOESNT_EXIST : Number = 0; //00
		public static var EXISTS : Number = BitFlag.create (1,2); //11
		public static var BEING_CREATED : Number = BitFlag.create (2); //01
		public static var BEING_DELETED : Number = BitFlag.create (1); //10
		/////////////////
		//used to determine whether not this should be checked for changes,
		// the higher bits being used to determine what scope
		// has changed
		// hasn't changed
		//
		public static var WHOLE_MASK : Number = BitFlag.create (3, 4);
		public static var WHOLE_MASK_NOCHANGE = EditedState.NO_CHANGE << 2;
		public static var WHOLE_MASK_UPDATED = EditedState.UPDATED << 2;
		////////LEVEL 2//////////////////////////////////
		//whether primative members have changed
		public static var SELF_MASK : Number = BitFlag.create (1, 2, 3, 4) <<4;
		public static var SELF_MASK_NOCHANGE = EditedState.NO_CHANGE << 4;
		public static var SELF_MASK_UPDATED = EditedState.UPDATED << 4;
		public static var SELF_MASK_CREATED = EditedState.CREATED << 4;
		public static var SELF_MASK_DELETED = EditedState.DELETED << 4;
		///////LEVEL 3 /////////////////////////////////////
		//wheter object references to children/outgoing have changed
		public static var CHILD_MASK : Number = BitFlag.create (9, 10, 11, 12);
		public static var CHILD_MASK_NOCHANGE = EditedState.NO_CHANGE << 8;
		public static var CHILD_MASK_UPDATED = EditedState.UPDATED << 8;
		public static var CHILD_MASK_CREATED = EditedState.CREATED << 8;
		public static var CHILD_MASK_DELETED = EditedState.DELETED << 8;
		//whether or not references to parents (incoming) have changed
		public static var PARENT_MASK : Number = BitFlag.create (13, 14, 15, 16);
		public static var PARENT_MASK_NOCHANGE = EditedState.NO_CHANGE << 12;
		public static var PARENT_MASK_UPDATED = EditedState.UPDATED << 12;
		public static var PARENT_MASK_CREATED = EditedState.CREATED << 12;
		public static var PARENT_MASK_DELETED = EditedState.DELETED << 12;
		/////////LEVEL 4 synch ///////////////////////////////////////
		//these are extended synchronization information
		public var version : Number;
		public var fileSize : Number;
		public var hashcode : Number;
		public var creationDate : Date;
		public var lastModifiedDate : Date;
		public var lastAccessedDate : Date;
		public function SynchState ()
		{
			this.init();
		}
		public function init() : void {
			this.cud = 0;
			trace("testq " +BitFlag.toBinary(SELF_MASK) );
		}
		///////////////////////////////////////////////////////////
		//returns true if exists, being created or being deleted
		public function get exists (){
			return (this.cud & EXISTS_MASK > DOESNT_EXIST);
		}
		public function set exists (doesExist:Boolean){
			if(doesExist){
				this.cud = BitFlag.setBitsAtTo(this.cud, EXISTS, EXISTS_MASK);
			}else{
				this.cud = BitFlag.setBitsAtTo(this.cud, DOESNT_EXIST, EXISTS_MASK);
			}
		//	trace("setting exists" + doesExist +"\r"  + BitFlag.toBinary(this.cud));
		}
	
		public function get hasChanged (){
		//	trace ("before changes" + BitFlag.toBinary (this.cud));
			var tmp = BitFlag.flipBitsOFF(this.cud, ~WHOLE_MASK);
		//	trace ("filtered      " +  BitFlag.toBinary(tmp, WHOLE_MASK));
		//	trace ("interested in " + BitFlag.toBinary (WHOLE_MASK, WHOLE_MASK));
		//	trace ("equals        " + BitFlag.toBinary (WHOLE_MASK_UPDATED, WHOLE_MASK));
			var res = (tmp== WHOLE_MASK_UPDATED);
		//	trace(BitFlag.toBinary (res));
			return res;
		}
		//These are responsible for mapping into the bit flags (space) and out in reliable fashion
		public function setSelfChanges (changes : Number) : void {
			//trace("setSelfChanges " + EditedState.toString(changes));
			var mods = changes << 4;
			mods |=  SynchState.WHOLE_MASK_UPDATED;
			var masks = WHOLE_MASK | SELF_MASK;
			this.cud = BitFlag.setBitsAtTo(this.cud, mods, masks);
			//trace("after s "  + BitFlag.toBinary(this.cud));
		}
		public function getSelfChanges () : Number
		{
			//trace("getSelfChanges");
			var tmp = this.cud & SELF_MASK;
			//trace(BitFlag.toBinary(this.cud, SELF_MASK));
			//trace(BitFlag.toBinary(tmp, SELF_MASK));
			tmp >>=4;
			//trace(BitFlag.toBinary(tmp));
		//	trace("getSelfChanges " + EditedState.toString(tmp));
			return tmp;
		}
		public function setChild () : void {
		}
		public function setParent () : void {
		}
	}
	
}