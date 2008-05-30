package com.troyworks.ui.tree { 
	//import it.sephiroth.iDragAndDropTree;
	import mx.core.UIComponent;
	import com.troyworks.events.TEventDispatcher;
	
	
	[Event("double_click")]
	[Event("drag_start")]
	[Event("drag_complete")]
	[Event("drag_fail")]
	[InspectableList("enabled","visible","dragRules","rowHeight")]
	
	
	/**
	 * Drag and Drop extension for Macromedia Tree component.
	 * It allows you to define different rules for dragging items and folder 
	 * into a tree component
	 * @author	alessandro crugnola
	 * @version	1.5.5
	 */
	/**
	 * @author Troy Gardner
	 */
	import flash.utils.getTimer;
	import flash.ui.Mouse;
	import flash.display.MovieClip;
	import flash.xml.XMLNode;
	public class DragAndDropTree extends UIComponent{
			// define component specific variables
		static public var symbolName:String   = "DragAndDropTree";
		static public var symbolOwner:Object  = DragAndDropTree;
		protected var className:String   = "DragAndDropTree";
		
		static public var componentVersion:String = "1.5";
		// define protected variables
		protected var label:MovieClip;
		protected var tree:mx.controls.Tree;
		protected var icon:MovieClip;
		protected var tree_listener:Object;
		protected var controller_mc:MovieClip;
		protected var boundingBox_mc:MovieClip;
		protected var tfList:Object;
		protected var __dropTarget:Array;
		protected var _iconFunction:Function;
		protected var __rowHeight:Number = 20;
		protected var __dropFunction:Function;
		protected var __dragFunction:Function;
		
		protected var TREEDEPTH:Number = 10;
		protected var CONTDEPTH:Number = 11;
		protected var ICONDEPTH:Number = 12;
		
		public var addEventListener:Function;
		public var removeEventListener:Function;
		public var dispatchEvent:Function;
		
		/** 
		* deny drag a folder.
		* Each of treednd constant can be used associated with multiple other constants
		* @usage <code>import it.sephiroth.DragAndDropTree
		* myDndTree.dragRules = DragAndDropTree.DENYDRAGFOLDER | DragAndDropTree.DENYDROPITEM
		* </code>
		*/
		static public var DENYDRAGFOLDER:Number      = 1;
		/** deny drag an item node */
		static public var DENYDRAGITEM:Number        = 2;
		/** deny drop into an item */
		static public var DENYDROPITEM:Number        = 4;
		/** everything is allowed */
		static public var DEFAULT:Number             = 0;
		/** deny drop through nodes, only into is allowed */
		static public var DENYDROPUPSIDEDOWN:Number  = 8;
		/** deny all */
		static public var DENYALL:Number             = DENYDRAGITEM | DENYDRAGFOLDER | DENYDROPITEM | DENYDROPUPSIDEDOWN;
		
		protected var __options:Number = DEFAULT;
		
		/**
		 * constructor
		 */
		/*function DragAndDropTree()
		{
		
		}*/
		
		/**
		* internal, set enabled on off
		* @param enabled
		*/
		protected function setEnabled(enabled:Boolean):void
		{
			super.setEnabled();
			tree.enabled = enabled;
		}	
		
		// ******************************************
		// Private methods
		// ******************************************
	
		/**
		 * override UIComponent init constructor
		 * @return	void
		 */
		protected function init():void
		{
			super.init();
			var width  = __width;
			var height = __height		;
			__options = DEFAULT;
			boundingBox_mc.visible = false;
			boundingBox_mc.width = boundingBox_mc.height = 0;
			// create the objects to be used in the component
			createClassObject(mx.controls.Tree, "tree", TREEDEPTH, {width : width, height : height});
			controller_mc = createEmptyObject("controller_mc", CONTDEPTH);
			// initialize the event object
			TEventDispatcher.initialize( this );
			initTreeListener();
			setEnabled(enabled);
			tree.rowHeight = __rowHeight;
		}
		
	
		/**
		 * 
		 * @param	void
		 * @return	void
		 */
		public function size(void) : void
		{
			super.size();
			tree.setSize( __width, __height, true );
		}
		
	
		/**
		 * 
		 * @param	void
		 * @return	void	
		 */
		public function draw(void):void{
			super.draw();
		}
		
		/**
		 * Initialize Tree listeners and Tree MovieClip controller
		 * @usage	
		 * @return	void	
		 */
		protected function initTreeListener():void
		{
			// Tree listeners
			tfList = new Object();
			tfList.selectedItem  = undefined;
			tfList.selectedIndex = undefined;
			tfList.parent = this;
			tfList._time = getTimer();
			tfList._oldItem = undefined;
			// tree itemRollOver
			tfList.itemRollOver = function( evt ){
				public var item = this.parent.tree.getItemAt(evt.index);
				if( item != undefined )
				{
					var opt:Number   = this.parent.dragRules;
					var opt_1:Number = opt;
					if(opt >= DragAndDropTree.DENYDROPUPSIDEDOWN){
						opt_1 = opt ^ DragAndDropTree.DENYDROPUPSIDEDOWN;
					}
					if( this.parent.__dragFunction != undefined){
						if(!this.parent.__dragFunction( item )){
							this.itemRollOut();
							return;
						}
					} else {
						if( (opt_1 == DENYDRAGFOLDER  || opt_1 == (DENYDRAGFOLDER | DENYDROPITEM) || opt_1 == (DENYDRAGITEM | DENYDRAGFOLDER) || opt == DENYALL) && this.parent.tree.getIsBranch( item ))
						{
							this.itemRollOut();
							return;
						} else if( !this.parent.tree.getIsBranch( item ) && (opt_1 == DENYDRAGITEM || opt == DENYALL || opt_1 == (DENYDRAGITEM | DENYDROPITEM) || opt_1 == (DENYDRAGITEM | DENYDRAGFOLDER)))
						{
							this.itemRollOut();
							return;
						}
					}
					this.selectedItem  = item;
					this.selectedIndex = evt.index;
				} else {
					this.itemRollOut();
				}
			};
			
			// tree itemRollOut
			tfList.itemRollOut = function(evt:Object)
			{
				this.selectedItem  = undefined;
				this.selectedIndex = undefined;
			};
			
			tfList.change = function( evt:Object)
			{
				if( (getTimer() - this._time) < 300)
				{
					if( evt.target.selectedItem == this._oldItem)
					{
						this.parent.dispatchEvent({type:"double_click", target: this.parent.tree});
					}
				}
				this._oldItem = evt.target.selectedItem;
				this._time = getTimer();
			};
			
			// add tree listeners
			tree.addEventListener("change",       tfList);
			tree.addEventListener("itemRollOver", tfList);
			tree.addEventListener("itemRollOut",  tfList);
	
			// controller functions
			controller_mc.tree  = tree;
			controller_mc.item  = undefined;
			controller_mc.index = undefined;
			controller_mc.__canDrop   = false;
			controller_mc.__canDropTarget = false;
			controller_mc.__dropTargetMc = undefined;
			controller_mc.__dropIndex = undefined;
			controller_mc.__targetNode  = undefined;
			controller_mc.__dragStart   = false;
			controller_mc.onMouseDown = function(){
				this.__dragStart = false;
				this.item  = this.parent.tfList.selectedItem;
				this.index = this.parent.tfList.selectedIndex;
				this.added = false;
				this.__targetNode = undefined;
				this.points = new Array( this.mouseX, this.mouseY);
				if( this.item == undefined ){
					return;
				}
				this.onEnterFrame = function(){
					/**
					 * canDrop:
					 * -1 => deny always
					 *  0  => deny if dropIndex == undefined
					 *  1  => allow
					 */
					this.graphics.clear();
					public var canDrop:Number      = -1;
					public var dropIndex:Number    = undefined;
					public var opt:Number          = this.parent.dragRules;
					public var opt_1:Number        = opt;
					this.__canDropTarget    = false;
					this.__dropTargetMc     = undefined				;
					if(opt >= DragAndDropTree.DENYDROPUPSIDEDOWN){
						opt_1 = opt ^ DragAndDropTree.DENYDROPUPSIDEDOWN;
					}
					public var targetLabel:Boolean = false;
					public var default_icon:String;
					public var point:Object = new Object();
					point.x = this.parent.mouseX;
					point.y = this.parent.mouseY;
					this.parent.localToGlobal( point );
					if( !this.added ){
						var x = this.mouseX;
						var y = this.mouseY;
						if(Math.abs( x  - this.points[0] ) > 2 || Math.abs( y - this.points[1] ) > 2 ){
							if( !this.added && this.item != undefined ){
								this.__dragStart = true;
								this.added = true;
								this.parent.createIcon( );
								this.parent.dispatchEvent({type:"drag_start", target:this.tree, sourceNode: this.item});
							}
						}
					} else {
						for(var a = 0; a < this.tree.rows.length; a++)
						{
							if( this.tree.rows[a].item != undefined)
							{
								//if( this.tree.rows[a].hitTest( this.parent.mouseX, this.parent.mouseY, true) )
								if( this.tree.rows[a].hitTest( point.x, point.y, true) )
								{
									var item = this.tree.rows[a];
									this.__targetNode = item;
									if( item.item == this.item ){
										// if the same item, then DENY
										canDrop = 0;
										// If trying to DROP an item inside itself, DENY
									} else if ( this.parent.isSubNode(this.item , item.item ) ){
										canDrop = -1;
									} else {
										if( this.parent.__dropFunction != undefined ){
											canDrop = this.parent.__dropFunction( this.item, this.__targetNode.node );
										} else {
											canDrop = 1;
											// now core functions..
											// check if item can be dropped and where it will be dropped!
											// deny drop into item 3,4,5,6,7
											if( (opt_1 >= (DENYDRAGITEM | DENYDRAGFOLDER) && opt <= DENYALL) && !this.tree.getIsBranch( item.node )){
												if( opt == DENYALL ){
													canDrop = -1;
												} else {
													canDrop = 0;
												}
											}
										}
									}
									if( item.mouseY > ((item.bG_mc.height/2) + item.bG_mc.height/4) && opt < DENYDROPUPSIDEDOWN && (this.parent.tree.mouseY + item.height < this.parent.tree.height))
									{
										this.graphics.beginFill(this.parent.getStyle("separatorColor") ? this.parent.getStyle("separatorColor") : 0x666666,100);
										this.drawRect( 0, item.y + item.bG_mc.height, this.parent.tree.width - (this.parent.tree.vSB.width ? this.parent.tree.vSB.width : 0) - 1, item.y + item.bG_mc.height + 1 );
										this.graphics.endFill();
										// try to retrieve the item index
										if( this.tree.getIsBranch( item.node ) )
										{
											if( this.tree.getIsOpen( item.node ))
											{
												// it's the first element of the branch
												dropIndex = item.rowIndex;
											}
										}
										dropIndex = item.rowIndex;
									}
									break;
								}
							}
						}
						// Now apply permissions to dragging icon
						if( canDrop == 1 )
						{
							targetLabel = true;
							this.__canDrop = true;
						} else if(canDrop == 0)
						{
							if(dropIndex == undefined)
							{
								targetLabel = false;
								this.__canDrop = false;
							} else {
								targetLabel = true;
								this.__canDrop = true;
							}
						} else {
							targetLabel = false;
							this.__canDrop = false;
						}
						this.__dropIndex = dropIndex;
						default_icon = this.parent._iconFunction( targetLabel );
						
						// dropTarget
						if(this.parent.dropTarget != undefined){
							for(var a in this.parent.dropTarget){
								if(this.parent.dropTarget[a].hitTest(point.x, point.y, true))
								{
									targetLabel = true;
									this.__canDropTarget = true;
									this.__dropTargetMc = this.parent.dropTarget[a];
									break;
								}
							}
						}
						
						if( default_icon == undefined )
						{
							default_icon = targetLabel ? "icon_allow_drag" : "icon_deny_drag";
						}					
						if( this.parent.icon[default_icon].name != default_icon || this.parent.icon[default_icon] == undefined)
						{
							this.parent.icon.attachMovie( default_icon, default_icon , 1 );
						}
					}
					
					public var _mouseP = new Object();
					_mouseP.x = this.parent.mouseX;
					_mouseP.y = this.parent.mouseY;
					//this.parent.globalToLocal( _mouseP )
					this.parent.icon.x = _mouseP.x + 5;
					this.parent.icon.y = _mouseP.y + 15;
				};
				this.onEnterFrame();
			};
			
			/**
			* mouse up, drag and drop end
			*/
			controller_mc.onMouseUp = function(){
				delete this.onEnterFrame;
				if( this.__dragStart != true ){
					return;
				}
				if( this.__canDrop == true )
				{
					public var node = this.tree.getItemAt(this.index);
					public var cloned = node.cloneNode(true);
					if( this.__dropIndex != undefined )
					{
						if( this.tree.getIsBranch( this.__targetNode.item ) && this.tree.getIsOpen( this.__targetNode.item ))
						{
							node.removeNode();
							this.__targetNode.item.addTreeNodeAt(0, cloned );
						} else {
							if(this.__targetNode.item.nextSibling == null)
							{
								if(this.__targetNode.item == node)
								{
									if(this.__targetNode.item.parentNode.nextSibling != null)
									{
										this.__targetNode.item.parentNode.parentNode.insertBefore(cloned, this.__targetNode.item.parentNode.nextSibling);
									}
								} else {
									this.__targetNode.item.parentNode.addTreeNode( cloned );
								}
								node.removeNode();
							} else {
								if( node != this.__targetNode.item && node != this.__targetNode.item.nextSibling )	// fix by TAKATAMA, Hirokazu
								{
									node.removeNode();
									this.__targetNode.item.parentNode.insertBefore( cloned, this.__targetNode.item.nextSibling );
									this.tree.refresh();
								}
							}
						}
					} else {
						node.removeNode();
						this.__targetNode.item.addTreeNode( cloned );
					}
					this.parent.dispatchEvent({type:"drag_complete", target: this.tree, sourceNode: node, targetNode: this.__targetNode.item});
					this.tree.dataProvider = this.tree.getDataProvider();
				} else {
					this.parent.dispatchEvent({type:"drag_fail", target: this.tree, sourceNode: node, targetNode: this.__targetNode.item});
				}
				if(this.__canDropTarget == true){
					public var node = this.tree.getItemAt(this.index);
					this.parent.dispatchEvent({type:"drag_target", target: this.tree, sourceNode: node, targetMc: this.__dropTargetMc});
				}			
				this.graphics.clear();
				this.__canDrop   = false;
				this.__dropIndex = undefined;
				this.parent.removeIcon();
				this.points = new Array();
				this.item   = undefined;
				this.index  = undefined;
				this.added  = false;
			};
		}
		
	
		/**
		 * Internal, remove the dragging mouse icon
		 * @usage	
		 * @return	void	
		 */
		protected function removeIcon():void
		{
			icon.removeMovieClip();
		}
		
	
		/**
		 * internal, create the dragging icon attaching from library
		 * @usage	
		 * @return	MovieClip	
		 */
		protected function createIcon():MovieClip
		{
			return createEmptyObject( "icon", ICONDEPTH );
		}
		
	
		/**
		 * Verify that targetNode is a subnode of dragNode
		 * @usage	DragAndDropTree.isSubNode( sourceNode, targetNode )
		 * @param	dragNode	(XMLNode)
		 * @param	targetNode	(XMLNode)
		 * @return	Boolean	
		 */
		protected function isSubNode( dragNode:XMLNode, targetNode:XMLNode):Boolean
		{
			var ret:Boolean = false;
			while( targetNode.parentNode != undefined)
			{
				if(targetNode == dragNode)
				{
					ret = true;
					break;
				}
				targetNode = targetNode.parentNode;
			}
			return ret;
		}
		
		
		// ******************************************
		// Getter / Setter
		// ******************************************
		
		/**
		 * Set the Tree Drag and Drop rules
		 * @usage	DragAndDropTree.dragRules = DragAndDropTree.DENYDRAGITEM | DragAndDropTree.DENYDROPITEM
		 * @param	value	(Number)
		 * @return	void
		 */	
		[Inspectable(defaultValue=0,type=Number)]
		public function set dragRules(value:Number)
		{
			if(value >= 0 && value <= DENYALL && value != undefined)
			{
				__options = value;
			} else {
				throw new Error("IndexError: value must be an integer between " + DEFAULT + " and " + DENYALL);
			}
			/**
			0 DEFAULT -> Allow everything
			1 DENYDRAGFOLDER -> DENY drag folders
			2 DENYDRAGITEM   -> DENY drag items
			4 DENYDROPITEM   -> DENY drop into items
			5 DENYDRAGFOLDER | DENYDROPITEM -> Deny Drag folder & deny drop on items
			6 DENYDRAGITEM | DENYDROPITEM   -> Deny drag item & deny drop item
			7 DENYALL -> Deny All
			3 DENYDRAGITEM | DENYDRAGFOLDER -> Deny All
			8 DENYDROPUPSIDEDOWN -> deny lines
			*/
		}
		
		/**
		 * return the current drag rules
		 * @usage	
		 * @return	Number	
		 */
		public function get dragRules():Number
		{
			return __options;
		}
		
		// set icon function for display allow/deny dragging icon
		public function set iconFunction(func:Function)
		{
			_iconFunction = func;
		}
		
		public function get iconFunction():Function
		{
			return _iconFunction;
		}
		
		// ******************************************
		// Tree public functions
		// ******************************************
		
		/**
		 * Return a pointer to the current used Tree component
		 * @usage	
		 * @return	mx.controls.Tree the tree component used
		 */
		public function getTree():mx.controls.Tree
		{
			return this.tree;
		}
		
		public function set dropTarget(mc:Array):void
		{
			this.__dropTarget = mc;
		}
		
		public function get dropTarget():Array
		{
			return this.__dropTarget;
		}
	
		[Inspectable(defaultValue=20,type=Number)]
		public function set rowHeight(w:Number)
		{
			__rowHeight = w;
			this.tree.rowHeight = w;
		}
		
		public function get rowHeight():Number
		{
			return __rowHeight;
		}
		
		/**
		* set a user defined drop function,
		* this function must return a boolean
		* @usage <code>
		* myDndTree.dropFunction = function(sourceNode:XMLNode, targetNode:XMLNode){
			// in this way you can define a custom dragRule
		* 	return sourceNode.attributes.name != targetNode.attributes.value
		* }
		* </code>
		*/
		public function set dropFunction(fn:Function){
			__dropFunction = fn;
		}
		
		/**
		* user defined drag function, which decide if item
		* can be dragged
		* @usage <code>
		* myDndTree.dragFunction = function(item:XMLNode){
		* 	return item.attributes.myattribue == 'some value'
		* }
		* </code>
		*/
		public function set dragFunction(fn:Function){
			__dragFunction = fn;
		}
		
	}
}