package com.troyworks.datastructures.skiplist { 
	import com.troyworks.datastructures.skiplist.simple.SkipListElement;
	// implement a node in the skip list
	public class SkipNode {
	   // protected int        nodeHeight;
	    protected var        nodeHeight:Number;
	    
	//    protected int        key;
	    protected var        key:Number;
	//    protected com.troyworks.datastructures.skiplist.SkipNode[] fwdNodes;
	    protected var fwdNodes:Array;
	    
	//    protected boolean[]  visited;
	    protected var  visited:Array;
	    
	    public static var MaxNodeValue:Number = 65536;
	    public static var MinNodeValue:Number = 0;
	    
	      //  friend class SkipList;
	    public function SkipNode(){
	    	//route based on number of arguments
			if(arguments.length == 1){
				 this.initWithNumberOfNodes.apply(this, arguments);	
			}else if (arguments.length == 2){
				 this.initWithProbability.apply(this, arguments);	
			}
	    }
	    public function set2SkipNode(k:Number, h:Number) :void{
	        nodeHeight = h;
	        key        = k;
	        fwdNodes   = new Array(h+1);
	        visited    = new Array(h+1);
	        for (var x:Number = 1; x <= nodeHeight; x++) {
	          fwdNodes[x] = null;
	          visited[x]  = false;
	        }
	    }
	        
	    public function setSkipNode(h:Number):void {
	        nodeHeight = h;
	        key        = MinNodeValue - 1; // -1 means not populated
	        fwdNodes   = new Array(h+1);
	        visited    = new Array(h+1);
	        for (var x:Number = 1; x <= nodeHeight; x++) {
	          fwdNodes[x] = null;
	          visited[x]  = false;
	        }
	    }    
		public function initWithProbability( fProbability:Number, intMaxLevel:Number):void
		{
		//	trace("init with probability");
		   this.myProbability = fProbability;
		   this.myMaxLevel = intMaxLevel;
		   this.myLevel = 0;  // level of empty list
		
		   // generate the header of the list:
		   this.myHeader = new SkipListElement(this.myMaxLevel, 0, null);
		
		   // append "NIL" element to header:
		   var nilElement:SkipListElement =	new SkipListElement(this.myMaxLevel, NIL_KEY, null);
		   for (var i:Number=0; i<=myMaxLevel; i++) {
			  this.myHeader.forward[i] = nilElement;
		   }
		}
		//The constructor presented makes it necessary to know the exact influence of the two parameters, probability and maximum level. If we choose the wrong parameters, we might construct a badly performing skip list. Since we cannot expect every programmer to know detailed skip-list parameters, we provide a second, easier-to-use constructor that does the job in most cases by calling the first constructor with good arguments. The only thing a programmer has to know at construction time is the estimated number of nodes:
	
	    // 0.25 is a good probability finalstatic
	    public static var GOOD_PROB:Number = 0.25;
	
		protected var myProbability : Number;
	
		protected var myMaxLevel : Number;
	
		protected var myLevel : Number;
	
		protected var myHeader : SkipListElement;
	
		protected var NIL_KEY : Number;
	
		protected var SkipList : Object;
	
		public function initWithNumberOfNodes(lngMaxNodes:Number):void {
			//trace("init with number of nodes");
			 // see Pugh for math. background
			 this.initWithProbability(GOOD_PROB, Math.round(Math.ceil( Math.log(lngMaxNodes)/ Math.log(1/SkipNode.GOOD_PROB))-1));
		}
		/////////////////////////////////////////////
	    public function getKey():Number {
	        return key;
	    }
	    
	    public function getHgt():Number {
	        return nodeHeight;
	    }
	    
	    public function setFwdNode(i:Number, x:SkipNode):void {
	        fwdNodes[i] = x;
	    }
	    
	    public function getFwdNode(i:Number):SkipNode {
	        return SkipNode(fwdNodes[i]);
	    }
	    
	    public function setVisited(i:Number, b:Boolean):void {
	        visited[i] = b;
	    }
	    
	    public function  getVisited(i:Number) :Boolean{
	        return visited[i];
	    }
	    
	    public function clearVisited():void {
	        for(var  i:Number=0;i<nodeHeight+1;i++) {
	            visited[i] = false;
	        }
	    }
	}
	
}