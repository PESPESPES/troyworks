package com.troyworks.ui.controls.dataproviders { 
	/*
	Date: Fri, 21 Jan 2005 00:35:14 +0100
	To: judah <judah@drumbeatinsight.com>
	From: EECOLOR <eecolor@zonnet.nl>
	
	Syntax:
	import contextMenuManager;
	
	//customItems_array is an array filled with 'new CustomMenuItems()'
	contextMenuManager.registerMovieClip(mc:MovieClip, customItems_array:Array):void
	
	//remove the contextMenu from a movieclip
	contextMenuManager.unregisterMovieClip(mc);
	
	One tip, if u want to use the class with a datagrid, tree, 
	combobox or something like that, just use the component itself as a target 
	and use the selected index to check which item is meant to recieve the right 
	click. This will keep the contextMenuManager from having to loop over too 
	many items :)
	*/
	
	import mx.utils.Delegate;
	
	import flash.ui.ContextMenu;
	import flash.display.MovieClip;
	public class ContextMenuManager {
		
		static protected var _registered_obj:Object = new Object();
		static protected var _inited_bool = false;
		static public var hideRootBuiltInItems = false;
		static public var _builtInItems:Object;
		
		// this function is called when a new context contextMenu is made when we first register our movieclip
		static protected function _menuRequested(mc:MovieClip, cm:ContextMenu) : void{
			var x_num = _root.mouseX;
			var y_num = _root.mouseY;
			
			var customItems_array:Array;
			
			// loop through movieclips that use context contextMenu manager
			for (var i in _registered_obj) {
				
				// get reference to object that contains our registered movieclip
				var obj:Object = _registered_obj[i];
				var clip_mc:MovieClip = obj.mc;
				
				// check if mouse is over our movieclip
				if (clip_mc.hitTest(x_num, y_num, true)) {
					//trace ("inside... "+clip_mc);
					// get reference to registered movieclip context contextMenu items
					customItems_array = obj.customItems;
					//trace(" customItems_array.owner = "+ customItems_array.owner)
					// call context contextMenu pre select method
					clip_mc.onContextMenuPreSelect();
					break;
					//trace ("onSelect clip_mc.lastOver..." + clip_mc.lastOver);
					/*
					// we get the indexes because we cannot select by items apparently
					var item  = clip_mc.getItemAt(clip_mc.lastOver);
					var items = clip_mc.selectedItems;
					var itemIndex  = clip_mc.lastOver;
					var itemIndices = clip_mc.selectedIndices;
					var len = clip_mc.selectedIndices.length;
					
					// checking if the user has selected multiple items
					if (clip_mc.multipleSelection && len > 1) {
						// creating an new array and then adding the new item
						// is the only way that seems to work for adding a new item to the selectedItems array
						var myArray = new Array();
						for (var i=0;i<itemIndices.length;i++) 
						{
							var theItem = itemIndices[i];					
							myArray.push(itemIndices[i]);
						}
						//clip_mc.selectedItems = myArray;
						clip_mc.selectedIndices = myArray;
						//trace(" 1 clip_mc.selectedIndices = "+clip_mc.selectedIndices)
						//trace(" 1 clip_mc.selectedIndices.len = "+len)
					}
					else 
					{
						//clip_mc.selectedItem = item;
						//trace(" 2 clip_mc.selectedIndex = "+clip_mc.lastOver)
					}
					
					//----------
					
					//clip_mc.selectedItem  = clip_mc.getItemAt(clip_mc.lastOver);
					//trace ("#3 clip_mc.selectedItem.label =" + clip_mc.selectedItem.label + ":" + clip_mc.lastOver);
					//trace ("#3 clip_mc.selectedIndex =" + clip_mc.selectedIndex + ":" + clip_mc.lastOver);
					*/
				};
			};
			
			// if custom items were found assign them to the (_root) context contextMenu
			if (customItems_array) {
				cm.customItems = customItems_array;
				cm.hideBuiltInItems();
			}
			else {
				cm.customItems = undefined;
				if (!hideRootBuiltInItems) {
					showBuiltInItems(cm);
				};
			};
		};
		
		static public function showBuiltInItems(cm:ContextMenu): void {
			cm.builtInItems.zoom = true;
			cm.builtInItems.quality = true;
			cm.builtInItems.play = true;
			cm.builtInItems.loop = true;
			cm.builtInItems.rewind = true;
			cm.builtInItems.forward_back = true;
			cm.builtInItems.print = true;
		}
		
		/*
		Makes the context contextMenu show up for nested movieclips or components
		@description Makes the context contextMenu show up for nested movieclips or components
		@param MovieClip - movie clip on the root
		@param MovieClip - movieclip or component that has a context contextMenu 
		@param CustomItems - custom items array
		*/
		static public function registerMovieClip(mc:MovieClip, dndListInstance:Object, contextMenuItems_array:Array):void {
			//trace('registering movieclip;')
			// create new context contextMenu 
			public var contextMenu:ContextMenu = new ContextMenu(ContextMenuManager._menuRequested);
			//contextMenu.hideBuiltInItems();
			
			// mc is a movieclip whose parent is the _root
			// we assign a new contextMenu to it
			mc.contextMenu = contextMenu;
			
			// add reference to owner in each contextMenu item
			for(public var i=0;i<contextMenuItems_array.length;i++) {
				contextMenuItems_array[i].owner = dndListInstance;
			}
			
			// create reference to this in the onContextMenuPreSelect
			//mc.$dndDataGridPath = dndListInstance;
			mc['$'+dndListInstance.className+'Path'] = dndListInstance;
			//_global.$dndDataGridPath = dndListInstance;
			
			_registered_obj[String(mc)+dndListInstance.name] = new Object();
			var regObject = _registered_obj[String(mc)+dndListInstance.name];
			regObject.mc = dndListInstance;
			regObject.customItems = contextMenuItems_array;
			regObject.customItems['owner'] = dndListInstance;
			
		};
		
		static public function unregisterMovieClip(mc:MovieClip, dndListInstance:Object):void {
			//delete _registered_obj[String(mc)];
			delete _registered_obj[String(mc)+dndListInstance.name];
		};
	};
}