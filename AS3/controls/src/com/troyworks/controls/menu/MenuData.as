﻿package com.troyworks.controls.menu {
	import com.troyworks.data.iterators.IIterator;	
	import com.troyworks.data.iterators.ArrayIterator;
	import com.troyworks.data.ArrayX;

	/**
	 * @author Troy Gardner
	 */
	public class MenuData extends MenuSystemItem {
		public var items : ArrayX;

		public function MenuData() {
			super();
		//	trace("MenuData href " + href);
			items = new ArrayX();
		}

		override public function addItem(item : IMenuDataItem) : void {
			item.setMenuDepth(this.getMenuDepth() +1);
			items.push(item);
		}

		override public function removeItem(item : IMenuDataItem) : void {
			var i : uint;
			for(i = 0;i < items.length; i++) {
				if(items[i] == item) {
					items.splice(i, 1);
					break;
				}
			}
		}

		override public function iterator() : IIterator {
			trace("returning iterator for " + items.length);
			return new ArrayIterator(items);
		}
		override public function toString():String{
			var sp:Array = new Array();
			var l:int = getMenuDepth();
			while(l--){
				sp.push(" ");
			}
			var spc:String = sp.join(''); 
			var res:Array = new Array();
			res.push(spc +getName() );
			for(var i:int = 0; i < items.length; i++){
				res.push(spc + "+- " + items[i].toString());
			}
			return res.join('\r');
		}
	}
}
