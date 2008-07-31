package com.troyworks.controls.menu {
	import com.troyworks.data.iterators.NullIterator;	
	import com.troyworks.data.iterators.IIterator;	
	
	/**
	 * @author Troy Gardner
	 */
	public class MenuDataEntry extends MenuSystemItem {
		public function MenuDataEntry() {
			super();
			//trace("MenuDataEntry href " + href);
		}
		override public function iterator():IIterator {
			return new NullIterator();
		}
	}
	
}
