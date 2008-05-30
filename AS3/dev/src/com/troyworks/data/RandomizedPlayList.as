package com.troyworks.data { 
	//import com.troyworks.events.TEventDispatcher;
	///////////////////////////////////////////
	// this generates a unique playlist that makes sure
	//every clip is viewed once in random order before shuffling again
	public class RandomizedPlayList extends ArrayX
	{
	//	public static var SEQUENTIAL:Number = 1;
		
		public static var SEQUENTIAL:Number = 1;
		public static var RANDOMIZED:Number = 2;
		public var playlistMode:Number = SEQUENTIAL;
		public static var STOP:Number =-1;
		public static var REPEAT:Number =0;
	//	public static var :Number =0;
		
		public var atEnd:Number;
		//necessary for the complier
	//	public static var evtd : Function = TEventDispatcher;
		public var addEventListener : Function;
		public var dispatchEvent : Function;
		public var removeEventListener : Function;
		//by index
		public var curIdx : Number ;
		public var lastIdx : Number ;
		public var nextIdx : Number ;
		//by item/ref
		public var curItem : Object;
		public var lastItem : Object;
		public var nextItem : Object ;
		public var hasStarted : Boolean;
		//
		public static var EVT_PLAYLIST_CHANGED : String = "EVT_PLAYLIST_CHANGED";
		public static var EVT_CURRENT_ITEM_CHANGED : String = "EVT_CURRENT_ITEM_CHANGED";
		public static var EVT_AT_LAST_IN_PLAYLIST : String = "EVT_AT_LAST_IN_PLAYLIST";
		public static var EVT_AT_FIRST_IN_PLAYLIST : String = "EVT_AT_FIRST_IN_PLAYLIST";
		public function RandomizedPlayList ()
		{
			super ();
	//		TEventDispatcher.initialize(this);
		}
		public function init () : void
		{
			this.curIdx = - 1;
			this.lastIdx = - 1;
			this.nextIdx = - 1;
			//by item
			this.curItem = null;
			this.lastItem = null;
			this.nextItem = null;
			this.hasStarted = false;
		}
		// a utility method for shuffling the playlist, and avoiding
		// repeat showings if possibe.
		public function shuffleClips (firstClip : Object=null, skipEvent : Boolean= false) : void
		{
			trace ("BBBBBBBBBBBBBBBBBBBshuffleClipsBBBBBBBBBBBBBBBBBBBBBBBBBB");
			trace ("building playlist");
			//		trace ("+current " + this.toString (true));
			var tmp:Object = this.curItem;
			this.init ();
			if (this.length > 1)
			{
				trace ("**shuffling**");
				super.shuffle ();
				while (tmp != null  && this [0] == tmp)
				{
					trace ("***just saw that clip..Reshuffling**");
					super.shuffle ();
				}
			//	this.curIdx = 0;
			//	this.curItem = this[this.curIdx];
			}
			if (firstClip != null)
			{
				trace ("000000000000000000000000000000000000000000000000000000");
				trace ("000000000000000000000000000000000000000000000000000000");
				trace ("00000000000shuffleClips firstClip overridden 0000000000000000000000000000000000000000000");
				trace ("000000000000000000000000000000000000000000000000000000");
				trace ("000000000000000000000000000000000000000000000000000000");
				trace ("000000000000000000000000000000000000000000000000000000");
				var didx:Number = - 1;
				//search through all clips
				var len : Number = this.length;
				for (var i : Number = 0; i < len; i ++)
				{
					var c:Object = this [i];
					trace (i + " " + c);
					if (c === firstClip)
					{
						didx = i;
						break;
					}
				}
				if (didx > 0)
				{
					trace ("moving didx " + didx + " to front ");
					//move clip all the way to beginning.
					this.shiftTowardsStart (didx);
				} else
				{
					trace ("not moving firstclip");
				}
				if (skipEvent == false)
				{
					this.dispatchEvent (
					{
						type : RandomizedPlayList.EVT_PLAYLIST_CHANGED, target : this, curIdx : this.curIdx, curItem : this.curItem, lastIdx : this.lastIdx, lastItem : this.lastItem, nextItem : this.nextItem, nextIdx : this.nextIdx
					});
				}
				this.changeIndex (1, null, skipEvent);
				trace ("+after " + this.toString (true));
			}
		}
		public function changeIndex (inc : Number, absolute : Boolean = false, skipEvent : Boolean = false) : void
		{
			this.lastItem = this.curItem;
			this.lastIdx = this.curIdx;
			if (absolute == null || absolute == false)
			{
				this.curIdx += inc;
			} else
			{
				this.curIdx = inc;
			}
			var adj:Number =  (inc>=0)? 1: -1;
			trace("CHANGE INDEXA Cur " + this.curIdx + " Next " + this.nextIdx + " " + adj); 
			this.nextIdx = (this.curIdx + adj);
			trace("CHANGE INDEXB Cur " + this.curIdx + " Next " + this.nextIdx + " " + adj); 
			
			//////////Boundary Check ///////////////////////
			var atLast : Boolean = false;
			var atFirst : Boolean = false;
			if (this.curIdx == 0)
			{
				trace ("*** at first clip***");
				if (skipEvent == null || skipEvent == false)
				{
					this.dispatchEvent (
					{
						type : RandomizedPlayList.EVT_AT_FIRST_IN_PLAYLIST, target : this, curIdx : this.curIdx, curItem : this.curItem, lastIdx : this.lastIdx, lastItem : this.lastItem, nextItem : this.nextItem, nextIdx : this.nextIdx
					});
				}
				atFirst = true;
			}
			if (this.nextIdx == this.length)
			{
				trace ("*** at last clip***");
				if (skipEvent == null || skipEvent == false)
				{
					this.dispatchEvent (
					{
						type : RandomizedPlayList.EVT_AT_LAST_IN_PLAYLIST, target : this, curIdx : this.curIdx, curItem : this.curItem, lastIdx : this.lastIdx, lastItem : this.lastItem, nextItem : this.nextItem, nextIdx : this.nextIdx, atLast : atLast, atFirst : atFirst
					});
				}
				atLast = true;
			}
			this.curItem = this [this.curIdx];
			this.nextItem = this [this.nextIdx];
			if (skipEvent == null || skipEvent == false)
			{
				this.dispatchEvent (
				{
					type : RandomizedPlayList.EVT_CURRENT_ITEM_CHANGED, target : this, curIdx : this.curIdx, curItem : this.curItem, lastIdx : this.lastIdx, lastItem : this.lastItem, nextItem : this.nextItem, nextIdx : this.nextIdx, atLast : atLast, atFirst : atFirst
				});
			}
		}
		//searches through the data to find the given item and updates the current
		//index based on the position it's at
		public function setCurrentToObject (dataItem : Object) : void
		{
			var len : Number = this.length;
			for (var i : Number = 0; i < len; i ++)
			{
				var c = this [i];
				trace (i + " " + c);
			}
		}
		public function hasNext():Boolean{
			var res:Boolean = true;
			if(this.nextIdx >= this.length  || this.length == 0){
				res = false;
			//}else if(this.curIdx == this.nextIdx){
			//	res = false;
			}
			trace("RandomPlayList hasNext? " + res);
			return res;
		}
		public function hasPrevious():Boolean{
			return(this.nextIdx > -1);
		}
		public function getNext () : Object
		{
			trace ("PLAYLIST GET NEXT " + this.length);
			if (this.length > 0)
			{
				/////////HAS CLIPS///////////////////
				if (this.curIdx == - 1)
				{ //At Beginning
					trace("at Beginning");
					if( playlistMode == RANDOMIZED){
						this.shuffleClips ();
					//	trace("getNextNewList =" + this.toString(false));
						this.changeIndex (1);
						return this.curItem;
					}else{
						this.changeIndex (1);
						//	trace("getNextExisting =" + this.toString(false));
						return this.curItem;
					}
				} else if (this.curIdx + 1 < this.length )
				{
					trace("in middle");
					this.changeIndex (1);
					//	trace("getNextExisting =" + this.toString(false));
					return this.curItem;
				} else
				{
					trace("at end");
					//fire event that playlist finished
					if(playlistMode == RANDOMIZED){ 
						this.shuffleClips ();
						//	trace("getNextRefresh =" + this.toString(false));
						return this.curItem;
					}else{
						//this.changeIndex (1);
						return null;
					}
				}
			} else
			{
				////////HAS NO CLIPS /////////////////
				trace ("no items in playlist");
				return null;
			}
		};
		public function getPrevious () : Object
		{
			trace ("PLAYLIST GET PREVIOUS ");
			if (this.length > 0)
			{
				/////////HAS CLIPS///////////////////
				if (this.curIdx == - 1 && playlistMode == RANDOMIZED)
				{
					this.shuffleClips ();
					//	trace("getNextNewList =" + this.toString(false));
					return this.curItem;
				} else if (this.curIdx - 1 >= 0 )
				{
					this.changeIndex ( - 1);
					//	trace("getNextExisting =" + this.toString(false));
					return this.curItem;
				} else
				{
					if(playlistMode == RANDOMIZED){ 
						//fire event that playlist finished
						this.shuffleClips ();
						//	trace("getNextRefresh =" + this.toString(false));
						return this.curItem;
					}else{
						this.changeIndex ( - 1);
						return null;
					}
				}
			} else
			{
				////////HAS NO CLIPS /////////////////
				trace ("no items in playlist");
				return null;
			}
		};
		public function toString (contents : Boolean) : String
		{
			var res : String = "";
			if (contents)
			{
				for (var i = 0; i < this.length; i ++)
				{
					res += this [i].toString () + "\r";
				}
			}
			res += "last:[" + this.lastIdx + "] " + this.lastItem + " \r";
			res += "cur :[" + this.curIdx + "] " + this.curItem + " \r";
			res += "nxt :[" + this.nextIdx + "] " + this.nextItem + " ";
			return res;
		}
	}
	
}