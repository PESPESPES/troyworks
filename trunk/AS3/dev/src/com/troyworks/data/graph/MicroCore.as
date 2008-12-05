package com.troyworks.data.graph {
	import com.troyworks.util.Trace; 
	import com.troyworks.data.MultiEntryDictionary;
import flash.utils.getDefinitionByName;	//import com.troyworks.data.skiplist. *;
	public class MicroCore extends com.troyworks.data.graph.MicroNode
	{
		public static var className : String = "com.troyworks.data.graph.MicroCore";
		///public var classType
		//typed nodes and links. being used as a dictionary.
		//which allows quick access to getting a particular type of node, e.g. red, left, "associated"
		public var _nodes : MultiEntryDictionary;
		public var _links : MultiEntryDictionary;
		//list of all nodes and links regardless of type
		public var nodes : Array;
		public var links : Array;
		public var nIdx : Object;
		public var lIdx : Object;
		public var rootNodes : Array;
		//holder for the set interval
		protected var si : Number;
		public var depth : Number;
		public function MicroCore (id : Number, name : String, nType : String)
		{
			super (id, name, nType);
			//trace("new MicroCore");
			this.depth = 0;
			this.initcore ();
		};
		public function initcore () : void
		{
			//trace("initing MicroCore core");
			//typed nodes and links for selective traversal
			this._nodes = new MultiEntryDictionary ();
			this._links = new MultiEntryDictionary ();
			//all nodes and links for traversing all
			this.nodes = new Array ();
			this.links = new Array ();
			this.nIdx = new Object ();
			this.lIdx = new Object ();
			this.rootNodes = new Array ();
			super.initBlank ();
		};
		/////////////////////////////////////
		// returns a top level graph to contain the
		// child graphs in
		public static function createRoot () : MicroCore
		{
			var c:MicroCore = new MicroCore ( - 1, "root", "root");
			return c;
		}
		//	public function graphics.clear():void{
		//		this.init();
		//	};
		public function createNode (name : String, className : Object, oType : String) : MicroNode
		{
			var n : MicroNode = null;
			if (className != null)
			{
				var f:Object = className;
				//eval(className);
				////trace( f + " n type of "   + typeof (f) + " " + (typeof (f) == "function"));
				if (typeof (f) == "function")
				{
					//	//trace(" n creating dynamic function ");
					trace("$1");
					n = new f (this.nodes.length, name, oType);
				} else if (f is MicroNode)
				{
					trace("$2");
					n = MicroNode (className);
				} else if (typeof (className) == "string")
				{
					trace("$3");
					f = getDefinitionByName(String(className));
					n = new f(this.nodes.length, name, oType);
				}
				else
				{
					trace("$4");
					n = new MicroNode (this.nodes.length, name, oType);
				};
			} else
			{
				n = new MicroNode (this.nodes.length, name, oType);
			};
			n.core = this;
			n.parent = this;
			n.depth = this.depth + 1;
			if (this.nIdx [n.name] != null)
			{
				var str:String = new String ("*********************************************************************************\r");
				str += ("MicroCore.createNode ****WARNING OVERWRITING, Node " + name + " ALREADY EXISTS\r" );
				str += ("*********************************************************************************");
				traceMe (str);
			}
			this.nIdx [n.name] = n;
			this.nodes.push (n);
			if (oType == null)
			{
				oType = "_";
			};
			this._nodes.addItem (oType, n);
			return n;
		};
		public function createHeirarchicalNode (name : String, className : Object, oType : String) : MicroCore
		{
			var n : MicroCore = null;
			if (className != null)
			{
				var f = className;
				// _global[className];//eval(className);
				//	//trace( f + " " + name + " h type of "   + typeof (f) + " " + (typeof (f) == "function") + " instance of MicroCore?: " + (f is MicroCore) + " instance of Object?: " + (f is Object));
				if (f is MicroCore)
				{
					//	  //trace(" h casting instance ");
					n = MicroCore (className);
					n.id = this.nodes.length;
					if ( ! n)
					{
						//trace ("warning casting " + name + " failed!");
					};
				} else if (typeof (f) == "function")
				{
					//	//trace(" h creating dynamic function ");
					n = new f (this.nodes.length, name, oType);
	
				} else if (typeof (className) == "string"){
					var cl = getDefinitionByName(String(className));
					n = new cl (String(className))();
				} else
				{
					n = new MicroCore (this.nodes.length, name, oType);
				};
			} else
			{
				n = new MicroCore (this.nodes.length, name, oType);
			};
			n.core = this;
			n.parent = this;
			n.depth = this.depth + 1;
			this.nIdx [n.name] = n;
			this.nodes.push (n);
			if (oType == null)
			{
				oType = "_";
			};
			this._nodes.addItem (oType, n);
			return n;
		};
		public function createHeirarchicalRootNode (name : String, className : Object, oType : String) : MicroCore
		{
			var root : MicroCore = this.createHeirarchicalNode (name, className, oType);
			root.setAsRootNode ();
			return root;
		};
		public function addNode (n : MicroNode) : MicroNode
		{
			//trace ("add Node " + n);
			n.id = this.nodes.length;
			n.core = this;
			n.parent = this;
			n.depth = this.depth + 1;
			this.nodes.push (n);
			this.nIdx [n.name] = n;
			if (n.nType == null)
			{
				n.nType = "_";
			};
			this._nodes.addItem (n.nType, n);
			return n;
		};
		public function getNodes (nType : String) : Array
		{
			return (nType != null) ? (this._nodes.getAllItems (nType)) : this.nodes;
		};
		public function getNodeByName (name : String) : MicroNode
		{
			//trace (" getNodeByName name: " + name );
			var o = this.nIdx [name];
			if (o != null)
			{
				//trace (" o != null");
				return MicroNode (o);
			} else
			{
				//trace (" o == null");
				return null;
			};
		};
		public function getLinks (nType : String) : Array
		{
			return (nType != null) ? (this._links.getAllItems (nType)) : this.links;
		};
		//getnode, getNodes, removeNode, removeNodes, etc
		//e..g rG.createLink("A>B", null, null, nA, nB, 1);
		public function createLink (name : String, className : Object, oType : String,
		fromNode : MicroNode, toNode : MicroNode, weight : Number) : MicroLink
		{
			//trace("creating LInk " + name + " from " + fromNode + " to " + toNode);
			var l = null;
			if (className != null)
			{
				var f = className;
				//:Function = eval(className);
				if (typeof (f) == "function")
				{
					l = new f (this.links.length, name, oType, weight);
				} else if (f is MicroLink)
				{
					l = MicroLink (className);
					l.id = this.links.length;
				} else
				{
					l = new MicroLink (this.links.length, name, oType, weight);
				};
			} else
			{
				l	= new MicroLink (this.links.length, name, oType, weight);
			};
			l.core = this;
			this.links.push (l);
			if (oType == null)
			{
				oType = "_";
			};
			this._links.addItem (oType, l);
			if (fromNode != null && toNode != null)
			{
				this.linkNodes (fromNode, toNode, l);
			};
			return l;
		};
		/////////////////Linking Section///////////////////////////////////////////
		public function linkNodes (fromNode : MicroNode, toNode : MicroNode,
		link : MicroLink) : void
		{
			//bind the fromNode and the outgoing link
			fromNode.addLink (false, link);
			link.setNode (true, fromNode);
			link.setNode (false, toNode);
			toNode.addLink (true, link);
		};
		public function unlinkNodes (fromNode : MicroNode, toNode : MicroNode,
		link : MicroLink) : void
		{
			//bind the fromNode and the outgoing link
			//fromNode.addLink(false, link);
			//link.setNode(true, fromNode);
			//link.setNode(false, toNode);
			//toNode.addLink(true, link);
		};
		public function addAsRootNode (rNode : MicroNode) : void
		{
			rootNodes.push (rNode);
		};
		public function removeRootNode (rNode : MicroNode) : void
		{
			rootNodes.push (rNode);
		};
		public function removeAllRootNodes () : void
		{
			this.rootNodes = new Array ();
		};
		public function removeAllChildren () : void
		{
			//this.removeAllRootNodes;
			//this.
			this.initcore ();
		};
		/////////uses the depth and parent aspects to find a path between the to and from node
		public function findHeirachicalPath (fromNode : MicroNode, toNode : MicroNode) : Object
		{
			var sA : MicroNode = fromNode;
			var sB : MicroNode = toNode;
			var dA : Number = sA.depth;
			var dB : Number = sB.depth;
			var res : Object = new Object ();
			var exitList : Array = new Array ();
			var tranList : Array = new Array ();
			var enterList : Array = new Array ();
			var findParent : Boolean = true;
			var dir = null;
			//trace ("From " + sA.name + " @ " + dA + " -> " + sB.name + " @ " + dB);
			if (dA > dB)
			{
				var i = dA - dB;
				//trace ("doing down " + i + " sA");
				dir = i;
				while (i --)
				{
					exitList.push (sA);
					sA = sA.parent;
					dA = sA.depth;
				};
			} else if (dA < dB)
			{
				var i = dB - dA;
				//trace ("going up " + i + " sB");
				dir = i;
				if (sA === sB.parent)
				{
					//trace("transition internally to child");
					findParent = false;
				} //else transition out of this into to sibling's child
				while (i --)
				{
					enterList.unshift (sB);
					sB = sB.parent;
					dB = sB.depth;
				};
			} else if (dA == dB)
			{
				//trace ("at same level");
				if (sA === sB)
				{
					//trace ("self transition");
					exitList.push (sA);
					enterList.unshift (sB);
					//	//trace (" exiting \n\t" + exitList + "\n crossing \n\t" + tranList + "\n entering \n\t" + enterList);
					findParent = false;
				}
				dir = 0;
			};
			// /////now find common ancestor
			//
			if (findParent)
			{
				//trace("finding LCA: A:"+sA.name+" B:"+sB.name);
				if (sA.parent === sB.parent)
				{
					//trace ("LCA.same level1: got common parent: " + sA.parent.name);
					exitList.push (sA);
					enterList.unshift (sB);
					////trace (" exiting \n\t" + exitList + "\n crossing \n\t" + tranList + "\n entering \n\t" + enterList);
				} else
				{
					exitList.push (sA);
					enterList.unshift (sB);
					while (true)
					{
						sA = sA.parent;
						sB = sB.parent;
						exitList.push (sA);
						enterList.unshift (sB);
						if (sA.parent == null)
						{
							//trace ("LCA.reached top, couldn't find parent");
							break;
						} else if (sA.parent === sB.parent)
						{
							//trace ("LCA.same level2: got common parent: " + sA.parent.name);
							break;
						};
					};
				};
			}
			//trace (" exiting \n\t" + exitList + "\n crossing \n\t" + tranList + "\n entering \n\t" + enterList);
			res.exitList = exitList;
			res.tranList = tranList;
			res.enterList = enterList;
			res.direction = dir;
			return res;
		};
		// G
		// s = start node
		// w = weighted map
		//based off of http://www.boost.org/libs/graph/doc/dijkstra_shortest_paths.html
		public function dijkstra (s : MicroNode, w : Object):void
		{
			//distances map -each items distance from the point s on the graph g.
			var d : Object = new Object ();
			//predecessor map (for after the thing completes to be able to navigate the shortest path)
			var p : Object = new Object ();
			//not discovered yet
			var WHITE:Number = 0;
			//in prority queue
			var GRAY:Number = 1;
			//solved
			var BLACK:Number = 2;
			var _color : Object = new Object ();
			//sorted by priority/distance
			var q : Array = new Array ();
			//start run
			/////initialize traversal
			var i:String = null;
			for (i in this.nodes)
			{
				var node = this.nodes [i];
				var id = node.id;
				//set distance
				d [id] = Number.POSITIVE_INFINITY;
				p [id] = node;
				_color [id] = WHITE;
			}
			//// set the start node
			_color [s.id] = GRAY;
			d [s.id] = 0;
			//insert the start node in the sorted priority queue
			q.push (s);
			//q.sort ();
			/////iterate over priorities
			while (q.length > 0)
			{
				trace ("going past children" + q.length);
				// get current node
				var u = MicroNode (q.pop ());
				trace ("starting with node " + u);
				//get adjacent/children and look for minimum length;
				var links : Array = u.getOutLinksReadOnly ();
				trace ("found children " + links);
				//		var S = S U{u}
				//for each ver
				var j = null;
				for (j in links)
				{
					var lnk = links [j];
					var v = lnk.getToNode ();
					//	trace ("adjacent " + lnk + " " + lnk.weight);
					//if weight of link + current distance of from node less than distance from to node
					if (lnk.weight + d [u.id] < d [v.id])
					{
						d [v.id] = lnk.weight + d [u.id];
						p [v.id] = u;
						var c = _color [v.id];
						switch (c)
						{
							case WHITE :
							{
								_color [v.id] = GRAY;
								q.push (v);
							}
							break;
							case GRAY :
							{
								//	q.sort ();
	
							}
							break;
						}
					} else
					{
						//not relaxed
	
					}
				}
				_color [u.id] = BLACK;
			}
			trace (Trace.me (d, "distances from " + s, true));
			var id = 5;
			while (id != s.id)
			{
				trace (id + " pred " + p [id]);
				id = p [id].id;
			}
		}
		/////////////////////////////////////////////////////
		public function toString () : String
		{
			var res = new Array ();
			res.push ("MicroCore." + this.name + ".toString()");
			res.push ("Nodes:");
			for (var ni in this.nodes)
			{
				res.push ("\t " + this.nodes [ni]);
			}
			res.push ("Links:");
			for (var li in this.links)
			{
				res.push ("\t " + this.links [li]);
			}
			return res.join ("\r");
		}
	}
}