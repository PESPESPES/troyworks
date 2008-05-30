package com.troyworks.apps.mnemosyne {

	public class Category {
		public var name : String = null;
		public var active : Boolean = true;

		//-------------------------------------------------------------------------------
		public function Category(name : String, active : Boolean = true) {
			this.name = name;
			this.active = active;
		}
	}
}