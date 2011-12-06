package com.troyworks.data.graph {
	import com.troyworks.core.cogs.CogEvent;	
	import com.troyworks.core.cogs.Hsm; 
	import com.troyworks.data.MultiEntryDictionary;

	
	public class MicroNode extends Hsm
	{
		public var _inLinks : MultiEntryDictionary;
		public var _outLinks : MultiEntryDictionary;
		//	public var linkIdx:Object;
		public var links : Array;
		public var data : Object;
		public var core : MicroCore;
		public var parent : MicroNode;
		public var nType : String;
		private var _id : int = -1;
		public var name : String;
		public var depth : Number;
		//-1 is off, low number equals low priority, high number equals high priority.
		//the level of this or greater makes it to trace output. e.g. 1 traces everything, 9 only high priority
		public static var debugLevel : Number = 1;
		public function MicroNode (id : Number, name : String, nType : String)
		{
			super("s_initial", "MicroNode", false);
			this.initnode (id, name, nType);
		}
		/********************************************************
		* Init is responsible for making sure all data structures
		* are created before actively using the state.
		* typcially called by the constructor or reinitialization
		* during recycling
		****************************************************** **/
		public function initnode (id : Number, name : String, nType : String):void
		{
			this.initBlank ();
			this.id = (id == -1)?MicroCore.IDGen.getNextID():id;
			this.name = name;
		}
		public function initBlank ():void
		{
			//this.core = core;
			this._inLinks = new MultiEntryDictionary ();
			this._outLinks = new MultiEntryDictionary ();
			//	this.linkIdx = new Object();
			this.links = new Array ();
			this.data = new Object ();
			this.nType = (nType == null) ?"_" : nType;
			this.depth = 0;
		}
		public function get id():int{
			return _id;
		}
		public function set id(newId:int):void{
			_id= newId;
			MicroCore.IDX[_id]= this;
		}
		
		public function addLink (incoming : Boolean, link : MicroLink) : void
		{
			if (incoming)
			{
				this._inLinks.addItem (link.nType, link);
			} else
			{
				this._outLinks.addItem (link.nType, link);
			}
			//this.linkIdx[link.na
	
		}
		public function addOutgoingLink (link : MicroLink) : void
		{
			this._outLinks.addItem (link.nType, link);
		}
		public function addIncomingLink (link : MicroLink) : void
		{
			this._inLinks.addItem (link.nType, link);
		}
		public function removeLink (incoming : Boolean, link : MicroLink) : void
		{
			this._inLinks.removeItem (link.nType, link);
		}
		public function getLink (incoming : Boolean, targetNode : MicroNode, lType : String) : MicroLink
		{
			//trace("getLink incoming: "+ incoming + " type:" + lType + " to " + targetNode.name );
			var _array:Array;
			var i:int;
			var l : MicroLink;
			if (incoming)
			{
				_array = this._inLinks.getAllItems (lType);
				 i = _array.length;
				//trace("found " + i + " inlinks");
				while (i --)
				{
					l  = MicroLink (_array [i]);
					//trace("need "+ this.name + "<- " + targetNode.name + "  comparing: in: " + l._toNode.name + " out: " + l._fromNode.name );
					if (l._toNode == targetNode)
					{
						//trace("found target Node");
						return l;
					}
				}
			} else
			{
				 _array = this._outLinks.getAllItems (lType);
				 i = _array.length;
				//trace("found " + i + " outlinks");
				while (i --)
				{
					 l  = MicroLink (_array [i]);
					//trace("need "+ this.name + "-> " + targetNode.name + "  comparing: in: " + l._toNode.name + " out: " + l._fromNode.name );
					if (l._toNode == targetNode)
					{
						//trace("found target Node");
						return l;
					}
				}
			}
			return null;
		}
		public function getOutgoingLinks (lType : String, res : Array, includeParent:Boolean = true) : Array
		{
			//trace("Node.getOutgoingLinks ");
			var topLevel:Boolean = false;
			if (res == null)
			{
				res = new Array ();
				topLevel = true;
			}
			if(this.parent && includeParent){
				this.parent.getOutgoingLinks (lType, res);
			}
			var l_array : Array = this._outLinks.getAllItems (lType);
			var i : Number = (l_array)?l_array.length:0;
			//trace(this.name + " found " + i + " local links " );
			while (i --)
			{
				res.push (l_array [i]);
			}
			if (topLevel)
			{
				var j : Number = res.length;
				while (j --)
				{
					var lnk : MicroLink = MicroLink (res [j]);
					if ( ! (lnk._toNode === this))
					{
						//trace("\t"+ res[j].name);
	
					}
				}
			}
			return res;
		}
		public function getOutLinksReadOnly(lType : String = null) : Array{
			return this._outLinks.getAllItems (lType);
		}
		public function getInLinksReadOnly(lType : String = null) : Array{
			return this._inLinks.getAllItems (lType);
		}
		public function traceMe (str : String, lvl : Number =NaN) : void
		{
			if (MicroNode.debugLevel == - 1)
			{
				return;
			} else if (isNaN(lvl) || lvl >= MicroNode.debugLevel){
				trace (str);
			}
		}
		public function setAsRootNode () : void 
		{
			if(this.core == null){
				throw new Error("MicroNode.setAsRootNode Core cannoto be null!");
			}
			this.core.addAsRootNode (this);//, val);
		}
		/////////////////////////////////////////////////////
		override public function toString () : String
		{
			return " node " + this.name + " id: " + this.id;
		}
		////////////////////////////////////////////////////
	
		/*..PSEUDOSTATE...............................................................*/
		public function s_initial(e : CogEvent) : Function
		{
			//trace("************************* s_initial " + util.Trace.me(e)+" ******************");
			//onFunctionEnter ("s_initial-", e, []);
			if(e.sig != SIG_TRACE){
				return s_active;
			}
			return s_root;
		}
		/*.................................................................*/
		public function s_active(e : CogEvent) : Function
		{
			//onFunctionEnter ("s_active-", e, []);
			/*switch (e.sig)
			{
				case SIG_ENTRY :
				{
					dispState("calc");
					return null;
				}
				case Q_INIT_SIG :
				{
					graphics.clear();
					Q_INIT(s__ready);
					return null;
				}
				case SIG_C:
				case SIG_CE:{
					graphics.clear();
					tranc);
					return null;
				}
				case Q_TERMINATE_SIG:
				{
					trtrtrtran					return null;
				}
			}*/
			return s_root;
		}
		/*..PSEUDOSTATE...............................................................*/
		public function s_final(e : CogEvent) : Function
		{
//			this.onFunctionEnter ("s_final-", e, []);
			switch (e.sig)
			{
				case SIG_ENTRY :
				{ 
					//return s_root;
				}
			}
			return s_root;
		}
		
	}
	
	
}